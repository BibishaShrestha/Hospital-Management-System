-- DATABASE: Hospital1

Create Database Hospital1;
Use Hospital1;

-- TABLE CREATION:
-- ============================================================

-- Department Table

CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(50)
);

-- Patient Table

CREATE TABLE Patient (
    patient_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    gender VARCHAR(10),
    age INT,
    phone VARCHAR(15)
);

-- Doctor Table

CREATE TABLE Doctor (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    specialization VARCHAR(50),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

-- Appointment Table

CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id)
);

-- Billing Table

CREATE TABLE Billing (
    bill_id INT PRIMARY KEY,
    appointment_id INT,
    total_amount DECIMAL(10,2),
    payment_status VARCHAR(20),
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);


-- INSERT DATA:
-- ============================================================

-- Department

INSERT INTO Department VALUES
(1, 'Cardiology', 'Block A'),
(2, 'Neurology', 'Block B'),
(3, 'Orthopedics', 'Block C'),
(4, 'Pediatrics', 'Block D'),
(5, 'General Medicine', 'Block E');

-- Patient

INSERT INTO Patient VALUES
(1, 'Ben Adam', 'Male', 45, '9811111111'),
(2, 'Aaisha Shree', 'Female', 30, '9822222222'),
(3, 'Jenny Green', 'Female', 60, '9833333333'),
(4, 'Biyaan Parson', 'Female', 25, '9844444444'),
(5, 'Thomas Sinclaire', 'Male', 50, '9855555555');

-- Doctor

INSERT INTO Doctor VALUES
(1, 'Dr. Bibisha Shrestha', 'Cardiologist', 1),
(2, 'Dr. Bidhi Shrivastav', 'Neurologist', 2),
(3, 'Dr. Caroline Forbes', 'Orthopedic Surgeon', 3),
(4, 'Dr. Katherine Salvatore', 'Pediatrician', 4),
(5, 'Dr. Liam Rys', 'Physician', 5);

-- Appointment

INSERT INTO Appointment VALUES
(1, 1, 1, '2026-02-01', 'Completed'),
(2, 2, 2, '2026-02-05', 'Completed'),
(3, 3, 1, '2026-02-10', 'Scheduled'),
(4, 4, 4, '2026-02-12', 'Completed'),
(5, 5, 5, '2026-02-15', 'Scheduled');

--Billing

INSERT INTO Billing VALUES
(1, 1, 5000.00, 'Paid'),
(2, 2, 7000.00, 'Paid'),
(3, 3, 4500.00, 'Unpaid'),
(4, 4, 3000.00, 'Paid'),
(5, 5, 6000.00, 'Unpaid');

-- TABLES:

SELECT * FROM Department;
SELECT * FROM Patient;
SELECT * FROM Doctor;
SELECT * FROM Appointment;
SELECT * FROM Billing;


-- QUERIES:
-- ============================================================

-- 1. INNER JOIN:
-- Show patient name and doctor name for each appointment

SELECT p.name AS patient_name, d.name AS doctor_name, a.appointment_date
FROM Appointment AS a
INNER JOIN Patient AS p ON a.patient_id = p.patient_id
INNER JOIN Doctor AS d ON a.doctor_id = d.doctor_id;


-- 2. LEFT JOIN:
-- Show all patients and their appointments (even if they have none)

SELECT p.name, a.appointment_date
FROM Patient AS p
LEFT JOIN Appointment AS a ON p.patient_id = a.patient_id;


-- 3. RIGHT JOIN:
-- Show All Doctors and Their Appointments

SELECT d.name AS Doctor_Name, a.appointment_date, a.status
FROM Appointment AS a
RIGHT JOIN Doctor d ON a.doctor_id = d.doctor_id;



-- 4. Aggregate Function (COUNT + GROUP BY):
-- Count Number of Appointments Per Doctor

SELECT d.name AS Doctor_Name, COUNT(a.appointment_id) AS Total_Appointments
FROM Doctor d
LEFT JOIN Appointment a ON d.doctor_id = a.doctor_id
GROUP BY d.name;



-- 5. SUM :
-- Total Revenue From Paid Bills


SELECT SUM(total_amount) AS Total_Revenue
FROM Billing
WHERE payment_status = 'Paid';



-- 6. AVG:
-- Average Bill Amount

SELECT AVG(total_amount) AS Average_Bill
FROM Billing;

-- 7. Subquery:
-- Find patients who have appointments with a specific doctor

SELECT name
FROM Patient
WHERE patient_id IN (
    SELECT patient_id
    FROM Appointment
    WHERE doctor_id = 1
);


-- 8. View:

-- Create a view for paid bills

CREATE VIEW Paid_Bills AS
SELECT bill_id, total_amount
FROM Billing
WHERE payment_status = 'Paid';

-- To check it:
SELECT *
FROM Paid_Bills;


-- Create View Showing Full Appointment Details
CREATE OR ALTER VIEW Appointment_Details AS
SELECT 
    a.appointment_id,
    p.name AS Patient_Name,
    d.name AS Doctor_Name,
    a.appointment_date,
    a.status
FROM Appointment AS a
JOIN Patient p ON a.patient_id = p.patient_id
JOIN Doctor d ON a.doctor_id = d.doctor_id;

--To check it:
SELECT * FROM Appointment_Details;


-- 9. Transaction (COMMIT / ROLLBACK):
-- Mark Bill as Paid

BEGIN TRANSACTION;

UPDATE Billing
SET payment_status = 'Paid'
WHERE bill_id = 1;


-- Check before committing
SELECT * FROM Billing WHERE bill_id = 1;
-- If correct
COMMIT;
-- If wrong
-- ROLLBACK;



