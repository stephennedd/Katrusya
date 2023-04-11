import { Module } from '@nestjs/common';
import { JwtStrategy } from './auth.strategy';
import { DatabaseService } from 'src/databases/database.service';
import { CorsMiddleware } from 'src/middlewares/cors.middleware';
import { AuthController } from './controllers/auth.controller';
import { UserOtpsRepository, UsersRepository } from './repositories/users.repository';
import { AuthService } from './services/auth.service';
import { EmailService } from './services/messagings/email.service';
import { UsersService } from './services/users/users.service';
import { MailerModule } from '@nestjs-modules/mailer';
import * as nodemailer from 'nodemailer';
import { HandlebarsAdapter } from '@nestjs-modules/mailer/dist/adapters/handlebars.adapter';
import { PassportModule } from '@nestjs/passport';
import { JwtModule } from '@nestjs/jwt';

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
     //   AuthModule
      ],
    controllers: [AuthController],
  providers: [CorsMiddleware,
    JwtStrategy,AuthService,UsersService,EmailService, UserOtpsRepository,UsersRepository, DatabaseService]
})
export class AuthModule {}