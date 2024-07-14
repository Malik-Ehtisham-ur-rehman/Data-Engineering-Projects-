CREATE TABLE banks (
    Rank_No INT,
    Bank_name VARCHAR(255),
    Total_assets DECIMAL(15, 2)
);

LOAD DATA INFILE 'D:/data.csv'
INTO TABLE banks
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(Rank_No, Bank_name, @Total_assets)
SET Total_assets = REPLACE(REPLACE(@Total_assets, '$', ''), ',', '') + 0.0;



SELECT * FROM banks;

SELECT * FROM banks
ORDER BY Total_assets DESC
LIMIT 10;


SELECT COUNT(*) AS total_banks FROM banks;


SELECT SUM(Total_assets) AS total_assets FROM banks;

SELECT AVG(Total_assets) AS average_assets FROM banks;


SELECT * FROM banks
WHERE Total_assets > 3000;  

SELECT * FROM banks
ORDER BY Total_assets DESC
LIMIT 10 OFFSET 10;


SELECT * FROM banks
WHERE ABS(Total_assets - (SELECT AVG(Total_assets) FROM banks)) < 500;  


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

