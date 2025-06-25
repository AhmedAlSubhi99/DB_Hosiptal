Create Database HospitalProject;

-- Patients table
CREATE TABLE Patients
(
    P_ID INT PRIMARY KEY, -- Unique identifier for each patient
    P_Name VARCHAR(100) NOT NULL, -- Patient's full name
    P_Gender VARCHAR(10) CHECK (P_Gender IN ('Male', 'Female', 'Other')), -- Gender with constraint
    P_DOB DATE NOT NULL, -- Date of birth
    P_Contact_Info VARCHAR(100) -- Optional contact details (e.g., phone or email)
);
GO

-- Departments table
CREATE TABLE Departments
(
    De_ID INT PRIMARY KEY, -- Unique department ID
    De_Name VARCHAR(100) NOT NULL UNIQUE -- Unique department name
);
GO

-- Staff table 
CREATE TABLE Staff
(
    S_ID INT PRIMARY KEY,
    S_Name VARCHAR(100) NOT NULL,
    Role VARCHAR(50) CHECK (Role IN ('Nurse', 'Admin', 'Technician', 'Receptionist')),
    Shift VARCHAR(50) DEFAULT 'Day',
    De_ID INT NOT NULL,
    SuperviseBy INT NULL, -- FK to Doctors, must be created after Doctors table
    FOREIGN KEY (De_ID) REFERENCES Departments(De_ID)
);
GO

-- Doctors table 
CREATE TABLE Doctors 
(
    D_ID INT PRIMARY KEY,
    D_Name VARCHAR(100) NOT NULL,
    D_Gender VARCHAR(10) CHECK (D_Gender IN ('Male', 'Female', 'Other')),
    D_Specialization VARCHAR(100),
    D_Contact_Info VARCHAR(100),
    De_ID INT NOT NULL,
    ManagedBy INT,
    FOREIGN KEY (De_ID) REFERENCES Departments(De_ID),
    FOREIGN KEY (ManagedBy) REFERENCES Staff(S_ID)
);
GO

-- Users table
CREATE TABLE Users 
(
    UserName VARCHAR(50) PRIMARY KEY, -- Login username
    Password VARCHAR(100) NOT NULL, -- Encrypted or plain password
    Role VARCHAR(50) CHECK (Role IN ('AdminUser', 'StaffUser')), -- Application role
    S_ID INT UNIQUE NOT NULL, -- Linked to Staff (1-to-1)
    FOREIGN KEY (S_ID) REFERENCES Staff(S_ID) -- FK to Staff
);
GO

-- Rooms table
CREATE TABLE Rooms
(
    Room_Num INT PRIMARY KEY, -- Room number
    R_Type VARCHAR(50) CHECK (R_Type IN ('ICU', 'General', 'Private')), -- Type of room
    Availability BIT DEFAULT 1 -- Availability flag: 1=available, 0=occupied
);
GO

-- MedicalRecords table
CREATE TABLE MedicalRecords 
(
    MR_ID INT PRIMARY KEY, -- Medical record ID
    P_ID INT NOT NULL, -- Patient
    D_ID INT NOT NULL, -- Attending doctor
    Date DATE NOT NULL, -- Date of record
    Treatment_Plans TEXT, -- Optional treatment plan
    Notes TEXT, -- Doctor's notes
    Diagnosis TEXT NOT NULL, -- Diagnosis made
    FOREIGN KEY (P_ID) REFERENCES Patients(P_ID), -- FK to Patients
    FOREIGN KEY (D_ID) REFERENCES Doctors(D_ID) -- FK to Doctors
);
GO

-- Billing table
CREATE TABLE Billing 
(
    B_ID INT PRIMARY KEY, -- Bill ID
    P_ID INT NOT NULL, -- Patient
    Date DATE NOT NULL, -- Billing date
    TotalCost DECIMAL(10,2) NOT NULL CHECK (TotalCost >= 0), -- Total cost for bill
    FOREIGN KEY (P_ID) REFERENCES Patients(P_ID) -- FK to Patients
);
GO

-- Services table
CREATE TABLE Services
(
    Service_ID INT PRIMARY KEY, -- Unique ID for service
    Service_Name VARCHAR(100) NOT NULL UNIQUE -- Name of service
);
GO

-- AdmissionStay table
CREATE TABLE AdmissionStay 
(
    P_ID INT NOT NULL, -- Patient ID
    Room_Num INT NOT NULL, -- Room number assigned
    DateIn DATE NOT NULL, -- Check-in date
    DateOut DATE, -- Check-out date (nullable)
    CONSTRAINT PK_AdmissionStay_Composite PRIMARY KEY (P_ID, Room_Num, DateIn), -- Composite key
    FOREIGN KEY (P_ID) REFERENCES Patients(P_ID), -- FK to Patients
    FOREIGN KEY (Room_Num) REFERENCES Rooms(Room_Num) -- FK to Rooms
);
GO

-- BillingDetails table
CREATE TABLE BillingDetails
(
    B_ID INT NOT NULL, -- Reference to main bill
    Service_ID INT NOT NULL, -- Specific service charged
    Performed_By INT NOT NULL, -- Staff member who performed it
    Quantity INT NOT NULL CHECK (Quantity > 0), -- Quantity of service
    Unit_Cost DECIMAL(10,2) NOT NULL CHECK (Unit_Cost >= 0), -- Price per unit
    CONSTRAINT PK_BillingDetails_Composite PRIMARY KEY (B_ID, Service_ID), -- Composite PK
    -- Foreign key linking to the main bill record
    CONSTRAINT FK_BillingDetails_Billing FOREIGN KEY (B_ID) REFERENCES Billing(B_ID),
    -- Foreign key ensuring the billed service exists in the Services table
    CONSTRAINT FK_BillingDetails_Service FOREIGN KEY (Service_ID) REFERENCES Services(Service_ID),
    -- Foreign key identifying which staff member performed the service
    CONSTRAINT FK_BillingDetails_Performer FOREIGN KEY (Performed_By) REFERENCES Staff(S_ID)
);
GO

-- AppointmentsLink table
CREATE TABLE AppointmentsLink 
(
    P_ID INT NOT NULL, -- Patient ID
    D_ID INT NOT NULL, -- Doctor ID
    Ap_DateTime DATETIME NOT NULL, -- Scheduled appointment time
    CONSTRAINT PK_Appointments_Composite PRIMARY KEY (P_ID, D_ID, Ap_DateTime), -- Composite PK
    FOREIGN KEY (P_ID) REFERENCES Patients(P_ID), -- FK to Patients
    FOREIGN KEY (D_ID) REFERENCES Doctors(D_ID) -- FK to Doctors
);
GO

-- Add FK to Staff AFTER Doctors exists
ALTER TABLE Staff
ADD CONSTRAINT FK_Staff_SuperviseBy FOREIGN KEY (SuperviseBy) REFERENCES Doctors(D_ID);
GO

ALTER TABLE Doctors
ADD Shift VARCHAR(50) DEFAULT 'Day';

UPDATE Doctors
SET Shift = 'Day'
WHERE Shift IS NULL;



-- Insert patients with names, genders, DOBs, and contact numbers
INSERT INTO Patients (P_ID, P_Name, P_Gender, P_DOB, P_Contact_Info) VALUES
(1, 'Basma Al Balushi', 'Female', '1990-12-08', '992136803'),
(2, 'Fahad Al Busaidi', 'Male', '1980-02-28', '998975998'),
(3, 'Fatma Al Balushi', 'Female', '1959-06-23', '993922079'),
(4, 'Sara Al Riyami', 'Female', '1991-09-02', '998070528'),
(5, 'Yusuf Al Shukaili', 'Male', '2001-09-18', '998410469'),
(6, 'Majid Al Shukaili', 'Male', '1997-09-10', '993489730'),
(7, 'Ali Al Shukaili', 'Male', '1981-12-24', '995175844'),
(8, 'Fatma Al Harthy', 'Female', '1956-06-16', '993130177'),
(9, 'Salma Al Harthy', 'Female', '1976-06-01', '994150523'),
(10, 'Raya Al Rawahi', 'Female', '1972-05-04', '997320629'),
(11, 'Fatma Al Busaidi', 'Female', '1986-08-18', '997180675'),
(12, 'Ahmed Al Balushi', 'Male', '1956-09-20', '997931186'),
(13, 'Salim Al Rawahi', 'Male', '1992-09-09', '999528603'),
(14, 'Majid Al Rawahi', 'Male', '1977-04-05', '992616428'),
(15, 'Fatma Al Balushi', 'Female', '1982-08-26', '994202345'),
(16, 'Fatma Al Riyami', 'Female', '1978-03-07', '994808762'),
(17, 'Shaima Al Harthy', 'Female', '1956-02-04', '997361393'),
(18, 'Saeed Al Busaidi', 'Male', '1997-12-19', '998020654'),
(19, 'Nasser Al Abri', 'Male', '1997-10-04', '998242080'),
(20, 'Ahmed Al Riyami', 'Male', '1965-08-16', '995248141'),
(21, 'Aisha Al Habsi', 'Female', '1982-12-28', '998510675'),
(22, 'Shaima Al Hinai', 'Female', '1958-11-05', '996487238'),
(23, 'Sara Al Busaidi', 'Female', '2003-04-25', '997281615'),
(24, 'Fahad Al Rawahi', 'Male', '2000-09-06', '995625407'),
(25, 'Khalid Al Shukaili', 'Male', '1964-04-09', '997607341'),
(26, 'Nasser Al Shukaili', 'Male', '1979-10-18', '999307125'),
(27, 'Raya Al Rawahi', 'Female', '1999-12-26', '998636304'),
(28, 'Khalid Al Riyami', 'Male', '1970-06-19', '994725092'),
(29, 'Nasser Al Riyami', 'Male', '2005-02-10', '992878937'),
(30, 'Salma Al Farsi', 'Female', '1959-10-23', '994852804');

-- Insert departments data
INSERT INTO Departments (De_ID, De_Name) VALUES
(1, 'Internal Medicine'),       
(2, 'Cardiology'),              
(3, 'Orthopedics'),       
(4, 'Pediatrics'),              
(5, 'Emergency'),             
(6, 'Radiology'),           
(7, 'Surgery'),             
(8, 'Neurology'),             
(9, 'Dermatology'),         
(10, 'Oncology'),              
(11, 'Psychiatry'),          
(12, 'Ophthalmology'),          
(13, 'ENT (Otolaryngology)'),  
(14, 'Nephrology'),             
(15, 'Gastroenterology'),       
(16, 'Urology'),             
(17, 'Obstetrics and Gynecology'), 
(18, 'Anesthesiology'),         
(19, 'Pulmonology'),          
(20, 'Endocrinology');          
   
-- Insert hospital staff (nurses, admin, technicians, Receptionist)
INSERT INTO Staff (S_ID,S_Name,Role,Shift,De_ID) VALUES
(1,'Latifa Al-Balushi','Admin','Day',1),
(2,'Hassan Al-Harthy','Nurse','Night',2),
(3,'Maha Al-Maqbali','Nurse','Day',3),
(4,'Zahir Al-Riyami','Receptionist','Evening',4),
(5,'Shaima Al-Hinai','Admin','Day',5),
(6,'Faisal Al-Shanfari','Nurse','Night',1),
(7,'Aisha Al-Siyabi','Receptionist','Day',2),
(8,'Talib Al-Farsi','Technician','Evening',3),
(9,'Nawal Al-Mahrouqi','Nurse','Day',4),
(10,'Huda Al-Lawati','Nurse','Night',5),
(11,'Majid Al-Kalbani','Technician','Day',1),
(12,'Badria Al-Hinawi','Receptionist','Evening',2),
(13,'Yousef Al-Rawas','Admin','Day',3),
(14,'Rawya Al-Amri','Nurse','Night',4),
(15,'Fahad Al-Azri','Technician','Day',5),
(16,'Ruqaya Al-Abri','Receptionist','Evening',1),
(17,'Sultan Al-Busaidi','Admin','Day',2),
(18,'Asma Al-Kindi','Nurse','Night',3),
(19,'Hilal Al-Hinai','Nurse','Day',4),
(20,'Mubarak Al-Araimi','Nurse','Evening',5),
(21,'Wafa Al-Mukhaini','Admin','Day',1),
(22,'Amer Al-Saadi','Nurse','Night',2),
(23,'Samira Al-Belushi','Technician','Day',3),
(24,'Tariq Al-Shukaili','Nurse','Evening',4),
(25,'Rashid Al-Rahbi','Admin','Day',5),
(26,'Nasser Al-Kharusi','Nurse','Night',1),
(27,'Maha Al-Zadjali','Nurse','Evening',2),
(28,'Salim Al-Sabri','Technician','Day',3),
(29,'Fatma Al-Jahwari','Nurse','Day',4),
(30,'Tariq Al-Nabhani','Nurse','Night',5);


-- Insert doctors with department assignment and contact info
INSERT INTO Doctors (D_ID,D_Name,D_Gender,D_Specialization,D_Contact_Info,De_ID,ManagedBy) VALUES
(1,'Ahmed Al-Balushi','Male','Cardiology','ahmed.b@hospital.om',1,1),
(2,'Salim Al-Harthy','Male','Neurology','salim.h@hospital.om',2,5),
(3,'Fatma Al-Maqbali','Female','Pediatrics','fatma.m@hospital.om',3,13),
(4,'Khalid Al-Riyami','Male','Orthopedics','khalid.r@hospital.om',4,17),
(5,'Maryam Al-Hinai','Female','Dermatology','maryam.h@hospital.om',5,21),
(6,'Saeed Al-Shanfari','Male','Gastroenterology','saeed.s@hospital.om',1,25),
(7,'Aisha Al-Siyabi','Female','Gynecology','aisha.s@hospital.om',2,1),
(8,'Talib Al-Farsi','Male','Urology','talib.f@hospital.om',3,5),
(9,'Nawal Al-Mahrouqi','Female','Radiology','nawal.m@hospital.om',4,13),
(10,'Hassan Al-Lawati','Male','Oncology','hassan.l@hospital.om',5,17),
(11,'Huda Al-Kalbani','Female','ENT','huda.k@hospital.om',1,21),
(12,'Majid Al-Hinawi','Male','Endocrinology','majid.h@hospital.om',2,25),
(13,'Badria Al-Rawas','Female','Nephrology','badria.r@hospital.om',3,1),
(14,'Yousef Al-Amri','Male','Pulmonology','yousef.a@hospital.om',4,5),
(15,'Rawya Al-Azri','Female','Hematology','rawya.a@hospital.om',5,13),
(16,'Faisal Al-Abri','Male','Allergy','faisal.a@hospital.om',1,17),
(17,'Latifa Al-Busaidi','Female','Internal Medicine','latifa.b@hospital.om',2,21),
(18,'Zahir Al-Kindi','Male','General Surgery','zahir.k@hospital.om',3,25),
(19,'Asma Al-Hinai','Female','Rheumatology','asma.h@hospital.om',4,1),
(20,'Mubarak Al-Araimi','Male','Plastic Surgery','mubarak.a@hospital.om',5,5),
(21,'Shaima Al-Mukhaini','Female','Emergency Medicine','shaima.m@hospital.om',1,13),
(22,'Hilal Al-Saadi','Male','Infectious Disease','hilal.s@hospital.om',2,17),
(23,'Wafa Al-Belushi','Female','Pathology','wafa.b@hospital.om',3,21),
(24,'Amer Al-Shukaili','Male','Anesthesiology','amer.s@hospital.om',4,25),
(25,'Ruqaya Al-Rahbi','Female','Family Medicine','ruqaya.r@hospital.om',5,1),
(26,'Nasser Al-Kharusi','Male','Genetics','nasser.k@hospital.om',1,5),
(27,'Maha Al-Zadjali','Female','Ophthalmology','maha.z@hospital.om',2,13),
(28,'Sultan Al-Sabri','Male','Rehabilitation','sultan.s@hospital.om',3,17),
(29,'Samira Al-Jahwari','Female','Occupational Health','samira.j@hospital.om',4,21),
(30,'Tariq Al-Nabhani','Male','Sports Medicine','tariq.n@hospital.om',5,25);


-- This for Set Data in Subervise to staffs(Nursese)
UPDATE Staff SET SuperviseBy = 2 WHERE S_ID = 2;
UPDATE Staff SET SuperviseBy = 3 WHERE S_ID = 3;
UPDATE Staff SET SuperviseBy = 6 WHERE S_ID = 6;
UPDATE Staff SET SuperviseBy = 9 WHERE S_ID = 9;
UPDATE Staff SET SuperviseBy = 10 WHERE S_ID = 10;
UPDATE Staff SET SuperviseBy = 14 WHERE S_ID = 14;
UPDATE Staff SET SuperviseBy = 18 WHERE S_ID = 18;
UPDATE Staff SET SuperviseBy = 19 WHERE S_ID = 19;
UPDATE Staff SET SuperviseBy = 20 WHERE S_ID = 20;
UPDATE Staff SET SuperviseBy = 22 WHERE S_ID = 22;
UPDATE Staff SET SuperviseBy = 24 WHERE S_ID = 24;
UPDATE Staff SET SuperviseBy = 26 WHERE S_ID = 26;
UPDATE Staff SET SuperviseBy = 27 WHERE S_ID = 27;
UPDATE Staff SET SuperviseBy = 29 WHERE S_ID = 29;
UPDATE Staff SET SuperviseBy = 30 WHERE S_ID = 30;


-- Create user accounts for each staff member
INSERT INTO Users (UserName,Password,Role,S_ID) VALUES
('kshukaili01','khalid@2025','AdminUser',1),
('sriyami02','salim@2026','StaffUser',2),
('srawahi03','salim@2027','StaffUser',3),
('yhinai04','yusuf@2028','AdminUser',4),
('fbalushi05','fahad@2029','AdminUser',5),
('fshukaili06','fahad@2030','AdminUser',6),
('lfarsi07','layla@2031','StaffUser',7),
('habri08','hamad@2032','AdminUser',8),
('shinai09','sara@2033','StaffUser',9),
('mhinai10','majid@2034','StaffUser',10),
('mbusaidi11','mariam@2035','AdminUser',11),
('ashukaili12','ahmed@2036','AdminUser',12),
('mabri13','majid@2037','AdminUser',13),
('yhabsi14','yusuf@2038','AdminUser',14),
('shinai15','salma@2039','StaffUser',15),
('abusaidi16','ahmed@2040','AdminUser',16),
('hbusaidi17','huda@2041','StaffUser',17),
('sriyami18','shaima@2042','StaffUser',18),
('shabsi19','sara@2043','StaffUser',19),
('fhinai20','fatma@2044','AdminUser',20),
('ashukaili21','aisha@2045','AdminUser',21),
('mshukaili22','mariam@2046','AdminUser',22),
('sbusaidi23','shaima@2047','StaffUser',23),
('rhabsi24','raya@2048','StaffUser',24),
('abalushi25','ahmed@2049','AdminUser',25),
('hrawahi26','huda@2050','StaffUser',26),
('hhinai27','hamad@2051','AdminUser',27),
('thinai28','talal@2052','StaffUser',28),
('srawahi29','shaima@2053','StaffUser',29),
('bbalushi30','basma@2054','AdminUser',30);


-- Insert hospital room details
INSERT INTO Rooms (Room_Num, R_Type, Availability) VALUES
(101, 'ICU', 0),
(102, 'General', 1),
(103, 'General', 0),
(104, 'General', 1),
(105, 'Private', 1),
(106, 'ICU', 1),
(107, 'Private', 1),
(108, 'ICU', 0),
(109, 'ICU', 1),
(110, 'Private', 1),
(111, 'General', 1),
(112, 'General', 0),
(113, 'General', 0),
(114, 'General', 1),
(115, 'ICU', 1),
(116, 'ICU', 1),
(117, 'General', 1),
(118, 'Private', 1),
(119, 'General', 0),
(120, 'General', 1),
(121, 'Private', 0),
(122, 'Private', 0),
(123, 'General', 1),
(124, 'Private', 1),
(125, 'ICU', 0),
(126, 'ICU', 0),
(127, 'General', 1),
(128, 'Private', 0),
(129, 'ICU', 1),
(130, 'Private', 1);

-- Track which patients are admitted in which rooms and when
INSERT INTO AdmissionStay (P_ID, Room_Num, DateIn, DateOut) VALUES
(1, 107, '2025-05-26', NULL),
(2, 101, '2025-06-18', NULL),
(3, 103, '2025-06-11', '2025-06-17'),
(4, 118, '2025-06-07', '2025-06-10'),
(5, 110, '2025-06-07', NULL),
(6, 111, '2025-06-11', '2025-06-15'),
(7, 126, '2025-05-30', NULL),
(8, 117, '2025-06-18', NULL),
(9, 127, '2025-06-09', NULL),
(10, 102, '2025-06-18', NULL),
(11, 121, '2025-05-29', '2025-06-06'),
(12, 109, '2025-06-21', '2025-06-22'),
(13, 110, '2025-06-13', NULL),
(14, 118, '2025-05-27', '2025-06-02'),
(15, 111, '2025-06-15', NULL),
(16, 108, '2025-05-25', NULL),
(17, 103, '2025-06-09', '2025-06-19'),
(18, 121, '2025-06-14', NULL),
(19, 112, '2025-06-07', NULL),
(20, 120, '2025-06-13', '2025-06-22'),
(21, 128, '2025-05-25', NULL),
(22, 123, '2025-05-31', NULL),
(23, 112, '2025-06-18', NULL),
(24, 121, '2025-06-08', '2025-06-20'),
(25, 124, '2025-06-17', '2025-06-20'),
(26, 121, '2025-05-30', NULL),
(27, 106, '2025-06-09', NULL),
(28, 127, '2025-06-17', '2025-06-17'),
(29, 121, '2025-06-19', '2025-06-21'),
(30, 108, '2025-06-03', '2025-06-16');

-- Scheduled appointments between patients and doctors
INSERT INTO AppointmentsLink (P_ID, D_ID, Ap_DateTime) VALUES
(1, 10, '2025-06-29 16:01:30'),
(2, 21, '2025-07-23 03:30:43'),
(3, 25, '2025-06-23 20:02:43'),
(4, 13, '2025-07-22 17:32:47'),
(5, 23, '2025-07-23 02:49:15'),
(6, 6, '2025-07-17 13:12:19'),
(7, 19, '2025-07-10 05:11:04'),
(8, 19, '2025-07-21 22:14:13'),
(9, 14, '2025-06-29 11:36:34'),
(10, 6, '2025-06-26 02:11:32'),
(11, 11, '2025-07-11 01:17:00'),
(12, 8, '2025-07-15 21:55:36'),
(13, 12, '2025-07-11 02:40:34'),
(14, 18, '2025-07-13 23:19:25'),
(15, 24, '2025-07-08 20:41:33'),
(16, 19, '2025-07-10 22:58:56'),
(17, 19, '2025-07-04 01:27:05'),
(18, 22, '2025-07-15 08:16:41'),
(19, 2, '2025-07-10 04:45:48'),
(20, 19, '2025-07-02 21:20:41'),
(21, 19, '2025-07-02 07:36:13'),
(22, 14, '2025-07-12 02:35:57'),
(23, 21, '2025-06-26 13:51:04'),
(24, 19, '2025-07-13 16:17:35'),
(25, 25, '2025-07-11 18:23:52'),
(26, 15, '2025-07-17 20:11:46'),
(27, 26, '2025-07-06 10:24:23'),
(28, 23, '2025-07-02 00:50:57'),
(29, 4, '2025-07-20 16:25:06'),
(30, 1, '2025-07-11 19:38:37');

-- Medical records showing diagnosis and Treatment plan
INSERT INTO MedicalRecords (MR_ID, P_ID, D_ID, Date, Treatment_Plans, Notes, Diagnosis) VALUES
(1, 1, 1, '2025-06-16', 'Fracture assessment', 'Tv business enter star.', 'Hypertension'),
(2, 2, 13, '2025-06-15', 'Appendectomy', 'Want appear home blue.', 'Routine Immunization'),
(3, 3, 23, '2025-06-21', 'Appendectomy', 'Drug knowledge subject none general we.', 'Routine Immunization'),
(4, 4, 11, '2025-06-19', 'X-ray & report', 'Offer type front any but into market.', 'Stable vitals'),
(5, 5, 8, '2025-06-11', 'X-ray & report', 'Movement like my for have walk our.', 'Suspected fracture'),
(6, 6, 15, '2025-06-08', 'Blood pressure monitoring', 'Mean training over watch relationship too add.', 'Hypertension'),
(7, 7, 3, '2025-06-17', 'Diabetes consultation', 'Read artist effect collection indeed.', 'Suspected fracture'),
(8, 8, 16, '2025-06-18', 'Cardiac screening', 'Parent market clearly.', 'Type 2 Diabetes'),
(9, 9, 5, '2025-06-09', 'Vaccination', 'Modern shake until style few.', 'Infection'),
(10, 10, 24, '2025-06-19', 'Wound dressing', 'Executive begin kind nation evidence.', 'Sprained ankle'),
(11, 11, 22, '2025-06-12', 'Fracture assessment', 'Wait attack vote image social book now.', 'Suspected fracture'),
(12, 12, 4, '2025-06-18', 'Minor surgery', 'Ground manage create deep drop also travel.', 'Appendicitis'),
(13, 13, 15, '2025-06-09', 'Appendectomy', 'Until action prevent natural among walk.', 'Arrhythmia'),
(14, 14, 28, '2025-06-18', 'Appendectomy', 'Until fight executive poor foot.', 'Routine Immunization'),
(15, 15, 30, '2025-06-20', 'Wound dressing', 'Security skill letter.', 'Sprained ankle'),
(16, 16, 18, '2025-06-18', 'X-ray & report', 'Member turn hospital country baby.', 'Type 2 Diabetes'),
(17, 17, 5, '2025-06-20', 'X-ray & report', 'Expert little result.', 'Suspected fracture'),
(18, 18, 8, '2025-06-10', 'Vaccination', 'Business unit good pass.', 'Appendicitis'),
(19, 19, 28, '2025-06-18', 'General checkup', 'Good guy hospital another meet those believe.', 'Sprained ankle'),
(20, 20, 10, '2025-06-15', 'Appendectomy', 'Sister day his industry.', 'Suspected fracture'),
(21, 21, 8, '2025-06-19', 'Blood pressure monitoring', 'Surface accept small beat.', 'Stable vitals'),
(22, 22, 12, '2025-06-08', 'Cardiac screening', 'Chair leader view product.', 'Appendicitis'),
(23, 23, 8, '2025-06-09', 'Diabetes consultation', 'Charge leave bed property.', 'Stable vitals'),
(24, 24, 1, '2025-06-16', 'Appendectomy', 'What standard stage dog issue public.', 'Stable vitals'),
(25, 25, 3, '2025-06-10', 'Diabetes consultation', 'Factor protect generation.', 'Type 2 Diabetes'),
(26, 26, 13, '2025-06-13', 'X-ray & report', 'Around ask under explain.', 'Arrhythmia'),
(27, 27, 28, '2025-06-11', 'Cardiac screening', 'Society size painting should teacher table enjoy.', 'Infection'),
(28, 28, 28, '2025-06-18', 'Fracture assessment', 'Happy personal suffer theory owner glass real.', 'Suspected fracture'),
(29, 29, 18, '2025-06-08', 'Minor surgery', 'Media able family her contain for.', 'Infection'),
(30, 30, 2, '2025-06-10', 'Appendectomy', 'What move human question court reveal interview lose.', 'Hypertension');

-- Billing summary Data
INSERT INTO Billing (B_ID, P_ID, Date, TotalCost) VALUES
(1, 1, '2025-06-20', 72.89),
(2, 2, '2025-06-19', 249.97),
(3, 3, '2025-06-19', 118.55),
(4, 4, '2025-06-14', 423.56),
(5, 5, '2025-06-17', 276.45),
(6, 6, '2025-06-13', 374.14),
(7, 7, '2025-06-16', 460.92),
(8, 8, '2025-06-21', 369.40),
(9, 9, '2025-06-13', 121.74),
(10, 10, '2025-06-22', 189.81),
(11, 11, '2025-06-20', 454.65),
(12, 12, '2025-06-21', 86.40),
(13, 13, '2025-06-14', 356.80),
(14, 14, '2025-06-22', 442.99),
(15, 15, '2025-06-15', 102.83),
(16, 16, '2025-06-17', 438.52),
(17, 17, '2025-06-15', 329.49),
(18, 18, '2025-06-14', 168.74),
(19, 19, '2025-06-14', 148.38),
(20, 20, '2025-06-21', 467.79),
(21, 21, '2025-06-20', 435.32),
(22, 22, '2025-06-14', 33.66),
(23, 23, '2025-06-16', 67.73),
(24, 24, '2025-06-14', 429.18),
(25, 25, '2025-06-13', 61.68),
(26, 26, '2025-06-17', 220.22),
(27, 27, '2025-06-13', 371.26),
(28, 28, '2025-06-16', 341.58),
(29, 29, '2025-06-17', 185.84),
(30, 30, '2025-06-14', 85.00);


-- List of services available at the hospital
INSERT INTO Services (Service_ID, Service_Name) VALUES
(1, 'General Checkup'),
(2, 'Blood Test'),
(3, 'X-ray'),
(4, 'MRI Scan'),
(5, 'CT Scan'),
(6, 'Vaccination'),
(7, 'Ultrasound'),
(8, 'ECG'),
(9, 'Appendectomy'),
(10, 'Cardiac Screening'),
(11, 'Wound Dressing'),
(12, 'Fracture Assessment'),
(13, 'Diabetes Consultation'),
(14, 'Minor Surgery'),
(15, 'ENT Examination'),
(16, 'Dermatology Consultation'),
(17, 'Neurology Test'),
(18, 'Physical Therapy'),
(19, 'Pulmonary Function Test'),
(20, 'Vision Screening');


-- Billing details show what services were billed to which patient and who performed them
INSERT INTO BillingDetails (B_ID, Service_ID, Performed_By, Quantity, Unit_Cost) VALUES
(1, 20, 20, 1, 84.65),
(2, 18, 29, 1, 133.76),
(3, 19, 10, 1, 37.78),
(4, 8, 26, 2, 73.66),
(5, 3, 3, 1, 132.55),
(6, 8, 15, 1, 42.85),
(7, 13, 10, 1, 85.10),
(8, 18, 23, 1, 103.64),
(9, 18, 19, 2, 112.65),
(10, 17, 4, 1, 105.62),
(11, 5, 16, 1, 29.43),
(12, 15, 24, 1, 130.54),
(13, 9, 5, 1, 21.92),
(14, 20, 27, 2, 140.58),
(15, 11, 5, 1, 139.86),
(16, 14, 10, 1, 44.58),
(17, 19, 24, 1, 134.18),
(18, 13, 12, 1, 118.12),
(19, 2, 9, 1, 51.15),
(20, 18, 7, 1, 19.98),
(21, 7, 28, 2, 33.58),
(22, 10, 5, 1, 35.83),
(23, 3, 13, 1, 125.09),
(24, 14, 24, 1, 115.32),
(25, 1, 10, 2, 96.41),
(26, 8, 15, 1, 33.95),
(27, 10, 10, 1, 117.76),
(28, 2, 24, 1, 146.98),
(29, 15, 8, 1, 129.72),
(30, 12, 10, 1, 132.54);

-- Set all rooms to available
UPDATE Rooms SET Availability = 1;
-- Set all rooms to unavailable
UPDATE Rooms SET Availability = 0;

-- Set rooms to unavailable if a patient have no DateOut
UPDATE Rooms
SET Availability = 0
WHERE Room_Num IN 
(
    SELECT Room_Num
    FROM AdmissionStay
    WHERE DateOut IS NULL
);

--Set rooms to available
UPDATE Rooms
SET Availability = 1
WHERE Room_Num NOT IN (
    SELECT Room_Num
    FROM AdmissionStay
    WHERE DateOut IS NULL
);

-- 1. List all patients who visited a specific doctor
SELECT DISTINCT P.P_ID, P.P_Name         -- Select unique patient ID and name
FROM AppointmentsLink A                  -- From appointment records
JOIN Patients P ON A.P_ID = P.P_ID       -- Join to get patient details
WHERE A.D_ID = 6;                        -- Filter for doctor with ID 6 (change as needed)

-- 2. Count of appointments per department
SELECT D.De_Name, COUNT(*) AS AppointmentCount   -- Show department name and total appointments
FROM AppointmentsLink A                          -- From appointment records
JOIN Doctors Doc ON A.D_ID = Doc.D_ID            -- Link to doctors
JOIN Departments D ON Doc.De_ID = D.De_ID        -- Link doctors to departments
GROUP BY D.De_Name;                              -- Group by department to count per dept

-- 3. Doctors who have more than 5 appointments in 7/2025
SELECT D.D_ID, D.D_Name, COUNT(*) AS TotalAppointments  -- Show doctor ID, name, and total appts
FROM AppointmentsLink A                                 -- From appointment records
JOIN Doctors D ON A.D_ID = D.D_ID                       -- Link to doctors
WHERE MONTH(A.Ap_DateTime) = 7                          -- Filter for June (month = 7)
  AND YEAR(A.Ap_DateTime) = 2025                        -- And year 2025
GROUP BY D.D_ID, D.D_Name                               -- Group by doctor
HAVING COUNT(*) > 5;                                    -- Only show doctors with more than 5 appts

-- 4. List appointments with patient, doctor, department
SELECT P.P_Name, D.D_Name, Dept.De_Name, A.Ap_DateTime  -- Show patient, doctor, dept, and date
FROM AppointmentsLink A                                 -- From appointments
JOIN Patients P ON A.P_ID = P.P_ID                      -- Join patients
JOIN Doctors D ON A.D_ID = D.D_ID                       -- Join doctors
JOIN Departments Dept ON D.De_ID = Dept.De_ID;          -- Join departments

-- 5. Appointments grouped by department and doctor, using HAVING
SELECT Dept.De_Name, D.D_Name, COUNT(*) AS AppointmentCount  -- Show dept, doctor, count
FROM AppointmentsLink A                                      -- From appointments
JOIN Doctors D ON A.D_ID = D.D_ID                            -- Join doctors
JOIN Departments Dept ON D.De_ID = Dept.De_ID                -- Join departments
GROUP BY Dept.De_Name, D.D_Name                              -- Group by dept and doctor
HAVING COUNT(*) > 1;                                         -- Only include where count > 1

-- 6. List doctors who have at least one appointment
SELECT D.D_ID, D.D_Name   -- Show doctor ID and name
FROM Doctors D    -- From doctors table
WHERE EXISTS (SELECT 1 FROM AppointmentsLink A WHERE A.D_ID = D.D_ID); -- Subquery returns 1 if any appointment exists
GO

-- 1. Scalar Function: Calculate age from DOB
CREATE FUNCTION fn_GetPatientAge (@DOB DATE)  -- Create a scalar function that accepts a date input (DOB)
RETURNS INT                                   -- It will return an integer (the calculated age)
AS
BEGIN
RETURN DATEDIFF(YEAR, @DOB, GETDATE()) -       -- Get the difference in years between DOB and today
CASE                                           -- Subtract 1 if the birthday hasn't occurred yet this year
WHEN MONTH(@DOB) > MONTH(GETDATE())            -- If birth month is after the current month
OR (MONTH(@DOB) = MONTH(GETDATE())             -- OR birth month is the same but...
AND DAY(@DOB) > DAY(GETDATE()))                -- the birth day is still ahead
THEN 1                                         -- Then subtract 1 (birthday not yet passed)
ELSE 0                                         -- Otherwise, keep the full year difference
END;
END;
GO  -- Mark the end of the function for SQL Server


-- 2. Stored Procedure: Admit a patient and Update room occupied
CREATE PROCEDURE sp_AdmitPatient
    @P_ID INT,         -- Patient ID
    @Room_Num INT,     -- Room number to admit patient into
    @DateIn DATE       -- Date of admission
AS
BEGIN
IF EXISTS (SELECT 1 FROM Rooms WHERE Room_Num = @Room_Num AND Availability = 1)     --Check if room is available (Availability = 1)
BEGIN
-- Insert into AdmissionStay table
INSERT INTO AdmissionStay (P_ID, Room_Num, DateIn)
VALUES (@P_ID, @Room_Num, @DateIn);

-- Update room availability to 0 (occupied)
UPDATE Rooms
SET Availability = 0
 WHERE Room_Num = @Room_Num;
END
ELSE
BEGIN
RAISERROR ('Room is already occupied or does not exist.', 16, 1); -- If the room is not available, raise an error
END
END;
GO


-- 3- Stored Procedure: Generate billing invoice from BillingDetails table

-- Generate an invoice for a patient based on the billing details as treatments
CREATE OR ALTER PROCEDURE sp_GenerateInvoiceFromTreatments
    @P_ID INT,        -- Patient ID
    @B_ID INT,        -- Billing ID
    @BillDate DATE    -- Billing Date
AS
BEGIN
--Calculate total cost from BillingDetails for this Billing ID
DECLARE @TotalCost DECIMAL(10,2);

SELECT @TotalCost = SUM(Quantity * Unit_Cost)
FROM BillingDetails
WHERE B_ID = @B_ID;

-- If there's no matching services, raise an error
IF @TotalCost IS NULL
BEGIN
RAISERROR('No billing details found for this Billing ID.', 16, 1);
RETURN;
END
-- Insert or update the Billing record
IF NOT EXISTS (SELECT 1 FROM Billing WHERE B_ID = @B_ID)
BEGIN
-- Insert new billing record
INSERT INTO Billing (B_ID, P_ID, Date, TotalCost)
VALUES (@B_ID, @P_ID, @BillDate, @TotalCost);
END
ELSE
BEGIN
-- Update existing billing record (optional behavior)
UPDATE Billing
SET TotalCost = @TotalCost,
Date = @BillDate,
P_ID = @P_ID
WHERE B_ID = @B_ID;
END
END;
GO


-- 4. Stored Procedure: Assign a doctor to a department and shift
CREATE PROCEDURE sp_AssignDoctorToDepartmentAndShift
    @D_ID INT,         -- Doctor ID
    @De_ID INT,        -- New Department ID
    @Shift VARCHAR(50) -- New Shift: 'Day', 'Night', etc.
AS
BEGIN
UPDATE Doctors
SET De_ID = @De_ID,
Shift = @Shift
WHERE D_ID = @D_ID;
END;
GO






-- test the Stored Procedure codeing 

-- 1- Calculate age from DOB
SELECT P_ID, P_Name, P_DOB, dbo.fn_GetPatientAge(P_DOB) AS Age
FROM Patients;

-- 2- Admit a patient and Update room occupied

SELECT * FROM Rooms WHERE Room_Num = 108; -- If it is unavailable (Availability = 0)
-- it show result like this (Room is already occupied or does not exist).

SELECT * FROM Rooms WHERE Room_Num = 120; -- Must be available (Availability = 1) ( if you want to test do in number room 122)

-- For call Stored Procedure
EXEC sp_AdmitPatient 
    @P_ID = 1, 
    @Room_Num = 120, 
    @DateIn = '2025-06-24';

SELECT * FROM AdmissionStay WHERE P_ID = 1;
SELECT * FROM Rooms WHERE Room_Num = 120; -- Should now show Availability = 0

-- 3- Generate billing invoice from BillingDetails table

-- Insert billing for B_ID = 100
INSERT INTO Billing (B_ID, P_ID, Date, TotalCost)
VALUES (100, 1, '2025-06-24', 0.00);

-- Insert example billing detail for B_ID = 100
INSERT INTO BillingDetails (B_ID, Service_ID, Performed_By, Quantity, Unit_Cost)
VALUES (100, 3, 5, 2, 45.50); 

EXEC sp_GenerateInvoiceFromTreatments
    @P_ID = 1,
    @B_ID = 100,
    @BillDate = '2025-06-24';

SELECT B.B_ID, B.P_ID, B.Date, S.Service_Name, BD.Quantity, BD.Unit_Cost, (BD.Quantity * BD.Unit_Cost) AS LineTotal, B.TotalCost
FROM Billing B
JOIN BillingDetails BD ON B.B_ID = BD.B_ID
JOIN Services S ON BD.Service_ID = S.Service_ID
WHERE B.B_ID = 100;


-- 4. Assign a doctor to a department and shift

SELECT * FROM Doctors WHERE D_ID = 17; -- Confirm this doctor has a valid S_ID

EXEC sp_AssignDoctorToDepartmentAndShift 
    @D_ID = 17,
    @De_ID = 18,
    @Shift = 'Evening';

SELECT * FROM Doctors WHERE D_ID = 17;
GO


-- 1. Trigger: AFTER INSERT on AppointmentsLink → Auto insert into MedicalRecords

CREATE TRIGGER trg_AfterAppointment_Insert
ON AppointmentsLink
AFTER INSERT
AS
BEGIN
-- Insert a medical record using data from the newly inserted appointment
INSERT INTO MedicalRecords (MR_ID, P_ID, D_ID, Date, Diagnosis)
SELECT 
-- Generate new unique MR_ID by incrementing max existing ID
(SELECT ISNULL(MAX(MR_ID), 0) + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) 
FROM MedicalRecords) AS MR_ID,
i.P_ID, -- Patient ID from inserted row
i.D_ID, -- Doctor ID from inserted row
CAST(i.Ap_DateTime AS DATE), -- Use appointment date for the record
'Auto-generated from appointment' -- Default placeholder diagnosis
FROM inserted i; -- Use 'inserted' pseudo-table for trigger context
END;
GO

-- 2. Trigger: INSTEAD OF DELETE on Patients → Block if patient has billing

CREATE TRIGGER trg_BlockPatientDeleteIfBillsExist
ON Patients
INSTEAD OF DELETE
AS
BEGIN
-- Check if any of the patients to be deleted have related billing records
IF EXISTS (SELECT 1 FROM Billing B JOIN deleted d ON B.P_ID = d.P_ID)
BEGIN
-- Raise an error and stop the deletion
RAISERROR('Cannot delete patient: pending billing records exist.', 16, 1);
ROLLBACK TRANSACTION;
END
ELSE
BEGIN
-- Proceed to delete the patient if no billing exists
DELETE FROM Patients
WHERE P_ID IN (SELECT P_ID FROM deleted);
END
END;
GO

-- Trigger 3: AFTER UPDATE on Rooms → Ensure no two patients occupy the same room

CREATE TRIGGER trg_EnsureRoomUniqueness
ON AdmissionStay
AFTER INSERT, UPDATE
AS
BEGIN
    -- Check only the room(s) being inserted/updated
    IF EXISTS (
        SELECT Room_Num
        FROM AdmissionStay
        WHERE DateOut IS NULL
          AND Room_Num IN (SELECT Room_Num FROM inserted)
        GROUP BY Room_Num
        HAVING COUNT(*) > 1
    )
    BEGIN
        RAISERROR('Room conflict: multiple patients cannot occupy the same room at the same time.', 16, 1);
        ROLLBACK;
    END
END;
GO



-- Test Triggers

-- (1)
INSERT INTO AppointmentsLink (P_ID, D_ID, Ap_DateTime)
VALUES (1, 3, GETDATE());  -- or use a specific future datetime

SELECT * 
FROM MedicalRecords 
WHERE P_ID = 1 AND D_ID = 3 
ORDER BY MR_ID DESC;

-- (2)

-- Patient 1 has billing (from your DB data)
DELETE FROM Patients WHERE P_ID = 1;

-- Add test patient (no billing)
INSERT INTO Patients (P_ID, P_Name, P_Gender, P_DOB, P_Contact_Info)
VALUES (999, 'Test Patient', 'Male', '1990-01-01', '000000000');

-- Delete it 
DELETE FROM Patients WHERE P_ID = 999;

-- Verify it
SELECT * FROM Patients WHERE P_ID = 999;

-- (3)
-- Test on room 130
INSERT INTO AdmissionStay (P_ID, Room_Num, DateIn)
VALUES (1, 130, '2025-06-24'); 

-- this show room conflict 
INSERT INTO AdmissionStay (P_ID, Room_Num, DateIn)
VALUES (2, 130, '2025-06-25');



-- DCL: Security 

-- 1. Create two roles: DoctorUser and AdminUser

CREATE ROLE DoctorUser; -- read-only for doctors
CREATE ROLE AdminUser; -- insert and update access for admins

-- 2. Grant SELECT permissions to DoctorUser

-- This allows doctors to view data from key tables
GRANT SELECT ON Patients TO DoctorUser;
GRANT SELECT ON AppointmentsLink TO DoctorUser;

-- 3. Grant INSERT and UPDATE permissions to AdminUser on all tables

-- Safely close existing cursor if it already exists
IF CURSOR_STATUS('global', 'table_cursor') >= -1
BEGIN
    CLOSE table_cursor;
    DEALLOCATE table_cursor;
END
-- Declare a variable to store table names
DECLARE @TableName NVARCHAR(128);
-- Declare a cursor to loop through all user tables
DECLARE table_cursor CURSOR FOR
SELECT name FROM sys.tables WHERE type = 'U';  -- 'U' = user-defined table
-- Open the cursor
OPEN table_cursor;
FETCH NEXT FROM table_cursor INTO @TableName;
-- Loop through tables and grant permissions
WHILE @@FETCH_STATUS = 0
BEGIN
-- Dynamically build and execute GRANT statement for AdminUser
EXEC('GRANT INSERT, UPDATE ON [' + @TableName + '] TO AdminUser');
-- Move to next table
FETCH NEXT FROM table_cursor INTO @TableName;
END
-- Close and clean up the cursor
CLOSE table_cursor;
DEALLOCATE table_cursor;

-- 4. Revoke DELETE permission on Doctors table from AdminUser

-- This ensures doctor records cannot be deleted accidentally
REVOKE DELETE ON Doctors FROM AdminUser;

-- Test DCL

-- (1)
-- Create SQL Server logins 
CREATE LOGIN DoctorTestLogin WITH PASSWORD = 'Dr@12345';
CREATE LOGIN AdminTestLogin  WITH PASSWORD = 'Adm@12345';

-- Create two test users
CREATE USER DoctorTest FOR LOGIN DoctorTestLogin;
CREATE USER AdminTest FOR LOGIN AdminTestLogin;

-- Assign roles
EXEC sp_addrolemember 'DoctorUser', 'DoctorTest';
EXEC sp_addrolemember 'AdminUser', 'AdminTest';

-- (2)

-- As DoctorTest user:
EXECUTE AS USER = 'DoctorTest';

-- it should return data
SELECT TOP 1 * FROM Patients;
SELECT TOP 1 * FROM AppointmentsLink;

-- it Should Fail
INSERT INTO Patients (P_ID, P_Name, P_Gender, P_DOB, P_Contact_Info)
VALUES (999, 'Blocked Patient', 'Male', '1990-01-01', '0000');

REVERT;  -- End impersonation

-- (3)

-- As AdminTest user:
EXECUTE AS USER = 'AdminTest';

-- Try inserting into Doctors (should succeed)
INSERT INTO Doctors (D_ID, D_Name, D_Gender, D_Specialization, D_Contact_Info, De_ID, ManagedBy, Shift)
VALUES (999, 'Test Admin Doctor', 'Male', 'Testing', 'test@hospital.om', 1, 1, 'Day');

REVERT; --FOR REVERT

-- Try updating a patient
UPDATE Patients SET P_Contact_Info = 'new@email.com' WHERE P_ID = 1;

REVERT; --FOR REVERT

-- (4)

-- As AdminTest user:
EXECUTE AS USER = 'AdminTest';

-- This should FAIL
DELETE FROM Doctors WHERE D_ID = 999;

REVERT;

-- TCL 1: Admit a Patient and Generate Billing

BEGIN TRANSACTION; -- Start transaction
BEGIN TRY
INSERT INTO Patients (P_ID, P_Name, P_Gender, P_DOB, P_Contact_Info) -- Add a new patient
VALUES (101, 'Mohammed Al-Mamari', 'Male', '1995-04-10', 'mohammed@om');

INSERT INTO AdmissionStay (P_ID, Room_Num, DateIn) -- Register their room admission
VALUES (101, 130, GETDATE());

UPDATE Rooms SET Availability = 1 WHERE Room_Num = 130;  -- Mark room as occupied (Availability = 1)

INSERT INTO Billing (B_ID, P_ID, TotalCost, Date)  -- Generate billing record
VALUES (501, 101, 80.000, GETDATE());

COMMIT;   -- Commit all if successful
PRINT 'Admission and billing committed.';
END TRY
BEGIN CATCH

ROLLBACK;    -- Rollback if any step fails
PRINT 'Failed. Rolled back.';
PRINT ERROR_MESSAGE(); -- Show the error
END CATCH;


-- TCL 2: Update Patient Contact Info

BEGIN TRANSACTION;
BEGIN TRY

UPDATE Patients -- Update the patient's email/contact info
SET P_Contact_Info = 'updated@email.om'
WHERE P_ID = 101;

PRINT 'Contact info updated by user: ' + SYSTEM_USER;  -- Show which user did the update

COMMIT;  -- Commit the update
PRINT 'Contact update committed.';
END TRY
BEGIN CATCH

ROLLBACK; -- Rollback on error
PRINT 'Failed. Rolled back.';
PRINT ERROR_MESSAGE();
END CATCH;

-- TCL 3: Book Multiple Appointments 

BEGIN TRANSACTION;
BEGIN TRY

INSERT INTO AppointmentsLink (P_ID, D_ID, Ap_DateTime) -- Book first appointment
VALUES (101, 3, '2025-06-26 09:00');

INSERT INTO AppointmentsLink (P_ID, D_ID, Ap_DateTime) -- Book second appointment
VALUES (101, 5, '2025-06-26 11:00');

COMMIT;   -- Commit both bookings
PRINT 'Appointments booked.';
END TRY
BEGIN CATCH

ROLLBACK; -- Cancel both if one fails
PRINT 'Failed. Rolled back.';
PRINT ERROR_MESSAGE();
END CATCH;


-- TCL 4: Discharge Patient and Update Room

BEGIN TRANSACTION;
BEGIN TRY

UPDATE AdmissionStay -- Set discharge date
SET DateOut = GETDATE()
WHERE P_ID = 101 AND DateOut IS NULL;

UPDATE Rooms  -- Mark the room as available
SET Availability = 0
WHERE Room_Num = 130;

COMMIT; -- Commit changes
PRINT 'Patient discharged and room freed.';
END TRY
BEGIN CATCH

ROLLBACK; -- Rollback if either step fails
PRINT 'Failed. Rolled back.';
PRINT ERROR_MESSAGE();
END CATCH;

-- TCL 5: Cancel Overcharged Billing

BEGIN TRANSACTION;
BEGIN TRY

DELETE FROM Billing  -- Delete billing if amount is over 500
WHERE B_ID = 501 AND TotalCost > 500;

PRINT 'Billing above 500 removed by ' + SYSTEM_USER;  -- Show who removed the billing

COMMIT;  -- Commit deletion
PRINT 'Billing removed.';
END TRY
BEGIN CATCH

ROLLBACK;   -- Undo delete if error occurs
PRINT 'Failed. Rolled back.';
PRINT ERROR_MESSAGE();
END CATCH;
GO

-- Views

CREATE VIEW vw_DoctorSchedule 
AS
SELECT d.D_ID, d.D_Name, a.P_ID, p.P_Name, a.Ap_DateTime
FROM AppointmentsLink a -- From appointment table
JOIN Doctors d ON a.D_ID = d.D_ID   -- Match with doctors
JOIN Patients p ON a.P_ID = p.P_ID -- Match with patients
WHERE a.Ap_DateTime > GETDATE();  -- Only future appointments
Go




CREATE VIEW vw_PatientSummary AS
SELECT p.P_ID, p.P_Name, p.P_Gender, p.P_DOB, p.P_Contact_Info, MAX(a.Ap_DateTime) AS LatestVisit  
FROM Patients p
LEFT JOIN AppointmentsLink a ON p.P_ID = a.P_ID  -- Match appointments if available
GROUP BY p.P_ID, p.P_Name, p.P_Gender, p.P_DOB, p.P_Contact_Info; -- Group by patient
GO

CREATE VIEW vw_DepartmentStats AS
SELECT dept.De_ID, dept.De_Name, COUNT(DISTINCT doc.D_ID) AS TotalDoctors, COUNT(DISTINCT a.P_ID) AS TotalPatients     
FROM Departments dept
LEFT JOIN Doctors doc ON dept.De_ID = doc.De_ID        -- Link doctors to departments
LEFT JOIN AppointmentsLink a ON doc.D_ID = a.D_ID      -- Link patients via appointments to doctors
GROUP BY dept.De_ID, dept.De_Name;                     -- Group per department
GO

-- For Display the Views
SELECT * FROM vw_DoctorSchedule;

SELECT * FROM vw_PatientSummary;

SELECT * FROM vw_DepartmentStats;

-- SQL Job Agent

-- Daily Backup Job 
EXEC msdb.dbo.sp_delete_job  
    @job_name = N'Daily_HospitalDB_Backup';

-- Create the backup job
EXEC msdb.dbo.sp_add_job  
    @job_name = N'Daily_HospitalDB_Backup',  
    @enabled = 1,  
    @description = N'Daily backup of HospitalProject DB to default MSSQL backup folder.',  
    @category_name = N'[Uncategorized (Local)]';

-- Add job step: perform the backup to specified path
EXEC msdb.dbo.sp_add_jobstep  
    @job_name = N'Daily_HospitalDB_Backup',
    @step_name = N'Backup Hospital DB',
    @subsystem = N'TSQL',
    @command = N'
        BACKUP DATABASE HospitalProject
        TO DISK = ''C:\Backup\HospitalProject_Test.bak'' + 
                  CONVERT(VARCHAR(10), GETDATE(), 120) + ''.bak''
        WITH INIT, FORMAT;',
    @on_success_action = 1;

-- Create schedule to run daily at 12:00 AM
EXEC msdb.dbo.sp_add_schedule  
    @schedule_name = N'Daily_12AM_Backup_Schedule',  
    @freq_type = 4,               -- Daily
    @freq_interval = 1,          -- Every day
    @active_start_time = 120000; -- 11:00 AM

-- Attach schedule to the job
EXEC msdb.dbo.sp_attach_schedule  
    @job_name = N'Daily_HospitalDB_Backup',  
    @schedule_name = N'Daily_12AM_Backup_Schedule';

-- Register job with SQL Server Agent
EXEC msdb.dbo.sp_add_jobserver  
    @job_name = N'Daily_HospitalDB_Backup',
    @server_name = @@SERVERNAME;

--  Doctor Schedule Report

-- Create a table to log the daily doctor schedule
CREATE TABLE DoctorDailyScheduleLog 
(
    LogID INT IDENTITY(1,1) PRIMARY KEY,       -- Auto-increment log ID
    D_ID INT,                                  -- Doctor ID
    D_Name NVARCHAR(100),                      -- Doctor Name
    P_ID INT,                                  -- Patient ID
    P_Name NVARCHAR(100),                      -- Patient Name
    Ap_DateTime DATETIME,                      -- Appointment DateTime
    LoggedAt DATETIME DEFAULT GETDATE()        -- Timestamp when the log was recorded
);
GO

-- Create a stored procedure that logs today's appointments
CREATE PROCEDURE sp_LogDoctorSchedule
AS
BEGIN
-- Insert today appointments into the log table
INSERT INTO DoctorDailyScheduleLog (D_ID, D_Name, P_ID, P_Name, Ap_DateTime)
SELECT d.D_ID, d.D_Name, p.P_ID, p.P_Name, a.Ap_DateTime                         
FROM AppointmentsLink a
JOIN Doctors d ON a.D_ID = d.D_ID          -- Join to get doctor info
JOIN Patients p ON a.P_ID = p.P_ID         -- Join to get patient info
WHERE CAST(a.Ap_DateTime AS DATE) = CAST(GETDATE() AS DATE);  -- Only for today appointments
END;
GO

-- Create the SQL Agent Job to automate the procedure
EXEC msdb.dbo.sp_add_job  
    @job_name = N'Doctor_Daily_Schedule_Report',       -- Job name (N is related for Unicode String)
    @enabled = 1,                                      -- Enable the job
    @description = N'Logs daily doctor appointment schedule.';  -- Job description
GO

-- Add step to the job that calls the procedure
EXEC msdb.dbo.sp_add_jobstep  
    @job_name = N'Doctor_Daily_Schedule_Report',       -- Job name
    @step_name = N'Run sp_LogDoctorSchedule',          -- Step name
    @subsystem = N'TSQL',                              -- Type of command
    @command = N'EXEC sp_LogDoctorSchedule',           -- Command to run
    @database_name = N'HospitalProject';               -- Database
GO

-- Create a daily schedule that runs at 07:00 AM
EXEC msdb.dbo.sp_add_schedule  
    @schedule_name = N'Daily_11AM_Schedule',           -- Schedule name
    @freq_type = 4,                                    -- Frequency type: daily
    @freq_interval = 1,                                -- Every day
    @active_start_time = 070000;                       -- Start time: 11:00 AM
GO

-- Attach the schedule to the job
EXEC msdb.dbo.sp_attach_schedule  
    @job_name = N'Doctor_Daily_Schedule_Report',       -- Job name 
    @schedule_name = N'Daily_7AM_Schedule';            -- Schedule name
GO

-- Register the job with the SQL Server Agent
EXEC msdb.dbo.sp_add_jobserver  
    @job_name = N'Doctor_Daily_Schedule_Report',       -- Job name
    @server_name = @@SERVERNAME;                       -- Automatically fetch local server name
GO

-- For Verify the SQL Job Work

-- Run the job for testing
EXEC msdb.dbo.sp_start_job N'Daily_HospitalDB_Backup';


-- Run the procedure manually
EXEC sp_LogDoctorSchedule;

-- Check log entries
SELECT * FROM DoctorDailyScheduleLog
WHERE CAST(LoggedAt AS DATE) = CAST(GETDATE() AS DATE);

-- Check if log was inserted
SELECT TOP 5 * FROM DoctorDailyScheduleLog ORDER BY LoggedAt DESC;
GO

-- Bouns Task

-- Alert Email + Export Billing via Agent

-- 1. Create Procedure: Alert if any doctor has >10 appointments today

CREATE PROCEDURE sp_AlertDoctorsOverload
AS
BEGIN
    SET NOCOUNT ON; -- Avoid extra results from interfering with procedure results
    IF EXISTS (
        SELECT D_ID
        FROM AppointmentsLink
        WHERE CAST(Ap_DateTime AS DATE) = CAST(GETDATE() AS DATE)
        GROUP BY D_ID
        HAVING COUNT(*) > 10 -- Check for doctors with more than 10 appointments
    )
    BEGIN
        EXEC msdb.dbo.sp_send_dbmail  -- Use Database Mail to send an email
            @profile_name = 'HospitalMailProfile',  -- Configured mail profile
            @recipients = 'ahmed.b@hospital.om',   -- Email Doctor
            @subject = 'Doctor Appointment Overload', -- Subject of the email
            @body = 'One or more doctors have over 10 appointments today.'; -- Message body
    END
END;
GO

-- SQL Agent Job 1: Email Alert
EXEC msdb.dbo.sp_delete_job  -- Remove the job if exists to avoid duplicate job names
    @job_name = N'Doctor_Overload_Email_Alert';


EXEC sp_configure 'show advanced options', 1; -- Enable advanced configuration options
RECONFIGURE;
EXEC sp_configure 'Database Mail XPs', 1; -- Enable Database Mail extended stored procedures needed for sp_send_dbmail
RECONFIGURE;

EXEC msdb.dbo.sp_add_job   -- Create new SQL Agent job
    @job_name = N'Doctor_Overload_Email_Alert';

EXEC msdb.dbo.sp_add_jobstep  -- Add step to this job that runs the procedure
    @job_name = N'Doctor_Overload_Email_Alert', 
    @step_name = N'Send Overload Email',
    @subsystem = N'TSQL', -- The step runs a T-SQL (Transact-SQL) command
    @command = N'EXEC sp_AlertDoctorsOverload'; -- The procedure to execute

EXEC msdb.dbo.sp_add_schedule  -- Schedule the job to run daily at 11:30 AM
    @schedule_name = N'Daily_11:30AM_Email_Alert',
    @freq_type = 4,   -- 4 = Daily
    @freq_interval = 1,    -- Every day
    @active_start_time = 113000;  -- Time in HHMMSS (11:30 AM)

EXEC msdb.dbo.sp_attach_schedule   -- Attach the schedule to the job
    @job_name = N'Doctor_Overload_Email_Alert',
    @schedule_name = N'Daily_11:30AM_Email_Alert';

EXEC msdb.dbo.sp_add_jobserver   -- Register the job with the SQL Server Agent
    @job_name = N'Doctor_Overload_Email_Alert',  
    @server_name = @@SERVERNAME; -- Automatically get the current server name



-- SQL Agent Job 2: Weekly Billing Export

EXEC msdb.dbo.sp_add_job   -- Create new job that export billing data weekly
    @job_name = N'Weekly_Billing_Export_CSV';

EXEC msdb.dbo.sp_add_jobstep   -- Add step that runs command-line BCP(bulk copy) export to CSV (bcp exports the entire Billing table to .csv file)
    @job_name = N'Weekly_Billing_Export_CSV',
    @step_name = N'Export Billing Data',
    @subsystem = N'CmdExec', -- This runs a system command (not T-SQL)
    @command = N'bcp "SELECT * FROM HospitalProject.dbo.Billing" queryout "C:\Exports\BillingSummary.csv" -c -t, -T -S DESKTOP-35G8EDD'; -- -c: character format-t,: comma -T: trusted connection -S: your server name

EXEC msdb.dbo.sp_add_schedule  -- Create weekly schedule for Sunday 8:00 PM
    @schedule_name = N'Weekly_Export_Sunday_8PM',
    @freq_type = 8, -- Weekly
    @freq_interval = 1, -- Every Sunday
	@freq_recurrence_factor = 1,  -- Every week
    @active_start_time = 200000,  -- 8:00 PM
    @active_start_date = 20250624   -- Job starts on this date


EXEC msdb.dbo.sp_attach_schedule   -- Attach the schedule to the export job
    @job_name = N'Weekly_Billing_Export_CSV',
    @schedule_name = N'Weekly_Export_Sunday_8PM';

EXEC msdb.dbo.sp_add_jobserver  -- Register the export job with the SQL Server Agent 
    @job_name = N'Weekly_Billing_Export_CSV',
    @server_name = @@SERVERNAME;



-- Testing Bouns Task

-- Insert 11 unique appointments for Doctor 3 and Patient 1 in 1-minute apart
DECLARE @i INT = 1;
WHILE @i <= 11
BEGIN
    INSERT INTO AppointmentsLink (P_ID, D_ID, Ap_DateTime)
    VALUES (1, 3, DATEADD(MINUTE, @i, GETDATE()));  -- Each minute adds a new appointment
    
    SET @i = @i + 1;
END

-- Manually start the email alert job for testing
EXEC msdb.dbo.sp_start_job @job_name = 'Doctor_Overload_Email_Alert';

-- Manually start the export job for testing
EXEC msdb.dbo.sp_start_job @job_name = 'Weekly_Billing_Export_CSV';

-- View job execution history for the email alert job
EXEC msdb.dbo.sp_help_jobhistory 
    @job_name = 'Doctor_Overload_Email_Alert';  
