import 'dotenv/config';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { ValidationPipe } from '@nestjs/common';
import rateLimit from 'express-rate-limit';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  // Configuração global de validação
  app.useGlobalPipes(new ValidationPipe({
    whitelist: true,
    transform: true,
  }));

  // Rate limiting para endpoint de login (anti brute-force)
  app.use(
    '/auth/login',
    rateLimit({
      windowMs: 10 * 60 * 1000, // 10 minutos
      max: 20, // máximo 20 tentativas por IP
      message: {
        error: 'Muitas tentativas de login',
        message: 'Tente novamente em 10 minutos',
      },
      standardHeaders: true,
      legacyHeaders: false,
    })
  );

  // Configuração do Swagger
  const config = new DocumentBuilder()
    .setTitle('Packing API')
    .setDescription('API para empacotamento de pedidos')
    .setVersion('1.0')
    .addBearerAuth({
      type: 'http',
      scheme: 'bearer',
      bearerFormat: 'JWT',
    }, 'bearer')
    .build();
  
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('swagger', app, document);

  const port = process.env.PORT || 3000;
  await app.listen(port);
  console.log(`🚀 Server running on http://localhost:${port}/swagger`);
}

bootstrap();
