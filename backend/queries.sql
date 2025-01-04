--query1

-- SELECT Complaint.case_id, Involved_Party.first_name AS plaintiff_first_name, Involved_Party.last_name AS plaintiff_last_name,
--        Involved_Party_2.first_name AS defendant_first_name, Involved_Party_2.last_name AS defendant_last_name
-- FROM Complaint
-- INNER JOIN Involved_Party ON Complaint.plaintiff_id = Involved_Party.party_id
-- INNER JOIN Involved_Party AS Involved_Party_2 ON Complaint.defendant_id = Involved_Party_2.party_id;


--query2

SELECT Cases.case_id, Cases.case_type, Appeal.appeal_date, Appeal.reason
FROM Cases
LEFT JOIN Appeal ON Cases.case_id = Appeal.case_id;


--qurery3
SELECT Appeal.case_id, Appeal.appeal_date, Appeal.reason, Cases.case_type
FROM Appeal
RIGHT JOIN Cases ON Appeal.case_id = Cases.case_id;


--query4
-- SELECT Representation.client_id, Involved_Party.first_name AS client_first_name, Involved_Party.last_name AS client_last_name,
--        Representation.lawyer_id, Involved_Party_2.first_name AS lawyer_first_name, Involved_Party_2.last_name AS lawyer_last_name
-- FROM Representation
-- FULL OUTER JOIN Involved_Party ON Representation.client_id = Involved_Party.party_id
-- FULL OUTER JOIN Involved_Party AS Involved_Party_2 ON Representation.lawyer_id = Involved_Party_2.party_id;


--query5
SELECT p1.first_name AS party_1_first_name, p1.last_name AS party_1_last_name, p2.first_name AS party_2_first_name, p2.last_name AS party_2_last_name, c.case_id, c.case_type
FROM Involved_Party p1
INNER JOIN Role_Assignment r1 ON p1.party_id = r1.party_id
INNER JOIN Cases c ON r1.case_id = c.case_id
INNER JOIN Role_Assignment r2 ON c.case_id = r2.case_id
INNER JOIN Involved_Party p2 ON r2.party_id = p2.party_id
WHERE p1.party_id != p2.party_id;


--query6
-- SELECT Session.case_id, Session.session_date, Session.summary, Court_Branch.court_name, Court_Branch.court_type
-- FROM Session
-- INNER JOIN Court_Branch ON Session.court_branch = Court_Branch.court_id;


--query7
SELECT Involved_Party.first_name, Involved_Party.last_name, Role_Assignment.role, Role_Assignment.case_id
FROM Involved_Party
LEFT JOIN Role_Assignment ON Involved_Party.party_id = Role_Assignment.party_id;

--query8
-- SELECT
--     ip.first_name AS party_first_name,
--     ip.last_name AS party_last_name,
--     ip.is_juridical,
--     c.case_id,
--     c.case_type,
--     r.start_date AS representation_start_date,
--     r.end_date AS representation_end_date,
--     r.client_id,
--     r.lawyer_id,
--     l.first_name AS lawyer_first_name,
--     l.last_name AS lawyer_last_name
-- FROM
--     Complaint AS cp
-- JOIN Involved_Party AS ip ON ip.party_id = cp.plaintiff_id OR ip.party_id = cp.defendant_id
-- JOIN Cases AS c ON c.case_id = cp.case_id
-- JOIN Representation AS r ON (r.client_id = ip.party_id AND r.case_id = c.case_id)
-- JOIN Involved_Party AS l ON l.party_id = r.lawyer_id
-- ORDER BY
--     c.case_id, ip.party_id;


--query9
SELECT Evidence.case_id, Evidence.description, Evidence.evidence_type, Evidence.date_submitted, 
       Involved_Party.first_name, Involved_Party.last_name
FROM Evidence
FULL OUTER JOIN Person_Evidence_Relation ON Evidence.case_id = Person_Evidence_Relation.evidence_id
FULL OUTER JOIN Involved_Party ON Person_Evidence_Relation.person_id = Involved_Party.party_id;

--query10
SELECT r1.client_id AS plaintiff_client_id, r2.client_id AS defendant_client_id, r1.lawyer_id, Involved_Party.first_name AS lawyer_first_name, Involved_Party.last_name AS lawyer_last_name
FROM Representation r1
INNER JOIN Representation r2 ON r1.lawyer_id = r2.lawyer_id
INNER JOIN Involved_Party ON r1.lawyer_id = Involved_Party.party_id
WHERE r1.client_id != r2.client_id;


SELECT *
FROM Court_Session
WHERE 
  session_date BETWEEN TO_DATE('2000-12-31', 'YYYY-MM-DD') AND TO_DATE('2025-12-31', 'YYYY-MM-DD')
  AND court_name = 'Central Court';



DELIMITER $$

CREATE PROCEDURE RegisterComplaint(
    IN p_case_id INT,
    IN p_plaintiff_id INT,
    IN p_defendant_id INT,
    IN p_complaint_date DATE,
    IN p_description TEXT,
    IN p_case_type VARCHAR(50),
    IN p_status VARCHAR(50)
)
BEGIN
    DECLARE v_status VARCHAR(50);
    
    INSERT INTO Complaint(case_id, plaintiff_id, defendant_id, complaint_date, description)
    VALUES (p_case_id, p_plaintiff_id, p_defendant_id, p_complaint_date, p_description);
    
    INSERT INTO Accuses(party_id, complaint_id, role)
    VALUES (p_plaintiff_id, p_case_id, 'Accuser'),
           (p_defendant_id, p_case_id, 'Accused');
    
    UPDATE Cases
    SET case_type = p_case_type, status = p_status
    WHERE case_id = p_case_id;

    SELECT * FROM Cases WHERE case_id = p_case_id;
    
END$$

DELIMITER ;


SELECT
    ip.party_id AS involved_party_id,
    ip.first_name AS involved_party_first_name,
    ip.last_name AS involved_party_last_name,
    c.case_id,
    c.case_type,
    c.description,
    v.date_issued AS verdict_date,
    v.verdict_type,
    v.summary AS verdict_summary
FROM
    Involved_Party ip
INNER JOIN
    Role_Assignment ra ON ip.party_id = ra.party_id
INNER JOIN
    Cases c ON ra.case_id = c.case_id
LEFT JOIN
    Verdict v ON c.case_id = v.case_id

                WHERE i.party_id = 1

SELECT *
FROM Court_Session
WHERE

              session_date BETWEEN 2003-01-17 AND 2027-10-30
              AND court_name = 'High Court'

SELECT *
FROM Court_Session
WHERE 
    session_date BETWEEN TO_DATE('2003-01-17', 'YYYY-MM-DD') 
    AND TO_DATE('2027-10-30', 'YYYY-MM-DD')
    AND court_name = 'High Court'
