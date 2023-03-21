import { Injectable } from '@nestjs/common';
import { DatabaseService } from '../../../databases/database.service';

@Injectable()
export class SectionsService {
  constructor(private readonly dbService: DatabaseService) {}

  async getSection(id: number): Promise<any> {
    const knex = this.dbService.getKnexInstance();
    const section = await knex('sections').where({ id }).first();
    return section;
  }

  async getTestBySectionId(sectionId: number): Promise<any> {
    const knex = this.dbService.getKnexInstance();
    const test = await knex('tests')
      .select('tests.id', 'tests.title', 'tests.image_url', 'tests.description', 'tests.time_seconds')
      .where('tests.section_id', sectionId)
      .groupBy('tests.id')
      .first();

    const questions = await knex('questions').select().where('test_id', test.id);

    for (const question of questions) {
        const answers = await knex('answers')
          .select()
          .where('question_id', question.id);
        question.answers = answers;
      }

      test.questions = questions
 
  return test;
   
 }

}
