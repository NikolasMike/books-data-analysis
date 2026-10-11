# Books Data Analysis

SQL analysis of the Goodreads books dataset (~11,000 books) using PostgreSQL. The project covers loading raw data, cleaning it, normalizing it, and answering questions with SQL.

## Dataset
`books.csv` from Kaggle (Goodreads books). Columns: title, authors, average rating, ISBN, language, pages, ratings count, publication date, publisher.

## Tools
PostgreSQL 16, bash (`sed`, `awk`), Git, GitHub Codespaces.

## Data cleaning
| Problem | Decision |
|---|---|
| 4 rows with unquoted commas in `authors` broke the CSV import | Fixed with `clean_books.sh` on a copy, raw file untouched |
| Extra spaces in the `num_pages` header | Removed in `clean_books.sh` |
| 2 impossible dates (`11/31/2000`, `6/31/1982`) | Set to `NULL` instead of guessing a day |
| 26 books with rating 0 and 0 ratings | Set to `NULL`: 0 means "no data", not "bad book" |
| 76 books with 0 pages | Set to `NULL` (audiobooks, collections or missing data) |
| Publisher `VIZ Media` written 3 ways (122 books) | Unified into one name |

All SQL cleaning steps are in `cleaning.sql`.

## Normalization
The `authors` column held several authors per cell (4,564 books, 41%), which breaks First Normal Form. I split it into an `authors` table (9,237 unique authors) and a `books_authors` bridge table (19,212 links). All 11,127 books kept at least one author. See `normalize_authors.sql`.

## Findings
- **Largest publishers:** Vintage (318 books), Penguin Books (261), Penguin Classics (184).
- **Best average rating** (publishers with 20+ books): Library of America and Tyndale House (4.26), then VIZ Media (4.25).
- **Most rated book:** Twilight (4.6M ratings) but with a 3.59 rating, the lowest of the top 10. More ratings does not mean a better rating.
- **Book length:** long books (400+ pages) have the highest average rating (4.03) versus short (3.95) and medium (3.91). The result held when filtering to books with 100+ ratings.
- **Cleaning changed the results:** unifying 3 spellings of `VIZ Media` merged two ranking entries into one (4.25) and counted 14 books that had been filtered out for having fewer than 20 books under that name.
- **Most books by author:** Stephen King (99), William Shakespeare (93), J.R.R. Tolkien (55). The dataset counts editions, not works, so Shakespeare's 93 are mostly repeated editions of the same plays.
- **Best average rating by author** (10+ books): Akira Watanabe and Hiromu Arakawa lead (4.56), followed by J.K. Rowling (4.50). Several of the top 10 are manga authors (Arakawa, Tsugumi Ohba, Tite Kubo), consistent with VIZ Media ranking third among publishers. Each manga volume counts as one book, which gives long series extra weight.

## Limitations
- The length and decade differences are small (0.08 to 0.12 points out of 5). They are correlations, not causes.
- **Coverage bias:** 1,700 books were published in 2006 but only 49 in 2008, so the dataset is concentrated around 2006-2007. Decade comparisons are only reliable for 1980-2000.
- Imprints of the same company (Penguin Books / Penguin Classics) are counted as separate publishers.
- Names after the `/` in `authors` are not always co-authors (they can be illustrators), and the dataset has no role information.
- One author name contains a description from the raw data (`David E. Smith (Turgon of TheOneRing.net - ...)`), and its comma was replaced by a dash during cleaning.
- Author names were checked for case-only duplicates only. Other spelling variants (extra spaces, initials) may remain.

## How to reproduce
```bash
createdb books
./clean_books.sh                      # creates books_clean.csv
psql -d books -f schema.sql           # creates the table and loads the CSV
psql -d books -f cleaning.sql         # cleaning decisions
psql -d books -f normalize_authors.sql
psql -d books -f analysis.sql
```
Note: the `COPY` path in `schema.sql` is absolute (`/workspaces/books-data-analysis/`). Change it if your folder is different.

## Files
- `books.csv`: raw data
- `clean_books.sh`: fixes the CSV before loading
- `schema.sql`: creates the books table and loads the data
- `cleaning.sql`: cleaning decisions in SQL
- `normalize_authors.sql`: splits authors into their own tables
- `analysis.sql`: analysis queries