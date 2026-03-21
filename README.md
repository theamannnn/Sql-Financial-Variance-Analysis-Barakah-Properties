# SQL Financial Variance Analysis — Barakah Properties

A end-to-end SQL analysis showcasing the rental income and maintenance cost reporting workflow for a property management company. Built in PostgreSQL using pgAdmin.

---

## Business Context

Barakah Properties manages a portfolio of 5 residential and commercial buildings across Dubai — Jumeirah Village Circle, Dubai Marina, Deira, Al Barsha, and Dubai Silicon Oasis. The finance and operations teams need regular reporting on:

- Whether buildings are hitting their rental income targets
- Which units are vacant, in arrears, or underperforming
- Where maintenance budgets are being exceeded
- The overall net financial position per building

This here is the workflow of pulling data from property management, accounting, and facilities systems cleaning it into a relational model and answering 7 real business questions using SQL.

---

## Database Schema

The analysis is built across 5 related tables:

| Table | Description | Rows |
|---|---|---|
| `buildings` | Master list of 5 properties with location and type | 5 |
| `units` | Individual apartments, offices and retail units per building | 150 |
| `rental_targets` | Monthly budgeted rent per unit for 2024 | 1,800 |
| `rental_actuals` | Actual rent collected per unit per month with payment status | 1,800 |
| `maintenance_costs` | Monthly budgeted vs actual maintenance costs by category | 336 |

**Relationships:**
- `buildings` → `units` (one to many on `building_id`)
- `units` → `rental_targets` (one to many on `unit_id`)
- `units` → `rental_actuals` (one to many on `unit_id`)
- `buildings` → `maintenance_costs` (one to many on `building_id`)

---

## Business Questions & SQL Techniques

### Q1 — Income Variance by Building
*Which buildings are under collecting vs target, and by how much in AED and %?*

Joins `rental_actuals`, `rental_targets`, `units`, and `buildings`. Aggregates total collected vs total targeted per building and calculates variance in AED and percentage. Uses `NULLIF` to guard against division by zero.

**Techniques:** Multi table JOIN · GROUP BY · SUM · ROUND · NULLIF

---

### Q2 — Unit Status Breakdown (Q4 2024)
*What is the payment status breakdown per building for Q4 2024?*

Filters for months 10, 11, 12 using `IN`. Uses conditional aggregation to count Paid, Late, Arrears, and Vacant statuses as separate columns rather than separate rows — a common pattern in management reporting.

**Techniques:** WHERE with IN · COUNT DISTINCT · Conditional aggregation with CASE WHEN

---

### Q3 — Top 10 Units by Rent Shortfall
*Which 10 units have the highest cumulative rent shortfall in 2024, and what is driving it?*

Identifies the worst performing individual units across the portfolio. Includes arrears and vacancy counts per unit to surface whether the shortfall is driven by empty units or non-paying tenants two problems that require very different management responses.

**Techniques:** Multi table JOIN · CASE WHEN · GROUP BY · ORDER BY · LIMIT

---

### Q4 — Maintenance Overspend by Category
*Where are we over budget on maintenance costs?*

Breaks down maintenance variance by building and cost category (AC, Plumbing, Cleaning, Electrical, Security, Landscaping). Uses `HAVING` to filter the output to overspends only keeping the report focused on problem areas.

**Techniques:** GROUP BY · SUM · HAVING · ROUND · NULLIF

---

### Q5 — Collection Efficiency by Quarter
*What percentage of target rent is being collected per building per quarter?*

Uses CTEs to break the problem into two steps first label each month as Q1–Q4, then aggregate to building and quarter level. Calculates collection efficiency rate as a positive KPI metric distinct from variance percentage.

**Techniques:** CTE (WITH clause) · CASE WHEN for quarter labeling · Multi level aggregation

---

### Q6 — Net Position (P&L) per Building
*What is the net financial position per building after accounting for maintenance costs?*

Uses two chained CTEs one summarising rent collected, one summarising maintenance spend then joins them in the main query to produce a simple P&L view per building.

**Techniques:** Multiple CTEs · USING join syntax · Derived column arithmetic

---

### Q7 — Performance Tier Classification
*How does each building rank overall Top Performer, On Track, At Risk, or Underperforming?*

Classifies each building into a performance tier based on annual collection efficiency. Thresholds: above 98% = Top Performer, 95–98% = On Track, 90–95% = At Risk, below 90% = Underperforming.

**Techniques:** CASE WHEN tiering · Aggregation with classification · Full year filter

---

## Key Findings

- **Marina Heights Tower (B002)** is the top performer — consistently highest collection efficiency across all quarters
- **Silicon Oasis Hub (B005)** is the weakest — highest vacancy rate and lowest collection efficiency, classified as Underperforming
- **AC Maintenance** is the biggest overspend category across the portfolio — particularly in summer months (May–September), consistent with Dubai's climate demands
- **Deira Business Centre (B003)** shows the highest maintenance overspend percentage despite being a mid-size commercial property

---

## Files

```
|
├── buildings.csv
├── units.csv
├── rental_targets.csv
├── rental_actuals.csv
├── maintenance_costs.csv
└── Solution_script.sql
```

---

## Tools Used

- **PostgreSQL** — database and query execution
- **pgAdmin 4** — query development and data import
