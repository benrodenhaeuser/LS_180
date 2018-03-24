CREATE TABLE stars(
  id serial PRIMARY KEY,
  name varchar(25) UNIQUE NOT NULL,
  distance int NOT NULL,
  spectral_type char(1),
  companions int NOT NULL,
  CHECK (distance > 0),
  CHECK (companions >= 0)
);

CREATE TABLE planets(
  id serial PRIMARY KEY,
  designation char(1),
  mass int
);

-- for planets table:
-- CHECK (designation SIMILAR TO '[a-z]')

-- for stars table:
-- CHECK (spectral_type IN ('O', 'B', 'A', 'F', 'G', 'K', 'M'))


-- Add a star_id column to the planets table; this column will be used to relate each planet in the planets table to its home star in the stars table. Make sure the row is defined in such a way that it is required and must have a value that is present as an id in the stars table.

ALTER TABLE planets
ADD COLUMN star_id
integer NOT NULL references stars (id);

-- Modify the stars.name column so that it allows star names as long as 50 characters.

ALTER TABLE stars
ALTER COLUMN name
TYPE varchar(50);

-- For many of the closest stars, we know the distance from Earth fairly accurately; for instance, Proxima Centauri is roughly 4.3 light years away. Our database, as currently defined, only allows integer distances, so the most accurate value we can enter is 4. Modify the distance column in the stars table so that it allows fractional light years to any degree of precision required.

ALTER TABLE stars
ALTER COLUMN distance
TYPE decimal;


-- for stars table enforce spectral type:

ALTER TABLE stars
ADD CHECK (spectral_type IN ('O', 'B', 'A', 'F', 'G', 'K', 'M'));

ALTER TABLE stars
ALTER COLUMN spectral_type
SET NOT NULL;

-- remove the check constraint on spectral_type
-- use an enumerated type with possible values
-- 'O', 'B', 'A', 'F', 'G', 'K', 'M'.

CREATE TYPE spectral AS ENUM ('O', 'B', 'A', 'F', 'G', 'K', 'M');

ALTER TABLE stars
ALTER COLUMN spectral_type
TYPE spectral
USING spectral_type::spectral;


-- We will measure Planetary masses in terms of the mass of Jupiter. As such, the current data type of integer is inappropriate; it is only really useful for planets as large as Jupiter or larger. These days, we know of many extrasolar planets that are smaller than Jupiter, so we need to be able to record fractional parts for the mass. Modify the mass column in the planets table so that it allows fractional masses to any degree of precision required. In addition, make sure the mass is required and positive.
-- While we're at it, also make the designation column required.

ALTER TABLE planets
ALTER COLUMN mass
TYPE decimal;

ALTER TABLE planets
ADD CHECK (mass > 0.0);

ALTER TABLE planets
ALTER COLUMN mass
SET NOT NULL;

ALTER TABLE planets
ALTER COLUMN designation
SET NOT NULL;


-- Add a semi_major_axis column for the semi-major axis of each planet's orbit; the semi-major axis is the average distance from the planet's star as measured in astronomical units (1 AU is the average distance of the Earth from the Sun). Use a data type of numeric, and require that each planet have a value for the semi_major_axis.

ALTER TABLE planets
ADD COLUMN semi_major_axis numeric NOT NULL;

-- Add a moons table

-- id: a unique serial number that auto-increments and serves as a primary key for this table.

-- designation: the designation of the moon. We will assume that moon designations will be numbers, with the first moon discovered for each planet being moon 1, the second moon being moon 2, etc. The designation is required.

-- semi_major_axis: the average distance in kilometers from the planet when a moon is farthest from its corresponding planet. This field must be a number greater than 0, but is not required; it may take some time before we are able to measure moon-to-planet distances in extrasolar systems.

-- mass: the mass of the moon measured in terms of Earth Moon masses. This field must be a numeric value greater than 0, but is not required.

-- Make sure you also specify any foreign keys necessary to tie each moon to other rows in the database.

CREATE TABLE moons(
  id serial PRIMARY KEY,
  designation integer NOT NULL CHECK (designation > 0),
  semi_major_axis numeric CHECK (semi_major_axis > 0.0),
  mass numeric CHECK (mass > 0.0),
  planet_id integer NOT NULL REFERENCES planets (id)
);
