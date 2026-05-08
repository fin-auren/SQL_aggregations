CREATE DATABASE payments_method;

USE payments_method;

CREATE TABLE payments(
payment_id VARCHAR(10),
merchant_id VARCHAR(20),
amount FLOAT,
payment_method VARCHAR(20),
status_id VARCHAR(20),
created_at time
);
DROP table payments;

CREATE TABLE merchants(
merchant_id VARCHAR(5),
merchant_name VARCHAR(100),
category VARCHAR(50)
);

INSERT INTO payments(payment_id, merchant_id, amount, payment_method, status_id, created_at) VALUES
('PAY_001', 'M01', 500.00, 'UPI', 'captured', '2026-03-10 14:30:00'),
('PAY_002', 'M02', 1200.00, 'CREDIT_CARD', 'failed', '2026-03-10 15:45:00'),
('PAY_003', 'M01', 800.00, 'UPI', 'captured', '2026-03-11 09:00:00'),
('PAY_004', 'M03', 300.00, 'NETBANKING', 'created', '2026-03-11 10:30:00'),
('PAY_005', 'M01', 950.00, 'UPI', 'captured', '2026-03-11 12:00:00'),
('PAY_006', 'M02', 450.00, 'CREDIT_CARD', 'failed', '2026-03-12 08:15:00'),
('PAY_007', 'M01', 200.00, 'UPI', 'created', '2026-03-12 16:00:00'),
('PAY_008', 'M03', 1100.00, 'NETBANKING', 'captured', '2026-03-12 18:30:00'),
('PAY_009', 'M02', 700.00, 'CREDIT_CARD', 'failed', '2026-03-13 11:00:00'),
('PAY_010', 'M04', 650.00, 'UPI', 'captured', '2026-03-13 20:45:00');

INSERT INTO merchants (merchant_id, merchant_name, category) VALUES
('M01', 'Swiggy', 'Food Delivery'),
('M02', 'Zomato', 'Food Delivery'),
('M03', 'BookMyShow', 'Entertainment'),
('M05', 'Nykaa', 'Beauty');

SELECT * FROM payments;

SELECT status_id, COUNT(*) AS payment_count
FROM payments
GROUP BY status_id;


SELECT payment_method, sum(amount) 
FROM payments
GROUP BY payment_method;

SELECT payment_method, COUNT(*) AS usage_count
FROM payments
GROUP BY payment_method
HAVING count(*) > 2;


SELECT merchant_id, sum(amount) AS total_amount
FROM payments
WHERE status_id = 'captured'
GROUP BY merchant_id
HAVING sum(amount) > 1000;

SELECT 
    p.payment_id,
    m.merchant_name,
    p.amount,
    p.status_id
FROM payments p
INNER JOIN merchants m
    ON p.merchant_id = m.merchant_id;



SELECT 
    p.payment_id,
    m.merchant_name,
    p.amount,
    p.status_id
FROM payments p
LEFT JOIN merchants m
    ON p.merchant_id = m.merchant_id;
    
SELECT 
    m.merchant_name,
    SUM(p.amount) AS total_revenue
FROM payments p
INNER JOIN merchants m
    ON p.merchant_id = m.merchant_id
GROUP BY m.merchant_name
ORDER BY total_revenue DESC;




