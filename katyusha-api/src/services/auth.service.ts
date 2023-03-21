import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
//hello
@Injectable()
export class AuthService {
    constructor(private jwtService: JwtService) {}
  
    async validateUser(username: string, password: string): Promise<any> {
      // TODO: implement user authentication logic
    }
  
    async login(user: any) {
      const payload = { username: user.username, sub: user.userId };
      return {
        access_token: this.jwtService.sign(payload),
      };
    }
}
