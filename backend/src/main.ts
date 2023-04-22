import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
require('dotenv').config(); 

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await AppModule.setupSwagger(app); // add this line
  app.enableCors();
  await app.listen(parseInt(process.env.PORT));
}
bootstrap();

// import { NestFactory } from '@nestjs/core';
// import { AppModule } from './app.module';
// import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
// import * as fs from 'fs';

// async function bootstrap() {
//   const app = await NestFactory.create(AppModule);

//   // Enable CORS
//   app.enableCors();

//   // Set up Swagger
//   const options = new DocumentBuilder()
//     .setTitle('My API')
//     .setDescription('API documentation')
//     .setVersion('1.0')
//     .build();
//   const document = SwaggerModule.createDocument(app, options);
//   SwaggerModule.setup('api', app, document);

//   // Save the OpenAPI contract as a JSON file
//   const jsonDocument = JSON.stringify(document);
//   fs.writeFileSync('openapi.json', jsonDocument);

//   await app.listen(3000);
// }
// bootstrap();
