import { Test, TestingModule } from '@nestjs/testing';
import { BadRequestException } from '@nestjs/common';
import { CoursesService } from './courses.service';
import { CoursesRepository, TestsRepository, UserCoursesRepository } from '../../repositories/courses.repository';
import { UsersRepository } from '../../../auth/repositories/users.repository';
import { DatabaseService } from '../../../databases/database.service';
import { CourseQuiz } from '../../models/courseQuiz';
import { CourseEntity } from '../../../models/course/course';

interface QueryParams{
  category?: string,
  is_recommended?: boolean,
  is_featured?: boolean,
  search?:string
}

describe('CoursesService', () => {
  let coursesService: CoursesService;
  let coursesRepository: CoursesRepository;
  let testsRepository: TestsRepository;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CoursesService,
        CoursesRepository,
        UserCoursesRepository,
        TestsRepository,
        UsersRepository,
        {
          provide: DatabaseService,
          useValue: {
            getKnexInstance: jest.fn(),
          },
        },
      ],
    }).compile();

    coursesService = module.get<CoursesService>(CoursesService);
    coursesRepository = module.get<CoursesRepository>(CoursesRepository);
    testsRepository = module.get<TestsRepository>(TestsRepository);
  });

  describe('getCourseDetails', () => {
    it('should throw BadRequestException if course does not exist', async () => {
      const courseId = 1;
      jest.spyOn(coursesRepository, 'getById').mockResolvedValueOnce(null);
  
      await expect(coursesService.getCourseDetails(courseId)).rejects.toThrow(
        new BadRequestException(`Course with ID ${courseId} does not exist`),
      );
    });
  
    it('should return course details with valid course ID', async () => {
      const courseId = 1;
      const courseDetails = {
        course_name: 'Example Course',
        course_description: 'This is an example course.',
        section_id: 1,
        section_title: 'Example Section 1',
        section_image: 'example-section-1.png',
        lesson_id: 1,
        lesson_name: 'Example Lesson 1',
        lesson_duration_in_hours: 1,
        video_url: 'https://example.com/example-video-1.mp4',
        lesson_image: 'example-lesson-1.png',
      };
      const expectedCourseDetails = {
        course_name: 'Example Course',
        course_description: 'This is an example course.',
        sections: [
          {
            id: 1,
            title: 'Example Section 1',
            image: 'example-section-1.png',
            lessons: [
              {
                lesson_id: 1,
                section_id: 1,
                lesson_name: 'Example Lesson 1',
                lesson_duration_in_hours: 1,
                video_url: 'https://example.com/example-video-1.mp4',
                image: 'example-lesson-1.png',
              },
            ],
            number_of_lessons: 1,
            section_duration_in_hours: 1,
          },
        ],
        number_of_lessons: 1,
        course_duration_in_hours: 1,
      };
      jest.spyOn(coursesRepository, 'getById').mockResolvedValueOnce(courseDetails);
     jest.spyOn(coursesRepository, 'getCourseDetails').mockResolvedValueOnce([courseDetails])
  
      const result = await coursesService.getCourseDetails(courseId);
  
      expect(result).toEqual(expectedCourseDetails);
    });
  });

  describe('getCourseQuizzes', () => {
    it('should return an array of course quizzes', async () => {
      // Arrange
      const courseId = 1;
      const quizzes = [
        {
          image_url: 'https://example.com/image1.jpg',
          quiz_title: 'Quiz 1',
          section_id: 1,
          course_id: 1,
          number_of_questions: 10,
        },
        {
          image_url: 'https://example.com/image2.jpg',
          quiz_title: 'Quiz 2',
          section_id: 2,
          course_id: 1,
          number_of_questions: 20,
        },
      ];
      const course: CourseEntity = Object.assign(new CourseEntity(), { id: courseId });
      jest.spyOn(coursesRepository, 'getById').mockResolvedValue(course);
      jest.spyOn(testsRepository, 'getCourseQuizzes').mockResolvedValue(quizzes);

      // Act
      const result = await coursesService.getCourseQuizzes(courseId);

      // Assert
      expect(result).toEqual(quizzes);
    });

    it('should throw a BadRequestException if the course does not exist', async () => {
      // Arrange
      const courseId = 1;
      jest.spyOn(coursesRepository, 'getById').mockResolvedValue(null);

      // Act and assert
      await expect(coursesService.getCourseQuizzes(courseId)).rejects.toThrow(
        new BadRequestException(`Course with ID ${courseId} does not exist`),
      );
    });
  });  

  describe('getCourses', () => {
    it('should return an array of courses', async () => {
      // Arrange
      const queryParams: QueryParams = {
        category: null,
        is_recommended: null,
        is_featured: null,
        search:null
      };
      const courses = [
        {
          id: 1,
          name: 'Course 1',
          description: 'Description 1',
          image: 'https://example.com/image1.jpg',
          price: 19.99,
          duration_in_hours: 20,
          review: 4.5,
          is_favorited: false,
          is_recommended: false,
          is_featured: false,
          tags: ['tag1', 'tag2'],
          number_of_lessons: 10,
          number_of_sections: 5,
        },
        {
          id: 2,
          name: 'Course 2',
          description: 'Description 2',
          image: 'https://example.com/image2.jpg',
          price: 29.99,
          duration_in_hours: 30,
          review: 4.8,
          is_favorited: false,
          is_recommended: false,
          is_featured: false,
          tags: ['tag3', 'tag4'],
          number_of_lessons: 15,
          number_of_sections: 7,
        },
      ];
      jest.spyOn(coursesRepository, 'getCourses').mockResolvedValue(courses);

      // Act
      const result = await coursesService.getCourses(queryParams);

      // Assert
      expect(result).toEqual(courses);
    });
  });
});
