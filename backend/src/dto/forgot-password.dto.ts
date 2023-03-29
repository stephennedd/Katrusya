import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsString, IsPhoneNumber, Length } from 'class-validator';

export class ForgotPasswordDto {
  @IsEmail()
  @ApiProperty()
  email: string;
}
