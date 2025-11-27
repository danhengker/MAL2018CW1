--SET EXERCISE 7: TRIGGER
CREATE TABLE CW1.TrailLog (
    Log_ID INT IDENTITY(1,1) PRIMARY KEY,
    Trail_ID_Added INT NOT NULL,
    Trail_Name_Added VARCHAR(60) NOT NULL,
    Added_By VARCHAR(128) NOT NULL, -- To store the database user/login name
    Log_Timestamp DATETIME DEFAULT GETDATE()
);
GO

CREATE TRIGGER CW1.trg_Log_NewTrail
ON CW1.Trail
AFTER INSERT
AS
BEGIN
    -- Prevention for the trigger from doing unnecessary work if no rows inserted
    IF @@ROWCOUNT = 0 
        RETURN;
    
    -- The INSERTED pseudo-table contains the data for the new row(s)
    INSERT INTO CW1.TrailLog (
        Trail_ID_Added,
        Trail_Name_Added,
        Added_By,
        Log_Timestamp
    )
    SELECT
        i.Trail_ID,
        i.Trail_Name,
        SUSER_SNAME(), -- SQL Server system function to capture the user who ran the query
        GETDATE()      -- SQL Server function for the current date and time
    FROM inserted i;
END
GO 

--New trail insertion using TRIGGER
EXEC CW1.Trail_Insert 
    @TrailName = 'Observation Point Loop', 
    @Length = 4.00, 
    @Difficulty = 'Moderate', 
    @Elevation = 600.0, 
    @Time = 2.00, 
    @RouteTypeID = 1;

GO