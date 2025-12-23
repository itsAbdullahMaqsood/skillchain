export interface IUser {
  _id: string;
  fullName: string;
  email: string;
  password: string;
  bio: string;
  age: number;
  gender: string;
  profilePic: string | null;
  location: string;
  phoneNumber: string;
  education: string;
  offeringSkills: string[];
  learningSkills: string[];
  pastExperience: string;
  portfolioLink: string;
  resume: string | null;
  timeCoins: number;
  subscriptionPackage: string | null;
  ratings: number;
  reviews: any[];
  status: string;
  verified: boolean;
  earnedCertificates: string[];
  createdAt?: Date;
  updatedAt?: Date;
}

export interface IUserPayload {
  sub: string;
  email: string;
  type: 'user';
}

