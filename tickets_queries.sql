-- How many tickets where sold?

SELECT count(id) FROM tickets; -- 3783

-- How many different customers purchased tickets to at least one event.

SELECT count(DISTINCT customer_id) FROM tickets; -- 1652

-- Write a query that determines what percentage of the customers in the database have purchased a ticket to one of the events.

SELECT 1652 / count(*)::float * 100 FROM customers;

-- this works, but we are not suppposed to use 1652 here!

-- use a join.

SELECT count(DISTINCT tickets.customer_id) / count(DISTINCT customers.id)::float * 100 AS percent
FROM customers
LEFT OUTER JOIN tickets
ON tickets.customer_id = customers.id;

-- left outer join means: all customer rows will be part of the result table (this is important here: if we use an inner join, tickets.customer_id and customers.id will be the same number!).

-- Write a query that returns the name of each event and how many tickets were sold for it, in order from most popular to least popular.

SELECT events.name, count(tickets.event_id) as popularity
FROM events LEFT OUTER JOIN tickets
ON tickets.event_id = events.id
GROUP BY events.id
ORDER BY popularity DESC;

-- Write a query that returns the user id, email address, and number of events for all customers that have purchased tickets to three events.

SELECT customers.id, customers.email, count(DISTINCT tickets.event_id)
FROM customers INNER JOIN tickets
ON tickets.customer_id = customers.id
GROUP BY customers.id
HAVING count(DISTINCT tickets.event_id) = 3;

-- Write a query to print out a report of all tickets purchased by the customer with the email address 'gennaro.rath@mcdermott.co'. The report should include the event name and starts_at and the seat's section name, row, and seat number.

SELECT events.name AS event, events.starts_at, sections.name AS section, seats.row, seats.number as seat
  FROM customers
    JOIN tickets
    ON customers.id = tickets.customer_id
    JOIN events
    ON events.id = tickets.event_id
    JOIN seats
    ON seats.id = tickets.seat_id
    JOIN sections
    ON sections.id = seats.section_id
WHERE customers.email = 'gennaro.rath@mcdermott.co';

SELECT events.name AS event, events.starts_at, sections.name AS section, seats.row, seats.number AS seat
  FROM tickets
    INNER JOIN events ON tickets.event_id = events.id
    INNER JOIN customers ON tickets.customer_id = customers.id
    INNER JOIN seats ON tickets.seat_id = seats.id
    INNER JOIN sections ON seats.section_id = sections.id
WHERE customers.email = 'gennaro.rath@mcdermott.co';
