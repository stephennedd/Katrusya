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
//import { UsersService } from './users/services/users/users.service';
import { CoursesModule } from './courses/courses.module';
import { SectionsModule } from './sections/sections.module';
import { UsersModule } from './users/users.module';
import { CategoriesModule } from './categories/categories.module';
import { MailerModule } from '@nestjs-modules/mailer';
import * as nodemailer from 'nodemailer';
import { HandlebarsAdapter } from '@nestjs-modules/mailer/dist/adapters/handlebars.adapter';
import { EmailService } from './services/messagings/email.service';
import { UserOtpsRepository, UsersRepository } from './repositories/users.repository';
import { UsersService } from './services/users/users.service';
import { JwtStrategy } from './auth.strategy';
import { PassportModule } from '@nestjs/passport';

@Module({
  imports: [
    MailerModule.forRoot({
      transport: nodemailer.createTransport({
        host: 'localhost',
        port: 1025, // Replace with the port number of your local email client
        auth: {
          user: 'your-username',
          pass: 'your-password',
        },
      }),
      defaults: {
        from: '"No Reply" <no-reply@example.com>',
      },
      template: {
        dir: __dirname + '/public/templates',
        adapter: new HandlebarsAdapter(), // Replace with the template engine you're using
        options: {
          strict: true,
        },
      },
    }),
    PassportModule.register({ defaultStrategy: 'jwt' }),    
    JwtModule.register({
      secret: 'your-secret-key-here',
      signOptions: { expiresIn: '1h' },
    }),
    CoursesModule,
    SectionsModule,
    UsersModule,
    CategoriesModule,
    
  ],
  controllers: [AppController, AuthController,],
  providers: [AppService,
     AuthService,
     CorsMiddleware,
     UsersService, 
     AuthService, 
     EmailService, 
     UsersRepository, 
     UserOtpsRepository, 
     DatabaseService,
    JwtStrategy],
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
