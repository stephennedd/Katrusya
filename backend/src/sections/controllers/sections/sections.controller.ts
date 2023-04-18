import { Controller, Get,Post, Put, Delete, Body, Param} from '@nestjs/common';
import { SectionEntity } from '../../../models/section/section';
import { SectionsService } from '../../services/sections/sections.service';

@Controller('sections')
export class SectionsController {
  constructor(private readonly sectionsService: SectionsService) {}

  @Get(':id')
  async getSection(@Param('id') id: number) {
    return this.sectionsService.getSection(id);
  }

  
  @Get(':id/test')
  async getTestBasedOnSectionId(@Param('id') id: number) {
    return this.sectionsService.getTestBySectionId(id);
  }

  @Get()
  async getSections() {
    return this.sectionsService.getSections();
  }


  @Post()
  async addSection(@Body() category: SectionEntity) {
    return this.sectionsService.addSection(category);
  }
    
  @Put(':id')
  async updateSection(@Param('id') id: number, @Body() category: SectionEntity) {
    return this.sectionsService.updateSection(id, category);
  }
    
  @Delete(':id')
  async deleteSection(@Param('id') id: number) {
    return this.sectionsService.deleteSection(id);
  }   
}
