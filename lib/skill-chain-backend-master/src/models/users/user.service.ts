import {
  Injectable,
  UnauthorizedException,
  ConflictException,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcrypt';
import { User, UserDocument } from './entities/user.entity';
import { SignupRequestDto } from './serializers/signup-request.serializer';
import { IUserPayload } from './interfaces/user.interface';
import {
  USER_JWT_EXPIRES_IN,
  USER_JWT_REFRESH_EXPIRES_IN,
} from './constants/user.constants';

@Injectable()
export class UserService {
  constructor(
    @InjectModel(User.name) private userModel: Model<UserDocument>,
    private jwtService: JwtService,
    private configService: ConfigService,
  ) {}

  async signup(signupDto: SignupRequestDto) {
    // Check if user already exists
    const existingUser = await this.userModel.findOne({
      $or: [
        { email: signupDto.email.toLowerCase() },
        { phoneNumber: signupDto.phoneNumber },
      ],
    });

    if (existingUser) {
      if (existingUser.email === signupDto.email.toLowerCase()) {
        throw new ConflictException('Email already exists');
      }
      throw new ConflictException('Phone number already exists');
    }

    // Hash password
    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash(signupDto.password, saltRounds);

    // Create user
    const userData = {
      fullName: signupDto.fullName,
      email: signupDto.email.toLowerCase(),
      password: hashedPassword,
      bio: signupDto.bio || '',
      age: signupDto.age,
      gender: signupDto.gender,
      profilePic: signupDto.profilePic || null,
      location: signupDto.location,
      phoneNumber: signupDto.phoneNumber,
      education: signupDto.education || '',
      offeringSkills: signupDto.offeringSkills || [],
      learningSkills: signupDto.learningSkills,
      pastExperience: signupDto.pastExperience || '',
      portfolioLink: signupDto.portfolioLink,
      resume: signupDto.resume || null,
      timeCoins: 0,
      subscriptionPackage: null,
      ratings: 0,
      reviews: [],
      status: 'active',
      verified: false,
      earnedCertificates: [],
    };

    const user = new this.userModel(userData);
    await user.save();

    return this.generateTokens(user);
  }

  async validateUser(email: string, password: string): Promise<UserDocument> {
    const user = await this.userModel.findOne({ email: email.toLowerCase() });

    if (!user) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid credentials');
    }

    if (user.status !== 'active') {
      throw new UnauthorizedException('Account is not active');
    }

    return user;
  }

  async login(user: UserDocument) {
    return this.generateTokens(user);
  }

  private generateTokens(user: UserDocument) {
    const payload: IUserPayload = {
      sub: user._id.toString(),
      email: user.email,
      type: 'user',
    };

    const accessToken = this.jwtService.sign(payload, {
      expiresIn: USER_JWT_EXPIRES_IN,
    });

    const refreshToken = this.jwtService.sign(payload, {
      secret: this.configService.get<string>('jwt.refreshSecret') || 'refresh-secret',
      expiresIn: USER_JWT_REFRESH_EXPIRES_IN,
    });

    return {
      user: {
        id: user._id.toString(),
        fullName: user.fullName,
        email: user.email,
        bio: user.bio,
        age: user.age,
        gender: user.gender,
        profilePic: user.profilePic,
        location: user.location,
        phoneNumber: user.phoneNumber,
        education: user.education,
        offeringSkills: user.offeringSkills,
        learningSkills: user.learningSkills,
        pastExperience: user.pastExperience,
        portfolioLink: user.portfolioLink,
        resume: user.resume,
        timeCoins: user.timeCoins,
        subscriptionPackage: user.subscriptionPackage,
        ratings: user.ratings,
        reviews: user.reviews,
        status: user.status,
        verified: user.verified,
        earnedCertificates: user.earnedCertificates,
      },
      accessToken,
      refreshToken,
    };
  }
}

