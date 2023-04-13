import { Injectable } from '@nestjs/common';
import { CategoriesRepository } from '../../repositories/categories.repository';
import { DatabaseService } from '../../../databases/database.service';

@Injectable()
export class CategoriesService {
    constructor(
      private readonly categoriesRepository: CategoriesRepository) {} 
    async getCategories(): Promise<any>{
        const categories = await this.categoriesRepository.getAll();
        //await knex('categories').select('*');
        return categories;
      }
}

