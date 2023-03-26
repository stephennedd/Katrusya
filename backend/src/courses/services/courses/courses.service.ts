import { Injectable } from '@nestjs/common';
import { DatabaseService } from 'src/databases/database.service';


interface QueryParams{
    category?: string,
    is_recommended?: boolean,
    is_featured?: boolean,
    search?:string
}

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

    async getCourses(queryParams: QueryParams): Promise<any>{
        const knex = this.dbService.getKnexInstance();
      
        // Create a base query
        let query = knex('courses');
      
        // Apply filters based on query params
        if (queryParams.category!==undefined) {
            query = query
            .join('course_categories', 'courses.id', 'course_categories.course_id')
            .join('categories', 'categories.id', 'course_categories.category_id')
            .where('categories.name', queryParams.category)
          //  .select('courses.*');
        }
      
        if (queryParams.is_recommended!==undefined) {
          query = query.where('is_recommended', queryParams.is_recommended? 1 : 0);
        }
      
        if (queryParams.is_featured!==undefined) {
          query = query.where('is_featured', queryParams.is_featured? 1 : 0);
        }

        if (queryParams.search!==undefined) {
            query = query.whereRaw(`JSON_CONTAINS(tags->'$[*]', '["${queryParams.search}"]')`)
          }
      
        // Execute the query
        if(queryParams.category){
         query = query.select('courses.*');
        } else {
            query = query.select('*');
        }

             const courses = (await query).map(course => {
            return {
              ...course,
              is_recommended: course.is_recommended === 1 ? true : false,
              is_featured: course.is_featured === 1?true : false,
              is_favorited: course.is_favorited === 1?true : false,
            };
          });
         
        return courses;
      }
    

        async getCoursesBasedOnCategoryName(categoryName:string): Promise<any>{
            const knex = this.dbService.getKnexInstance();
            const query = await knex('courses')
              .join('course_categories', 'courses.id', 'course_categories.course_id')
              .join('categories', 'categories.id', 'course_categories.category_id')
              .where('categories.name', categoryName)
              .select('courses.*');
            
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

    //   async getCourses(): Promise<any>{
    //     const knex = this.dbService.getKnexInstance();
    //     let query = await knex('courses').select('*');

    //     const courses = query.map(course => {
    //         return {
    //           ...course,
    //           is_recommended: course.is_recommended === 1 ? true : false,
    //           is_featured: course.is_featured === 1?true : false,
    //           is_favorited: course.is_favorited === 1?true : false,
    //         };
    //       });

    //     return courses;
    //   }
}
