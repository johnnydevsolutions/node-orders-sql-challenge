import { Test, TestingModule } from '@nestjs/testing';
import { JwtService } from '@nestjs/jwt';
import { AuthService } from './auth.service';

describe('AuthService', () => {
  let service: AuthService;
  let jwtService: JwtService;

  const mockJwtService = {
    sign: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        {
          provide: JwtService,
          useValue: mockJwtService,
        },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
    jwtService = module.get<JwtService>(JwtService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('validateUser', () => {
    it('should return user without password when credentials are valid', async () => {
      const result = await service.validateUser('admin', 'admin123');
      expect(result).toEqual({
        id: 1,
        username: 'admin',
        role: 'admin',
      });
    });

    it('should return null when username is invalid', async () => {
      const result = await service.validateUser('invalid', 'admin123');
      expect(result).toBeNull();
    });

    it('should return null when password is invalid', async () => {
      const result = await service.validateUser('admin', 'wrongpassword');
      expect(result).toBeNull();
    });
  });

  describe('login', () => {
    it('should return access token when user is valid', async () => {
      const user = { id: 1, username: 'admin', role: 'admin' };
      const expectedToken = 'jwt-token';
      
      mockJwtService.sign.mockReturnValue(expectedToken);

      const result = await service.login(user);

      expect(result).toEqual({
        access_token: expectedToken,
        user: {
          id: 1,
          username: 'admin',
          role: 'admin',
        },
      });

      expect(mockJwtService.sign).toHaveBeenCalledWith({
        username: user.username,
        sub: user.id,
        role: user.role,
      });
    });
  });

  describe('hashPassword', () => {
    it('should return hashed password', async () => {
      const password = 'testpassword';
      const hashedPassword = await service.hashPassword(password);
      
      expect(hashedPassword).toBeDefined();
      expect(hashedPassword).not.toBe(password);
      expect(typeof hashedPassword).toBe('string');
    });
  });
});