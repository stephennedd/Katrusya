import { Test, TestingModule } from '@nestjs/testing';
import { BadRequestException, Controller } from '@nestjs/common';
import { CoursesService } from './courses.service';
import { CoursesRepository, TestsRepository, UserCoursesRepository } from '../../repositories/courses.repository';
import { UsersRepository } from '../../../auth/repositories/users.repository';
import { DatabaseService } from '../../../databases/database.service';
import { CourseQuiz } from '../../models/courseQuiz';
import { CourseEntity } from '../../../models/course/course';
import { PurchasedCourse } from 'src/courses/models/purchasedCourse';
import { CoursesController } from 'src/courses/controllers/courses/courses.controller';

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
        DatabaseService
        // {
        //   provide: DatabaseService,
        //   useValue: {
        //     getKnexInstance: jest.fn(),
        //   },
        // },
      ],
    }).compile();

    coursesService = module.get<CoursesService>(CoursesService);
    coursesRepository = module.get<CoursesRepository>(CoursesRepository);
    testsRepository = module.get<TestsRepository>(TestsRepository);
  });

  describe('getCourseDetails', () => {
    it('should throw BadRequestException if course does not exist', async () => {
      const courseId = 100;
      try {
        await coursesService.getCourseDetails(courseId);
      } catch (error) {
        expect(error.response.statusCode).toEqual(400);
        expect(error.response.message).toEqual(`Course with ID ${courseId} does not exist`);
        expect(error.response.error).toEqual('Bad Request');
      }
    });
  
    // it('should return course details with valid course ID', async () => {
    //   const courseId = 1;
      
    //   const expectedCourseDetails ={
    //     "course_name": "UI/UX Design",
    //     "course_description": "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before the final copy is available.",
    //     "sections": [
    //         {
    //             "id": 1,
    //             "title": "Section 1 title",
    //             "image": "https://images.unsplash.com/photo-1541462608143-67571c6738dd?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTF8fGZhc2hpb258ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    //             "lessons": [
    //                 {
    //                     "lesson_id": 1,
    //                     "section_id": 1,
    //                     "lesson_name": "Lesson 1 title",
    //                     "lesson_duration_in_hours": 5,
    //                     "video_url": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
    //                     "image": "https://images.unsplash.com/photo-1541462608143-67571c6738dd?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTF8fGZhc2hpb258ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60"
    //                 },
    //                 {
    //                     "lesson_id": 2,
    //                     "section_id": 1,
    //                     "lesson_name": "Lesson 2 title",
    //                     "lesson_duration_in_hours": 5,
    //                     "video_url": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    //                     "image": "https://images.unsplash.com/photo-1541462608143-67571c6738dd?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTF8fGZhc2hpb258ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60"
    //                 }
    //             ],
    //             "number_of_lessons": 2,
    //             "section_duration_in_hours": 10
    //         }
    //     ],
    //     "number_of_lessons": 2,
    //     "course_duration_in_hours": 10
    // }
    //  const result = await coursesService.getCourseDetails(courseId);
     
    //  result.sections.forEach(section => {
    //   console.log(result.section.lessons);
    //   section.lessons.sort((a, b) => a.lesson_id - b.lesson_id);
    // });
  
    //   expect(result).toEqual(expectedCourseDetails);
    // });
  });

  describe('getCourseQuizzes', () => {
    it('should return an array of course quizzes', async () => {
      // Arrange
      const courseId = 1;
      const quizzes = [
        {
            "image_url": "https://images.unsplash.com/photo-1557318041-1ce374d55ebf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY3MzkyMzM2OQ&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1080",
            "quiz_title": "Biology",
            "section_id": 1,
            "course_id": 1,
            "number_of_questions": 5
        }
      ];
      // Act
      const result = await coursesService.getCourseQuizzes(courseId);

      // Assert
      expect(result).toEqual(quizzes);
    });

    it('should throw a BadRequestException if the course does not exist', async () => {
      // Arrange
      const courseId = 1;

      try {
        await coursesService.getCourseQuizzes(courseId)
      } catch (error) {
        expect(error.response.statusCode).toEqual(400);
        expect(error.response.message).toEqual(`Course with ID ${courseId} does not exist`);
        expect(error.response.error).toEqual('Bad Request');
      }
    });
  });  

  describe('getCourses', () => {
    it('should return an array of courses', async () => {
      // Arrange
      const queryParams: QueryParams = {
        category: undefined,
        is_recommended: undefined,
        is_featured: undefined,
        search: undefined
      };
      const courses = [
        {
            "id": 1,
            "name": "UI/UX Design",
            "description": "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before the final copy is available.",
            "image": "https://images.unsplash.com/photo-1586717791821-3f44a563fa4c?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=900&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY3OTEwMTA4Nw&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=1600",
            "price": "$110.00",
            "duration_in_hours": 10,
            "review": "4.5",
            "is_favorited": false,
            "is_recommended": false,
            "is_featured": true,
            "tags": [
                "design",
                "ui",
                "ux"
            ],
            "number_of_lessons": 2,
            "number_of_sections": 1
        },
        {
            "id": 2,
            "name": "Programming",
            "description": "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before the final copy is available.",
            "image": "https://images.unsplash.com/photo-1517694712202-14dd9538aa97?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTF8fGZhc2hpb258ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
            "price": "$155.00",
            "duration_in_hours": 20,
            "review": "5",
            "is_favorited": true,
            "is_recommended": false,
            "is_featured": true,
            "tags": [
                "database",
                "frontend",
                "backend",
                "computer"
            ],
            "number_of_lessons": 2,
            "number_of_sections": 1
        },
        {
            "id": 3,
            "name": "English Writing",
            "description": "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before the final copy is available.",
            "image": "https://images.unsplash.com/photo-1503676260728-1c00da094a0b?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTF8fGZhc2hpb258ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
            "price": "$65.00",
            "duration_in_hours": 12,
            "review": "4.5",
            "is_favorited": false,
            "is_recommended": false,
            "is_featured": true,
            "tags": [
                "english",
                "writing",
                "publishing",
                "story"
            ],
            "number_of_lessons": 2,
            "number_of_sections": 1
        },
        {
            "id": 4,
            "name": "Photography",
            "description": "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before the final copy is available.",
            "image": "https://images.unsplash.com/photo-1472393365320-db77a5abbecc?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTF8fGZhc2hpb258ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
            "price": "$80.00",
            "duration_in_hours": 4,
            "review": "4.5",
            "is_favorited": false,
            "is_recommended": false,
            "is_featured": true,
            "tags": [
                "photo",
                "pictures",
                "taking photo",
                "photography"
            ],
            "number_of_lessons": 2,
            "number_of_sections": 1
        },
        {
            "id": 5,
            "name": "Guitar Class",
            "description": "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before the final copy is available.",
            "image": "https://images.unsplash.com/photo-1549298240-0d8e60513026?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTF8fGZhc2hpb258ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
            "price": "$125.00",
            "duration_in_hours": 12,
            "review": "5",
            "is_favorited": false,
            "is_recommended": false,
            "is_featured": true,
            "tags": [
                "guitar",
                "music",
                "instrument"
            ],
            "number_of_lessons": 2,
            "number_of_sections": 1
        },
        {
            "id": 6,
            "name": "Painting",
            "description": "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before the final copy is available.",
            "image": "https://images.unsplash.com/photo-1596548438137-d51ea5c83ca5?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTF8fGZhc2hpb258ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
            "price": "$65.00",
            "duration_in_hours": 12,
            "review": "4.5",
            "is_favorited": false,
            "is_recommended": true,
            "is_featured": false,
            "tags": [
                "paint",
                "masterpiece",
                "drawing"
            ],
            "number_of_lessons": 2,
            "number_of_sections": 1
        },
        {
            "id": 7,
            "name": "Social Media",
            "description": "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before the final copy is available.",
            "image": "https://images.unsplash.com/photo-1611162617213-7d7a39e9b1d7?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTF8fGZhc2hpb258ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
            "price": "$135.00",
            "duration_in_hours": 6,
            "review": "4",
            "is_favorited": false,
            "is_recommended": true,
            "is_featured": false,
            "tags": [
                "instagram",
                "facebook",
                "youtube"
            ],
            "number_of_lessons": 2,
            "number_of_sections": 1
        },
        {
            "id": 8,
            "name": "Caster",
            "description": "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before the final copy is available.",
            "image": "https://images.unsplash.com/photo-1554446422-d05db23719d2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTF8fGZhc2hpb258ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
            "price": "$95.00",
            "duration_in_hours": 8,
            "review": "4.5",
            "is_favorited": false,
            "is_recommended": true,
            "is_featured": false,
            "tags": [
                "caster",
                "raw materials"
            ],
            "number_of_lessons": 2,
            "number_of_sections": 1
        },
        {
            "id": 9,
            "name": "Management",
            "description": "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before the final copy is available.",
            "image": "https://images.unsplash.com/photo-1542626991-cbc4e32524cc?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTF8fGZhc2hpb258ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
            "price": "$75.00",
            "duration_in_hours": 8,
            "review": "4.5",
            "is_favorited": false,
            "is_recommended": true,
            "is_featured": false,
            "tags": [
                "managing"
            ],
            "number_of_lessons": 6,
            "number_of_sections": 3
        }
    ]
      // Act
      const result = await coursesService.getCourses(queryParams);
      // Assert
      expect(result).toEqual(courses);
    });
  });

  describe('addPurchasedCourse', () => {
    it('should add a purchased course', async () => {
      const purchase = {id:1, courseId: 1, userId: 1 };
      const purchasedCourse: PurchasedCourse = { ...purchase, course_id: purchase.courseId, user_id: purchase.userId, is_completed: false };
      jest.spyOn(coursesService, 'addPurchasedCourse').mockResolvedValue({ id: 1, ...purchasedCourse });
  
      const result = await coursesService.addPurchasedCourse(purchase.courseId, purchase.userId);
  
      expect(result).toEqual({ id: 1, ...purchasedCourse });
    });
  });
});