import { ArgumentMetadata, BadRequestException, Injectable, PipeTransform } from '@nestjs/common';
import { CreateUserPurchase } from 'src/courses/dtos/CreateUserPurchase.dtos';

@Injectable()
export class ValidateCreateUserPurchasePipe implements PipeTransform {
  transform(value: CreateUserPurchase, metadata: ArgumentMetadata) {
    if (!value.courseId || !value.userId) {
      throw new BadRequestException('courseId and userId are required');
    }
    return value;
  }
}
