import { Injectable } from '@nestjs/common';
import { DatabaseService } from 'src/databases/database.service';

@Injectable()
export class CoursesService {
    constructor(private readonly dbService: DatabaseService) {} 
    
//     async getRecommendedCourses(): Promise<any>{
//     const knex = this.dbService.getKnexInstance();
//     const recommendedCourses = await knex('courses')
//   .where({ is_recommended: true })
//   .select('*');
//   return recommendedCourses;
//     }

async getRecommendedCourses(isRecommended: boolean): Promise<any>{
    const knex = this.dbService.getKnexInstance();
    let query = await knex('courses').select('*')
      .where('is_recommended', isRecommended ? 1 : 0);
   
    
    const recommendedCourses = query.map(course => {
        return {
          ...course,
          is_recommended: course.is_recommended === 1 ? true : false,
          is_featured: course.is_featured === 1?true : false,
          is_favorited: course.is_favorited === 1?true : false,
        };
      });
    return recommendedCourses;
  }
 
    // async getFeauturedCourses(): Promise<any>{
    //     const knex = this.dbService.getKnexInstance();
    //     const featuredCourses = await knex('courses')
    //   .where({ is_featured: true })
    //   .select('*');
    //   return featuredCourses;
    //     }

        async getCoursesBasedOnCategoryName(categoryName:string): Promise<any>{
            const knex = this.dbService.getKnexInstance();
            const courses = await knex('courses')
              .join('course_categories', 'courses.id', 'course_categories.course_id')
              .join('categories', 'categories.id', 'course_categories.category_id')
              .where('categories.name', categoryName)
              .select('courses.*');
            return courses;
            }

    async getFeaturedCourses(isFeatured: boolean): Promise<any>{
        const knex = this.dbService.getKnexInstance();
        let query = await knex('courses').select('*')
        .where('is_featured', isFeatured ? 1 : 0);
        
        const featuredCourses = query.map(course => {
            return {
              ...course,
              is_recommended: course.is_recommended === 1 ? true : false,
              is_featured: course.is_featured === 1?true : false,
              is_favorited: course.is_favorited === 1?true : false,
            };
          });

        return featuredCourses;
      }

      async getCourses(): Promise<any>{
        const knex = this.dbService.getKnexInstance();
        let query = await knex('courses').select('*');

        const courses = query.map(course => {
            return {
              ...course,
              is_recommended: course.is_recommended === 1 ? true : false,
              is_featured: course.is_featured === 1?true : false,
              is_favorited: course.is_favorited === 1?true : false,
            };
          });

        return courses;
      }
}
