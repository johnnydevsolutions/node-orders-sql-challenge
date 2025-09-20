import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcryptjs';

export interface User {
  id: number;
  username: string;
  password: string;
  role: string;
}

@Injectable()
export class AuthService {
  // Simulação de usuários em memória (em produção, usar banco de dados)
  private readonly users = [
    {
      id: 1,
      username: 'admin',
      password: '$2b$10$8QwMzJyhEFaggdrKi83Or.5Vw5Momm3NP/Z1VpF/fBJYc8EuS/zIu', // admin123
      role: 'admin',
    },
    {
      id: 2,
      username: 'user',
      password: '$2b$10$dFD7tNPuWtKR9t.AE8VTYu.TvNi7PGJlf7mjQUf3ILqONC3dql0XG', // user123
      role: 'user',
    },
  ];

  constructor(private jwtService: JwtService) {}

  async validateUser(username: string, password: string): Promise<any> {
    const user = this.users.find(user => user.username === username);
    if (user && await bcrypt.compare(password, user.password)) {
      const { password, ...result } = user;
      return result;
    }
    return null;
  }

  async login(user: any) {
    const payload = { username: user.username, sub: user.id, role: user.role };
    return {
      access_token: this.jwtService.sign(payload),
      user: {
        id: user.id,
        username: user.username,
        role: user.role,
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

  // Método para hash de senhas (útil para criar novos usuários)
  async hashPassword(password: string): Promise<string> {
    return bcrypt.hash(password, 10);
  }
}