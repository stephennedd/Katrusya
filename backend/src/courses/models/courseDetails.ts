export class CourseDetails {
    course_name: string
    course_description: string
    sections: Section[]
    number_of_lessons: number
    course_duration_in_hours: number
}

export class Section{
   id: number
   title: string
   image: string
   lessons: Lesson[]
   number_of_lessons: number
   section_duration_in_hours: number
}

export class Lesson {
lesson_id: number
section_id: number
lesson_name: string
lesson_duration_in_hours: number
video_url: string
image: string
}