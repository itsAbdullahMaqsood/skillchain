import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MongoConfigModule } from './config/database/mongo/config.module';
import { AdminSeederModule } from './database/seeders/admin/seeder.module';
import { AdminModule } from './models/admin/admin.module';
import { UserModule } from './models/users/user.module';
import configuration from './config/database/mongo/configuration';

@Module({
  imports: [
    ConfigModule.forRoot({
      load: [configuration],
      isGlobal: true,
      envFilePath: ['.env.local', '.env'],
    }),
    MongoConfigModule,
    AdminSeederModule,
    AdminModule,
    UserModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
