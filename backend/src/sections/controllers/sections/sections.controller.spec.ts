import { Test, TestingModule } from '@nestjs/testing';
import { SectionsController } from './sections.controller';
import { SectionsService } from '../../services/sections/sections.service';
import { DatabaseService } from '../../../databases/database.service';
import { AnswersRepository, QuestionsRepository, SectionsRepository, TestsRepository } from '../../repositories/sections.repository';

describe('SectionsController', () => {
  let controller: SectionsController;
  let service: SectionsService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [SectionsController],
      providers: [SectionsService,DatabaseService,SectionsRepository,
        TestsRepository, QuestionsRepository, AnswersRepository],
    }).compile();

    controller = module.get<SectionsController>(SectionsController);
    service = module.get<SectionsService>(SectionsService);
  });

  describe('getSection', () => {
    it('should return a section by ID', async () => {
      const section = { id: 1, name: 'section 1' };
      jest.spyOn(service, 'getSection').mockResolvedValue(section);

      expect(await controller.getSection(section.id)).toBe(section);
    });
  });

  describe('getTestBasedOnSectionId', () => {
    it('should return a test by section ID', async () => {
      const sectionId = 1;
      const test = { id: 1, name: 'test 1', sectionId };
      jest.spyOn(service, 'getTestBySectionId').mockResolvedValue(test);

      expect(await controller.getTestBasedOnSectionId(sectionId)).toBe(test);
    });
  });
});
