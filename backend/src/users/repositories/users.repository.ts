import { Injectable } from "@nestjs/common";
import { DatabaseService } from "../../databases/database.service";
import { CourseEntity } from "src/models/course/course";
import { LessonEntity } from "src/models/section/section";
import { UserCompletedLessonEntity, UserCompletedSectionEntity, UserCourseEntity, UserEntity, UserFavoriteCourseEntity, UserLessonEntity, UserResultEntity } from "../../models/user/user";
import { BaseRepository } from "./base.repository";

@Injectable()
export class UsersRepository extends BaseRepository<UserEntity> {

  constructor(protected readonly db: DatabaseService) {
    super(db, 'users');
  }
}

@Injectable()
export class UserResultsRepository extends BaseRepository<UserResultEntity> {

  constructor(protected readonly db: DatabaseService) {
    super(db, 'user_results');
  }
}


@Injectable()
export class UserFavoriteCoursesRepository extends BaseRepository<UserFavoriteCourseEntity> {

  constructor(protected readonly db: DatabaseService) {
    super(db, 'user_favorite_courses');
  }
}


@Injectable()
export class UserCoursesRepository extends BaseRepository<UserCourseEntity> {

  constructor(protected readonly db: DatabaseService) {
    super(db, 'user_courses');
  }
}


@Injectable()
export class UserCompletedSectionsRepository extends BaseRepository<UserCompletedSectionEntity> {

  constructor(protected readonly db: DatabaseService) {
    super(db, 'user_completed_sections');
  }
}

@Injectable()
export class UserLessonsRepository extends BaseRepository<UserLessonEntity> {

  constructor(protected readonly db: DatabaseService) {
    super(db, 'user_lessons');
  }
}

@Injectable()
export class UserCompletedLessonsRepository extends BaseRepository<UserCompletedLessonEntity> {

  constructor(protected readonly db: DatabaseService) {
    super(db, 'user_completed_lessons');
  }
}