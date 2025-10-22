# 🛒 Procurement System - ระบบจัดซื้อ

**Priority**: ⭐⭐⭐ สูงสุด | **Tables**: 12 | **Time**: 3-4 weeks

## 📋 Overview

ระบบจัดซื้อครบวงจร: สัญญา → PR → PO → รับของ → จ่ายเงิน

## 📚 Documentation Files

| File | Description |
|------|-------------|
| [01-SCHEMA.md](01-SCHEMA.md) | Tables, enums, relationships |
| [02-FLOW.md](02-FLOW.md) | Workflow diagrams |
| [03-API.md](03-API.md) | API endpoints |
| [04-BUSINESS-LOGIC.md](04-BUSINESS-LOGIC.md) | Business rules |
| [05-EXAMPLES.md](05-EXAMPLES.md) | Code examples |

## 🔄 Workflow Summary

```
Contract → PR (approval + budget) → PO → Receipt (inspect) → Payment
```

## 🎯 Quick Start

1. Read [01-SCHEMA.md](01-SCHEMA.md) - เข้าใจตาราง
2. See [02-FLOW.md](02-FLOW.md) - เข้าใจ workflow
3. Implement [03-API.md](03-API.md) - สร้าง APIs
4. Apply [04-BUSINESS-LOGIC.md](04-BUSINESS-LOGIC.md) - ใช้ business rules
5. Test [05-EXAMPLES.md](05-EXAMPLES.md) - ทดสอบ

**Related**: [Master Data](../01-master-data/README.md), [Budget](../02-budget-management/README.md), [Inventory](../04-inventory/README.md)
