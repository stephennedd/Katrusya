export class CourseEntity implements IEntity {
  id: number;
  name: string;
  description: string;
  image: string;
  price: string;
  duration_in_hours: number;
  review: string;
  is_favorited: boolean;
  is_recommended: boolean;
  is_featured: boolean;
  tags: string[]
}


export class UserCourseEntity implements IEntity {
  id: number;
  user_id: number;
  course_id: number;
  is_completed: boolean;
}

export class TestEntity implements IEntity {
    id: number;
    title: string;
    image_url: string;
    description: string;
    time_seconds: number;
    section_id: number;
    course_id: number;
}


export interface IEntity {
  id: number;
}