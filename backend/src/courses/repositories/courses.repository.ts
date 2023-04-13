import { Injectable } from "@nestjs/common";
import { DatabaseService } from "../../databases/database.service";
import { CourseEntity, TestEntity, UserCourseEntity } from "../../models/course/course";
import { BaseRepository } from "./base.repository";

@Injectable()
export class CoursesRepository extends BaseRepository<any> {

  constructor(protected readonly db: DatabaseService) {
    super(db, 'courses');
  }
}

@Injectable()
export class UserCoursesRepository extends BaseRepository<UserCourseEntity> {

  constructor(protected readonly db: DatabaseService) {
    super(db, 'user_courses');
  }
}

@Injectable()
export class TestsRepository extends BaseRepository<TestEntity> {

  constructor(protected readonly db: DatabaseService) {
    super(db, 'tests');
  }
}