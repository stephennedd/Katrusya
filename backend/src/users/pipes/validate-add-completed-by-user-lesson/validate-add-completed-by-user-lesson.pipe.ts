import { ArgumentMetadata, Injectable, PipeTransform } from '@nestjs/common';
import { AddCompletedLessonDto } from 'src/users/dtos/AddCompletedLesson.dtos';

@Injectable()
export class ValidateAddCompletedByUserLessonPipe implements PipeTransform {
  transform(value: AddCompletedLessonDto, metadata: ArgumentMetadata) {
    return value;
  }
}
