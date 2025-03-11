<template>
    <div class="container-fluid p-4">
        <div class="row mb-4">
            <div class="col-md-10 text-start">
                <p class="fs-4 fw-semibold">Movimentacaao</p>
            </div>
            <div class="col-md-2 align-self-center">
                <div class="d-grid gap-2">
                    <router-link type="button" class="btn btn-primary"
                        to="/movimentacoes/formulario">Cadastrar</router-link>
                </div>
            </div>
        </div>
        <div v-if="List.length == 0" class="alert alert-secondary" role="alert">
            Nenhuma Movimentacao encontrada
        </div>
        <div v-else>
            <table class="table table-striped table-hover rounded-3 shadow-sm">
                <thead class="table-light sticky-top shadow">
                    <tr>
                        <th class="text-center">ID</th>
                        <th class="text-center">Placa</th>
                        <th class="text-center">Condutor</th>
                        <th class="text-center">Data Entrada</th>
                        <th class="text-center">Data Saída</th>
                        <th class="text-center">Status</th>
                        <th class="text-center">Opções</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="item in List" :key="item.id">
                        <th class="align-middle text-center col-md-1">{{ item.id }}</th>
                        <th class="align-middle col-md-2 text-center">{{ item.veiculo.placa }} <span
                                v-if="!item.veiculo.ativo" class="badge text-bg-danger">Desativado</span>
                        </th>
                        <th class="align-middle col-md-2 text-center">{{ item.condutor.nome }} <span
                                v-if="!item.condutor.ativo" class="badge text-bg-danger">Desativado</span>
                        </th>
                        <th class="align-middle col-md-2 text-center">
                            {{ formatDate(item.dataEntrada) }}
                        </th>
                        <th class="align-middle text-center col-md-2">
                            {{ formatDate(item.dataSaida) }}
                        </th>
                        <th class="align-middle text-center col-md-1">
                            <span v-if="item.ativo && item.dataSaida == null" class="badge text-bg-success">
                                Ativo
                            </span>
                            <span v-if="item.ativo && item.dataSaida != null" class="badge text-bg-success">
                                Concluído
                            </span>
                            <span v-if="!item.ativo" class="badge text-bg-danger">
                                Cancelado
                            </span>
                        </th>
                        <th class="align-middle text-center col-md-2">
                            <BotoesAcoes listarRoute="movimentacoes.listar" editarRoute="movimentacoes.form.editar"
                                toggleRoute="movimentacoes.form.toggle" :isAtivo="item.ativo" :id="item.id">
                            </BotoesAcoes>
                        </th>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue'
import { Movimentacao } from '@/model/Movimentacao'
import { MovimentacaoClient } from '@/service/Movimentacao.client'
import BotoesAcoes from '@/components/BotoesAcoes.vue';

export default defineComponent({
    name: 'VeiculosView',
    data() {
        return {
            List: new Array<Movimentacao>()
        }
    },
    mounted() {
        this.findAll()
    },
    components: {
        BotoesAcoes
    },
    methods: {
        findAll() {
            const client = new MovimentacaoClient()
            client
                .findAll()
                .then(sucess => {
                    this.List = sucess
                })
                .catch(error => {
                    console.log("Error!!")
                })
        },
        formatDate(dateString: string | number | Date) {
            if (dateString != null) {
                const dateTime = new Date(dateString)
                const formattedDate = dateTime.toLocaleDateString()
                const formattedTime = dateTime.toLocaleTimeString([], {
                    hour: '2-digit',
                    minute: '2-digit'
                })
                return `${formattedDate} ${formattedTime}`
            } else {
                return '---'
            }
        }
    }
})
</script>

<style scoped>
.container-fluid {
    background-color: #f7f7f8;
    border-radius: 10px;
    padding: 2rem;
}

.btn-primary {
    background-color: #0078d4;
    border: none;
    border-radius: 5px;
    font-weight: 500;
    transition: all 0.3s ease-in-out;
}

.btn-primary:hover {
    background-color: #005a9e;
}
</style>
