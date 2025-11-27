--SET EXERCISE 5: VIEW
--Merging table from table Trail, RouteType and aggregation of HikeLog
CREATE VIEW CW1.Web_Trail_Summary
AS
SELECT
    T.Trail_ID,
    T.Trail_Name,
    T.Trail_Length,
    R.RouteType_Name, 
    T.Trail_Difficulty,
    T.Elevation_Gain,
    T.Estimation_Time,

    -- Aggregate Data from HikeLog
    AVG(H.Rating * 1.0) AS Average_Rating, -- Use * 1.0 for floating point average
    COUNT(H.HikeLog_ID) AS Total_Hikes
FROM CW1.Trail T
JOIN CW1.RouteType R 
    ON T.RouteType_ID = R.RouteType_ID
LEFT JOIN CW1.HikeLog H 
    ON T.Trail_ID = H.Trail_ID
GROUP BY
    T.Trail_ID, T.Trail_Name, T.Trail_Length, R.RouteType_Name, T.Trail_Difficulty, 
    T.Elevation_Gain, T.Estimation_Time;

--View Verification SQL
SELECT * FROM CW1.Web_Trail_Summary;

--demonstrate view is queryable
SELECT 
    Trail_Name,
    Trail_Length,
    RouteType_Name,
    Average_Rating
FROM CW1.Web_Trail_Summary
WHERE Trail_Difficulty = 'Moderate'
ORDER BY Average_Rating DESC;
