import { Test, TestingModule } from '@nestjs/testing';
import { CoursesController } from './courses.controller';
import { CoursesService } from '../../services/courses/courses.service';
import { DatabaseService } from '../../../databases/database.service';
import { UsersRepository } from '../../../auth/repositories/users.repository';
import { CoursesRepository, UserCoursesRepository, TestsRepository } from '../../../courses/repositories/courses.repository';
import { PurchasedCourse } from '../../models/purchasedCourse';

describe('CoursesController', () => {
  let controller: CoursesController;
  let service: CoursesService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [CoursesController],
      providers: [CoursesService,DatabaseService, CoursesRepository,
        UsersRepository, UserCoursesRepository, TestsRepository],
    }).compile();

    controller = module.get<CoursesController>(CoursesController);
    service = module.get<CoursesService>(CoursesService);
  });

  describe('getCourseQuizzes', () => {
    it('should return an array of quizzes for a course', async () => {
      const quizzes = [{ id: 1, name: 'quiz 1' }, { id: 2, name: 'quiz 2' }];
      jest.spyOn(service, 'getCourseQuizzes').mockResolvedValue(quizzes);

      const result = await controller.getCourseQuizzes(1);

      expect(result).toBe(quizzes);
      expect(service.getCourseQuizzes).toHaveBeenCalledWith(1);
    });
  });

  describe('addPurchasedCourse', () => {
    it('should add a purchased course', async () => {
      const purchase = {id:1, courseId: 1, userId: 1 };
      const purchasedCourse: PurchasedCourse = { ...purchase, course_id: purchase.courseId, user_id: purchase.userId, is_completed: false };
      jest.spyOn(service, 'addPurchasedCourse').mockResolvedValue({ id: 1, ...purchasedCourse });
  
      const result = await controller.addPurchasedCourse(purchase);
  
      expect(result).toEqual({ id: 1, ...purchasedCourse });
      expect(service.addPurchasedCourse).toHaveBeenCalledWith(purchase.courseId, purchase.userId);
    });
  });

  describe('getCourses', () => {
    it('should return an array of courses', async () => {
      const courses = [{ id: 1, name: 'course 1' }, { id: 2, name: 'course 2' }];
      jest.spyOn(service, 'getCourses').mockResolvedValue(courses);

      const result = await controller.getCourses(false, true, 'category', 'search');

      expect(result).toBe(courses);
      expect(service.getCourses).toHaveBeenCalledWith({
        category: 'category',
        is_recommended: false,
        is_featured: true,
        search: 'search',
      });
    });
  });

  describe('getCourseDetails', () => {
    it('should return the details of a course', async () => {
      const courseDetails = { id: 1, name: 'course 1', description: 'course description' };
      jest.spyOn(service, 'getCourseDetails').mockResolvedValue(courseDetails);

      const result = await controller.getCourseDetails(1);

      expect(result).toBe(courseDetails);
      expect(service.getCourseDetails).toHaveBeenCalledWith(1);
    });
  });
});
