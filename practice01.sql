-- Step 1: Create Table

CREATE TABLE FeePayments (
    payment_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) CHECK (amount > 0),
    payment_date DATE NOT NULL
);

-- Part A: Insert Multiple Fee Payments in a Transaction (COMMIT Example)
START TRANSACTION;

INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES 
(1, 'Ashish', 5000.00, '2024-06-01'),
(2, 'Smaran', 4500.00, '2024-06-02'),
(3, 'Vaibhav', 5500.00, '2024-06-03');

COMMIT;

SELECT * FROM FeePayments;

-- Part B: Demonstrate ROLLBACK for Failed Payment Insertion

START TRANSACTION;
INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES (4, 'Kiran', 4800.00, '2024-06-04');
INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES (1, 'Ashish', -3000.00, '2024-06-05');

ROLLBACK;
SELECT * FROM FeePayments;

-- Part C: Simulate Partial Failure (NULL Student Name)

START TRANSACTION;

INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES (5, 'Ravi', 4600.00, '2024-06-06');

INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES (6, NULL, 4700.00, '2024-06-07');

ROLLBACK;

SELECT * FROM FeePayments;

-- Part D: Verify ACID Compliance in One Flow

START TRANSACTION;
INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES (7, 'Sneha', 4700.00, '2024-06-08'),
       (8, 'Arjun', 4900.00, '2024-06-09');
COMMIT;

START TRANSACTION;
INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES (9, 'Rohit', 5000.00, '2024-06-10');

INSERT INTO FeePayments (payment_id, student_name, amount, payment_date)
VALUES (2, 'DuplicateID', 5200.00, '2024-06-11');
ROLLBACK;

-- Final table state
SELECT * FROM FeePayments;
