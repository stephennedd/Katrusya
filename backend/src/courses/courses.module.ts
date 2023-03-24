import { Module } from '@nestjs/common';
import { DatabaseService } from 'src/databases/database.service';
import { CoursesController } from './controllers/courses/courses.controller';
import { CoursesService } from './services/courses/courses.service';

@Module({
  controllers: [CoursesController],
  providers: [CoursesService, DatabaseService]
})
export class CoursesModule {}

