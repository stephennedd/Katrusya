import { Module } from '@nestjs/common';
import { DatabaseService } from 'src/databases/database.service';
import { SectionsController } from './controllers/sections/sections.controller';
import { SectionsService } from './services/sections/sections.service';

@Module({
    controllers: [SectionsController],
  providers: [SectionsService, DatabaseService]
})
export class SectionsModule {}
