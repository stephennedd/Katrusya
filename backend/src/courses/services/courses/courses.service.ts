import { Injectable } from '@nestjs/common';
import { DatabaseService } from 'src/databases/database.service';


interface QueryParams{
    category?: string,
    is_recommended?: boolean,
    is_featured?: boolean,
    search?:string
}

interface Test{
    id: number,
    title: string,
    image_url?: string,
    description: string,
    time_seconds: number
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

async addPurchasedCourse(courseId: number, userId: number) {
    const knex = this.dbService.getKnexInstance();
    try { await knex('user_courses').insert({
      course_id: courseId,
      user_id: userId,
      is_completed: false
    });
    return { success: true };
}catch (err) {
    // Log the error for debugging purposes    
    // Check if the error is a unique constraint violation error
    if (err.sqlState === '23000' && err.code === 'ER_DUP_ENTRY') {
        const message = `The user with ID ${userId} has already purchased the course with ID ${courseId}`;
        return { success: false, error: message };
      } else {
      return {
        success: false,
        error: 'An error occurred while adding the course to the user',
      };
    }
  }
  }

  async getCourseQuizzes(courseId: number): Promise<any>{
    const knex = this.dbService.getKnexInstance();

    const result = await knex.select('tests.title as quiz_title','tests.section_id as section_id',
    'tests.image_url as image_url','tests.course_id')
    .count('questions.id as number_of_questions')
    .from('tests')
    .leftJoin('questions', 'tests.id', 'questions.test_id')
    .where('tests.course_id', courseId)
    .groupBy('tests.id')
    .orderBy('tests.section_id');

    return result;
  }

async getCourseDetails(courseId: number): Promise<any>{
const knex = this.dbService.getKnexInstance();

const result = await knex("courses as c")
  .leftJoin("sections as s", "c.id", "s.course_id")
  .leftJoin("lessons as l", "s.id", "l.section_id")
  .select(
    "c.name as course_name",
    "c.description as course_description",
    "s.id as section_id",
    "s.title as section_title",
    "s.image as section_image",
    "l.image as lesson_image",
    "l.title as lesson_name",
    "l.duration_in_hours as lesson_duration_in_hours",
    "l.video_url"
  )
  .where("c.id", courseId)
  .orderBy("s.id", "l.id");

  // const courseQuizzes = await knex.select('tests.title as quiz_title')
  //   .count('questions.id as number_of_questions')
  //   .from('tests')
  //   .leftJoin('questions', 'tests.id', 'questions.test_id')
  //   .where('tests.course_id', courseId)
  //   .groupBy('tests.id')
  //   .orderBy('tests.section_id');

const course = {
  course_name: result[0].course_name,
  course_description: result[0].course_description,
  sections: [],
  number_of_lessons: 0,
  course_duration_in_hours: 0
};

let currentSection = {id:0,title: "",  image: "", lessons: [], number_of_lessons: 0, section_duration_in_hours: 0};
for (const row of result) {
  if (currentSection.id !== row.section_id) {
    currentSection = {id:row.section_id, title: row.section_title, image: row.section_image, lessons: [], number_of_lessons: 0, section_duration_in_hours: 0 };
    course.sections.push(currentSection);
  }
  currentSection.lessons.push({lesson_name: row.lesson_name, lesson_duration_in_hours: row.lesson_duration_in_hours, video_url: row.video_url, image: row.lesson_image });
  currentSection.number_of_lessons = currentSection.number_of_lessons + 1;
  currentSection.section_duration_in_hours = currentSection.section_duration_in_hours + row.lesson_duration_in_hours
  course.number_of_lessons = course.number_of_lessons+1;
  course.course_duration_in_hours = course.course_duration_in_hours + row.lesson_duration_in_hours;
}

return course;
}

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
