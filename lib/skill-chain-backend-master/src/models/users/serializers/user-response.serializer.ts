import { ApiProperty } from '@nestjs/swagger';

export class UserDataDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  fullName: string;

  @ApiProperty()
  email: string;

  @ApiProperty({ nullable: true })
  bio: string;

  @ApiProperty()
  age: number;

  @ApiProperty()
  gender: string;

  @ApiProperty({ nullable: true })
  profilePic: string | null;

  @ApiProperty()
  location: string;

  @ApiProperty()
  phoneNumber: string;

  @ApiProperty()
  education: string;

  @ApiProperty({ type: [String] })
  offeringSkills: string[];

  @ApiProperty({ type: [String] })
  learningSkills: string[];

  @ApiProperty()
  pastExperience: string;

  @ApiProperty()
  portfolioLink: string;

  @ApiProperty({ nullable: true })
  resume: string | null;

  @ApiProperty()
  timeCoins: number;

  @ApiProperty({ nullable: true })
  subscriptionPackage: string | null;

  @ApiProperty()
  ratings: number;

  @ApiProperty({ type: [Object] })
  reviews: any[];

  @ApiProperty()
  status: string;

  @ApiProperty()
  verified: boolean;

  @ApiProperty({ type: [String] })
  earnedCertificates: string[];
}

export class SignupResponseDto {
  @ApiProperty({ type: UserDataDto })
  user: UserDataDto;

  @ApiProperty()
  accessToken: string;

  @ApiProperty()
  refreshToken: string;
}

export class LoginResponseDto {
  @ApiProperty({ type: UserDataDto })
  user: UserDataDto;

  @ApiProperty()
  accessToken: string;

  @ApiProperty()
  refreshToken: string;
}

