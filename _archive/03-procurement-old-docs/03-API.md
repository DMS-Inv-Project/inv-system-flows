# API Endpoints - Procurement System

## Contracts

```
GET    /api/procurement/contracts
POST   /api/procurement/contracts
GET    /api/procurement/contracts/:id
PUT    /api/procurement/contracts/:id
DELETE /api/procurement/contracts/:id

GET    /api/procurement/contracts/:id/items
GET    /api/procurement/contracts/:id/remaining-value
```

## Purchase Requests

```
GET    /api/procurement/purchase-requests
POST   /api/procurement/purchase-requests
GET    /api/procurement/purchase-requests/:id
PUT    /api/procurement/purchase-requests/:id

POST   /api/procurement/purchase-requests/:id/submit
POST   /api/procurement/purchase-requests/:id/approve
POST   /api/procurement/purchase-requests/:id/reject
POST   /api/procurement/purchase-requests/:id/convert-to-po
```

## Purchase Orders

```
GET    /api/procurement/purchase-orders
POST   /api/procurement/purchase-orders
GET    /api/procurement/purchase-orders/:id
PUT    /api/procurement/purchase-orders/:id

POST   /api/procurement/purchase-orders/:id/send-to-vendor
POST   /api/procurement/purchase-orders/:id/cancel
```

## Receipts

```
GET    /api/procurement/receipts
POST   /api/procurement/receipts
GET    /api/procurement/receipts/:id
PUT    /api/procurement/receipts/:id

POST   /api/procurement/receipts/:id/add-inspector
POST   /api/procurement/receipts/:id/verify
POST   /api/procurement/receipts/:id/post-to-inventory
```

## Payments

```
GET    /api/procurement/payments
POST   /api/procurement/payments
GET    /api/procurement/payments/:id

POST   /api/procurement/payments/:id/submit
POST   /api/procurement/payments/:id/approve
POST   /api/procurement/payments/:id/mark-paid
```
