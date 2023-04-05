import { IsEmail, IsNotEmpty } from 'class-validator';

export class CreateUserDto {
  @IsNotEmpty()
  user_guid: string;

  @IsNotEmpty()
  name: string;

  @IsNotEmpty()
  avatar: string;

  @IsEmail()
  @IsNotEmpty()
  email: string;

  @IsNotEmpty()
  password: string;

  @IsNotEmpty()
  is_active: boolean;

  @IsNotEmpty()
  email_verified_at: string;

  // created_at: Date;
}
