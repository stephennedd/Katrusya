import { Controller, Get, Post, Body, Param, UsePipes, ValidationPipe, Delete, UseGuards, Query } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { CreateUserDto } from 'src/users/dtos/CreateUser.dtos';
import { CreateUserResultsDto } from 'src/users/dtos/CreateUserResults.dtos';
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

    @Delete('/results/:testResultId')
    @UsePipes(new ValidationPipe())
    async deleteUserResult(
        @Param('testResultId') testResultId: number
    ) {
      return this.usersService.deleteUserResult(testResultId);
    }
}
