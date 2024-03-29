import { Controller, Get, Post, Body, Param, UsePipes, ValidationPipe, Delete, Query, Put } from '@nestjs/common';
import { AddCompletedLessonDto } from '../../../users/dtos/AddCompletedLesson.dtos';
import { AddFavoriteCourseDto } from '../../../users/dtos/AddFavoriteCourse.dtos';
import { CreateUserDto } from '../../../users/dtos/CreateUser.dtos';
import { CreateUserResultsDto } from '../../../users/dtos/CreateUserResults.dtos';
import { ValidateAddCompletedByUserLessonPipe } from '../../../users/pipes/validate-add-completed-by-user-lesson/validate-add-completed-by-user-lesson.pipe';
import { ValidateAddFavoriteCoursePipe } from '../../../users/pipes/validate-add-favorite-course/validate-add-favorite-course.pipe';
import { ValidateCreateUserResultsPipe } from '../../../users/pipes/validate-create-user-results/validate-create-user-results.pipe';
import { ValidateCreateUserPipe } from '../../../users/pipes/validate-create-user/validate-create-user.pipe';
import { UsersService } from '../../services/users/users.service';

@Controller('users')
export class UsersController {
    constructor(private readonly usersService: UsersService) {}
    
    @Get('')
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
    async hasUserPurchasedTheCourse(@Param('userId') userId: number,
    @Query('course_id') courseId: number
    ) {
      return this.usersService.hasUserPurchasedTheCourse(userId,courseId);
    }

    @Get(':id')
    async getUser(@Param('id') userId: number) {
      return this.usersService.getUser(userId);
    }

    @Get(':userId/courses/:courseId/completedLessons')
    async getUserCompletedLessonsForCertainCourse(@Param('userId') userId: number,@Param('courseId') courseId: number) {
      return this.usersService.getCompleteByUserLessonsForCertainCourse(userId,courseId);
    }

    @Get(':userId/completedSections')
    async getUserCompletedSectionsForCertainCourse(@Param('userId') userId: number) {
      return this.usersService.getCompleteByUserSections(userId);
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

  @Put(':userId/roles')
  async flipTeacherMode(@Param('userId') userId: number) {
    return await this.usersService.flipTeacherMode(userId);
  }

  @Post('/:userId/lessons/:lessonId')
  async addTimestampOfLastViewedMomentOfLesson(
    @Param('userId') userId: number,
    @Param('lessonId') lessonId: number,
  ) {
    try {
      await this.usersService.addTimestampOfLastViewedMomentOfLesson(
        userId,
        lessonId,
      );
      return { message: 'Record inserted successfully!' };
    } catch (error) {
      return { message: 'Error inserting record' };
    }
  }

  @Put('/:userId/lessons/:lessonId')
async updateTimestampOfLastViewedMomentOfLesson(
  @Param('userId') userId: number,
  @Param('lessonId') lessonId: number,
  @Body('timestamp') timestamp: Date,
): Promise<any> {
  try {
    await this.usersService.updateTimestampOfLastViewedMomentOfLesson(
      userId,
      lessonId,
      timestamp,
    );
    return { message: 'Record updated successfully!' };
  } catch (error) {
    return { message: error };
  }
}
  
@Get(':userId/lessons/:lessonId')
  async getLastViewedMoment(@Param('userId') userId: number, @Param('lessonId') lessonId: number) {
    const timestamp = await this.usersService.getTimestampOfLastViewedMomentOfLesson(userId, lessonId);
    return { timestamp };
  }

  @Delete(':userId/favoriteCourses/:courseId')
async removeFavoriteCourse(
  @Param('userId') userId: number,
  @Param('courseId') courseId: number,
) {
  return await this.usersService.deleteUserFavoriteCourse(userId, courseId);
  } 

  @Delete(':id')
  async deleteSection(@Param('id') id: number) {
    return this.usersService.deleteUser(id);
  }  
}