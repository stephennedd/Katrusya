import { ArgumentMetadata, Injectable, PipeTransform } from '@nestjs/common';
import { AddFavoriteCourseDto } from 'src/users/dtos/AddFavoriteCourse.dtos';

@Injectable()
export class ValidateAddFavoriteCoursePipe implements PipeTransform {
  transform(value: AddFavoriteCourseDto, metadata: ArgumentMetadata) {
    return value;
  }
}
