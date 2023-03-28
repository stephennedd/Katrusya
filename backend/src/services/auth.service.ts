import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ServerResponse } from 'http';
import { DatabaseService } from 'src/databases/database.service';
import { AuthenticationRequest, CreateUserDto } from 'src/dto/create-user.dto';
import { AuthenticationResponse } from 'src/dto/responses/minimal-user-dto';
import { UserOtpsRepository, UsersRepository } from 'src/repositories/users.repository';
import { UsersService } from './users/users.service';
import * as bcrypt from 'bcrypt';
import { UserEntity } from 'src/models/user/user';
import { plainToClass } from 'class-transformer';
@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
    private readonly db: DatabaseService,
    private readonly userRepository: UsersRepository,
    private readonly userOtpsRepository: UserOtpsRepository
  ) { }

  async validateUser(username: string, password: string): Promise<any> {
    const user = await this.userRepository.getFirst({ username });
    //compare hashed password
    if (user && user.password === password) {
      const { password, ...result } = user;
      return result;
    }
    return null;
  }

  async loginUser(request: AuthenticationRequest): Promise<AuthenticationResponse> {
    var user = await this.userRepository.getFirst({ email: request.email });
    
    if (user?.is_active != true)
      throw new NotFoundException(`user not found`);

    if (!(await bcrypt.compare(request.password, user.password)))
      throw new NotFoundException(`user not found`);

    return await this.refreshTokenAsync(user);
  }

  async registerUser(createUserDto: CreateUserDto): Promise<AuthenticationResponse> {
    const doesUserEmailExist = await this.usersService.getUserBasedOnEmail(createUserDto.email);
    if(doesUserEmailExist){
      throw new BadRequestException("user email already exists");
    }
    const doesUsernameExist = await this.usersService.getUserBasedOnUsername(createUserDto.username);
    if(doesUsernameExist){
      throw new BadRequestException("username already exists");
    }
    const doesPhoneExist = await this.usersService.getUserBasedOnPhone(createUserDto.phone);
    if(doesPhoneExist){
      throw new BadRequestException("phone already exists");
    }
    const user = await this.usersService.create(createUserDto);
    if (user) {
      return await this.generateToken(user);
    }
    return null;
  }

  private async refreshTokenAsync(user: UserEntity): Promise<AuthenticationResponse> {
    if (user?.is_active == true) {
      return this.generateToken(user);
    }

    throw new NotFoundException("user not found");
  }

  private async hashPass(password: string): Promise<string> {
    const saltOrRounds = 10;
    const hashedPassword = await bcrypt.hash(password, saltOrRounds);
    return hashedPassword;
  }

  public async confirmEmailAsync(userId: number, code: string): Promise<void> {
    await this.throwIfInvalidateOTP(userId, code);

    // email confirmed
    var user = await this.userRepository.getById(userId);
    user.is_active = true;
    user.emailConfirmed = true;
    await this.userRepository.update(user);
  }

  private async throwIfInvalidateOTP(userId: number, token: string) {
    let otp = await this.userOtpsRepository.getFirst({ userId }); // returns the first matching row or undefined

    if (otp == null || otp.isExpired)
      throw new NotFoundException(`User not found`);

    // Note: token == "1234" is for TEST
    if (otp.activationCode.toString() != token && token != "1234") {
      otp.requestCount++;
      if (otp.requestCount > 3)
        otp.isExpired = true;

      await this.userOtpsRepository.update(otp);

      throw new NotFoundException(`Otp code is invalid`);
    }
  }


  public async generateToken(user: UserEntity): Promise<AuthenticationResponse> {
    delete user.password;
    const payload = {
      username: user.username,
      id: user.id,
    };

    const accessToken = this.jwtService.sign(payload);

    let response = plainToClass(AuthenticationResponse, user);
    response.isAuthenticated = true;
    response.accessToken = accessToken;
    response.expiresIn = 60;

    return response;
  }


}