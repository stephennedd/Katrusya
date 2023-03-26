import { ArgumentMetadata, HttpException, HttpStatus, Injectable, PipeTransform } from '@nestjs/common';

@Injectable()
export class ValidatePassBooleanQueryParamPipe implements PipeTransform {
  transform(value: any, metadata: ArgumentMetadata) {
    if(value!==undefined){
      if(value==='true'||value==='false'){
    const booleanQueryValue = value === 'true';
    return booleanQueryValue;
      } else{
        throw new HttpException(
          'Invalid Data Type for property is_recommended/is_featured. Expected Boolean (true/false)',
          HttpStatus.BAD_REQUEST,
        );
      }
    }
  }
}
