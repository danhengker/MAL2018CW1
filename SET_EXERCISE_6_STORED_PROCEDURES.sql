--SET EXERCISE 6: STORED PROCEDURES(CRUD)

--Insertion procedure
CREATE PROCEDURE CW1.Trail_Insert
    @TrailName VARCHAR(60),
    @Length DECIMAL(6,2),
    @Difficulty VARCHAR(20),
    @Elevation FLOAT,
    @Time DECIMAL(10,2),
    @RouteTypeID INT
AS
BEGIN
    -- Ensures the FK reference exists before inserting
    IF NOT EXISTS (SELECT 1 FROM CW1.RouteType WHERE RouteType_ID = @RouteTypeID)
    BEGIN
        RAISERROR('Error: RouteType ID does not exist.', 16, 1)
        RETURN
    END

    INSERT INTO CW1.Trail (
        Trail_Name, Trail_Length, Trail_Difficulty, Elevation_Gain, Estimation_Time, RouteType_ID
    )
    VALUES (
        @TrailName, @Length, @Difficulty, @Elevation, @Time, @RouteTypeID
    );

    -- Return the newly created Trail_ID (useful for applications)
    SELECT SCOPE_IDENTITY() AS New_Trail_ID;
END
GO

--Read Procedure
CREATE PROCEDURE CW1.Trail_Read
    @TrailID INT = NULL
AS
BEGIN
    SELECT 
        T.Trail_ID, 
        T.Trail_Name, 
        T.Trail_Length, 
        T.Trail_Difficulty, 
        T.Elevation_Gain, 
        T.Estimation_Time, 
        R.RouteType_Name
    FROM CW1.Trail T
    JOIN CW1.RouteType R ON T.RouteType_ID = R.RouteType_ID
    WHERE T.Trail_ID = ISNULL(@TrailID, T.Trail_ID);
END
GO

--Update Procedure
CREATE PROCEDURE CW1.Trail_Update
    @TrailID INT,
    @TrailName VARCHAR(60),
    @Length DECIMAL(6,2),
    @Difficulty VARCHAR(20),
    @Elevation FLOAT,
    @Time DECIMAL(10,2),
    @RouteTypeID INT
AS
BEGIN
    -- Assure the existence of trail table
    IF NOT EXISTS (SELECT 1 FROM CW1.Trail WHERE Trail_ID = @TrailID)
    BEGIN
        RAISERROR('Error: Trail ID not found.', 16, 1)
        RETURN
    END

    -- Assure new RouteType exist
    IF NOT EXISTS (SELECT 1 FROM CW1.RouteType WHERE RouteType_ID = @RouteTypeID)
    BEGIN
        RAISERROR('Error: RouteType ID does not exist.', 16, 1)
        RETURN
    END

    UPDATE CW1.Trail
    SET
        Trail_Name = @TrailName,
        Trail_Length = @Length,
        Trail_Difficulty = @Difficulty,
        Elevation_Gain = @Elevation,
        Estimation_Time = @Time,
        RouteType_ID = @RouteTypeID
    WHERE Trail_ID = @TrailID;
END

--Delete Procedure
CREATE PROCEDURE CW1.Trail_Delete
    @TrailID INT
AS
BEGIN
    -- Record check in HikeLog and TrailLandmark
    IF EXISTS (SELECT 1 FROM CW1.HikeLog WHERE Trail_ID = @TrailID)
    BEGIN
        RAISERROR('Error: Cannot delete trail; dependent hike logs exist.', 16, 1)
        RETURN
    END
    
    IF EXISTS (SELECT 1 FROM CW1.TrailLandmark WHERE Trail_ID = @TrailID)
    BEGIN
        RAISERROR('Error: Cannot delete trail; dependent landmark associations exist.', 16, 1)
        RETURN
    END

    -- If no dependencies found, proceed with deletion
    DELETE FROM CW1.Trail
    WHERE Trail_ID = @TrailID;
END
GO