import { Injectable } from "@nestjs/common";
import { DatabaseService } from "../../databases/database.service";
import { UserEntity, UserOtpEntity } from "../../models/user/user";
import { BaseRepository } from "./base.repository";

@Injectable()
export class UsersRepository extends BaseRepository<UserEntity> {

  constructor(protected readonly db: DatabaseService) {
    super(db, 'users');
  }
}

@Injectable()
export class UserOtpsRepository extends BaseRepository<UserOtpEntity> {

  constructor(protected readonly db: DatabaseService) {
    super(db, 'user_otps');
  }
}