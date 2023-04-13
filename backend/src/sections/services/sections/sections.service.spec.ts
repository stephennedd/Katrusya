import { BadRequestException } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { AnswersRepository, QuestionsRepository, SectionsRepository, TestsRepository } from '../../repositories/sections.repository';
import { DatabaseService } from '../../../databases/database.service';
import { SectionsService } from './sections.service';
import { SectionEntity } from 'src/models/section/section';

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

  describe('getSection', () => {
    it('should return a section by id', async () => {
      jest.spyOn(sectionsRepository, 'getById').mockResolvedValue(mockSection);
      expect(await service.getSection(mockSection.id)).toBe(mockSection);
    });

    it('should throw a BadRequestException if section is not found', async () => {
      jest.spyOn(sectionsRepository, 'getById').mockResolvedValue(undefined);
      await expect(service.getSection(mockSection.id)).rejects.toThrow(BadRequestException);
    });
  });

  describe('getTestBySectionId', () => {
    it('should return a test with questions and answers for a given section id', async () => {
      jest.spyOn(testsRepository, 'getSectionTest').mockResolvedValue(mockTest);
      jest.spyOn(questionsRepository, 'getTestQuestions').mockResolvedValue([mockQuestion]);
      jest.spyOn(answersRepository, 'getQuestionAnswers').mockResolvedValue([mockAnswer]);

      const result = await service.getTestBySectionId(mockSection.id);

      expect(result.id).toBe(mockTest.id);
      expect(result.questions).toEqual([{ ...mockQuestion, answers: [mockAnswer] }]);
    });

    it('should throw a BadRequestException if test is not found for given section id', async () => {
      jest.spyOn(testsRepository, 'getSectionTest').mockResolvedValue(undefined);
      await expect(service.getTestBySectionId(mockSection.id)).rejects.toThrow(BadRequestException);
    });
  });
});
