import { IsEmail, IsNotEmpty } from 'class-validator';

export class CreateUserPurchase {
  @IsNotEmpty()
  userId: number;

  @IsNotEmpty()
  courseId: number;
}