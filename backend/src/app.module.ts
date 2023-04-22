import { MiddlewareConsumer, Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { CoursesModule } from './courses/courses.module';
import { SectionsModule } from './sections/sections.module';
import { UsersModule } from './users/users.module';
import { CategoriesModule } from './categories/categories.module';
import { AuthModule } from './auth/auth.module';

@Module({
  imports: [
    CoursesModule,
    SectionsModule,
    UsersModule,
    CategoriesModule,
    AuthModule
  ],
  controllers: [AppController,],
  providers: [AppService],
})
export class AppModule {
  configure(consumer: MiddlewareConsumer) {
    // add middleware here
  }

  static async setupSwagger(app) {
    const options = new DocumentBuilder()
      .setTitle('Katyusha API')
      .setDescription('game changer in toturials')
      .setVersion('1.0')
      .build();
    const document = SwaggerModule.createDocument(app, options);
    SwaggerModule.setup('docs', app, document);
  }

}
