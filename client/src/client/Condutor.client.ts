import { Condutor } from "@/Model/Condutor";
import axios, { AxiosInstance } from "axios";

export class ConfiguracaoClient{

    private axiosClient: AxiosInstance;

    constructor() {
        this.axiosClient = axios.create({
            baseURL: 'http://localhost:8080/api/condutor',
            headers: {'Content-type' : 'application/json'}
        });
    }

    public async findById(id: number) : Promise<Condutor> {
        try {
            return (await this.axiosClient.get<Condutor>(`/${id}`)).data
        } catch (error:any) {
            return Promise.reject(error.response);
        }
    }

    public async ativos(): Promise<Condutor[]>{
        try {
            return( await this.axiosClient.get<Condutor[]>('/ativos')).data
        } catch (error:any){
            return Promise.reject(error.response);
        }
    }

    public async listar(): Promise<Condutor[]> {
        try {
            return (await this.axiosClient.get<Condutor[]>('/lista')).data;
        } catch (error: any) {
            return Promise.reject(error.response);
        }
    }

    public async newMarca(condutor: Condutor): Promise<void> {
        try {
            return (await this.axiosClient.post('/', condutor));
        } catch (error: any) {
            return Promise.reject(error.response);
        }
    }

    public async upDate(id: Number, condutor:Condutor): Promise<void>{
        try{
            return(await this.axiosClient.put(`/${condutor.id}`, condutor)).data;
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