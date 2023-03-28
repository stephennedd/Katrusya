import { Exclude } from "class-transformer";

export class UserEntity implements IEntity {
  id: number;
  username: string;
  @Exclude()
  password: string;
  email: string;
  is_active: boolean;
  emailConfirmed: boolean;
  avatar: string;
  // add more fields here
}


export class UserOtpEntity implements IEntity {
  id: number;
  userId: Number;
  activationCode: number;
  isMobileOtp?: boolean;
  isExpired: boolean;
  requestCount: number;
}

export interface IEntity {
  id: number;
}
