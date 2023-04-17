import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { CategoriesRepository } from '../../repositories/categories.repository';
import { DatabaseService } from '../../../databases/database.service';
import { CategoryEntity } from '../../../models/category/category';

@Injectable()
export class CategoriesService {
    constructor(
      private readonly categoriesRepository: CategoriesRepository) {} 
    async getCategories(): Promise<any>{
        const categories = await this.categoriesRepository.getAll();
        //await knex('categories').select('*');
        return categories;
      }

      async getCategory(id:number): Promise<any>{
        const doesCategoryExist = await this.categoriesRepository.getById(id);
      if(!doesCategoryExist){
        throw new BadRequestException(`The category with id ${id} does not exist`);
      } 
        const category = await this.categoriesRepository.getById(id);
        //await knex('categories').select('*');
        return category;
      }

      async addCategory(category: CategoryEntity): Promise<CategoryEntity> {
        return this.categoriesRepository.create(category);
      }
    
      async updateCategory(id: number, category: CategoryEntity): Promise<CategoryEntity> {
        const doesCategoryExist = await this.categoriesRepository.getById(id);
        if(!doesCategoryExist){
          throw new BadRequestException(`The category with id ${id} does not exist`);
        } 
       
        return this.categoriesRepository.update(id, category);
      }
    

      async deleteCategory(id: number): Promise<string> {
        const category = await this.categoriesRepository.getById(id);
        if (!category) {
          throw new NotFoundException(`Category with ID ${id} not found`);
        }
        await this.categoriesRepository.delete(id);
        return `Category with ID ${id} deleted`;
      }
}

