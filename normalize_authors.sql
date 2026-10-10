-- Split the authors column (several authors per cell, separated by "/")
-- into an authors table and a books_authors bridge table.
CREATE TABLE authors (author_id SERIAL PRIMARY KEY, name TEXT UNIQUE);

CREATE TABLE books_authors (
  bookid INT REFERENCES books(bookid),
  author_id INT REFERENCES authors(author_id),
  PRIMARY KEY (bookid, author_id)
);

INSERT INTO authors (name)
SELECT DISTINCT TRIM(unnest(string_to_array(authors, '/')))
FROM books;

INSERT INTO books_authors (bookid, author_id)
SELECT DISTINCT b.bookid, a.author_id
FROM (
  SELECT bookid, TRIM(unnest(string_to_array(authors, '/'))) AS author_name
  FROM books
) AS b
INNER JOIN authors AS a ON a.name = b.author_name;
