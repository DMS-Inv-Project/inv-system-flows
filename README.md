# INVS Modern 🏥

Modern Hospital Inventory Management System built with PostgreSQL, Prisma, and TypeScript.

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- Docker & Docker Compose
- Git

### 1. Start Database
```bash
# Start PostgreSQL container
docker-compose up -d

# Check if database is ready
docker logs invs-modern-db
```

### 2. Setup Project
```bash
# Install dependencies
npm install

# Generate Prisma client
npm run db:generate

# Push schema to database
npm run db:push

# Seed master data
npm run db:seed
```

### 3. Run Application
```bash
# Development mode
npm run dev

# Build and run production
npm run build
npm start
```

## 📊 Database Access

### PostgreSQL Connection
- **Host**: localhost
- **Port**: 5434
- **Database**: invs_modern
- **Username**: invs_user
- **Password**: invs123

### pgAdmin Web Interface
- **URL**: http://localhost:8081
- **Email**: admin@invs.local
- **Password**: invs123

### Prisma Studio
```bash
npm run db:studio
```
Access at: http://localhost:5555

## 🗄️ Database Schema

### Core Models (16 Tables)

#### Master Data
- **Location** - Storage locations (warehouse, pharmacy, ward)
- **Department** - Hospital departments with budget codes
- **BudgetType** - Budget categories (operational, investment, emergency)
- **Company** - Vendors and manufacturers
- **DrugGeneric** - Generic drug catalog
- **Drug** - Trade drug catalog with manufacturer links

#### Inventory Management
- **Inventory** - Stock levels per drug/location
- **DrugLot** - FIFO/FEFO lot tracking with expiry dates
- **InventoryTransaction** - All inventory movements

#### Budget Management
- **BudgetAllocation** - Annual budget allocation by quarter
- **BudgetReservation** - Budget reservations for purchase requests

#### Procurement
- **PurchaseRequest** - Purchase request workflow
- **PurchaseRequestItem** - Detailed items in requests
- **PurchaseOrder** - Purchase orders with vendor
- **PurchaseOrderItem** - Items in purchase orders
- **Receipt** - Goods receiving documents
- **ReceiptItem** - Items received with lot information

## 🛠️ Available Scripts

```bash
# Development
npm run dev              # Start development server
npm run build           # Build TypeScript
npm start              # Run built application

# Database
npm run db:generate    # Generate Prisma client
npm run db:push        # Push schema to database
npm run db:migrate     # Create and run migration
npm run db:seed        # Seed master data
npm run db:studio      # Open Prisma Studio

# Data Migration
npx ts-node src/scripts/migrate-data.ts  # Migrate from old system
```

## 📁 Project Structure

```
invs-modern/
├── prisma/
│   ├── schema.prisma          # Database schema definition
│   ├── migrations/            # Database migrations
│   └── seed.ts               # Master data seeding
├── src/
│   ├── lib/
│   │   └── prisma.ts         # Prisma client setup
│   ├── scripts/
│   │   └── migrate-data.ts   # Data migration utilities
│   └── index.ts              # Main application entry
├── docker-compose.yml        # PostgreSQL + pgAdmin
├── tsconfig.json            # TypeScript configuration
└── package.json             # Dependencies and scripts
```

## 🔄 Data Migration

### From Old INVS System
The migration script can extract data from the existing INVS database:

```bash
# Run migration from old system
npx ts-node src/scripts/migrate-data.ts
```

### Sample Data
If old system is not available, the script creates sample data:
- 5 Companies (GPO, Zuellig, Pfizer, etc.)
- 5 Drug Generics (Paracetamol, Ibuprofen, etc.)
- Sample inventory with realistic stock levels
- Budget allocations for 2025

## 💰 Budget Management Features

### Real-time Budget Control
```typescript
// Check budget availability
const budget = await prisma.budgetAllocation.findFirst({
  where: {
    fiscalYear: 2025,
    departmentId: 1,
    budgetTypeId: 1
  }
})

// Create budget reservation
await prisma.budgetReservation.create({
  data: {
    allocationId: budget.id,
    reservedAmount: 500000,
    status: 'ACTIVE'
  }
})
```

### Quarterly Budget Tracking
- Q1-Q4 budget breakdown
- Real-time spending tracking
- Automatic budget validation
- Budget reservation system

## 📦 Inventory Features

### FIFO/FEFO Management
```typescript
// Find expiring lots
const expiringLots = await prisma.drugLot.findMany({
  where: {
    expiryDate: {
      lte: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000) // 30 days
    },
    quantityAvailable: { gt: 0 }
  },
  orderBy: { expiryDate: 'asc' }
})
```

### Stock Level Monitoring
- Min/Max level alerts
- Reorder point tracking
- Multi-location inventory
- Average cost calculation

## 🔐 Environment Variables

Create `.env` file:
```env
DATABASE_URL="postgresql://invs_user:invs123@localhost:5434/invs_modern?schema=public"
NODE_ENV=development
PORT=3000
```

## 🚀 Deployment

### Production Setup
1. Update environment variables
2. Run migrations: `npm run db:migrate`
3. Build application: `npm run build`
4. Start: `npm start`

### Docker Production
```bash
# Build production image
docker build -t invs-modern .

# Run with environment
docker run -e DATABASE_URL="..." invs-modern
```

## 📈 Performance

### Database Optimization
- Proper indexes on foreign keys
- Compound indexes for queries
- Optimized enum usage
- Connection pooling with Prisma

### Recommended Settings
```javascript
// prisma/schema.prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

generator client {
  provider        = "prisma-client-js"
  previewFeatures = ["metrics"]
}
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Issues**: GitHub Issues
- **Documentation**: See `/docs` folder
- **Database Schema**: Use Prisma Studio for exploration

---

**INVS Modern** - Making hospital inventory management efficient and reliable! 🏥✨