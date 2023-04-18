import { Exclude } from "class-transformer";
import { Timestamp } from "typeorm";

export class UserEntity implements IEntity {
  id: number;
  username: string;
  @Exclude()
  password: string;
  email: string;
  is_active: boolean;
  email_confirmed: boolean;
  reset_token: string;
  reset_token_expiry: Date;
  avatar: string;
}

export class UserOtpEntity implements IEntity {
  id: number;
  userId: Number;
  activationCode: number;
  isMobileOtp?: boolean;
  isExpired: boolean;
  requestCount: number;
  expiryTime: number;
}

export class UserResultEntity implements IEntity {
  id: number;
  user_id:number;
  test_id:number;
  number_of_hp_points: number;
}

export class UserFavoriteCourseEntity implements IEntity {
  id: number;
  user_id: number;
  course_id: number;
}

export class UserCourseEntity implements IEntity {
  id: number;
  user_id: number;
  course_id: number;
  is_completed: boolean;
}

export class UserCompletedSectionEntity implements IEntity {
  id: number;
  user_id: number;
  section_id: number;
  course_id: number;
}

export class UserLessonEntity implements IEntity {
  id: number;
  user_id: number;
  lesson_id: number;
  timestamp_of_last_viewed_moment: Timestamp
}

export class UserCompletedLessonEntity implements IEntity {
  id: number;
  user_id: number;
  lesson_id: number;
  section_id: number;
}

export interface IEntity {
  id: number;
}
