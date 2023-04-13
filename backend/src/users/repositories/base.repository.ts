import { DatabaseService } from "src/databases/database.service";
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

  async getById(id: number){
    return this.db.getKnexInstance()(this.tableName).where({ id }).first();
  }

  async getAll(): Promise<T[]> {
    return this.db.getKnexInstance()(this.tableName).select();
  }

  async getFirst(filter): Promise<T> {
    return this.db.getKnexInstance()(this.tableName).where(filter).first();
  }

  async getUserResults(userId: number, testId: number) {
   const userResults = this.db.getKnexInstance()(this.tableName)
        .where({ user_id: userId, test_id: testId });
    return userResults;
  }

  async getFavoriteCourses(userId: number) {
   return this.db.getKnexInstance().select(
      'courses.id as course_id',
      'courses.name as course_name',
      'courses.image as course_image',
      'courses.price as course_price',
      this.db.getKnexInstance().raw('COUNT(DISTINCT lessons.id) as number_of_lessons'),
      'courses.duration_in_hours',
      'courses.review as course_review'
    ).from(this.tableName)
    .join('courses', 'courses.id', '=', 'user_favorite_courses.course_id')
    .leftJoin('sections', 'sections.course_id', '=', 'courses.id')
    .leftJoin('lessons', 'lessons.section_id', '=', 'sections.id')
    .where('user_favorite_courses.user_id', userId)
    .groupBy('courses.id');
  }

  async getUserCourses(userId:number){
    return (await (this.db.getKnexInstance().select(
      'courses.id as course_id',
      'courses.name as course_name',
      'courses.image as course_image',
      'user_courses.is_completed as is_completed',
      this.db.getKnexInstance().raw('COUNT(DISTINCT lessons.id) as number_of_lessons'),
      this.db.getKnexInstance().raw('COUNT(DISTINCT sections.id) as number_of_sections')
    )
      .from(this.tableName)
      .join('user_courses', 'user_courses.course_id', '=', 'courses.id')
      .leftJoin('sections', 'sections.course_id', '=', 'courses.id')
      .leftJoin('lessons', 'lessons.section_id', '=', 'sections.id')
      .where('user_courses.user_id', '=', userId)
      .groupBy('courses.id')
      .orderBy('user_courses.id', 'asc')))
  .map((course) => {
    return {
      ...course,
      is_completed: course.is_completed ? true : false,
    };
  });
  }

  async getCompletedLessons(userId:number,courseId:number){
    return this.db.getKnexInstance()(this.tableName)
    .select('user_completed_lessons.user_id','user_completed_lessons.lesson_id','user_completed_lessons.section_id',
    'sections.course_id')
    .join('sections', 'sections.id', '=', 'user_completed_lessons.section_id')
    .where({
      'user_completed_lessons.user_id': userId,
      'sections.course_id': courseId
    })
    .orderBy('user_completed_lessons.lesson_id', 'asc');
  }

  async getCompletedLessonsToKnowWhetherSectionIsCompleted(lessonsInThisSection,userId){
    return this.db.getKnexInstance()(this.tableName)
    .whereIn('lesson_id', lessonsInThisSection.map(l => l.id))
    .andWhere('user_id', userId);
  }
  async getCompletedSections(userId:number){
    return this.db.getKnexInstance()(this.tableName)
  .select('user_completed_sections.user_id','user_completed_sections.section_id',
  'user_completed_sections.course_id')
  .where({
    'user_completed_sections.user_id': userId
  })
  .orderBy('user_completed_sections.section_id', 'asc');
  }

  async getCompletedSectionsToKnowWhetherSectionIsCompleted(sectionsInThisCourse,
    userId){
      return this.db.getKnexInstance()(this.tableName)
      .whereIn('section_id', sectionsInThisCourse.map(s => s.id))
      .andWhere('user_id', userId);
  }

  async doesUserOwnCourse(userId:number,courseId:number){
    return this.db.getKnexInstance()(this.tableName)
    .select('id')
    .where({
      user_id: userId,
      course_id: courseId
    })
    .first();
  }

  async doesUserExist(userId: number){
    return this.db.getKnexInstance()(this.tableName)
    .select('id')
    .where('id', userId)
    .first();
  }

  async deleteUserCompletedLesson(userId:number,
    lessonId:number,sectionId:number){
    return this.db.getKnexInstance()(this.tableName)
    .where({
      user_id: userId,
      lesson_id: lessonId,
      section_id: sectionId
    })
    .delete(); 
  }

  async addUserCompletedLesson(userCompletedLesson){
    return this.db.getKnexInstance()(this.tableName).insert(userCompletedLesson);
  }

  async addUserCompletedSection(userCompletedSection){
    return this.db.getKnexInstance()(this.tableName).insert(userCompletedSection);
  }

  async deleteUserCompletedSection(userId:number,courseId:number,
    sectionId:number){
    return this.db.getKnexInstance()(this.tableName)
    .where({
      user_id: userId,
      course_id: courseId,
      section_id: sectionId,
    })
    .delete();
  }

  async markUserCourseAsUncompleted(userId:number,
    courseId:number){
    return this.db.getKnexInstance()(this.tableName)
    .where({
      user_id: userId,
      course_id: courseId
    })
    .update({
      is_completed: false
    }); 
  }

  async markUserCourseAsCompleted(userId:number,
    courseId:number){
    return this.db.getKnexInstance()(this.tableName)
    .where({
      user_id: userId,
      course_id: courseId
    })
    .update({
      is_completed: true
    }); 
  }

  async addUserFavoriteCourse(userId:number,courseId:number){
    return this.db.getKnexInstance()(this.tableName).insert({
      user_id: userId, // the ID of the user who is adding the favorite course
      course_id: courseId // the ID of the course that the user is adding to their favorites
    });
  }

  async deleteUserFavoriteCourse(userId:number, courseId:number){
    return this.db.getKnexInstance()(this.tableName)
    .where({
      user_id: userId,
      course_id: courseId
    })
    .del();
  }

  async getDeletedUserFavoriteCourse(userId:number, courseId:number){
    return this.db.getKnexInstance().select(
      'courses.id as course_id',
      'courses.name as course_name',
      'courses.image as course_image',
      'courses.price as course_price',
      this.db.getKnexInstance().raw('COUNT(DISTINCT lessons.id) as number_of_lessons'),
      'courses.duration_in_hours',
      'courses.review as course_review'
    ).from(this.tableName)
    .join('courses', 'courses.id', '=', 'user_favorite_courses.course_id')
    .leftJoin('sections', 'sections.course_id', '=', 'courses.id')
      .leftJoin('lessons', 'lessons.section_id', '=', 'sections.id')
      .where({
        user_id: userId,
        'user_favorite_courses.course_id': courseId
      })
      .then(rows => {
        const [deletedRow] = rows;
        return deletedRow;
      });
  }

  async doesUserOwnTest(userId:number,testId:number){
    return this.db.getKnexInstance()(this.tableName).select('user_courses.id')
  .join('sections', 'user_courses.course_id', '=', 'sections.course_id')
  .join('tests', 'tests.section_id', '=', 'sections.id')
  .where('user_courses.user_id', userId)
  .andWhere('tests.id', testId);
  }

  async getUpdatedUserFavoritedCourse(userId:number, courseId: number){
    return this.db.getKnexInstance().select(
      'courses.id as course_id',
      'courses.name as course_name',
      'courses.image as course_image',
      'courses.price as course_price',
      this.db.getKnexInstance().raw('COUNT(DISTINCT lessons.id) as number_of_lessons'),
      'courses.duration_in_hours',
      'courses.review as course_review'
    ).from(this.tableName)
    .join('courses', 'courses.id', '=', 'user_favorite_courses.course_id')
    .leftJoin('sections', 'sections.course_id', '=', 'courses.id')
    .leftJoin('lessons', 'lessons.section_id', '=', 'sections.id')
    .where({ user_id: userId, 'user_favorite_courses.course_id': courseId })
    .orderBy('courses.id', 'desc') // sort by created_at column in descending order
    .first(); 
  }

  async doesUserCompleteTest(userId: number, testId: number) {
    const userResults = await this.db.getKnexInstance()(this.tableName)
    .where('user_id', userId)
    .andWhere('test_id', testId)
    .first();
     return userResults;
   }

  async create(entity): Promise<T> {
    const [id] = await this.db.getKnexInstance()(this.tableName)
      .insert(entity)
      .select('*');

    return {...entity, id};
  }

  async addTimestampOfLastViewedMomentOfLesson(userId:number,
    lessonId:number){
    return this.db.getKnexInstance()(this.tableName)
    .insert({
      user_id: userId,
      lesson_id: lessonId,
      timestamp_of_last_viewed_moment: null
    });
  }

  async updateTimestampOfLastViewedMomentOfLesson(userId:number,
    lessonId:number,timestamp:Date){
    return this.db.getKnexInstance()(this.tableName)
      .where({ user_id: userId, lesson_id: lessonId })
      .update({ timestamp_of_last_viewed_moment: timestamp });
  }

  async getTimestampOfLastViewedMomentOfLesson(userId:number,
    lessonId:number){
    return this.db.getKnexInstance()(this.tableName).select('timestamp_of_last_viewed_moment')
  .where('user_id', userId)
  .andWhere('lesson_id', lessonId)
  .then(rows => {
    const timestamp = rows[0].timestamp_of_last_viewed_moment;
    const formattedTimestamp = timestamp.toISOString().slice(0, 19).replace('T', ' ');
    return formattedTimestamp
  })
  .catch(error => {
    console.error(error);
  })
  }

  async hasUserPurchasedTheCourse(userId: number, courseId: number){
    return this.db.getKnexInstance()(this.tableName)
    .select()
    .where({
      user_id: userId,
      course_id: courseId
    })
    .first();
  }

  async update(entity: T): Promise<T> {
    const { id } = entity;
    await this.db.getKnexInstance()(this.tableName).where({ id }).update(entity);
    return entity;
  }

  async updateUserRoles(updatedRolesJson,userId){
    return this.db.getKnexInstance()(this.tableName)
    .where({ id: userId })
    .update({ roles: updatedRolesJson });
  }

  async delete(id: number): Promise<void> {
    this.db.getKnexInstance()(this.tableName).where({ id }).delete();
  }
}
