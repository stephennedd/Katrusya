export class SectionEntity implements IEntity {
    id: number
    title: string
    description: string
    image: string
    duration_in_hours: number
    course_id: number
  }

  export class LessonEntity implements IEntity {
    id: number
    title: string
    description: string
    video_url: string
    image: string
    duration_in_hours: number
    section_id: number
  }

  export class QuestionEntity implements IEntity {
    id: number
    question:string
    correct_answer:string
    selected_answer:string
    test_id:number
  }

  export class AnswerEntity implements IEntity {
    id: number
    identifier:string
    answer:string
    question_id:number
  }


  export interface IEntity {
    id: number;
  }