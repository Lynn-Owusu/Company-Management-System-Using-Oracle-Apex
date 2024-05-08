CREATE TABLE Roles (
    RoleID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    RoleName VARCHAR2(50) NOT NULL
);

CREATE TABLE Users (
    UserID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Username VARCHAR2(100) UNIQUE NOT NULL,
    PasswordHash VARCHAR2(100) NOT NULL,
    RoleID NUMBER NOT NULL,
    EmployeeID NUMBER UNIQUE,
    CONSTRAINT fk_roleid FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

CREATE TABLE Skills (
    SkillID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    SkillName VARCHAR2(100) NOT NULL
);

CREATE TABLE Departments (
    DepartmentID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    DepartmentName VARCHAR2(100) NOT NULL,
    ManagerID NUMBER
);

CREATE TABLE Employees (
    EmployeeID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    FirstName VARCHAR2(100) NOT NULL,
    LastName VARCHAR2(100) NOT NULL,
    Email VARCHAR2(100) UNIQUE NOT NULL,
    DepartmentID NUMBER,
    Position VARCHAR2(100) NOT NULL,
    HireDate DATE NOT NULL,
    HourlyRate DECIMAL(10, 2),  -- Added HourlyRate column
    Photo BLOB,
    CONSTRAINT fk_departmentid FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE EmployeeSkills (
    EmployeeID NUMBER NOT NULL,
    SkillID NUMBER NOT NULL,
    CONSTRAINT pk_empskills PRIMARY KEY (EmployeeID, SkillID),
    CONSTRAINT fk_employeeid FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    CONSTRAINT fk_skillid FOREIGN KEY (SkillID) REFERENCES Skills(SkillID)
);

CREATE TABLE Education (
    EducationID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    EmployeeID NUMBER NOT NULL,
    Degree VARCHAR2(100) NOT NULL,
    Institution VARCHAR2(100) NOT NULL,
    YearOfCompletion NUMBER,
    CONSTRAINT fk_empeducation FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Communication (
    CommunicationID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    SenderID NUMBER NOT NULL,
    ReceiverID NUMBER NOT NULL,
    Message CLOB NOT NULL,
    TimeStamp TIMESTAMP NOT NULL,
    CONSTRAINT fk_senderid FOREIGN KEY (SenderID) REFERENCES Users(UserID),
    CONSTRAINT fk_receiverid FOREIGN KEY (ReceiverID) REFERENCES Users(UserID)
);

CREATE TABLE VacationStatus (
    StatusID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    StatusName VARCHAR2(50) NOT NULL
);

CREATE TABLE Vacations (
    VacationID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    EmployeeID NUMBER NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Reason CLOB,
    StatusID NUMBER NOT NULL,
    CONSTRAINT fk_vacationempid FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    CONSTRAINT fk_statusid FOREIGN KEY (StatusID) REFERENCES VacationStatus(StatusID)
);

CREATE TABLE Evaluations (
    EvaluationID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    EmployeeID NUMBER NOT NULL,
    EvaluationDate DATE NOT NULL,
    Score NUMBER NOT NULL,
    Comments CLOB,
    CONSTRAINT fk_evaluationempid FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Trainings (
    TrainingID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TrainingName VARCHAR2(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL
);

CREATE TABLE EmployeeTrainings (
    EmployeeID NUMBER NOT NULL,
    TrainingID NUMBER NOT NULL,
    CompletionDate DATE,
    CONSTRAINT pk_emptrainings PRIMARY KEY (EmployeeID, TrainingID),
    CONSTRAINT fk_emptrainid FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    CONSTRAINT fk_trainingid FOREIGN KEY (TrainingID) REFERENCES Trainings(TrainingID)
);

CREATE TABLE Attendance (
    AttendanceID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    EmployeeID NUMBER NOT NULL,
    AttendanceDate DATE NOT NULL,
    HoursWorked NUMBER,  -- Added HoursWorked column
    Status VARCHAR2(50) NOT NULL,
    CONSTRAINT fk_attendanceempid FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Salaries (
    SalaryID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    EmployeeID NUMBER NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentDate DATE NOT NULL,
    CONSTRAINT fk_salaryempid FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

CREATE OR REPLACE PROCEDURE calculate_salary(
    p_employee_id IN Employees.EmployeeID%TYPE,
    p_payment_date IN DATE
) AS
    v_hours_worked NUMBER;
    v_hourly_rate DECIMAL(10, 2);
    v_salary NUMBER(10, 2);
BEGIN
    SELECT HourlyRate INTO v_hourly_rate FROM Employees WHERE EmployeeID = p_employee_id;
    SELECT SUM(HoursWorked) INTO v_hours_worked FROM Attendance WHERE EmployeeID = p_employee_id AND AttendanceDate BETWEEN ADD_MONTHS(p_payment_date, -1) AND p_payment_date;

    v_salary := v_hours_worked * v_hourly_rate;

    INSERT INTO Salaries (EmployeeID, Amount, PaymentDate)
    VALUES (p_employee_id, v_salary, p_payment_date);
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END calculate_salary;
