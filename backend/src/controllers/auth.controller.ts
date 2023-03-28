import { Controller, Get, Post, UseGuards, Request, Body, Query } from '@nestjs/common';
import { ApiBody, ApiQuery, ApiResponse, ApiTags } from '@nestjs/swagger';
import { AuthenticationRequest, CreateUserDto } from 'src/dto/create-user.dto';
import { ResponseBase, ResponseGeneric } from 'src/dto/response.dto';
import { AuthenticationResponse } from 'src/dto/responses/minimal-user-dto';
import { AuthService } from 'src/services/auth.service';
@Controller('auth')
@ApiTags('Authentication')
export class AuthController {
    constructor(private authService: AuthService) {}

    // @UseGuards(LocalAuthGuard)
    @Post('login')
    @ApiBody({ type: AuthenticationRequest })
    @ApiResponse({type: ResponseGeneric<AuthenticationResponse>})
    async login(@Body() req: AuthenticationRequest) {
      let data  = await this.authService.loginUser(req);
      return new ResponseGeneric<AuthenticationResponse>(data);
    }

    @ApiBody({ type: CreateUserDto })
    @ApiResponse({type: ResponseGeneric<AuthenticationResponse>})
    @Post('register')
    async register(@Body() req: CreateUserDto): Promise<ResponseGeneric<AuthenticationResponse>> {
      let data  = await this.authService.registerUser(req);
      return new ResponseGeneric<AuthenticationResponse>(data);
    }

    // @ApiQuery({ type: CreateUserDto })
    @ApiResponse({type: ResponseBase})
    @ApiQuery({ name: 'userId', description: 'user id', type: Number, required: true })
    @ApiQuery({ name: 'code', description: 'confirmation code', type: String, required: true })
    @Post('confirm/email')
    async confirmEmail(@Query() model: { userId: number, code: string }) {
      await this.authService.confirmEmailAsync(model.userId, model.code);
      return ResponseBase.succeed("email successfully confirmed");
    }

}
