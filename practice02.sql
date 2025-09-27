-- Step 1: Create StudentEnrollments table
CREATE TABLE StudentEnrollments (
    enrollment_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    course_id VARCHAR(10) NOT NULL,
    enrollment_date DATE NOT NULL,
    CONSTRAINT uq_student_course UNIQUE (student_name, course_id)
);

-- Transaction for User A
START TRANSACTION;

INSERT INTO StudentEnrollments (enrollment_id, student_name, course_id, enrollment_date)
VALUES 
(1, 'Ashish', 'CSE101', '2024-07-01'),
(2, 'Smaran', 'CSE102', '2024-07-01'),
(3, 'Vaibhav', 'CSE101', '2024-07-01');

COMMIT;

-- User A (already enrolled Ashish in CSE101)
START TRANSACTION;
INSERT INTO StudentEnrollments (enrollment_id, student_name, course_id, enrollment_date)
VALUES (4, 'Ashish', 'CSE101', '2024-07-05'); -- This will FAIL (duplicate key)
COMMIT;

-- User A starts transaction and locks Ashish's CSE101 row
START TRANSACTION;
SELECT * FROM StudentEnrollments
WHERE student_name = 'Ashish' AND course_id = 'CSE101'
FOR UPDATE;

-- User B tries to update the locked row
START TRANSACTION;
UPDATE StudentEnrollments
SET enrollment_date = '2024-07-10'
WHERE student_name = 'Ashish' AND course_id = 'CSE101';

-- Keep the transaction open here (do not commit/rollback yet)
-- This row is now locked for updates by others

COMMIT;

SELECT * FROM StudentEnrollments;
