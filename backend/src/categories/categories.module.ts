import { Module } from '@nestjs/common';
import { DatabaseService } from '../databases/database.service';
import { CategoriesController } from './controllers/categories/categories.controller';
import { CategoriesRepository } from './repositories/categories.repository';
import { CategoriesService } from './services/categories/categories.service';

@Module({
  controllers: [CategoriesController],
  providers: [CategoriesService,DatabaseService,CategoriesRepository]
})
export class CategoriesModule {}
