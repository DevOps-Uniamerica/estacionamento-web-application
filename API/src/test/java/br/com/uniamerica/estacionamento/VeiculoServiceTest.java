package br.com.uniamerica.estacionamento;

import br.com.uniamerica.estacionamento.entity.Modelo;
import br.com.uniamerica.estacionamento.entity.Movimentacao;
import br.com.uniamerica.estacionamento.entity.Veiculo;
import br.com.uniamerica.estacionamento.repository.ModeloRepository;
import br.com.uniamerica.estacionamento.repository.MovimentacaoRepository;
import br.com.uniamerica.estacionamento.repository.VeiculoRepository;
import br.com.uniamerica.estacionamento.service.VeiculoService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;
import org.springframework.util.Assert;

import java.util.Collections;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
 class VeiculoServiceTest {

    @InjectMocks
    private VeiculoService veiculoService;

    @Mock
    private VeiculoRepository veiculoRepository;

    @Mock
    private ModeloRepository modeloRepository;

    @Mock
    private MovimentacaoRepository movimentacaoRepository;

    private Veiculo veiculo;
    private Modelo modelo;

    @BeforeEach
    void setup() {
        modelo = new Modelo();
        modelo.setId(1L);
        modelo.setNome("Modelo Teste");
        modelo.setAtivo(true);

        veiculo = new Veiculo();
        veiculo.setId(1L);
        veiculo.setPlaca("ABC1234");
        veiculo.setModelo(modelo);
    }

    @Test
    void deveCadastrarVeiculoComSucesso() {
        when(veiculoRepository.findByPlaca(veiculo.getPlaca())).thenReturn(Collections.emptyList());
        when(modeloRepository.findById(veiculo.getModelo().getId())).thenReturn(Optional.of(modelo));
        when(veiculoRepository.save(veiculo)).thenReturn(veiculo);

        Veiculo veiculoCadastrado = veiculoService.cadastrar(veiculo);

        assertNotNull(veiculoCadastrado);
        assertEquals(veiculo.getPlaca(), veiculoCadastrado.getPlaca());
        verify(veiculoRepository, times(1)).save(veiculo);
    }

    @Test
    void naoDeveCadastrarVeiculoComPlacaExistente() {
        when(veiculoRepository.findByPlaca(veiculo.getPlaca())).thenReturn(Collections.singletonList(veiculo));

        Exception exception = assertThrows(IllegalArgumentException.class, () -> veiculoService.cadastrar(veiculo));
        assertTrue(exception.getMessage().contains("Veiculo com placa"));
    }


    @Test
    void deveDesativarVeiculoRelacionadoAMovimentacao() {
        when(veiculoRepository.findById(veiculo.getId())).thenReturn(Optional.of(veiculo));
        when(movimentacaoRepository.findByVeiculoId(veiculo.getId())).thenReturn(Collections.<Movimentacao>singletonList(new Movimentacao()));

        ResponseEntity<?> response = veiculoService.desativar(veiculo.getId());
        assertTrue(response.getBody().toString().contains("DESATIVADO"));
        verify(veiculoRepository, times(1)).save(veiculo);
    }

    @Test
    void deveDeletarVeiculoSemMovimentacao() {
        when(veiculoRepository.findById(veiculo.getId())).thenReturn(Optional.of(veiculo));
        when(movimentacaoRepository.findByVeiculoId(veiculo.getId())).thenReturn(Collections.emptyList());

        ResponseEntity<?> response = veiculoService.desativar(veiculo.getId());
        assertTrue(response.getBody().toString().contains("DELETADO"));
        verify(veiculoRepository, times(1)).delete(veiculo);
    }
}
