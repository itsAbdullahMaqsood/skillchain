export interface IAdmin {
  _id: string;
  fullName: string;
  profilePic: string | null;
  phoneNumber: string;
  email: string;
  password: string;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface IAdminPayload {
  sub: string;
  email: string;
  type: 'admin';
}

