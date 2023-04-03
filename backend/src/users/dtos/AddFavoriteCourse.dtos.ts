import { IsInt, IsNotEmpty } from 'class-validator';

export class AddFavoriteCourseDto {
  @IsInt()
  @IsNotEmpty()
  course_id: number;
}