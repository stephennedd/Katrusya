import { Test, TestingModule } from '@nestjs/testing';
import { UsersService } from './users.service';
import { UserCompletedLessonsRepository, UserCompletedSectionsRepository, UserCoursesRepository, UserFavoriteCoursesRepository, UserLessonsRepository, UserResultsRepository, UsersRepository } from '../../repositories/users.repository';
import { DatabaseService } from '../../../databases/database.service';
import { UserEntity } from 'src/models/user/user';
import { CoursesRepository, TestsRepository } from '../../../courses/repositories/courses.repository';
import { LessonsRepository, SectionsRepository } from '../../../sections/repositories/sections.repository';

describe('UsersService', () => {
  let service: UsersService;
  let repository: UsersRepository;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UsersService,UsersRepository,
        UserFavoriteCoursesRepository,UserCompletedLessonsRepository,
      UserCompletedSectionsRepository,UserCoursesRepository,
      UserResultsRepository,CoursesRepository,
      LessonsRepository,SectionsRepository,UserLessonsRepository,
      TestsRepository,{
        provide: DatabaseService,
        useValue: {}, // Provide a mock object here
      },
      ],
    }).compile();

    service = module.get<UsersService>(UsersService);
    repository = module.get<UsersRepository>(UsersRepository);
  });

  afterEach(() => {
    jest.resetAllMocks();
  });

  describe('getUsers', () => {
    it('should return an array of users', async () => {
      // Arrange
      const users:UserEntity[] = [
        {
         id: 1,
         username: 'Jane Smith',
         password: 'password',
         email: 'jane@smith.com',
         is_active: true,
         email_confirmed: null,
         reset_token: 'reset_token',
         reset_token_expiry: null,
         avatar: 'avatar'
        },
        {
          id: 2,
          username: 'Yehor Zhvarnytskyi',
          password: 'password',
          email: 'yehor@smith.com',
          is_active: true,
          email_confirmed: null,
          reset_token: 'reset_token',
          reset_token_expiry: null,
          avatar: 'avatar'
        },
      ];
      jest.spyOn(repository, 'getAll').mockResolvedValue(users);

      // Act
      const result = await service.getUsers();

      // Assert
      expect(result).toEqual(users);
    });
  });

  describe('getUser', () => {
    it('should return a user by id', async () => {
      // Arrange
      const user = {
        user_guid: '123',
        name: 'John Doe',
        avatar: 'avatar',
        email: 'john@doe.com',
        password: 'password',
        is_active: true,
        email_verified_at: null,
      };
      const userId = 1;
      jest.spyOn(repository, 'getById').mockResolvedValue(user);

      // Act
      const result = await service.getUser(userId);

      // Assert
      expect(result).toEqual(user);
    });

    it('should throw BadRequestException if user does not exist', async () => {
      // Arrange
      const userId = 1;
      jest.spyOn(repository, 'getById').mockResolvedValue(null);

      // Act and Assert
      await expect(service.getUser(userId)).rejects.toThrow(
        `The user with id ${userId} does not exist`,
      );
    });
  })
});
