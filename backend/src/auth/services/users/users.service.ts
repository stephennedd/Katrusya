import { Injectable, NotFoundException } from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import { CreateUserDto } from 'src/dto/create-user.dto';
import { UserEntity, UserOtpEntity } from 'src/models/user/user';
import { plainToClass } from 'class-transformer';
import { EmailService } from '../messagings/email.service';
import { UserOtpsRepository, UsersRepository } from '../../repositories/users.repository';

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
    user.username = data.username;
    //isActive is true by default
    user.is_active = true;
    // user.id = -1;
    // insert the user into the database
    let userEntity = await this.userRepository.create(user); 

    //send verification email
    await this.SendVerificationPhoneAsync(userEntity);

    return userEntity;
  }

  async update(userId: number, data): Promise<UserEntity> {
    const user = await this.userRepository.getById(userId);
  
    if (!user) {
      throw new NotFoundException(`User with ID ${userId} not found`);
    }
  
    if (data.username) {
      user.username = data.username;
    }
  
    if (data.email) {
      user.email = data.email;
    }
  
    if (data.password) {
      user.password = data.password;
    }
  
    await this.userRepository.update(user);
  
    return user;
  }

  async getUserBasedOnEmail(email: String): Promise<UserEntity> {

    let userEntity = await this.userRepository.getUserBasedOnEmail(email); 

    return userEntity;
  }

  async getUserBasedOnUsername(username: String): Promise<UserEntity> {

    let userEntity = await this.userRepository.getUserBasedOnUsername(username); 

    return userEntity;
  }

  async getUserBasedOnPhone(phone: String): Promise<UserEntity> {

    let userEntity = await this.userRepository.getUserBasedOnPhone(phone); 

    return userEntity;
  }


  private async SendVerificationPhoneAsync(user: UserEntity) {
    let otp = await this.GenerateConfirmationTokenAsync(user);
    await this.emailService.sendTemplateEmail(user.email, "katrusya otp code", "otp", { otp: otp.activationCode });
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
    otp.expiryTime = Date.now() + (5 * 60 * 1000);

    // Later, when you need to check if the OTP code is expired:
// if (otp.expiryTime < Date.now()) {
//   otp.isExpired = true;
//   // Handle expired OTP code
// }
    
    let userOtpEntity = await this.userOtpsRepository.create(otp);

    return userOtpEntity;
  }
}
