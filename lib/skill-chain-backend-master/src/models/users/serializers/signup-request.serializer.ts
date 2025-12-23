import { ApiProperty } from '@nestjs/swagger';
import {
  IsEmail,
  IsNotEmpty,
  IsString,
  MinLength,
  IsNumber,
  IsEnum,
  IsOptional,
  IsArray,
  IsUrl,
  IsBoolean,
  ArrayMinSize,
} from 'class-validator';

export class SignupRequestDto {
  @ApiProperty({ example: 'John Doe' })
  @IsString()
  @IsNotEmpty()
  fullName: string;

  @ApiProperty({ example: 'john.doe@example.com' })
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @ApiProperty({ example: 'Password123!' })
  @IsString()
  @IsNotEmpty()
  @MinLength(6)
  password: string;

  @ApiProperty({ example: 'Software developer with 5 years of experience', required: false })
  @IsString()
  @IsOptional()
  bio?: string;

  @ApiProperty({ example: 28 })
  @IsNumber()
  @IsNotEmpty()
  age: number;

  @ApiProperty({ example: 'male', enum: ['male', 'female', 'other'] })
  @IsEnum(['male', 'female', 'other'])
  @IsNotEmpty()
  gender: string;

  @ApiProperty({ required: false, nullable: true })
  @IsString()
  @IsOptional()
  profilePic?: string | null;

  @ApiProperty({ example: 'New York, USA' })
  @IsString()
  @IsNotEmpty()
  location: string;

  @ApiProperty({ example: '+1234567890' })
  @IsString()
  @IsNotEmpty()
  phoneNumber: string;

  @ApiProperty({ example: 'Bachelor of Science in Computer Science', required: false })
  @IsString()
  @IsOptional()
  education?: string;

  @ApiProperty({ example: ['JavaScript', 'Node.js', 'React'], required: false })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  offeringSkills?: string[];

  @ApiProperty({ example: ['Python', 'Machine Learning', 'Data Science', 'AI', 'Deep Learning'] })
  @IsArray()
  @IsString({ each: true })
  @IsNotEmpty()
  @ArrayMinSize(5, { message: 'You must provide at least 5 skills you want to learn' })
  learningSkills: string[];

  @ApiProperty({ example: '5 years as Full Stack Developer', required: false })
  @IsString()
  @IsOptional()
  pastExperience?: string;

  @ApiProperty({ example: 'https://portfolio.example.com' })
  @IsUrl()
  @IsNotEmpty()
  portfolioLink: string;

  @ApiProperty({ required: false, nullable: true })
  @IsString()
  @IsOptional()
  resume?: string | null;
}

