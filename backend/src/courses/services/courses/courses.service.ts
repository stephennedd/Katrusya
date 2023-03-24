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

        async getCoursesBasedOnCategoryName(categoryName:string): Promise<any>{
            const knex = this.dbService.getKnexInstance();
            const courses = await knex('courses')
              .join('course_categories', 'courses.id', 'course_categories.course_id')
              .join('categories', 'categories.id', 'course_categories.category_id')
              .where('categories.name', categoryName)
              .select('courses.*');
            return courses;
            }
}
