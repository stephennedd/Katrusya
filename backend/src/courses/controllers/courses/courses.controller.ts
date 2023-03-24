import { Controller, Get, Param } from '@nestjs/common';
import { CoursesService } from 'src/courses/services/courses/courses.service';

@Controller('courses')
export class CoursesController {
    constructor(private readonly coursesService: CoursesService) {}
   
    @Get('/recommended')
  async getRecommendedCourses() {
    return this.coursesService.getRecommendedCourses();
  }

  @Get('/featured')
  async getFeaturedCourses() {
    return this.coursesService.getFeauturedCourses();
  }

  @Get(':categoryName')
  async getCoursesBasedOnCategoryName(@Param('categoryName') categoryName: string){
    return this.coursesService.getCoursesBasedOnCategoryName(categoryName);
  }
}
