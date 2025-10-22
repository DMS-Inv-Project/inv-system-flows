# 🔗 TMT Integration - UI Mockups & User Flow

**Thai Medical Terminology Integration - User Interface Mockups**

**Version:** 2.2.0
**Last Updated:** 2025-01-22

---

## 📋 Overview

เอกสารนี้แสดง UI mockups สำหรับ TMT Integration:

1. **TMT Mapping** - แม็พยากับ TMT code
2. **Compliance Dashboard** - ติดตาม compliance rate

---

## 🔄 Flow 1: Map Drug to TMT

### 📱 Screen: TMT Mapping

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  TMT Mapping - Paracetamol 500mg                                  [X]       │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Drug Information:                                                           │
│  Trade Name: Tylenol 500mg Tablet                                            │
│  Generic: Paracetamol | Strength: 500mg | Form: Tablet                       │
│                                                                              │
│  Search TMT Concepts:                                                        │
│  [Paracetamol 500___________] 🔍    Level: [GP - Generic Product ▼]         │
│                                                                              │
│  🤖 AI-Suggested Matches (Confidence Score):                                 │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ TMT ID    │ Preferred Term              │ Level│ Match │ Confidence │ │ │
│  ├────────────────────────────────────────────────────────────────────────┤ │
│  │ 100250001 │ Paracetamol 500mg Tab       │ GP   │ ✓ Name│ 95%  ●●●●● │ │ │
│  │ 100250002 │ Paracetamol 500mg Cap       │ GP   │ ○ Form│ 75%  ●●●○○ │ │ │
│  │ 100251001 │ Paracetamol 500mg Tab (GPO) │ TP   │ ○ Brand│70%  ●●●○○ │ │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  Manual Search Results:                                                      │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ TMT ID    │ FSN                         │ Level│ Strength│ Form     │ │ │
│  ├────────────────────────────────────────────────────────────────────────┤ │
│  │ 100250001 │ Paracetamol 500mg Tab       │ GP   │ 500mg   │ Tablet   │ │ │
│  │ ● Select this TMT concept                                             │ │ │
│  │                                                                        │ │ │
│  │ Hierarchy: VTM → GP → TP                                               │ │ │
│  │ • VTM: Paracetamol                                                     │ │ │
│  │ • GP: Paracetamol 500mg Tablet (this level) ✓ Recommended             │ │ │
│  │ • TP: Paracetamol 500mg Tablet (Brand X)                               │ │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  Mapping Details:                                                            │
│  TMT Code: 100250001                                                         │
│  Level: GP (Generic Product) ✓ Recommended                                  │
│                                                                              │
│  ☑ Verified by Pharmacist (Required for compliance)                         │
│  Verified By: [Select Pharmacist ▼]                                         │
│                                                                              │
│                                            [Cancel]  [Save Mapping]          │
└──────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. Pharmacist searches TMT concepts
2. System shows AI suggestions with confidence scores
3. Pharmacist selects best match (prefer GP level)
4. Pharmacist verifies mapping
5. System saves mapping

---

## 🔄 Flow 2: Compliance Dashboard

### 📱 Screen: TMT Compliance

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  🏥 INVS Modern - TMT Compliance Dashboard                                   │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  TMT Mapping Status                                   As of: 2025-01-22     │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ 📊 Compliance Rate: 96.5% (1,204 / 1,248 active drugs)                │ │
│  │                                                                        │ │
│  │ ████████████████████████████████████████████░░░ 96.5%                 │ │
│  │                                                                        │ │
│  │ ✅ Target: ≥ 95% | Status: ✓ COMPLIANT                                │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  Mapping Statistics:                                                         │
│  • ✅ Mapped & Verified: 1,204 drugs (96.5%)                                 │
│  • ⚠️ Mapped but Not Verified: 12 drugs (1.0%)                               │
│  • ❌ Unmapped: 32 drugs (2.6%)                                              │
│  • 🔴 Priority: 8 high-usage drugs need mapping                             │
│                                                                              │
│  Unmapped Drugs (Top 10 by Usage):                                           │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ Drug Code           │ Trade Name        │ Usage/Month │ Days Unmapped │ │ │
│  ├────────────────────────────────────────────────────────────────────────┤ │
│  │ 123456789012345678 │ Aspirin 100mg      │ 5,000 units │ 45 days   │[Map]│ │
│  │ 234567890123456789 │ Vitamin B Complex  │ 3,500 units │ 30 days   │[Map]│ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  Compliance Trend (Last 6 Months):                                           │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ Month  │ Rate  │ ████████████░░░                                       │ │
│  │ Jul 24 │ 85.2% │ ████████████░░░                                       │ │
│  │ Aug 24 │ 88.5% │ █████████████░░                                       │ │
│  │ Sep 24 │ 91.0% │ ██████████████░                                       │ │
│  │ Oct 24 │ 93.2% │ ███████████████                                       │ │
│  │ Nov 24 │ 95.1% │ ████████████████  ← Reached target                    │ │
│  │ Dec 24 │ 95.8% │ ████████████████                                       │ │
│  │ Jan 25 │ 96.5% │ ████████████████  ✓ Current                           │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  [Generate Ministry Report] [Export Unmapped List] [Bulk Mapping Tool]      │
└──────────────────────────────────────────────────────────────────────────────┘
```

**User Flow:**
1. User views compliance rate (Target: ≥95%)
2. System shows unmapped drugs prioritized by usage
3. User clicks **[Map]** to map high-priority drugs
4. User exports report for ministry submission

---

## 📊 Summary

- **TMT Mapping:** AI-assisted with pharmacist verification
- **Compliance:** Real-time tracking with trend analysis
- **Priority Focus:** High-usage drugs mapped first

---

**Built with ❤️ for INVS Modern Team**
**Last Updated:** 2025-01-22 | **Version:** 2.2.0
