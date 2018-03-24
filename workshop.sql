-- create tables

CREATE TABLE devices (
  id serial PRIMARY KEY,
  name text NOT NULL,
  created_at timestamp DEFAULT now()
);

CREATE TABLE parts (
  id serial PRIMARY KEY,
  part_number integer UNIQUE NOT NULL,
  device_id integer REFERENCES devices (id)
);

-- insert sample data

INSERT INTO devices (name)
     VALUES ('Accelerometer'), ('Gyroscope');

-- Accelerometer: id 1, Gyroscope: id 2

INSERT INTO parts (part_number, device_id)
     VALUES (10, 1), (11, 1), (12, 1),
            (13, 2), (14, 2), (15, 2), (16, 2), (17, 2),
            (18, NULL), (19, NULL), (20, NULL);


-- Show device names and part numbers for parts of that device

SELECT devices.name, parts.part_number
  FROM devices JOIN parts
    ON devices.id = parts.device_id;

-- We want to grab all parts that have a part_number that starts with 1. Write a SELECT query to get this information. This table may show all attributes of the parts table.

SELECT *
  FROM parts
 WHERE CAST(part_number AS text) LIKE '1%';

-- Write an SQL query that returns a result table with the name of each device in our database together with the number of parts for that device.

  SELECT devices.name, count(parts.device_id)
    FROM devices JOIN parts
      ON devices.id = parts.device_id
GROUP BY devices.name
ORDER BY devices.name;


-- Generate a listing of parts that currently belong to a device.

SELECT parts.part_number, parts.device_id
  FROM parts JOIN devices
    ON parts.device_id = devices.id;

-- Generate a listing of parts that don't belong to a device.

SELECT parts.part_number, parts.device_id
  FROM parts LEFT JOIN devices
    ON parts.device_id = devices.id
 WHERE parts.part_number NOT IN
       (SELECT parts.part_number
         FROM parts JOIN devices
           ON parts.device_id = devices.id
       );

-- While the above works, it is needlessly complicated. We can just do:

SELECT part_number, device_id
  FROM parts
 WHERE device_id IS NULL;

SELECT part_number, device_id
  FROM parts
 WHERE device_id IS NOT NULL;

-- Let's add a new device

INSERT INTO devices (name) VALUES ('Magnetometer');
INSERT INTO parts (part_number, device_id) VALUES (42, 3);

-- Assuming nothing about the existing order of the records in the database, write an SQL statement that will return the name of the oldest device from our devices table.

  SELECT name
    FROM devices
ORDER BY created_at
   LIMIT 1;

-- Now let's do this with a subquery.

 SELECT name
   FROM devices
  WHERE created_at = (SELECT min(created_at) FROM devices);

-- this actually gives back two devices ...

-- We've realized that the last two parts we're using for device number 2, "Gyroscope", actually belong to an "Accelerometer". Write an SQL statement that will associate the last two parts from our parts table with an "Accelerometer" instead of a "Gyroscope".

-- so part_number 16 and 17 belong to id 1

UPDATE parts
   SET device_id = 1
 WHERE part_number = 16 OR part_number = 17;


-- What if we wanted to set the part with the smallest part_number to be associated with "Gyroscope"? How would we go about doing that?

-- (the smallest part number is 10, so we want that to have device_id 2)

UPDATE parts
   SET device_id = 2
 WHERE part_number = (SELECT min(part_number) FROM parts);

 -- delete accelerometer

DELETE FROM parts
     WHERE device_id = 1;

DELETE FROM devices
      WHERE id = 1;


-- Foreign key "ON DELETE CASCADE"

-- First, drop the constraint:

    ALTER TABLE parts
DROP CONSTRAINT parts_device_id_fkey;

-- Now, we add it again in modified form:

   ALTER TABLE parts
ADD CONSTRAINT parts_device_id_fkey
   FOREIGN KEY (device_id)
    REFERENCES devices (id)
     ON DELETE CASCADE;
