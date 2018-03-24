-- Schema

CREATE TABLE bidders(
  id serial PRIMARY KEY,
  name text NOT NULL
);

CREATE TABLE items(
  id serial PRIMARY KEY,
  name text NOT NULL,
  initial_price numeric(6, 2) NOT NULL CHECK(initial_price BETWEEN 0.01 AND 1000.00),
  sales_price numeric(6, 2) CHECK(sales_price BETWEEN 0.01 AND 1000.00)
);

CREATE TABLE bids(
  id serial PRIMARY KEY,
  bidder_id integer NOT NULL REFERENCES bidders (id) ON DELETE CASCADE,
  item_id integer NOT NULL REFERENCES items (id) ON DELETE CASCADE,
  amount numeric(6, 2) NOT NULL CHECK(amount BETWEEN 0.01 AND 1000.00)
);

CREATE INDEX ON bids (bidder_id, item_id);

-- Write a SQL query that shows all items that have had bids put on them. Use the logical operator IN for this exercise, as well as a subquery.

SELECT items.name AS "Items with Bids"
  FROM items
 WHERE items.id IN (SELECT bids.item_id FROM bids);

-- Write a SQL query that shows all items that have not had bids put on them

SELECT items.name AS "Items without Bids"
  FROM items
 WHERE items.id NOT IN (SELECT bids.item_id FROM bids);

-- Write a SELECT query that returns a list of names of everyone who has bid in the auction. While it is possible (and perhaps easier) to do this with a JOIN clause, we're going to do things differently: use a subquery with the EXISTS clause instead. Here is the expected output:

SELECT bidders.name
  FROM bidders
 WHERE EXISTS (SELECT 1 FROM bids WHERE bids.bidder_id = bidders.id);

-- or:

SELECT bidders.name
  FROM bidders
 WHERE bidders.id IN (SELECT bids.bidder_id FROM bids);

-- or (with a join):

SELECT DISTINCT bidders.name
  FROM bidders
  JOIN bids
    ON bidders.id = bids.bidder_id;


 -- Write an SQL query that returns the names of all items that have bids of less than 100 dollars. To accomplish this, use an ANY clause, along with a subquery.

 -- Using ANY
 SELECT name AS "Highest Bid Less Than 100 Dollars" FROM items
 WHERE 100.00 > ANY
   (SELECT amount FROM bids WHERE item_id = items.id);

 -- Using ALL (but with different result)
 SELECT name AS "Highest Bid Less Than 100 Dollars" FROM items
 WHERE 100.00 > ALL
   (SELECT amount FROM bids WHERE item_id = items.id);


-- For this exercise, we'll make a slight departure from how we've been using subqueries. We have so far used subqueries to filter our results using a WHERE clause. In this exercise, we will build that filtering into the table that we will query. Write an SQL query that finds the largest number of bids from an individual bidder.

-- For this exercise, you must use a subquery to generate a result table (or virtual table), and then query that table for the largest number of bids.

SELECT max(bids_counts.number_of_bids)
  FROM (
          SELECT count(bids.id) AS number_of_bids
            FROM bids
        GROUP BY bids.bidder_id
      ) AS bids_counts;


-- For this exercise, use a scalar subquery to determine the number of bids on each item. The entire query should return a table that has the name of each item along with the number of bids on an item.

  SELECT items.name,
         (SELECT count(id) FROM bids WHERE item_id = items.id)
    FROM items;

-- We want to check that a given item is in our database. There is one problem though: we have all of the data for the item, but we don't know the id number. Write an SQL query that will display the id for the item that matches all of the data that we know, but does not use the AND keyword. Here is the data we know:

-- name, initial_price, sales_price
-- 'Painting', 100.00, 250.00

SELECT id
  FROM items
 WHERE ROW(items.name, items.initial_price, items.sales_price) =
        ROW('Painting', 100.00, 250.00);

explain SELECT name FROM bidders
WHERE EXISTS (SELECT 1 FROM bids WHERE bids.bidder_id = bidders.id);


explain analyze SELECT MAX(bid_counts.count) FROM
  (SELECT COUNT(bidder_id) FROM bids GROUP BY bidder_id) AS bid_counts;

explain analyze SELECT COUNT(bidder_id) AS max_bid FROM bids
GROUP BY bidder_id
ORDER BY max_bid DESC
LIMIT 1;
