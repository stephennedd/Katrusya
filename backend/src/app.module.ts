import { MiddlewareConsumer, Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
// import { AuthService } from './services/auth.service';
// import { AuthController } from './controllers/auth.controller';
import { JwtModule } from '@nestjs/jwt';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
// import { DatabaseService } from './databases/database.service';
// import { CorsMiddleware } from './middlewares/cors.middleware';
import { CoursesModule } from './courses/courses.module';
import { SectionsModule } from './sections/sections.module';
import { UsersModule } from './users/users.module';
import { CategoriesModule } from './categories/categories.module';
// import { MailerModule } from '@nestjs-modules/mailer';
// import * as nodemailer from 'nodemailer';
// import { HandlebarsAdapter } from '@nestjs-modules/mailer/dist/adapters/handlebars.adapter';
// import { EmailService } from './services/messagings/email.service';
// import { UserOtpsRepository, UsersRepository } from './repositories/users.repository';
// import { UsersService } from './services/users/users.service';
// import { JwtStrategy } from './auth.strategy';
// import { PassportModule } from '@nestjs/passport';
import { AuthModule } from './auth/auth.module';

@Module({
  imports: [
    CoursesModule,
    SectionsModule,
    UsersModule,
    CategoriesModule,
    AuthModule
  ],
  controllers: [AppController,],
  providers: [AppService],
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
