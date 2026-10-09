#!/bin/bash
# Cleans books.csv: fixes unquoted commas in authors and trims header spaces
cp books.csv books_clean.csv
sed -i 's/Warner, Jr\./Warner Jr./' books_clean.csv
sed -i 's/TheOneRing.net, one of/TheOneRing.net - one of/' books_clean.csv
sed -i 's/James Wesley, Rawles/James Wesley Rawles/' books_clean.csv
sed -i 's/Brown, Son/Brown Son/' books_clean.csv
sed -i '1s/,  num_pages/,num_pages/' books_clean.csv
