import { Injectable } from "@nestjs/common";
import { DatabaseService } from "../../databases/database.service";
import { CategoryEntity } from "../../models/category/category";
import { BaseRepository } from "./base.repository";

@Injectable()
export class CategoriesRepository extends BaseRepository<CategoryEntity> 
{

  constructor(protected readonly db: DatabaseService) {
    super(db, 'categories');
  }
}