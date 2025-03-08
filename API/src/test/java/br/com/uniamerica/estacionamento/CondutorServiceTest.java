package br.com.uniamerica.estacionamento;

import br.com.uniamerica.estacionamento.entity.Condutor;
import br.com.uniamerica.estacionamento.entity.Movimentacao;
import br.com.uniamerica.estacionamento.repository.CondutorRepository;
import br.com.uniamerica.estacionamento.repository.MovimentacaoRepository;
import br.com.uniamerica.estacionamento.service.CondutorService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;
import org.springframework.util.Assert;

import java.util.Collections;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CondutorServiceTest {

    @Mock
    private CondutorRepository condutorRepository;

    @Mock
    private MovimentacaoRepository movimentacaoRepository;

    @InjectMocks
    private CondutorService condutorService;

    private Condutor condutor;

    @BeforeEach
    void setUp() {
        condutor = new Condutor();
        condutor.setId(1L);
        condutor.setNome("João Silva");
        condutor.setCpf("123.456.789-00");
        condutor.setTelefone("(11) 99999-9999");
        condutor.setTempoPagoSegundos(3600L);
        condutor.setTempoDescontoSegundos(1800L);
        condutor.setTempoDescontoUsadoSegundos(600L);
    }



    @Test
    void testCadastrar_CondutorJaExiste() {
        when(condutorRepository.findByCpf(condutor.getCpf())).thenReturn(Collections.singletonList(condutor));

        Exception exception = assertThrows(IllegalArgumentException.class, () -> condutorService.cadastrar(condutor));
        assertEquals("Condutor com CPF [ 123.456.789-00 ] já existe!", exception.getMessage());
    }

    @Test
    void testEditar_CondutorNaoExiste() {
        when(condutorRepository.findById(1L)).thenReturn(Optional.empty());

        Exception exception = assertThrows(IllegalArgumentException.class, () -> condutorService.editar(1L, condutor));
        assertEquals("Condutor não existe!", exception.getMessage());
    }

    @Test
    void testRelatorioPerfil_Sucesso() {
        when(condutorRepository.findById(1L)).thenReturn(Optional.of(condutor));

        ResponseEntity<?> response = condutorService.relatorioPerfil(1L);
        assertNotNull(response);
        assertTrue(response.getBody().toString().contains("Nome: João Silva"));
    }

    @Test
    void testRelatorioPerfil_CondutorNaoExiste() {
        when(condutorRepository.findById(1L)).thenReturn(Optional.empty());

        Exception exception = assertThrows(IllegalArgumentException.class, () -> condutorService.relatorioPerfil(1L));
        assertEquals("Condutor não existe!", exception.getMessage());
    }

    @Test
    void testDesativar_CondutorSemMovimentacao() {
        when(condutorRepository.findById(1L)).thenReturn(Optional.of(condutor));
        when(movimentacaoRepository.findByCondutorId(1L)).thenReturn(Collections.emptyList());

        ResponseEntity<?> response = condutorService.desativar(1L);
        assertNotNull(response);
        assertTrue(response.getBody().toString().contains("DELETADO com sucesso"));
    }


}
