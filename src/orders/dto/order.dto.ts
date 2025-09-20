import { ApiProperty } from '@nestjs/swagger';
import { IsArray, IsNumber, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { ProductDto } from './product.dto';

export class OrderDto {
  @ApiProperty({ example: 1, description: 'ID do pedido' })
  @IsNumber()
  pedido_id!: number;

  @ApiProperty({ type: [ProductDto], description: 'Lista de produtos no pedido' })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ProductDto)
  produtos!: ProductDto[];
}
