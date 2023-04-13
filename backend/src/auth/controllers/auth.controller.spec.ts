import { Test, TestingModule } from '@nestjs/testing';
import { AuthController } from './auth.controller';
import { AuthService } from '../services/auth.service';
import { CreateUserDto } from '../../dto/create-user.dto';
import { AuthenticationRequest } from '../../dto/create-user.dto';
import { ResponseBase, ResponseGeneric } from '../../dto/response.dto';
import { AuthenticationResponse } from '../../dto/responses/minimal-user-dto';
import { ForgotPasswordDto } from '../../dto/forgot-password.dto';
import { ChangePasswordDto } from '../../dto/change-password.dto';
import { DatabaseService } from '../../databases/database.service';
import { CorsMiddleware } from '../../middlewares/cors.middleware';
import { JwtStrategy } from '../auth.strategy';
import { UserOtpsRepository, UsersRepository } from '../repositories/users.repository';
import { EmailService } from '../services/messagings/email.service';
import { UsersService } from '../services/users/users.service';
import { MailerModule } from '@nestjs-modules/mailer';
import { HandlebarsAdapter } from '@nestjs-modules/mailer/dist/adapters/handlebars.adapter';
import { PassportModule } from '@nestjs/passport';
import { JwtModule } from '@nestjs/jwt';
import * as nodemailer from 'nodemailer';

describe('AuthController', () => {
  let controller: AuthController;
  let authService: AuthService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
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
      providers: [AuthService,CorsMiddleware,
        JwtStrategy,UsersService,EmailService, UserOtpsRepository,UsersRepository, DatabaseService],
    }).compile();

    controller = module.get<AuthController>(AuthController);
    authService = module.get<AuthService>(AuthService);
  });

  describe('login', () => {
    it('should return an authentication response', async () => {
      const authenticationRequest: AuthenticationRequest = {
        email: 'smisha5000@gmail.com',
        password: 'password',
      };
      const authenticationResponse: AuthenticationResponse = {
          accessToken: 'jwt.token.here',
          expiresIn: 3600,
          phoneNumber: "0505670644",
          isAuthenticated: false,
          role: "student",
          isTeacher: false,
          email: 'smisha5000@gmail.com',
          userId: 0,
          profileImageUrl: 'profileImageUrl',
          firstName: 'Yehor',
          lastName: 'Zhvarnytskyi',
          descriptions: 'description',
          created: undefined,
          fullName: 'Yehor Zhvarnytskyi'
      };
      jest.spyOn(authService, 'loginUser').mockResolvedValue(authenticationResponse);

      const result = await controller.login(authenticationRequest);

      expect(result).toEqual(new ResponseGeneric<AuthenticationResponse>(authenticationResponse));
    });
  });

  describe('register', () => {
    it('should return an authentication response', async () => {
      const createUserDto: CreateUserDto = {
          username: 'testuser',
          email: 'testuser@example.com',
          password: 'password',
          phone: '',
          created_at: undefined,
          balance_of_tokens: 0,
          roles: ''
      };
      const authenticationResponse: AuthenticationResponse = {
          accessToken: 'jwt.token.here',
          expiresIn: 3600,
          phoneNumber: '',
          isAuthenticated: false,
          role: '',
          isTeacher: false,
          email: '',
          userId: 0,
          profileImageUrl: '',
          firstName: '',
          lastName: '',
          descriptions: '',
          created: undefined,
          fullName: ''
      };
      jest.spyOn(authService, 'registerUser').mockResolvedValue(authenticationResponse);

      const result = await controller.register(createUserDto);

      expect(result).toEqual(new ResponseGeneric<AuthenticationResponse>(authenticationResponse));
    });
  });

  describe('confirmEmail', () => {
    it('should return a response', async () => {
      const createConfirmEmailDto = {
        userId: 1,
        code: 'confirmation code',
      };
      jest.spyOn(authService, 'confirmEmailAsync').mockResolvedValue(undefined);

      const result = await controller.confirmEmail(createConfirmEmailDto);

      expect(result).toEqual(ResponseBase.succeed("email successfully confirmed"));
    });
  });

  describe('forgotPassword', () => {
    it('should return a success message', async () => {
      const forgotPasswordDto: ForgotPasswordDto = {
        email: 'testuser@example.com',
      };
      jest.spyOn(authService, 'sendPasswordResetEmail').mockResolvedValue(undefined);

      const result = await controller.forgotPassword(forgotPasswordDto);

      expect(result).toEqual({ message: 'Password reset email sent successfully.' });
    });
  });

  describe('changePassword', () => {
    it('should return a response', async () => {
      const changePasswordDto: ChangePasswordDto = {
          password: ''
      };
      const token = 'jwt.token.here';
      jest.spyOn(authService, 'changePassword').mockResolvedValue(undefined);

      const result = await controller.changePassword(changePasswordDto, `Bearer ${token}`);

      expect(result).toBeUndefined();
    });
  });
});
