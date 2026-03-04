-- Presons
CREATE TABLE Persons (
    first_name VARCHAR(30) NOT NULL,
    surname VARCHAR(30) NOT NULL,
    phone_number INT PRIMARY KEY NOT NULL
);

-- Car mechanics
CREATE TABLE Mechanics (
    date_of_hiring SMALLDATETIME NOT NULL,
    phone_number INT PRIMARY KEY NOT NULL,
    lay_off_date SMALLDATETIME,
    hourly_wage TINYINT NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE,

    FOREIGN KEY (phone_number) REFERENCES Persons(phone_number)
	ON UPDATE CASCADE ON DELETE CASCADE
);

-- Car models
CREATE TABLE Car_Models (
    model_name VARCHAR(30) PRIMARY KEY NOT NULL,
    make VARCHAR(20) NOT NULL
);

-- Cars
CREATE TABLE Cars (
    year_of_production INT NOT NULL,
    mileage INT NOT NULL,
    registration_number CHAR(7) PRIMARY KEY NOT NULL,
    owners_phone_number INT NOT NULL,
    model_name VARCHAR(30) NOT NULL,

    FOREIGN KEY (owners_phone_number) REFERENCES Persons(phone_number)
	ON UPDATE CASCADE,
    FOREIGN KEY (model_name) REFERENCES Car_Models(model_name)
);

-- Insurers
CREATE TABLE Insurers (
    insurer_name VARCHAR(60) PRIMARY KEY NOT NULL,
    contact_email VARCHAR(254) NOT NULL UNIQUE,
    contact_phone_number INT NOT NULL UNIQUE
);

-- Insurances
CREATE TABLE Insurances (
    insurance_coverage FLOAT NOT NULL,
    insured_registration_number CHAR(7) PRIMARY KEY NOT NULL,
    insurer_name VARCHAR(60) NOT NULL,

    FOREIGN KEY (insured_registration_number) REFERENCES Cars(registration_number),
    FOREIGN KEY (insurer_name) REFERENCES Insurers(insurer_name) ON UPDATE CASCADE
);

-- Repair jobs
CREATE TABLE Jobs (
    return_date SMALLDATETIME NULL,
    roll_in_date SMALLDATETIME NOT NULL,
    work_hours SMALLINT NULL,
    repair_id INT PRIMARY KEY NOT NULL,
    repaired_registration_number CHAR(7) NOT NULL,
    mechanics_phone_number INT NULL,

    FOREIGN KEY (repaired_registration_number) REFERENCES Cars(registration_number),
    FOREIGN KEY (mechanics_phone_number) REFERENCES Mechanics(phone_number) ON UPDATE CASCADE ON DELETE SET NULL
);

-- Invoices
CREATE TABLE Invoices (
    is_paid BIT NOT NULL,
    creation_date SMALLDATETIME NOT NULL,
    invoice_number INT PRIMARY KEY NOT NULL,
    repair_id INT NOT NULL,
    persons_phone_number INT NULL,
    insurer_name VARCHAR(60) NULL,
    FOREIGN KEY (repair_id) REFERENCES Jobs(repair_id),
    FOREIGN KEY (persons_phone_number) REFERENCES Persons(phone_number) ON UPDATE CASCADE,
    FOREIGN KEY (insurer_name) REFERENCES Insurers(insurer_name) ON UPDATE CASCADE
);

-- Part_kinds
CREATE TABLE Part_Kinds (
    id INT PRIMARY KEY NOT NULL,
    part_kind_type VARCHAR(60) NOT NULL,
    manufacturer VARCHAR(30) NOT NULL,
    price MONEY NOT NULL
);

-- Parts
CREATE TABLE Parts (
    in_stock BIT NOT NULL,
    serial_number VARCHAR(30) PRIMARY KEY NOT NULL,
    part_kind_id INT NOT NULL,
    repair_id INT NULL,

    FOREIGN KEY (part_kind_id) REFERENCES Part_Kinds(id),
    FOREIGN KEY (repair_id) REFERENCES Jobs(repair_id)
);

-- Compatibility
CREATE TABLE Compatibility (
    part_kind_id INT NOT NULL,
    model_name VARCHAR(30) NOT NULL,

    FOREIGN KEY (part_kind_id) REFERENCES Part_Kinds(id),
    FOREIGN KEY (model_name) REFERENCES Car_Models(model_name),
    PRIMARY KEY (part_kind_id, model_name)
);

