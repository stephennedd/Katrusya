import { Test, TestingModule } from '@nestjs/testing';
import { AuthController } from '../controllers/auth.controller';
import { AuthService } from '../services/auth.service';
import { AuthenticationRequest } from '../../dto/create-user.dto';
import { AuthenticationResponse } from '../../dto/responses/minimal-user-dto';
import { DatabaseService } from '../../databases/database.service';
import { CorsMiddleware } from '../../middlewares/cors.middleware';
import { JwtStrategy } from '../auth.strategy';
import { UserOtpsRepository, UsersRepository } from '../repositories/users.repository';
import { EmailService } from '../services/messagings/email.service';
import { UsersService as UsersService2 } from '../../users/services/users/users.service';
import { UsersService } from './users/users.service';
import { MailerModule } from '@nestjs-modules/mailer';
import { HandlebarsAdapter } from '@nestjs-modules/mailer/dist/adapters/handlebars.adapter';
import { PassportModule } from '@nestjs/passport';
import { JwtModule } from '@nestjs/jwt';
import * as nodemailer from 'nodemailer';
import { UserCoursesRepository, CoursesRepository, TestsRepository } from '../../courses/repositories/courses.repository';
import { LessonsRepository, SectionsRepository } from '../../sections/repositories/sections.repository';
import {UsersRepository as UsersRepository2, UserCoursesRepository as UserCoursesRepository2, UserFavoriteCoursesRepository, UserCompletedLessonsRepository, UserCompletedSectionsRepository, UserResultsRepository, UserLessonsRepository } from '../../users/repositories/users.repository';
import { ResponseBase } from '../../dto/response.dto';
import { ForgotPasswordDto } from '../../dto/forgot-password.dto';
import { ChangePasswordDto } from '../../dto/change-password.dto';

describe('AuthController', () => {
  let controller: AuthController;
  let authService: AuthService;
  let usersService: UsersService;
  let usersService2: UsersService2;

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
      providers: [UsersService2,AuthService,CorsMiddleware,
        JwtStrategy,UsersService,EmailService, UserOtpsRepository,UsersRepository, DatabaseService,
        DatabaseService,
        UserFavoriteCoursesRepository,UserCompletedLessonsRepository,
      UserCompletedSectionsRepository,UserCoursesRepository,UserCoursesRepository2,
      UserResultsRepository,CoursesRepository,
      LessonsRepository,SectionsRepository,UserLessonsRepository,
      TestsRepository,UsersRepository2],
    }).compile();

    controller = module.get<AuthController>(AuthController);
    authService = module.get<AuthService>(AuthService);
    usersService = module.get<UsersService>(UsersService);
    usersService2 = module.get<UsersService2>(UsersService2);
  });

  describe('register', () => {
    it('should return an authentication response', async () => {
      const createUserDto = {
          id:4,
          username: 'sorokin',
          email: 'smisha7000@gmail.com',
          password: 'qwerty',
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
      const result = await controller.register(createUserDto);

      expect(result.succeeded).toEqual(true);
    });
  });

  describe('login', () => {
    it('should return an authentication response', async () => {
      const authenticationRequest: AuthenticationRequest = {
        email: 'smisha7000@gmail.com',
        password: 'qwerty',
      };
      const result = await controller.login(authenticationRequest);
   
      expect(result.succeeded).toEqual(true);
    });
  });

  describe('forgotPassword', () => {
    it('should return a success message', async () => {
      const forgotPasswordDto: ForgotPasswordDto = {
        email: 'smisha7000@gmail.com',
      };
      const result = await controller.forgotPassword(forgotPasswordDto);

      expect(result).toEqual({ message: 'Password reset email sent successfully.' });
    });
  });

describe('deleteUser', () => {
    it('should delete a user by id', async () => {
      
      // Act
      const result = await usersService.deleteOtpsOfUser(4);
      const result2 = await usersService2.deleteUser(4);
    });
  });
});