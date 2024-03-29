import { Controller,Post, UseGuards, Request, Body, Query, Patch } from '@nestjs/common';
import { Headers, Put } from '@nestjs/common/decorators';
import { AuthGuard } from '@nestjs/passport';
import { ApiBody, ApiResponse, ApiTags } from '@nestjs/swagger';
import { ChangePasswordDto } from '../../dto/change-password.dto';
import { AuthenticationRequest, CreateConfirmEmailDto, CreateUserDto } from '../../dto/create-user.dto';
import { ForgotPasswordDto } from '../../dto/forgot-password.dto';
import { ResponseBase, ResponseGeneric } from '../../dto/response.dto';
import { AuthenticationResponse } from '../../dto/responses/minimal-user-dto';
import { AuthService } from '../services/auth.service';
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
   // @ApiResponse({type: ResponseBase})
   // @ApiQuery({ name: 'userId', description: 'user id', type: Number, required: true })
   // @ApiQuery({ name: 'code', description: 'confirmation code', type: String, required: true })
   @ApiBody({ type: CreateConfirmEmailDto })
    @ApiResponse({type: ResponseBase})
    @Post('confirm/email')
    async confirmEmail(@Body() req: CreateConfirmEmailDto): Promise<ResponseGeneric<AuthenticationResponse>> {  
        await this.authService.confirmEmailAsync(req.userId, req.code);
      return ResponseBase.succeed("email successfully confirmed");
    }
    
    @Post('forgotPassword')
    async forgotPassword(@Body() forgotPasswordDto: ForgotPasswordDto) {
      await this.authService.sendPasswordResetEmail(forgotPasswordDto.email);
      return { message: 'Password reset email sent successfully.' };
    }
    
    @Put('/changePassword')
    @UseGuards(AuthGuard('jwt'))
    async changePassword(@Body() changePasswordDto: ChangePasswordDto,@Headers('Authorization') authorization: string){
        const token = authorization.replace('Bearer ', '');
        return this.authService.changePassword(changePasswordDto,token);
    }
}
