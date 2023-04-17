import { Module } from '@nestjs/common';
import { UsersRepository } from '../auth/repositories/users.repository';
import { DatabaseService } from '../databases/database.service';
import { CoursesController } from './controllers/courses/courses.controller';
import { CoursesRepository, TestsRepository, UserCoursesRepository } from './repositories/courses.repository';
import { CoursesService } from './services/courses/courses.service';

@Module({
  controllers: [CoursesController],
  providers: [CoursesService, DatabaseService, CoursesRepository,
  UsersRepository, UserCoursesRepository, TestsRepository]
})
export class CoursesModule {}

