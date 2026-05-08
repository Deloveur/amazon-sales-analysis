SELECT * FROM amazon_clean LIMIT 10; 
SELECT 
    c1 AS product_id,
    c2 AS product_name,
    c3 AS category,
    c4 AS discounted_price,
    c5 AS actual_price,
    c6 AS discount_percentage,
    c7 AS rating,
    c8 AS rating_count
FROM amazon1;

SELECT * FROM amazon_clean

DELETE FROM amazon_clean
WHERE product_id = 'product_id';

--1. Очистка данных (как в pandas)
SELECT 
    product_name,
    CAST(REPLACE(REPLACE(discounted_price, '₹', ''), ',', '') AS FLOAT) AS discounted_price,
    CAST(REPLACE(REPLACE(actual_price, '₹', ''), ',', '') AS FLOAT) AS actual_price,
    CAST(REPLACE(discount_percentage, '%', '') AS FLOAT) AS discount_percentage,
    CAST(rating AS FLOAT) AS rating,
    CAST(REPLACE(rating_count, ',', '') AS INT) AS rating_count
FROM amazon_clean;

--2. discount_value (новая колонка)
SELECT 
    product_name,
    CAST(REPLACE(REPLACE(actual_price, '₹', ''), ',', '') AS FLOAT) -
    CAST(REPLACE(REPLACE(discounted_price, '₹', ''), ',', '') AS FLOAT) AS discount_value
FROM amazon_clean
ORDER BY discount_value DESC;

--3. Средняя, медиана, максимум скидки
SELECT 
    AVG(CAST(REPLACE(discount_percentage, '%', '') AS FLOAT)) AS avg_discount,
    MAX(CAST(REPLACE(discount_percentage, '%', '') AS FLOAT)) AS max_discount
FROM amazon_clean;

--4. Топ-10 товаров по скидке
SELECT 
    product_name,
    CAST(REPLACE(REPLACE(actual_price, '₹', ''), ',', '') AS FLOAT) -
    CAST(REPLACE(REPLACE(discounted_price, '₹', ''), ',', '') AS FLOAT) AS discount_value
FROM amazon_clean
ORDER BY discount_value DESC
LIMIT 10;

--5. Основная категория (до "|")
SELECT 
    product_name,
    TRIM(SUBSTR(category, 1, INSTR(category, '|') - 1)) AS main_category
FROM amazon_clean;

--6. Средний рейтинг и скидка по категориям 
SELECT 
    TRIM(SUBSTR(category, 1, INSTR(category, '|') - 1)) AS main_category,
    AVG(CAST(rating AS FLOAT)) AS avg_rating,
    AVG(CAST(REPLACE(discount_percentage, '%', '') AS FLOAT)) AS avg_discount
FROM amazon_clean
GROUP BY main_category
ORDER BY avg_rating DESC;

--7. Топ-10 категорий по рейтингу 
SELECT 
    TRIM(SUBSTR(category, 1, INSTR(category, '|') - 1)) AS main_category,
    AVG(CAST(rating AS FLOAT)) AS avg_rating
FROM amazon_clean
GROUP BY main_category
ORDER BY avg_rating DESC
LIMIT 10;


--8. Среднее количество отзывов 
SELECT 
    AVG(CAST(REPLACE(rating_count, ',', '') AS INT)) AS avg_reviews
FROM amazon_clean;

--9. Продукт с максимальными отзывами 
SELECT product_name
FROM amazon_clean
ORDER BY CAST(REPLACE(rating_count, ',', '') AS INT) DESC
LIMIT 1;


--10. Conversion Score (самое важное) 

SELECT 
    TRIM(SUBSTR(category, 1, INSTR(category, '|') - 1)) AS main_category,
    AVG(
        CAST(rating AS FLOAT) * 
        LOG(1 + CAST(REPLACE(rating_count, ',', '') AS INT))
    ) AS conversion_score
FROM amazon_clean
GROUP BY main_category
ORDER BY conversion_score DESC;

