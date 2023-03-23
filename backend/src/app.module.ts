import { MiddlewareConsumer, Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
//import { UsersService } from './services/users/users.service';
import { AuthService } from './services/auth.service';
import { AuthController } from './controllers/auth.controller';
import { JwtModule } from '@nestjs/jwt';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { DatabaseService } from './databases/database.service';
import { SectionsController } from './sections/controllers/sections/sections.controller';
import { SectionsService } from './sections/services/sections/sections.service';
import { CorsMiddleware } from './middlewares/cors.middleware';
import { UsersController } from './users/controllers/users/users.controller';
import { UsersService } from './users/services/users/users.service';

@Module({
  imports: [
    JwtModule.register({
      secret: 'your-secret-key-here',
      signOptions: { expiresIn: '1h' },
    }),
  ],
  controllers: [AppController, AuthController, SectionsController, UsersController,],
  providers: [AppService,
    SectionsService,
    DatabaseService,
     AuthService,
     CorsMiddleware,
     UsersService],
})
export class AppModule {
  configure(consumer: MiddlewareConsumer) {
    // add middleware here
  }

  static async setupSwagger(app) {
    const options = new DocumentBuilder()
      .setTitle('Katyusha API')
      .setDescription('game changer in toturials')
      .setVersion('1.0')
      .build();
    const document = SwaggerModule.createDocument(app, options);
    SwaggerModule.setup('docs', app, document);
  }

}
