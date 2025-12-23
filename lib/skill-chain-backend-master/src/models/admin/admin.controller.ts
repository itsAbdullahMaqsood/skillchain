import { Controller, Post, Body, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { AdminService } from './admin.service';
import { AdminLoginRequestDto } from './serializers/login-request.serializer';
import { AdminLoginResponseDto } from './serializers/login-response.serializer';

@ApiTags('Admin')
@Controller('admin')
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Admin login' })
  @ApiResponse({
    status: 200,
    description: 'Login successful',
    type: AdminLoginResponseDto,
  })
  @ApiResponse({ status: 401, description: 'Invalid credentials' })
  async login(@Body() loginDto: AdminLoginRequestDto): Promise<AdminLoginResponseDto> {
    const admin = await this.adminService.validateAdmin(
      loginDto.email,
      loginDto.password,
    );
    return this.adminService.login(admin);
  }
}

