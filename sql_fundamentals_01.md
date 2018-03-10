## Create the database `animals`

```sql
CREATE DATABASE animals;
```

## Create the table `birds`

```sql
CREATE TABLE birds(
id integer PRIMARY KEY,
name varchar(25),
age integer,
species varchar(15)
);
```

## Insert some data

```sql
INSERT INTO birds(name, age, species)
VALUES ('Charlie', 3, 'Finch'),
       ('Allie', 5, 'Owl'),
       ('Jennifer', 3, 'Magpie'),
       ('Jamie', 4, 'Owl'),
       ('Roy', 8, 'Crow');
```

## Query the table to see what you added

```sql
SELECT *
FROM birds;
```

## Select the birds under the age of 5

```sql
SELECT *
FROM birds
WHERE age < 5;
```

## Change the species of Roy to Raven

```sql
UPDATE birds
SET species = 'Raven'
WHERE name = 'Roy';
```

Alternatively, we could use Roy's id.

## Turn Jamie into a Hawk

```sql
UPDATE birds
SET species = 'Hawk'
WHERE name = 'Jamie';
```

## Delete any 3-year old finches

```sql
DELETE FROM table
WHERE age = 3 AND species = 'Finch';

```

## Only birds with positive age are allowed

```sql
ALTER TABLE birds
ADD CONSTRAINT check_age
CHECK (age > 0);
```

shorthand:

```sql
ALTER TABLE birds
ADD CHECK (age > 0);
```

(parentheses are not optional!)


## Delete the birds table

```sql
DROP TABLE birds;
```

## Delete the animals database

```sql
DROP DATABASE animals;
```

(connect to a different database first)
