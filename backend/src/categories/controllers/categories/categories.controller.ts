import { Controller, Get,Post, Put, Delete, Body, Param } from '@nestjs/common';
import { CategoryEntity } from '../../../models/category/category';
import { CategoriesService } from '../../services/categories/categories.service';

@Controller('categories')
export class CategoriesController {
    constructor(private readonly categoriesService: CategoriesService) {}
  
    @Get('')
    async getCategories() {
      return this.categoriesService.getCategories();
    }
      
    @Get(':id')
    async getCategory(@Param('id') id: number) {
      return this.categoriesService.getCategory(id);
    }
    
    @Post()
      async addCategory(@Body() category: CategoryEntity) {
        return this.categoriesService.addCategory(category);
      }
    
      @Put(':id')
      async updateCategory(@Param('id') id: number, @Body() category: CategoryEntity) {
        return this.categoriesService.updateCategory(id, category);
      }
    
      @Delete(':id')
      async deleteCategory(@Param('id') id: number) {
        return this.categoriesService.deleteCategory(id);
      }   
}
