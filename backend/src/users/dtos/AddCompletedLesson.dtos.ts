import { IsInt, IsNotEmpty } from 'class-validator';

export class AddCompletedLessonDto {
  @IsInt()
  @IsNotEmpty()
  lesson_id: number;
  @IsInt()
  @IsNotEmpty()
  section_id: number;
  @IsInt()
  @IsNotEmpty()
  course_id: number;
}