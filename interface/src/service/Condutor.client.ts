import { Condutor } from '@/model/Condutor';
import axios, { AxiosInstance } from 'axios';

export class CondutorClient {
  private axiosClient: AxiosInstance;

  constructor() {
    this.axiosClient = axios.create({
      baseURL: `http://localhost:8080/api`,
      headers: { 'Content-type': 'application/json' }
    });
  }

  public async getCondutorById(id: number): Promise<Condutor> {
    try {
      const response = await this.axiosClient.get<Condutor>(`/condutor?id=${id}`);
      return response.data;
    } catch (error) {
      return Promise.reject(error);
    }
  }

  public async getAllCondutores(): Promise<Condutor[]> {
    try {
      const response = await this.axiosClient.get<Condutor[]>('/condutor/lista');
      return response.data;
    } catch (error) {
      console.error(error);
      return [];
    }
  }

  public async getCondutoresByName(name: string): Promise<Condutor[]> {
    try {
      const response = await this.axiosClient.get<Condutor[]>(`/condutor/nome?nome=${name}`);
      return response.data;
    } catch (error) {
      return Promise.reject(error);
    }
  }

  public async getCondutoresByCpf(cpf: string): Promise<Condutor[]> {
    try {
      const response = await this.axiosClient.get<Condutor[]>(`/condutor/cpf?cpf=${cpf}`);
      return response.data;
    } catch (error) {
      return Promise.reject(error);
    }
  }

  public async getActiveCondutores(): Promise<Condutor[]> {
    try {
      const response = await this.axiosClient.get<Condutor[]>('/condutor/lista/ativos');
      return response.data;
    } catch (error) {
      console.error(error);
      return [];
    }
  }

  public async addCondutor(condutor: Condutor): Promise<Condutor> {
    try {
      const response = await this.axiosClient.post<Condutor>('/condutor', condutor);
      return response.data;
    } catch (error) {
      return Promise.reject(error);
    }
  }

  public async updateCondutor(condutor: Condutor): Promise<Condutor> {
    try {
      const response = await this.axiosClient.put<Condutor>(`/condutor?id=${condutor.id}`, condutor);
      return response.data;
    } catch (error) {
      return Promise.reject(error);
    }
  }

  public async deactivateCondutor(id: number): Promise<Condutor> {
    try {
      const response = await this.axiosClient.delete<Condutor>(`/condutor?id=${id}`);
      return response.data;
    } catch (error) {
      return Promise.reject(error);
    }
  }
}
