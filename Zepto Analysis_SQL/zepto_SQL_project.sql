drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC (8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

--DATA EXPLORATION

--COUNT OF ROWS

SELECT COUNT(*) FROM zepto;

--SAMPLE DATA

SELECT * FROM zepto
LIMIT 10;

--NULL VALUES

SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
weightingms IS NULL
OR
outofstock IS NULL
OR
quantity IS NULL;

--DIFFERENT PRODUCT CATEGORIES

SELECT DISTINCT category
FROM zepto
ORDER BY category;

--STOCK OF PRODUCTS

SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

--PRODUCT NAMES PRESENT MULTIPLE TIMES

SELECT name, COUNT(sku_id) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) >1
ORDER BY COUNT(sku_id) DESC;

--DATA CLEANING

--PRODUCTS WITH PRICE = 0

SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--CONVERTING PRICE IN PAISE TO RUPEES

UPDATE zepto
SET  mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp,discountedSellingPrice FROM zepto;

--TOP 10 BEST VALUE PRODUCTS BASED ON DISCOUNT

SELECT DISTINCT name,mrp,discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

--HIGH MRP PRODUCT BUT OUT OF STOCK

SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock = True AND mrp > 300
ORDER BY mrp DESC;

--CALCULATE ESTIMATED REVENUE FOR EACH CATEGORY

SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--ALL PRODUCTS WITH MRP>500 AND DISCOUNT <10%

SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

--TOP 5 CATEGORIES OFFERING HIGHEST AVERAGE DISCOUNT PERCENTAGE

SELECT category,
ROUND(AVG(discountPercent),2) AS Average_Discount_Percent
FROM zepto
GROUP BY category
ORDER BY Average_Discount_Percent DESC
LIMIT 5;

--PRICE PER GRAM FOR PRODUCTS >100GM AND SORT BY BEST VALUE

SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--GROUP PRODUCTS INTO CATEGORIES: LOW, MEDIUM, BULK

SELECT DISTINCT name, weightInGms,
CASE
	WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
END AS weight_category
FROM zepto;


--TOTAL INVENTORY WEIGHT PER CATEGORY

SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;


