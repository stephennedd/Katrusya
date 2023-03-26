import { Controller, Get, Param, Query, UsePipes, ValidationPipe } from '@nestjs/common';
import { ValidatePassBooleanQueryParamPipe } from 'src/courses/pipes/validate-pass-boolean-query-param/validate-pass-boolean-query-param.pipe';
import { CoursesService } from 'src/courses/services/courses/courses.service';

@Controller('courses')
export class CoursesController {
    constructor(private readonly coursesService: CoursesService) {}
   
//     @Get('/recommended')
//   async getRecommendedCourses() {
//     return this.coursesService.getRecommendedCourses();
//   }

@Get('')
@UsePipes(new ValidationPipe())
async getCourses(@Query('is_recommended',ValidatePassBooleanQueryParamPipe) isRecommended: boolean,
@Query('is_featured',ValidatePassBooleanQueryParamPipe) isFeatured: boolean,
@Query('category') category: string) {
    return this.coursesService.getCourses({category:category, is_recommended:isRecommended, is_featured:isFeatured});
 // }
}

//   @Get('/featured')
//   async getFeaturedCourses() {
//     return this.coursesService.getFeauturedCourses();
//   }

//   @Get(':categoryName')
//   async getCoursesBasedOnCategoryName(@Param('categoryName') categoryName: string){
//     return this.coursesService.getCoursesBasedOnCategoryName(categoryName);
//   }
}
