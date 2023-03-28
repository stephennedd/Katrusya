import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsString, IsPhoneNumber, Length } from 'class-validator';

export class AuthenticationRequest {
  @IsEmail()
  @ApiProperty()
  email: string;

  @Length(6)
  @ApiProperty()
  password: string;
}

export class CreateUserDto {
  @IsEmail()
  @ApiProperty()
  email: string;

  @IsNotEmpty()
  @ApiProperty()
  username: string;

  @ApiProperty()
  phone: string;
  
  @IsNotEmpty()
  @ApiProperty()
  password: string;
}

