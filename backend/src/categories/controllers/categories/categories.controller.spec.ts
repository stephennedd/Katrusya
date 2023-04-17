import { Test, TestingModule } from '@nestjs/testing';
import { CategoriesController } from './categories.controller';
import { CategoriesService } from '../../services/categories/categories.service';
import { CategoriesRepository } from '../../repositories/categories.repository';
import { DatabaseService } from '../../../databases/database.service';
import { CategoryEntity } from '../../../models/category/category';
import { BadRequestException } from '@nestjs/common';

describe('CategoriesController', () => {
  let controller: CategoriesController;
  let service: CategoriesService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [CategoriesController],
      providers: [CategoriesService,CategoriesRepository,{
        provide: DatabaseService,
        useValue: {}, // Provide a mock object here
      },],
    }).compile();

    controller = module.get<CategoriesController>(CategoriesController);
    service = module.get<CategoriesService>(CategoriesService);
  });

  describe('getCategories', () => {
    it('should return an array of categories', async () => {
      const categories = [{ id: 1, name: 'category 1' }, { id: 2, name: 'category 2' }];
      jest.spyOn(service, 'getCategories').mockResolvedValue(categories);

      expect(await controller.getCategories()).toBe(categories);
    });
  });

  describe('addCategory', () => {
    it('should add a new category', async () => {
      const category: CategoryEntity = {id:1, name: 'New Category', icon: "New icon"};
      jest.spyOn(service, 'addCategory').mockResolvedValue(category);

      const result = await controller.addCategory(category);

      expect(result).toBe(category);
      expect(service.addCategory).toHaveBeenCalledWith(category);
    });
  });

  describe('updateCategory', () => {
    it('should update an existing category', async () => {
      const category: CategoryEntity = { id:1, name: 'New Category', icon: "New icon" };
      const id = 1;
      jest.spyOn(service, 'updateCategory').mockResolvedValue(category);

      const result = await controller.updateCategory(id, category);

      expect(result).toBe(category);
      expect(service.updateCategory).toHaveBeenCalledWith(id, category);
    });
  });

  describe('deleteCategory', () => {
    it('should delete a category and return a success message', async () => {
      const id = 1;
      const message = `Category with ID ${id} deleted`;
      jest.spyOn(service, 'deleteCategory').mockResolvedValue(message);
    
      expect(await controller.deleteCategory(id)).toBe(message);
    });
  });

  describe('getCategory', () => {
    it('should return a category by id', async () => {
      // Arrange
      const categoryId = 1;
      const category = { id: categoryId, name: 'Category 1', icon: "Icon 1" };
      jest.spyOn(service, 'getCategory').mockResolvedValue(category);

      // Act
      const result = await controller.getCategory(categoryId);

      // Assert
      expect(result).toEqual(category);
    });

    it('should throw a BadRequestException if the category does not exist', async () => {
      // Arrange
      const categoryId = 1;
      jest.spyOn(service, 'getCategory').mockImplementation(() => {
        throw new BadRequestException(`The category with id ${categoryId} does not exist`);
      });

      // Act & Assert
      await expect(controller.getCategory(categoryId)).rejects.toThrow(BadRequestException);
    });
  });
});
