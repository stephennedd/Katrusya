import { Test, TestingModule } from '@nestjs/testing';
import { SectionsService } from './sections.service';
import { AnswersRepository, QuestionsRepository, SectionsRepository, TestsRepository } from '../../repositories/sections.repository';
import { DatabaseService } from '../../../databases/database.service';
import { CategoryEntity } from 'src/models/category/category';
import { SectionEntity } from 'src/models/section/section';

describe('SectionsService', () => {
    let service: SectionsService;
    let repository: SectionsRepository;
    let databaseService: DatabaseService;
  let testsRepository: TestsRepository;
  let questionsRepository: QuestionsRepository;
  let answersRepository: AnswersRepository;
 
  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SectionsService,
        SectionsRepository,
        TestsRepository,
        QuestionsRepository,
        AnswersRepository,
        DatabaseService
      ],
    }).compile();

    service = module.get<SectionsService>(SectionsService);
    repository = module.get<SectionsRepository>(SectionsRepository);
    service = module.get<SectionsService>(SectionsService);
    databaseService = module.get<DatabaseService>(DatabaseService);
    testsRepository = module.get<TestsRepository>(TestsRepository);
    questionsRepository = module.get<QuestionsRepository>(QuestionsRepository);
    answersRepository = module.get<AnswersRepository>(AnswersRepository);

    //await databaseService.connect();
  });
  afterAll(async () => {
    await databaseService.close();
  });

  describe('getSections', () => {
    it('should return an array of sections', async () => {
      const sections = await service.getSections();

      expect(sections).toHaveLength(11);
      expect(sections[0].title).toBe('Section 1 title');
      expect(sections[1].title).toBe('Section 1 title');
    });
  });

  describe('getSection', () => {
    it('should return a section by id', async () => {
      const sections = await service.getSections();
      const id = sections[0].id;

      const section = await service.getSection(id);

      expect(section).toBeDefined();
      expect(section.title).toBe('Section 1 title');
    });

    it('should throw a 400 BadRequestError if the section does not exist', async () => {
        const id = 100;
      
       try {
          await service.getSection(id);

        } catch (error) {
          expect(error.response.statusCode).toEqual(400);
          expect(error.response.message).toEqual(`Section with ID ${id} does not exist`);
          expect(error.response.error).toEqual('Bad Request');
        }
      });
  });

  describe('getTestBySectionId', () => {
    it('should return the test for the given section id', async () => {
      // Arrange
      
      // Act
      const result = await service.getTestBySectionId(1);

      // Assert
      expect(result).toBeDefined();
      expect(result.id).toEqual(1);
      expect(result.title).toEqual("Biology");
      expect(result.description).toEqual("Basic Biology Multiple Choice Questions (MCQ) to practice basic Biology quiz answers");
    });
});
  describe('addSection', () => {
    it('should create a section', async () => {
      // Arrange
      const section: SectionEntity = {
          id: 12,
          title: 'New section',
          description: 'New description',
          image: 'New image',
          duration_in_hours: 10,
          course_id: 1
      };

      // Act
      const result = await service.addSection(section);

      // Assert
      expect(result).toHaveProperty('id');
      expect(result.title).toEqual(section.title);
      expect(result.description).toEqual(section.description);
    });
  });

  describe('updateSection', () => {
    it('should update a section', async () => {
      // Act
      const section: SectionEntity = {
        id: 12,
        title: 'New updated section',
        description: 'New updated description',
        image: 'New updated image',
        duration_in_hours: 20,
        course_id: 1
    };
      const result = await service.updateSection(12, section);

      // Assert
      expect(result).toHaveProperty('id');
      expect(result.title).toEqual(section.title);
      expect(result.description).toEqual(section.description);
    });

    it('should throw a BadRequestException if category does not exist', async () => {
      // Arrange
      const sectionId = 100;

      // Act & Assert
      await expect(service.updateSection(sectionId, null)).rejects.toThrow();
    });
});

describe('deleteSection', () => {
    it('should delete a section by id', async () => {
      
      // Act
      const result = await service.deleteSection(12);

      // Assert
      expect(result).toEqual(`Section with ID ${12} deleted`);

      const deletedSection = await repository.getById(12);
      expect(deletedSection).toBeUndefined();
    });
  });
});