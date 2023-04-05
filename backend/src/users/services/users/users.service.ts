import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import knex from 'knex';
import { AddCompletedLessonDto } from 'src/users/dtos/AddCompletedLesson.dtos';
import { DatabaseService } from '../../../databases/database.service';

interface User {
    user_guid: string;
    name: string;
    avatar: string;
    email: string;
    password: string;
    is_active: boolean;
    email_verified_at: string | null;
   // created_at: Date | null;
  }

  interface UserResult {
    user_id: number,
    test_id: number,
    number_of_hp_points: number
  }

@Injectable()
export class UsersService {
    
    constructor(private readonly dbService: DatabaseService) {}

    async getUsers(): Promise<any> {
        const knex = this.dbService.getKnexInstance();
        const users = await knex.select().from('users');
        return users;
      }

    async getUser(id: number): Promise<any> {
      const knex = this.dbService.getKnexInstance();
      const user = await knex('users').where({ id }).first();
      return user;
    }
  
    async getUserResults(userId: number, testId: number): Promise<any> {
        const knex = this.dbService.getKnexInstance();
        const userResults = await knex('user_results')
        .where({ user_id: userId, test_id: testId });
        return userResults;
   }

   async addUser(user: User): Promise<any> {
    const knex = this.dbService.getKnexInstance();
    const users = await knex('users').insert(user);
  }

  async addUserResult(userResult: UserResult): Promise<any> {
    const knex = this.dbService.getKnexInstance();
    const user_results = await knex('user_results').insert(userResult);
  }
  
  async deleteUserResult(result_id: number): Promise<any>{
    const knex = this.dbService.getKnexInstance();
  const rowsAffected = await knex('user_results').where({ id: result_id }).delete();
  return rowsAffected;
  }

  async isUserPurchasedTheCourse(user_id: number, course_id): Promise<any>{
    const knex = this.dbService.getKnexInstance();
    const purchase = await knex('user_courses')
    .select()
    .where({
      user_id: user_id,
      course_id: course_id
    })
    .first();
    
  return !!purchase;
  }

  async getUserFavoriteCourses(userId:number): Promise<any>{
    const knex = this.dbService.getKnexInstance();

    // const favoriteCourses = await knex.select(
    //   'courses.id as course_id',
    //   'courses.name as course_name',
    //   'courses.image as course_image',
    //   'courses.price as course_price',
    //   'courses.duration_in_hours',
    //   'courses.review as course_review'
    // ).from('user_favorite_courses')
    // .join('courses', 'courses.id', '=', 'user_favorite_courses.course_id')
    // .where('user_favorite_courses.user_id', userId);

    const favoriteCourses = await knex.select(
      'courses.id as course_id',
      'courses.name as course_name',
      'courses.image as course_image',
      'courses.price as course_price',
      knex.raw('COUNT(DISTINCT lessons.id) as number_of_lessons'),
      'courses.duration_in_hours',
      'courses.review as course_review'
    ).from('user_favorite_courses')
    .join('courses', 'courses.id', '=', 'user_favorite_courses.course_id')
    .leftJoin('sections', 'sections.course_id', '=', 'courses.id')
    .leftJoin('lessons', 'lessons.section_id', '=', 'sections.id')
    .where('user_favorite_courses.user_id', userId)
    .groupBy('courses.id');

    return favoriteCourses;
  }

  async getUserCourses(userId:number): Promise<any>{
    const knex = this.dbService.getKnexInstance();
    // const courses = await (await knex.select('courses.id as course_id',
    // // 'courses.number_of_lessons as number_of_lessons',
    //   'courses.name as course_name', 'courses.image as course_image',
    // 'user_courses.is_completed as is_completed')
    //   .from('courses')
    //   .join('user_courses', 'user_courses.course_id', '=', 'courses.id')
    //   .where('user_courses.user_id', '=', userId)
    //   .orderBy('user_courses.id', 'asc'))
    const courses = await (await knex.select(
      'courses.id as course_id',
      'courses.name as course_name',
      'courses.image as course_image',
      'user_courses.is_completed as is_completed',
      knex.raw('COUNT(DISTINCT lessons.id) as number_of_lessons'),
      knex.raw('COUNT(DISTINCT sections.id) as number_of_sections')
    )
      .from('courses')
      .join('user_courses', 'user_courses.course_id', '=', 'courses.id')
      .leftJoin('sections', 'sections.course_id', '=', 'courses.id')
      .leftJoin('lessons', 'lessons.section_id', '=', 'sections.id')
      .where('user_courses.user_id', '=', userId)
      .groupBy('courses.id')
      .orderBy('user_courses.id', 'asc'))
  .map((course) => {
    return {
      ...course,
      is_completed: course.is_completed ? true : false,
    };
  });

    return courses;
  }

  async addUserFavoriteCourse(userId: number, courseId: number): Promise<any>{
    const knex = this.dbService.getKnexInstance();
    
    await knex('user_favorite_courses').insert({
      user_id: userId, // the ID of the user who is adding the favorite course
      course_id: courseId // the ID of the course that the user is adding to their favorites
    });

    const updatedUserFavoritedCourse = await knex.select(
      'courses.id as course_id',
      'courses.name as course_name',
      'courses.image as course_image',
      'courses.price as course_price',
      knex.raw('COUNT(DISTINCT lessons.id) as number_of_lessons'),
      'courses.duration_in_hours',
      'courses.review as course_review'
    ).from('user_favorite_courses')
    .join('courses', 'courses.id', '=', 'user_favorite_courses.course_id')
    .leftJoin('sections', 'sections.course_id', '=', 'courses.id')
    .leftJoin('lessons', 'lessons.section_id', '=', 'sections.id')
    .where({ user_id: userId, 'user_favorite_courses.course_id': courseId })
    .orderBy('courses.id', 'desc') // sort by created_at column in descending order
    .first(); 
  return updatedUserFavoritedCourse;
  }

  async deleteCompletedByUserLesson(userId:number,completedLessonDto: AddCompletedLessonDto): Promise<any>{
    const knex = this.dbService.getKnexInstance();

    const userOwnsCourse = await knex('user_courses')
    .select('id')
    .where({
      user_id: userId,
      course_id: completedLessonDto.course_id
    })
    .first();
  
    if(!userOwnsCourse){
      throw new HttpException('User does not own the course', HttpStatus.BAD_REQUEST);
    }
  
    const userExists = await knex('users')
    .select('id')
    .where('id', userId)
    .first();
  
      if (!userExists) {
        throw new HttpException('User not found', HttpStatus.NOT_FOUND);
      }
  
      const lessonExists = await knex('lessons')
        .select('id')
        .where('id', completedLessonDto.lesson_id)
        .first();
  
      if (!lessonExists) {
        throw new HttpException('Lesson not found', HttpStatus.NOT_FOUND);
      }
  
      const sectionExists = await knex('sections')
        .select('id')
        .where('id', completedLessonDto.section_id)
        .first();
  
      if (!sectionExists) {
        throw new HttpException('Section not found', HttpStatus.NOT_FOUND);
      }

    const lessonExistsInSection = await knex('lessons')
  .select('id')
  .where('id', completedLessonDto.lesson_id)
  .andWhere('section_id', completedLessonDto.section_id)
  .first();

   if (!lessonExistsInSection) {
     throw new HttpException('Lesson not found in the section', HttpStatus.NOT_FOUND);
   }

   const sectionExistsInCourse = await knex('sections')
  .select('id')
  .where('id', completedLessonDto.section_id)
  .andWhere('course_id', completedLessonDto.course_id)
  .first();

   if (!sectionExistsInCourse) {
     throw new HttpException('Section not found in the course', HttpStatus.NOT_FOUND);
   }

    const wasSectionCompleted = await this.isSectionCompletedByUser(userId,completedLessonDto.section_id);
    const wasCourseCompleted = await this.isCourseCompletedByUser(userId,completedLessonDto.course_id);
    
   await knex('user_completed_lessons')
    .where({
      user_id: userId,
      lesson_id: completedLessonDto.lesson_id,
      section_id: completedLessonDto.section_id,
    })
    .delete(); 

    const isSectionCompleted = await this.isSectionCompletedByUser(userId,completedLessonDto.section_id);
    
    if(wasSectionCompleted&&!isSectionCompleted){
    await knex('user_completed_sections')
    .where({
      user_id: userId,
      course_id: completedLessonDto.course_id,
      section_id: completedLessonDto.section_id,
    })
    .delete();
    }

    const isCourseCompleted = await this.isCourseCompletedByUser(userId,completedLessonDto.course_id);
    
    if(wasCourseCompleted&&!isCourseCompleted){
    await knex('user_courses')
    .where({
      user_id: userId,
      course_id: completedLessonDto.course_id
    })
    .update({
      is_completed: false
    }); 
  }
  const deletedElement = {
    user_id:parseInt(userId.toString(), 10),
    lesson_id: completedLessonDto.lesson_id,
    section_id: completedLessonDto.section_id,
  };

  deletedElement['course_id'] = completedLessonDto.course_id; 
  return deletedElement;
  }

  async getCompleteByUserLessonsForCertainCourse(userId: number, courseId: number): Promise<any>{
    const knex = this.dbService.getKnexInstance();
    const userOwnsCourse = await knex('user_courses')
    .select('id')
    .where({
      user_id: userId,
      course_id: courseId
    })
    .first();
  
    if(!userOwnsCourse){
      throw new HttpException('User does not own the course', HttpStatus.BAD_REQUEST);
    }
    const completedLessons = await knex('user_completed_lessons')
  .select('user_completed_lessons.user_id','user_completed_lessons.lesson_id','user_completed_lessons.section_id',
  'sections.course_id')
  .join('sections', 'sections.id', '=', 'user_completed_lessons.section_id')
  .where({
    'user_completed_lessons.user_id': userId,
    'sections.course_id': courseId
  })
  .orderBy('user_completed_lessons.lesson_id', 'asc');
  return completedLessons;
  }

  async getCompleteByUserSections(userId: number): Promise<any>{
    const knex = this.dbService.getKnexInstance();
  
    const completedSections = await knex('user_completed_sections')
  .select('user_completed_sections.user_id','user_completed_sections.section_id',
  'user_completed_sections.course_id')
  .where({
    'user_completed_sections.user_id': userId
  })
  .orderBy('user_completed_sections.section_id', 'asc');
  return completedSections;
  }

  async addCompletedByUserLesson(userId:number,completedLessonDto: AddCompletedLessonDto): Promise<any>{
    const knex = this.dbService.getKnexInstance();
   
      const userOwnsCourse = await knex('user_courses')
  .select('id')
  .where({
    user_id: userId,
    course_id: completedLessonDto.course_id
  })
  .first();

  if(!userOwnsCourse){
    throw new HttpException('User does not own the course', HttpStatus.BAD_REQUEST);
  }

  const userExists = await knex('users')
  .select('id')
  .where('id', userId)
  .first();

    if (!userExists) {
      throw new HttpException('User not found', HttpStatus.NOT_FOUND);
    }

    const lessonExists = await knex('lessons')
      .select('id')
      .where('id', completedLessonDto.lesson_id)
      .first();

    if (!lessonExists) {
      throw new HttpException('Lesson not found', HttpStatus.NOT_FOUND);
    }

    const sectionExists = await knex('sections')
      .select('id')
      .where('id', completedLessonDto.section_id)
      .first();

    if (!sectionExists) {
      throw new HttpException('Section not found', HttpStatus.NOT_FOUND);
    }

    const lessonExistsInSection = await knex('lessons')
  .select('id')
  .where('id', completedLessonDto.lesson_id)
  .andWhere('section_id', completedLessonDto.section_id)
  .first();

   if (!lessonExistsInSection) {
     throw new HttpException('Lesson not found in the section', HttpStatus.NOT_FOUND);
   }

   const sectionExistsInCourse = await knex('sections')
  .select('id')
  .where('id', completedLessonDto.section_id)
  .andWhere('course_id', completedLessonDto.course_id)
  .first();

   if (!sectionExistsInCourse) {
     throw new HttpException('Section not found in the course', HttpStatus.NOT_FOUND);
   }

    const userCompletedLesson = {
      user_id:parseInt(userId.toString(), 10),
      lesson_id: completedLessonDto.lesson_id,
      section_id: completedLessonDto.section_id,
    };
    await knex('user_completed_lessons').insert(userCompletedLesson);
    const isSectionCompletedByUser = await this.isSectionCompletedByUser(userId,completedLessonDto.section_id);

    if(isSectionCompletedByUser){
      const userCompletedSection = {
        user_id:userId,
        section_id: completedLessonDto.section_id,
        course_id: completedLessonDto.course_id,
      };
      await knex('user_completed_sections').insert(userCompletedSection);

      const isCourseCompletedByUser = await this.isCourseCompletedByUser(userId,completedLessonDto.course_id);

      if(isCourseCompletedByUser){
        await knex('user_courses')
        .where({
          user_id: userId,
          course_id: completedLessonDto.course_id
        })
        .update({
          is_completed: true
        }); 
      }
    }

    userCompletedLesson['course_id'] = completedLessonDto.course_id; 
    return userCompletedLesson;
  }

  async isSectionCompletedByUser(userId:number,sectionId:number): Promise<boolean> {
    const knex = this.dbService.getKnexInstance();

    const lessonsInThisSection = await knex('lessons')
    .select('id')
    .where('section_id', sectionId);
  
  const completedLessons = await knex('user_completed_lessons')
    .whereIn('lesson_id', lessonsInThisSection.map(l => l.id))
    .andWhere('user_id', userId);
  
  return lessonsInThisSection.length === completedLessons.length;
  }

  async isCourseCompletedByUser(userId:number,courseId:number): Promise<Boolean> {
    const knex = this.dbService.getKnexInstance();

    const sectionsInThisCourse = await knex('sections')
    .select('id')
    .where('course_id', courseId);
  
  const completedSections = await knex('user_completed_sections')
    .whereIn('section_id', sectionsInThisCourse.map(s => s.id))
    .andWhere('user_id', userId);
  
  return sectionsInThisCourse.length === completedSections.length;
  }

  async deleteUserFavoriteCourse(userId: number, courseId: number): Promise<any>{
    const knex = this.dbService.getKnexInstance();
    
    const deletedUserFavoriteCourse = await knex.select(
      'courses.id as course_id',
      'courses.name as course_name',
      'courses.image as course_image',
      'courses.price as course_price',
      knex.raw('COUNT(DISTINCT lessons.id) as number_of_lessons'),
      'courses.duration_in_hours',
      'courses.review as course_review'
    ).from('user_favorite_courses')
    .join('courses', 'courses.id', '=', 'user_favorite_courses.course_id')
    .leftJoin('sections', 'sections.course_id', '=', 'courses.id')
      .leftJoin('lessons', 'lessons.section_id', '=', 'sections.id')
      .where({
        user_id: userId,
        'user_favorite_courses.course_id': courseId
      })
      .then(rows => {
        const [deletedRow] = rows;
        return deletedRow;
      });

    await knex('user_favorite_courses')
  .where({
    user_id: userId,
    course_id: courseId
  })
  .del();
 
  return deletedUserFavoriteCourse;
  }
  

}
