-- Dates that do not exist (11/31/2000, 6/31/1982) become NULL
UPDATE books SET publication_date = NULL WHERE bookid IN (31373, 45531);

-- A rating of 0 with 0 ratings means "no data", not "bad book"
UPDATE books SET average_rating = NULL WHERE average_rating = 0 AND ratings_count = 0;

-- 0 pages is a missing value (audiobooks, collections, or missing data)
UPDATE books SET num_pages = NULL WHERE num_pages = 0;



-- Same publisher written 3 ways (VIZ Media, Viz Media, VIZ Media LLC)
UPDATE books SET publisher = 'VIZ Media' WHERE publisher ILIKE '%viz media%';
