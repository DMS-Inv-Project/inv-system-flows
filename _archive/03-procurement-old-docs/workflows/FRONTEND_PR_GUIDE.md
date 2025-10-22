# FLOW 08: Frontend - Purchase Request UI
## การพัฒนา UI สำหรับสร้าง Purchase Request แบบ Real-time Preview

---

## 🎯 **Overview**

เอกสารนี้อธิบายการพัฒนา Frontend สำหรับสร้าง Purchase Request (PR) แบบมี real-time preview คล้ายกับ invoice creation UI ของ Arto+

### Key Features
- ✅ Fullscreen Dialog UI
- ✅ Split View (Form | Preview)
- ✅ Real-time Preview Updates
- ✅ Auto-calculate Budget
- ✅ Budget Availability Check
- ✅ Auto-save Draft
- ✅ PDF Export
- ✅ Email Notification

---

## 📐 **UI Layout Structure**

```
┌────────────────────────────────────────────────────────────────────────────┐
│  INVS Modern - Create Purchase Request                          [?] [X]    │
├──────────────────────────────────┬─────────────────────────────────────────┤
│                                  │                                         │
│  PR Details                      │  Preview                    [PDF] [📧] │
│                                  │                                         │
│  Department *                    │  ╔══════════════════════════════════╗  │
│  ┌──────────────────────────┐   │  ║  Purchase Request                ║  │
│  │ 👤 Pharmacy Department   │   │  ║  PR-2025-001                     ║  │
│  │    Selected              │ > │  ║                                  ║  │
│  └──────────────────────────┘   │  ║  Department: Pharmacy            ║  │
│                                  │  ║  Date: 10 Jan 2025               ║  │
│  Purpose                         │  ║  Budget: OP001 - Q1              ║  │
│  ┌──────────────────────────┐   │  ║                                  ║  │
│  │ Stock replenishment      │   │  ║  Items:                          ║  │
│  └──────────────────────────┘   │  ║  1. Paracetamol 500mg            ║  │
│                                  │  ║     Qty: 10,000 tabs             ║  │
│  PR Date                         │  ║     Est: ฿25,000                 ║  │
│  ┌──────────────────────────┐   │  ║                                  ║  │
│  │ 10 January 2025      [📅]│   │  ║  Budget Status:                  ║  │
│  └──────────────────────────┘   │  ║  Available: ฿2,500,000           ║  │
│                                  │  ║  Request:   ฿25,000              ║  │
│  Budget Allocation *             │  ║  Remaining: ฿2,475,000           ║  │
│  ┌──────────────────────────┐   │  ║                                  ║  │
│  │ OP001 - Drugs - Q1 2025  │▼ │  ║  Status: ✓ Budget Available     ║  │
│  │ Available: ฿2.5M         │   │  ╚══════════════════════════════════╝  │
│  └──────────────────────────┘   │                                         │
│                                  │  Budget Check Summary:                  │
│  Urgency                         │  • Budget Type: OP001                   │
│  ○ Normal  ● Urgent  ○ Emergency │  • Department: Pharmacy                 │
│                                  │  • Fiscal Year: 2025                    │
│  ─────────────────────────────   │  • Quarter: Q1                          │
│                                  │  • Available: ฿2,500,000.00             │
│  Generic Drugs                   │  • Requesting: ฿25,000.00               │
│                                  │  • After Reserve: ฿2,475,000.00         │
│  Item  Qty  Unit Cost   Tax      │                                         │
│  ┌────────────────────────────┐ │  Approval Workflow:                     │
│  │ 💊 Paracetamol 500mg       │ │  1. ⏳ Department Head                  │
│  │    10,000 tabs             │ │  2. ⏳ Finance Approval                 │
│  │    ฿2.50/tab          10%  │ │                                         │
│  └────────────────────────────┘ │                                         │
│                                  │                                         │
│  [+ Add New Line]                │                                         │
│                                  │                                         │
│  ☐ Reserve Budget               │                                         │
│  ☑ Auto-check Budget            │                                         │
│                                  │                                         │
│  Last saved: Just now            │                                         │
│  [Cancel]          [Save Draft]  [Submit PR]                              │
└──────────────────────────────────┴─────────────────────────────────────────┘
```

---

## 🏗️ **Frontend Architecture**

### Technology Stack Recommendation

```typescript
// Framework & Libraries
- React 18+ with TypeScript
- TanStack Query (React Query) for data fetching
- Zustand or Redux Toolkit for state management
- React Hook Form for form validation
- Zod for schema validation
- TailwindCSS + shadcn/ui for components
- Recharts for budget visualization
```

### Folder Structure

```
src/
├── features/
│   └── purchase-request/
│       ├── components/
│       │   ├── PRDialog.tsx              # Fullscreen dialog container
│       │   ├── PRForm.tsx                # Left side form
│       │   ├── PRPreview.tsx             # Right side preview
│       │   ├── PRItemsList.tsx           # Items table
│       │   ├── BudgetCheck.tsx           # Budget check component
│       │   └── ApprovalStatus.tsx        # Approval workflow display
│       ├── hooks/
│       │   ├── usePRForm.ts              # Form state & validation
│       │   ├── useBudgetCheck.ts         # Real-time budget check
│       │   ├── useAutoSave.ts            # Auto-save draft
│       │   └── usePRPreview.ts           # Preview data generation
│       ├── api/
│       │   ├── prApi.ts                  # API calls
│       │   └── budgetApi.ts              # Budget API calls
│       ├── types/
│       │   └── pr.types.ts               # TypeScript types
│       └── utils/
│           ├── prCalculations.ts         # Price calculations
│           └── prValidations.ts          # Custom validations
├── components/
│   └── ui/                               # Reusable UI components
│       ├── dialog.tsx
│       ├── select.tsx
│       ├── input.tsx
│       └── ...
└── lib/
    ├── api-client.ts                     # Axios/Fetch wrapper
    └── queryClient.ts                    # React Query config
```

---

## 💻 **Implementation Examples**

### 1. Main PR Dialog Component

```typescript
// features/purchase-request/components/PRDialog.tsx
import { useState } from 'react';
import { Dialog, DialogContent } from '@/components/ui/dialog';
import { PRForm } from './PRForm';
import { PRPreview } from './PRPreview';
import { usePRForm } from '../hooks/usePRForm';
import { useAutoSave } from '../hooks/useAutoSave';

interface PRDialogProps {
  open: boolean;
  onClose: () => void;
  prId?: number; // For editing existing PR
}

export function PRDialog({ open, onClose, prId }: PRDialogProps) {
  const { formData, setFormData, handleSubmit, isValid } = usePRForm(prId);

  // Auto-save draft every 30 seconds
  useAutoSave(formData, 30000);

  return (
    <Dialog open={open} onOpenChange={onClose}>
      <DialogContent className="max-w-screen-2xl h-screen p-0">
        <div className="flex h-full">
          {/* Left Side - Form */}
          <div className="w-1/2 overflow-y-auto p-6 border-r">
            <PRForm
              data={formData}
              onChange={setFormData}
              onSubmit={handleSubmit}
              onCancel={onClose}
            />
          </div>

          {/* Right Side - Preview */}
          <div className="w-1/2 overflow-y-auto p-6 bg-gray-50">
            <PRPreview
              data={formData}
              isValid={isValid}
            />
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
```

### 2. Form Component with Real-time Budget Check

```typescript
// features/purchase-request/components/PRForm.tsx
import { useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { useBudgetCheck } from '../hooks/useBudgetCheck';
import { prSchema, type PRFormData } from '../types/pr.types';

interface PRFormProps {
  data: PRFormData;
  onChange: (data: PRFormData) => void;
  onSubmit: (data: PRFormData) => Promise<void>;
  onCancel: () => void;
}

export function PRForm({ data, onChange, onSubmit, onCancel }: PRFormProps) {
  const form = useForm<PRFormData>({
    resolver: zodResolver(prSchema),
    defaultValues: data,
    mode: 'onChange', // Real-time validation
  });

  const { watch, handleSubmit } = form;
  const formValues = watch();

  // Real-time budget check
  const {
    budgetStatus,
    isChecking,
    error: budgetError
  } = useBudgetCheck({
    departmentId: formValues.departmentId,
    budgetAllocationId: formValues.budgetAllocationId,
    requestedAmount: formValues.totalAmount,
    enabled: !!formValues.budgetAllocationId && !!formValues.totalAmount,
  });

  // Update parent state on form change
  useEffect(() => {
    onChange(formValues);
  }, [formValues, onChange]);

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
      <div className="space-y-4">
        <h2 className="text-2xl font-bold">PR Details</h2>

        {/* Department Selector */}
        <FormField
          control={form.control}
          name="departmentId"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Department *</FormLabel>
              <DepartmentSelect {...field} />
              <FormMessage />
            </FormItem>
          )}
        />

        {/* Purpose */}
        <FormField
          control={form.control}
          name="purpose"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Purpose</FormLabel>
              <Textarea {...field} placeholder="Stock replenishment" />
              <FormMessage />
            </FormItem>
          )}
        />

        {/* PR Date */}
        <FormField
          control={form.control}
          name="prDate"
          render={({ field }) => (
            <FormItem>
              <FormLabel>PR Date</FormLabel>
              <DatePicker {...field} />
              <FormMessage />
            </FormItem>
          )}
        />

        {/* Budget Allocation */}
        <FormField
          control={form.control}
          name="budgetAllocationId"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Budget Allocation *</FormLabel>
              <BudgetAllocationSelect
                {...field}
                departmentId={formValues.departmentId}
              />
              <FormMessage />

              {/* Real-time Budget Status */}
              {budgetStatus && (
                <div className="mt-2 p-3 bg-blue-50 rounded-md">
                  <p className="text-sm font-medium">
                    Available: ฿{budgetStatus.available.toLocaleString()}
                  </p>
                  {budgetStatus.isAvailable ? (
                    <p className="text-sm text-green-600">
                      ✓ Budget Available
                    </p>
                  ) : (
                    <p className="text-sm text-red-600">
                      ✗ Insufficient Budget
                    </p>
                  )}
                </div>
              )}
            </FormItem>
          )}
        />

        {/* Urgency */}
        <FormField
          control={form.control}
          name="urgency"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Urgency</FormLabel>
              <RadioGroup {...field}>
                <RadioGroupItem value="normal" label="Normal" />
                <RadioGroupItem value="urgent" label="Urgent" />
                <RadioGroupItem value="emergency" label="Emergency" />
              </RadioGroup>
              <FormMessage />
            </FormItem>
          )}
        />

        {/* Items List */}
        <div>
          <h3 className="text-lg font-semibold mb-3">Generic Drugs</h3>
          <PRItemsList
            items={formValues.items}
            onChange={(items) => form.setValue('items', items)}
          />
        </div>

        {/* Options */}
        <div className="space-y-2">
          <FormField
            control={form.control}
            name="reserveBudget"
            render={({ field }) => (
              <FormItem className="flex items-center space-x-2">
                <FormControl>
                  <Checkbox
                    checked={field.value}
                    onCheckedChange={field.onChange}
                  />
                </FormControl>
                <FormLabel className="!mt-0">Reserve Budget</FormLabel>
              </FormItem>
            )}
          />

          <FormField
            control={form.control}
            name="autoCheckBudget"
            render={({ field }) => (
              <FormItem className="flex items-center space-x-2">
                <FormControl>
                  <Checkbox
                    checked={field.value}
                    onCheckedChange={field.onChange}
                  />
                </FormControl>
                <FormLabel className="!mt-0">Auto-check Budget</FormLabel>
              </FormItem>
            )}
          />
        </div>
      </div>

      {/* Actions */}
      <div className="flex justify-between items-center pt-4 border-t">
        <p className="text-sm text-gray-500">
          Last saved: Just now
        </p>
        <div className="space-x-2">
          <Button type="button" variant="outline" onClick={onCancel}>
            Cancel
          </Button>
          <Button
            type="button"
            variant="secondary"
            onClick={() => onSubmit({ ...formValues, status: 'draft' })}
          >
            Save Draft
          </Button>
          <Button
            type="submit"
            disabled={!budgetStatus?.isAvailable || isChecking}
          >
            Submit PR
          </Button>
        </div>
      </div>
    </form>
  );
}
```

### 3. Real-time Preview Component

```typescript
// features/purchase-request/components/PRPreview.tsx
import { useMemo } from 'react';
import { Card } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { FileText, Mail } from 'lucide-react';
import { usePRPreview } from '../hooks/usePRPreview';
import type { PRFormData } from '../types/pr.types';

interface PRPreviewProps {
  data: PRFormData;
  isValid: boolean;
}

export function PRPreview({ data, isValid }: PRPreviewProps) {
  const {
    previewData,
    generatePDF,
    sendEmail
  } = usePRPreview(data);

  // Calculate totals
  const totals = useMemo(() => {
    const subtotal = data.items.reduce(
      (sum, item) => sum + (item.quantity * item.estimatedUnitCost),
      0
    );
    const tax = subtotal * 0.10; // 10% tax
    const total = subtotal + tax;

    return { subtotal, tax, total };
  }, [data.items]);

  return (
    <div className="space-y-4">
      {/* Header Actions */}
      <div className="flex justify-between items-center">
        <h2 className="text-xl font-bold">Preview</h2>
        <div className="flex gap-2">
          <Button
            variant="outline"
            size="sm"
            onClick={generatePDF}
            disabled={!isValid}
          >
            <FileText className="w-4 h-4 mr-2" />
            PDF
          </Button>
          <Button
            variant="outline"
            size="sm"
            onClick={sendEmail}
            disabled={!isValid}
          >
            <Mail className="w-4 h-4 mr-2" />
            Email
          </Button>
        </div>
      </div>

      {/* Preview Card */}
      <Card className="p-6 space-y-4">
        {/* Header */}
        <div className="text-center border-b pb-4">
          <h3 className="text-2xl font-bold">Purchase Request</h3>
          <p className="text-lg text-gray-600">{data.prNumber || 'PR-DRAFT'}</p>
        </div>

        {/* Details Grid */}
        <div className="grid grid-cols-2 gap-4 text-sm">
          <div>
            <p className="font-semibold text-gray-600">Department</p>
            <p>{previewData.departmentName}</p>
          </div>
          <div>
            <p className="font-semibold text-gray-600">Date</p>
            <p>{new Date(data.prDate).toLocaleDateString()}</p>
          </div>
          <div>
            <p className="font-semibold text-gray-600">Budget</p>
            <p>{previewData.budgetTypeName}</p>
          </div>
          <div>
            <p className="font-semibold text-gray-600">Urgency</p>
            <p className="capitalize">{data.urgency}</p>
          </div>
        </div>

        {/* Purpose */}
        {data.purpose && (
          <div className="border-t pt-4">
            <p className="font-semibold text-gray-600 mb-1">Purpose</p>
            <p className="text-sm">{data.purpose}</p>
          </div>
        )}

        {/* Items */}
        <div className="border-t pt-4">
          <p className="font-semibold mb-3">Items</p>
          <div className="space-y-3">
            {data.items.map((item, index) => (
              <div key={index} className="flex items-start gap-3 p-3 bg-gray-50 rounded">
                <div className="w-10 h-10 bg-blue-100 rounded flex items-center justify-center">
                  💊
                </div>
                <div className="flex-1">
                  <p className="font-medium">{item.genericName}</p>
                  <p className="text-sm text-gray-600">
                    Qty: {item.quantity.toLocaleString()} {item.unit}
                  </p>
                  <p className="text-sm text-gray-600">
                    Est: ฿{(item.quantity * item.estimatedUnitCost).toLocaleString()}
                  </p>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Budget Summary */}
        <div className="border-t pt-4">
          <p className="font-semibold mb-3">Budget Status</p>
          <div className="space-y-2 text-sm bg-blue-50 p-3 rounded">
            <div className="flex justify-between">
              <span className="text-gray-600">Available:</span>
              <span className="font-medium">
                ฿{previewData.budgetAvailable?.toLocaleString()}
              </span>
            </div>
            <div className="flex justify-between">
              <span className="text-gray-600">Request:</span>
              <span className="font-medium">
                ฿{totals.total.toLocaleString()}
              </span>
            </div>
            <div className="flex justify-between border-t pt-2">
              <span className="text-gray-600">Remaining:</span>
              <span className="font-bold">
                ฿{(previewData.budgetAvailable - totals.total).toLocaleString()}
              </span>
            </div>
          </div>

          {previewData.budgetAvailable >= totals.total ? (
            <div className="mt-3 p-2 bg-green-50 rounded text-sm text-green-700 font-medium">
              ✓ Budget Available
            </div>
          ) : (
            <div className="mt-3 p-2 bg-red-50 rounded text-sm text-red-700 font-medium">
              ✗ Insufficient Budget
            </div>
          )}
        </div>

        {/* Approval Workflow */}
        <div className="border-t pt-4">
          <p className="font-semibold mb-3">Approval Workflow</p>
          <div className="space-y-2">
            <div className="flex items-center gap-2 text-sm">
              <span className="w-6 h-6 rounded-full bg-gray-200 flex items-center justify-center text-xs">
                1
              </span>
              <span className="text-gray-600">⏳ Department Head</span>
            </div>
            <div className="flex items-center gap-2 text-sm">
              <span className="w-6 h-6 rounded-full bg-gray-200 flex items-center justify-center text-xs">
                2
              </span>
              <span className="text-gray-600">⏳ Finance Approval</span>
            </div>
          </div>
        </div>
      </Card>

      {/* Additional Info */}
      <Card className="p-4 bg-blue-50">
        <p className="text-sm font-semibold mb-2">Budget Check Summary</p>
        <ul className="text-xs space-y-1 text-gray-700">
          <li>• Budget Type: {previewData.budgetCode}</li>
          <li>• Department: {previewData.departmentName}</li>
          <li>• Fiscal Year: 2025</li>
          <li>• Quarter: Q1</li>
          <li>• Available: ฿{previewData.budgetAvailable?.toLocaleString()}</li>
          <li>• Requesting: ฿{totals.total.toLocaleString()}</li>
        </ul>
      </Card>
    </div>
  );
}
```

### 4. Real-time Budget Check Hook

```typescript
// features/purchase-request/hooks/useBudgetCheck.ts
import { useQuery } from '@tanstack/react-query';
import { budgetApi } from '../api/budgetApi';

interface UseBudgetCheckProps {
  departmentId?: number;
  budgetAllocationId?: number;
  requestedAmount?: number;
  enabled?: boolean;
}

export function useBudgetCheck({
  departmentId,
  budgetAllocationId,
  requestedAmount,
  enabled = true,
}: UseBudgetCheckProps) {
  return useQuery({
    queryKey: ['budgetCheck', departmentId, budgetAllocationId, requestedAmount],
    queryFn: async () => {
      if (!budgetAllocationId || !requestedAmount) {
        return null;
      }

      // Call PostgreSQL function via API
      const response = await budgetApi.checkAvailability({
        allocationId: budgetAllocationId,
        amount: requestedAmount,
      });

      return response.data;
    },
    enabled: enabled && !!budgetAllocationId && !!requestedAmount,
    staleTime: 10000, // Refresh every 10 seconds
    refetchInterval: 30000, // Auto-refresh every 30 seconds
  });
}
```

### 5. Auto-save Hook

```typescript
// features/purchase-request/hooks/useAutoSave.ts
import { useEffect, useRef } from 'react';
import { useMutation } from '@tanstack/react-query';
import { prApi } from '../api/prApi';
import type { PRFormData } from '../types/pr.types';

export function useAutoSave(data: PRFormData, delay: number = 30000) {
  const timeoutRef = useRef<NodeJS.Timeout>();

  const saveDraft = useMutation({
    mutationFn: (data: PRFormData) => prApi.saveDraft(data),
    onSuccess: () => {
      console.log('Draft saved successfully');
    },
  });

  useEffect(() => {
    // Clear existing timeout
    if (timeoutRef.current) {
      clearTimeout(timeoutRef.current);
    }

    // Set new timeout
    timeoutRef.current = setTimeout(() => {
      if (data.departmentId && data.items.length > 0) {
        saveDraft.mutate(data);
      }
    }, delay);

    // Cleanup
    return () => {
      if (timeoutRef.current) {
        clearTimeout(timeoutRef.current);
      }
    };
  }, [data, delay]);

  return {
    isSaving: saveDraft.isPending,
    lastSaved: saveDraft.data?.savedAt,
  };
}
```

---

## 🔌 **API Integration**

### API Client Setup

```typescript
// lib/api-client.ts
import axios from 'axios';

export const apiClient = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000/api',
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add request interceptor for auth
apiClient.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});
```

### Budget API

```typescript
// features/purchase-request/api/budgetApi.ts
import { apiClient } from '@/lib/api-client';

export const budgetApi = {
  // Check budget availability
  checkAvailability: async (params: {
    allocationId: number;
    amount: number;
  }) => {
    return apiClient.post('/budget/check-availability', params);
  },

  // Get budget allocations by department
  getAllocationsByDepartment: async (departmentId: number) => {
    return apiClient.get(`/budget/allocations/department/${departmentId}`);
  },

  // Reserve budget for PR
  reserveBudget: async (params: {
    allocationId: number;
    prId: number;
    amount: number;
  }) => {
    return apiClient.post('/budget/reserve', params);
  },
};
```

### PR API

```typescript
// features/purchase-request/api/prApi.ts
import { apiClient } from '@/lib/api-client';
import type { PRFormData } from '../types/pr.types';

export const prApi = {
  // Create new PR
  create: async (data: PRFormData) => {
    return apiClient.post('/purchase-requests', data);
  },

  // Save draft
  saveDraft: async (data: PRFormData) => {
    return apiClient.post('/purchase-requests/draft', data);
  },

  // Get PR by ID
  getById: async (id: number) => {
    return apiClient.get(`/purchase-requests/${id}`);
  },

  // Submit PR for approval
  submit: async (id: number) => {
    return apiClient.post(`/purchase-requests/${id}/submit`);
  },

  // Generate PDF
  generatePDF: async (id: number) => {
    return apiClient.get(`/purchase-requests/${id}/pdf`, {
      responseType: 'blob',
    });
  },

  // Send email
  sendEmail: async (id: number, recipients: string[]) => {
    return apiClient.post(`/purchase-requests/${id}/email`, { recipients });
  },
};
```

---

## 📝 **TypeScript Types**

```typescript
// features/purchase-request/types/pr.types.ts
import { z } from 'zod';

// Zod Schema for validation
export const prItemSchema = z.object({
  genericId: z.number(),
  genericName: z.string().min(1),
  quantity: z.number().positive(),
  unit: z.string(),
  estimatedUnitCost: z.number().positive(),
  notes: z.string().optional(),
});

export const prSchema = z.object({
  prNumber: z.string().optional(),
  departmentId: z.number({ required_error: 'Department is required' }),
  budgetAllocationId: z.number({ required_error: 'Budget allocation is required' }),
  prDate: z.date(),
  purpose: z.string().min(10, 'Purpose must be at least 10 characters'),
  urgency: z.enum(['normal', 'urgent', 'emergency']),
  items: z.array(prItemSchema).min(1, 'At least one item is required'),
  reserveBudget: z.boolean().default(false),
  autoCheckBudget: z.boolean().default(true),
  status: z.enum(['draft', 'submitted', 'approved', 'rejected']).default('draft'),
});

// TypeScript types
export type PRItem = z.infer<typeof prItemSchema>;
export type PRFormData = z.infer<typeof prSchema>;

// API Response types
export interface BudgetCheckResponse {
  available: boolean;
  totalBudget: number;
  totalSpent: number;
  remainingBudget: number;
  quarterAvailable: number;
  message: string;
}

export interface PRResponse {
  id: number;
  prNumber: string;
  departmentId: number;
  budgetAllocationId: number;
  status: string;
  requestedAmount: number;
  createdAt: string;
  updatedAt: string;
}
```

---

## 🎨 **Styling with TailwindCSS**

### Configuration

```javascript
// tailwind.config.js
module.exports = {
  content: [
    './src/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        // INVS Brand Colors
        primary: {
          50: '#eff6ff',
          100: '#dbeafe',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
        },
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('tailwindcss-animate'),
  ],
};
```

---

## ✅ **Implementation Checklist**

### Phase 1: Basic Structure
- [ ] Setup React project with TypeScript
- [ ] Install required dependencies
- [ ] Create folder structure
- [ ] Setup TailwindCSS and shadcn/ui
- [ ] Create basic Dialog layout

### Phase 2: Form Components
- [ ] Department selector
- [ ] Budget allocation dropdown
- [ ] Date picker
- [ ] Items list with add/remove
- [ ] Form validation with Zod
- [ ] Error handling

### Phase 3: Preview & Real-time Updates
- [ ] Preview component layout
- [ ] Real-time form-to-preview sync
- [ ] Budget check integration
- [ ] Preview calculations

### Phase 4: API Integration
- [ ] Setup axios client
- [ ] Create API endpoints
- [ ] Implement React Query hooks
- [ ] Error handling & loading states

### Phase 5: Advanced Features
- [ ] Auto-save draft
- [ ] PDF generation
- [ ] Email sending
- [ ] Approval workflow display
- [ ] Real-time budget monitoring

### Phase 6: Testing & Optimization
- [ ] Unit tests for components
- [ ] Integration tests for API
- [ ] E2E tests with Playwright
- [ ] Performance optimization
- [ ] Accessibility (a11y)

---

## 🚀 **Next Steps**

1. **Backend API Development** - Create REST API endpoints
2. **Database Functions Integration** - Connect to PostgreSQL functions
3. **Authentication** - Implement user auth & permissions
4. **Email Service** - Setup email notifications
5. **PDF Generation** - Implement PDF export
6. **Deployment** - Deploy to production

---

**Status**: Ready for Implementation 🎯

*Created with ❤️ by Claude Code - Frontend Architecture Guide*
