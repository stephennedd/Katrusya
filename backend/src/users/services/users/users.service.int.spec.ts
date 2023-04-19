import { Test, TestingModule } from '@nestjs/testing';
import { UsersService } from './users.service';
import { DatabaseService } from '../../../databases/database.service';


import { CoursesRepository, TestsRepository } from '../../../courses/repositories/courses.repository';
import { LessonsRepository, SectionsRepository } from '../../../sections/repositories/sections.repository';
import {UserCoursesRepository,UserFavoriteCoursesRepository, UserCompletedLessonsRepository, UserCompletedSectionsRepository, UserResultsRepository, UserLessonsRepository, UsersRepository } from '../../../users/repositories/users.repository';
import { BadRequestException, HttpException } from '@nestjs/common';
import { AddCompletedLessonDto } from 'src/users/dtos/AddCompletedLesson.dtos';

describe('UsersService', () => {
    let service: UsersService;
    let repository: UsersRepository;
    let databaseService: DatabaseService;
    let testsRepository: TestsRepository;
    let userFavoriteCoursesRepository: UserFavoriteCoursesRepository;
    let userCompletedLessonsRepository: UserCompletedLessonsRepository;
    let userCompletedSectionsRepository: UserCompletedSectionsRepository;
    let userCoursesRepository:UserCoursesRepository;
    let userResultsRepository:UserResultsRepository;
    let coursesRepository: CoursesRepository;
    let lessonsRepository: LessonsRepository;
    let sectionsRepository: SectionsRepository;
    let userLessonsRepository: UserLessonsRepository;
 
  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UsersService,
        DatabaseService,
        UsersRepository,
        UserFavoriteCoursesRepository,
        UserCompletedLessonsRepository,
        UserCompletedSectionsRepository,
        UserCoursesRepository,
        UserResultsRepository,
        CoursesRepository,
        LessonsRepository,
        SectionsRepository,
        UserLessonsRepository,
        TestsRepository,
        DatabaseService
      ],
    }).compile();

    service = module.get<UsersService>(UsersService);
    repository = module.get<UsersRepository>(UsersRepository);
    databaseService = module.get<DatabaseService>(DatabaseService);
    testsRepository = module.get<TestsRepository>(TestsRepository);
    userFavoriteCoursesRepository = module.get<UserFavoriteCoursesRepository>(UserFavoriteCoursesRepository);
    userCompletedLessonsRepository = module.get<UserCompletedLessonsRepository>(UserCompletedLessonsRepository);
    userCompletedSectionsRepository = module.get<UserCompletedSectionsRepository>(UserCompletedSectionsRepository);
    userCoursesRepository = module.get<UserCoursesRepository>(UserCoursesRepository);
    userResultsRepository = module.get<UserResultsRepository>(UserResultsRepository);
    coursesRepository = module.get<CoursesRepository>(CoursesRepository);
    lessonsRepository = module.get<LessonsRepository>(LessonsRepository);
    sectionsRepository = module.get<SectionsRepository>(SectionsRepository);
    userLessonsRepository = module.get<UserLessonsRepository>(UserLessonsRepository);

    //await databaseService.connect();
  });

  interface User {
    id: number,
    user_guid: string;
    name: string;
    avatar: string;
    email: string;
    password: string;
    is_active: boolean;
    email_verified_at: string | null;
    roles: string
   // created_at: Date | null;
  }

  interface UserResult {
    id:number,
    user_id: number,
    test_id: number,
    number_of_hp_points: number
  }

  describe('getUsers', () => {
    it('should return an array of sections', async () => {
      const users = await service.getUsers();

     // expect(users).toHaveLength(1);
      expect(users[0].name).toBe('Yehor');
      expect(users[0].email).toBe('smisha2000@gmail.com');
    });
  });

  describe('getUser', () => {
    it('should return a section by id', async () => {
      const users = await service.getUsers();
      const id = users[0].id;

      const user = await service.getUser(id);

      expect(user).toBeDefined();
      expect(user.name).toBe('Yehor');
    });

    it('should throw a 400 BadRequestError if the user does not exist', async () => {
        const id = 100;
      
       try {
          await service.getUser(id);

        } catch (error) {
          expect(error.response.statusCode).toEqual(400);
          expect(error.response.message).toEqual(`The user with id ${id} does not exist`);
          expect(error.response.error).toEqual('Bad Request');
        }
      });
  });

  describe('addUser', () => {
    it('should add a user to the database', async () => {
      const user:User = {
          id:2,
          user_guid: "slkfdlmfd",
          name: "Misha",
          avatar: "avatar",
          email: "smisha6000@gmail.com",
          password: "ritjngirjnfriejfnreijn",
          is_active: true,
          email_verified_at: '',
          roles:JSON.stringify(["student"])
      };
    //  const createSpy = jest.spyOn(repository, 'create').mockResolvedValue(user);

      const result = await service.addUser(user);

      expect(result.name).toEqual(user.name);
      expect(result.email).toEqual(user.email);
      expect(result.password).toEqual(user.password);
      expect(result.user_guid).toEqual(user.user_guid);
    });
  });

  describe('addUserResult', () => {
    it('should add a user result to the database', async () => {
      const userResult: UserResult = {
        id:1,
        user_id: 1,
        test_id: 1,
        number_of_hp_points: 100,
      };
     
      const result = await service.addUserResult(userResult);

      expect(result).toEqual(userResult);
      
    });

    it('should throw a BadRequestException if the user has already completed the quiz', async () => {
      const userResult: UserResult = {
        id:1,
        user_id: 1,
        test_id: 1,
        number_of_hp_points: 100,
      };
    //  const doesUserCompleteTestSpy = jest.spyOn(userResultsRepository, 'doesUserCompleteTest').mockResolvedValue({});

      try {
        await service.addUserResult(userResult);
      } catch (error) {
        expect(error).toBeInstanceOf(BadRequestException);
        expect(error.message).toEqual('User has already completed the quiz');
      }
    });
  });

  describe('getUserResults', () => {
    it('should return the user results', async () => {
      const userId = 1;
      const testId = 1;
      const score = 100
      
      const userResults = await service.getUserResults(userId, testId);

      expect(userResults[0].user_id).toEqual(userId);
      expect(userResults[0].number_of_hp_points).toEqual(score);
      expect(userResults[0].test_id).toEqual(testId);
    });

    it('should throw a BadRequestException if the user does not exist', async () => {
      const userId = 100;
      const testId = 1;

      try {
        await service.getUserResults(userId, testId);
      } catch (error) {
        expect(error).toBeInstanceOf(BadRequestException);
        expect(error.message).toEqual(`The user with id ${userId} does not exist`);
      }
    });

    it('should throw a BadRequestException if the test does not exist', async () => {
      const userId = 1;
      const testId = 100;
 
      try {
        await service.getUserResults(userId, testId);
      } catch (error) {
        expect(error).toBeInstanceOf(BadRequestException);
        expect(error.message).toEqual(`The test with id ${testId} does not exist`);
      }
    });

    it('should throw a BadRequestException if the user does not own the test', async () => {
      const userId = 1;
      const testId = 2;

      try {
        await service.getUserResults(userId, testId);
      } catch (error) {
        expect(error).toBeInstanceOf(BadRequestException);
        expect(error.message).toEqual(`The user with id ${userId} does not own the test with id ${testId}`);
      }
    });
  });

  describe('hasUserPurchasedCourse', () => {
    it('should return true when the user has purchased the course', async () => {
        const userId = 1;
        const courseId = 1;
      // Check if the user has purchased the course
      const result = await service.hasUserPurchasedTheCourse(userId,courseId);
      expect(result).toBe(true);
    });

    it('should return false when the user has not purchased the course', async () => {
        const userId = 1;
        const courseId = 2;
      // Check if the user has purchased the course
      const result = await service.hasUserPurchasedTheCourse(userId,courseId);
      expect(result).toBe(false);
    });

    it('should throw a BadRequestException when the user does not exist', async () => {
      const user_id = 100;
      const course_id = 1;

      await expect(service.hasUserPurchasedTheCourse(user_id, course_id)).rejects.toThrow(
        new BadRequestException(`The user with id ${user_id} does not exist`),
      );
    });

    it('should throw a BadRequestException when the course does not exist', async () => {
      const user_id = 1;
      const course_id = 456;

      await expect(service.hasUserPurchasedTheCourse(user_id, course_id)).rejects.toThrow(
        new BadRequestException(`The course with id ${course_id} does not exist`),
      );
    });
  });

  describe('addUserFavoriteCourse', () => {
    it('should add a course to the user favorites', async () => {
      const userId = 1;
      const courseId = 2;

      const result = await service.addUserFavoriteCourse(userId, courseId);
      expect(result).toBeDefined();
      expect(result.course_id).toEqual(courseId);
    });

    it('should throw a BadRequestException if the user does not exist', async () => {
      const userId = 100;
      const courseId = 1;

      await expect(
        service.addUserFavoriteCourse(userId, courseId),
      ).rejects.toThrow(BadRequestException);
    });

    it('should throw a BadRequestException if the course does not exist', async () => {
      const userId = 1;
      const courseId = 100;

      await expect(
        service.addUserFavoriteCourse(userId, courseId),
      ).rejects.toThrow(BadRequestException);
    });
  });

  describe('addCompletedByUserLesson', () => {
    it('should add a completed lesson by the user', async () => {
      const userId = 1;
      const completedLessonDto: AddCompletedLessonDto = {
          lesson_id: 1,
          section_id: 1,
          course_id: 1
      }

      const result = await service.addCompletedByUserLesson(userId, completedLessonDto);
      expect(result).toBeDefined();
      expect(result.course_id).toEqual(completedLessonDto.course_id);
    });

    it('should throw a BadRequestException if the user does not exist', async () => {
      const userId = 100;
      const completedLessonDto: AddCompletedLessonDto = {
        lesson_id: 1,
        section_id: 1,
        course_id: 1
    }

      await expect(
        service.addCompletedByUserLesson(userId, completedLessonDto),
      ).rejects.toThrow(HttpException);
    });

    it('should throw a BadRequestException if the course does not exist', async () => {
      const userId = 1
      const completedLessonDto: AddCompletedLessonDto = {
        lesson_id: 1,
        section_id: 1,
        course_id: 100
    }

      await expect(
        service.addCompletedByUserLesson(userId, completedLessonDto),
      ).rejects.toThrow(HttpException);
    });
  });

  describe('getUserCourses', () => {
    it('should return an array of user favorite courses', async () => {
      const userId = 1;
      const courseId = 1;

      const result = await service.getUserCourses(userId);

      expect(result).toBeDefined();
      expect(Array.isArray(result)).toBe(true);
      expect(result[0].course_id).toEqual(courseId);
    });
});

  describe('getFavoriteCourses', () => {
    it('should return an array of user favorite courses', async () => {
      const userId = 1;
      const courseId = 2;

      const result = await service.getUserFavoriteCourses(userId);

      expect(result).toBeDefined();
      expect(Array.isArray(result)).toBe(true);
      expect(result[0].course_id).toEqual(courseId);
    });
});

describe('getCompleteByUserLessonsForCertainCourse', () => {
    it('should return an array of completed lessons for a user and a course', async () => {

      // Call the function being tested
      const result = await service.getCompleteByUserLessonsForCertainCourse(1, 1);
      const expectedResult = [{ user_id: 1, lesson_id: 1, section_id: 1, course_id: 1 }];

      expect(result).toBeDefined();
      expect(Array.isArray(result)).toBe(true);
      expect(result).toEqual(expectedResult)
    });

    it('should throw a BadRequestException if the user does not exist', async () => {
      // Call the function being tested with a non-existent user
      const userId = 100;
      const courseId = 1;
      await expect(service.getCompleteByUserLessonsForCertainCourse(userId, courseId)).rejects.toThrowError(new BadRequestException(`The user with id ${userId} does not exist`));
    });

    it('should throw a BadRequestException if the course does not exist', async () => {
      const courseId = 100;
      await expect(service.getCompleteByUserLessonsForCertainCourse(1, courseId)).rejects.toThrowError(new BadRequestException(`The course with id ${courseId} does not exist`));
    });

});

describe('getIsSectionCompletedByUser', () => {
    it('should return false if user has not completed all lessons in the section', async () => {
  
        // Check if the section is completed by the user
        const isSectionCompleted = await service.isSectionCompletedByUser(1, 1);
        expect(isSectionCompleted).toBe(false);
      });
    
    
    it('should return true if user has completed all lessons in the section', async () => {
        const userId = 1;
        const completedLessonDto: AddCompletedLessonDto = {
            lesson_id: 2,
            section_id: 1,
            course_id: 1
        }
  
        const result = await service.addCompletedByUserLesson(userId, completedLessonDto);
      // Check if the section is completed by the user
      const isSectionCompleted = await service.isSectionCompletedByUser(1, 1);
      expect(isSectionCompleted).toBe(true);
    });

    it('should throw BadRequestException if user or section does not exist', async () => {
      // Call the method with a non-existing user id
      await expect(service.isSectionCompletedByUser(999, 1)).rejects.toThrow(BadRequestException);
      
      // Call the method with a non-existing section id
      await expect(service.isSectionCompletedByUser(1, 999)).rejects.toThrow(BadRequestException);
    });

});

describe('getIsCourseCompletedByUser', () => { 
    // it('should return true if user has completed all sections in the course', async () => {
    //   const isCourseCompletedByUser = await service.isCourseCompletedByUser(1, 1);
    //   expect(isCourseCompletedByUser).toBe(true);

    // });

    it('should throw BadRequestException if user or section does not exist', async () => {
      // Call the method with a non-existing user id
      await expect(service.isCourseCompletedByUser(999, 1)).rejects.toThrow(BadRequestException);
      
      // Call the method with a non-existing section id
      await expect(service.isCourseCompletedByUser(1, 999)).rejects.toThrow(BadRequestException);
    });
});

describe('deleteCompletedLesson', () => {
    it('should delete a lesson from the user completed lessons', async () => {
      const userId = 1;

      const completedLessonDto: AddCompletedLessonDto = {
        lesson_id: 1,
        section_id: 1,
        course_id: 1
    }

      const result = await service.deleteCompletedByUserLesson(userId, completedLessonDto);
  
      expect(result).toBeDefined();
      expect(result.course_id).toEqual(completedLessonDto.course_id);
    });

    it('should delete a lesson from the user completed lessons', async () => {
        const userId = 1;
  
        const completedLessonDto: AddCompletedLessonDto = {
          lesson_id: 2,
          section_id: 1,
          course_id: 1
      }
  
        const result = await service.deleteCompletedByUserLesson(userId, completedLessonDto);
  
        expect(result).toBeDefined();
        expect(result.course_id).toEqual(completedLessonDto.course_id);
      });

    it('should throw a BadRequestException if the user does not exist', async () => {
      const userId = 100;
      const completedLessonDto: AddCompletedLessonDto = {
        lesson_id: 1,
        section_id: 1,
        course_id: 1
    }

      await expect(
        service.deleteCompletedByUserLesson(userId, completedLessonDto),
      ).rejects.toThrow(BadRequestException);
    });
  });

  describe('isCourseCompletedByUser', () => { 
    it('should return false if user has not completed all sections in the course', async () => {
      const isCourseCompletedByUser = await service.isCourseCompletedByUser(1, 1);
      expect(isCourseCompletedByUser).toBe(false);
    });

    it('should throw BadRequestException if user or section does not exist', async () => {
      // Call the method with a non-existing user id
      await expect(service.isCourseCompletedByUser(999, 1)).rejects.toThrow(BadRequestException);
      
      // Call the method with a non-existing section id
      await expect(service.isCourseCompletedByUser(1, 999)).rejects.toThrow(BadRequestException);
    });
});

  describe('deleteUserFavoriteCourse', () => {
    it('should delete a course from the user favorites', async () => {
      const userId = 1;
      const courseId = 2;

      const result = await service.deleteUserFavoriteCourse(userId, courseId);

      expect(result).toBeDefined();
      expect(result.course_id).toEqual(courseId);
    });

    it('should throw a BadRequestException if the user does not exist', async () => {
      const userId = 100;
      const courseId = 1;

      await expect(
        service.deleteUserFavoriteCourse(userId, courseId),
      ).rejects.toThrow(BadRequestException);
    });

    it('should throw a BadRequestException if the course does not exist', async () => {
      const userId = 1;
      const courseId = 100;

      await expect(
        service.deleteUserFavoriteCourse(userId, courseId),
      ).rejects.toThrow(BadRequestException);
    });
  });

  describe('deleteUserResult', () => {
    it('should delete a user result by id', async () => {
      // Arrange
      const result_id = 1;
      // Act
      const rowsAffected = await service.deleteUserResult(result_id);
      expect(rowsAffected).toEqual(1);
    });

    it('should throw a BadRequestException if the user result does not exist', async () => {
      // Arrange
      const result_id = 100;
    
      // Act & Assert
      await expect(service.deleteUserResult(result_id)).rejects.toThrowError(BadRequestException);
    });
  });
  describe('flipTeacherMode', () => {
    it('should flip user roles from student to teacher or teacher to student', async () => {
      // Arrange
      const userId = 2;
      const updatedRoles = ['teacher'];
 
 
      // Act
      const result = await service.flipTeacherMode(userId);
  
      // Assert
      expect(result).toEqual(updatedRoles);
    });
  
    it('should throw BadRequestException if the user does not exist', async () => {
      // Arrange
      const userId = 100;
      // Act & Assert
      await expect(service.flipTeacherMode(userId)).rejects.toThrow(BadRequestException);
    });
  });
  describe('deleteUser', () => {
    it('should delete a user by id', async () => {
      
      // Act
      const result = await service.deleteUser(2);

      // Assert
      expect(result).toEqual(`User with ID ${2} deleted`);

      
      const deletedUser = await repository.getById(2);
      expect(deletedUser).toBeUndefined();

      try {
        await service.deleteUser(100);
      } catch (error) {
        expect(error).toBeInstanceOf(BadRequestException);
        expect(error.message).toEqual(`User with ID ${100} does not exist`);
      }
    });
  });
});