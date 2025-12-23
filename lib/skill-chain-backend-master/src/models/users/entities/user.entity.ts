import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type UserDocument = User & Document;

@Schema({ timestamps: true })
export class User {
  @Prop({ required: true })
  fullName: string;

  @Prop({ required: true, unique: true, lowercase: true })
  email: string;

  @Prop({ required: true })
  password: string;

  @Prop({ default: '' })
  bio: string;

  @Prop({ required: true })
  age: number;

  @Prop({ required: true, enum: ['male', 'female', 'other'] })
  gender: string;

  @Prop({ type: String, default: null })
  profilePic: string | null;

  @Prop({ required: true })
  location: string;

  @Prop({ required: true, unique: true })
  phoneNumber: string;

  @Prop({ default: '' })
  education: string;

  @Prop({ type: [String], default: [] })
  offeringSkills: string[];

  @Prop({ type: [String], required: true })
  learningSkills: string[];

  @Prop({ default: '' })
  pastExperience: string;

  @Prop({ required: true })
  portfolioLink: string;

  @Prop({ type: String, default: null })
  resume: string | null;

  @Prop({ type: Number, default: 0 })
  timeCoins: number;

  @Prop({ type: String, default: null })
  subscriptionPackage: string | null;

  @Prop({ type: Number, default: 0 })
  ratings: number;

  @Prop({ type: [Object], default: [] })
  reviews: any[];

  @Prop({ type: String, default: 'active', enum: ['active', 'inactive', 'suspended'] })
  status: string;

  @Prop({ type: Boolean, default: false })
  verified: boolean;

  @Prop({ type: [String], default: [] })
  earnedCertificates: string[];
}

export const UserSchema = SchemaFactory.createForClass(User);

