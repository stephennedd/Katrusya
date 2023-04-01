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
    const result = await knex('user_favorite_courses')
    .where({ user_id: userId })
    .select('course_id')

    return result;
  }

  async addUserFavoriteCourse(userId: number, courseId: number): Promise<any>{
    const knex = this.dbService.getKnexInstance();
    
    await knex('user_favorite_courses').insert({
      user_id: userId, // the ID of the user who is adding the favorite course
      course_id: courseId // the ID of the course that the user is adding to their favorites
    });

    const updatedUserFavoritedCourses = await knex('user_favorite_courses')
    .where({ user_id: userId })
    .select('course_id')
  return updatedUserFavoritedCourses;
    return updatedUserFavoritedCourses;
  }

  async deleteUserFavoriteCourse(userId: number, courseId: number): Promise<any>{
    const knex = this.dbService.getKnexInstance();
    
    await knex('user_favorite_courses')
  .where({
    user_id: userId,
    course_id: courseId
  })
  .del();
  const updatedUserFavoritedCourses = await knex('user_favorite_courses')
    .where({ user_id: userId })
    .select('course_id')
  return updatedUserFavoritedCourses;
  }
  

}
