import { Module } from '@nestjs/common';
import { DatabaseService } from 'src/databases/database.service';
import { UsersController } from './controllers/users/users.controller';
import { UsersService } from './services/users/users.service';

@Module({
    controllers: [UsersController],
  providers: [UsersService, DatabaseService]
})
export class UsersModule {}
