DROP TABLE IF EXISTS StudentEnrollments;

CREATE TABLE StudentEnrollments (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    course_id VARCHAR(10),
    enrollment_date DATE
);

INSERT INTO StudentEnrollments (student_id, student_name, course_id, enrollment_date) VALUES
(1, 'Ashish', 'CSE101', '2024-06-01'),
(2, 'Smaran', 'CSE102', '2024-06-01'),
(3, 'Vaibhav', 'CSE103', '2024-06-01');

-- PART A: Simulate Deadlock Between Two Transactions
-- Instructions:
-- Open two sessions (Session 1 and Session 2) in your DB client.

-- Session 1:
START TRANSACTION;
UPDATE StudentEnrollments SET enrollment_date='2024-07-01' WHERE student_id=1;
-- Pause here, do NOT commit yet
-- Wait until Session 2 runs the first update

-- Session 2:
START TRANSACTION;
UPDATE StudentEnrollments SET enrollment_date='2024-08-01' WHERE student_id=2;
-- Pause here, do NOT commit yet
-- Now try updating student 1 to trigger deadlock
UPDATE StudentEnrollments SET enrollment_date='2024-08-02' WHERE student_id=1;
-- One session will fail with deadlock error

-- Session 1 can now try to update student 2
UPDATE StudentEnrollments SET enrollment_date='2024-07-02' WHERE student_id=2;
-- The database automatically rolls back one transaction

-- PART B: MVCC to Allow Concurrent Read/Write
-- Session A: Reader
START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM StudentEnrollments WHERE student_id=1;
-- Should see: enrollment_date = 2024-06-01

-- Session B: Writer
START TRANSACTION;
UPDATE StudentEnrollments SET enrollment_date='2024-07-10' WHERE student_id=1;
COMMIT;

-- Back to Session A:
SELECT * FROM StudentEnrollments WHERE student_id=1;
-- Still sees old value 2024-06-01
COMMIT;

-- PART C: Comparing Behavior With and Without MVCC
-- Scenario 1: Traditional Locking (blocking)
-- Session 1: Writer
START TRANSACTION;
SELECT * FROM StudentEnrollments WHERE student_id=1 FOR UPDATE;
UPDATE StudentEnrollments SET enrollment_date='2024-08-01' WHERE student_id=1;
-- Do NOT commit yet

-- Session 2: Reader/Writer
START TRANSACTION;
SELECT * FROM StudentEnrollments WHERE student_id=1 FOR UPDATE;
-- This will BLOCK until Session 1 commits

-- After Session 1 commits:
COMMIT;

-- Scenario 2: MVCC (non-blocking reads)
-- Session 1: Writer
START TRANSACTION;
UPDATE StudentEnrollments SET enrollment_date='2024-09-01' WHERE student_id=1;
-- Not committed yet

-- Session 2: Reader
START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM StudentEnrollments WHERE student_id=1;
-- Will see old value, e.g., 2024-08-01, without blocking
COMMIT;

-- Session 1 commits
COMMIT;
