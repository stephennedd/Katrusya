import { Body, Controller, Get, Param, Post, Query, UsePipes, ValidationPipe } from '@nestjs/common';
import { CreateUserPurchase } from 'src/courses/dtos/CreateUserPurchase.dtos';
import { ValidateCreateUserPurchasePipe } from 'src/courses/pipes/validate-create-user-purchase/validate-create-user-purchase.pipe';
import { ValidatePassBooleanQueryParamPipe } from 'src/courses/pipes/validate-pass-boolean-query-param/validate-pass-boolean-query-param.pipe';
import { CoursesService } from 'src/courses/services/courses/courses.service';
import { ValidateCreateUserPipe } from 'src/users/pipes/validate-create-user/validate-create-user.pipe';

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
@Query('category') category: string,
@Query('search') search: string,) {
    return this.coursesService.getCourses({category:category, is_recommended:isRecommended, is_featured:isFeatured,search:search});
 // }
}

@Get(':courseId/details')
@UsePipes(new ValidationPipe())
async getCourseDetails(@Param('courseId') courseId: number) {
    return this.coursesService.getCourseDetails(courseId);
}

@Get(':courseId/quizzes')
@UsePipes(new ValidationPipe())
async getCourseQuizzes(@Param('courseId') courseId: number) {
    return this.coursesService.getCourseQuizzes(courseId);
 // }
}

@Post('/purchasedCourses')
  async addPurchasedCourse(@Body(ValidateCreateUserPurchasePipe) createPurchase: CreateUserPurchase) {
    const { courseId, userId } = createPurchase;
    return this.coursesService.addPurchasedCourse(courseId, userId);
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
