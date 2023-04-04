import { Controller, Get, Post, Body, Param, UsePipes, ValidationPipe, Delete, UseGuards, Query } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { AddCompletedLessonDto } from 'src/users/dtos/AddCompletedLesson.dtos';
import { AddFavoriteCourseDto } from 'src/users/dtos/AddFavoriteCourse.dtos';
import { CreateUserDto } from 'src/users/dtos/CreateUser.dtos';
import { CreateUserResultsDto } from 'src/users/dtos/CreateUserResults.dtos';
import { ValidateAddCompletedByUserLessonPipe } from 'src/users/pipes/validate-add-completed-by-user-lesson/validate-add-completed-by-user-lesson.pipe';
import { ValidateAddFavoriteCoursePipe } from 'src/users/pipes/validate-add-favorite-course/validate-add-favorite-course.pipe';
import { ValidateCreateUserResultsPipe } from 'src/users/pipes/validate-create-user-results/validate-create-user-results.pipe';
import { ValidateCreateUserPipe } from 'src/users/pipes/validate-create-user/validate-create-user.pipe';
import { UsersService } from '../../services/users/users.service';

@Controller('users')
export class UsersController {
    constructor(private readonly usersService: UsersService) {}
    
    @Get('')
    @UseGuards(AuthGuard('jwt'))
    async getUsers() {
      return this.usersService.getUsers();
    }

    @Get(':userId/favoriteCourses')
  async getFavoriteCourses(@Param('userId') userId: number) {
    return this.usersService.getUserFavoriteCourses(userId);
  }

  @Get(':userId/courses')
  async getUserCourses(@Param('userId') userId: number) {
    return this.usersService.getUserCourses(userId);
  }

    @Get(':userId/tests/:testId/results')
    async getUserResults(@Param('userId') userId: number, @Param('testId') testId: number) {
      return this.usersService.getUserResults(userId,testId);
    }

    @Get(':userId/isCoursePurchased')
    async isUserPurchasedTheCourse(@Param('userId') userId: number,
    @Query('course_id') courseId: number
    ) {
      return this.usersService.isUserPurchasedTheCourse(userId,courseId);
    }

    @Get(':id')
    async getUser(@Param('id') userId: number) {
      return this.usersService.getUser(userId);
    }

    //getCompleteByUserLessonsForCertainCourse

    @Get(':userId/courses/:courseId/completedLessons')
    async getUserCompletedLessonsForCertainCourse(@Param('userId') userId: number,@Param('courseId') courseId: number) {
      return this.usersService.getCompleteByUserLessonsForCertainCourse(userId,courseId);
    }

    @Get(':userId/sections/:sectionId/isCompleted')
    async getIsSectionCompletedByUser(@Param('userId') userId: number,@Param('sectionId') sectionId: number) {
      return this.usersService.isSectionCompletedByUser(userId,sectionId);
    }

    @Get(':userId/courses/:courseId/isCompleted')
    async getIsCourseCompletedByUser(@Param('userId') userId: number,@Param('courseId') courseId: number) {
      return this.usersService.isCourseCompletedByUser(userId,courseId);
    }

    @Post('')
    @UsePipes(new ValidationPipe())
    async createUser(
      @Body(ValidateCreateUserPipe) createUser: CreateUserDto,
    ) {
      return this.usersService.addUser(createUser);
    }

    @Post('/testResults')
    @UsePipes(new ValidationPipe())
    async createUserResult(
      @Body(ValidateCreateUserResultsPipe) createUserResult: CreateUserResultsDto,
    ) {
      return this.usersService.addUserResult(createUserResult);
    }

    @Post(':userId/completedLessons')
    @UsePipes(new ValidationPipe())
    async addCompletedLesson(
      @Param('userId') userId: number,
      @Body(ValidateAddCompletedByUserLessonPipe) completedLessonDto: AddCompletedLessonDto,
    ) {
      return this.usersService.addCompletedByUserLesson(userId, completedLessonDto);
    }

    @Delete(':userId/completedLessons')
    @UsePipes(new ValidationPipe())
    async deleteCompletedLesson(
      @Param('userId') userId: number,
      @Body(ValidateAddCompletedByUserLessonPipe) completedLessonDto: AddCompletedLessonDto,
    ) {
      return this.usersService.deleteCompletedByUserLesson(userId, completedLessonDto);
    }
  
    @Post(':userId/favoriteCourses')
    @UsePipes(new ValidationPipe())
  async addFavoriteCourse(
    @Param('userId') userId: number,
    @Body(ValidateAddFavoriteCoursePipe) addFavoriteCourseDto: AddFavoriteCourseDto,
  ) {
    return await this.usersService.addUserFavoriteCourse(userId, addFavoriteCourseDto.course_id);
  }
  

  @Delete(':userId/favoriteCourses/:courseId')
async removeFavoriteCourse(
  @Param('userId') userId: number,
  @Param('courseId') courseId: number,
) {
  return await this.usersService.deleteUserFavoriteCourse(userId, courseId);
  } 
}