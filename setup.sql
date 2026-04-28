drop database if exists Ticket_Booking;
create database Ticket_Booking;
use Ticket_Booking;



-- User table
create table  User (
    UserID INT AUTO_INCREMENT PRIMARY KEY not null,
    User_name VARCHAR(100) NOT NULL,
    Email_id VARCHAR(100) UNIQUE not null,
    Mobile_No VARCHAR(15) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    login_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Wallet table
create table Wallet (
    Wallet_id INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT UNIQUE,
    Balance DECIMAL(10,2) default 0,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

-- Train_Category table
create table Train_Category (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    Train_Category ENUM('Local', 'Express', 'Superfast') NOT NULL
);

-- Train table
create table Train (
    TrainID INT AUTO_INCREMENT PRIMARY KEY,
    Train_Name ENUM('Mumbai Express', 'Navi Mumbai Local') NOT NULL,
    Train_Number VARCHAR(10) UNIQUE NOT NULL,
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Train_Category(CategoryID)
);

-- Station table
create table Station (
    StationID INT AUTO_INCREMENT PRIMARY KEY,
    Station_Name VARCHAR(90) NOT NULL,
    Station_Code VARCHAR(10) UNIQUE,
    Latitude DECIMAL(9,6),
    Longitude DECIMAL(9,6)
);

-- Route table
create table Route (
    RouteID INT AUTO_INCREMENT PRIMARY KEY,
    TrainID INT,
    SourceStationID INT,
    DestinationStationID INT,
    Distance_km DECIMAL(6,2),
    Departure_Time DATETIME,
    Arrival_Time DATETIME,
    FOREIGN KEY (TrainID) REFERENCES Train(TrainID),
    FOREIGN KEY (SourceStationID) REFERENCES Station(StationID),
    FOREIGN KEY (DestinationStationID) REFERENCES Station(StationID)
);

-- Route_Stations table
create table Route_Stations (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    RouteID INT,
    StationID INT,
    Sequence_No INT,
    Arrival_Time DATETIME,
    Departure_Time DATETIME,
    FOREIGN KEY (RouteID) REFERENCES Route(RouteID),
    FOREIGN KEY (StationID) REFERENCES Station(StationID)
);

-- Ticket table
create table Ticket (
    TicketID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    Wallet_id INT,
    RouteID INT,
    Ticket_Type ENUM('normal','return','platform','season'),
    Ticket_Mode ENUM('paper','digital'),
    Journey_Date DATE,
    Ticket_Price DECIMAL(10,2),
    Status ENUM('pending' ,'active','used','cancelled','expired'),
    QR_Code TEXT,
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (Wallet_id) REFERENCES Wallet(Wallet_id),
    FOREIGN KEY (RouteID) REFERENCES Route(RouteID)
);

-- Payment table
create table Payment (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    TicketID INT,
    UserID INT,
    Amount DECIMAL(10,2),
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Method VARCHAR(20),
    Status ENUM('Success','Failed','Pending'),
    FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

-- Quick_Booking table
create table Quick_Booking (
    QuickBookingID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    TicketID INT,
    Booking_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID)
);

-- Feedback table
create table Feedback (
    FeedbackID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    Comment TEXT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

-- Season_Ticket table
create table Season_Ticket (
    SeasonTicketID INT AUTO_INCREMENT PRIMARY KEY,
    TicketID INT UNIQUE,
    Start_Date DATE,
    End_Date DATE,
    FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID)
);

-- QR_Booking table
create table QR_Booking (
    QRBookingID INT AUTO_INCREMENT PRIMARY KEY,
    TicketID INT UNIQUE,
    QR_Scanned TIMESTAMP,
    FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID)
);

