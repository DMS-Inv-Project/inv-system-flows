import { prisma } from './lib/prisma'

async function main() {
  console.log('🏥 INVS Modern - Database Status Check')
  
  try {
    await prisma.$connect()
    console.log('✅ Connected to database\n')
    
    const tables = [
      'location', 'department', 'budgetTypeGroup', 'budgetCategory', 'budget',
      'company', 'drugGeneric', 'drug', 'inventory', 'drugLot',
      'purchaseRequest', 'purchaseOrder', 'receipt', 'contract',
      'tmtConcept', 'drugDistribution', 'drugReturn'
    ]
    
    console.log('📊 Record Counts:')
    console.log('----------------')
    
    for (const table of tables) {
      try {
        const count = await (prisma[table as any] as any).count()
        console.log(`${table.padEnd(20)}: ${count.toLocaleString()}`)
      } catch (err) {
        console.log(`${table.padEnd(20)}: Error or Table not found`)
      }
    }
    
    console.log('\n----------------')
    
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
