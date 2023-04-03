import { Injectable } from '@nestjs/common';
import knex from 'knex';
import { DatabaseService } from '../../../databases/database.service';

interface User {
    user_guid: string;
    name: string;
    avatar: string;
    email: string;
    password: string;
    is_active: boolean;
    email_verified_at: string | null;
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
    // const result = await knex('user_favorite_courses')
    // .where({ user_id: userId })
    // .select('course_id')

    const favoriteCourses = await knex.select(
      'courses.id as course_id',
      'courses.name as course_name',
      'courses.image as course_image',
      'courses.price as course_price',
      'courses.number_of_lessons',
      'courses.duration_in_hours',
      'courses.review as course_review'
    ).from('user_favorite_courses')
    .join('courses', 'courses.id', '=', 'user_favorite_courses.course_id')
    .where('user_favorite_courses.user_id', userId);

    return favoriteCourses;
  }

  async getUserCourses(userId:number): Promise<any>{
    const knex = this.dbService.getKnexInstance();
    const courses = await (await knex.select('courses.id as course_id', 'courses.number_of_lessons as number_of_lessons', 'courses.name as course_name', 'courses.image as course_image',
    'user_courses.is_complete as is_complete')
      .from('courses')
      .join('user_courses', 'user_courses.course_id', '=', 'courses.id')
      .where('user_courses.user_id', '=', userId)
      .orderBy('user_courses.id', 'asc'))
  .map((course) => {
    return {
      ...course,
      is_complete: course.is_complete ? true : false,
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
      'courses.number_of_lessons',
      'courses.duration_in_hours',
      'courses.review as course_review'
    ).from('user_favorite_courses')
    .join('courses', 'courses.id', '=', 'user_favorite_courses.course_id')
    .where({ user_id: userId, course_id: courseId })
    .orderBy('courses.id', 'desc') // sort by created_at column in descending order
    .first(); 
  return updatedUserFavoritedCourse;
  }

  async deleteUserFavoriteCourse(userId: number, courseId: number): Promise<any>{
    const knex = this.dbService.getKnexInstance();
    
    const deletedUserFavoriteCourse = await knex.select(
      'courses.id as course_id',
      'courses.name as course_name',
      'courses.image as course_image',
      'courses.price as course_price',
      'courses.number_of_lessons',
      'courses.duration_in_hours',
      'courses.review as course_review'
    ).from('user_favorite_courses')
    .join('courses', 'courses.id', '=', 'user_favorite_courses.course_id')
      .where({
        user_id: userId,
        course_id: courseId
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
