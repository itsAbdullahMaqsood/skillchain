import {
  Controller,
  Post,
  Body,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { UserService } from './user.service';
import { SignupRequestDto } from './serializers/signup-request.serializer';
import { LoginRequestDto } from './serializers/login-request.serializer';
import {
  SignupResponseDto,
  LoginResponseDto,
} from './serializers/user-response.serializer';

@ApiTags('Users')
@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Post('signup')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'User signup' })
  @ApiResponse({
    status: 201,
    description: 'User created successfully',
    type: SignupResponseDto,
  })
  @ApiResponse({ status: 409, description: 'Email or phone number already exists' })
  async signup(@Body() signupDto: SignupRequestDto): Promise<SignupResponseDto> {
    return this.userService.signup(signupDto);
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'User login' })
  @ApiResponse({
    status: 200,
    description: 'Login successful',
    type: LoginResponseDto,
  })
  @ApiResponse({ status: 401, description: 'Invalid credentials' })
  async login(@Body() loginDto: LoginRequestDto): Promise<LoginResponseDto> {
    const user = await this.userService.validateUser(
      loginDto.email,
      loginDto.password,
    );
    return this.userService.login(user);
  }
}

