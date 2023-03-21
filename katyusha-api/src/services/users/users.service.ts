import { Injectable } from '@nestjs/common';
import { DatabaseService } from '../../databases/database.service';

@Injectable()
export class UsersService {
  constructor(private readonly dbService: DatabaseService) {}

  async getUser(id: number): Promise<any> {
    const knex = this.dbService.getKnexInstance();
    const user = await knex('users').where({ id }).first();
    return user;
  }
}
