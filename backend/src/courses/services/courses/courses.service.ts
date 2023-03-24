import { Injectable } from '@nestjs/common';
import { DatabaseService } from 'src/databases/database.service';

@Injectable()
export class CoursesService {
    constructor(private readonly dbService: DatabaseService) {} 
    
    async getRecommendedCourses(): Promise<any>{
    const knex = this.dbService.getKnexInstance();
    const recommendedCourses = await knex('courses')
  .where({ is_recommended: true })
  .select('*');
  return recommendedCourses;
    }

    async getFeauturedCourses(): Promise<any>{
        const knex = this.dbService.getKnexInstance();
        const featuredCourses = await knex('courses')
      .where({ is_featured: true })
      .select('*');
      return featuredCourses;
        }
}
