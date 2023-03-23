import { IsEmail, IsNotEmpty } from 'class-validator';

export class CreateUserResultsDto {
  @IsNotEmpty()
  user_id: number;

  @IsNotEmpty()
  test_id: number;

  @IsNotEmpty()
  number_of_hp_points: number;
}