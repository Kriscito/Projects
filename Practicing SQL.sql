/*

SQL Practice

*/

------------------------------------------------------------------------------------------------------------------------

-- Using the 'Having' clauses
SELECT  JobTitle, 
		COUNT(JobTitle)
FROM EmployeeDemographics a
JOIN EmployeeSalary b
	ON a.EmployeeID = b.EmployeeID
GROUP BY JobTitle
HAVING COUNT(JobTitle) > 1

SELECT  JobTitle, 
		AVG(Salary)
FROM EmployeeDemographics a
JOIN EmployeeSalary b
	ON a.EmployeeID = b.EmployeeID
GROUP BY JobTitle
HAVING AVG(Salary) > 44000
ORDER BY AVG(Salary)

------------------------------------------------------------------------------------------------------------------------

-- Using the 'Case' statement

SELECT  FirstName, 
		LastName, 
		Age,
CASE WHEN Age > 30 THEN 'Old'
	 WHEN Age BETWEEN 27 AND 30 THEN 'Young'
END 
FROM EmployeeDemographics
WHERE Age IS NOT NULL
ORDER BY Age


SELECT  FirstName, 
		LastName, 
		JobTitle, 
		Salary,
CASE WHEN JobTitle = 'Salesman' THEN Salary + (Salary * 0.10)
	 WHEN JobTitle = 'Accountant' THEN Salary + (Salary * 0.05)
	 WHEN JobTitle = 'HR' THEN Salary + (Salary * 0.02)
	 ELSE Salary + (Salary * 0.03)
END As NewSalary
FROM EmployeeDemographics a
JOIN EmployeeSalary b
	ON a.EmployeeID = b.EmployeeID

------------------------------------------------------------------------------------------------------------------------

-- The Partition By statement

SELECT  FirstName, 
		LastName, 
		Gender, 
		Salary, 
		COUNT(Gender) OVER (PARTITION BY Gender) as TotalGender, 
		AVG(SALARY) OVER (PARTITION BY GENDER) AS AverageSalary
FROM EmployeeDemograghics a
JOIN EmployeeSalary b
	ON a.EmployeeID = b.EmployeeID
WHERE Age > 31
					

------------------------------------------------------------------------------------------------------------------------

-- How to write subqueries
-- Subquery in Select statement

SELECT EmployeeID, Salary, 
(SELECT AVG(Salary) FROM  EmployeeSalary) AS AvgSalary
FROM EmployeeSalary;

-- Perform a subquery with partition by

SELECT EmployeeID, Salary, AVG(Salary) OVER () AS AvgSalary
FROM EmployeeSalary;

-- Subquery in the from statement

SELECT * 
FROM	(SELECT EmployeeID, Salary, AVG(Salary) OVER () AS AvgSalary
		FROM EmployeeSalary) a

-- Subquery in the where statement

SELECT EmployeeID, JobTitle, Salary
FROM EmployeeSalary 
WHERE Salary < 45000 And EmployeeID IN (
					SELECT EmployeeID
					FROM EmployeeDemograghics
					WHERE Age > 30);


------------------------------------------------------------------------------------------------------------------------

-- Creating Temp Tables

CREATE TABLE #temp_employee 
	(
	EmployeeID INT,
	JobTitle VARCHAR(255), 
	Salary INT
	)

INSERT INTO #temp_employee
SELECT *
FROM EmployeeSalary


CREATE TABLE #TempEmployee 
	(
	JobTitle VARCHAR(50),
	EmployeesPerJob INT,
	AvgAge INT,
	AvgSalary INT
	)

INSERT INTO #TempEmployee
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM EmployeeDemograghics a
JOIN EmployeeSalary b
	ON a.EmployeeID = b.EmployeeID
GROUP BY JobTitle


------------------------------------------------------------------------------------------------------------------------

-- Stored Procedures In SQL

CREATE PROCEDURE EmployeeData
AS
SELECT CONCAT(FirstName, ' ', LastName) AS EmployeeName, Age, JobTitle, Salary
FROM EmployeeDemograghics a
JOIN EmployeeSalary b
ON a.EmployeeID = b.EmployeeID;

-- Test the stored procedure
EXEC EmployeeData;

CREATE PROCEDURE Temp_Employee
AS
CREATE TABLE #temp_employee (JobTitle VARCHAR(255), EmployeesPerJob INT, AvgAge INT, AvgSalary INT)

INSERT INTO #temp_employee
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
	FROM EmployeeDemograghics a
	JOIN EmployeeSalary b
		ON a.EmployeeID = b.EmployeeID
	GROUP BY JobTitle

SELECT * 
FROM #temp_employee;

-- Test the Procedure

EXEC Temp_Employee

------------------------------------------------------------------------------------------------------------------------

-- How to use CTEs


WITH Employees AS	(
SELECT  FirstName, 
		LastName, 
		Gender, 
		Salary, 
		COUNT(Gender) OVER (PARTITION BY Gender) as TotalGender, 
		AVG(SALARY) OVER (PARTITION BY GENDER) AS AverageSalary
FROM EmployeeDemograghics a
JOIN EmployeeSalary b
	ON a.EmployeeID = b.EmployeeID
WHERE Salary > 45000
					)
SELECT LastName,
		Gender,
		Salary 
FROM employees

------------------------------------------------------------------------------------------------------------------------