import { Module } from '@nestjs/common';
import { DatabaseService } from 'src/databases/database.service';
import { CategoriesController } from './controllers/categories/categories.controller';
import { CategoriesService } from './services/categories/categories.service';

@Module({
  controllers: [CategoriesController],
  providers: [CategoriesService,DatabaseService]
})
export class CategoriesModule {}
