import { Module } from '@nestjs/common';
import { DatabaseService } from 'src/databases/database.service';
import { SectionsController } from './controllers/sections/sections.controller';
import { AnswersRepository, QuestionsRepository, SectionsRepository, TestsRepository } from './repositories/sections.repository';
import { SectionsService } from './services/sections/sections.service';

@Module({
    controllers: [SectionsController],
  providers: [SectionsService,TestsRepository, QuestionsRepository, AnswersRepository, DatabaseService, SectionsRepository]
})
export class SectionsModule {}
