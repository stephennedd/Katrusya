import { BadRequestException } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { AnswersRepository, QuestionsRepository, SectionsRepository, TestsRepository } from '../../repositories/sections.repository';
import { DatabaseService } from '../../../databases/database.service';
import { SectionsService } from './sections.service';
import { SectionEntity } from '../../../models/section/section';
import { Section } from 'src/sections/models/section';

describe('SectionsService', () => {
  let service: SectionsService;
  let sectionsRepository: SectionsRepository;
  let testsRepository: TestsRepository;
  let questionsRepository: QuestionsRepository;
  let answersRepository: AnswersRepository;

  const mockSection: SectionEntity = {
    id: 1,
    title: 'Section 1',
    description: 'This is a section 1',
    image: 'http://example.com/mock-image.png',
    duration_in_hours: 2,
    course_id: 1,
  };
  const mockTest = { id: 1, name: 'Test 1', sectionId: mockSection.id };
  const mockQuestion = { id: 1, text: 'Question 1', testId: mockTest.id };
  const mockAnswer = { id: 1, text: 'Answer 1', questionId: mockQuestion.id };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SectionsService,
        SectionsRepository,
        TestsRepository,
        QuestionsRepository,
        AnswersRepository,
        {
          provide: DatabaseService,
          useValue: {
            getKnexInstance: jest.fn(() => jest.fn().mockReturnValue({
              select: jest.fn(),
              where: jest.fn(),
            })),
          },
        },
      ],
    }).compile();

    service = module.get<SectionsService>(SectionsService);
    sectionsRepository = module.get<SectionsRepository>(SectionsRepository);
    testsRepository = module.get<TestsRepository>(TestsRepository);
    questionsRepository = module.get<QuestionsRepository>(QuestionsRepository);
    answersRepository = module.get<AnswersRepository>(AnswersRepository);
  });

  describe('getSections', () => {
    it('should return an array of sections', async () => {
      // Arrange
      
      const sections: SectionEntity[] = [
        {
        id: 1, description: "New description",
        title: 'New title',
        image: 'New image',
        duration_in_hours: 1,
        course_id: 1
        },
        { id: 2, description: "New description 2",
        title: 'New title 2',
        image: 'New image 2',
        duration_in_hours: 2,
        course_id: 2 },
      ];
      jest.spyOn(sectionsRepository, 'getAll').mockResolvedValue(sections);

      // Act
      const result = await service.getSections();

      // Assert
      expect(result).toEqual(sections);
    });
  });

  describe('getSection', () => {
    it('should return a section with the specified ID', async () => {
      // Arrange
      const section: SectionEntity = {
        id: 1, description: "New description",
        title: 'New title',
        image: 'New image',
        duration_in_hours: 1,
        course_id: 1
      };
      jest.spyOn(sectionsRepository, 'getById').mockResolvedValue(section);

      // Act
      const result = await service.getSection(section.id);

      // Assert
      expect(result).toEqual(section);
    });

    it('should throw a BadRequestException if the section does not exist', async () => {
      // Arrange
      const sectionId = 1;
      jest.spyOn(sectionsRepository, 'getById').mockResolvedValue(undefined);

      // Act & Assert
      await expect(service.getSection(sectionId)).rejects.toThrow(
        new BadRequestException(`Section with ID ${sectionId} does not exist`),
      );
    });
  });

  describe('addSection', () => {
    it('should create a section', async () => {
      // Arrange
      const section: SectionEntity = {
        id: 1, description: "New description",
        title: 'New title',
        image: 'New image',
        duration_in_hours: 1,
        course_id: 1
      };
      jest.spyOn(sectionsRepository, 'create').mockResolvedValue(section);

      // Act
      const result = await service.addSection(section);

      // Assert
      expect(result).toEqual(section);
    });
  });

  describe('updateSection', () => {
    it('should update a section', async () => {
      // Arrange
      const section: SectionEntity = {
        id: 1, description: "New description",
        title: 'New title',
        image: 'New image',
        duration_in_hours: 1,
        course_id: 1
      };
      jest.spyOn(sectionsRepository, 'getById').mockResolvedValue(section);
      jest.spyOn(sectionsRepository, 'update').mockResolvedValue(section);

      // Act
      const result = await service.updateSection(section.id, section);

      // Assert
      expect(result).toEqual(section);
    });

    it('should throw a BadRequestException if section does not exist', async () => {
      // Arrange
      const sectionId = 1;
      jest.spyOn(sectionsRepository, 'getById').mockResolvedValue(null);

      // Act & Assert
      await expect(service.updateSection(sectionId, null)).rejects.toThrow(BadRequestException);
    });
  });

  describe('deleteSection', () => {
    it('should delete a section', async () => {
      // Arrange
      const sectionId = 1;
      const section: SectionEntity = {
        id: 1, description: "New description",
        title: 'New title',
        image: 'New image',
        duration_in_hours: 1,
        course_id: 1
      };
      jest.spyOn(sectionsRepository, 'getById').mockResolvedValue(section);
      jest.spyOn(sectionsRepository, 'delete').mockResolvedValue(null);

      // Act
      const result = await service.deleteSection(sectionId);

      // Assert
      expect(result).toEqual('Section with ID 1 deleted');
    });

    it('should throw a BadRequestException if section does not exist', async () => {
      // Arrange
      const sectionId = 1;
      jest.spyOn(sectionsRepository, 'getById').mockResolvedValue(null);

      // Act & Assert
      await expect(service.deleteSection(sectionId)).rejects.toThrow(BadRequestException);
    });
  });
});
