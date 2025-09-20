import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNotEmpty, Matches, MinLength } from 'class-validator';

export class RegisterDto {
  @ApiProperty({
    description: 'Nome de usuário',
    example: 'joao123',
    minLength: 3,
  })
  @IsString()
  @IsNotEmpty()
  @MinLength(3)
  username!: string;

  @ApiProperty({
    description: 'Senha do usuário (mínimo 8 caracteres, pelo menos 1 número e 1 caractere especial)',
    example: 'MinhaSenh@123',
    minLength: 8,
  })
  @IsString()
  @IsNotEmpty()
  @Matches(
    /^(?=.*[0-9])(?=.*[!@#$%^&*()_+=\-]).{8,}$/,
    {
      message: 'A senha deve ter pelo menos 8 caracteres, incluindo pelo menos 1 número e 1 caractere especial (!@#$%^&*()_+-=)',
    }
  )
  password!: string;


}