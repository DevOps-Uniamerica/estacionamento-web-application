package br.com.uniamerica.estacionamento.controller;
import br.com.uniamerica.estacionamento.Repository.ModeloRepository;
import br.com.uniamerica.estacionamento.entity.Condutor;
import br.com.uniamerica.estacionamento.entity.Modelo;
import br.com.uniamerica.estacionamento.servece.ModeloService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping(value = "/api/modelo")
public class ModeloController {

    @Autowired
    private ModeloService modeloService;

    @GetMapping("/{id}")
    public ResponseEntity<?> findByIdPath(@PathVariable("id") final Long id){
        final Modelo modelo = this.modeloService.findById(id);

        return ResponseEntity.ok(modeloService);
    }

    @GetMapping("/lista")
    public ResponseEntity<List<Modelo>> findAll() {
        List<Modelo> modelos = this.modeloService.findAll();
        return ResponseEntity.ok(modelos);
    }

    @GetMapping("/ativos")
    public ResponseEntity<List<Modelo>> buscarAtivos() {
        List<Modelo> modelos = this.modeloService.findByAtivo();
        return ResponseEntity.ok(modelos);
    }

    @PostMapping
    public ResponseEntity<?> cadastrar(@RequestParam final Modelo modelo){
        try{
            this.modeloService.cadastrar(modelo);
            return ResponseEntity.ok("Registro cadastrado com sucesso");
        }
        catch (DataIntegrityViolationException e){
            return ResponseEntity.internalServerError().body("Error" + e.getCause().getCause().getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> edicao(@PathVariable("id") final Long id, @RequestBody final Modelo modelo){
        try{
            final Modelo modeloBanco = this.modeloService.findById(id);

            if(modeloBanco == null || !modeloBanco.getId().equals(modelo.getId()))
            {
                throw new RuntimeException("Não foi possível identificar o registro informado");
            }

            this.modeloService.edicao(modelo);
            return ResponseEntity.ok("Registro editado com sucesso");
        }
        catch (DataIntegrityViolationException e){
            return ResponseEntity.internalServerError().body("Error " + e.getCause().getCause().getMessage());
        }
        catch (RuntimeException e){
            return ResponseEntity.internalServerError().body("Error " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable final Long id) {
        try {
            this.condutorService.delete(id);
            return ResponseEntity.ok("Condutor excluído com sucesso");
        }catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (DataIntegrityViolationException e){
            return ResponseEntity.internalServerError().body("Error " + e.getCause().getCause().getMessage());
        } catch (RuntimeException e){
            return ResponseEntity.internalServerError().body("Error " + e.getMessage());
        }
    }}
}
