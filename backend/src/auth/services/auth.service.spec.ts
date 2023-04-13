import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { UsersService } from './users/users.service';
import { EmailService } from './messagings/email.service';
import { JwtModule, JwtService } from '@nestjs/jwt';
import { DatabaseService } from '../../databases/database.service';
import { UsersRepository, UserOtpsRepository } from '../repositories/users.repository';
import { AuthenticationResponse } from '../../dto/responses/minimal-user-dto';
import { CreateUserDto } from '../../dto/create-user.dto';
import { BadRequestException, NotFoundException } from '@nestjs/common';
import { UserEntity } from '../../models/user/user';
import * as bcrypt from 'bcrypt';
import { MailerModule, MailerService } from '@nestjs-modules/mailer';
import { HandlebarsAdapter } from '@nestjs-modules/mailer/dist/adapters/handlebars.adapter';
import { PassportModule } from '@nestjs/passport';
import * as nodemailer from 'nodemailer';

describe('AuthService', () => {
  let authService: AuthService;
  let usersService: UsersService;
  let emailService: EmailService;
  let jwtService: JwtService;
  let dbService: DatabaseService;
  let usersRepository: UsersRepository;
  let userOtpsRepository: UserOtpsRepository;

  const mockJwtService = {
    sign: jest.fn().mockReturnValue('mock-token'),
  };

  const mockDbService = {
    getKnexInstance: jest.fn(),
  };

  const mockUserRepository = {
    getUserBasedOnEmail: jest.fn(),
    getUserBasedOnUsername: jest.fn(),
    getUserBasedOnPhone: jest.fn(),
    create: jest.fn(),
  };

  const mockUserOtpsRepository = {
    getOtp: jest.fn(),
    create: jest.fn(),
    update: jest.fn(),
  };

  const mockUsersService = {
    getUserBasedOnEmail: jest.fn(),
    getUserBasedOnUsername: jest.fn(),
    getUserBasedOnPhone: jest.fn(),
    create: jest.fn(),
  };

  const mockMailerService = {
    sendMail: jest.fn(),
  };


  beforeEach(async () => {
    const moduleRef: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        UsersService,
        {
          provide: JwtService,
          useValue: mockJwtService,
        },
        {
          provide: DatabaseService,
          useValue: mockDbService,
        },
        {
          provide: UsersRepository,
          useValue: mockUserRepository,
        },
        {
          provide: UserOtpsRepository,
          useValue: mockUserOtpsRepository,
        },
        {
          provide: EmailService,
          useValue: mockMailerService,
        },
      ],
    }).compile();

    authService = moduleRef.get<AuthService>(AuthService);
    usersService = moduleRef.get<UsersService>(UsersService);
    emailService = moduleRef.get<EmailService>(EmailService);
    jwtService = moduleRef.get<JwtService>(JwtService);
    dbService = moduleRef.get<DatabaseService>(DatabaseService);
    usersRepository = moduleRef.get<UsersRepository>(UsersRepository);
    userOtpsRepository = moduleRef.get<UserOtpsRepository>(UserOtpsRepository);
  });

  describe('registerUser', () => {
    const createUserDto: CreateUserDto = {
        email: 'john@example.com',
        password: 'password123',
        username: 'john_doe',
        phone: '1234567890',
        created_at: undefined,
        balance_of_tokens: 0,
        roles: ''
    };
    const userEntity: UserEntity = {
        id: 1,
        email: 'john@example.com',
        password: bcrypt.hashSync('password123', 10),
        username: 'john_doe',
        is_active: false,
        email_confirmed: false,
        reset_token: '',
        reset_token_expiry: undefined,
        avatar: ''
    };
    const authenticationResponse: AuthenticationResponse = {
        isAuthenticated: true,
        email: 'john@example.com',
        phoneNumber: '',
        role: '',
        isTeacher: false,
        accessToken: '',
        expiresIn: 0,
        userId: 0,
        profileImageUrl: '',
        firstName: '',
        lastName: '',
        descriptions: '',
        created: undefined,
        fullName: ''
    };

    it('should register a new user', async () => {
      jest.spyOn(usersService, 'getUserBasedOnEmail').mockResolvedValueOnce(null);
      jest.spyOn(usersService, 'getUserBasedOnUsername').mockResolvedValueOnce(null);
      jest.spyOn(usersService, 'getUserBasedOnPhone').mockResolvedValueOnce(null);
      jest.spyOn(usersService, 'create').mockResolvedValueOnce(userEntity);
      jest.spyOn(authService, 'generateToken').mockResolvedValueOnce(authenticationResponse);

      const result = await authService.registerUser(createUserDto);

      expect(usersService.getUserBasedOnEmail).toHaveBeenCalledWith(createUserDto.email);
      expect(usersService.getUserBasedOnUsername).toHaveBeenCalledWith(createUserDto.username);
      expect(usersService.getUserBasedOnPhone).toHaveBeenCalledWith(createUserDto.phone);

    })})
});