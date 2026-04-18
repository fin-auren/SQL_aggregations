#   SQL Aggregations, JOINs & Fraud Investigation

**PayFlow Payments Database + "Diwali Weekend" Fraud Case Study**

A production-style SQL project covering GROUP BY, HAVING, all four JOIN types, and a real fraud investigation workflow — hunting 3 fraud typologies hidden in transaction data.

---

## Database Architecture

### PayFlow Teaching Database (10 transactions)
Three carefully designed tables with **intentional discrepancies** to illustrate JOIN behaviour:
- **T010** uses merchant M04 — which does NOT exist in the merchants table
- **Nykaa (M05)** exists in merchants but has ZERO transactions

These two cases make every JOIN type produce a different result — which is the point.

### Fraud Case Study: "The Diwali Weekend" Database
Isolated slice of a payment gateway database after a chargeback spike:
- 7 users (mix of trusted and suspicious)
- 4 merchants (including one shell)
- 14 transactions (5 normal + 9 fraud)

---

## SQL Files

| File | Concepts |
|---|---|
| `sql/01_aggregations.sql` | `COUNT`, `SUM`, `AVG`, `GROUP BY`, `HAVING`, execution order |
| `sql/02_joins.sql` | `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `FULL OUTER JOIN`, 3-table JOIN, audit queries |
| `fraud-case-study/03_fraud_investigation.sql` | EDA, chargeback quantification, burner accounts, velocity attack, shell merchant |

---

## Key Concepts

### The WHERE vs HAVING Trap

```sql
-- WRONG — throws an error:
SELECT merchant_id, COUNT(*) AS cnt
FROM transactions
GROUP BY merchant_id
WHERE cnt > 2;           -- cnt doesn't exist at WHERE stage

-- CORRECT:
SELECT merchant_id, COUNT(*) AS cnt
FROM transactions
GROUP BY merchant_id
HAVING cnt > 2;          -- cnt exists after GROUP BY
```

**Rule:** WHERE filters rows *before* grouping. HAVING filters groups *after* aggregation. They run at different steps in the execution order.

### The JOIN Decision Tree

```
Do you need ALL rows from your main table?
├── YES → LEFT JOIN (most common in reporting)
│         (missing matches show as NULL — a visible flag, not a silent drop)
└── NO  → INNER JOIN (only complete matched rows)
          Use when partial data is meaningless in your context

Need ALL rows from BOTH tables (including unmatched)?
└── FULL OUTER JOIN (reconciliation, gap analysis)
    In SQLite: simulate with LEFT JOIN UNION LEFT JOIN (flipped)
```

### SQL Execution Order (not the writing order)
```
1. FROM        → load the table(s)
2. JOIN        → combine tables
3. WHERE       → filter individual rows
4. GROUP BY    → form groups
5. HAVING      → filter groups
6. SELECT      → pick columns and compute aliases
7. ORDER BY    → sort
8. LIMIT       → cut to N rows
```

---

## Fraud Investigation: Results

Running `03_fraud_investigation.sql` produces these findings:

**Chargeback ratio: 35.7%** — over 35× the 1% threshold that triggers a $100K fine and payment freeze.

| Typology | Suspect | Evidence |
|---|---|---|
| Burner Account | U_881 (John Doe 1) | Signed up Oct 24, first transaction Oct 25 (1.09 days gap), risk score 95 |
| Velocity Attack | U_881 | 5 transactions in the 02:00 AM hour, ₹2,45,000 total — bot confirmed |
| Shell Merchant | M_99 (Global Crypto Exchange) | 75% chargeback ratio, T+0 settlement (collects money same day before chargebacks) |

**One-line insight:** A single burner account (U_881) executed a velocity attack against Amazon at 2AM on Diwali weekend, while a shell crypto merchant (M_99) was simultaneously collecting stolen card payments at T+0 settlement — both exploiting the holiday weekend's reduced monitoring.

---

## How to Run

**DB Fiddle (browser — recommended):**
1. Go to [db-fiddle.com](https://www.db-fiddle.com) → select **SQLite**
2. Paste the `CREATE TABLE` + `INSERT INTO` blocks in the Schema panel
3. Run any query from the SQL files in the Query panel

**SQLite locally:**
```bash
sqlite3 class10.db < sql/01_aggregations.sql
sqlite3 class10.db < sql/02_joins.sql
sqlite3 class10.db < fraud-case-study/03_fraud_investigation.sql
```

---

## Interview-Ready Concepts from This Class

- **Chargeback Ratio** — % of total transactions that result in chargebacks. Above 1% = High-Risk Aggregator classification, $100K fine, risk of payment freeze.
- **Burner Account** — newly created account used immediately for fraud. Detected by: `days_since_signup ≤ 2 AND risk_score > 80`.
- **Velocity Attack** — bot firing multiple transactions in seconds. Detected by: `COUNT(*) ≥ 3 in same hour per user`.
- **Shell/Bust-Out Merchant** — fake merchant using stolen cards to buy from themselves. Detected by: abnormally high `chargeback_ratio` + `T+0 settlement_sla`.
- **Representment** — the process by which a merchant disputes a chargeback by submitting evidence (receipts, delivery logs). Rarely succeeds.

---

*Built as part of Foundation Masterclass — : SQL Aggregations, JOINs & FinTech Fraud Analysis*
