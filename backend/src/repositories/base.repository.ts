import { DatabaseService } from "src/databases/database.service";
import { IEntity } from "src/models/user/user";


export abstract class BaseRepository<T extends IEntity> {
  protected readonly tableName: string;

  constructor(protected readonly db: DatabaseService, tableName: string) {
    this.tableName = tableName;
  }

  async getById(id: number): Promise<T> {
    return this.db.getKnexInstance()(this.tableName).where({ id }).first();
  }

  async getAll(filter: any): Promise<T[]> {
    return this.db.getKnexInstance()(this.tableName).where(filter).select();
  }

  async getFirst(filter): Promise<T> {
    return this.db.getKnexInstance()(this.tableName).where(filter).first();
  }

  async getUserBasedOnEmail(email): Promise<T> {
    return this.db.getKnexInstance()(this.tableName).where({email}).first();
  }

  async getUserBasedOnUsername(username): Promise<T> {
    return this.db.getKnexInstance()(this.tableName).where({username}).first();
  }

  async getUserBasedOnPhone(phone): Promise<T> {
    return this.db.getKnexInstance()(this.tableName).where({phone}).first();
  }

  async create(entity: T): Promise<T> {
    const [id] = await this.db.getKnexInstance()(this.tableName)
      .insert(entity)
      .select('*');

    return {...entity, id};
  }

  async update(entity: T): Promise<T> {
    const { id } = entity;
    await this.db.getKnexInstance()(this.tableName).where({ id }).update(entity);
    return entity;
  }

  async delete(id: number): Promise<void> {
    await this.db.getKnexInstance()(this.tableName).where({ id }).delete();
  }
}
