import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsArray, ValidateNested } from 'class-validator';
import { OrderDto } from './order.dto';

export class BatchOrdersDto {
  @ApiProperty({ type: [OrderDto], description: 'Lista de pedidos para empacotamento' })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => OrderDto)
  pedidos!: OrderDto[];
}
