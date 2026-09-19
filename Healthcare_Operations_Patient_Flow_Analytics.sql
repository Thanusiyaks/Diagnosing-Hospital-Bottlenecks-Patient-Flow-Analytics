CREATE DATABASE healthcare_analytics;
USE healthcare_analytics;
DROP TABLE IF EXISTS patient_flow;
CREATE TABLE patient_flow (
    Patient_ID VARCHAR(20) PRIMARY KEY,
    Visit_Date DATE,
    Department VARCHAR(50),
    Gender VARCHAR(20),
    Age INT,
    Visit_Type VARCHAR(30),
    Doctor_ID VARCHAR(20),
    Insurance_Type VARCHAR(30),
    Patient_Status VARCHAR(30),
    Waiting_Time_Min DECIMAL(10,2),
    Treatment_Duration_Min INT,
    Length_of_Stay_Days INT,
    Satisfaction_Score DECIMAL(3,1)
);
DESCRIBE patient_flow;
SELECT COUNT(*) AS Total_Patients
FROM patient_flow;
SELECT
    ROUND(AVG(Waiting_Time_Min), 2) AS Average_Waiting_Time
FROM patient_flow;
SELECT
    Department,
    COUNT(*) AS Total_Visits,
    ROUND(AVG(Waiting_Time_Min), 2) AS Avg_Waiting_Time,
    ROUND(AVG(Treatment_Duration_Min), 2) AS Avg_Treatment_Duration,
    ROUND(AVG(Satisfaction_Score), 2) AS Avg_Satisfaction
FROM patient_flow
GROUP BY Department
ORDER BY Avg_Waiting_Time DESC;
SELECT
    Visit_Type,
    COUNT(*) AS Total_Visits,
    ROUND(AVG(Waiting_Time_Min), 2) AS Avg_Waiting_Time,
    ROUND(AVG(Treatment_Duration_Min), 2) AS Avg_Treatment_Duration
FROM patient_flow
GROUP BY Visit_Type
ORDER BY Total_Visits DESC;
SELECT
    Patient_Status,
    COUNT(*) AS Total_Patients,
    ROUND(AVG(Waiting_Time_Min), 2) AS Avg_Waiting_Time,
    ROUND(AVG(Length_of_Stay_Days), 2) AS Avg_Length_of_Stay
FROM patient_flow
GROUP BY Patient_Status
ORDER BY Total_Patients DESC;
SELECT
    Doctor_ID,
    COUNT(*) AS Total_Visits,
    ROUND(AVG(Waiting_Time_Min), 2) AS Avg_Waiting_Time,
    ROUND(AVG(Treatment_Duration_Min), 2) AS Avg_Treatment_Duration
FROM patient_flow
GROUP BY Doctor_ID
ORDER BY Total_Visits DESC;
CREATE TABLE department_master (
    Department_ID VARCHAR(10) PRIMARY KEY,
    Department VARCHAR(50)
);
INSERT INTO department_master
(Department_ID, Department)
VALUES
('D001', 'Cardiology'),
('D002', 'Emergency'),
('D003', 'General Medicine'),
('D004', 'Neurology'),
('D005', 'Orthopedics'),
('D006', 'Pediatrics');
SELECT
    p.Department,
    d.Department_ID,
    COUNT(*) AS Total_Visits,
    ROUND(AVG(p.Waiting_Time_Min), 2) AS Avg_Waiting_Time,
    ROUND(AVG(p.Satisfaction_Score), 2) AS Avg_Satisfaction
FROM patient_flow p
JOIN department_master d
    ON p.Department = d.Department
GROUP BY
    p.Department,
    d.Department_ID
ORDER BY Avg_Waiting_Time DESC;
WITH department_summary AS (
    SELECT
        Department,
        COUNT(*) AS Total_Visits,
        AVG(Waiting_Time_Min) AS Avg_Waiting_Time
    FROM patient_flow
    GROUP BY Department
)
SELECT
    Department,
    Total_Visits,
    ROUND(Avg_Waiting_Time, 2) AS Avg_Waiting_Time
FROM department_summary
ORDER BY Avg_Waiting_Time DESC;
WITH department_summary AS (
    SELECT
        Department,
        AVG(Waiting_Time_Min) AS Avg_Waiting_Time
    FROM patient_flow
    GROUP BY Department
)
SELECT
    Department,
    ROUND(Avg_Waiting_Time, 2) AS Avg_Waiting_Time,
    RANK() OVER (
        ORDER BY Avg_Waiting_Time DESC
    ) AS Wait_Rank
FROM department_summary;