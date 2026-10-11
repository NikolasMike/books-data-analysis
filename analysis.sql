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

-- 5. Average rating by decade (only reliable for 1980-2000, see coverage below)
SELECT
  FLOOR(EXTRACT(YEAR FROM publication_date) / 10) * 10 AS decade,
  COUNT(*) AS books,
  ROUND(AVG(average_rating), 2) AS avg_rating
FROM books
WHERE publication_date IS NOT NULL AND ratings_count >= 100
GROUP BY decade
ORDER BY decade;

-- 6. Books per year: coverage drops sharply after 2007
SELECT EXTRACT(YEAR FROM publication_date) AS year, COUNT(*) FROM books WHERE publication_date >= '2005-01-01' GROUP BY year ORDER BY year;

-- 7. Authors with the most books
SELECT a.name, COUNT(*)
FROM authors AS a
INNER JOIN books_authors AS ba ON a.author_id = ba.author_id
GROUP BY a.name
ORDER BY COUNT(*) DESC
LIMIT 10;

-- 8. Best average rating by author (at least 10 books)
SELECT a.name, COUNT(*) AS books, ROUND(AVG(b.average_rating), 2) AS avg_rating
FROM authors AS a
INNER JOIN books_authors AS ba ON a.author_id = ba.author_id
INNER JOIN books AS b ON ba.bookid = b.bookid
GROUP BY a.name
HAVING COUNT(*) >= 10
ORDER BY AVG(b.average_rating) DESC
LIMIT 10;
