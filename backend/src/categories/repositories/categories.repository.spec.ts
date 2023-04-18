import { Test, TestingModule } from '@nestjs/testing';
import { DatabaseService } from '../../databases/database.service';
import { CategoriesRepository } from './categories.repository';

describe('CategoriesRepository', () => {
  let repository: CategoriesRepository;
  let dbService: DatabaseService;

  const mockCategory = { id: 1, name: 'Category 1' };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CategoriesRepository,
        {
          provide: DatabaseService,
          useValue: {
            getKnexInstance: jest.fn(() => jest.fn().mockReturnValue({
                select: jest.fn(() => [mockCategory]),
                where: jest.fn(() => ({
                  first: jest.fn(() => mockCategory),
                  update: jest.fn(),
                  delete: jest.fn(),
                })),
              })),
          },
        },
      ],
    }).compile();

    repository = module.get<CategoriesRepository>(CategoriesRepository);
    dbService = module.get<DatabaseService>(DatabaseService);
  });

  describe('getAll', () => {
    it('should return an array of categories', async () => {
      const categories = await repository.getAll();
      expect(categories).toEqual([mockCategory]);
    });
  });

  describe('getById', () => {
    it('should return a category by id', async () => {
      const category = await repository.getById(1);
      expect(category).toEqual(mockCategory);
    });
  });

  describe('getFirst', () => {
    it('should return the first matching category', async () => {
      const filter = { name: 'Category 1' };
      const category = await repository.getFirst(filter);
      expect(category).toEqual(mockCategory);
    });
  });
});





