import { Controller, Get, Param, Query, UsePipes, ValidationPipe } from '@nestjs/common';
import { ValidatePassBooleanQueryParam } from 'src/courses/pipes/validate-create-course/validate-pass-boolean-query-param.pipe';
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
async getCourses(@Query('is_recommended',ValidatePassBooleanQueryParam) isRecommended: boolean,
@Query('is_featured',ValidatePassBooleanQueryParam) isFeatured: boolean) {
  if(isRecommended!==undefined){
    return this.coursesService.getRecommendedCourses(isRecommended);
  } else if(isFeatured!==undefined){
    return this.coursesService.getFeaturedCourses(isFeatured);
  } else {
    return this.coursesService.getCourses();
  }
}

//   @Get('/featured')
//   async getFeaturedCourses() {
//     return this.coursesService.getFeauturedCourses();
//   }

  @Get(':categoryName')
  async getCoursesBasedOnCategoryName(@Param('categoryName') categoryName: string){
    return this.coursesService.getCoursesBasedOnCategoryName(categoryName);
  }
}
