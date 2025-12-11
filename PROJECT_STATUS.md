# INVS Modern - Project Status

**Last Updated**: 2024-12-11
**Version**: 3.3.0
**Status**: ✅ Database + Full Data Migration Complete (Phase 19 Added)

---

## Current Status

```
┌─────────────────────────────────────────────────────────┐
│           INVS Modern - Project Status                  │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ✅ Database Schema: 58 tables, 32 enums               │
│  ✅ Database Functions: 12 business logic functions    │
│  ✅ Database Views: 11 reporting views                 │
│  ✅ Ministry Compliance: 100% (79/79 fields)           │
│  ✅ ED Classification: 6 categories (คู่มือหน้า 12)    │
│  ✅ VEN Analysis: V/E/N drug prioritization            │
│                                                         │
│  📦 Data Migration (Phase 1-19):                       │
│  ───────────────────────────────────────────           │
│  Phase 1-8:  81,353 records (existing)                 │
│  Phase 9:    1,266 drug pack ratios                    │
│  Phase 10:   736 drug components                       │
│  Phase 11:   62 focus lists                            │
│  Phase 12:   800 companies                             │
│  Phase 13:   6,092 drugs (total: 7,261)                │
│  Phase 14:   1,713 budget items                        │
│  Phase 15:   13,138 inventory + lots                   │
│  Phase 16:   209 ED groups + 1,104 ED mappings         │
│  Phase 17:   626 TMT GPU mappings (56.45%)             │
│  Phase 18:   981 VEN Analysis (88.46%)                 │
│  Phase 19:   908 procurement + 3,131 NC24 ⭐ NEW       │
│  ───────────────────────────────────────────           │
│  📊 TOTAL: ~110,000 records migrated                   │
│                                                         │
│  🎯 Ready for Backend API Development                   │
│  🎯 Ready for Frontend Development                      │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Data Summary

| Category | Table | Records |
|----------|-------|--------:|
| **Master Data** | | |
| | drugs | **7,261** (3,131 with NC24) |
| | drug_generics | **1,109** (full data) |
| | companies | **800** |
| | departments | **108** |
| | locations | **96** |
| | drug_components | 736 |
| | drug_pack_ratios | 1,266 |
| | dosage_forms | 107 |
| | drug_units | 88 |
| | ed_groups | 209 |
| **Budget** | | |
| | budget_plans | **3** |
| | budget_plan_items | **1,710** |
| **Inventory** | | |
| | inventory | **7,105** |
| | drug_lots | **6,033** |
| **TMT** | | |
| | tmt_concepts | 76,904 |
| **Lookups** | | |
| | purchase_methods | 18 |
| | purchase_types | 20 |
| | return_reasons | 19 |
| | return_actions | 8 |

---

## Drug Generics Data Coverage

| Field | Records | Coverage |
|-------|--------:|---------:|
| ed_category | 1,095 | 98.74% |
| ed_list | 839 | 75.65% |
| ed_group_id | 1,095 | 98.74% |
| tmt_gpu_id | 626 | 56.45% |
| ven_category | 981 | 88.46% |
| last_buy_cost | 908 | 81.87% |
| hosp_list | 1,104 | 99.55% |

---

## ED Classification (Phase 16)

**Source**: คู่มือ INVS หน้า 12 (บัญชี ED)

| Category | Thai Name | Count |
|----------|-----------|------:|
| ED | บัญชียา ED (Essential Drug) | 852 |
| NED | บัญชียา NED (Non-Essential) | 149 |
| NDMS | เวชภัณฑ์มิใช่ยา | 5 |
| CM | สารเคมี | 89 |
| LS | วัสดุทางห้องปฏิบัติการ | 0 |
| PS | วัสดุทางเภสัชกรรม | 0 |

**ED List Distribution (บัญชี 1-6)**:
| List | Count |
|------|------:|
| บัญชี 1 | 497 |
| บัญชี 2 | 50 |
| บัญชี 3 | 161 |
| บัญชี 4 | 97 |
| บัญชี 5 | 17 |
| บัญชี 6 | 17 |

---

## TMT GPU Mapping (Phase 17)

**Mapping**: `drug_generics.tmt_gpu_id` → `tmt_concepts.id` (GPU level)

| Status | Count | % |
|--------|------:|--:|
| มี TMT GPU | 626 | 56.45% |
| ไม่มี TMT GPU | 483 | 43.55% |

**Method**: ใช้ `GPUID` จาก MySQL เป็นรหัสมาตรฐาน TMT โดยตรง

---

## VEN Analysis (Phase 18)

**Purpose**: จัดลำดับความสำคัญของยาสำหรับการจัดซื้อ

| Category | Thai Name | Count | % |
|----------|-----------|------:|--:|
| V | Vital - ยาช่วยชีวิต/ขาดไม่ได้ | 10 | 0.90% |
| E | Essential - ยาจำเป็น | 969 | 87.38% |
| N | Non-essential - ยาไม่จำเป็น | 2 | 0.18% |
| NULL | ไม่ระบุ | 128 | 11.54% |

**ตัวอย่างยา Vital**: Naloxone, Atropine, Serum งู, Protamine, Activated Charcoal

---

## Procurement Data (Phase 19) ⭐ NEW

### drug_generics
| Field | Records | Description |
|-------|--------:|-------------|
| last_buy_cost | 908 | ราคาซื้อล่าสุด |
| last_vendor_code | 908 | รหัสผู้จำหน่ายล่าสุด |
| hosp_list | 1,104 | บัญชียา รพ. (1-21) |

### drugs
| Field | Records | Description |
|-------|--------:|-------------|
| nc24_code | 3,131 | รหัสยา 24 หลัก |

---

## 8 Core Systems Status

| # | System | Status | Data |
|---|--------|--------|------|
| 1 | Master Data | ✅ Complete | 100% migrated |
| 2 | Budget Management | ✅ Complete | 100% migrated |
| 3 | Procurement | ✅ Complete | Cost + vendor data |
| 4 | Inventory | ✅ Complete | 7,105 records + 6,033 lots |
| 5 | Distribution | ✅ Schema Ready | Ready for transactions |
| 6 | Drug Return | ✅ Schema Ready | Ready for transactions |
| 7 | TMT Integration | ✅ Complete | 76,904 concepts |
| 8 | HPP System | ✅ Schema Ready | Ready for data |

---

## Quick Start

```bash
# 1. Start containers
docker-compose up -d

# 2. Restore database (use prisma folder)
gunzip -c prisma/full_dump.sql.gz | docker exec -i invs-modern-db psql -U invs_user -d invs_modern

# 3. Verify
npm run dev
```

---

## Key Files

| File | Description |
|------|-------------|
| `prisma/schema.prisma` | Database schema (58 tables, 32 enums) |
| `prisma/full_dump.sql.gz` | Full database dump (3MB) |
| `CLAUDE.md` | Instructions for Claude Code |
| `HANDOFF.md` | Handoff document for new developers |

---

## Migration Phases Completed

| Phase | Description | Records |
|-------|-------------|--------:|
| 1 | Procurement Master | 57 |
| 2 | Drug Components | 821 |
| 3 | Distribution Support | 4 |
| 4 | Drug Master | 3,006 |
| 5 | Lookup Tables | 213 |
| 6 | FK Mappings | 1,085 |
| 7 | TMT Concepts | 76,904 |
| 8 | Drug-TMT Mapping | 561 |
| 9 | Drug Pack Ratios | 1,266 |
| 10 | Drug Components | 736 |
| 11 | Focus Lists | 62 |
| 12 | Companies | 800 |
| 13 | All Drugs | 6,092 |
| 14 | Budget Management | 1,713 |
| 15 | Inventory + Lots | 13,138 |
| 16 | ED Classification | 1,313 |
| 17 | TMT GPU Mapping | 626 |
| 18 | VEN Analysis | 981 |
| **19** | **Procurement Data + NC24** | **4,039** ⭐ NEW |

---

*Last Updated: 2024-12-11 by Claude Code*
