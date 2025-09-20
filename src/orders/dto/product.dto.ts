import { ApiProperty } from '@nestjs/swagger';
import { IsNumber, IsOptional, IsString, Min, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';

export class DimensoesDto {
  @ApiProperty({ description: 'Altura do produto em cm' })
  @IsNumber()
  @Min(0.1)
  altura!: number;

  @ApiProperty({ description: 'Largura do produto em cm' })
  @IsNumber()
  @Min(0.1)
  largura!: number;

  @ApiProperty({ description: 'Comprimento do produto em cm' })
  @IsNumber()
  @Min(0.1)
  comprimento!: number;
}

export class ProductDto {
  @ApiProperty({ description: 'ID do produto' })
  @IsOptional()
  @IsString()
  produto_id?: string;

  @ApiProperty({ type: DimensoesDto, description: 'Dimensões do produto' })
  @ValidateNested()
  @Type(() => DimensoesDto)
  dimensoes!: DimensoesDto;
}
