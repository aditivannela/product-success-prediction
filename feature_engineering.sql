-- Remove tables if they already exist
DROP TABLE IF EXISTS product_features;
DROP TABLE IF EXISTS modeling_dataset;

-- Create aggregated product features
CREATE TABLE product_features AS
SELECT
    p.asin,
    p.title,
    p.brand_name,
    p.price_value,
    COUNT(r."reviewID") AS review_count,
    AVG(r.rating) AS avg_review_rating,
    STDDEV(r.rating) AS rating_variability,
    AVG(r.sentiment_score) AS avg_sentiment
FROM products p
LEFT JOIN reviews r
ON p.asin = r."productASIN"
GROUP BY
    p.asin,
    p.title,
    p.brand_name,
    p.price_value;

-- Create ML dataset
CREATE TABLE modeling_dataset AS
SELECT *,
    CASE
        WHEN avg_review_rating >= 4 AND review_count > 100 THEN 1
        ELSE 0
    END AS is_successful
FROM product_features;