package br.com.uniamerica.estacionamento.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
@MappedSuperclass
public abstract class AbstractEntity {
    @Getter
    @Column(name = "id", nullable = false, unique = true)
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    @Getter @Setter
    @Column(name = "dtCadastro", nullable = false)
    private LocalDateTime cadastro;
    @Getter @Setter
    @Column(name = "dtAtualizacao")
    private LocalDateTime atualizacao;
    @Getter @Setter
    @Column(name = "ativo")
    private boolean ativo;

    @PrePersist
    private void prePersist(){
        this.cadastro = LocalDateTime.now();

    }
    @PreUpdate
    private void preUpdate(){
        this.atualizacao = LocalDateTime.now();
    }
}
