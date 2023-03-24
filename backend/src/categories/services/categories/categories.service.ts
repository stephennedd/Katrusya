import { Injectable } from '@nestjs/common';
import { DatabaseService } from 'src/databases/database.service';

@Injectable()
export class CategoriesService {
    constructor(private readonly dbService: DatabaseService) {} 
    async getCategories(): Promise<any>{
        const knex = this.dbService.getKnexInstance();
        const categories = await knex('categories').select('*');
        return categories;
      }
}
