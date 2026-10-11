-- Raw books table, loaded from books_clean.csv
-- publication_date is loaded as TEXT first (the CSV has impossible dates)
-- and converted to DATE after cleaning.
CREATE TABLE books (
  bookid INT PRIMARY KEY,
  title TEXT,
  authors TEXT,
  isbn VARCHAR(10),
  isbn13 VARCHAR(13),
  average_rating NUMERIC(3,2),
  publication_date TEXT,
  language_code TEXT,
  num_pages INT,
  ratings_count INT,
  text_reviews_count INT,
  publisher TEXT
);

COPY books (bookid, title, authors, average_rating, isbn, isbn13, language_code, num_pages, ratings_count, text_reviews_count, publication_date, publisher)
FROM '/workspaces/books-data-analysis/books_clean.csv'
WITH (FORMAT csv, HEADER true);
