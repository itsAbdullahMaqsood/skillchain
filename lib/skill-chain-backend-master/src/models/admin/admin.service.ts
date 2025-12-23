import { Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcrypt';
import { Admin, AdminDocument } from './entities/admin.entity';
import { IAdminPayload } from './interfaces/admin.interface';
import {
  ADMIN_JWT_EXPIRES_IN,
  ADMIN_JWT_REFRESH_EXPIRES_IN,
} from './constants/admin.constants';

@Injectable()
export class AdminService {
  constructor(
    @InjectModel(Admin.name) private adminModel: Model<AdminDocument>,
    private jwtService: JwtService,
    private configService: ConfigService,
  ) {}

  async validateAdmin(email: string, password: string): Promise<AdminDocument> {
    const admin = await this.adminModel.findOne({ email: email.toLowerCase() });
    
    if (!admin) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const isPasswordValid = await bcrypt.compare(password, admin.password);
    
    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid credentials');
    }

    return admin;
  }

  async login(admin: AdminDocument) {
    const payload: IAdminPayload = {
      sub: admin._id.toString(),
      email: admin.email,
      type: 'admin',
    };

    const accessToken = this.jwtService.sign(payload, {
      expiresIn: ADMIN_JWT_EXPIRES_IN,
    });

    const refreshToken = this.jwtService.sign(payload, {
      secret: this.configService.get<string>('jwt.refreshSecret') || 'refresh-secret',
      expiresIn: ADMIN_JWT_REFRESH_EXPIRES_IN,
    });

    return {
      admin: {
        id: admin._id.toString(),
        fullName: admin.fullName,
        profilePic: admin.profilePic,
        phoneNumber: admin.phoneNumber,
        email: admin.email,
      },
      accessToken,
      refreshToken,
    };
  }
}

