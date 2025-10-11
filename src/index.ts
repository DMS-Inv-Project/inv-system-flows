import { prisma } from './lib/prisma'

async function main() {
  console.log('🏥 INVS Modern - Hospital Inventory Management System')
  console.log('📊 Connecting to database...')
  
  try {
    await prisma.$connect()
    console.log('✅ Database connected successfully!')
    
    // Test query
    const locationCount = await prisma.location.count()
    console.log(`📍 Locations in database: ${locationCount}`)
    
    const drugCount = await prisma.drug.count()
    console.log(`💊 Drugs in database: ${drugCount}`)
    
    const companyCount = await prisma.company.count()
    console.log(`🏢 Companies in database: ${companyCount}`)
    
  } catch (error) {
    console.error('❌ Database connection failed:', error)
  } finally {
    await prisma.$disconnect()
  }
}

main()
  .catch((error) => {
    console.error('💥 Application error:', error)
    process.exit(1)
  })