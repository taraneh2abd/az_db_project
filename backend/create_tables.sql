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
  complaint_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  case_id INT,
  plaintiff_id INT,
  defendant_id INT,
  complaint_date DATE,
  description VARCHAR2(4000),
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
  evidence_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  case_id INT,
  description VARCHAR2(4000),
  evidence_type VARCHAR2(50) CHECK (evidence_type IN ('Other', 'Digital Document', 'Written', 'Testimony')),
  date_submitted DATE,
  FOREIGN KEY (case_id) REFERENCES Cases(case_id)
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


CREATE TABLE Represents_What (
  client_id INT,
  lawyer_id INT,
  case_id INT,
  party_id INT,
  role VARCHAR2(50) CHECK (role IN ('Plaintiff', 'Defendant')) NOT NULL,
  PRIMARY KEY (client_id, lawyer_id, case_id, party_id, role),
  FOREIGN KEY (client_id, lawyer_id, case_id) REFERENCES Representation(client_id, lawyer_id, case_id),
  FOREIGN KEY (party_id) REFERENCES Involved_Party(party_id)
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

CREATE TABLE Representing_Who (
  client_id INT,
  lawyer_id INT,
  case_id INT,
  party_id INT,
  PRIMARY KEY (client_id, lawyer_id, case_id, party_id),
  FOREIGN KEY (client_id, lawyer_id, case_id) REFERENCES Representation(client_id, lawyer_id, case_id),
  FOREIGN KEY (party_id) REFERENCES Involved_Party(party_id)
);