import { Inject, Injectable } from '@nestjs/common';
import { Knex } from 'knex';
import { DatabaseService } from 'src/databases/database.service';

export interface IUnitOfWork {
  start(): void;
  complete(work: () => void): Promise<void>;
  getRepository<T>(R: new (knex: Knex) => T): T;
}

@Injectable()
export class KnexUnitOfWork implements IUnitOfWork {
    private readonly asyncDatabaseConnection: Knex;
    private transaction: Knex.Transaction;

    constructor(
        private readonly db: DatabaseService,
    ) {
        this.asyncDatabaseConnection = db.getKnexInstance();
    }

    async start() {
        this.transaction = await this.asyncDatabaseConnection.transaction();
    }

    getRepository<T>(R: new (knex: Knex) => T): T {
        if (!this.transaction) {
            throw new Error('Unit of work is not started. Call the start () method');
        }
        return new R(this.transaction);
    }

    async complete(work: () => void) {
        try {
            await work();
            await this.transaction.commit();
        } catch (error) {
            await this.transaction.rollback();
            throw error;
        }
    }
}