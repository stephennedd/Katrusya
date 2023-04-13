import { Test, TestingModule } from '@nestjs/testing';
import { UsersController } from './users.controller';
import { UsersService } from '../../services/users/users.service';
import { CoursesRepository, TestsRepository } from '../../../courses/repositories/courses.repository';
import { DatabaseService } from '../../../databases/database.service';
import { LessonsRepository, SectionsRepository } from '../../../sections/repositories/sections.repository';
import {UserCoursesRepository, UserFavoriteCoursesRepository, UserCompletedLessonsRepository, UserCompletedSectionsRepository, UserResultsRepository, UserLessonsRepository, UsersRepository } from '../../../users/repositories/users.repository';
import { CreateUserDto } from 'src/dto/create-user.dto';
import { CreateUserResultsDto } from 'src/users/dtos/CreateUserResults.dtos';
import { AddCompletedLessonDto } from 'src/users/dtos/AddCompletedLesson.dtos';
import { AddFavoriteCourseDto } from 'src/users/dtos/AddFavoriteCourse.dtos';

describe('UsersController', () => {
  let controller: UsersController;
  let service: UsersService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [UsersController],
      providers: [UsersService,UsersRepository,
        UserFavoriteCoursesRepository,UserCompletedLessonsRepository,
      UserCompletedSectionsRepository,UserCoursesRepository,
      UserResultsRepository,CoursesRepository,
      LessonsRepository,SectionsRepository,UserLessonsRepository,
      TestsRepository,{
        provide: DatabaseService,
        useValue: {}, // Provide a mock object here
      },],
    }).compile();

    controller = module.get<UsersController>(UsersController);
    service = module.get<UsersService>(UsersService);
  });

  describe('getUsers', () => {
    it('should return an array of users', async () => {
      const users = [{ name: 'User 1' }, { name: 'User 2' }];
      jest.spyOn(service, 'getUsers').mockResolvedValue(users);

      expect(await controller.getUsers()).toBe(users);
    });
  });

  describe('getFavoriteCourses', () => {
    it('should return an array of favorite courses for a given user', async () => {
      const userId = 1;
      const favoriteCourses = [{ id: 1, name: 'Course 1' }, { id: 2, name: 'Course 2' }];

      jest.spyOn(service, 'getUserFavoriteCourses').mockResolvedValue(favoriteCourses);

      expect(await controller.getFavoriteCourses(userId)).toEqual(favoriteCourses);
    });
  });

  describe('getUserCourses', () => {
    it('should return an array of courses for a given user', async () => {
      // Arrange
      const userId = 1;
      const expectedResponse = Promise.resolve([
        { id: 1, name: 'Course 1' },
        { id: 2, name: 'Course 2' },
      ]);
      jest.spyOn(service, 'getUserCourses').mockImplementation(() => expectedResponse);

      // Act
      const result = await controller.getUserCourses(userId);

      // Assert
      expect(result).toEqual( [{"id": 1, "name": "Course 1"}, {"id": 2, "name": "Course 2"}]);
    });
  });

  describe('getUserResults', () => {
    it('should return the results of a test for a given user', async () => {
      // Arrange
      const userId = 1;
      const testId = 1;
      const expectedResponse = Promise.resolve([
        { id: 1, name: 'Course 1' },
        { id: 2, name: 'Course 2' },
      ]);
      jest.spyOn(service, 'getUserResults').mockImplementation(() => expectedResponse);

      // Act
      const result = await controller.getUserResults(userId, testId);

      // Assert
      expect(result).toEqual([{"id": 1, "name": "Course 1"}, {"id": 2, "name": "Course 2"}]);
    });
  });

  it('should return whether the user has purchased the course or not', async () => {
    // Arrange
    const userId = 1;
    const courseId = 2;
    const expectedResponse = true;
    jest.spyOn(service, 'hasUserPurchasedTheCourse').mockImplementation(() => Promise.resolve(expectedResponse));

    // Act
    const result = await controller.hasUserPurchasedTheCourse(userId, courseId);

    // Assert
    expect(result).toEqual(expectedResponse);
  });

  describe('getUser', () => {
    it('should return a user object for the given user id', async () => {
      // Arrange
      const userId = 1;
      const expectedResponse = { id: 1, name: 'John Doe', email: 'johndoe@example.com' };
      jest.spyOn(service, 'getUser').mockImplementation(() => Promise.resolve(expectedResponse));

      // Act
      const result = await controller.getUser(userId);

      // Assert
      expect(result).toEqual(expectedResponse);
    });
  });

  describe('getUserCompletedLessonsForCertainCourse', () => {
    it('should return the completed lessons for a user and a certain course', async () => {
      // Arrange
      const userId = 1;
      const courseId = 1;
      const expectedResponse = Promise.resolve([
        { id: 1, name: 'Lesson 1' },
        { id: 2, name: 'Lesson 2' },
      ]);
      jest.spyOn(service, 'getCompleteByUserLessonsForCertainCourse').mockImplementation(() => expectedResponse);

      // Act
      const result = await controller.getUserCompletedLessonsForCertainCourse(userId, courseId);

      // Assert
      expect(result).toStrictEqual([{ id: 1, name: 'Lesson 1' }, { id: 2, name: 'Lesson 2' }]);
    });
  });

  describe('getUserCompletedSectionsForCertainCourse', () => {
    it('should return the completed sections for a user', async () => {
      // Arrange
      const userId = 1;
      const expectedResponse = Promise.resolve([
        { id: 1, name: 'Section 1' },
        { id: 2, name: 'Section 2' },
      ]);
      jest.spyOn(service, 'getCompleteByUserSections').mockImplementation(() => expectedResponse);

      // Act
      const result = await controller.getUserCompletedSectionsForCertainCourse(userId);

      // Assert
      expect(result).toStrictEqual([{ id: 1, name: 'Section 1' }, { id: 2, name: 'Section 2' }]);
    });
  });

  describe('getIsSectionCompletedByUser', () => {
    it('should return whether a section is completed by a user', async () => {
      // Arrange
      const userId = 1;
      const sectionId = 1;
      const expectedResponse = Promise.resolve(true);
      jest.spyOn(service, 'isSectionCompletedByUser').mockImplementation(() => expectedResponse);

      // Act
      const result = await controller.getIsSectionCompletedByUser(userId, sectionId);

      // Assert
      expect(result).toBe(true);
    });
  });

  describe('getIsCourseCompletedByUser', () => {
    it('should return whether the course is completed by the user', async () => {
      // Arrange
      const userId = 1;
      const courseId = 1;
      const expectedResponse = Promise.resolve(true);
      jest.spyOn(service, 'isCourseCompletedByUser').mockImplementation(() => expectedResponse);

      // Act
      const result = await controller.getIsCourseCompletedByUser(userId, courseId);

      // Assert
      expect(result).toEqual(true);
    });
  });

  describe('createUser', () => {
    it('should create a new user', async () => {
      // Arrange
      const createUserDto: CreateUserDto = {
        email: 'smisha5000@gmail.com',
        username: 'zhvarikkk',
        phone: '0505670644',
        password: 'rtyeh323',
        created_at: undefined,
        balance_of_tokens: 0,
        roles: 'student'
      };
      const expectedResponse = Promise.resolve({ id: 1, ...createUserDto });
      jest.spyOn(service, 'addUser').mockImplementation(() => expectedResponse);

      // Act
      const result = await controller.createUser({ ...createUserDto } as any);

      // Assert
      expect(result).toEqual({ id: 1, ...createUserDto });
    });
  });

  describe('createUserResult', () => {
    it('should create a new user result', async () => {
      // Arrange
      const createUserResultsDto: CreateUserResultsDto = {
        user_id: 1,
        test_id: 1,
        number_of_hp_points: 100
      };
      const expectedResponse = Promise.resolve({ id: 1, ...createUserResultsDto });
      jest.spyOn(service, 'addUserResult').mockImplementation(() => expectedResponse);

      // Act
      const result = await controller.createUserResult({ ...createUserResultsDto } as any);

      // Assert
      expect(result).toEqual({ id: 1, ...createUserResultsDto });
    });
  });

  describe('addCompletedLesson', () => {
    it('should add a completed lesson for a user', async () => {
      // Arrange
      const userId = 1;
      const completedLessonDto: AddCompletedLessonDto = {
        lesson_id: 1,
        section_id: 1,
        course_id: 1
      };
      jest.spyOn(service, 'addCompletedByUserLesson').mockResolvedValueOnce(true);

      // Act
      const result = await controller.addCompletedLesson(
        userId,
        completedLessonDto,
      );

      // Assert
      expect(result).toEqual(true);
    });
  });

  describe('deleteCompletedLesson', () => {
    it('should delete a completed lesson for a user', async () => {
      // Arrange
      const userId = 1;
      const completedLessonDto: AddCompletedLessonDto = {
        lesson_id: 1,
        section_id: 1,
        course_id: 1
      };
      jest.spyOn(service, 'deleteCompletedByUserLesson').mockResolvedValueOnce(true);

      // Act
      const result = await controller.deleteCompletedLesson(
        userId,
        completedLessonDto,
      );

      // Assert
      expect(result).toEqual(true);
    });
  });

  describe('addFavoriteCourse', () => {
    it('should add a favorite course for a user', async () => {
      // Arrange
      const userId = 1;
      const addFavoriteCourseDto: AddFavoriteCourseDto = {
        course_id: 1,
      };
      jest.spyOn(service, 'addUserFavoriteCourse').mockResolvedValueOnce(true);

      // Act
      const result = await controller.addFavoriteCourse(
        userId,
        addFavoriteCourseDto,
      );

      // Assert
      expect(result).toEqual(true);
    });
  });

  describe('flipTeacherMode', () => {
    it('should flip user teacher mode', async () => {
      // Arrange
      const userId = 1;
      jest.spyOn(service, 'flipTeacherMode').mockResolvedValue(true);

      // Act
      const result = await controller.flipTeacherMode(userId);

      // Assert
      expect(result).toBe(true);
    });
  });

  describe('addTimestampOfLastViewedMomentOfLesson', () => {
    it('should return success message when record is inserted successfully', async () => {
      // Arrange
      const userId = 1;
      const lessonId = 1;
      jest.spyOn(service, 'addTimestampOfLastViewedMomentOfLesson').mockResolvedValue(null);

      // Act
      const result = await controller.addTimestampOfLastViewedMomentOfLesson(userId, lessonId);

      // Assert
      expect(result).toEqual({ message: 'Record inserted successfully!' });
    });

    it('should return error message when record insertion fails', async () => {
      // Arrange
      const userId = 1;
      const lessonId = 1;
      jest.spyOn(service, 'addTimestampOfLastViewedMomentOfLesson').mockRejectedValue(new Error('Database error'));

      // Act
      const result = await controller.addTimestampOfLastViewedMomentOfLesson(userId, lessonId);

      // Assert
      expect(result).toEqual({ message: 'Error inserting record' });
    });
  });

  describe('updateTimestampOfLastViewedMomentOfLesson', () => {
    it('should update timestamp of last viewed moment of lesson', async () => {
      const userId = 1;
      const lessonId = 2;
      const timestamp = new Date('2022-01-01T00:00:00Z');
      const spy = jest.spyOn(service, 'updateTimestampOfLastViewedMomentOfLesson').mockResolvedValueOnce(undefined);

      const result = await controller.updateTimestampOfLastViewedMomentOfLesson(userId, lessonId, timestamp);

      expect(spy).toHaveBeenCalledWith(userId, lessonId, timestamp);
      expect(result).toEqual({ message: 'Record updated successfully!' });
    });

    it('should return an error message when failed to update timestamp', async () => {
      const userId = 1;
      const lessonId = 2;
      const timestamp = new Date('2022-01-01T00:00:00Z');
      const errorMsg = 'Failed to update timestamp';
      const spy = jest.spyOn(service, 'updateTimestampOfLastViewedMomentOfLesson').mockRejectedValueOnce(errorMsg);

      const result = await controller.updateTimestampOfLastViewedMomentOfLesson(userId, lessonId, timestamp);

      expect(spy).toHaveBeenCalledWith(userId, lessonId, timestamp);
      expect(result).toEqual({ message: errorMsg });
    });
  });

  describe('getLastViewedMoment', () => {
    it('should return the timestamp of last viewed moment of the lesson', async () => {
      const userId = 1;
      const lessonId = 2;
      const timestamp = new Date('2022-01-01T00:00:00Z');
      const spy = jest.spyOn(service, 'getTimestampOfLastViewedMomentOfLesson').mockResolvedValueOnce(timestamp);

      const result = await controller.getLastViewedMoment(userId, lessonId);

      expect(spy).toHaveBeenCalledWith(userId, lessonId);
      expect(result).toEqual({ timestamp });
    });
  });

  describe('removeFavoriteCourse', () => {
    it('should remove the favorite course', async () => {
      const userId = 1;
      const courseId = 2;
      const spy = jest.spyOn(service, 'deleteUserFavoriteCourse').mockResolvedValueOnce(undefined);

      const result = await controller.removeFavoriteCourse(userId, courseId);

      expect(spy).toHaveBeenCalledWith(userId, courseId);
      expect(result).toBeUndefined();
    });
  });
});

