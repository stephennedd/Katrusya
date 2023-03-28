import { Injectable } from '@nestjs/common';
import { MailerService } from '@nestjs-modules/mailer';
const path = require('path');

@Injectable()
export class EmailService {
    constructor(private readonly mailerService: MailerService) { }

    async sendTextEmail(to: string, subject: string, text: string) {
        try {
            await this.mailerService.sendMail({
                to,
                subject,
                text,
            });
            return true;
        } catch (error) {
            console.error(error);
            return false;
        }
    }

    async sendTemplateEmail(to: string, subject: string, template: string, data: any) {
        try {
            // this is causing the error
            await this.mailerService.sendMail({
                to,
                subject, 
                template: path.resolve(`dist/public/templates/${template}.hbs`), // The name of the handlebars file in the templates folder
                context: { to, subject, ...data },
            });
            return true;
        } catch (error) {
            console.error(error);
            return false;
        }
    }
}