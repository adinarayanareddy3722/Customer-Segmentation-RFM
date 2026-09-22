CREATE DATABASE retail_db;
USE retail_db;


Select * from  retail_data;

SELECT COUNT(DISTINCT CustomerID) AS ActiveCustomers
FROM retail_data;

WITH RecencyCTE AS (
    SELECT 
        CustomerID,
        DATEDIFF(CURRENT_DATE(), MAX(STR_TO_DATE(InvoiceDate, '%m/%d/%Y'))) AS Recency
    FROM retail_data
    GROUP BY CustomerID
),
FrequencyCTE AS (
    SELECT 
        CustomerID,
        COUNT(*) AS Frequency
    FROM retail_data
    GROUP BY CustomerID
),
MonetaryCTE AS (
    SELECT 
        CustomerID,
        SUM(Quantity * UnitPrice) AS Monetary
    FROM retail_data
    GROUP BY CustomerID
)
SELECT 
    R.CustomerID,
    R.Recency,
    F.Frequency,
    M.Monetary
FROM 
    RecencyCTE R
JOIN 
    FrequencyCTE F ON R.CustomerID = F.CustomerID
JOIN 
    MonetaryCTE M ON R.CustomerID = M.CustomerID
ORDER BY 
    R.Recency ASC, F.Frequency DESC, M.Monetary DESC;
    
WITH RecencyCTE AS (
    SELECT 
        CustomerID,
        DATEDIFF(CURRENT_DATE(), MAX(STR_TO_DATE(InvoiceDate, '%m/%d/%Y'))) AS Recency
    FROM retail_data
    GROUP BY CustomerID
),
FrequencyCTE AS (
    SELECT 
        CustomerID,
        COUNT(*) AS Frequency
    FROM retail_data
    GROUP BY CustomerID
),
MonetaryCTE AS (
    SELECT 
        CustomerID,
        SUM(Quantity * UnitPrice) AS Monetary
    FROM retail_data
    GROUP BY CustomerID
),
RFM_Calculation AS (
    SELECT 
        R.CustomerID,
        -- LOGIC CHANGE: We want 5 to be the BEST score.
        -- Recency: Order DESC so low days (recent) get the highest bin (5).
        NTILE(5) OVER (ORDER BY R.Recency DESC) AS RecencyScore,
        -- Frequency: Order ASC so high freq gets the highest bin (5).
        NTILE(5) OVER (ORDER BY F.Frequency ASC) AS FrequencyScore,
        -- Monetary: Order ASC so high money gets the highest bin (5).
        NTILE(5) OVER (ORDER BY M.Monetary ASC) AS MonetaryScore
    FROM 
        RecencyCTE R
    JOIN 
        FrequencyCTE F ON R.CustomerID = F.CustomerID
    JOIN 
        MonetaryCTE M ON R.CustomerID = M.CustomerID
)
SELECT 
    CustomerID,
    RecencyScore,
    FrequencyScore,
    MonetaryScore,
    (RecencyScore + FrequencyScore + MonetaryScore) AS TotalRFMScore
FROM 
    RFM_Calculation
ORDER BY 
    TotalRFMScore DESC;
    
    
    
    
    
    
    
WITH TotalSales AS (
    SELECT 
        CustomerID,
        -- Calculate Revenue directly here
        SUM(Quantity * UnitPrice) AS TotalSales
    FROM 
        retail_data -- <--- Updated Table Name
    GROUP BY 
        CustomerID
),
DefinedSegments AS (
    SELECT 
        CustomerID,
        CASE 
            WHEN TotalSales >= 2000 THEN 'High Value'
            -- Changed 2000 to 1999 to avoid overlap with the line above
            WHEN TotalSales BETWEEN 800 AND 1999 THEN 'Medium Value' 
            WHEN TotalSales BETWEEN 400 AND 799 THEN 'Low Value'
            ELSE 'Dormant'
        END AS SalesSegment
    FROM 
        TotalSales
)
SELECT 
    SalesSegment,
    COUNT(CustomerID) AS CustomerCount
FROM 
    DefinedSegments
GROUP BY 
    SalesSegment
ORDER BY 
    -- This sorts specific to your desired order
    FIELD(SalesSegment, 'High Value', 'Medium Value', 'Low Value', 'Dormant');