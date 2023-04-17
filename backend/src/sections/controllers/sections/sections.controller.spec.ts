import { Test, TestingModule } from '@nestjs/testing';
import { SectionsController } from './sections.controller';
import { SectionsService } from '../../services/sections/sections.service';
import { DatabaseService } from '../../../databases/database.service';
import { AnswersRepository, QuestionsRepository, SectionsRepository, TestsRepository } from '../../repositories/sections.repository';
import { SectionEntity } from '../../../models/section/section';
import { BadRequestException } from '@nestjs/common';

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

  // describe('getSection', () => {
  //   it('should return a section by ID', async () => {
  //     const section = { id: 1, name: 'section 1' };
  //     jest.spyOn(service, 'getSection').mockResolvedValue(section);

  //     expect(await controller.getSection(section.id)).toBe(section);
  //   });
  // });

  describe('getTestBasedOnSectionId', () => {
    it('should return a test by section ID', async () => {
      const sectionId = 1;
      const test = { id: 1, name: 'test 1', sectionId };
      jest.spyOn(service, 'getTestBySectionId').mockResolvedValue(test);

      expect(await controller.getTestBasedOnSectionId(sectionId)).toBe(test);
    });
  });

  describe('getSections', () => {
    it('should return an array of sections', async () => {
      const sections = [{ id: 1, name: 'section 1' }, { id: 2, name: 'section 2' }];
      jest.spyOn(service, 'getSections').mockResolvedValue(sections);

      expect(await controller.getSections()).toBe(sections);
    });
  });

  describe('addSection', () => {
    it('should add a new section', async () => {
      const section: SectionEntity = {
        id: 1, description: "New Description",
        title: 'New title',
        image: 'New image',
        duration_in_hours: 1,
        course_id: 1
      };
      jest.spyOn(service, 'addSection').mockResolvedValue(section);

      const result = await controller.addSection(section);

      expect(result).toBe(section);
      expect(service.addSection).toHaveBeenCalledWith(section);
    });
  });

  describe('getSection', () => {
    it('should return a section by id', async () => {
      // Arrange
      const sectionId = 1;
      const section = { id: sectionId, name: 'Section 1', description: "Description 1" };
      jest.spyOn(service, 'getSection').mockResolvedValue(section);

      // Act
      const result = await controller.getSection(sectionId);

      // Assert
      expect(result).toEqual(section);
    });

    it('should throw a BadRequestException if the section does not exist', async () => {
      // Arrange
      const sectionId = 1;
      jest.spyOn(service, 'getSection').mockImplementation(() => {
        throw new BadRequestException(`The section with id ${sectionId} does not exist`);
      });

      // Act & Assert
      await expect(controller.getSection(sectionId)).rejects.toThrow(BadRequestException);
    });
  });

  describe('updateSection', () => {
    it('should update an existing section', async () => {
      // Arrange
      const section: SectionEntity = {
        id: 1, description: "New description",
        title: 'New title',
        image: 'New image',
        duration_in_hours: 1,
        course_id: 1
      };
      const id = 1;
      jest.spyOn(service, 'updateSection').mockResolvedValue(section);

      // Act
      const result = await controller.updateSection(id, section);

      // Assert
      expect(result).toBe(section);
      expect(service.updateSection).toHaveBeenCalledWith(id, section);
    });
  });

  describe('deleteSection', () => {
    it('should delete a section and return a success message', async () => {
      // Arrange
      const id = 1;
      const message = `Category with ID ${id} deleted`;
      jest.spyOn(service, 'deleteSection').mockResolvedValue(message);
    
      expect(await controller.deleteSection(id)).toBe(message);
    });
  });
});
