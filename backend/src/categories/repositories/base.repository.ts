import { DatabaseService } from "src/databases/database.service";
import { IEntity } from "src/models/user/user";

export abstract class BaseRepository<T extends IEntity> {
  protected readonly tableName: string;

  constructor(protected readonly db: DatabaseService, tableName: string) {
    this.tableName = tableName;
  }

  async getById(id: number){
    return this.db.getKnexInstance()(this.tableName).where({ id }).first();
  }

  async getAll(): Promise<T[]> {
    return this.db.getKnexInstance()(this.tableName).select();
  }

  async getFirst(filter): Promise<T> {
    return this.db.getKnexInstance()(this.tableName).where(filter).first();
  }
}
