import { Injectable } from '@nestjs/common';
import { BatchOrdersDto } from './dto/batch.dto';
import { OrderDto } from './dto/order.dto';
import { ProductDto } from './dto/product.dto';

type Dim = { h: number; w: number; l: number };

type BoxType = {
  name: string | null;
  dim: Dim;
  volume: number;
};

type Box = {
  boxType: BoxType;
  items: Array<{ product: ProductDto; orientation: Dim }>;
  usedVolume: number;
};

const BOX_TYPES: BoxType[] = [
  { name: 'Caixa 1 (30x40x80)', dim: { h: 30, w: 40, l: 80 }, volume: 30 * 40 * 80 },
  { name: 'Caixa 2 (50x50x40)', dim: { h: 50, w: 50, l: 40 }, volume: 50 * 50 * 40 },
  { name: 'Caixa 3 (50x80x60)', dim: { h: 50, w: 80, l: 60 }, volume: 50 * 80 * 60 },
].sort((a, b) => a.volume - b.volume);

function allRotations(p: ProductDto): Dim[] {
  const dims = [p.dimensoes.altura, p.dimensoes.largura, p.dimensoes.comprimento];
  const [a, b, c] = dims;
  // Unique permutations of (a,b,c)
  const set = new Set<string>();
  const out: Dim[] = [];
  const perms = [
    [a, b, c],
    [a, c, b],
    [b, a, c],
    [b, c, a],
    [c, a, b],
    [c, b, a],
  ];
  for (const [h, w, l] of perms) {
    const key = [h, w, l].join('x');
    if (!set.has(key)) {
      set.add(key);
      out.push({ h, w, l });
    }
  }
  return out;
}

function fits(orientation: Dim, box: BoxType): boolean {
  return (
    orientation.h <= box.dim.h &&
    orientation.w <= box.dim.w &&
    orientation.l <= box.dim.l
  );
}

@Injectable()
export class OrdersService {
  packBatch(payload: BatchOrdersDto) {
    return {
      pedidos: payload.pedidos.map((o) => ({
        pedido_id: o.pedido_id,
        caixas: this.packOrder(o),
      })),
    };
  }

  private packOrder(order: OrderDto) {
    const products = [...order.produtos].map((p) => ({
      ...p,
      volume: p.dimensoes.altura * p.dimensoes.largura * p.dimensoes.comprimento,
    }));
    products.sort((a, b) => b.volume - a.volume);

    const boxes: Box[] = [];

    for (const p of products) {
      const rotations = allRotations(p);
      // Try to place in existing boxes first
      let placed = false;
      for (const box of boxes) {
        for (const r of rotations) {
          if (fits(r, box.boxType)) {
            const remaining = box.boxType.volume - box.usedVolume;
            if (p.volume <= remaining) {
              box.items.push({ product: p, orientation: r });
              box.usedVolume += p.volume;
              placed = true;
              break;
            }
          }
        }
        if (placed) break;
      }
      if (!placed) {
        // Open the smallest box type that can fit this product dimensionally
        const candidate = BOX_TYPES.find((bt) => rotations.some((r) => fits(r, bt)));
        if (!candidate) {
          // Produto não cabe em nenhuma caixa - criar uma entrada especial
          const specialBox: Box = { 
            boxType: { name: null, dim: { h: 0, w: 0, l: 0 }, volume: 0 }, 
            items: [{ product: p, orientation: { h: p.dimensoes.altura, w: p.dimensoes.largura, l: p.dimensoes.comprimento } }], 
            usedVolume: 0 
          };
          boxes.push(specialBox);
        } else {
          const r = rotations.find((rot) => fits(rot, candidate))!;
          const newBox: Box = { boxType: candidate, items: [{ product: p, orientation: r }], usedVolume: p.volume };
          boxes.push(newBox);
        }
      }
    }

    // Shape response conforme exemplo do recrutador
    return boxes.map((b) => ({
      caixa_id: b.boxType.name || "Caixa Especial",
      produtos: b.items.map((it) => it.product.produto_id || "Produto sem ID")
    }));
  }
}
