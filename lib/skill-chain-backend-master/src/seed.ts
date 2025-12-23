import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { AdminSeederService } from './database/seeders/admin/seeder.service';

async function bootstrap() {
  const app = await NestFactory.createApplicationContext(AppModule);
  
  const adminSeeder = app.get(AdminSeederService);
  
  try {
    await adminSeeder.seed();
    console.log('Seeding completed successfully!');
  } catch (error) {
    console.error('Seeding failed:', error);
    process.exit(1);
  } finally {
    await app.close();
  }
}

bootstrap();

