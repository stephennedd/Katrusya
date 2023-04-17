import { BadRequestException, Injectable } from '@nestjs/common';
import { Section } from '../../models/section';
import { AnswersRepository, QuestionsRepository, SectionsRepository, TestsRepository } from '../../repositories/sections.repository';
import { DatabaseService } from '../../../databases/database.service';
import { SectionEntity } from 'src/models/section/section';

@Injectable()
export class SectionsService {
  constructor(private readonly dbService: DatabaseService,
    private readonly sectionsRepository: SectionsRepository,
    private readonly testsRepository: TestsRepository,
    private readonly questionsRepository: QuestionsRepository,
    private readonly answersRepository: AnswersRepository) {}
   
    async getSections(): Promise<any>{
      const categories = await this.sectionsRepository.getAll();
      //await knex('categories').select('*');
      return categories;
    }
  async getSection(id: number): Promise<any> {
    const section: Section = await this.sectionsRepository.getById(id);
    if (!section) {
      throw new BadRequestException(`Section with ID ${id} does not exist`);
    }
    return section;
  }

  async getTestBySectionId(sectionId: number): Promise<any> {
    const section: Section = await this.sectionsRepository.getById(sectionId);
    if (!section) {
      throw new BadRequestException(`Section with ID ${sectionId} does not exist`);
    }
    const test = await this.testsRepository.getSectionTest(sectionId);
    if (!test) {
      throw new BadRequestException(`Test of section with ID ${sectionId} does not exist`);
    }
    const questions = await this.questionsRepository.getTestQuestions(test.id);

    for (const question of questions) {
        const answers = await this.answersRepository.getQuestionAnswers(question.id)
        question.answers = answers;
      }

      test.questions = questions
 
  return test;
   
 }

 async addSection(category: SectionEntity): Promise<SectionEntity> {
  return this.sectionsRepository.create(category);
}

async updateSection(id:number,category: SectionEntity): Promise<SectionEntity> {
  const section: Section = await this.sectionsRepository.getById(id);
    if (!section) {
      throw new BadRequestException(`Section with ID ${id} does not exist`);
    }
  return this.sectionsRepository.update(id,category);
}

async deleteSection(id: number): Promise<string> {
  const section: Section = await this.sectionsRepository.getById(id);
  if (!section) {
    throw new BadRequestException(`Section with ID ${id} does not exist`);
  }
  await this.sectionsRepository.delete(id);
  return `Section with ID ${id} deleted`;
}

}
