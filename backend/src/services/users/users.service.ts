import { Injectable } from '@nestjs/common';
import { DatabaseService } from 'src/databases/database.service';
import * as bcrypt from 'bcrypt';
import { CreateUserDto } from 'src/dto/create-user.dto';
import { UserEntity, UserOtpEntity } from 'src/models/user/user';
import { plainToClass } from 'class-transformer';
import { EmailService } from '../messagings/email.service';
import { UserOtpsRepository, UsersRepository } from 'src/repositories/users.repository';

@Injectable()
export class UsersService {


  constructor(private readonly emailService: EmailService,
    private userRepository: UsersRepository,
    private userOtpsRepository: UserOtpsRepository
  ) { }


  async create(data: CreateUserDto): Promise<UserEntity> {

    let user = plainToClass(UserEntity, data);
    // hash the password with bcrypt
    const saltOrRounds = 10;
    const hashedPassword = await bcrypt.hash(data.password, saltOrRounds);
    user.password = hashedPassword;
    user.username = data.email;
    // user.id = -1;
    // insert the user into the database
    let userEntity = await this.userRepository.create(user); 

    //send verification email
    await this.SendVerificationPhoneAsync(userEntity);

    return userEntity;
  }


  private async SendVerificationPhoneAsync(user: UserEntity) {
    let otp = await this.GenerateConfirmationTokenAsync(user);
    await this.emailService.sendTemplateEmail(user.email, "katrusha otp code", "otp", { otp: otp.activationCode });
  }

  private Rand(min: number, max: number): number {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

  private async GenerateConfirmationTokenAsync(user: UserEntity): Promise<UserOtpEntity> {

    // Create a new UserOtp instance and assign values
    let otp = new UserOtpEntity();
    otp.isMobileOtp = false;
    otp.userId = user.id;
    otp.isExpired = false;
    otp.requestCount = 0;
    otp.activationCode = this.Rand(1000, 9999);
    
    let userOtpEntity = await this.userOtpsRepository.create(otp);

    return userOtpEntity;
  }
}
