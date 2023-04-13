import { Test, TestingModule } from '@nestjs/testing';
import { CategoriesController } from './categories.controller';
import { CategoriesService } from '../../services/categories/categories.service';
import { CategoriesRepository } from '../../repositories/categories.repository';
import { DatabaseService } from '../../../databases/database.service';

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
});
