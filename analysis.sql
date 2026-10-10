-- 1. Publishers with the most books
SELECT publisher, COUNT(*) FROM books GROUP BY publisher ORDER BY COUNT(*) DESC LIMIT 10;

-- 2. Best average rating by publisher (at least 20 books)
SELECT publisher, ROUND(AVG(average_rating), 2) FROM books GROUP BY publisher HAVING COUNT(*) >= 20 ORDER BY AVG(average_rating) DESC LIMIT 10;

-- 3. Most rated books
SELECT title, ratings_count, average_rating FROM books ORDER BY ratings_count DESC LIMIT 10;

-- 4. Rating by book length (only books with at least 100 ratings)
SELECT
  CASE
    WHEN num_pages < 200 THEN 'short (<200)'
    WHEN num_pages < 400 THEN 'medium (200-399)'
    ELSE 'long (400+)'
  END AS length,
  COUNT(*) AS books,
  ROUND(AVG(average_rating), 2) AS avg_rating
FROM books
WHERE num_pages IS NOT NULL AND ratings_count >= 100
GROUP BY length
ORDER BY avg_rating DESC;
