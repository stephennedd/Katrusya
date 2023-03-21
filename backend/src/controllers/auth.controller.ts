import { Controller, Get } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';

@Controller('auth')
@ApiTags('example')
export class AuthController {

    @Get()
    findAll(): string {
        return 'This action returns all examples';
    }

}
