import { Controller, Post, Body, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { OrdersService } from './orders.service';
import { BatchOrdersDto } from './dto/batch.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@ApiTags('Orders')
@Controller('orders')
export class OrdersController {
  constructor(private readonly ordersService: OrdersService) {}

  @Post('pack')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth('bearer')
  @ApiOperation({ summary: 'Empacotar pedidos em lote (Requer autenticação)' })
  @ApiResponse({ status: 200, description: 'Pedidos empacotados com sucesso' })
  @ApiResponse({ status: 401, description: 'Token de autenticação inválido ou ausente' })
  packBatch(@Body() batchOrdersDto: BatchOrdersDto) {
    return this.ordersService.packBatch(batchOrdersDto);
  }
}
