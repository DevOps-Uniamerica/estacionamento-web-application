import { Movimentacao } from "@/Model/Movimentacao";
import axios, { AxiosInstance } from "axios";

export class ConfiguracaoClient{

    private axiosClient: AxiosInstance;

    constructor() {
        this.axiosClient = axios.create({
            baseURL: 'http://localhost:8080/api/movimentacao',
            headers: {'Content-type' : 'application/json'}
        });
    }

    public async findById(id: number) : Promise<Movimentacao> {
        try {
            return (await this.axiosClient.get<Movimentacao>(`/${id}`)).data
        } catch (error:any) {
            return Promise.reject(error.response);
        }
    }

    public async ativos(): Promise<Movimentacao[]>{
        try {
            return( await this.axiosClient.get<Movimentacao[]>('/ativos')).data
        } catch (error:any){
            return Promise.reject(error.response);
        }
    }

    public async listar(): Promise<Movimentacao[]> {
        try {
            return (await this.axiosClient.get<Movimentacao[]>('/lista')).data;
        } catch (error: any) {
            return Promise.reject(error.response);
        }
    }

    public async newMarca(movimentacao: Movimentacao): Promise<void> {
        try {
            return (await this.axiosClient.post('/', movimentacao));
        } catch (error: any) {
            return Promise.reject(error.response);
        }
    }

    public async upDate(id: Number, movimentacao:Movimentacao): Promise<void>{
        try{
            return(await this.axiosClient.put(`/${movimentacao.id}`, movimentacao)).data;
        } catch(error: any) {
            return Promise.reject(error.response);
        }
    }

    public async deletar(id:Number): Promise<void>{
        try{
            return(await this.axiosClient.delete(`${id}`)).data;
        } catch (error: any){
           return Promise.reject(error.response);
        }
    }
}