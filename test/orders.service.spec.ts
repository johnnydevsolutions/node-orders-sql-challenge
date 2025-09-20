import { OrdersService } from '../src/orders/orders.service';

describe('OrdersService', () => {
  it('packs simple orders', () => {
    const service = new OrdersService();
    const result = service.packBatch({
      pedidos: [{
        pedido_id: 'T1',
        produtos: [
          { produto_id: 'P1', dimensoes: { altura: 20, largura: 30, comprimento: 40 } },
          { produto_id: 'P2', dimensoes: { altura: 10, largura: 10, comprimento: 50 } }
        ]
      }]
    } as any);
    expect(result.pedidos[0].caixas.length).toBeGreaterThan(0);
  });
});
