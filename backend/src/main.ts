import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await AppModule.setupSwagger(app); // add this line
  app.enableCors();
  await app.listen(3000);
}
bootstrap();
