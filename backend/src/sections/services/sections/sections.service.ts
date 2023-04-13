import { BadRequestException, Injectable } from '@nestjs/common';
import { Section } from '../../models/section';
import { AnswersRepository, QuestionsRepository, SectionsRepository, TestsRepository } from '../../repositories/sections.repository';
import { DatabaseService } from '../../../databases/database.service';

@Injectable()
export class SectionsService {
  constructor(private readonly dbService: DatabaseService,
    private readonly sectionsRepository: SectionsRepository,
    private readonly testsRepository: TestsRepository,
    private readonly questionsRepository: QuestionsRepository,
    private readonly answersRepository: AnswersRepository) {}

  async getSection(id: number): Promise<any> {
    const section: Section = await this.sectionsRepository.getById(id);
    if (!section) {
      throw new BadRequestException(`Section with ID ${id} does not exist`);
    }
    return section;
  }

  async getTestBySectionId(sectionId: number): Promise<any> {
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

}
