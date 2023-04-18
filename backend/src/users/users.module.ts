import { Module } from '@nestjs/common';
import { CoursesRepository, TestsRepository } from '../courses/repositories/courses.repository';
import { DatabaseService } from '../databases/database.service';
import { LessonsRepository, SectionsRepository } from '../sections/repositories/sections.repository';
import { UsersController } from './controllers/users/users.controller';
import { UserCompletedLessonsRepository, UserCompletedSectionsRepository, UserCoursesRepository, UserFavoriteCoursesRepository, UserLessonsRepository, UserResultsRepository, UsersRepository } from './repositories/users.repository';
import { UsersService } from './services/users/users.service';

@Module({
    controllers: [UsersController],
  providers: [UsersService, DatabaseService,UsersRepository,
  UserFavoriteCoursesRepository,UserCompletedLessonsRepository,
UserCompletedSectionsRepository,UserCoursesRepository,
UserResultsRepository,CoursesRepository,
LessonsRepository,SectionsRepository,UserLessonsRepository,
TestsRepository]
})
export class UsersModule {}
