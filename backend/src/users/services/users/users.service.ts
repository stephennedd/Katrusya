import { BadRequestException, HttpException, HttpStatus, Injectable } from '@nestjs/common';
import knex from 'knex';
import { AddCompletedLessonDto } from '../../../users/dtos/AddCompletedLesson.dtos';
import { DatabaseService } from '../../../databases/database.service';
import { UserCompletedLessonsRepository, UserCompletedSectionsRepository, UserCoursesRepository, UserFavoriteCoursesRepository, UserLessonsRepository, UserResultsRepository, UsersRepository } from '../../../users/repositories/users.repository';
import { LessonsRepository, SectionsRepository } from '../../../sections/repositories/sections.repository';
import { CoursesRepository, TestsRepository } from '../../../courses/repositories/courses.repository';

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
    
    constructor(private readonly dbService: DatabaseService,
      private readonly usersRepository: UsersRepository,
      private readonly userResultsRepository: UserResultsRepository,
      private readonly userFavoriteCoursesRepository: UserFavoriteCoursesRepository,
      private readonly userCompletedLessonsRepository: UserCompletedLessonsRepository,
      private readonly userCompletedSectionsRepository: UserCompletedSectionsRepository,
      private readonly userCoursesRepository: UserCoursesRepository,
      private readonly coursesRepository: CoursesRepository,
      private readonly lessonsRepository: LessonsRepository,
      private readonly sectionsRepository: SectionsRepository,
      private readonly userLessonsRepository: UserLessonsRepository,
      private readonly testsRepository: TestsRepository) {}
      
    async getUsers(): Promise<any> {
        const users = await this.usersRepository.getAll();
        return users;
    }

    async getUser(id: number): Promise<any> {
      const user = await this.usersRepository.getById(id);
      if(!user){
        throw new BadRequestException(`The user with id ${id} does not exist`);
      }
      return user;
    }
  
    async getUserResults(userId: number, testId: number): Promise<any> {
      const user = await this.usersRepository.getById(userId);
      if(!user){
        throw new BadRequestException(`The user with id ${userId} does not exist`);
      } 

      const test = await this.testsRepository.getById(testId);
      if(!test){
        throw new BadRequestException(`The test with id ${testId} does not exist`);
      } 

      const result = await this.userCoursesRepository.doesUserOwnTest(userId,testId);
      if (result.length == 0) {
  throw new BadRequestException(`The user with id ${userId} does not own the test with id ${testId}`);
}
      const userResults = await this.userResultsRepository.getUserResults(userId,testId);
        return userResults;
   }

   async addUser(user: User): Promise<any> {
    const users = await this.usersRepository.create(user);
  }

  async addUserResult(userResult: UserResult): Promise<any> {
    const result = await this.userResultsRepository.doesUserCompleteTest(userResult.user_id,userResult.test_id);
 
  const hasUserAlreadyCompletedQuiz = Boolean(result);
  if(!hasUserAlreadyCompletedQuiz){
   await this.userResultsRepository.create(userResult);
    return userResult;
  } else{
    throw new BadRequestException('User has already completed the quiz');
  }
  }
  
  async deleteUserResult(result_id: number): Promise<any>{
    const userResult = await this.userResultsRepository.getById(result_id);
    if(!userResult){
      throw new BadRequestException(`The user result with id ${result_id} does not exist`);
    }
  const rowsAffected =await this.userResultsRepository.delete(result_id);
  //await knex('user_results').where({ id: result_id }).delete();
  return rowsAffected;
  }

  async hasUserPurchasedTheCourse(user_id: number, course_id:number): Promise<any>{
    const user = await this.usersRepository.getById(user_id);
    if(!user){
      throw new BadRequestException(`The user with id ${user_id} does not exist`);
    }

    const course = await this.coursesRepository.getById(course_id);
    if(!course){
      throw new BadRequestException(`The course with id ${course_id} does not exist`);
    }
    
    const purchase = await this.userCoursesRepository.hasUserPurchasedTheCourse(user_id,course_id);
    // await knex('user_courses')
    // .select()
    // .where({
    //   user_id: user_id,
    //   course_id: course_id
    // })
    // .first();
    
  return !!purchase;
  }

  async getUserFavoriteCourses(userId:number): Promise<any>{
    const user = await this.usersRepository.getById(userId);
    if(!user){
      throw new BadRequestException(`The user with id ${userId} does not exist`);
    }
    
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

    const favoriteCourses = 
    await this.userFavoriteCoursesRepository.getFavoriteCourses(userId);
    // await knex.select(
    //   'courses.id as course_id',
    //   'courses.name as course_name',
    //   'courses.image as course_image',
    //   'courses.price as course_price',
    //   knex.raw('COUNT(DISTINCT lessons.id) as number_of_lessons'),
    //   'courses.duration_in_hours',
    //   'courses.review as course_review'
    // ).from('user_favorite_courses')
    // .join('courses', 'courses.id', '=', 'user_favorite_courses.course_id')
    // .leftJoin('sections', 'sections.course_id', '=', 'courses.id')
    // .leftJoin('lessons', 'lessons.section_id', '=', 'sections.id')
    // .where('user_favorite_courses.user_id', userId)
    // .groupBy('courses.id');

    return favoriteCourses;
  }

  async getUserCourses(userId:number): Promise<any>{
    const user = await this.usersRepository.getById(userId);
    if(!user){
      throw new BadRequestException(`The user with id ${userId} does not exist`);
    }
    
    const courses = await this.coursesRepository.getUserCourses(userId);
  //   await (await knex.select(
  //     'courses.id as course_id',
  //     'courses.name as course_name',
  //     'courses.image as course_image',
  //     'user_courses.is_completed as is_completed',
  //     knex.raw('COUNT(DISTINCT lessons.id) as number_of_lessons'),
  //     knex.raw('COUNT(DISTINCT sections.id) as number_of_sections')
  //   )
  //     .from('courses')
  //     .join('user_courses', 'user_courses.course_id', '=', 'courses.id')
  //     .leftJoin('sections', 'sections.course_id', '=', 'courses.id')
  //     .leftJoin('lessons', 'lessons.section_id', '=', 'sections.id')
  //     .where('user_courses.user_id', '=', userId)
  //     .groupBy('courses.id')
  //     .orderBy('user_courses.id', 'asc'))
  // .map((course) => {
  //   return {
  //     ...course,
  //     is_completed: course.is_completed ? true : false,
  //   };
  // });

    return courses;
  }

  async addUserFavoriteCourse(userId: number, courseId: number): Promise<any>{
    const user = await this.usersRepository.getById(userId);
    if(!user){
      throw new BadRequestException(`The user with id ${userId} does not exist`);
    }

    const course = await this.coursesRepository.getById(courseId);
    if(!course){
      throw new BadRequestException(`The course with id ${courseId} does not exist`);
    }
    
    
    // await knex('user_favorite_courses').insert({
    //   user_id: userId, // the ID of the user who is adding the favorite course
    //   course_id: courseId // the ID of the course that the user is adding to their favorites
    // });

    await this.userFavoriteCoursesRepository.addUserFavoriteCourse(userId,courseId);

    const updatedUserFavoritedCourse =await this.userFavoriteCoursesRepository.getUpdatedUserFavoritedCourse(userId,courseId);
    // await knex.select(
    //   'courses.id as course_id',
    //   'courses.name as course_name',
    //   'courses.image as course_image',
    //   'courses.price as course_price',
    //   knex.raw('COUNT(DISTINCT lessons.id) as number_of_lessons'),
    //   'courses.duration_in_hours',
    //   'courses.review as course_review'
    // ).from('user_favorite_courses')
    // .join('courses', 'courses.id', '=', 'user_favorite_courses.course_id')
    // .leftJoin('sections', 'sections.course_id', '=', 'courses.id')
    // .leftJoin('lessons', 'lessons.section_id', '=', 'sections.id')
    // .where({ user_id: userId, 'user_favorite_courses.course_id': courseId })
    // .orderBy('courses.id', 'desc') // sort by created_at column in descending order
    // .first(); 
  return updatedUserFavoritedCourse;
  }

  async deleteCompletedByUserLesson(userId:number,completedLessonDto: AddCompletedLessonDto): Promise<any>{
    const userOwnsCourse = await this.userCoursesRepository.doesUserOwnCourse(userId,completedLessonDto.course_id);
    // await knex('user_courses')
    // .select('id')
    // .where({
    //   user_id: userId,
    //   course_id: completedLessonDto.course_id
    // })
    // .first();
  
    if(!userOwnsCourse){
      throw new BadRequestException('User does not own the course');
    }
  
    const userExists = await this.usersRepository.doesUserExist(userId);
    // await knex('users')
    // .select('id')
    // .where('id', userId)
    // .first();
  
      if (!userExists) {
        throw new BadRequestException('User not found');
      }

      const courseExists = await this.coursesRepository.getById(completedLessonDto.course_id);
    if(!courseExists){
      throw new BadRequestException(`The course with id ${completedLessonDto.course_id} does not exist`);
    }
  
      const lessonExists = await this.lessonsRepository.doesLessonExist(completedLessonDto.lesson_id);
      // await knex('lessons')
      //   .select('id')
      //   .where('id', completedLessonDto.lesson_id)
      //   .first();
  
      if (!lessonExists) {
        throw new HttpException('Lesson not found', HttpStatus.NOT_FOUND);
      }
      
      const sectionExists =await this.sectionsRepository.doesSectionExist(completedLessonDto.section_id);
      // await knex('sections')
      //   .select('id')
      //   .where('id', completedLessonDto.section_id)
      //   .first();
  
      if (!sectionExists) {
        throw new HttpException('Section not found', HttpStatus.NOT_FOUND);
      }

    const lessonExistsInSection = await this.lessonsRepository.doesLessonExistsInSection(completedLessonDto.lesson_id,completedLessonDto.section_id)

    //   await knex('lessons')
  // .select('id')
  // .where('id', completedLessonDto.lesson_id)
  // .andWhere('section_id', completedLessonDto.section_id)
  // .first();

   if (!lessonExistsInSection) {
     throw new HttpException('Lesson not found in the section', HttpStatus.NOT_FOUND);
   }
   
   const sectionExistsInCourse = await this.sectionsRepository.doesSectionExistsInCourse(completedLessonDto.section_id,
    completedLessonDto.course_id);
  //  await knex('sections')
  // .select('id')
  // .where('id', completedLessonDto.section_id)
  // .andWhere('course_id', completedLessonDto.course_id)
  // .first();

   if (!sectionExistsInCourse) {
     throw new HttpException('Section not found in the course', HttpStatus.NOT_FOUND);
   }

    const wasSectionCompleted = await this.isSectionCompletedByUser(userId,completedLessonDto.section_id);
    const wasCourseCompleted = await this.isCourseCompletedByUser(userId,completedLessonDto.course_id);
  
    await this.userCompletedLessonsRepository.deleteUserCompletedLesson(
      userId,completedLessonDto.lesson_id,completedLessonDto.section_id
    )
  //  await knex('user_completed_lessons')
  //   .where({
  //     user_id: userId,
  //     lesson_id: completedLessonDto.lesson_id,
  //     section_id: completedLessonDto.section_id,
  //   })
  //   .delete(); 

    const isSectionCompleted = await this.isSectionCompletedByUser(userId,completedLessonDto.section_id);
    if(wasSectionCompleted&&!isSectionCompleted){
      await this.userCompletedSectionsRepository.deleteUserCompletedSection(userId,completedLessonDto.course_id,
        completedLessonDto.section_id);
    // await knex('user_completed_sections')
    // .where({
    //   user_id: userId,
    //   course_id: completedLessonDto.course_id,
    //   section_id: completedLessonDto.section_id,
    // })
    // .delete();
    }

    const isCourseCompleted = await this.isCourseCompletedByUser(userId,completedLessonDto.course_id);
    if(wasCourseCompleted&&!isCourseCompleted){
      await this.userCoursesRepository.markUserCourseAsUncompleted(userId,completedLessonDto.course_id);
    // await knex('user_courses')
    // .where({
    //   user_id: userId,
    //   course_id: completedLessonDto.course_id
    // })
    // .update({
    //   is_completed: false
    // }); 
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
    const user = await this.usersRepository.getById(userId);
    if(!user){
      throw new BadRequestException(`The user with id ${userId} does not exist`);
    }

    const course = await this.coursesRepository.getById(courseId);
    if(!course){
      throw new BadRequestException(`The course with id ${courseId} does not exist`);
    }
    
    const userOwnsCourse = await this.userCoursesRepository.doesUserOwnCourse(userId,courseId);
    //await knex('user_courses')
    // .select('id')
    // .where({
    //   user_id: userId,
    //   course_id: courseId
    // })
    // .first();
  
    if(!userOwnsCourse){
      throw new HttpException('User does not own the course', HttpStatus.BAD_REQUEST);
    }
    const completedLessons = await this.userCompletedLessonsRepository.getCompletedLessons(userId,courseId);
  //   await knex('user_completed_lessons')
  // .select('user_completed_lessons.user_id','user_completed_lessons.lesson_id','user_completed_lessons.section_id',
  // 'sections.course_id')
  // .join('sections', 'sections.id', '=', 'user_completed_lessons.section_id')
  // .where({
  //   'user_completed_lessons.user_id': userId,
  //   'sections.course_id': courseId
  // })
  // .orderBy('user_completed_lessons.lesson_id', 'asc');
  return completedLessons;
  }

  async getCompleteByUserSections(userId: number): Promise<any>{
    const user = await this.usersRepository.getById(userId);
    if(!user){
      throw new BadRequestException(`The user with id ${userId} does not exist`);
    }

    const completedSections = await this.userCompletedSectionsRepository.getCompletedSections(userId)
  //   await knex('user_completed_sections')
  // .select('user_completed_sections.user_id','user_completed_sections.section_id',
  // 'user_completed_sections.course_id')
  // .where({
  //   'user_completed_sections.user_id': userId
  // })
  // .orderBy('user_completed_sections.section_id', 'asc');
  return completedSections;
  }

  async addCompletedByUserLesson(userId:number,completedLessonDto: AddCompletedLessonDto): Promise<any>{  
    const userOwnsCourse = await this.userCoursesRepository.doesUserOwnCourse(userId,completedLessonDto.course_id);
      
  //     await knex('user_courses')
  // .select('id')
  // .where({
  //   user_id: userId,
  //   course_id: completedLessonDto.course_id
  // })
  // .first();

  if(!userOwnsCourse){
    throw new HttpException('User does not own the course', HttpStatus.BAD_REQUEST);
  }

  const userExists =await this.usersRepository.doesUserExist(userId);
  // await knex('users')
  // .select('id')
  // .where('id', userId)
  // .first();

    if (!userExists) {
      throw new HttpException('User not found', HttpStatus.NOT_FOUND);
    }

    const lessonExists = await this.lessonsRepository.doesLessonExist(completedLessonDto.lesson_id);

    const courseExists = await this.coursesRepository.getById(completedLessonDto.course_id);
    if(!courseExists){
      throw new BadRequestException(`The course with id ${completedLessonDto.course_id} does not exist`);
    }  
    
    // await knex('lessons')
    //   .select('id')
    //   .where('id', completedLessonDto.lesson_id)
    //   .first();

    if (!lessonExists) {
      throw new HttpException('Lesson not found', HttpStatus.NOT_FOUND);
    }

    const sectionExists = await this.sectionsRepository.doesSectionExist(completedLessonDto.section_id);
    
    // await knex('sections')
    //   .select('id')
    //   .where('id', completedLessonDto.section_id)
    //   .first();

    if (!sectionExists) {
      throw new HttpException('Section not found', HttpStatus.NOT_FOUND);
    }

    const lessonExistsInSection = await this.lessonsRepository.doesLessonExistsInSection(completedLessonDto.lesson_id,
      completedLessonDto.section_id); 
    
  //   await knex('lessons')
  // .select('id')
  // .where('id', completedLessonDto.lesson_id)
  // .andWhere('section_id', completedLessonDto.section_id)
  // .first();

   if (!lessonExistsInSection) {
     throw new HttpException('Lesson not found in the section', HttpStatus.NOT_FOUND);
   }

   const sectionExistsInCourse = await this.sectionsRepository.doesSectionExistsInCourse(
    completedLessonDto.section_id,
    completedLessonDto.course_id
   )
   
  //  await knex('sections')
  // .select('id')
  // .where('id', completedLessonDto.section_id)
  // .andWhere('course_id', completedLessonDto.course_id)
  // .first();

   if (!sectionExistsInCourse) {
     throw new HttpException('Section not found in the course', HttpStatus.NOT_FOUND);
   }

    const userCompletedLesson = {
      user_id:parseInt(userId.toString(), 10),
      lesson_id: completedLessonDto.lesson_id,
      section_id: completedLessonDto.section_id,
    };
    
    await this.userCompletedLessonsRepository.addUserCompletedLesson(userCompletedLesson);

   // await knex('user_completed_lessons').insert(userCompletedLesson);
    const isSectionCompletedByUser = await this.isSectionCompletedByUser(userId,completedLessonDto.section_id);

    if(isSectionCompletedByUser){
      const userCompletedSection = {
        user_id:userId,
        section_id: completedLessonDto.section_id,
        course_id: completedLessonDto.course_id,
      };
      await this.userCompletedSectionsRepository.addUserCompletedSection(userCompletedSection);
     // await knex('user_completed_sections').insert(userCompletedSection);

      const isCourseCompletedByUser = await this.isCourseCompletedByUser(userId,completedLessonDto.course_id);

      if(isCourseCompletedByUser){
        await this.userCoursesRepository.markUserCourseAsCompleted(userId,completedLessonDto.course_id);
        // await knex('user_courses')
        // .where({
        //   user_id: userId,
        //   course_id: completedLessonDto.course_id
        // })
        // .update({
        //   is_completed: true
        // }); 
      }
    }

    userCompletedLesson['course_id'] = completedLessonDto.course_id; 
    return userCompletedLesson;
  }

  async isSectionCompletedByUser(userId:number,sectionId:number): Promise<boolean> {

    const user = await this.usersRepository.getById(userId);
    if(!user){
      throw new BadRequestException(`The user with id ${userId} does not exist`);
    }

    const section = await this.sectionsRepository.getById(sectionId);
    if(!section){
      throw new BadRequestException(`The section with id ${sectionId} does not exist`);
    }
    
    const lessonsInThisSection = await this.lessonsRepository.getLessonsInSection(sectionId);
    
    // await knex('lessons')
    // .select('id')
    // .where('section_id', sectionId);
  
  const completedLessons = await this.userCompletedLessonsRepository.getCompletedLessonsToKnowWhetherSectionIsCompleted(lessonsInThisSection,userId)
  // await knex('user_completed_lessons')
  //   .whereIn('lesson_id', lessonsInThisSection.map(l => l.id))
  //   .andWhere('user_id', userId);
  
  return lessonsInThisSection.length === completedLessons.length;
  }

  async isCourseCompletedByUser(userId:number,courseId:number): Promise<Boolean> {
   
    const user = await this.usersRepository.getById(userId);
    if(!user){
      throw new BadRequestException(`The user with id ${userId} does not exist`);
    }

    const course = await this.coursesRepository.getById(courseId);
    if(!course){
      throw new BadRequestException(`The course with id ${courseId} does not exist`);
    }
    

    const sectionsInThisCourse = await this.sectionsRepository.getSectionsInCourse(courseId);
    // await knex('sections')
    // .select('id')
    // .where('course_id', courseId);
  
  const completedSections = await this.userCompletedSectionsRepository.getCompletedSectionsToKnowWhetherSectionIsCompleted(sectionsInThisCourse,userId);
  
  // await knex('user_completed_sections')
  //   .whereIn('section_id', sectionsInThisCourse.map(s => s.id))
  //   .andWhere('user_id', userId);
  
  return sectionsInThisCourse.length === completedSections.length;
  }

  async deleteUserFavoriteCourse(userId: number, courseId: number): Promise<any>{
    const user = await this.usersRepository.getById(userId);
    if(!user){
      throw new BadRequestException(`The user with id ${userId} does not exist`);
    }

    const course = await this.coursesRepository.getById(courseId);
    if(!course){
      throw new BadRequestException(`The course with id ${courseId} does not exist`);
    }
    const deletedUserFavoriteCourse = await this.userFavoriteCoursesRepository.getDeletedUserFavoriteCourse(userId,courseId);
    // await knex.select(
    //   'courses.id as course_id',
    //   'courses.name as course_name',
    //   'courses.image as course_image',
    //   'courses.price as course_price',
    //   knex.raw('COUNT(DISTINCT lessons.id) as number_of_lessons'),
    //   'courses.duration_in_hours',
    //   'courses.review as course_review'
    // ).from('user_favorite_courses')
    // .join('courses', 'courses.id', '=', 'user_favorite_courses.course_id')
    // .leftJoin('sections', 'sections.course_id', '=', 'courses.id')
    //   .leftJoin('lessons', 'lessons.section_id', '=', 'sections.id')
    //   .where({
    //     user_id: userId,
    //     'user_favorite_courses.course_id': courseId
    //   })
    //   .then(rows => {
    //     const [deletedRow] = rows;
    //     return deletedRow;
    //   });

    await this.userFavoriteCoursesRepository.deleteUserFavoriteCourse(userId,courseId);
  //   await knex('user_favorite_courses')
  // .where({
  //   user_id: userId,
  //   course_id: courseId
  // })
  // .del();
 
  return deletedUserFavoriteCourse;
  }

  async flipTeacherMode(userId: number): Promise<any>{
    const user = await this.usersRepository.getById(userId);
    // await knex('users')
    // .where({ id: userId })
    // .first();

  if (!user) {
    throw new BadRequestException(`User with ID ${userId} not found`);
  }

  const updatedRoles = user.roles.map(role => {
    if (role === 'student') {
      return 'teacher';
    } else if (role === 'teacher') {
      return 'student';
    } else {
      return role;
    }
  });

  const updatedRolesJson = JSON.stringify(updatedRoles);
  
  await this.usersRepository.updateUserRoles(updatedRolesJson,
    userId);

  // await knex('users')
  //   .where({ id: userId })
  //   .update({ roles: updatedRolesJson });

    return updatedRoles;
  }

  async addTimestampOfLastViewedMomentOfLesson(userId:number, lessonId: number): Promise<any>{
    const user = await this.usersRepository.getById(userId);
    if(!user){
      throw new BadRequestException(`The user with id ${userId} does not exist`);
    }

    const lesson = await this.lessonsRepository.getById(lessonId);
    if(!lesson){
      throw new BadRequestException(`The lesson with id ${lessonId} does not exist`);
    }
    await this.userLessonsRepository.addTimestampOfLastViewedMomentOfLesson(userId,lessonId);
    // await knex('user_lessons')
    // .insert({
    //   user_id: userId,
    //   lesson_id: lessonId,
    //   timestamp_of_last_viewed_moment: null
    // });
  } 

  async updateTimestampOfLastViewedMomentOfLesson(
    userId: number,
    lessonId: number,
    timestamp: Date,
  ): Promise<any> {
    const user = await this.usersRepository.getById(userId);
    if(!user){
      throw new BadRequestException(`The user with id ${userId} does not exist`);
    }

    const lesson = await this.lessonsRepository.getById(lessonId);
    if(!lesson){
      throw new BadRequestException(`The lesson with id ${lessonId} does not exist`);
    }
       return await this.userLessonsRepository.updateTimestampOfLastViewedMomentOfLesson(userId,lessonId,timestamp);
      //  await knex('user_lessons')
      // .where({ user_id: userId, lesson_id: lessonId })
      // .update({ timestamp_of_last_viewed_moment: timestamp });
}

async getTimestampOfLastViewedMomentOfLesson(userId: number, lessonId:number):Promise<any>{
  const user = await this.usersRepository.getById(userId);
    if(!user){
      throw new BadRequestException(`The user with id ${userId} does not exist`);
    }

    const lesson = await this.lessonsRepository.getById(lessonId);
    if(!lesson){
      throw new BadRequestException(`The lesson with id ${lessonId} does not exist`);
    }
    
  return await this.userLessonsRepository.getTimestampOfLastViewedMomentOfLesson(userId,lessonId);
  // await knex.select('timestamp_of_last_viewed_moment')
  // .from('user_lessons')
  // .where('user_id', userId)
  // .andWhere('lesson_id', lessonId)
  // .then(rows => {
  //   const timestamp = rows[0].timestamp_of_last_viewed_moment;
  //   const formattedTimestamp = timestamp.toISOString().slice(0, 19).replace('T', ' ');
  //   return formattedTimestamp
  // })
  // .catch(error => {
  //   console.error(error);
  // })
}

}
