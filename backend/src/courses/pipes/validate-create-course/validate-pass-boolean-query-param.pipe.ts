import { ArgumentMetadata, Injectable, PipeTransform } from '@nestjs/common';

@Injectable()
export class ValidatePassBooleanQueryParam implements PipeTransform {
  transform(value: any, metadata: ArgumentMetadata) {
    if(value!==undefined){
    const booleanQueryValue = value === 'true';
    return booleanQueryValue;
    }
  }
}
