
CREATE TABLE customers(
  id serial PRIMARY KEY,
  name text NOT NULL,
  payment_token char(8) CHECK (payment_token SIMILAR TO '[A-Z]*')
);

-- payment_token has to be unique and not null: we add that later

CREATE TABLE services(
  id serial PRIMARY KEY,
  description text NOT NULL,
  price numeric(10, 2) NOT NULL CHECK (price >= 0.00)
);

INSERT INTO customers (name, payment_token)
     VALUES ('Pat Johnson', 'XHGOAHEQ'),
            ('Nancy Monreal', 'JKWQPJKL'),
            ('Lynn Blake', 'KLZXWEEE'),
            ('Chen Ke-Hua', 'KWETYCVX'),
            ('Scott Lakso', 'UUEAPQPS'),
            ('Jim Pornot', 'XKJEYAZA');

INSERT INTO services (description, price)
     VALUES ('Unix Hosting', 5.95),
            ('DNS', 4.95),
            ('Whois Registration', 1.95),
            ('High Bandwidth', 15.00),
            ('Business Support', 250.00),
            ('Dedicated Hosting', 50.00),
            ('Bulk Email', 250.00),
            ('One-to-one Training', 999.00);

CREATE TABLE customers_services(
  id serial PRIMARY KEY,
  customer_id integer REFERENCES customers (id) ON DELETE CASCADE,
  service_id integer REFERENCES services (id)
);

INSERT INTO customers_services (customer_id, service_id)
     VALUES (1, 1),
            (1, 2),
            (1, 3),
            (3, 1),
            (3, 2),
            (3, 3),
            (3, 4),
            (3, 5),
            (4, 1),
            (4, 4),
            (5, 1),
            (5, 2),
            (5, 6),
            (6, 1),
            (6, 6),
            (6, 7);


 ALTER TABLE customers
ALTER COLUMN payment_token
         SET NOT NULL;

ALTER TABLE customers
ADD UNIQUE (payment_token);

ALTER TABLE customers_services
ADD UNIQUE (customer_id, service_id);


-- Write a query to retrieve the customer data for every customer who currently subscribes to at least one service.

      SELECT DISTINCT customers.id, customers.name, customers.payment_token
        FROM customers
  INNER JOIN customers_services
          ON customers.id = customers_services.customer_id
  INNER JOIN services
          ON customers_services.service_id = services.id;


-- Write a query to retrieve the customer data for every customer who currently subscribes to at least one service.

   SELECT DISTINCT customers.id, customers.name, customers.payment_token
     FROM customers
LEFT JOIN customers_services
       ON customers.id = customers_services.customer_id
LEFT JOIN services
       ON customers_services.service_id = services.id
    WHERE services.id IS NULL;

-- Can you write a query that displays all customers with no services and all services that currently don't have any customers?

    SELECT DISTINCT customers.*, services.*
      FROM customers
 FULL JOIN customers_services
        ON customers.id = customers_services.customer_id
 FULL JOIN services
        ON customers_services.service_id = services.id
     WHERE services.id IS NULL OR customers.id IS NULL;

-- Write a query to display a list of all services that are not currently in use.

    SELECT DISTINCT services.description
      FROM customers
      JOIN customers_services
        ON customers.id = customers_services.customer_id
RIGHT JOIN services
        ON customers_services.service_id = services.id
     WHERE customers.id IS NULL;


-- Write a query to display a list of all customer names together with a comma-separated list of the services they use.

   SELECT customers.name, string_agg(services.description, ', ') AS services
     FROM customers
LEFT JOIN customers_services
       ON customers.id = customers_services.customer_id
LEFT JOIN services
       ON customers_services.service_id = services.id
 GROUP BY customers.name;

-- Write a query that displays the description for every service that is subscribed to by at least 3 customers. Include the customer count for each description in the report.

  SELECT services.description, count(customers.id)
  FROM customers
  JOIN customers_services
  ON customers.id = customers_services.customer_id
  JOIN services
  ON customers_services.service_id = services.id
  GROUP BY services.description
  HAVING count(customers.id) >= 3
  ORDER BY services.description;

-- Assuming that everybody in our database has a bill coming due, and that all of them will pay on time, write a query to compute the total gross income we expect to receive.

SELECT sum(services.price)
  FROM services
  JOIN customers_services
    ON services.id = customers_services.service_id;

-- A new customer, 'John Doe', has signed up with our company. His payment token is `EYODHLCN'. Initially, he has signed up for UNIX hosting, DNS, and Whois Registration. Create any SQL statement(s) needed to add this record to the database.

INSERT INTO customers (name, payment_token)
     VALUES ('John Doe', 'EYODHLCN');

INSERT INTO customers_services (customer_id, service_id)
     VALUES (10, 1),
            (10, 2),
            (10, 3);


-- The company president is looking to increase revenue. As a prelude to his decision making, he asks for two numbers: the amount of expected income from "big ticket" services (those services that cost more than $100) and the maximum income the company could achieve if it managed to convince all of its customers to select all of the company's big ticket items.

-- For simplicity, your solution should involve two separate SQL queries: one that reports the current expected income level, and one that reports the hypothetical maximum. Column name is 'sum' for each query.

SELECT sum(services.price)
  FROM customers
  JOIN customers_services
    ON customers.id = customers_services.customer_id
  JOIN services
    ON customers_services.service_id = services.id
 WHERE services.price > 100;

SELECT (count(customers.id) * (SELECT sum(price) FROM services WHERE price > 100)) AS sum
  FROM customers;

-- The second report could also be created with a cross join:

SELECT sum(price)
FROM customers
CROSS JOIN services
WHERE price > 100;

-- Write the necessary SQL statements to delete the "Bulk Email" service and customer "Chen Ke-Hua" from the database.

-- we can delete the customer, and his services will go away with him:

DELETE FROM customers WHERE id = 4;

-- for bulk email we need to check if someone has booked it.

SELECT * FROM customers_services WHERE service_id = 7;

-- that is indeed the case, so we need to first delete the row 16 from customers_services, then we can delete row 7 from services

DELETE FROM customers_services WHERE id = 16;
DELETE FROM services WHERE id = 7;
