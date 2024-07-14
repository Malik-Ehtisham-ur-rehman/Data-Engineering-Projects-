-- Create a table named 'banks' with columns for rank, bank name, and total assets
CREATE TABLE banks (
    Rank_No INT,  -- Column to store the rank number of the bank
    Bank_name VARCHAR(255),  -- Column to store the name of the bank
    Total_assets DECIMAL(15, 2)  -- Column to store the total assets of the bank, allowing for up to 15 digits and 2 decimal places
);

-- Load data from a CSV file into the 'banks' table
LOAD DATA INFILE 'D:/data.csv'
INTO TABLE banks
FIELDS TERMINATED BY ','  -- Fields in the CSV are separated by commas
ENCLOSED BY '"'  -- Fields in the CSV are enclosed by double quotes
LINES TERMINATED BY '\r\n'  -- Lines in the CSV are terminated by a carriage return and newline
IGNORE 1 ROWS  -- Skip the first row (header row) in the CSV file
(Rank_No, Bank_name, @Total_assets)  -- Load data into these columns
SET Total_assets = REPLACE(REPLACE(@Total_assets, '$', ''), ',', '') + 0.0;  -- Remove dollar signs and commas from total assets and convert to a decimal

-- Select all columns from the 'banks' table
SELECT * FROM banks;

-- Select all columns from the 'banks' table and order by total assets in descending order, limit to the top 10 rows
SELECT * FROM banks
ORDER BY Total_assets DESC
LIMIT 10;

-- Count the total number of banks in the 'banks' table
SELECT COUNT(*) AS total_banks FROM banks;

-- Calculate the sum of total assets for all banks in the 'banks' table
SELECT SUM(Total_assets) AS total_assets FROM banks;

-- Calculate the average total assets for all banks in the 'banks' table
SELECT AVG(Total_assets) AS average_assets FROM banks;

-- Select all columns from the 'banks' table where total assets are greater than 3000
SELECT * FROM banks
WHERE Total_assets > 3000;  

-- Select all columns from the 'banks' table and order by total assets in descending order, limit to the rows 11-20
SELECT * FROM banks
ORDER BY Total_assets DESC
LIMIT 10 OFFSET 10;

-- Select all columns from the 'banks' table where total assets are within 500 of the average total assets
SELECT * FROM banks
WHERE ABS(Total_assets - (SELECT AVG(Total_assets) FROM banks)) < 500;  

-- Group banks by asset range and count the number of banks in each range
SELECT 
    CASE 
        WHEN Total_assets < 1000 THEN '< $1 Trillion'
        WHEN Total_assets BETWEEN 1000 AND 2000 THEN '$1 - $2 Trillion'
        WHEN Total_assets BETWEEN 2000 AND 3000 THEN '$2 - $3 Trillion'
        WHEN Total_assets BETWEEN 3000 AND 4000 THEN '$3 - $4 Trillion'
        WHEN Total_assets BETWEEN 4000 AND 5000 THEN '$4 - $5 Trillion'
        ELSE '> $5 Trillion'
    END AS asset_range,
    COUNT(*) AS count
FROM banks
GROUP BY asset_range;
