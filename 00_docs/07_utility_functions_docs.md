# Utility & Supporting Functions Documentation

This document outlines the core utility functions (iTVFs) and scalar functions developed to support cross-functional operations across the RetailOpsLab database, ensuring clean architecture, code reusability, and optimal performance.

### 1. `fn_calculate_order_total`
* **Description:** Calculates the total amount for a given order by aggregating the line totals of its respective order items.
* **Beneficiaries:** Core Sales and checkout processing procedures to finalize transactions.
* **Target Team Members:** Mohamed Akram (Core Sales Procedures) and Alaa Ramadan (Transaction Logic).

### 2. `fn_get_available_stock`
* **Description:** Evaluates the current holding stock for a specific product across warehouses to ensure adequate inventory before processing new orders.
* **Beneficiaries:** Inventory tracking and order creation validations to prevent overselling.
* **Target Team Members:** Heba (Inventory Procedures) and Mohamed Akram (Core Sales Procedures).

### 3. `fn_CalculateLoyaltyPoints`
* **Description:** Computes loyalty reward points dynamically based on the total order amount and the customer's specific tier (e.g., Normal vs. VIP).
* **Beneficiaries:** Customer management modules and invoice generation to update and display reward balances.
* **Target Team Members:** Daliah (Customer/Invoice Procedures) and Mahmoud Nofaal (Backend Node.js API).

### 4. `fn_GetCustomerFinancialSummary`
* **Description:** Provides a highly optimized, aggregated summary of a customer's lifetime purchase value, total order count, and their last transaction date.
* **Beneficiaries:** User dashboards and rapid data retrieval endpoints without complex joins in the application layer.
* **Target Team Members:** Daliah (Customer Procedures) and Mahmoud Nofaal (Backend Node.js API).

### 5. `fn_MaskContactInfo`
* **Description:** Masks sensitive contact information (emails and phone numbers) to prevent unauthorized viewing of raw personal data in the UI or lower-privileged queries.
* **Beneficiaries:** Security protocols, Trigger protections, and secure data exposure policies.
* **Target Team Members:** Doaa Safwat (Triggers/Protection), Fayza Ahmed (Security/Roles), and Mahmoud Nofaal (Backend Node.js API).

### 6. `fn_GetRelatedProducts`
* **Description:** Generates a randomized list of alternative or related active products from the same category to support cross-selling features.
* **Beneficiaries:** Product recommendation engines and shopping cart UI.
* **Target Team Members:** Heba (Inventory Procedures) and Mahmoud Nofaal (Backend Node.js API).

### 7. `fn_CalculateWorkingDays`
* **Description:** Calculates the exact number of business days between two given dates by excluding weekends (Saturdays and Sundays).
* **Beneficiaries:** Order processing tracking to evaluate fulfillment efficiency and expected delivery dates.
* **Target Team Members:** Mohamed Akram (Core Sales & Order Procedures).

### 8. `fn_GetFiscalPeriod`
* **Description:** Converts a given calendar date into specific time dimensions, such as Calendar Year, Month, and Quarter.
* **Beneficiaries:** Statistical reporting and sales aggregation queries.
* **Target Team Members:** Mohamed Akram (Sales Reports) and the broader reporting team.