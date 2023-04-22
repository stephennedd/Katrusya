import { DatabaseService } from "../../databases/database.service";
import { IEntity } from "../../models/user/user";

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

  async getById(id: number): Promise<T> {
    return this.db.getKnexInstance()(this.tableName).where({ id }).first();
  }

  async getAll(filter: any): Promise<T[]> {
    return this.db.getKnexInstance()(this.tableName).where(filter).select();
  }

  async getFirst(filter): Promise<T> {
    return this.db.getKnexInstance()(this.tableName).where(filter).first();
  }

  async getCourses(queryParams: QueryParams){
    let query = this.db.getKnexInstance()(this.tableName);
      
    // Apply filters based on query params
    if (queryParams.category!==undefined) {
        query = query
        .join('course_categories', 'courses.id', 'course_categories.course_id')
        .join('categories', 'categories.id', 'course_categories.category_id')
        .where('categories.name', queryParams.category)
    }
  
    if (queryParams.is_recommended!==undefined) {
      query = query.where('is_recommended', queryParams.is_recommended? 1 : 0);
    }
  
    if (queryParams.is_featured!==undefined) {
      query = query.where('is_featured', queryParams.is_featured? 1 : 0);
    }

    if (queryParams.search!==undefined) {
        query = query.whereRaw(`JSON_CONTAINS(tags->'$[*]', '["${queryParams.search}"]')`)
      }

       // Add a left join with the sections and lessons tables to count the number of lessons for each course
query = query
.leftJoin('sections', 'sections.course_id', '=', 'courses.id')
.leftJoin('lessons', 'lessons.section_id', '=', 'sections.id')
.select('courses.*', this.db.getKnexInstance().raw('COUNT(DISTINCT lessons.id) as number_of_lessons'),
this.db.getKnexInstance().raw('COUNT(DISTINCT sections.id) as number_of_sections'))
.groupBy('courses.id');

return query;
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

  async getCourseQuizzes(courseId: number){
    return this.db.getKnexInstance()(this.tableName).select('tests.title as quiz_title','tests.section_id as section_id',
    'tests.image_url as image_url','tests.course_id')
    .count('questions.id as number_of_questions')
    .leftJoin('questions', 'tests.id', 'questions.test_id')
    .where('tests.course_id', courseId)
    .groupBy('tests.id')
    .orderBy('tests.section_id');
  }

  async getCourseDetails(courseId: number){
    return this.db.getKnexInstance()(this.tableName + " as c")
  .leftJoin("sections as s", "c.id", "s.course_id")
  .leftJoin("lessons as l", "s.id", "l.section_id")
  .select(
    "c.name as course_name",
    "c.description as course_description",
    "s.id as section_id",
    "s.title as section_title",
    "s.image as section_image",
    "l.image as lesson_image",
    "l.title as lesson_name",
    "l.duration_in_hours as lesson_duration_in_hours",
    "l.video_url",
    "l.id as lesson_id"
  )
  .where("c.id", courseId)
  .orderBy("s.id", "l.id");
  }

  async doesCourseExists(courseId:number): Promise<T>{
    const courseExists = this.db.getKnexInstance()(this.tableName).where('id', courseId).first();
    return courseExists;
  }

  async addUserCourse(courseId: number,userId: number): Promise<number[]>{
    const result = this.db.getKnexInstance()(this.tableName).insert({
      course_id: courseId,
      user_id: userId,
      is_completed: false
    });
    return result;
  }

  async addCourse(courseData){
    const [newCourseId] = await this.db.getKnexInstance()('courses')
        .insert({
          name: courseData.name,
          description: courseData.description,
          image: courseData.image,
          price: courseData.price,
          duration_in_hours: courseData.duration_in_hours,
          review: courseData.review,
          is_favorited: courseData.is_favorited,
          is_recommended: courseData.is_recommended,
          is_featured: courseData.is_featured,
          tags: courseData.tags,
        })

        console.log("Liza1");
        console.log(courseData.categories);
      // create new course categories records in the course_categories table
      const courseCategories = courseData.categories.map((categoryId) => ({
        course_id: newCourseId,
        category_id: categoryId,
      }));

      console.log("Liza2");
      
      const [newCourseCategoryId] = await this.db.getKnexInstance()('course_categories').insert(courseCategories);

      console.log("Liza3");
        
      // create new sections records in the sections table
      const sections = courseData.sections.map((section) => ({
        title: section.title,
        description: section.description,
        image: section.image,
        duration_in_hours: section.duration_in_hours,
        course_id: newCourseId,
      }));
       
      console.log("Liza4");

      let addedSectionsIds = [];
      for(let i = 0;i<sections.length;i++){
        const [newSectionId] = await this.db.getKnexInstance()('sections').insert(sections[i]);
        addedSectionsIds.push(newSectionId);
      }

      console.log("Liza5");
  
      // create new lessons records in the lessons table
      const lessons = courseData.sections.flatMap((section, index) => {
        const sectionId = addedSectionsIds[index];
        return section.lessons.map((lesson) => ({
          title: lesson.title,
          description: lesson.description,
          video_url: lesson.video_url,
          image: lesson.image,
          duration_in_hours: lesson.duration_in_hours,
          section_id: sectionId,
        }));
      });
      console.log("Liza6");
      this.db.getKnexInstance()('lessons').insert(lessons);

      console.log("Liza7");
  
      // create new tests records in the tests table
      const tests = courseData.sections.flatMap((section, index) => {
        const sectionId = addedSectionsIds[index];
        return section.tests.map((test) => ({
          title: test.title,
          image_url: test.image_url,
          description: test.description,
          time_seconds: test.time_seconds,
          section_id: sectionId,
          course_id: newCourseId,
        }));
      });
      console.log("Liza8");
      let addedTests = [];
      for(let i = 0;i<tests.length;i++){
        const [newTestId] = await this.db.getKnexInstance()('tests').insert(tests[i]);
        addedTests.push({test_id:newTestId,section_id:tests[i].section_id});
      }
      console.log("Liza9");
     
      // create new questions and answers records in the questions and answers tables
      const questions = courseData.sections.flatMap((section, index) => {
        const sectionId = addedSectionsIds[index];
        const testId = addedTests.find((test) => test.section_id === sectionId).test_id;
  
        return section.tests.flatMap((test) => {
          return test.questions.map((question) => {
            const answers = question.answers.map((answer) => ({
              identifier: answer.identifier,
              answer: answer.answer,
            }));
            return {
              question: question.question,
              correct_answer: question.correct_answer,
              selected_answer: question.selected_answer,
              test_id: testId,
              answers,
            };
          });
        });
      });

      console.log("Liza10");
      let addedQuestionsIds = [];
      for(let i = 0;i<questions.length;i++){
        const [newQuestionId] = await this.db.getKnexInstance()('questions').insert(questions[i]);
        addedQuestionsIds.push(newQuestionId);
      }
      console.log("Liza11");
      const answers = questions.flatMap((question, index) => {
        const questionId = addedQuestionsIds[index];
        return question.answers.map((answer) => ({
          identifier: answer.identifier,
          answer: answer.answer,
          question_id: questionId,
        }));
    });
    console.log("Liza12");
    const insertedAnswers = await this.db.getKnexInstance()('answers').insert(answers)
}

  async create(entity: T): Promise<T> {
    const [id] = await this.db.getKnexInstance()(this.tableName)
      .insert(entity)
      .select('*');

    return {...entity, id};
  }

  async update(entity: T): Promise<T> {
    const { id } = entity;
    await this.db.getKnexInstance()(this.tableName).where({ id }).update(entity);
    return entity;
  }

  async delete(id: number): Promise<void> {
    await this.db.getKnexInstance()(this.tableName).where({ id }).delete();
  }
}
