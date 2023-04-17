import { DatabaseService } from "../../databases/database.service";
import { IEntity } from "src/models/user/user";

interface QueryParams{
  category?: string,
  is_recommended?: boolean,
  is_featured?: boolean,
  search?:string
}

export abstract class BaseRepository<T extends IEntity> {
  protected readonly tableName: string;

  constructor(protected readonly db: DatabaseService, tableName: string) {
    this.tableName = tableName;
  }

  async getAll(): Promise<T[]> {
    return this.db.getKnexInstance()(this.tableName).select();
  }

  async getById(id: number): Promise<T> {
    return this.db.getKnexInstance()(this.tableName).where({ id }).first();
  }

  // async getAll(filter: any): Promise<T[]> {
  //   return this.db.getKnexInstance()(this.tableName).where(filter).select();
  // }

  async getFirst(filter): Promise<T> {
    return this.db.getKnexInstance()(this.tableName).where(filter).first();
  }

  async getSectionTest(sectionId:number){
    return this.db.getKnexInstance()(this.tableName)
      .select('tests.id', 'tests.title', 'tests.image_url', 'tests.description', 'tests.time_seconds')
      .where('tests.section_id', sectionId)
      .groupBy('tests.id')
      .first();
  }

  async getTestQuestions(testId: number){
    return this.db.getKnexInstance()(this.tableName).select().where('test_id', testId);
  }

  async getQuestionAnswers(questionId: number){
    const answers = this.db.getKnexInstance()(this.tableName)
          .select()
          .where('question_id', questionId)
          .orderBy('identifier');
    return answers;      
  }

  async doesLessonExist(lessonId:number){
    return this.db.getKnexInstance()(this.tableName)
        .select('id')
        .where('id', lessonId)
        .first();
  }

  async doesSectionExist(sectionId:number){
    return this.db.getKnexInstance()(this.tableName)
        .select('id')
        .where('id', sectionId)
        .first();
  }

  async doesLessonExistsInSection(lessonId: number, sectionId: number){
    return this.db.getKnexInstance()(this.tableName)
  .select('id')
  .where('id', lessonId)
  .andWhere('section_id', sectionId)
  .first();
  }

  async doesSectionExistsInCourse(sectionId: number, courseId: number){
    return this.db.getKnexInstance()(this.tableName)
  .select('id')
  .where('id', sectionId)
  .andWhere('course_id', courseId)
  .first();
  }

  async getLessonsInSection(sectionId:number){
    return this.db.getKnexInstance()(this.tableName)
    .select('id')
    .where('section_id', sectionId);
  }

  async getSectionsInCourse(courseId:number){
    return this.db.getKnexInstance()(this.tableName)
    .select('id')
    .where('course_id', courseId);
  }

  async create(entity: T): Promise<T> {
    const [id] = await this.db.getKnexInstance()(this.tableName)
      .insert(entity)
      .select('*');

    return {...entity, id};
  }

  async update(id:number,entity: T): Promise<T> {
    // const { id } = entity;
    await this.db.getKnexInstance()(this.tableName).where({ id }).update(entity);
    return entity;
  }

  async delete(id: number): Promise<void> {
    await this.db.getKnexInstance()(this.tableName).where({ id }).delete();
  }
}
