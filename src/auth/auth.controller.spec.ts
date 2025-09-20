import { Test, TestingModule } from '@nestjs/testing';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';

describe('AuthController', () => {
  let controller: AuthController;
  let authService: AuthService;

  const mockAuthService = {
    validateUser: jest.fn(),
    login: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AuthController],
      providers: [
        {
          provide: AuthService,
          useValue: mockAuthService,
        },
      ],
    }).compile();

    controller = module.get<AuthController>(AuthController);
    authService = module.get<AuthService>(AuthService);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  describe('login', () => {
    it('should return access token when credentials are valid', async () => {
      const loginDto: LoginDto = {
        username: 'admin',
        password: 'admin123',
      };

      const user = { id: 1, username: 'admin', role: 'admin' };
      const loginResult = {
        access_token: 'jwt-token',
        user: user,
      };

      mockAuthService.validateUser.mockResolvedValue(user);
      mockAuthService.login.mockResolvedValue(loginResult);

      const result = await controller.login(loginDto);

      expect(result).toEqual(loginResult);
      expect(mockAuthService.validateUser).toHaveBeenCalledWith('admin', 'admin123');
      expect(mockAuthService.login).toHaveBeenCalledWith(user);
    });

    it('should throw UnauthorizedException when credentials are invalid', async () => {
      const loginDto: LoginDto = {
        username: 'admin',
        password: 'wrongpassword',
      };

      mockAuthService.validateUser.mockResolvedValue(null);

      await expect(controller.login(loginDto)).rejects.toThrow('Credenciais inválidas');
    });
  });

  describe('getProfile', () => {
    it('should return user profile', () => {
      const user = { id: 1, username: 'admin', role: 'admin' };
      const req = { user };

      const result = controller.getProfile(req);

      expect(result).toEqual(user);
    });
  });
});