import { Body, Controller, Get, Param, Post, Query, UsePipes, ValidationPipe } from '@nestjs/common';
import { CreateUserPurchase } from '../../dtos/CreateUserPurchase.dtos';
import { ValidateCreateUserPurchasePipe } from '../../pipes/validate-create-user-purchase/validate-create-user-purchase.pipe';
import { ValidatePassBooleanQueryParamPipe } from '../../pipes/validate-pass-boolean-query-param/validate-pass-boolean-query-param.pipe';
import { CoursesService } from '../../services/courses/courses.service';

@Controller('courses')
export class CoursesController {
    constructor(private readonly coursesService: CoursesService) {}
   
@Get('')
@UsePipes(new ValidationPipe())
async getCourses(@Query('is_recommended',ValidatePassBooleanQueryParamPipe) isRecommended: boolean,
@Query('is_featured',ValidatePassBooleanQueryParamPipe) isFeatured: boolean,
@Query('category') category: string,
@Query('search') search: string,) {
    return this.coursesService.getCourses({category:category, is_recommended:isRecommended, is_featured:isFeatured,search:search});
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
}

@Post('/purchasedCourses')
  async addPurchasedCourse(@Body(ValidateCreateUserPurchasePipe) createPurchase: CreateUserPurchase) {
    const { courseId, userId } = createPurchase;
    return this.coursesService.addPurchasedCourse(courseId, userId);
  }
}
