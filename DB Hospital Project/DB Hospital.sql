CREATE TABLE Patients
(
    P_ID INT PRIMARY KEY,
    P_Name VARCHAR(100) NOT NULL,
    P_Gender VARCHAR(10) CHECK (P_Gender IN ('Male', 'Female', 'Other')),
    P_DOB DATE NOT NULL,
    P_Contact_Info VARCHAR(100)
);

CREATE TABLE Departments
(
    De_ID INT PRIMARY KEY,
    De_Name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Doctors 
(
    D_ID INT PRIMARY KEY,
    D_Name VARCHAR(100) NOT NULL,
    D_Gender VARCHAR(10) CHECK (D_Gender IN ('Male', 'Female', 'Other')),
    D_Specialization VARCHAR(100),
    D_Contact_Info VARCHAR(100),
    De_ID INT NOT NULL,
    FOREIGN KEY (De_ID) REFERENCES Departments(De_ID)
);

CREATE TABLE Staff 
(
    S_ID INT PRIMARY KEY,
    S_Name VARCHAR(100) NOT NULL,
    Role VARCHAR(50) CHECK (Role IN ('Nurse', 'Admin', 'Technician', 'Receptionist')),
    Shift VARCHAR(50) DEFAULT 'Day',
    De_ID INT NOT NULL,
    FOREIGN KEY (De_ID) REFERENCES Departments(De_ID)
);

CREATE TABLE Users 
(
    UserName VARCHAR(50) PRIMARY KEY,
    Password VARCHAR(100) NOT NULL,
    Role VARCHAR(50) CHECK (Role IN ('AdminUser', 'DoctorUser', 'StaffUser')),
    S_ID INT UNIQUE NOT NULL,
    FOREIGN KEY (S_ID) REFERENCES Staff(S_ID)
);

CREATE TABLE Rooms
(
    Room_Num INT PRIMARY KEY,
    R_Type VARCHAR(50) CHECK (R_Type IN ('ICU', 'General', 'Private')),
    Availability BIT DEFAULT 1
);

CREATE TABLE AdmissionStay 
(
    Admission_ID INT PRIMARY KEY,
    P_ID INT NOT NULL,
    Room_Num INT NOT NULL,
    DateIn DATE NOT NULL,
    DateOut DATE,
    FOREIGN KEY (P_ID) REFERENCES Patients(P_ID),
    FOREIGN KEY (Room_Num) REFERENCES Rooms(Room_Num)
);

CREATE TABLE MedicalRecords 
(
    MR_ID INT PRIMARY KEY,
    P_ID INT NOT NULL,
    D_ID INT NOT NULL,
    Date DATE NOT NULL,
    Treatment_Plans TEXT,
    Notes TEXT,
    Diagnosis TEXT NOT NULL,
    FOREIGN KEY (P_ID) REFERENCES Patients(P_ID),
    FOREIGN KEY (D_ID) REFERENCES Doctors(D_ID)
);

CREATE TABLE Billing 
(
    B_ID INT PRIMARY KEY,
    P_ID INT NOT NULL,
    Date DATE NOT NULL,
    TotalCost DECIMAL(10,2) NOT NULL CHECK (TotalCost >= 0),
    FOREIGN KEY (P_ID) REFERENCES Patients(P_ID)
);

CREATE TABLE Services
(
    Service_ID INT PRIMARY KEY,
    Service_Name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE BillingDetails 
(
    BillingDetail_ID INT PRIMARY KEY,
    B_ID INT NOT NULL,
    Service_ID INT NOT NULL,
    Performed_By INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Unit_Cost DECIMAL(10,2) NOT NULL CHECK (Unit_Cost >= 0),
    FOREIGN KEY (B_ID) REFERENCES Billing(B_ID),
    FOREIGN KEY (Service_ID) REFERENCES Services(Service_ID),
    FOREIGN KEY (Performed_By) REFERENCES Staff(S_ID)
);

CREATE TABLE AppointmentsLink 
(
    Appointment_ID INT PRIMARY KEY,
    P_ID INT NOT NULL,
    D_ID INT NOT NULL,
    Ap_DateTime DATETIME NOT NULL,
    FOREIGN KEY (P_ID) REFERENCES Patients(P_ID),
    FOREIGN KEY (D_ID) REFERENCES Doctors(D_ID)
);

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
   

-- Insert doctors with department assignment and contact info
INSERT INTO Doctors (D_ID, D_Name, D_Gender, D_Specialization, D_Contact_Info, De_ID) VALUES
(1, 'Dr. Salim Al Farsi', 'Male', 'Cardiologist', '933546086', 2),
(2, 'Dr. Layla Al Balushi', 'Female', 'Orthopedic Surgeon', '944198766', 3),
(3, 'Dr. Saeed Al Harthy', 'Male', 'General Physician', '975748605', 4),
(4, 'Dr. Hamad Al Harthy', 'Male', 'Pediatrician', '975996713', 5),
(5, 'Dr. Salim Al Hinai', 'Male', 'Neurologist', '991957805', 6),
(6, 'Dr. Layla Al Hinai', 'Female', 'Dermatologist', '972362701', 7),
(7, 'Dr. Mariam Al Harthy', 'Female', 'Emergency Physician', '936376701', 8),
(8, 'Dr. Raya Al Farsi', 'Female', 'ENT Specialist', '927188735', 9),
(9, 'Dr. Yusuf Al Habsi', 'Male', 'Radiologist', '993471230', 10),
(10, 'Dr. Fatma Al Hinai', 'Female', 'Oncologist', '961354357', 11),
(11, 'Dr. Salma Al Rawahi', 'Female', 'Psychiatrist', '948449767', 12),
(12, 'Dr. Fatma Al Rawahi', 'Female', 'Ophthalmologist', '928813039', 13),
(13, 'Dr. Khalid Al Harthy', 'Male', 'Nephrologist', '993803600', 14),
(14, 'Dr. Salim Al Shukaili', 'Male', 'Gastroenterologist', '997616828', 15),
(15, 'Dr. Saeed Al Farsi', 'Male', 'Urologist', '978254123', 16),
(16, 'Dr. Mariam Al Abri', 'Female', 'Gynecologist', '932038102', 17),
(17, 'Dr. Fatma Al Riyami', 'Female', 'Anesthesiologist', '961803299', 18),
(18, 'Dr. Hamad Al Harthy', 'Male', 'Pulmonologist', '940962833', 19),
(19, 'Dr. Ahmed Al Rawahi', 'Male', 'Endocrinologist', '983417610', 20),
(20, 'Dr. Shaima Al Hinai', 'Female', 'Family Medicine Specialist', '974318482', 1),
(21, 'Dr. Mariam Al Busaidi', 'Female', 'Cardiologist', '925839170', 2),
(22, 'Dr. Khalid Al Hinai', 'Male', 'Orthopedic Surgeon', '998346834', 3),
(23, 'Dr. Shaima Al Riyami', 'Female', 'General Physician', '976479034', 4),
(24, 'Dr. Raya Al Rawahi', 'Female', 'Pediatrician', '944699901', 5),
(25, 'Dr. Ahmed Al Farsi', 'Male', 'Neurologist', '939330829', 6),
(26, 'Dr. Talal Al Abri', 'Male', 'Dermatologist', '993984493', 7),
(27, 'Dr. Fatma Al Balushi', 'Female', 'Emergency Physician', '959763192', 8),
(28, 'Dr. Shaima Al Habsi', 'Female', 'ENT Specialist', '992276935', 9),
(29, 'Dr. Salma Al Hinai', 'Female', 'Radiologist', '925325377', 10),
(30, 'Dr. Fatma Al Farsi', 'Female', 'Oncologist', '932996143', 11);


-- Insert hospital staff (nurses, admin, technicians)
INSERT INTO Staff (S_ID, S_Name, Role, Shift, De_ID) VALUES
(1, 'Layla Al Hinai', 'Nurse', 'Day', 2),
(2, 'Fahad Al Rawahi', 'Admin', 'Day', 3),
(3, 'Sara Al Abri', 'Pharmacist', 'Night', 4),
(4, 'Shaima Al Farsi', 'Receptionist', 'Night', 5),
(5, 'Huda Al Hinai', 'Admin', 'Day', 6),
(6, 'Majid Al Hinai', 'Technician', 'Day', 7),
(7, 'Khalid Al Hinai', 'Receptionist', 'Day', 8),
(8, 'Majid Al Hinai', 'Receptionist', 'Day', 9),
(9, 'Aisha Al Habsi', 'Technician', 'Night', 10),
(10, 'Salim Al Rawahi', 'Receptionist', 'Night', 11),
(11, 'Fatma Al Rawahi', 'Receptionist', 'Day', 12),
(12, 'Huda Al Shukaili', 'Nurse', 'Day', 13),
(13, 'Nasser Al Balushi', 'Technician', 'Day', 14),
(14, 'Basma Al Balushi', 'Admin', 'Day', 15),
(15, 'Khalid Al Shukaili', 'Admin', 'Night', 16),
(16, 'Fatma Al Balushi', 'Admin', 'Night', 17),
(17, 'Sara Al Habsi', 'Nurse', 'Night', 18),
(18, 'Ahmed Al Busaidi', 'Pharmacist', 'Day', 19),
(19, 'Fahad Al Shukaili', 'Pharmacist', 'Night', 20),
(20, 'Huda Al Busaidi', 'Admin', 'Day', 1),
(21, 'Salma Al Balushi', 'Receptionist', 'Night', 2),
(22, 'Saeed Al Busaidi', 'Technician', 'Night', 3),
(23, 'Hamad Al Habsi', 'Nurse', 'Day', 4),
(24, 'Aisha Al Abri', 'Nurse', 'Day', 5),
(25, 'Huda Al Rawahi', 'Receptionist', 'Day', 6),
(26, 'Fatma Al Busaidi', 'Technician', 'Night', 7),
(27, 'Shaima Al Balushi', 'Technician', 'Day', 8),
(28, 'Basma Al Hinai', 'Nurse', 'Day', 9),
(29, 'Layla Al Riyami', 'Technician', 'Day', 10),
(30, 'Yusuf Al Balushi', 'Technician', 'Day', 11);

-- Create user accounts for each staff member
INSERT INTO Users (UserName, Password, Role, S_ID) VALUES
('kshukaili01', 'khalid@2025', 'AdminUser', 1),
('sriyami02', 'salim@2026', 'StaffUser', 2),
('srawahi03', 'salim@2027', 'StaffUser', 3),
('yhinai04', 'yusuf@2028', 'AdminUser', 4),
('fbalushi05', 'fahad@2029', 'AdminUser', 5),
('fshukaili06', 'fahad@2030', 'AdminUser', 6),
('lfarsi07', 'layla@2031', 'StaffUser', 7),
('habri08', 'hamad@2032', 'AdminUser', 8),
('shinai09', 'sara@2033', 'StaffUser', 9),
('mhinai10', 'majid@2034', 'StaffUser', 10),
('mbusaidi11', 'mariam@2035', 'AdminUser', 11),
('ashukaili12', 'ahmed@2036', 'AdminUser', 12),
('mabri13', 'majid@2037', 'AdminUser', 13),
('yhabsi14', 'yusuf@2038', 'AdminUser', 14),
('shinai15', 'salma@2039', 'StaffUser', 15),
('abusaidi16', 'ahmed@2040', 'AdminUser', 16),
('hbusaidi17', 'huda@2041', 'StaffUser', 17),
('sriyami18', 'shaima@2042', 'StaffUser', 18),
('shabsi19', 'sara@2043', 'StaffUser', 19),
('fhinai20', 'fatma@2044', 'AdminUser', 20),
('ashukaili21', 'aisha@2045', 'AdminUser', 21),
('mshukaili22', 'mariam@2046', 'AdminUser', 22),
('sbusaidi23', 'shaima@2047', 'StaffUser', 23),
('rhabsi24', 'raya@2048', 'StaffUser', 24),
('abalushi25', 'ahmed@2049', 'AdminUser', 25),
('hrawahi26', 'huda@2050', 'StaffUser', 26),
('hhinai27', 'hamad@2051', 'AdminUser', 27),
('thinai28', 'talal@2052', 'StaffUser', 28),
('srawahi29', 'shaima@2053', 'StaffUser', 29),
('bbalushi30', 'basma@2054', 'AdminUser', 30);

-- Insert hospital room details
INSERT INTO Rooms (Room_Num, R_Type, Availability) VALUES
(101, 'Isolation', 0),
(102, 'General', 1),
(103, 'General', 0),
(104, 'General', 1),
(105, 'VIP', 1),
(106, 'ICU', 1),
(107, 'Private', 1),
(108, 'ICU', 0),
(109, 'ICU', 1),
(110, 'Isolation', 1),
(111, 'General', 1),
(112, 'General', 0),
(113, 'General', 0),
(114, 'General', 1),
(115, 'VIP', 1),
(116, 'ICU', 1),
(117, 'Surgical', 1),
(118, 'Private', 1),
(119, 'General', 0),
(120, 'Isolation', 1),
(121, 'Private', 0),
(122, 'Private', 0),
(123, 'VIP', 1),
(124, 'VIP', 1),
(125, 'Surgical', 0),
(126, 'ICU', 0),
(127, 'General', 1),
(128, 'Isolation', 0),
(129, 'ICU', 1),
(130, 'Surgical', 1);


-- Track which patients are admitted in which rooms and when
INSERT INTO AdmissionStay (Admission_ID, P_ID, Room_Num, DateIn, DateOut) VALUES
(1, 1, 101, '2024-06-15', NULL),   
(2, 3, 104, '2024-06-20', NULL),   
(3, 5, 103, '2024-06-10', '2024-06-15'),
(4, 6, 105, '2024-06-22', NULL),
(5, 7, 106, '2024-06-23', NULL);

-- Scheduled appointments between patients and doctors
INSERT INTO AppointmentsLink (Appointment_ID, P_ID, D_ID, Ap_DateTime) VALUES
(1, 2, 2, '2024-07-01 10:00:00'),  
(2, 3, 3, '2024-06-25 09:30:00'),  
(3, 4, 1, '2024-06-28 14:00:00'),
(4, 5, 4, '2024-06-30 11:00:00'),
(5, 6, 5, '2024-07-02 08:30:00'),
(6, 7, 6, '2024-07-03 12:00:00'),
(7, 8, 4, '2024-07-04 09:15:00');

-- Medical records showing diagnosis and Treatment plan
INSERT INTO MedicalRecords (MR_ID, P_ID, D_ID, Date, Treatment_Plans, Notes, Diagnosis) VALUES
(1, 1, 1, '2024-06-16', 'Cardiac Monitoring', 'Stable condition', 'Heart Arrhythmia'),
(2, 3, 3, '2024-06-21', 'Emergency scan and IV', 'Discharged stable', 'Minor trauma'),
(3, 5, 4, '2024-06-15', 'Pediatric checkup and vaccines', 'Normal growth', 'Routine Checkup'),
(4, 6, 5, '2024-06-23', 'Blood pressure monitoring', 'Moderate hypertension', 'Hypertension Stage 1'),
(5, 7, 6, '2024-06-24', 'Appendectomy', 'Post-surgery stable', 'Appendicitis'),
(6, 8, 4, '2024-06-25', 'Child vaccine + general check', 'Mild fever', 'Routine Pediatric Care');

-- Billing summary Data
INSERT INTO Billing (B_ID, P_ID, Date, TotalCost) VALUES
(1, 1, '2024-06-16', 75.00),    
(2, 3, '2024-06-21', 120.00),
(3, 5, '2024-06-15', 60.00),
(4, 6, '2024-06-23', 90.00),
(5, 7, '2024-06-24', 250.00),
(6, 8, '2024-06-25', 50.00);

-- List of services available at the hospital
INSERT INTO Services (Service_ID, Service_Name) VALUES
(1, 'ECG'),
(2, 'X-Ray'),
(3, 'Blood Test'),
(4, 'Pediatric Vaccine'),
(5, 'Emergency Scan'),
(6, 'Blood Pressure Monitoring'),
(7, 'Appendectomy'),
(8, 'Child Health Check');

-- Billing details show what services were billed to which patient and who performed them
INSERT INTO BillingDetails (BillingDetail_ID, B_ID, Service_ID, Performed_By, Quantity, Unit_Cost) VALUES
(1, 1, 1, 1, 1, 25.00),    
(2, 1, 2, 1, 2, 50.00),
(3, 2, 5, 3, 1, 100.00),
(4, 2, 3, 3, 4, 20.00),
(5, 3, 4, 4, 3, 60.00),
(6, 4, 6, 5, 2, 90.00),
(7, 5, 7, 5, 5, 250.00),
(8, 6, 8, 6, 6, 50.00);


