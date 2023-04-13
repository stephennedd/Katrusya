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
});
