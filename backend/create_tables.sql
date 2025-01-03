BEGIN
   FOR t IN (SELECT table_name FROM user_tables) LOOP
      EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
   END LOOP;
END;
/

CREATE TABLE Involved_Party (
  party_id INT PRIMARY KEY,
  first_name VARCHAR2(100),
  last_name VARCHAR2(100),
  address VARCHAR2(255),
  phone_number VARCHAR2(20),
  is_juridical CHAR(1)
);

CREATE TABLE Cases (
  case_id INT PRIMARY KEY,
  case_type VARCHAR2(50) CHECK (case_type IN ('Political', 'Family', 'Criminal', 'Civil')),
  starting_date DATE,
  finishing_date DATE,
  status VARCHAR2(50) CHECK (status IN ('Referred', 'Pending', 'Closed', 'Open')),
  judgment_date DATE,
  description VARCHAR2(4000)
);

CREATE TABLE Representation (
  client_id INT,
  lawyer_id INT,
  case_id INT,
  start_date DATE,
  end_date DATE,
  PRIMARY KEY (client_id, lawyer_id, case_id),
  FOREIGN KEY (client_id) REFERENCES Involved_Party(party_id),
  FOREIGN KEY (lawyer_id) REFERENCES Involved_Party(party_id),
  FOREIGN KEY (case_id) REFERENCES Cases(case_id)
);

CREATE TABLE Complaint (
  complaint_id INT, 
  case_id INT,
  plaintiff_id INT,
  defendant_id INT,
  complaint_date DATE,
  description VARCHAR2(4000),
  PRIMARY key (COMPLAINT_ID),
  FOREIGN KEY (case_id) REFERENCES Cases(case_id),
  FOREIGN KEY (plaintiff_id) REFERENCES Involved_Party(party_id),
  FOREIGN KEY (defendant_id) REFERENCES Involved_Party(party_id)
);

CREATE TABLE Court_Staff (
  court_staff_id INT PRIMARY KEY,
  court_staff_name VARCHAR2(100),
  address VARCHAR2(255),
  court_staff_type VARCHAR2(50) CHECK (court_staff_type IN ('Judge', 'Bailiff', 'Jury_member', 'Reporter', 'Clerk', 'Prosecutor', 'Plaintiff-Lawyer', 'Defendant-Lawyer')),
  license_number VARCHAR2(50)
);

CREATE TABLE Court_Branch (
  court_name VARCHAR2(100),
  address VARCHAR2(255),
  court_type VARCHAR2(50) CHECK (court_type IN ('Family', 'Public', 'Military', 'Supreme')),
  validity INT CHECK (validity BETWEEN 1 AND 5),
  PRIMARY KEY (court_name, address)
);

CREATE TABLE Appeal (
  case_id INT,
  appeal_date DATE,
  reason VARCHAR2(4000),
  status VARCHAR2(50) CHECK (status IN ('Pending', 'Granted', 'Denied')),
  decision_date DATE,
  outcome VARCHAR2(4000),
  PRIMARY KEY (case_id, appeal_date),
  FOREIGN KEY (case_id) REFERENCES Cases(case_id)
);

CREATE TABLE Evidence (
  evidence_id INT, 
  case_id INT,
  description VARCHAR2(4000),
  evidence_type VARCHAR2(50) CHECK (evidence_type IN ('Other', 'Digital Document', 'Written', 'Testimony')),
  date_submitted DATE,
  FOREIGN KEY (case_id) REFERENCES Cases(case_id),
  PRIMARY KEY(EVIDENCE_ID)
);

CREATE TABLE Verdict (
  case_id INT,
  date_issued DATE,
  verdict_type VARCHAR2(50) CHECK (verdict_type IN ('Pending', 'Guilty', 'Not Guilty')),
  summary VARCHAR2(4000),
  PRIMARY KEY (case_id, date_issued),
  FOREIGN KEY (case_id) REFERENCES Cases(case_id)
);

CREATE TABLE Archive (
  case_id INT,
  archival_date DATE,
  PRIMARY KEY (case_id, archival_date),
  FOREIGN KEY (case_id) REFERENCES Cases(case_id)
);

CREATE TABLE Court_Session (
  case_id INT,
  court_name VARCHAR2(100),
  address VARCHAR2(255),
  session_date DATE,
  summary VARCHAR2(4000),
  PRIMARY KEY (case_id, court_name, address, session_date),
  FOREIGN KEY (case_id) REFERENCES Cases(case_id),
  FOREIGN KEY (court_name, address) REFERENCES Court_Branch(court_name, address)
);

CREATE TABLE Role_Assignment (
  party_id INT,
  case_id INT,
  role VARCHAR2(50),
  PRIMARY KEY (party_id, case_id, role),
  FOREIGN KEY (party_id) REFERENCES Involved_Party(party_id),
  FOREIGN KEY (case_id) REFERENCES Cases(case_id)
);

CREATE TABLE Role_In_Session (
  court_staff_id INT,
  case_id INT,
  court_name VARCHAR2(100),
  address VARCHAR2(255),
  session_date DATE,
  role VARCHAR2(50),
  PRIMARY KEY (court_staff_id, case_id, court_name, address, session_date, role),
  FOREIGN KEY (court_staff_id) REFERENCES Court_Staff(court_staff_id),
  FOREIGN KEY (case_id, court_name, address, session_date) REFERENCES Court_Session(case_id, court_name, address, session_date)
);

CREATE TABLE Person_Evidence_Relation (
  person_id INT,
  evidence_id INT,
  address_of_finding VARCHAR2(255),
  date_of_finding DATE,
  role VARCHAR2(50),
  PRIMARY KEY (person_id, evidence_id),
  FOREIGN KEY (person_id) REFERENCES Involved_Party(party_id),
  FOREIGN KEY (evidence_id) REFERENCES Evidence(evidence_id)
);





CREATE TABLE Appeal_Request (
  case_id INT,
  appeal_date DATE,
  request_date DATE,
  PRIMARY KEY (case_id, appeal_date, request_date),
  FOREIGN KEY (case_id, appeal_date) REFERENCES Appeal(case_id, appeal_date)
);

CREATE TABLE Writes (
  writer_id INT,
  case_id INT,
  appeal_date DATE,
  PRIMARY KEY (writer_id, case_id, appeal_date),
  FOREIGN KEY (writer_id) REFERENCES Involved_Party(party_id),
  FOREIGN KEY (case_id, appeal_date) REFERENCES Appeal(case_id, appeal_date)
);

CREATE TABLE Representing_What (
    representation_client_id INT NOT NULL,
    representation_lawyer_id INT NOT NULL,
    representation_case_id INT NOT NULL,
    complaint_id INT NOT NULL,
    role VARCHAR2(50),
    PRIMARY KEY (representation_client_id, representation_lawyer_id, representation_case_id, complaint_id),
    FOREIGN KEY (representation_client_id, representation_lawyer_id, representation_case_id) 
        REFERENCES Representation(client_id, lawyer_id, case_id) ON DELETE CASCADE,
    FOREIGN KEY (complaint_id) 
        REFERENCES Complaint(complaint_id) ON DELETE CASCADE
);


CREATE TABLE Case_Referral (
    referring_case_id INT,
    referred_case_id INT,
    referral_date DATE,
    PRIMARY KEY (referring_case_id, referred_case_id),
    FOREIGN KEY (referring_case_id) REFERENCES Cases(case_id),
    FOREIGN KEY (referred_case_id) REFERENCES Cases(case_id)
);

-- Delete all records from all tables to prevent duplication
DELETE FROM Representing_What;
DELETE FROM Writes;
DELETE FROM Appeal_Request;
DELETE FROM Person_Evidence_Relation;
DELETE FROM Role_In_Session;
DELETE FROM Role_Assignment;
DELETE FROM Court_Session;
DELETE FROM Archive;
DELETE FROM Verdict;
DELETE FROM Evidence;
DELETE FROM Appeal;
DELETE FROM Complaint;
DELETE FROM Court_Staff;
DELETE FROM Court_Branch;
DELETE FROM Representation;
DELETE FROM Involved_Party;
DELETE FROM Case_Referral;
DELETE FROM Cases;

INSERT INTO Involved_Party (party_id, first_name, last_name, address, phone_number, is_juridical)
VALUES (1, 'John', 'Doe', '123 Main St', '555-111-2222', 'N');
INSERT INTO Involved_Party (party_id, first_name, last_name, address, phone_number, is_juridical)
VALUES (2, 'Jane', 'Smith', '456 Oak Ave', '555-333-4444', 'N');
INSERT INTO Involved_Party (party_id, first_name, last_name, address, phone_number, is_juridical)
VALUES (3, 'Mary', 'Johnson', '789 Pine Rd', '555-555-5555', 'N');
INSERT INTO Involved_Party (party_id, first_name, last_name, address, phone_number, is_juridical)
VALUES (4, 'Alice', 'Brown', '101 Maple Ave', '222-333-4444', 'N');
INSERT INTO Involved_Party (party_id, first_name, last_name, address, phone_number, is_juridical)
VALUES (5, 'Bob', 'Green', '202 Birch St', '555-111-2233', 'N');
INSERT INTO Involved_Party (party_id, first_name, last_name, address, phone_number, is_juridical)
VALUES (6, 'Charlie', 'White', '303 Pine Rd', '555-444-5566', 'N');
INSERT INTO Involved_Party (party_id, first_name, last_name, address, phone_number, is_juridical)
VALUES (7, 'David', 'Black', '404 Oak Blvd', '555-777-8899', 'N');
INSERT INTO Involved_Party (party_id, first_name, last_name, address, phone_number, is_juridical)
VALUES (8, 'Eva', 'Davis', '505 Cedar St', '555-888-9000', 'N');
INSERT INTO Involved_Party (party_id, first_name, last_name, address, phone_number, is_juridical)
VALUES (9, 'Frank', 'Clark', '606 Elm St', '555-123-1122', 'N');
INSERT INTO Involved_Party (party_id, first_name, last_name, address, phone_number, is_juridical)
VALUES (10, 'Grace', 'Lopez', '707 Walnut Ave', '555-555-0000', 'N');
INSERT INTO Involved_Party (party_id, first_name, last_name, address, phone_number, is_juridical)
VALUES (11, 'Henry', 'Martinez', '808 Maple Rd', '555-222-3344', 'N');
INSERT INTO Involved_Party (party_id, first_name, last_name, address, phone_number, is_juridical)
VALUES (12, 'Isabella', 'Harris', '909 Pine Blvd', '555-666-7799', 'N');
INSERT INTO Involved_Party (party_id, first_name, last_name, address, phone_number, is_juridical)
VALUES (13, 'Jack', 'Young', '1010 Birch St', '555-444-3322', 'N');
INSERT INTO Involved_Party (party_id, first_name, last_name, address, phone_number, is_juridical)
VALUES (14, 'Karen', 'King', '1111 Cedar Ave', '555-999-4433', 'N');
INSERT INTO Involved_Party (party_id, first_name, last_name, address, phone_number, is_juridical)
VALUES (15, 'Leo', 'Wright', '1212 Oak Rd', '555-444-7777', 'N');
INSERT INTO Involved_Party (party_id, first_name, last_name, address, phone_number, is_juridical)
VALUES (16, 'Mona', 'Scott', '1313 Maple Blvd', '555-888-2323', 'N');
INSERT INTO Involved_Party (party_id, first_name, last_name, address, phone_number, is_juridical)
VALUES (17, 'Nathan', 'Adams', '1414 Pine Rd', '555-333-4422', 'N');


INSERT INTO Cases (case_id, case_type, starting_date, finishing_date, status, judgment_date, description)
VALUES (103, 'Criminal', TO_DATE('2024-03-10', 'YYYY-MM-DD'), TO_DATE('2024-07-15', 'YYYY-MM-DD'), 'Pending', NULL, 'Assault case');
INSERT INTO Cases (case_id, case_type, starting_date, finishing_date, status, judgment_date, description)
VALUES (104, 'Family', TO_DATE('2024-04-01', 'YYYY-MM-DD'), TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'Closed', TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'Custody battle');
INSERT INTO Cases (case_id, case_type, starting_date, finishing_date, status, judgment_date, description)
VALUES (105, 'Civil', TO_DATE('2024-05-15', 'YYYY-MM-DD'), TO_DATE('2024-08-30', 'YYYY-MM-DD'), 'Pending', NULL, 'Breach of contract');
INSERT INTO Cases (case_id, case_type, starting_date, finishing_date, status, judgment_date, description)
VALUES (106, 'Criminal', TO_DATE('2024-06-05', 'YYYY-MM-DD'), TO_DATE('2024-09-10', 'YYYY-MM-DD'), 'Pending', NULL, 'Theft case');
INSERT INTO Cases (case_id, case_type, starting_date, finishing_date, status, judgment_date, description)
VALUES (107, 'Family', TO_DATE('2024-07-10', 'YYYY-MM-DD'), TO_DATE('2024-08-25', 'YYYY-MM-DD'), 'Closed', TO_DATE('2024-08-25', 'YYYY-MM-DD'), 'Alimony dispute');
INSERT INTO Cases (case_id, case_type, starting_date, finishing_date, status, judgment_date, description)
VALUES (108, 'Criminal', TO_DATE('2024-07-01', 'YYYY-MM-DD'), TO_DATE('2024-09-01', 'YYYY-MM-DD'), 'Pending', NULL, 'Fraud case');
INSERT INTO Cases (case_id, case_type, starting_date, finishing_date, status, judgment_date, description)
VALUES (109, 'Civil', TO_DATE('2024-08-01', 'YYYY-MM-DD'), TO_DATE('2024-12-10', 'YYYY-MM-DD'), 'Pending', NULL, 'Property dispute');
INSERT INTO Cases (case_id, case_type, starting_date, finishing_date, status, judgment_date, description)
VALUES (110, 'Criminal', TO_DATE('2024-05-20', 'YYYY-MM-DD'), TO_DATE('2024-07-20', 'YYYY-MM-DD'), 'Pending', NULL, 'Drug trafficking');
INSERT INTO Cases (case_id, case_type, starting_date, finishing_date, status, judgment_date, description)
VALUES (111, 'Family', TO_DATE('2024-06-10', 'YYYY-MM-DD'), TO_DATE('2024-07-10', 'YYYY-MM-DD'), 'Closed', TO_DATE('2024-07-10', 'YYYY-MM-DD'), 'Child support case');
INSERT INTO Cases (case_id, case_type, starting_date, finishing_date, status, judgment_date, description)
VALUES (112, 'Civil', TO_DATE('2024-05-25', 'YYYY-MM-DD'), TO_DATE('2024-09-05', 'YYYY-MM-DD'), 'Pending', NULL, 'Intellectual property infringement');
INSERT INTO Cases (case_id, case_type, starting_date, finishing_date, status, judgment_date, description)
VALUES (113, 'Criminal', TO_DATE('2024-04-15', 'YYYY-MM-DD'), TO_DATE('2024-06-15', 'YYYY-MM-DD'), 'Pending', NULL, 'Armed robbery');
INSERT INTO Cases (case_id, case_type, starting_date, finishing_date, status, judgment_date, description)
VALUES (114, 'Family', TO_DATE('2024-03-01', 'YYYY-MM-DD'), TO_DATE('2024-04-15', 'YYYY-MM-DD'), 'Closed', TO_DATE('2024-04-15', 'YYYY-MM-DD'), 'Marriage annulment');
INSERT INTO Cases (case_id, case_type, starting_date, finishing_date, status, judgment_date, description)
VALUES (115, 'Criminal', TO_DATE('2024-08-15', 'YYYY-MM-DD'), TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'Pending', NULL, 'Corruption case');
INSERT INTO Cases (case_id, case_type, starting_date, finishing_date, status, judgment_date, description)
VALUES (116, 'Family', TO_DATE('2024-09-01', 'YYYY-MM-DD'), TO_DATE('2024-10-15', 'YYYY-MM-DD'), 'Closed', TO_DATE('2024-10-15', 'YYYY-MM-DD'), 'Domestic violence case');


-- Insert data for Representation
INSERT INTO Representation (client_id, lawyer_id, case_id, start_date, end_date)
VALUES (1, 2, 103, TO_DATE('2024-03-10', 'YYYY-MM-DD'), TO_DATE('2024-07-15', 'YYYY-MM-DD'));
INSERT INTO Representation (client_id, lawyer_id, case_id, start_date, end_date)
VALUES (3, 4, 104, TO_DATE('2024-04-01', 'YYYY-MM-DD'), TO_DATE('2024-05-01', 'YYYY-MM-DD'));
INSERT INTO Representation (client_id, lawyer_id, case_id, start_date, end_date)
VALUES (2, 3, 105, TO_DATE('2024-05-15', 'YYYY-MM-DD'), TO_DATE('2024-08-30', 'YYYY-MM-DD'));
INSERT INTO Representation (client_id, lawyer_id, case_id, start_date, end_date)
VALUES (4, 5, 106, TO_DATE('2024-06-05', 'YYYY-MM-DD'), TO_DATE('2024-09-10', 'YYYY-MM-DD'));
INSERT INTO Representation (client_id, lawyer_id, case_id, start_date, end_date)
VALUES (3, 6, 107, TO_DATE('2024-07-10', 'YYYY-MM-DD'), TO_DATE('2024-08-25', 'YYYY-MM-DD'));
INSERT INTO Representation (client_id, lawyer_id, case_id, start_date, end_date)
VALUES (5, 7, 108, TO_DATE('2024-07-01', 'YYYY-MM-DD'), TO_DATE('2024-09-01', 'YYYY-MM-DD'));
INSERT INTO Representation (client_id, lawyer_id, case_id, start_date, end_date)
VALUES (6, 8, 109, TO_DATE('2024-08-01', 'YYYY-MM-DD'), TO_DATE('2024-12-10', 'YYYY-MM-DD'));
INSERT INTO Representation (client_id, lawyer_id, case_id, start_date, end_date)
VALUES (7, 9, 110, TO_DATE('2024-05-20', 'YYYY-MM-DD'), TO_DATE('2024-07-20', 'YYYY-MM-DD'));
INSERT INTO Representation (client_id, lawyer_id, case_id, start_date, end_date)
VALUES (8, 10, 111, TO_DATE('2024-06-10', 'YYYY-MM-DD'), TO_DATE('2024-07-10', 'YYYY-MM-DD'));
INSERT INTO Representation (client_id, lawyer_id, case_id, start_date, end_date)
VALUES (9, 11, 112, TO_DATE('2024-05-25', 'YYYY-MM-DD'), TO_DATE('2024-09-05', 'YYYY-MM-DD'));
INSERT INTO Representation (client_id, lawyer_id, case_id, start_date, end_date)
VALUES (10, 12, 113, TO_DATE('2024-04-15', 'YYYY-MM-DD'), TO_DATE('2024-06-15', 'YYYY-MM-DD'));
INSERT INTO Representation (client_id, lawyer_id, case_id, start_date, end_date)
VALUES (11, 13, 114, TO_DATE('2024-03-01', 'YYYY-MM-DD'), TO_DATE('2024-04-15', 'YYYY-MM-DD'));
INSERT INTO Representation (client_id, lawyer_id, case_id, start_date, end_date)
VALUES (12, 14, 115, TO_DATE('2024-08-15', 'YYYY-MM-DD'), TO_DATE('2024-12-01', 'YYYY-MM-DD'));
INSERT INTO Representation (client_id, lawyer_id, case_id, start_date, end_date)
VALUES (13, 15, 116, TO_DATE('2024-09-01', 'YYYY-MM-DD'), TO_DATE('2024-10-15', 'YYYY-MM-DD'));

delete FROM COMPLAINT;
INSERT INTO Complaint (complaint_id, case_id, plaintiff_id, defendant_id, description, complaint_date)
VALUES (3, 103, 5, 6, 'Complaint regarding lack of communication', TO_DATE('2024-01-15', 'YYYY-MM-DD'));

INSERT INTO Complaint (complaint_id, case_id, plaintiff_id, defendant_id, description, complaint_date)
VALUES (4, 104, 7, 8, 'Complaint about mismanagement of case details', TO_DATE('2024-01-20', 'YYYY-MM-DD'));

INSERT INTO Complaint (complaint_id, case_id, plaintiff_id, defendant_id, description, complaint_date)
VALUES (5, 105, 9, 10, 'Complaint about delayed legal filings', TO_DATE('2024-01-25', 'YYYY-MM-DD'));

INSERT INTO Complaint (complaint_id, case_id, plaintiff_id, defendant_id, description, complaint_date)
VALUES (6, 106, 11, 12, 'Complaint regarding breach of contract terms', TO_DATE('2024-02-01', 'YYYY-MM-DD'));

INSERT INTO Complaint (complaint_id, case_id, plaintiff_id, defendant_id, description, complaint_date)
VALUES (7, 107, 13, 14, 'Complaint about failure to respond to discovery', TO_DATE('2024-02-05', 'YYYY-MM-DD'));

INSERT INTO Complaint (complaint_id, case_id, plaintiff_id, defendant_id, description, complaint_date)
VALUES (8, 108, 15, 16, 'Complaint about inappropriate court behavior', TO_DATE('2024-02-10', 'YYYY-MM-DD'));


DELETE from COURT_STAFF;
INSERT INTO Court_Staff (court_staff_id, court_staff_name, address, court_staff_type, license_number)
VALUES (1, 'John Smith', '123 Court St, Cityville', 'Judge', 'JS12345');

INSERT INTO Court_Staff (court_staff_id, court_staff_name, address, court_staff_type, license_number)
VALUES (2, 'Alice Johnson', '456 Justice Ave, Cityville', 'Clerk', 'AJ23456');

INSERT INTO Court_Staff (court_staff_id, court_staff_name, address, court_staff_type, license_number)
VALUES (3, 'Bob Williams', '789 Law Rd, Cityville', 'Bailiff', 'BW34567');

INSERT INTO Court_Staff (court_staff_id, court_staff_name, address, court_staff_type, license_number)
VALUES (5, 'Michael Miller', '202 Trial St, Cityville', 'Prosecutor', 'MM56789');
INSERT INTO Court_Staff (court_staff_id, court_staff_name, address, court_staff_type, license_number)
VALUES (7, 'James Moore', '404 Court Rd, Cityville', 'Judge', 'JM78901');

INSERT INTO Court_Staff (court_staff_id, court_staff_name, address, court_staff_type, license_number)
VALUES (8, 'Laura Taylor', '505 Clerk St, Cityville', 'Clerk', 'LT89012');

INSERT INTO Court_Staff (court_staff_id, court_staff_name, address, court_staff_type, license_number)
VALUES (9, 'David Anderson', '606 Bailiff Ln, Cityville', 'Bailiff', 'DA90123');

INSERT INTO Court_Staff (court_staff_id, court_staff_name, address, court_staff_type, license_number)
VALUES (11, 'Robert Jackson', '808 Prosecution St, Cityville', 'Prosecutor', 'RJ12345');

INSERT INTO Court_Staff (court_staff_id, court_staff_name, address, court_staff_type, license_number)
VALUES (13, 'Thomas Harris', '1010 Legal Way, Cityville', 'Judge', 'TH34567');

INSERT INTO Court_Staff (court_staff_id, court_staff_name, address, court_staff_type, license_number)
VALUES (14, 'Nancy Martinez', '1111 Trial Ave, Cityville', 'Clerk', 'NM45678');

INSERT INTO Court_Staff (court_staff_id, court_staff_name, address, court_staff_type, license_number)
VALUES (15, 'William Garcia', '1212 Justice Rd, Cityville', 'Bailiff', 'WG56789');

INSERT INTO Court_Branch (court_name, address, court_type, validity)
VALUES ('Central Court', '123 Central Ave, Cityville', 'Public', 3);

INSERT INTO Court_Branch (court_name, address, court_type, validity)
VALUES ('North District Court', '456 North St, Townsville', 'Family', 4);

INSERT INTO Court_Branch (court_name, address, court_type, validity)
VALUES ('South District Court', '789 South Blvd, Rivertown', 'Military', 2);

INSERT INTO Court_Branch (court_name, address, court_type, validity)
VALUES ('East District Court', '101 East Rd, Laketown', 'Supreme', 5);

INSERT INTO Court_Branch (court_name, address, court_type, validity)
VALUES ('West City Court', '202 West Ave, Cityburg', 'Public', 1);

INSERT INTO Court_Branch (court_name, address, court_type, validity)
VALUES ('Central District Court', '303 Central Rd, Villagetown', 'Military', 3);

INSERT INTO Court_Branch (court_name, address, court_type, validity)
VALUES ('Main Street Court', '404 Main St, Cityville', 'Family', 4);

INSERT INTO Court_Branch (court_name, address, court_type, validity)
VALUES ('High Court', '505 High St, Townington', 'Supreme', 5);

INSERT INTO Court_Branch (court_name, address, court_type, validity)
VALUES ('Regional Court', '606 Regional Ave, Suburbia', 'Public', 2);

INSERT INTO Court_Branch (court_name, address, court_type, validity)
VALUES ('State Court', '707 State Blvd, Downtown', 'Family', 1);

INSERT INTO Court_Branch (court_name, address, court_type, validity)
VALUES ('City Hall Court', '808 Hall Rd, Metropolis', 'Public', 3);

INSERT INTO Court_Branch (court_name, address, court_type, validity)
VALUES ('Northern Court', '909 North Rd, Hilltown', 'Family', 5);

INSERT INTO Court_Branch (court_name, address, court_type, validity)
VALUES ('Mountain Court', '1010 Mountain Ave, Valleyburg', 'Military', 4);

INSERT INTO Court_Branch (court_name, address, court_type, validity)
VALUES ('Southern Court', '1111 South St, Riverwood', 'Supreme', 2);

INSERT INTO Court_Branch (court_name, address, court_type, validity)
VALUES ('Lakeside Court', '1212 Lakeside Blvd, Baytown', 'Public', 1);


DELETE from APPEAL;
INSERT INTO Appeal (case_id, appeal_date, reason, status, decision_date, outcome)
VALUES (103, TO_DATE('2024-08-01', 'YYYY-MM-DD'), 'Disagreement with case outcome', 'Pending', NULL, NULL);

INSERT INTO Appeal (case_id, appeal_date, reason, status, decision_date, outcome)
VALUES (104, TO_DATE('2024-06-01', 'YYYY-MM-DD'), 'Custody arrangement dissatisfaction', 'Denied', TO_DATE('2024-06-15', 'YYYY-MM-DD'), 'Appeal denied, original ruling upheld');

INSERT INTO Appeal (case_id, appeal_date, reason, status, decision_date, outcome)
VALUES (105, TO_DATE('2024-07-10', 'YYYY-MM-DD'), 'Breach of contract interpretation', 'Pending', NULL, NULL);

INSERT INTO Appeal (case_id, appeal_date, reason, status, decision_date, outcome)
VALUES (106, TO_DATE('2024-08-10', 'YYYY-MM-DD'), 'Incorrect application of the law', 'Pending', NULL, NULL);

INSERT INTO Appeal (case_id, appeal_date, reason, status, decision_date, outcome)
VALUES (107, TO_DATE('2024-09-01', 'YYYY-MM-DD'), 'Alimony dispute ruling unfair', 'Denied', TO_DATE('2024-09-20', 'YYYY-MM-DD'), 'Appeal denied, original ruling upheld');

INSERT INTO Appeal (case_id, appeal_date, reason, status, decision_date, outcome)
VALUES (108, TO_DATE('2024-09-15', 'YYYY-MM-DD'), 'Wrongful charges', 'Pending', NULL, NULL);

INSERT INTO Appeal (case_id, appeal_date, reason, status, decision_date, outcome)
VALUES (109, TO_DATE('2024-11-01', 'YYYY-MM-DD'), 'Property rights violation', 'Pending', NULL, NULL);

INSERT INTO Appeal (case_id, appeal_date, reason, status, decision_date, outcome)
VALUES (110, TO_DATE('2024-09-05', 'YYYY-MM-DD'), 'Drug-related evidence mishandling', 'Pending', NULL, NULL);

INSERT INTO Appeal (case_id, appeal_date, reason, status, decision_date, outcome)
VALUES (111, TO_DATE('2024-07-20', 'YYYY-MM-DD'), 'Unfair child support decision', 'Denied', TO_DATE('2024-08-01', 'YYYY-MM-DD'), 'Appeal denied, original ruling upheld');

INSERT INTO Appeal (case_id, appeal_date, reason, status, decision_date, outcome)
VALUES (112, TO_DATE('2024-08-15', 'YYYY-MM-DD'), 'Improper handling of intellectual property case', 'Pending', NULL, NULL);

INSERT INTO Appeal (case_id, appeal_date, reason, status, decision_date, outcome)
VALUES (113, TO_DATE('2024-06-20', 'YYYY-MM-DD'), 'Violence during arrest', 'Pending', NULL, NULL);

INSERT INTO Appeal (case_id, appeal_date, reason, status, decision_date, outcome)
VALUES (114, TO_DATE('2024-04-25', 'YYYY-MM-DD'), 'Marriage annulment misunderstanding', 'Denied', TO_DATE('2024-05-10', 'YYYY-MM-DD'), 'Appeal denied, original ruling upheld');

INSERT INTO Appeal (case_id, appeal_date, reason, status, decision_date, outcome)
VALUES (115, TO_DATE('2024-09-25', 'YYYY-MM-DD'), 'Corruption case evidence disputed', 'Pending', NULL, NULL);

INSERT INTO Appeal (case_id, appeal_date, reason, status, decision_date, outcome)
VALUES (116, TO_DATE('2024-10-10', 'YYYY-MM-DD'), 'Domestic violence ruling not satisfactory', 'Denied', TO_DATE('2024-10-25', 'YYYY-MM-DD'), 'Appeal denied, original ruling upheld');

INSERT INTO Evidence (evidence_id, case_id, description, evidence_type, date_submitted)
VALUES (1, 103, 'Photograph of the crime scene', 'Other', TO_DATE('2024-03-15', 'YYYY-MM-DD'));

INSERT INTO Evidence (evidence_id, case_id, description, evidence_type, date_submitted)
VALUES (2, 104, 'Custody documents', 'Written', TO_DATE('2024-04-02', 'YYYY-MM-DD'));

INSERT INTO Evidence (evidence_id, case_id, description, evidence_type, date_submitted)
VALUES (3, 105, 'Signed contract breach letter', 'Written', TO_DATE('2024-05-17', 'YYYY-MM-DD'));

INSERT INTO Evidence (evidence_id, case_id, description, evidence_type, date_submitted)
VALUES (4, 106, 'Surveillance footage of theft', 'Digital Document', TO_DATE('2024-06-10', 'YYYY-MM-DD'));

INSERT INTO Evidence (evidence_id, case_id, description, evidence_type, date_submitted)
VALUES (5, 107, 'Bank records showing alimony payment', 'Digital Document', TO_DATE('2024-07-12', 'YYYY-MM-DD'));

INSERT INTO Evidence (evidence_id, case_id, description, evidence_type, date_submitted)
VALUES (6, 108, 'Fraudulent email correspondence', 'Digital Document', TO_DATE('2024-07-20', 'YYYY-MM-DD'));

INSERT INTO Evidence (evidence_id, case_id, description, evidence_type, date_submitted)
VALUES (7, 109, 'Property ownership dispute letter', 'Written', TO_DATE('2024-08-05', 'YYYY-MM-DD'));

INSERT INTO Evidence (evidence_id, case_id, description, evidence_type, date_submitted)
VALUES (8, 110, 'Witness testimony regarding drug trafficking', 'Testimony', TO_DATE('2024-06-25', 'YYYY-MM-DD'));

INSERT INTO Evidence (evidence_id, case_id, description, evidence_type, date_submitted)
VALUES (9, 111, 'Child support payment records', 'Digital Document', TO_DATE('2024-07-01', 'YYYY-MM-DD'));

INSERT INTO Evidence (evidence_id, case_id, description, evidence_type, date_submitted)
VALUES (10, 112, 'Patent infringement report', 'Other', TO_DATE('2024-05-28', 'YYYY-MM-DD'));

INSERT INTO Evidence (evidence_id, case_id, description, evidence_type, date_submitted)
VALUES (11, 113, 'Video footage of armed robbery', 'Digital Document', TO_DATE('2024-05-02', 'YYYY-MM-DD'));

INSERT INTO Evidence (evidence_id, case_id, description, evidence_type, date_submitted)
VALUES (12, 114, 'Marriage annulment certificate', 'Written', TO_DATE('2024-03-12', 'YYYY-MM-DD'));

INSERT INTO Evidence (evidence_id, case_id, description, evidence_type, date_submitted)
VALUES (13, 115, 'Witness testimony on bribery', 'Testimony', TO_DATE('2024-08-20', 'YYYY-MM-DD'));

INSERT INTO Evidence (evidence_id, case_id, description, evidence_type, date_submitted)
VALUES (14, 116, 'Domestic violence medical report', 'Other', TO_DATE('2024-09-10', 'YYYY-MM-DD'));

INSERT INTO Evidence (evidence_id, case_id, description, evidence_type, date_submitted)
VALUES (15, 103, 'Forensic report of assault victim', 'Other', TO_DATE('2024-03-17', 'YYYY-MM-DD'));



INSERT INTO Verdict (case_id, date_issued, verdict_type, summary)
VALUES (103, TO_DATE('2024-07-20', 'YYYY-MM-DD'), 'Pending', 'Awaiting judgment on the assault case.');

INSERT INTO Verdict (case_id, date_issued, verdict_type, summary)
VALUES (104, TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'Guilty', 'The father is granted full custody of the child.');

INSERT INTO Verdict (case_id, date_issued, verdict_type, summary)
VALUES (105, TO_DATE('2024-08-01', 'YYYY-MM-DD'), 'Not Guilty', 'The defendant was not found guilty of breach of contract.');

INSERT INTO Verdict (case_id, date_issued, verdict_type, summary)
VALUES (106, TO_DATE('2024-09-10', 'YYYY-MM-DD'), 'Pending', 'Still under investigation for the theft case.');

INSERT INTO Verdict (case_id, date_issued, verdict_type, summary)
VALUES (107, TO_DATE('2024-08-25', 'YYYY-MM-DD'), 'Guilty', 'The defendant is found liable for not paying alimony.');

INSERT INTO Verdict (case_id, date_issued, verdict_type, summary)
VALUES (108, TO_DATE('2024-09-01', 'YYYY-MM-DD'), 'Pending', 'Awaiting decision on the fraud case.');

INSERT INTO Verdict (case_id, date_issued, verdict_type, summary)
VALUES (109, TO_DATE('2024-12-01', 'YYYY-MM-DD'), 'Pending', 'The case is still under review.');

INSERT INTO Verdict (case_id, date_issued, verdict_type, summary)
VALUES (110, TO_DATE('2024-07-20', 'YYYY-MM-DD'), 'Pending', 'Awaiting sentencing for the drug trafficking case.');

INSERT INTO Verdict (case_id, date_issued, verdict_type, summary)
VALUES (111, TO_DATE('2024-07-10', 'YYYY-MM-DD'), 'Guilty', 'The defendant is ordered to pay child support.');

INSERT INTO Verdict (case_id, date_issued, verdict_type, summary)
VALUES (112, TO_DATE('2024-09-05', 'YYYY-MM-DD'), 'Not Guilty', 'The defendant was cleared of intellectual property infringement.');

INSERT INTO Verdict (case_id, date_issued, verdict_type, summary)
VALUES (113, TO_DATE('2024-06-20', 'YYYY-MM-DD'), 'Guilty', 'The defendant was convicted of armed robbery.');

INSERT INTO Verdict (case_id, date_issued, verdict_type, summary)
VALUES (114, TO_DATE('2024-04-15', 'YYYY-MM-DD'), 'Guilty', 'The marriage annulment has been granted.');

INSERT INTO Verdict (case_id, date_issued, verdict_type, summary)
VALUES (115, TO_DATE('2024-12-05', 'YYYY-MM-DD'), 'Pending', 'The corruption case is still under investigation.');

INSERT INTO Verdict (case_id, date_issued, verdict_type, summary)
VALUES (116, TO_DATE('2024-10-15', 'YYYY-MM-DD'), 'Guilty', 'The defendant was found guilty of domestic violence and sentenced to probation.');


INSERT INTO Archive (case_id, archival_date)
VALUES (103, TO_DATE('2024-08-01', 'YYYY-MM-DD'));

INSERT INTO Archive (case_id, archival_date)
VALUES (104, TO_DATE('2024-05-02', 'YYYY-MM-DD'));

INSERT INTO Archive (case_id, archival_date)
VALUES (105, TO_DATE('2024-08-02', 'YYYY-MM-DD'));

INSERT INTO Archive (case_id, archival_date)
VALUES (106, TO_DATE('2024-09-15', 'YYYY-MM-DD'));

INSERT INTO Archive (case_id, archival_date)
VALUES (107, TO_DATE('2024-08-26', 'YYYY-MM-DD'));

INSERT INTO Archive (case_id, archival_date)
VALUES (108, TO_DATE('2024-09-02', 'YYYY-MM-DD'));

INSERT INTO Archive (case_id, archival_date)
VALUES (109, TO_DATE('2024-12-15', 'YYYY-MM-DD'));

INSERT INTO Archive (case_id, archival_date)
VALUES (110, TO_DATE('2024-07-21', 'YYYY-MM-DD'));

INSERT INTO Archive (case_id, archival_date)
VALUES (111, TO_DATE('2024-07-11', 'YYYY-MM-DD'));

INSERT INTO Archive (case_id, archival_date)
VALUES (112, TO_DATE('2024-09-06', 'YYYY-MM-DD'));

INSERT INTO Archive (case_id, archival_date)
VALUES (113, TO_DATE('2024-06-18', 'YYYY-MM-DD'));

INSERT INTO Archive (case_id, archival_date)
VALUES (114, TO_DATE('2024-04-16', 'YYYY-MM-DD'));

INSERT INTO Archive (case_id, archival_date)
VALUES (115, TO_DATE('2024-12-10', 'YYYY-MM-DD'));

INSERT INTO Archive (case_id, archival_date)
VALUES (116, TO_DATE('2024-10-16', 'YYYY-MM-DD'));


INSERT INTO Court_Session (case_id, court_name, address, session_date, summary)
VALUES (103, 'Central Court', '123 Central Ave, Cityville', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 'First hearing for the assault case');

INSERT INTO Court_Session (case_id, court_name, address, session_date, summary)
VALUES (104, 'North District Court', '456 North St, Townsville', TO_DATE('2024-04-10', 'YYYY-MM-DD'), 'Hearing for the custody battle');

INSERT INTO Court_Session (case_id, court_name, address, session_date, summary)
VALUES (105, 'South District Court', '789 South Blvd, Rivertown', TO_DATE('2024-06-01', 'YYYY-MM-DD'), 'Initial hearing for breach of contract');

INSERT INTO Court_Session (case_id, court_name, address, session_date, summary)
VALUES (106, 'East District Court', '101 East Rd, Laketown', TO_DATE('2024-06-10', 'YYYY-MM-DD'), 'Theft case review');

INSERT INTO Court_Session (case_id, court_name, address, session_date, summary)
VALUES (107, 'Main Street Court', '404 Main St, Cityville', TO_DATE('2024-07-15', 'YYYY-MM-DD'), 'Alimony dispute hearing');

INSERT INTO Court_Session (case_id, court_name, address, session_date, summary)
VALUES (108, 'High Court', '505 High St, Townington', TO_DATE('2024-07-20', 'YYYY-MM-DD'), 'Fraud case examination');

INSERT INTO Court_Session (case_id, court_name, address, session_date, summary)
VALUES (109, 'Regional Court', '606 Regional Ave, Suburbia', TO_DATE('2024-09-05', 'YYYY-MM-DD'), 'Property dispute preliminary hearing');

INSERT INTO Court_Session (case_id, court_name, address, session_date, summary)
VALUES (110, 'City Hall Court', '808 Hall Rd, Metropolis', TO_DATE('2024-06-25', 'YYYY-MM-DD'), 'Drug trafficking case session');

INSERT INTO Court_Session (case_id, court_name, address, session_date, summary)
VALUES (111, 'State Court', '707 State Blvd, Downtown', TO_DATE('2024-06-30', 'YYYY-MM-DD'), 'Child support case closing hearing');

INSERT INTO Court_Session (case_id, court_name, address, session_date, summary)
VALUES (112, 'Southern Court', '1111 South St, Riverwood', TO_DATE('2024-07-10', 'YYYY-MM-DD'), 'Intellectual property infringement session');

INSERT INTO Court_Session (case_id, court_name, address, session_date, summary)
VALUES (113, 'Lakeside Court', '1212 Lakeside Blvd, Baytown', TO_DATE('2024-05-20', 'YYYY-MM-DD'), 'Armed robbery court session');

INSERT INTO Court_Session (case_id, court_name, address, session_date, summary)
VALUES (114, 'Northern Court', '909 North Rd, Hilltown', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 'Marriage annulment final hearing');

INSERT INTO Court_Session (case_id, court_name, address, session_date, summary)
VALUES (115, 'Central Court', '123 Central Ave, Cityville', TO_DATE('2024-08-10', 'YYYY-MM-DD'), 'Corruption case session');

INSERT INTO Court_Session (case_id, court_name, address, session_date, summary)
VALUES (116, 'West City Court', '202 West Ave, Cityburg', TO_DATE('2024-09-25', 'YYYY-MM-DD'), 'Domestic violence case hearing');


-- Assigning roles to involved parties in cases

-- For case 103 (Assault case)
INSERT INTO Role_Assignment (party_id, case_id, role) 
VALUES (1, 103, 'Judge');
INSERT INTO Role_Assignment (party_id, case_id, role) 
VALUES (2, 103, 'Prosecutor');
INSERT INTO Role_Assignment (party_id, case_id, role) 
VALUES (3, 103, 'Defendant');

-- For case 104 (Custody battle)
INSERT INTO Role_Assignment (party_id, case_id, role) 
VALUES (4, 104, 'Judge');
INSERT INTO Role_Assignment (party_id, case_id, role) 
VALUES (5, 104, 'Defense Attorney');

-- For case 105 (Breach of contract)
INSERT INTO Role_Assignment (party_id, case_id, role) 
VALUES (6, 105, 'Judge');
INSERT INTO Role_Assignment (party_id, case_id, role) 
VALUES (7, 105, 'Prosecutor');

-- For case 106 (Theft case)
INSERT INTO Role_Assignment (party_id, case_id, role) 
VALUES (8, 106, 'Judge');
INSERT INTO Role_Assignment (party_id, case_id, role) 
VALUES (9, 106, 'Defendant');

-- For case 107 (Alimony dispute)
INSERT INTO Role_Assignment (party_id, case_id, role) 
VALUES (10, 107, 'Judge');
INSERT INTO Role_Assignment (party_id, case_id, role) 
VALUES (11, 107, 'Witness');


-- Assigning roles for court staff in court sessions
DELETE from ROLE_IN_SESSION;
-- Case 103 (Assault case) at Central Court
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (1, 103, 'Central Court', '123 Central Ave, Cityville', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 'Judge');
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (2, 103, 'Central Court', '123 Central Ave, Cityville', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 'Clerk');
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (3, 103, 'Central Court', '123 Central Ave, Cityville', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 'Bailiff');
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (5, 103, 'Central Court', '123 Central Ave, Cityville', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 'Prosecutor');

-- Case 104 (Custody battle) at North District Court
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (7, 104, 'North District Court', '456 North St, Townsville', TO_DATE('2024-04-10', 'YYYY-MM-DD'), 'Judge');
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (2, 104, 'North District Court', '456 North St, Townsville', TO_DATE('2024-04-10', 'YYYY-MM-DD'), 'Clerk');
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (8, 104, 'North District Court', '456 North St, Townsville', TO_DATE('2024-04-10', 'YYYY-MM-DD'), 'Bailiff');
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (11, 104, 'North District Court', '456 North St, Townsville', TO_DATE('2024-04-10', 'YYYY-MM-DD'), 'Prosecutor');

-- Case 105 (Breach of contract) at South District Court
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (13, 105, 'South District Court', '789 South Blvd, Rivertown', TO_DATE('2024-06-01', 'YYYY-MM-DD'), 'Judge');
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (14, 105, 'South District Court', '789 South Blvd, Rivertown', TO_DATE('2024-06-01', 'YYYY-MM-DD'), 'Clerk');
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (9, 105, 'South District Court', '789 South Blvd, Rivertown', TO_DATE('2024-06-01', 'YYYY-MM-DD'), 'Bailiff');
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (5, 105, 'South District Court', '789 South Blvd, Rivertown', TO_DATE('2024-06-01', 'YYYY-MM-DD'), 'Prosecutor');

-- Case 106 (Theft case review) at East District Court
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (1, 106, 'East District Court', '101 East Rd, Laketown', TO_DATE('2024-06-10', 'YYYY-MM-DD'), 'Judge');
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (2, 106, 'East District Court', '101 East Rd, Laketown', TO_DATE('2024-06-10', 'YYYY-MM-DD'), 'Clerk');
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (3, 106, 'East District Court', '101 East Rd, Laketown', TO_DATE('2024-06-10', 'YYYY-MM-DD'), 'Bailiff');
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (11, 106, 'East District Court', '101 East Rd, Laketown', TO_DATE('2024-06-10', 'YYYY-MM-DD'), 'Prosecutor');

-- Case 107 (Alimony dispute hearing) at Main Street Court
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (13, 107, 'Main Street Court', '404 Main St, Cityville', TO_DATE('2024-07-15', 'YYYY-MM-DD'), 'Judge');
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (8, 107, 'Main Street Court', '404 Main St, Cityville', TO_DATE('2024-07-15', 'YYYY-MM-DD'), 'Clerk');
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (9, 107, 'Main Street Court', '404 Main St, Cityville', TO_DATE('2024-07-15', 'YYYY-MM-DD'), 'Bailiff');
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (11, 107, 'Main Street Court', '404 Main St, Cityville', TO_DATE('2024-07-15', 'YYYY-MM-DD'), 'Prosecutor');

-- Case 108 (Fraud case examination) at High Court
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (1, 108, 'High Court', '505 High St, Townington', TO_DATE('2024-07-20', 'YYYY-MM-DD'), 'Judge');
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (2, 108, 'High Court', '505 High St, Townington', TO_DATE('2024-07-20', 'YYYY-MM-DD'), 'Clerk');
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (3, 108, 'High Court', '505 High St, Townington', TO_DATE('2024-07-20', 'YYYY-MM-DD'), 'Bailiff');
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (11, 108, 'High Court', '505 High St, Townington', TO_DATE('2024-07-20', 'YYYY-MM-DD'), 'Prosecutor');

-- Case 109 (Property dispute preliminary hearing) at Regional Court
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (7, 109, 'Regional Court', '606 Regional Ave, Suburbia', TO_DATE('2024-09-05', 'YYYY-MM-DD'), 'Judge');
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (14, 109, 'Regional Court', '606 Regional Ave, Suburbia', TO_DATE('2024-09-05', 'YYYY-MM-DD'), 'Clerk');
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (9, 109, 'Regional Court', '606 Regional Ave, Suburbia', TO_DATE('2024-09-05', 'YYYY-MM-DD'), 'Bailiff');
INSERT INTO Role_In_Session (court_staff_id, case_id, court_name, address, session_date, role) 
VALUES (11, 109, 'Regional Court', '606 Regional Ave, Suburbia', TO_DATE('2024-09-05', 'YYYY-MM-DD'), 'Prosecutor');


INSERT INTO Person_Evidence_Relation (person_id, evidence_id, address_of_finding, date_of_finding, role)
VALUES (1, 1, '123 Main St', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 'Witness');

INSERT INTO Person_Evidence_Relation (person_id, evidence_id, address_of_finding, date_of_finding, role)
VALUES (2, 2, '456 Oak Ave', TO_DATE('2024-04-02', 'YYYY-MM-DD'), 'Author');

INSERT INTO Person_Evidence_Relation (person_id, evidence_id, address_of_finding, date_of_finding, role)
VALUES (3, 3, '789 Pine Rd', TO_DATE('2024-05-17', 'YYYY-MM-DD'), 'Recipient');

INSERT INTO Person_Evidence_Relation (person_id, evidence_id, address_of_finding, date_of_finding, role)
VALUES (4, 4, '101 Maple Ave', TO_DATE('2024-06-10', 'YYYY-MM-DD'), 'Viewer');

INSERT INTO Person_Evidence_Relation (person_id, evidence_id, address_of_finding, date_of_finding, role)
VALUES (5, 5, '202 Birch St', TO_DATE('2024-07-12', 'YYYY-MM-DD'), 'Owner');

INSERT INTO Person_Evidence_Relation (person_id, evidence_id, address_of_finding, date_of_finding, role)
VALUES (6, 6, '303 Pine Rd', TO_DATE('2024-07-20', 'YYYY-MM-DD'), 'Sender');

INSERT INTO Person_Evidence_Relation (person_id, evidence_id, address_of_finding, date_of_finding, role)
VALUES (7, 7, '404 Oak Blvd', TO_DATE('2024-08-05', 'YYYY-MM-DD'), 'Recipient');

INSERT INTO Person_Evidence_Relation (person_id, evidence_id, address_of_finding, date_of_finding, role)
VALUES (8, 8, '505 Cedar St', TO_DATE('2024-06-25', 'YYYY-MM-DD'), 'Testifier');

INSERT INTO Person_Evidence_Relation (person_id, evidence_id, address_of_finding, date_of_finding, role)
VALUES (9, 9, '606 Elm St', TO_DATE('2024-07-01', 'YYYY-MM-DD'), 'Supporter');

INSERT INTO Person_Evidence_Relation (person_id, evidence_id, address_of_finding, date_of_finding, role)
VALUES (10, 10, '707 Walnut Ave', TO_DATE('2024-05-28', 'YYYY-MM-DD'), 'Reporter');

INSERT INTO Person_Evidence_Relation (person_id, evidence_id, address_of_finding, date_of_finding, role)
VALUES (11, 11, '808 Maple Rd', TO_DATE('2024-05-02', 'YYYY-MM-DD'), 'Witness');

INSERT INTO Person_Evidence_Relation (person_id, evidence_id, address_of_finding, date_of_finding, role)
VALUES (12, 12, '909 Pine Blvd', TO_DATE('2024-03-12', 'YYYY-MM-DD'), 'Signatory');

INSERT INTO Person_Evidence_Relation (person_id, evidence_id, address_of_finding, date_of_finding, role)
VALUES (13, 13, '1010 Birch St', TO_DATE('2024-08-20', 'YYYY-MM-DD'), 'Testifier');

INSERT INTO Person_Evidence_Relation (person_id, evidence_id, address_of_finding, date_of_finding, role)
VALUES (14, 14, '1111 Cedar Ave', TO_DATE('2024-09-10', 'YYYY-MM-DD'), 'Victim');

INSERT INTO Person_Evidence_Relation (person_id, evidence_id, address_of_finding, date_of_finding, role)
VALUES (15, 15, '1212 Oak Rd', TO_DATE('2024-03-17', 'YYYY-MM-DD'), 'Collector');




INSERT INTO Appeal_Request (case_id, appeal_date, request_date)
VALUES (103, TO_DATE('2024-08-01', 'YYYY-MM-DD'), TO_DATE('2024-07-15', 'YYYY-MM-DD'));

INSERT INTO Appeal_Request (case_id, appeal_date, request_date)
VALUES (104, TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-05-20', 'YYYY-MM-DD'));

INSERT INTO Appeal_Request (case_id, appeal_date, request_date)
VALUES (105, TO_DATE('2024-07-10', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'));

INSERT INTO Appeal_Request (case_id, appeal_date, request_date)
VALUES (106, TO_DATE('2024-08-10', 'YYYY-MM-DD'), TO_DATE('2024-07-25', 'YYYY-MM-DD'));

INSERT INTO Appeal_Request (case_id, appeal_date, request_date)
VALUES (107, TO_DATE('2024-09-01', 'YYYY-MM-DD'), TO_DATE('2024-08-15', 'YYYY-MM-DD'));

INSERT INTO Appeal_Request (case_id, appeal_date, request_date)
VALUES (108, TO_DATE('2024-09-15', 'YYYY-MM-DD'), TO_DATE('2024-09-05', 'YYYY-MM-DD'));

INSERT INTO Appeal_Request (case_id, appeal_date, request_date)
VALUES (109, TO_DATE('2024-11-01', 'YYYY-MM-DD'), TO_DATE('2024-10-10', 'YYYY-MM-DD'));

INSERT INTO Appeal_Request (case_id, appeal_date, request_date)
VALUES (110, TO_DATE('2024-09-05', 'YYYY-MM-DD'), TO_DATE('2024-08-25', 'YYYY-MM-DD'));

INSERT INTO Appeal_Request (case_id, appeal_date, request_date)
VALUES (111, TO_DATE('2024-07-20', 'YYYY-MM-DD'), TO_DATE('2024-07-10', 'YYYY-MM-DD'));

INSERT INTO Appeal_Request (case_id, appeal_date, request_date)
VALUES (112, TO_DATE('2024-08-15', 'YYYY-MM-DD'), TO_DATE('2024-08-05', 'YYYY-MM-DD'));

INSERT INTO Appeal_Request (case_id, appeal_date, request_date)
VALUES (113, TO_DATE('2024-06-20', 'YYYY-MM-DD'), TO_DATE('2024-06-10', 'YYYY-MM-DD'));

INSERT INTO Appeal_Request (case_id, appeal_date, request_date)
VALUES (114, TO_DATE('2024-04-25', 'YYYY-MM-DD'), TO_DATE('2024-04-15', 'YYYY-MM-DD'));

INSERT INTO Appeal_Request (case_id, appeal_date, request_date)
VALUES (115, TO_DATE('2024-09-25', 'YYYY-MM-DD'), TO_DATE('2024-09-10', 'YYYY-MM-DD'));

INSERT INTO Appeal_Request (case_id, appeal_date, request_date)
VALUES (116, TO_DATE('2024-10-10', 'YYYY-MM-DD'), TO_DATE('2024-09-30', 'YYYY-MM-DD'));



INSERT INTO Writes (writer_id, case_id, appeal_date)
VALUES (1, 103, TO_DATE('2024-08-01', 'YYYY-MM-DD'));

INSERT INTO Writes (writer_id, case_id, appeal_date)
VALUES (2, 104, TO_DATE('2024-06-01', 'YYYY-MM-DD'));

INSERT INTO Writes (writer_id, case_id, appeal_date)
VALUES (3, 105, TO_DATE('2024-07-10', 'YYYY-MM-DD'));

INSERT INTO Writes (writer_id, case_id, appeal_date)
VALUES (4, 106, TO_DATE('2024-08-10', 'YYYY-MM-DD'));

INSERT INTO Writes (writer_id, case_id, appeal_date)
VALUES (5, 107, TO_DATE('2024-09-01', 'YYYY-MM-DD'));

INSERT INTO Writes (writer_id, case_id, appeal_date)
VALUES (6, 108, TO_DATE('2024-09-15', 'YYYY-MM-DD'));

INSERT INTO Writes (writer_id, case_id, appeal_date)
VALUES (7, 109, TO_DATE('2024-11-01', 'YYYY-MM-DD'));

INSERT INTO Writes (writer_id, case_id, appeal_date)
VALUES (8, 110, TO_DATE('2024-09-05', 'YYYY-MM-DD'));

INSERT INTO Writes (writer_id, case_id, appeal_date)
VALUES (9, 111, TO_DATE('2024-07-20', 'YYYY-MM-DD'));

INSERT INTO Writes (writer_id, case_id, appeal_date)
VALUES (10, 112, TO_DATE('2024-08-15', 'YYYY-MM-DD'));

INSERT INTO Writes (writer_id, case_id, appeal_date)
VALUES (11, 113, TO_DATE('2024-06-20', 'YYYY-MM-DD'));

INSERT INTO Writes (writer_id, case_id, appeal_date)
VALUES (12, 114, TO_DATE('2024-04-25', 'YYYY-MM-DD'));

INSERT INTO Writes (writer_id, case_id, appeal_date)
VALUES (13, 115, TO_DATE('2024-09-25', 'YYYY-MM-DD'));

INSERT INTO Writes (writer_id, case_id, appeal_date)
VALUES (14, 116, TO_DATE('2024-10-10', 'YYYY-MM-DD'));




-- Insert more data for Representing_What
INSERT INTO Representing_What (representation_client_id, representation_lawyer_id, representation_case_id, complaint_id, role)
VALUES (6, 8, 109, 7, 'Plaintiff');

INSERT INTO Representing_What (representation_client_id, representation_lawyer_id, representation_case_id, complaint_id, role)
VALUES (7, 9, 110, 8, 'Defendant');

INSERT INTO Representing_What (representation_client_id, representation_lawyer_id, representation_case_id, complaint_id, role)
VALUES (8, 10, 111, 8, 'Plaintiff');

INSERT INTO Representing_What (representation_client_id, representation_lawyer_id, representation_case_id, complaint_id, role)
VALUES (9, 11, 112, 6, 'Defendant');

INSERT INTO Representing_What (representation_client_id, representation_lawyer_id, representation_case_id, complaint_id, role)
VALUES (10, 12, 113, 5, 'Plaintiff');

INSERT INTO Representing_What (representation_client_id, representation_lawyer_id, representation_case_id, complaint_id, role)
VALUES (11, 13, 114, 4, 'Defendant');

INSERT INTO Representing_What (representation_client_id, representation_lawyer_id, representation_case_id, complaint_id, role)
VALUES (12, 14, 115, 3, 'Plaintiff');



-- Inserting more case referrals
INSERT INTO Case_Referral (referring_case_id, referred_case_id, referral_date)
VALUES (103, 105, TO_DATE('2024-03-20', 'YYYY-MM-DD'));

INSERT INTO Case_Referral (referring_case_id, referred_case_id, referral_date)
VALUES (106, 109, TO_DATE('2024-06-10', 'YYYY-MM-DD'));

INSERT INTO Case_Referral (referring_case_id, referred_case_id, referral_date)
VALUES (107, 112, TO_DATE('2024-07-25', 'YYYY-MM-DD'));

INSERT INTO Case_Referral (referring_case_id, referred_case_id, referral_date)
VALUES (108, 111, TO_DATE('2024-07-05', 'YYYY-MM-DD'));

INSERT INTO Case_Referral (referring_case_id, referred_case_id, referral_date)
VALUES (109, 113, TO_DATE('2024-08-15', 'YYYY-MM-DD'));

INSERT INTO Case_Referral (referring_case_id, referred_case_id, referral_date)
VALUES (110, 115, TO_DATE('2024-05-10', 'YYYY-MM-DD'));

INSERT INTO Case_Referral (referring_case_id, referred_case_id, referral_date)
VALUES (111, 116, TO_DATE('2024-06-20', 'YYYY-MM-DD'));

INSERT INTO Case_Referral (referring_case_id, referred_case_id, referral_date)
VALUES (112, 105, TO_DATE('2024-06-25', 'YYYY-MM-DD'));

INSERT INTO Case_Referral (referring_case_id, referred_case_id, referral_date)
VALUES (113, 107, TO_DATE('2024-04-05', 'YYYY-MM-DD'));

INSERT INTO Case_Referral (referring_case_id, referred_case_id, referral_date)
VALUES (114, 110, TO_DATE('2024-03-18', 'YYYY-MM-DD'));

INSERT INTO Case_Referral (referring_case_id, referred_case_id, referral_date)
VALUES (115, 106, TO_DATE('2024-09-01', 'YYYY-MM-DD'));

INSERT INTO Case_Referral (referring_case_id, referred_case_id, referral_date)
VALUES (116, 108, TO_DATE('2024-09-05', 'YYYY-MM-DD'));
