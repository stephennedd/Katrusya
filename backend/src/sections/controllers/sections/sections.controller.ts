import { Controller, Get, Param } from '@nestjs/common';
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
}
