CREATE TABLE contacts (
  id serial NOT NULL PRIMARY KEY,
  name varchar(40) NOT NULL,
  email varchar(40) NOT NULL
);

ALTER TABLE ONLY contacts
  ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);