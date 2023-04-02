import { Controller, Get, Post, Body, Param, UsePipes, ValidationPipe, Delete, UseGuards, Query } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { AddFavoriteCourseDto } from 'src/users/dtos/AddFavoriteCourse.dtos';
import { CreateUserDto } from 'src/users/dtos/CreateUser.dtos';
import { CreateUserResultsDto } from 'src/users/dtos/CreateUserResults.dtos';
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
      this.usersService.getUser(userId);
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