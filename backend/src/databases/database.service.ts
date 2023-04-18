import { Injectable } from '@nestjs/common';
import knex, { Knex } from 'knex';
import config from './knexfile';

@Injectable()
export class DatabaseService {
  private readonly knex: Knex;

  constructor() {
    this.knex = knex(config);
  }

  getKnexInstance() {
    return this.knex;
  }

  async close() {
    await this.knex.destroy();
  }
}