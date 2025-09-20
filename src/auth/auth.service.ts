import { Injectable, UnauthorizedException, ConflictException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcryptjs';
import { RegisterDto } from './dto/register.dto';

export interface User {
  id: number;
  username: string;
  password: string;
}

@Injectable()
export class AuthService {
  // Sistema dinâmico de usuários em memória (em produção, isso seria um banco de dados)
  private users: User[] = [];
  private nextId = 1;

  constructor(private jwtService: JwtService) {}

  async register(registerDto: RegisterDto): Promise<{ message: string; user: Omit<User, 'password'> }> {
    const { username, password } = registerDto;

    // Verificar se o usuário já existe
    const existingUser = this.users.find(user => user.username === username);
    if (existingUser) {
      throw new ConflictException('Nome de usuário já existe');
    }

    // Hash da senha
    const hashedPassword = await this.hashPassword(password);

    // Criar novo usuário
    const newUser: User = {
      id: this.nextId++,
      username,
      password: hashedPassword,
    };

    this.users.push(newUser);

    // Retornar usuário sem a senha
    const { password: _, ...userWithoutPassword } = newUser;
    return {
      message: 'Usuário registrado com sucesso',
      user: userWithoutPassword,
    };
  }

  async validateUser(username: string, password: string): Promise<any> {
    const user = this.users.find(user => user.username === username);
    if (user && await bcrypt.compare(password, user.password)) {
      const { password, ...result } = user;
      return result;
    }
    return null;
  }

  async login(user: any) {
    const payload = { username: user.username, sub: user.id };
    return {
      access_token: this.jwtService.sign(payload),
      user: {
        id: user.id,
        username: user.username,
      },
    };
  }

  async signIn(username: string, password: string) {
    const user = await this.validateUser(username, password);
    if (!user) {
      throw new UnauthorizedException('Credenciais inválidas');
    }
    return this.login(user);
  }

  // Método para hash de senhas
  async hashPassword(password: string): Promise<string> {
    return bcrypt.hash(password, 10);
  }


}