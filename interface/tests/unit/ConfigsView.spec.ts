import { shallowMount, flushPromises } from '@vue/test-utils'
import ConfigsView from '@/views/configuracao/ConfigsView.vue'
import AvisoComponent from '@/components/AvisoComponent.vue'

// Mockando a classe ConfiguracaoClient diretamente dentro do teste
jest.mock('@/service/Configuracao.client', () => {
  return {
    ConfiguracaoClient: jest.fn().mockImplementation(() => ({
      getConfiguracao: jest.fn().mockResolvedValue({
        id: 1,
        qntdCarro: 10,
        qntdMoto: 5,
        qntdVan: 2,
        valorHora: "5.00",
        valorMulta: "2.50",
        horaAbertura: "08:00:00",
        horaFechamento: "20:00:00"
      }),
      primeiraConfiguracao: jest.fn().mockResolvedValue("Configuração salva com sucesso"),
      editar: jest.fn().mockResolvedValue("Configuração editada com sucesso")
    }))
  }
})

describe('ConfigsView.vue', () => {
  it('deve renderizar corretamente o título', async () => {
    const wrapper = shallowMount(ConfigsView, {
      global: {
        components: {
          AvisoComponent
        }
      }
    })

    // Aguarda a resolução das promessas assíncronas
    await flushPromises()

    expect(wrapper.find('h2').text()).toBe('Configurações do Sistema')
  })

  it('deve possuir os campos de entrada esperados', async () => {
    const wrapper = shallowMount(ConfigsView)

    await flushPromises()

    const inputs = [
      '#vagasCarros',
      '#vagasMotos',
      '#vagasVan',
      '#valorHora',
      '#valorMulta',
      '#horaAbertura',
      '#horaFechamento'
    ]

    inputs.forEach(selector => {
      expect(wrapper.find(selector).exists()).toBe(true)
    })
  })
})
