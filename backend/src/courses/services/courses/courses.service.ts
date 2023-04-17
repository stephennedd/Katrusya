import { BadRequestException, Injectable } from '@nestjs/common';
import { UsersRepository } from '../../../auth/repositories/users.repository';
import { Course } from '../../models/course';
import { CourseDetails, Section } from '../../models/courseDetails';
import { CourseQuiz } from '../../models/courseQuiz';
import { CoursesRepository, TestsRepository, UserCoursesRepository } from '../../repositories/courses.repository';
import { DatabaseService } from '../../../databases/database.service';
import { PurchasedCourse } from '../../models/purchasedCourse';


interface QueryParams{
    category?: string,
    is_recommended?: boolean,
    is_featured?: boolean,
    search?:string
}

@Injectable()
export class CoursesService {

    constructor(private readonly dbService: DatabaseService,
      private readonly coursesRepository: CoursesRepository,
      private readonly userCoursesRepository: UserCoursesRepository,
      private readonly testsRepository: TestsRepository,
      private readonly usersRepository: UsersRepository) {} 
  
async addPurchasedCourse(courseId: number, userId: number) {
  const courseExists = await this.coursesRepository.getById(courseId);
  if (!courseExists) {
    throw new BadRequestException(`Course with ID ${courseId} does not exist`);
  }
  
  const userExists = await this.usersRepository.getById(userId);
  
  if (!userExists) {
    throw new BadRequestException(`User with ID ${userId} does not exist`);
  }
  
    try { 
    const result = await this.userCoursesRepository.addUserCourse(courseId,userId);
    const addedPurchasedCourse: PurchasedCourse = {
      id: result[0],
      course_id: courseId,
      user_id: userId,
      is_completed: false,
    };
    return addedPurchasedCourse;
}catch (err) { 
    // Check if the error is a unique constraint violation error
    if (err.sqlState === '23000' && err.code === 'ER_DUP_ENTRY') {
        const message = `The user with ID ${userId} has already purchased the course with ID ${courseId}`;
        throw new BadRequestException(message);
      } else {
      return {
        success: false,
        error: 'An error occurred while adding the course to the user',
      };
    }
  }
  }

  async getCourseQuizzes(courseId: number): Promise<any>{
    const courseExists = await this.coursesRepository.getById(courseId);
  if (!courseExists) {
    throw new BadRequestException(`Course with ID ${courseId} does not exist`);
  }
    const result = await this.testsRepository.getCourseQuizzes(courseId);
   
      const quizzes: CourseQuiz[] = result.map((quiz) => ({
        image_url:quiz.image_url,
        quiz_title: quiz.quiz_title,
        section_id: quiz.section_id,
        course_id: quiz.course_id,
        number_of_questions: quiz.number_of_questions,
      }));
      
    return quizzes;
  }

async getCourseDetails(courseId: number): Promise<any>{
  const courseExists = await this.coursesRepository.getById(courseId);
  if (!courseExists) {
    throw new BadRequestException(`Course with ID ${courseId} does not exist`);
  }
const result = await this.coursesRepository.getCourseDetails(courseId);

const course: CourseDetails = {
  course_name: result[0].course_name,
  course_description: result[0].course_description,
  sections: [],
  number_of_lessons: 0,
  course_duration_in_hours: 0
};

let currentSection: Section = {id:0,title: "",  image: "", lessons: [], number_of_lessons: 0, section_duration_in_hours: 0};
for (const row of result) {
  if (currentSection.id !== row.section_id) {
    currentSection = {id:row.section_id, title: row.section_title, image: row.section_image, lessons: [], number_of_lessons: 0, section_duration_in_hours: 0 };
    course.sections.push(currentSection);
  }
  currentSection.lessons.push({lesson_id:row.lesson_id,section_id: row.section_id,lesson_name: row.lesson_name, lesson_duration_in_hours: row.lesson_duration_in_hours, video_url: row.video_url, image: row.lesson_image });
  currentSection.number_of_lessons = currentSection.number_of_lessons + 1;
  currentSection.section_duration_in_hours = currentSection.section_duration_in_hours + row.lesson_duration_in_hours
  course.number_of_lessons = course.number_of_lessons+1;
  course.course_duration_in_hours = course.course_duration_in_hours + row.lesson_duration_in_hours;
}

return course;
}
 
  async getCourses(queryParams: QueryParams): Promise<any>{  
   let query = await this.coursesRepository.getCourses(queryParams);
   const courses:Course[] = (await query).map(course => {
    return {
      id: course.id,
      name: course.name,
      description: course.description,
      image: course.image,
      price: course.price,
      duration_in_hours: course.duration_in_hours,
      review: course.review,
      is_favorited: course.is_favorited === 1,
      is_recommended: course.is_recommended === 1,
      is_featured: course.is_featured === 1,
      tags: course.tags,
      number_of_lessons: course.number_of_lessons || 0,
      number_of_sections: course.number_of_sections || 0,
    };
  });
        return courses;
      }
    

    }
