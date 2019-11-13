# patient-database-with-triggers
Patient diagnosis and medication record database, with  triggers and stored procedures

BUSINESS SCENARIO: PATIENT HEALTH DATABASE

The aim of the following triggers and stored procedure is to create a patient diagnosis and medication record. This medication record can be used for further development into a drug inventory system, disease data analysis, patient record reference system, and others.

There are two manually inserted tables: Patients and Diagnosis. A third table, Treatment Plan, will be populated and upadated based on a after insert and after update triggers on the Patients table.

The treatment plan table will maintain a list of all diagnosis and medications that each patient has ever had. No cascade rules has been implemented since patient records will need to be kept on file for future references, eventhough the patient may no longer be in the Patients table.

The main purpose of this database is to compile health data, so further normalization of the tables are not necessary. PatientName, for example, will not be normalized to first name and last name since it is not necessary.

Finally, a stored procedure is programmed to query a patient's name and retrieve their all of their diagnosis and treatment records.
