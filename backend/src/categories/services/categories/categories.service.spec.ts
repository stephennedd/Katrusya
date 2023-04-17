import { Test, TestingModule } from '@nestjs/testing';
import { CategoriesService } from './categories.service';
import { CategoriesRepository } from '../../repositories/categories.repository';
import { DatabaseService } from '../../../databases/database.service';
import { CategoryEntity } from 'src/models/category/category';
import { BadRequestException, NotFoundException } from '@nestjs/common';

describe('CategoriesService', () => {
  let service: CategoriesService;
  let repository: CategoriesRepository;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CategoriesService,
        CategoriesRepository,
        {
          provide: DatabaseService,
          useValue: {
            getKnexInstance: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<CategoriesService>(CategoriesService);
    repository = module.get<CategoriesRepository>(CategoriesRepository);
  });

  afterEach(() => {
    jest.resetAllMocks();
  });

  describe('getCategories', () => {
    it('should return an array of categories', async () => {
      // Arrange
      const categories: CategoryEntity[] = [
        { id: 1, name: 'Category 1', icon: "Icon 1" },
        { id: 2, name: 'Category 2', icon: "Icon 2" },
      ];
      jest.spyOn(repository, 'getAll').mockResolvedValue(categories);

      // Act
      const result = await service.getCategories();

      // Assert
      expect(result).toEqual(categories);
    });
  });

  describe('addCategory', () => {
    it('should create a category', async () => {
      // Arrange
      const category: CategoryEntity = {
        id: 1,
        name: 'Category 1',
        icon: "Icon 1"
      };
      jest.spyOn(repository, 'create').mockResolvedValue(category);

      // Act
      const result = await service.addCategory(category);

      // Assert
      expect(result).toEqual(category);
    });
  });

  describe('updateCategory', () => {
    it('should update a category', async () => {
      // Arrange
      const category: CategoryEntity = {
        id: 1,
        name: 'Category 1',
        icon: "Icon 1"
      };
      jest.spyOn(repository, 'getById').mockResolvedValue(category);
      jest.spyOn(repository, 'update').mockResolvedValue(category);

      // Act
      const result = await service.updateCategory(category.id, category);

      // Assert
      expect(result).toEqual(category);
    });

    it('should throw a BadRequestException if category does not exist', async () => {
      // Arrange
      const categoryId = 1;
      jest.spyOn(repository, 'getById').mockResolvedValue(null);

      // Act & Assert
      await expect(service.updateCategory(categoryId, null)).rejects.toThrow(BadRequestException);
    });
  });

  describe('deleteCategory', () => {
    it('should delete a category', async () => {
      // Arrange
      const categoryId = 1;
      jest.spyOn(repository, 'getById').mockResolvedValue({id: categoryId});
      jest.spyOn(repository, 'delete').mockResolvedValue(null);

      // Act
      const result = await service.deleteCategory(categoryId);

      // Assert
      expect(result).toEqual(`Category with ID ${categoryId} deleted`);
    });

    it('should throw a NotFoundException if category does not exist', async () => {
      // Arrange
      const categoryId = 1;
      jest.spyOn(repository, 'getById').mockResolvedValue(null);

      // Act & Assert
      await expect(service.deleteCategory(categoryId)).rejects.toThrow(NotFoundException);
    });
  });

  describe('getCategory', () => {
    it('should return a category with the specified ID', async () => {
      // Arrange
      const id = 1;
      const category: CategoryEntity = { id, name: 'Category 1', icon: "Icon 1" };
      jest.spyOn(repository, 'getById').mockResolvedValue(category);

      // Act
      const result = await service.getCategory(id);

      // Assert
      expect(result).toEqual(category);
    });

    it('should throw an error if the category with the specified ID does not exist', async () => {
      // Arrange
      const id = 1;
      jest.spyOn(repository, 'getById').mockResolvedValue(null);

      // Act
      let error;
      try {
        await service.getCategory(id);
      } catch (e) {
        error = e;
      }

      // Assert
      expect(error).toBeInstanceOf(BadRequestException);
      expect(error.message).toEqual(`The category with id ${id} does not exist`);
    });
  });
});
