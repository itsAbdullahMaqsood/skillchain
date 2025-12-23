import { Injectable, Logger } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import * as bcrypt from 'bcrypt';
import { Admin, AdminDocument } from '../../../models/admin/entities/admin.entity';

@Injectable()
export class AdminSeederService {
  private readonly logger = new Logger(AdminSeederService.name);

  constructor(
    @InjectModel(Admin.name) private adminModel: Model<AdminDocument>,
  ) {}

  async seed() {
    try {
      // Check if admin already exists
      const existingAdmin = await this.adminModel.findOne({
        email: 'admin@skillchain.com',
      });

      if (existingAdmin) {
        this.logger.log('Admin already exists, skipping seed');
        return;
      }

      // Hash password
      const saltRounds = 10;
      const hashedPassword = await bcrypt.hash('Admin@123', saltRounds);

      // Create admin data
      const adminData = {
        fullName: 'Admin User',
        profilePic: null,
        phoneNumber: '+1234567890',
        email: 'admin@skillchain.com',
        password: hashedPassword,
      };

      // Create admin
      const admin = new this.adminModel(adminData);
      await admin.save();

      this.logger.log('Admin seeded successfully');
      this.logger.log(`Email: ${adminData.email}`);
      this.logger.log(`Password: Admin@123`);
    } catch (error) {
      this.logger.error('Error seeding admin:', error);
      throw error;
    }
  }

  async drop() {
    try {
      await this.adminModel.deleteMany({});
      this.logger.log('Admin collection dropped');
    } catch (error) {
      this.logger.error('Error dropping admin collection:', error);
      throw error;
    }
  }
}

