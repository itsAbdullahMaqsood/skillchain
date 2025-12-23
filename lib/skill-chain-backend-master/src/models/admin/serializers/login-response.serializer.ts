import { ApiProperty } from '@nestjs/swagger';

export class AdminDataDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  fullName: string;

  @ApiProperty({ nullable: true })
  profilePic: string | null;

  @ApiProperty()
  phoneNumber: string;

  @ApiProperty()
  email: string;
}

export class AdminLoginResponseDto {
  @ApiProperty({ type: AdminDataDto })
  admin: AdminDataDto;

  @ApiProperty()
  accessToken: string;

  @ApiProperty()
  refreshToken: string;
}

