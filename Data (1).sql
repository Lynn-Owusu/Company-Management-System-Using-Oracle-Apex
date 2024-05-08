-- Insert data into the Roles table
INSERT INTO Roles (RoleName) VALUES ('Administrator');
INSERT INTO Roles (RoleName) VALUES ('HR manager');
INSERT INTO Roles (RoleName) VALUES ('Department manager');
INSERT INTO Roles (RoleName) VALUES ('Employee');

-- Insert data into the Users table
INSERT INTO Users (Username, PasswordHash, RoleID) VALUES ('admin', 'admin123', 1);
INSERT INTO Users (Username, PasswordHash, RoleID) VALUES ('hrmanager', 'hr123', 2);
INSERT INTO Users (Username, PasswordHash, RoleID) VALUES ('deptmanager', 'dept123', 3);
INSERT INTO Users (Username, PasswordHash, RoleID) VALUES ('employee1', 'emp123', 4);
INSERT INTO Users (Username, PasswordHash, RoleID) VALUES ('employee2', 'emp456', 4);

-- Insert data into the Skills table
INSERT INTO Skills (SkillName) VALUES ('Java');
INSERT INTO Skills (SkillName) VALUES ('Python');
INSERT INTO Skills (SkillName) VALUES ('JavaScript');
INSERT INTO Skills (SkillName) VALUES ('SQL');

-- Insert data into the Departments table
INSERT INTO Departments (DepartmentName, ManagerID) VALUES ('Engineering', 3);
INSERT INTO Departments (DepartmentName, ManagerID) VALUES ('Human Resources', 2);
INSERT INTO Departments (DepartmentName, ManagerID) VALUES ('Sales', 4);

-- Insert data into the Employees table
INSERT INTO Employees (FirstName, LastName, Email, DepartmentID, Position, HireDate, HourlyRate) VALUES ('John', 'Doe', 'john.doe@example.com', 1, 'Manager', TO_DATE('2022-01-01', 'YYYY-MM-DD'), 30.00);
INSERT INTO Employees (FirstName, LastName, Email, DepartmentID, Position, HireDate, HourlyRate) VALUES ('Jane', 'Smith', 'jane.smith@example.com', 2, 'Employee', TO_DATE('2022-01-02', 'YYYY-MM-DD'), 25.00);

-- Insert data into the EmployeeSkills table
INSERT INTO EmployeeSkills (EmployeeID, SkillID) VALUES (1, 1);
INSERT INTO EmployeeSkills (EmployeeID, SkillID) VALUES (1, 3);
INSERT INTO EmployeeSkills (EmployeeID, SkillID) VALUES (2, 2);
INSERT INTO EmployeeSkills (EmployeeID, SkillID) VALUES (2, 3);

-- Insert data into the Education table
INSERT INTO Education (EmployeeID, Degree, Institution, YearOfCompletion) VALUES (1, 'MBA', 'University of XYZ', 2021);
INSERT INTO Education (EmployeeID, Degree, Institution, YearOfCompletion) VALUES (2, 'BSc', 'University of ABC', 2022);

-- Insert data into the Communication table
INSERT INTO Communication (SenderID, ReceiverID, Message, TimeStamp) VALUES (1, 2, 'Hello Jane, how are you?', CURRENT_TIMESTAMP);
INSERT INTO Communication (SenderID, ReceiverID, Message, TimeStamp) VALUES (2, 1, 'Hi John, I''m doing well. Thanks!', CURRENT_TIMESTAMP);

-- Insert data into the VacationStatus table
INSERT INTO VacationStatus (StatusName) VALUES ('Approved');
INSERT INTO VacationStatus (StatusName) VALUES ('Pending');

-- Insert data into the Vacations table
INSERT INTO Vacations (EmployeeID, StartDate, EndDate, Reason, StatusID) VALUES (1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2022-01-02', 'YYYY-MM-DD'), 'Vacation trip', 1);
INSERT INTO Vacations (EmployeeID, StartDate, EndDate, Reason, StatusID) VALUES (2, TO_DATE('2022-01-03', 'YYYY-MM-DD'), TO_DATE('2022-01-04', 'YYYY-MM-DD'), 'Family event', 2);

-- Insert data into the Evaluations table
INSERT INTO Evaluations (EmployeeID, EvaluationDate, Score, Comments) VALUES (1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 90, 'Good performance');
INSERT INTO Evaluations (EmployeeID, EvaluationDate, Score, Comments) VALUES (2, TO_DATE('2022-01-02', 'YYYY-MM-DD'), 95, 'Excellent work');

-- Insert data into the Trainings table
INSERT INTO Trainings (TrainingName, StartDate, EndDate) VALUES ('Management Skills', TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2022-01-02', 'YYYY-MM-DD'));
INSERT INTO Trainings (TrainingName, StartDate, EndDate) VALUES ('Communication Skills', TO_DATE('2022-01-03', 'YYYY-MM-DD'), TO_DATE('2022-01-04', 'YYYY-MM-DD'));

-- Insert data into the EmployeeTrainings table
INSERT INTO EmployeeTrainings (EmployeeID, TrainingID, CompletionDate) VALUES (1, 1, TO_DATE('2022-01-02', 'YYYY-MM-DD'));
INSERT INTO EmployeeTrainings (EmployeeID, TrainingID, CompletionDate) VALUES (2, 2, TO_DATE('2022-01-04', 'YYYY-MM-DD'));

-- Insert data into the Attendance table
INSERT INTO Attendance (EmployeeID, AttendanceDate, HoursWorked, Status) VALUES (1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 8, 'Present');
INSERT INTO Attendance (EmployeeID, AttendanceDate, HoursWorked, Status) VALUES (2, TO_DATE('2022-01-02', 'YYYY-MM-DD'), 8, 'Present');

-- Complete the last INSERT into the Salaries table
INSERT INTO Salaries (EmployeeID, Amount, PaymentDate) VALUES (2, 200.00, TO_DATE('2022-01-02', 'YYYY-MM-DD'));

-- Complete the calculate_salary procedure calls
DECLARE 
    v_employee_id NUMBER;
BEGIN
    SELECT EmployeeID INTO v_employee_id FROM Employees WHERE FirstName = 'John' AND LastName = 'Doe';
    calculate_salary(v_employee_id, TO_DATE('2022-01-01', 'YYYY-MM-DD'));
    
    SELECT EmployeeID INTO v_employee_id FROM Employees WHERE FirstName = 'Jane' AND LastName = 'Smith';
    calculate_salary(v_employee_id, TO_DATE('2022-01-02', 'YYYY-MM-DD'));
    
    -- Remove the COMMIT statement
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;