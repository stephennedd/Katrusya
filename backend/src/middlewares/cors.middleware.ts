import { Injectable, NestMiddleware } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';

@Injectable()
export class CorsMiddleware implements NestMiddleware {
  use(req: Request, res: Response, next: NextFunction) {
    // res.setHeader('Access-Control-Allow-Origin', '*');
    // console.log("Hey");
    // next();
  }
}