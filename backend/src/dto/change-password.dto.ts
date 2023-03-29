import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsString, IsPhoneNumber, Length } from 'class-validator';

export class ChangePasswordDto {
  @ApiProperty()
  password: string;
}
