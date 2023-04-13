import { Injectable } from "@nestjs/common";
import { DatabaseService } from "../../databases/database.service";
import { TestEntity } from "../../models/course/course";
import { AnswerEntity, LessonEntity, QuestionEntity, SectionEntity } from "../../models/section/section";
import { BaseRepository } from "./base.repository";

@Injectable()
export class SectionsRepository extends BaseRepository<SectionEntity> {

  constructor(protected readonly db: DatabaseService) {
    super(db, 'sections');
  }
}

@Injectable()
export class LessonsRepository extends BaseRepository<LessonEntity> {

  constructor(protected readonly db: DatabaseService) {
    super(db, 'lessons');
  }
}

@Injectable()
export class TestsRepository extends BaseRepository<TestEntity> {

  constructor(protected readonly db: DatabaseService) {
    super(db, 'tests');
  }
}

@Injectable()
export class QuestionsRepository extends BaseRepository<QuestionEntity> {

  constructor(protected readonly db: DatabaseService) {
    super(db, 'questions');
  }
}

@Injectable()
export class AnswersRepository extends BaseRepository<AnswerEntity> {

  constructor(protected readonly db: DatabaseService) {
    super(db, 'answers');
  }
}