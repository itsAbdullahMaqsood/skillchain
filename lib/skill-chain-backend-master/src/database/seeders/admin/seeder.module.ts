import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AdminSeederService } from './seeder.service';
import { Admin, AdminSchema } from '../../../models/admin/entities/admin.entity';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Admin.name, schema: AdminSchema }]),
  ],
  providers: [AdminSeederService],
  exports: [AdminSeederService],
})
export class AdminSeederModule {}

