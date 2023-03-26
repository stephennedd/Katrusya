import { ApiProperty } from "@nestjs/swagger";
import { SrvRecord } from "dns";

export class MinimalUserDto {
    @ApiProperty()
    userId: number;
    
    @ApiProperty()
    profileImageUrl: string;
    
    @ApiProperty()
    firstName: string;
    
    @ApiProperty()
    lastName: string;
    
    @ApiProperty()
    descriptions: string;
    
    @ApiProperty()
    created: Date;

    // using a getter and a setter to define a computed property
    get fullName(): string {
        return `${this.firstName} ${this.lastName}`;
    }

    set fullName(value: string) {
        const splittedNames = value.split(' ');
        if (splittedNames.length > 1) {
            this.firstName = splittedNames[0];
        }
        this.lastName = splittedNames[1];
    }

    constructor(data?: Partial<MinimalUserDto>) {
        Object.assign(this, data);
    }
}

export class UserDto extends MinimalUserDto {
    @ApiProperty()
    email: string;
}

export class AuthenticationResponse extends UserDto {
    @ApiProperty()
    phoneNumber: string;
    
    @ApiProperty()
    isAuthenticated: boolean;
    
    @ApiProperty()
    role: string;
    
    @ApiProperty()
    isTeacher: boolean;
    
    @ApiProperty()
    accessToken: string;
    
    @ApiProperty()
    expiresIn: number;
}