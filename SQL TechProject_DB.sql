CREATE DATABASE TechProject_DB
USE TechProject_DB

-- Table Create IT_Projects
Create Table IT_Projects
(
ProjectID INT IDENTITY(1,1) PRIMARY KEY,
ProjectName VARCHAR(50) NOT NULL,
StartDate DATE,
EndDate DATE,
Budget DECIMAL(10,2)
)
INSERT INTO IT_Projects VALUES('Project Alpha','2024-01-01','2024-06-01',50000.00),
('Project Beta','2024-02-15','2024-08-15',75000.00),
('Project Gamma','2024-03-01','2024-09-01',60000.00),
('Project Delta','2024-04-01','2024-10-01',55000.00),
('Project Epsilon','2024-05-01','2024-11-01',80000.00),
('Project Zeta','2024-06-01','2024-12-01',90000.00),
('Project Eta','2024-07-01','2025-01-01',100000.00),
('Project Theta','2024-08-01','2025-02-01',120000.00),
('Project Iota','2024-09-01','2025-03-01',110000.00),
('Project Kappa','2024-10-01','2025-04-01',130000.00)

SELECT * FROM IT_Projects

-- Table Create IT_Teams
Create Table IT_Teams
(
TeamID INT IDENTITY(1,1) PRIMARY KEY,
TeamName VARCHAR(50) NOT NULL,
ProjectID INT,
TeamLead VARCHAR(50),
NumberofMembers INT,
FOREIGN KEY (ProjectID) REFERENCES IT_Projects(ProjectID)
)
INSERT INTO IT_Teams VALUES('Development Team A',1,'Alice Johnson',10),
('QA Team A',1,'Bob Smith',5),
('Development Team B',2,'Charlei Brown',8),
('QA Team B',2,'David Wilson',4),
('Devops Team A',3,'Eve Davis',7),
('Development Team C',4,'Frank Miller',9),
('QA Team C',4,'Grace Clark',6),
('Support Team A',5,'Henry Lewis',12),
('Devops Team B',6,'Ivy Harris',5),
('Development Team D',7,'Jack White',11)

SELECT * FROM IT_Teams

--Q1- Select all projects with a budget greater than $70,000.

SELECT * FROM IT_Projects
WHERE Budget > 70000

--Q2- Find the name of the team lead for 'Project Alpha'.

SELECT TeamLead FROM IT_Teams
WHERE ProjectID=(select ProjectID FROM IT_Projects WHERE ProjectName = 'Project Alpha')

--Q3- List all teams that have more than 8 members.

SELECT * FROM IT_Teams
WHERE NumberofMembers > 8

--Q4- Count the number of projects that started after March 2024.

SELECT COUNT(*) FROM IT_Projects
WHERE StartDate > '2024-03-01'

--Q5- Find the total budget allocated for all projects.

SELECT SUM(Budget) AS TotalBudget FROM IT_Projects

--Q6- Update the budget of 'Project Gamma' to $65,000.

UPDATE IT_Projects
SET Budget = 65000
WHERE ProjectName = 'Project Gamma'

select * from IT_Projects

--Q7- Delete the team with the least number of members.

DELETE FROM IT_Teams
WHERE NumberofMembers = (SELECT MIN(NumberofMembers) FROM IT_Teams)

SELECT * FROM IT_Teams

--Q8- List all projects along with the corresponding team names.

SELECT P.ProjectName, T.TeamName
FROM IT_Projects P
JOIN IT_Teams T ON P.ProjectID = T.ProjectID

--Q9- Select projects that do not have any teams assigned.

SELECT * FROM IT_Projects
WHERE ProjectID NOT IN(SELECT ProjectID FROM IT_Teams)

--Q10- Find the project with the maximum budget.

SELECT TOP 1 * FROM IT_Projects
ORDER BY Budget DESC

--Q11- List team names and project names using INNER JOIN.

SELECT T.TeamName,P.ProjectName
FROM IT_Teams T
INNER JOIN IT_Projects P ON T.ProjectID = P.ProjectID

--Q12- Get the project name and budget where the budget is less than $60,000.

SELECT ProjectName, Budget from IT_Projects
where Budget < 60000

--Q13- List the number of teams working on each project.

SELECT P.ProjectName,COUNT(T.TeamID) AS TeamCount
FROM IT_Projects P
LEFT JOIN IT_Teams T ON P.ProjectID = T.ProjectID
GROUP BY P.ProjectName

--Q14- Find projects that have both a 'Development' and a 'QA' team.

SELECT P.ProjectName
FROM IT_Projects P
WHERE EXISTS (SELECT 1 FROM IT_Teams T WHERE T.ProjectID = P.ProjectID AND T.TeamName LIKE '%Development%')
  AND EXISTS (SELECT 1 FROM IT_Teams T WHERE T.ProjectID = P.ProjectID AND T.TeamName LIKE '%QA%')

  --Q15- Select project names and end dates for projects ending after December 2024.

  SELECT ProjectName, EndDate FROM IT_Projects
  WHERE EndDate > '2024-12-31'

  --Q16- Get the names of teams that are not assigned to any project.

  SELECT TeamName FROM IT_Teams
  WHERE ProjectID IS NULL

  --Q17- Find projects with no end date specified.

  SELECT * FROM IT_Projects
  WHERE EndDate IS NULL

  --Q18- Calculate the average budget of all projects.

  SELECT AVG(Budget) AS AverageBudget from IT_Projects

  --Q19-	List team leads who are leading more than one team.

  SELECT TeamLead, COUNT(TeamID) AS TeamCount
  FROM IT_Teams
  GROUP BY TeamLead
  HAVING COUNT(TeamID) > 1

  --Q20- Find projects with a budget between $60,000 and $90,000.

  SELECT * FROM IT_Projects
  WHERE Budget BETWEEN 60000 AND 90000

  --Q21- Update the team name 'QA Team A' to 'QA Team Alpha'.

  UPDATE IT_Teams
  SET TeamName = 'QA Team Alpha'
  WHERE TeamName = 'QA Team A'

  SELECT * FROM IT_Teams

  --Q22- List projects and their team counts using a correlated subquery.

  SELECT ProjectName,(SELECT COUNT(*) FROM IT_Teams T WHERE T.ProjectID = P.ProjectID) AS TeamCount
  FROM IT_Projects P

  --Q23- Select team names along with the corresponding project names using LEFT JOIN.

  SELECT T.TeamName, P.ProjectName
  from IT_Teams T
  LEFT JOIN IT_Projects P ON T.ProjectID = P.ProjectID

  --Q24- Delete all projects with a budget lower than $50,000.

  DELETE FROM IT_Projects
  WHERE Budget < 50000

  --Q25- Insert a new project with specific details.

  INSERT INTO IT_Projects (ProjectName, StartDate,EndDate,Budget)
  VALUES('Project Lambda','2024-11-01','2025-05-01',75000.00)

  select * from IT_Projects

  -- Stored Procedure
  -- A stored procedure is a precompiled collection of SQL statements that can be executed as a single command

  CREATE PROCEDURE GetProjectsBudget
     @MinBudget DECIMAL(10,2),
	 @MaxBudget DECIMAL(10,2)
AS
BEGIN
    SELECT ProjectID, ProjectName, StartDate,EndDate,Budget
	FROM IT_Projects
	WHERE Budget BETWEEN @MinBudget AND @MaxBudget
END

EXEC GetProjectsBudget @MinBudget = 60000.00, @MaxBudget = 100000.00

-- Trigger 
-- Triggers are special types of stored procedures that automatically execute in response to certain events on a particular table.

Create Table TeamLog
(
LogID INT IDENTITY(1,1) PRIMARY KEY,
TeamName VARCHAR(50),
ProjectID INT,
LogDate DATETIME DEFAULT GETDATE()
)

CREATE TRIGGER TrgAfterInsertTeam
ON IT_Teams
AFTER INSERT
AS
BEGIN
    INSERT INTO TeamLog (TeamName, ProjectID)
	SELECT TeamName, ProjectID FROM inserted
END

--  Insert a new team to see the trigger in action

INSERT INTO IT_Teams (TeamName, ProjectID, TeamLead, NumberofMembers)
VALUES('New Dev Team',8,'Nina Collins',8)

SELECT * FROM TeamLog


--Schema Binding
-- Schema binding is used in SQL Server to bind the schema of an object to a database object, ensuring that the underlying table's
-- schema cannot be changed without modifying or dropping the object.

CREATE VIEW dbo.vw_ProjectDetails
WITH SCHEMABINDING
AS
SELECT ProjectID, ProjectName, Budget
FROM dbo.IT_Projects

--Union Queries
-- Union queries are used to combine the result set of two or more SELECT queries.

SELECT ProjectName AS Name
FROM IT_Projects
UNION
SELECT TeamName AS Name
FROM IT_Teams


-- Below are examples of basic ALTER, DELETE, and UPDATE queries in SQL, demonstrating how to modify table structures, 
-- remove data, and update data, respectively

--1- ALTER TABLES QUERIES
-- The ALTER statement is used to modify an existing database object, such as a table, by adding, deleting, or modifying columns.
-- Adding A new Column

ALTER TABLE IT_Projects
ADD ProjectStatus VARCHAR(20)

SELECT * FROM IT_Projects

--2- Modifying an Existing Column
-- Change the data type of the ProjectStatus column to allow for more characters

ALTER TABLE IT_Projects
ALTER COLUMN ProjectStatus VARCHAR(50)

--3- Dropping a Column
-- Remove the ProjectStatus column from the IT_Projects table

ALTER TABLE IT_Projects
DROP COLUMN ProjectStatus


--4-  Deleting Records Based on a Condition
-- Delete projects that have a budget lower than a certain amount

	DELETE FROM IT_Projects
	WHERE Budget < 50000.00

--UPDATE QUERIES

UPDATE IT_Projects
SET EndDate = '2024-11-30'
WHERE ProjectID = 3

SELECT * FROM IT_Projects


