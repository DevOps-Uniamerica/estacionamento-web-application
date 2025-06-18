#!/bin/bash

# Script de diagnóstico para problemas do backend Spring Boot no Kubernetes
# Execute com: chmod +x debug-backend.sh && ./debug-backend.sh

NAMESPACE="estacionamento"
echo "🔍 Diagnóstico do Backend - Namespace: $NAMESPACE"
echo "=================================================="

# 1. Verificar status dos pods
echo "📊 1. Status dos Pods:"
kubectl get pods -n $NAMESPACE -l app=backend -o wide

echo ""
echo "📊 2. Detalhes dos Pods:"
kubectl describe pods -n $NAMESPACE -l app=backend

echo ""
echo "📋 3. Logs dos Pods do Backend (últimas 100 linhas):"
for pod in $(kubectl get pods -n $NAMESPACE -l app=backend -o jsonpath='{.items[*].metadata.name}'); do
    echo "--- Logs do pod: $pod ---"
    kubectl logs -n $NAMESPACE $pod --tail=100
    echo ""
done

echo ""
echo "📋 4. Logs dos Init Containers:"
for pod in $(kubectl get pods -n $NAMESPACE -l app=backend -o jsonpath='{.items[*].metadata.name}'); do
    echo "--- Init container logs do pod: $pod ---"
    kubectl logs -n $NAMESPACE $pod -c wait-for-postgres --tail=50 2>/dev/null || echo "Sem init container ou logs não disponíveis"
    echo ""
done

echo ""
echo "🌐 5. Testando conectividade de rede:"
echo "5.1 PostgreSQL:"
kubectl run debug-postgres --image=postgres:15-alpine --rm -i --restart=Never -n $NAMESPACE \
  --env="PGPASSWORD=postgres" -- \
  psql -h postgres-service -U postgres -d estacionamento -c "SELECT 'PostgreSQL OK' as status, version();" 2>/dev/null || echo "❌ PostgreSQL: FAIL"

echo ""
echo "5.2 Backend Health Check:"
kubectl run debug-backend --image=curlimages/curl --rm -i --restart=Never -n $NAMESPACE -- \
  curl -v -m 10 http://backend-service:8080/actuator/health 2>/dev/null || echo "❌ Backend Health: FAIL"

echo ""
echo "5.3 Backend Direto (dentro do pod):"
BACKEND_POD=$(kubectl get pods -n $NAMESPACE -l app=backend -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
if [ ! -z "$BACKEND_POD" ]; then
    echo "Testando dentro do pod: $BACKEND_POD"
    kubectl exec -n $NAMESPACE $BACKEND_POD -- curl -f -m 5 http://localhost:8080/actuator/health 2>/dev/null || echo "❌ Backend Local: FAIL"
    
    echo ""
    echo "5.4 Verificando processos Java no pod:"
    kubectl exec -n $NAMESPACE $BACKEND_POD -- ps aux | grep java || echo "❌ Processo Java não encontrado"
    
    echo ""
    echo "5.5 Verificando portas abertas:"
    kubectl exec -n $NAMESPACE $BACKEND_POD -- netstat -tlnp 2>/dev/null || echo "netstat não disponível"
else
    echo "❌ Nenhum pod do backend encontrado"
fi

echo ""
echo "🔧 6. Recursos e Limites:"
kubectl top pods -n $NAMESPACE -l app=backend 2>/dev/null || echo "Metrics não disponíveis"

echo ""
echo "⚠️  7. Eventos recentes:"
kubectl get events -n $NAMESPACE --sort-by='.lastTimestamp' | grep backend | tail -10

echo ""
echo "🔄 8. Status do Deployment:"
kubectl get deployment backend-deployment -n $NAMESPACE -o yaml | grep -A 20 "status:"

echo ""
echo "💡 SOLUÇÕES SUGERIDAS:"
echo "========================"
echo "1. ❌ Se o backend não está iniciando:"
echo "   kubectl delete deployment backend-deployment -n $NAMESPACE"
echo "   # Depois execute o deploy corrigido"
echo ""
echo "2. 🔄 Se está com crash loop:"
echo "   kubectl patch deployment backend-deployment -n $NAMESPACE -p '{\"spec\":{\"template\":{\"spec\":{\"containers\":[{\"name\":\"backend\",\"env\":[{\"name\":\"JAVA_OPTS\",\"value\":\"-Xmx512m -Xms256m -XX:+UseG1GC\"}]}]}}}}'"
echo ""
echo "3. 🩺 Para ver logs em tempo real:"
echo "   kubectl logs -f deployment/backend-deployment -n $NAMESPACE"
echo ""
echo "4. 🧪 Para testar conectividade manual:"
echo "   kubectl run -it --rm debug --image=curlimages/curl --restart=Never -n $NAMESPACE -- sh"
echo "   # Dentro do container: curl http://backend-service:8080/actuator/health"
echo ""
echo "5. 🚀 Para aplicar o deploy corrigido:"
echo "   # Use o arquivo deploy-k8s-fixed.yml fornecido"
echo ""

# Verific