import { DatabaseService } from "../../databases/database.service";
import { IEntity } from "src/models/user/user";

export abstract class BaseRepository<T> {
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

  async create(entity: T): Promise<T> {
    const [created_id] = await this.db.getKnexInstance()(this.tableName).insert(entity).select('*');
    return entity;
  }

  async update(id: number, entity: T): Promise<T> {
   await this.db.getKnexInstance()(this.tableName).where({ id }).update(entity);
    return entity;
  }

  async delete(id: number): Promise<void> {
    await this.db.getKnexInstance()(this.tableName).where({ id }).del();
  }
}
