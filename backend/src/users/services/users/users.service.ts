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
    const addedUser = await this.usersRepository.create(user);
    return addedUser;
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
    const favoriteCourses = 
    await this.userFavoriteCoursesRepository.getFavoriteCourses(userId);
    return favoriteCourses;
  }

  async getUserCourses(userId:number): Promise<any>{
    const user = await this.usersRepository.getById(userId);
    if(!user){
      throw new BadRequestException(`The user with id ${userId} does not exist`);
    }
    const courses = await this.coursesRepository.getUserCourses(userId);
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
    
    await this.userFavoriteCoursesRepository.addUserFavoriteCourse(userId,courseId);

    const addedUserFavoritedCourse =await this.userFavoriteCoursesRepository.getUpdatedUserFavoritedCourse(userId,courseId);
    
  return addedUserFavoritedCourse;
  }

  async deleteCompletedByUserLesson(userId:number,completedLessonDto: AddCompletedLessonDto): Promise<any>{
    const userOwnsCourse = await this.userCoursesRepository.doesUserOwnCourse(userId,completedLessonDto.course_id);  
    if(!userOwnsCourse){
      throw new BadRequestException('User does not own the course');
    }
  
    const userExists = await this.usersRepository.doesUserExist(userId);  
      if (!userExists) {
        throw new BadRequestException('User not found');
      }

      const courseExists = await this.coursesRepository.getById(completedLessonDto.course_id);
    if(!courseExists){
      throw new BadRequestException(`The course with id ${completedLessonDto.course_id} does not exist`);
    }
  
      const lessonExists = await this.lessonsRepository.doesLessonExist(completedLessonDto.lesson_id);

      if (!lessonExists) {
        throw new HttpException('Lesson not found', HttpStatus.NOT_FOUND);
      }
      
      const sectionExists =await this.sectionsRepository.doesSectionExist(completedLessonDto.section_id);  
      if (!sectionExists) {
        throw new HttpException('Section not found', HttpStatus.NOT_FOUND);
      }

    const lessonExistsInSection = await this.lessonsRepository.doesLessonExistsInSection(completedLessonDto.lesson_id,completedLessonDto.section_id)

   if (!lessonExistsInSection) {
     throw new HttpException('Lesson not found in the section', HttpStatus.NOT_FOUND);
   }
   
   const sectionExistsInCourse = await this.sectionsRepository.doesSectionExistsInCourse(completedLessonDto.section_id,
    completedLessonDto.course_id);

   if (!sectionExistsInCourse) {
     throw new HttpException('Section not found in the course', HttpStatus.NOT_FOUND);
   }

    const wasSectionCompleted = await this.isSectionCompletedByUser(userId,completedLessonDto.section_id);
    const wasCourseCompleted = await this.isCourseCompletedByUser(userId,completedLessonDto.course_id);
  
    await this.userCompletedLessonsRepository.deleteUserCompletedLesson(
      userId,completedLessonDto.lesson_id,completedLessonDto.section_id
    )
    const isSectionCompleted = await this.isSectionCompletedByUser(userId,completedLessonDto.section_id);
    if(wasSectionCompleted&&!isSectionCompleted){
      await this.userCompletedSectionsRepository.deleteUserCompletedSection(userId,completedLessonDto.course_id,
        completedLessonDto.section_id);
    }

    const isCourseCompleted = await this.isCourseCompletedByUser(userId,completedLessonDto.course_id);
    if(wasCourseCompleted&&!isCourseCompleted){
      await this.userCoursesRepository.markUserCourseAsUncompleted(userId,completedLessonDto.course_id);
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
    if(!userOwnsCourse){
      throw new HttpException('User does not own the course', HttpStatus.BAD_REQUEST);
    }
    const completedLessons = await this.userCompletedLessonsRepository.getCompletedLessons(userId,courseId);
  return completedLessons;
  }

  async getCompleteByUserSections(userId: number): Promise<any>{
    const user = await this.usersRepository.getById(userId);
    if(!user){
      throw new BadRequestException(`The user with id ${userId} does not exist`);
    }
    const completedSections = await this.userCompletedSectionsRepository.getCompletedSections(userId)
    return completedSections;
  }

  async addCompletedByUserLesson(userId:number,completedLessonDto: AddCompletedLessonDto): Promise<any>{  
    const userOwnsCourse = await this.userCoursesRepository.doesUserOwnCourse(userId,completedLessonDto.course_id);
  if(!userOwnsCourse){
    throw new HttpException('User does not own the course', HttpStatus.BAD_REQUEST);
  }

  const userExists =await this.usersRepository.doesUserExist(userId);

    if (!userExists) {
      throw new HttpException('User not found', HttpStatus.NOT_FOUND);
    }

    const lessonExists = await this.lessonsRepository.doesLessonExist(completedLessonDto.lesson_id);

    const courseExists = await this.coursesRepository.getById(completedLessonDto.course_id);
    if(!courseExists){
      throw new BadRequestException(`The course with id ${completedLessonDto.course_id} does not exist`);
    }  

    if (!lessonExists) {
      throw new HttpException('Lesson not found', HttpStatus.NOT_FOUND);
    }

    const sectionExists = await this.sectionsRepository.doesSectionExist(completedLessonDto.section_id);

    if (!sectionExists) {
      throw new HttpException('Section not found', HttpStatus.NOT_FOUND);
    }

    const lessonExistsInSection = await this.lessonsRepository.doesLessonExistsInSection(completedLessonDto.lesson_id,
      completedLessonDto.section_id); 
    
   if (!lessonExistsInSection) {
     throw new HttpException('Lesson not found in the section', HttpStatus.NOT_FOUND);
   }

   const sectionExistsInCourse = await this.sectionsRepository.doesSectionExistsInCourse(
    completedLessonDto.section_id,
    completedLessonDto.course_id
   )
   
   if (!sectionExistsInCourse) {
     throw new HttpException('Section not found in the course', HttpStatus.NOT_FOUND);
   }

    const userCompletedLesson = {
      user_id:parseInt(userId.toString(), 10),
      lesson_id: completedLessonDto.lesson_id,
      section_id: completedLessonDto.section_id,
    };
    
    await this.userCompletedLessonsRepository.addUserCompletedLesson(userCompletedLesson);

    const isSectionCompletedByUser = await this.isSectionCompletedByUser(userId,completedLessonDto.section_id);

    if(isSectionCompletedByUser){
      const userCompletedSection = {
        user_id:userId,
        section_id: completedLessonDto.section_id,
        course_id: completedLessonDto.course_id,
      };
      await this.userCompletedSectionsRepository.addUserCompletedSection(userCompletedSection);
    
      const isCourseCompletedByUser = await this.isCourseCompletedByUser(userId,completedLessonDto.course_id);

      if(isCourseCompletedByUser){
        await this.userCoursesRepository.markUserCourseAsCompleted(userId,completedLessonDto.course_id);
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
  
  const completedLessons = await this.userCompletedLessonsRepository.getCompletedLessonsToKnowWhetherSectionIsCompleted(lessonsInThisSection,userId)
  
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
    const completedSections = await this.userCompletedSectionsRepository.getCompletedSectionsToKnowWhetherSectionIsCompleted(sectionsInThisCourse,userId);
  
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
   
    await this.userFavoriteCoursesRepository.deleteUserFavoriteCourse(userId,courseId);
  return deletedUserFavoriteCourse;
  }

  async flipTeacherMode(userId: number): Promise<any>{
    const user = await this.usersRepository.getById(userId);
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
}

async deleteUser(id: number): Promise<string> {
  const user: User = await this.usersRepository.getById(id);
  if (!user) {
    throw new BadRequestException(`User with ID ${id} does not exist`);
  }
  await this.usersRepository.delete(id);
  return `User with ID ${id} deleted`;
}

}
