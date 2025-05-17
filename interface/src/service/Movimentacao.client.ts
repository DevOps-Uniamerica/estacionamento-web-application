import { Configuracao } from '@/model/Configuracao' 
import { Movimentacao } from '@/model/Movimentacao'
import { Tipo } from '@/model/Tipo'
import axios, { AxiosInstance } from 'axios'

export class MovimentacaoClient {
  private axiosClient: AxiosInstance
//http://estacionamento-backend.main.svc.cluster.local
  constructor() {
    this.axiosClient = axios.create({
      baseURL: "/api",
      headers: { 'Content-type': 'application/json' }
    })
  }

  public async findById(id: number): Promise<Movimentacao> {
    try {
      const response = await this.axiosClient.get<Movimentacao>(`/movimentacao?id=${id}`)
      return response.data
    } catch (error) {
      return Promise.reject(error)
    }
  }

  public async findAll(): Promise<Movimentacao[]> {
    try {
      const response = await this.axiosClient.get<Movimentacao[]>('/movimentacao/lista')
      return response.data
    } catch (error) {
      console.error(error)
      return []
    }
  }

  public async listarAbertas(): Promise<Movimentacao[]> {
    try {
      const response = await this.axiosClient.get<Movimentacao[]>('/movimentacao/lista/abertas')
      return response.data
    } catch (error) {
      console.error(error)
      return []
    }
  }
  public async getVagas(tipo: Tipo): Promise<Movimentacao[]> {
    try {
      const response = await this.axiosClient.get<Movimentacao[]>(`/movimentacao/lista/vagas?tipo=${tipo}`)
      return response.data
    } catch (error) {
      console.error(error)
      return []
    }
  }

  public async novaMovimentacao(movimentacao: Movimentacao): Promise<Movimentacao> {
    try {
      const response = await this.axiosClient.post<Movimentacao>('/movimentacao/nova', movimentacao)
      return response.data
    } catch (error) {
      return Promise.reject(error)
    }
  }

  public async editarMovimentacao(movimentacao: Movimentacao): Promise<string> {
    try {
      const response = await this.axiosClient.put<string>(
        `/movimentacao/editar?id=${movimentacao.id}`,
        movimentacao
      )
      return response.data
    } catch (error) {
      return Promise.reject(error)
    }
  }

  public async deletar(movimentacao: Movimentacao): Promise<Movimentacao> {
    try {Movimentacao
      const response = await this.axiosClient.delete<Movimentacao>(
        `/movimentacao?id=${movimentacao.id}`
      )
      return response.data
    } catch (error) {
      return Promise.reject(error)
    }
  }
}
