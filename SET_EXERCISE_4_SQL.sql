--EXERCISE 4 : SQL 

CREATE DATABASE MAL2017CW1;
CREATE SCHEMA CW1;

-- 1. User table creation
CREATE TABLE CW1.[User] (
    User_ID INT IDENTITY(1,1) PRIMARY KEY,
    User_Name VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE, -- Constraint: Must be UNIQUE
    PasswordHash VARCHAR(255) NOT NULL
);

-- 2.  RouteType table creation
CREATE TABLE CW1.RouteType (
    RouteType_ID INT IDENTITY(1,1) PRIMARY KEY,
    RouteType_Name VARCHAR(50) NOT NULL
);

-- 3. Landmark table creation
CREATE TABLE CW1.Landmark (
    Landmark_ID INT IDENTITY(1,1) PRIMARY KEY,
    Landmark_Name VARCHAR(50) NOT NULL
);

-- 4. Trail table creation
CREATE TABLE CW1.Trail (
    Trail_ID INT IDENTITY(1,1) PRIMARY KEY,
    Trail_Name VARCHAR(60) NOT NULL,
    Trail_Length DECIMAL(6,2) NOT NULL CHECK (Trail_Length > 0),
    Trail_Difficulty VARCHAR(20),
    Elevation_Gain FLOAT CHECK (Elevation_Gain >= 0),
    Estimation_Time DECIMAL(10,2) CHECK (Estimation_Time >= 0),
    RouteType_ID INT NOT NULL,
    FOREIGN KEY (RouteType_ID) REFERENCES CW1.RouteType(RouteType_ID)
);

-- 5.  HikeLog table creation
CREATE TABLE CW1.HikeLog (
    HikeLog_ID INT IDENTITY(1,1) PRIMARY KEY,
    User_ID INT NOT NULL,
    Trail_ID INT NOT NULL,
    HikeDate DATE NOT NULL,
    Duration DECIMAL(4,2) NOT NULL CHECK (Duration >= 0), -- FDD Constraint
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5), -- FDD Constraint
    FOREIGN KEY (User_ID) REFERENCES CW1.[User](User_ID),
    FOREIGN KEY (Trail_ID) REFERENCES CW1.Trail(Trail_ID)
);

-- 6.  TrailLandmark table creation
CREATE TABLE CW1.TrailLandmark (
    Trail_ID INT NOT NULL,
    Landmark_ID INT NOT NULL,
    FOREIGN KEY (Trail_ID) REFERENCES CW1.Trail(Trail_ID),
    FOREIGN KEY (Landmark_ID) REFERENCES CW1.Landmark(Landmark_ID),
    PRIMARY KEY (Trail_ID, Landmark_ID)
); 
GO

--Data insertion

-- A. Add Data to User
INSERT INTO CW1.[User] (User_Name, Email, PasswordHash) 
VALUES 
('Ada Lovelace', 'ada@plymouth.ac.uk', 'insecurePassword'),
('Tim Berners-Lee', 'tim@plymouth.ac.uk', 'COMP2001!');

-- B. Add Data to RouteType
INSERT INTO CW1.RouteType (RouteType_Name) 
VALUES ('Loop'), ('Out-and-Back'), ('Point-to-Point');

-- C. Add Data to Landmark
INSERT INTO CW1.Landmark (Landmark_Name) 
VALUES ('Big Waterfall'), ('Eagle Peak'), ('Hidden Cave'), ('Old Bridge');

-- D. Add Data to Trail
INSERT INTO CW1.Trail (Trail_Name, Trail_Length, Trail_Difficulty, Elevation_Gain, Estimation_Time, RouteType_ID) 
VALUES 
('Plymbridge Circular', 5.50, 'Moderate', 350.5, 2.50, 1),    -- Loop (ID 1)
('River Walk', 3.20, 'Easy', 50.0, 1.00, 2),          -- Out-and-Back (ID 2)
('Devil''s Staircase', 12.00, 'Hard', 1200.0, 6.50, 1); -- Loop (ID 1)

-- E. Add Data to HikeLog (Linking User and Trail)
-- Ada (User 1) hikes Plymbridge Circular (Trail 1) and River Walk (Trail 2)
INSERT INTO CW1.HikeLog (User_ID, Trail_ID, HikeDate, Duration, Rating) 
VALUES 
(1, 1, '2025-10-05', 2.30, 5), -- Ada: Plymbridge Circular, great rating
(1, 2, '2025-10-12', 1.05, 4); -- Ada: River Walk

-- Tim (User 2) hikes Devil's Staircase (Trail 3)
INSERT INTO CW1.HikeLog (User_ID, Trail_ID, HikeDate, Duration, Rating) 
VALUES 
(2, 3, '2025-10-01', 7.00, 3); -- Tim: Devil's Staircase, average rating

-- F. Add Data to TrailLandmark (Linking Trails to Landmarks)
INSERT INTO CW1.TrailLandmark (Trail_ID, Landmark_ID) 
VALUES 
(1, 2), -- Plymbridge Circular (1) -> Eagle Peak (2)
(1, 4), -- Plymbridge Circular (1) -> Old Bridge (4)
(2, 1), -- River Walk (2) -> Big Waterfall (1)
(3, 2); -- Devil's Staircase (3) -> Eagle Peak (2)

--SQL Queries for validation, usage of JOIN queries 
-- A. Add Data to User
INSERT INTO CW1.[User] (User_Name, Email, PasswordHash) 
VALUES 
('Ada Lovelace', 'ada@plymouth.ac.uk', 'insecurePassword'),
('Tim Berners-Lee', 'tim@plymouth.ac.uk', 'COMP2001!');

-- B. Add Data to RouteType
INSERT INTO CW1.RouteType (RouteType_Name) 
VALUES ('Loop'), ('Out-and-Back'), ('Point-to-Point');

-- C. Add Data to Landmark
INSERT INTO CW1.Landmark (Landmark_Name) 
VALUES ('Big Waterfall'), ('Eagle Peak'), ('Hidden Cave'), ('Old Bridge');

-- D. Add Data to Trail
INSERT INTO CW1.Trail (Trail_Name, Trail_Length, Trail_Difficulty, Elevation_Gain, Estimation_Time, RouteType_ID) 
VALUES 
('Plymbridge Circular', 5.50, 'Moderate', 350.5, 2.50, 1),    -- Loop (ID 1)
('River Walk', 3.20, 'Easy', 50.0, 1.00, 2),          -- Out-and-Back (ID 2)
('Devil''s Staircase', 12.00, 'Hard', 1200.0, 6.50, 1); -- Loop (ID 1)

-- E. Add Data to HikeLog (Linking User and Trail)
-- Ada (User 1) hikes Plymbridge Circular (Trail 1) and River Walk (Trail 2)
INSERT INTO CW1.HikeLog (User_ID, Trail_ID, HikeDate, Duration, Rating) 
VALUES 
(1, 1, '2025-10-05', 2.30, 5), -- Ada: Plymbridge Circular, great rating
(1, 2, '2025-10-12', 1.05, 4); -- Ada: River Walk

-- Tim (User 2) hikes Devil's Staircase (Trail 3)
INSERT INTO CW1.HikeLog (User_ID, Trail_ID, HikeDate, Duration, Rating) 
VALUES 
(2, 3, '2025-10-01', 7.00, 3); -- Tim: Devil's Staircase, average rating

-- F. Add Data to TrailLandmark (Linking Trails to Landmarks)
INSERT INTO CW1.TrailLandmark (Trail_ID, Landmark_ID) 
VALUES 
(1, 2), -- Plymbridge Circular (1) -> Eagle Peak (2)
(1, 4), -- Plymbridge Circular (1) -> Old Bridge (4)
(2, 1), -- River Walk (2) -> Big Waterfall (1)
(3, 2); -- Devil's Staircase (3) -> Eagle Peak (2)
GO

SELECT 
    T.Trail_Name, 
    L.Landmark_Name
FROM CW1.TrailLandmark TL
JOIN CW1.Trail T ON TL.Trail_ID = T.Trail_ID
JOIN CW1.Landmark L ON TL.Landmark_ID = L.Landmark_ID
WHERE T.Trail_Name = 'Plymbridge Circular';
