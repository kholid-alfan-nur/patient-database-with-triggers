/*
BUSINESS SCENARIO: PATIENT HEALTH DATABASE

The aim of the following triggers and stored procedure is to create a patient diagnosis and medication record. This medication record can be used for further development into a drug inventory system, disease data analysis, patient record reference system, and others.

There are two manually inserted tables: Patients and Diagnosis. A third table, Treatment Plan, will be populated and upadated based on a after insert and after update triggers on the Patients table.

The treatment plan table will maintain a list of all diagnosis and medications that each patient has ever had. No cascade rules has been implemented since patient records will need to be kept on file for future references, eventhough the patient may no longer be in the Patients table.

The main purpose of this database is to compile health data, so further normalization of the tables are not necessary. PatientName, for example, will not be normalized to first name and last name since it is not necessary.

Finally, a stored procedure is programmed to query a patient's name and retrieve their all of their diagnosis and treatment records.
*/

CREATE DATABASE HealthDataDB
GO

USE HealthDataDB
GO

--CREATE PATIENTS TABLE: the only data we need are ID, name, and diagnosis. For the purpose of this database, the patient's address is not relevant.
CREATE TABLE Patients
(
PatientID INT IDENTITY NOT NULL PRIMARY KEY,
PatientName VARCHAR(100) NOT NULL,
Diagnosis VARCHAR(100) NULL,
)
GO

--CREATE DIAGNOSIS TABLE: The diagnosis database will be a reference for the triggers, so we need to populate it manually.
CREATE TABLE Diagnosis
(
DiagnosisName VARCHAR(100) NOT NULL PRIMARY KEY,
Drug1 VARCHAR(100) NULL,
Drug2 VARCHAR(100) NULL,
Drug3 VARCHAR(100) NULL,
Drug4 VARCHAR(100) NULL,
)
GO

INSERT INTO Diagnosis VALUES (N'Respiratory Disease', N'Antihistamine', N'Corticosteroid', NULL, NULL)
INSERT INTO Diagnosis VALUES (N'Cardiovascular Disease', N'ACE Inhibitors', N'Statins', N'Nitrates', N'Anticoagulant')
INSERT INTO Diagnosis VALUES (N'Diabetes', N'Metformin', N'Sulfonylurea', N'Insulin', NULL)
INSERT INTO Diagnosis VALUES (N'Bacterial Infection', N'Antibiotics', N'Antipyretic', NULL, NULL)
GO

--CREATE TREATMENT OPTIONS TABLE: Population of this table will triggered by entry into the Patients table. This will be a permanent health record of each patient, so ON DELETE CASCADE will not be necessary.
CREATE TABLE TreatmentOptions
(
PatientID INT NOT NULL,
PatientName VARCHAR(100) NOT NULL,
Diagnosis VARCHAR(100) NOT NULL,
Treatment1 VARCHAR(100) NULL,
Treatment2 VARCHAR(100) NULL,
Treatment3 VARCHAR(100) NULL,
Treatment4 VARCHAR(100) NULL,
ActionDesc VARCHAR(100),
InsertDateTime DATETIME
)
GO

--AFTER INSERT TRIGGER: The insert trigged will be on Patients table but draws data from both Patients and Diagnosis tables.
CREATE TRIGGER trTreatmentAfterInsert ON Patients
AFTER INSERT
AS
	DECLARE @PatientID INT;
	DECLARE @PatientName VARCHAR(100);
	DECLARE @Diagnosis VARCHAR(100);
	DECLARE @Treatment1 VARCHAR(100);
	DECLARE @Treatment2 VARCHAR(100);
	DECLARE @Treatment3 VARCHAR(100);
	DECLARE @Treatment4 VARCHAR(100);
	DECLARE @ActionTest VARCHAR(100);

	SELECT @PatientID = i.PatientID FROM INSERTED i;
	SELECT @PatientName = i.PatientName FROM INSERTED i;
	SELECT @Diagnosis = i.Diagnosis FROM INSERTED i;
	SELECT @Treatment1 = (select Drug1 FROM Diagnosis WHERE @Diagnosis = DiagnosisName)
	SELECT @Treatment2 = (select Drug2 FROM Diagnosis WHERE @Diagnosis = DiagnosisName)
	SELECT @Treatment3 = (select Drug3 FROM Diagnosis WHERE @Diagnosis = DiagnosisName)
	SELECT @Treatment4 = (select Drug4 FROM Diagnosis WHERE @Diagnosis = DiagnosisName)

	SET @ActionTest = 'Record Inserted – AFTER INSERT Trigger.'

	INSERT INTO TreatmentOptions VALUES (@PatientID, @PatientName, @Diagnosis, @Treatment1, @Treatment2, @Treatment3, @Treatment4, @ActionTest, GETDATE())

	PRINT 'AFTER INSERT trigger has been fired.'
GO

--AFTER UPDATE TRIGGER: Each record update will be logged by the action test, but the old data will not be deleted. It will serve as a permanent health record of all patients.
CREATE TRIGGER trTreatmentAfterUpdate ON Patients
AFTER UPDATE
AS
	DECLARE @PatientID INT;
	DECLARE @PatientName VARCHAR (100);
	DECLARE @Diagnosis VARCHAR(100);
	DECLARE @Treatment1 VARCHAR(100);
	DECLARE @Treatment2 VARCHAR(100);
	DECLARE @Treatment3 VARCHAR(100);
	DECLARE @Treatment4 VARCHAR(100);
	DECLARE @ActionTest VARCHAR(100);

	SELECT @PatientID = i.PatientID FROM INSERTED i;
	SELECT @PatientName = i.PatientName FROM INSERTED i;
	SELECT @Diagnosis = i.Diagnosis FROM INSERTED i;
	SELECT @Treatment1 = (select Drug1 FROM Diagnosis WHERE @Diagnosis = DiagnosisName)
	SELECT @Treatment2 = (select Drug2 FROM Diagnosis WHERE @Diagnosis = DiagnosisName)
	SELECT @Treatment3 = (select Drug3 FROM Diagnosis WHERE @Diagnosis = DiagnosisName)
	SELECT @Treatment4 = (select Drug4 FROM Diagnosis WHERE @Diagnosis = DiagnosisName)

	IF UPDATE(PatientID)
	IF UPDATE(PatientName)
	IF UPDATE(Diagnosis)	

	SET @ActionTest = 'Record Updated – AFTER UPDATE Trigger.';
	SET @ActionTest = 'Record Updated – AFTER UPDATE Trigger.';
	SET @ActionTest = 'Record Updated – AFTER UPDATE Trigger.';

	INSERT INTO TreatmentOptions VALUES (@PatientID, @PatientName, @Diagnosis, @Treatment1, @Treatment2, @Treatment3, @Treatment4, @ActionTest, GETDATE())

	PRINT 'AFTER UPDATE trigger has been fired.'
GO

--SQL statements to enter into the Patients table that will initiate the triggers
INSERT INTO Patients Values (N'Scott Adams', N'Bacterial Infection')
UPDATE Patients SET Diagnosis = 'Diabetes' WHERE PatientName = 'Scott Adams'
GO

--Stored Procedure for retrieving patient data
CREATE PROC spPatientRecord @Name VARCHAR(20)
AS
SELECT * FROM TreatmentOptions WHERE PatientName = @Name
GO

EXEC spPatientRecord @Name='Scott Adams'
GO

--Stored Procedure for retrieving Diagnosis data
CREATE PROC spDiagnosisData @Diagnosis VARCHAR(20)
AS
SELECT * FROM TreatmentOptions WHERE Diagnosis = @Diagnosis
GO

EXEC spDiagnosisData @Diagnosis='Diabetes'
