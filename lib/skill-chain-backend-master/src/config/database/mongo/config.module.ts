import { Module, Logger } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { ConfigService } from '@nestjs/config';

@Module({
  imports: [
    MongooseModule.forRootAsync({
      useFactory: async (configService: ConfigService) => {
        const logger = new Logger('MongoConfigModule');
        const uri = configService.get<string>('database.mongo.uri');
        
        if (!uri || uri.includes('<') || uri.includes('>')) {
          logger.error('Invalid MongoDB URI. Please check your MONGODB_URI in .env file');
          throw new Error('Invalid MongoDB URI configuration');
        }
        
        return {
          uri,
          retryWrites: true,
          w: 'majority',
          maxPoolSize: 10,
          serverSelectionTimeoutMS: 5000,
          socketTimeoutMS: 45000,
        };
      },
      inject: [ConfigService],
    }),
  ],
  exports: [MongooseModule],
})
export class MongoConfigModule {}

