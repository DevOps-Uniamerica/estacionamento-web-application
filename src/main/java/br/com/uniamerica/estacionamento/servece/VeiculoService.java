package br.com.uniamerica.estacionamento.servece;

import br.com.uniamerica.estacionamento.Repository.ModeloRepository;
import br.com.uniamerica.estacionamento.Repository.MovimentacaoRepository;
import br.com.uniamerica.estacionamento.Repository.VeiculoRepository;
import br.com.uniamerica.estacionamento.entity.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.Year;
import java.util.Arrays;
import java.util.Optional;

@Service
public class VeiculoService {

    @Autowired
    private VeiculoRepository veiculoRepository;
    @Autowired
    private ModeloRepository modeloRepository;
    @Autowired
    private MovimentacaoRepository movimentacaoRepository;


    @Transactional
    public Veiculo cadastrar (Veiculo veiculo){

        Optional<Modelo> modeloBanco = this.modeloRepository.findById(veiculo.getModeloId().getId());
        Optional<Veiculo> veiculoPlacaBanco = this.veiculoRepository.findByPlaca(veiculo.getPlaca());
        int ano = veiculo.getAno();
        String anoEmString = Integer.toString(ano);

        if (veiculoPlacaBanco.isPresent()){
            throw new IllegalArgumentException("Existe outro veiculo com essa placa");
        }else if (veiculo.getPlaca() == null || !veiculo.getPlaca().matches("[A-Z]{3}[0-9][A-Z][0-9]{2}")){
            throw new IllegalArgumentException("A placa deve estar no formato AAA0A00");
        }
        if (anoEmString == null || !anoEmString.matches("[0-9]{4}") || ano < 1900 || ano > Year.now().getValue()){
            throw new IllegalArgumentException("Ano inválido / deve ser maior que o ano de 1900 e menor ou igual que 2023");
        }
        if (veiculo.getCor() == null || !Arrays.asList(Cor.values()).contains(veiculo.getCor())){
            throw new IllegalArgumentException("A cor deve ser um valor válido (AZUL|PRETO|CINZA|MARRON|VERMELHO|PRATA|BRANCO|AMARELO|VERDE)");
        }
        if (veiculo.getTipo() == null || !Arrays.asList(Tipo.values()).contains(veiculo.getTipo())){
            throw new IllegalArgumentException("O tipo deve ser um valor válido (CARRO|VAN|MOTO)");
        }
        if (modeloBanco.isEmpty()){
            throw new IllegalArgumentException("Modelo inválido");
        }

        Modelo modelo = modeloRepository.findById(veiculo.getModeloId().getId()).orElse(null);
        modelo.setAtivo(true);
        modeloRepository.save(modelo);

        return this.veiculoRepository.save(veiculo);
    }

    @Transactional
    public Veiculo editar (Veiculo veiculo){

        Optional<Modelo> modeloBanco = this.modeloRepository.findById(veiculo.getModeloId().getId());
        Optional<Veiculo> veiculoPlacaBanco = this.veiculoRepository.findByPlaca(veiculo.getPlaca());
        int ano = veiculo.getAno();
        String anoEmString = Integer.toString(ano);

        Optional<Veiculo> placaJaCadastrada = this.veiculoRepository.findByPlaca(veiculo.getPlaca());

        if (veiculoPlacaBanco.isPresent() && !placaJaCadastrada.get().getId().equals(veiculo.getId())){
            throw new IllegalArgumentException("Existe outro veiculo com essa placa");
        }else if (veiculo.getPlaca() == null || !veiculo.getPlaca().matches("[A-Z]{3}[0-9][A-Z][0-9]{2}")){
            throw new IllegalArgumentException("A placa deve estar no formato AAA0A00");
        }
        if (anoEmString == null || !anoEmString.matches("[0-9]{4}") || ano < 1900 || ano > Year.now().getValue()){
            throw new IllegalArgumentException("Ano inválido / deve ser maior que o ano de 1900 e menor ou igual que 2023");
        }
        if (veiculo.getCor() == null || !Arrays.asList(Cor.values()).contains(veiculo.getCor())){
            throw new IllegalArgumentException("A cor deve ser um valor válido (AZUL|PRETO|CINZA|MARRON|VERMELHO|PRATA|BRANCO|AMARELO|VERDE)");
        }
        if (veiculo.getTipo() == null || !Arrays.asList(Tipo.values()).contains(veiculo.getTipo())){
            throw new IllegalArgumentException("O tipo deve ser um valor válido (CARRO|VAN|MOTO)");
        }
        if (modeloBanco.isEmpty()){
            throw new IllegalArgumentException("Modelo inválido");
        }

        return this.veiculoRepository.save(veiculo);
    }
    public void delete(Long id) {
        final Veiculo verificacao = this.veiculoRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Não foi possível identificar o registro informado"));

        if (verificacao.isAtivo()){
            throw new IllegalArgumentException("O Veiculo está presente em alguma movimentação e não pode ser excluído.");
        }else {
            this.veiculoRepository.delete(verificacao);
        }
    }

}
