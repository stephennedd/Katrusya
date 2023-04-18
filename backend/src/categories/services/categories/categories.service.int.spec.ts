import { Test, TestingModule } from '@nestjs/testing';
import { CategoriesService } from './categories.service';
import { CategoriesRepository } from '../../repositories/categories.repository';
import { DatabaseService } from '../../../databases/database.service';
import { CategoryEntity } from 'src/models/category/category';

describe('CategoriesService', () => {
    let service: CategoriesService;
    let repository: CategoriesRepository;
 
  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CategoriesService,
        CategoriesRepository,
        DatabaseService
      ],
    }).compile();

    service = module.get<CategoriesService>(CategoriesService);
    repository = module.get<CategoriesRepository>(CategoriesRepository);
  });

  afterEach(async () => {
  // Clean up any resources used by your tests, such as the database connection
 // await databaseService.close();
});

  describe('getCategories', () => {
    it('should return an array of categories', async () => {
      const categories = await service.getCategories();

      expect(categories).toHaveLength(9);
      expect(categories[0].name).toBe('All');
      expect(categories[1].name).toBe('Coding');
    });
  });

  describe('getCategory', () => {
    it('should return a category by id', async () => {
      const categories = await service.getCategories();
      const id = categories[0].id;

      const category = await service.getCategory(id);

      expect(category).toBeDefined();
      expect(category.name).toBe('All');
    });

    it('should throw a 400 BadRequestError if the category does not exist', async () => {
        const id = 100;
      
       try {
          await service.getCategory(id);

        } catch (error) {
          expect(error.response.statusCode).toEqual(400);
          expect(error.response.message).toEqual(`The category with id ${id} does not exist`);
          expect(error.response.error).toEqual('Bad Request');
        }
      });
  });
  describe('addCategory', () => {
    it('should create a category', async () => {
      // Arrange
      const category: CategoryEntity = {
          name: 'Category 10',
          icon: 'Icon 10',
          id: 10
      };

      // Act
      const result = await service.addCategory(category);

      // Assert
      expect(result).toHaveProperty('id');
      expect(result.name).toEqual(category.name);
      expect(result.icon).toEqual(category.icon);
    });
  });

  describe('updateCategory', () => {
    it('should update a category', async () => {
      // Act
      const updatedCategory = {
        id: 10,
        name: 'Updated Category 11',
        icon: 'Updated Icon 11',
      };
      const result = await service.updateCategory(10, updatedCategory);

      // Assert
      expect(result).toHaveProperty('id');
      expect(result.name).toEqual(updatedCategory.name);
      expect(result.icon).toEqual(updatedCategory.icon);
    });

    it('should throw a BadRequestException if category does not exist', async () => {
      // Arrange
      const categoryId = 100;

      // Act & Assert
      await expect(service.updateCategory(categoryId, null)).rejects.toThrow();
    });
});

describe('deleteCategory', () => {
    it('should delete a category by id', async () => {
      
      // Act
      const result = await service.deleteCategory(10);

      // Assert
      expect(result).toEqual(`Category with ID ${10} deleted`);

      const deletedCategory = await repository.getById(10);
      expect(deletedCategory).toBeUndefined();
    });
  });
});
