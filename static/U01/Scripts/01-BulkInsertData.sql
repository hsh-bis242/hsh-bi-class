IF NOT EXISTS ( SELECT  *
                FROM    sys.schemas
                WHERE   name = N'vrs' )
    EXEC('CREATE SCHEMA [vrs]');
GO

IF OBJECT_ID(N'vrs.actor', N'U') IS NOT NULL
DROP TABLE vrs.actor;
GO

CREATE TABLE vrs.actor (
    actor_id INT PRIMARY KEY,
    first_name NVARCHAR(255),
	last_name NVARCHAR(255),
	last_update DATETIME2
    );
GO

BULK INSERT vrs.actor
FROM 'csvcontainer/actor.csv'
WITH (FORMAT='CSV', DATA_SOURCE = 'azureblobstorageDS', FIELDQUOTE = '"', FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', FIRSTROW = 2);
GO

IF OBJECT_ID(N'vrs.address', N'U') IS NOT NULL
DROP TABLE vrs.[address];
GO

CREATE TABLE vrs.[address] (
    address_id INT PRIMARY KEY,
    [address] NVARCHAR(255),
	address2 NVARCHAR(255),
	district NVARCHAR(255),
	city_id INT,
	postal_code NVARCHAR(255),
	phone NVARCHAR(255),
	[location] NVARCHAR(255),
	last_update DATETIME2
    );
GO

BULK INSERT vrs.[address]
FROM 'csvcontainer/address.csv'
WITH (FORMAT='CSV', DATA_SOURCE = 'azureblobstorageDS', FIELDQUOTE = '"', FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', FIRSTROW = 2);
GO

IF OBJECT_ID(N'vrs.category', N'U') IS NOT NULL
DROP TABLE vrs.category;
GO

CREATE TABLE vrs.category (
    category_id INT PRIMARY KEY,
    [name] NVARCHAR(255),
	last_update DATETIME2
    );
GO

BULK INSERT vrs.category
FROM 'csvcontainer/category.csv'
WITH (FORMAT='CSV', DATA_SOURCE = 'azureblobstorageDS', FIELDQUOTE = '"', FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', FIRSTROW = 2);
GO

IF OBJECT_ID(N'vrs.city', N'U') IS NOT NULL
DROP TABLE vrs.city;
GO

CREATE TABLE vrs.city (
    city_id INT PRIMARY KEY,
    city NVARCHAR(255),
	country_id INT,
	last_update DATETIME2
    );
GO

BULK INSERT vrs.city
FROM 'csvcontainer/city.csv'
WITH (FORMAT='CSV', DATA_SOURCE = 'azureblobstorageDS', FIELDQUOTE = '"', FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', FIRSTROW = 2);
GO

IF OBJECT_ID(N'vrs.country', N'U') IS NOT NULL
DROP TABLE vrs.country;
GO

CREATE TABLE vrs.country (
    country_id INT PRIMARY KEY,
    country NVARCHAR(255),
	last_update DATETIME2
    );
GO

BULK INSERT vrs.country
FROM 'csvcontainer/country.csv'
WITH (FORMAT='CSV', DATA_SOURCE = 'azureblobstorageDS', FIELDQUOTE = '"', FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', FIRSTROW = 2);
GO

IF OBJECT_ID(N'vrs.customer', N'U') IS NOT NULL
DROP TABLE vrs.customer;
GO

CREATE TABLE vrs.customer (
    customer_id INT PRIMARY KEY,
	store_id INT,
	first_name NVARCHAR(255),
	last_name NVARCHAR(255),
	email NVARCHAR(255),
	address_id INT,
	active TINYINT,
	create_date DATETIME2,
	last_update DATETIME2
    );
GO

BULK INSERT vrs.customer
FROM 'csvcontainer/customer.csv'
WITH (FORMAT='CSV', DATA_SOURCE = 'azureblobstorageDS', FIELDQUOTE = '"', FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', FIRSTROW = 2);
GO

IF OBJECT_ID(N'vrs.film', N'U') IS NOT NULL
DROP TABLE vrs.film;
GO

CREATE TABLE vrs.film (
    film_id INT PRIMARY KEY,
	title NVARCHAR(255),
	[description] NVARCHAR(255),
	release_year INT,
	language_id INT,
	original_language_id INT,
	rental_duration INT,
	rental_rate NUMERIC(19,2),
	[length] INT,
	replacement_cost NUMERIC(19,2),
	rating NVARCHAR(255),
	special_features NVARCHAR(255),
	last_update DATETIME2
    );
GO

BULK INSERT vrs.film
FROM 'csvcontainer/film.csv'
WITH (FORMAT='CSV', DATA_SOURCE = 'azureblobstorageDS', FIELDQUOTE = '"', FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', FIRSTROW = 2);
GO

IF OBJECT_ID(N'vrs.film_actor', N'U') IS NOT NULL
DROP TABLE vrs.film_actor;
GO

CREATE TABLE vrs.film_actor (
    actor_id INT NOT NULL,
	film_id INT NOT NULL,
	last_update DATETIME2,
	CONSTRAINT PK_film_actor PRIMARY KEY CLUSTERED (actor_id, film_id)
    );
GO

BULK INSERT vrs.film_actor
FROM 'csvcontainer/film_actor.csv'
WITH (FORMAT='CSV', DATA_SOURCE = 'azureblobstorageDS', FIELDQUOTE = '"', FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', FIRSTROW = 2);
GO

IF OBJECT_ID(N'vrs.film_category', N'U') IS NOT NULL
DROP TABLE vrs.film_category;
GO

CREATE TABLE vrs.film_category (
	film_id INT NOT NULL,
    category_id INT NOT NULL,
	last_update DATETIME2,
	CONSTRAINT PK_film_category PRIMARY KEY CLUSTERED (film_id, category_id)
    );
GO

BULK INSERT vrs.film_category
FROM 'csvcontainer/film_category.csv'
WITH (FORMAT='CSV', DATA_SOURCE = 'azureblobstorageDS', FIELDQUOTE = '"', FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', FIRSTROW = 2);
GO

IF OBJECT_ID(N'vrs.inventory', N'U') IS NOT NULL
DROP TABLE vrs.inventory;
GO

CREATE TABLE vrs.inventory (
	inventory_id INT PRIMARY KEY,
	film_id INT,
	store_id INT,
	last_update DATETIME2
    );
GO

BULK INSERT vrs.inventory
FROM 'csvcontainer/inventory.csv'
WITH (FORMAT='CSV', DATA_SOURCE = 'azureblobstorageDS', FIELDQUOTE = '"', FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', FIRSTROW = 2);
GO

IF OBJECT_ID(N'vrs.language', N'U') IS NOT NULL
DROP TABLE vrs.[language];
GO

CREATE TABLE vrs.[language] (
	language_id INT PRIMARY KEY,
	[name] NVARCHAR(255),
	last_update DATETIME2
    );
GO

BULK INSERT vrs.[language]
FROM 'csvcontainer/language.csv'
WITH (FORMAT='CSV', DATA_SOURCE = 'azureblobstorageDS', FIELDQUOTE = '"', FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', FIRSTROW = 2);
GO

IF OBJECT_ID(N'vrs.payment', N'U') IS NOT NULL
DROP TABLE vrs.payment;
GO

CREATE TABLE vrs.payment (
	payment_id INT PRIMARY KEY,
	customer_id INT,
	staff_id INT,
	rental_id INT,
	amount DECIMAL(19,2),
	payment_date DATETIME2
    );
GO

BULK INSERT vrs.payment
FROM 'csvcontainer/payment.csv'
WITH (FORMAT='CSV', DATA_SOURCE = 'azureblobstorageDS', FIELDQUOTE = '"', FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', FIRSTROW = 2);
GO

IF OBJECT_ID(N'vrs.rental', N'U') IS NOT NULL
DROP TABLE vrs.rental;
GO

CREATE TABLE vrs.rental (
	rental_id INT PRIMARY KEY,
	rental_date DATETIME2,
	inventory_id INT,
	customer_id INT,
	return_date DATETIME2,
	staff_id INT,
	last_update DATETIME2
    );
GO

BULK INSERT vrs.rental
FROM 'csvcontainer/rental.csv'
WITH (FORMAT='CSV', DATA_SOURCE = 'azureblobstorageDS', FIELDQUOTE = '"', FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', FIRSTROW = 2);
GO

IF OBJECT_ID(N'vrs.store', N'U') IS NOT NULL
DROP TABLE vrs.store;
GO

CREATE TABLE vrs.store (
	store_id INT PRIMARY KEY,
	manager_staff_id INT,
	address_id INT,
	last_update DATETIME2
    );
GO

BULK INSERT vrs.store
FROM 'csvcontainer/store.csv'
WITH (FORMAT='CSV', DATA_SOURCE = 'azureblobstorageDS', FIELDQUOTE = '"', FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', FIRSTROW = 2);
GO

IF OBJECT_ID(N'vrs.staff', N'U') IS NOT NULL
DROP TABLE vrs.staff;
GO

CREATE TABLE vrs.staff (
	staff_id INT PRIMARY KEY,
	first_name NVARCHAR(255),
	last_name NVARCHAR(255),
	address_id INT,
	email NVARCHAR(255),
	store_id INT,
	active NCHAR(1),
	username NVARCHAR(255),
	[password] NVARCHAR(255),
	last_update DATETIME2,
	picture NVARCHAR(255)
    );
GO

BULK INSERT vrs.staff
FROM 'csvcontainer/staff.csv'
WITH (FORMAT='CSV', DATA_SOURCE = 'azureblobstorageDS', FIELDQUOTE = '"', FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', FIRSTROW = 2);
GO

ALTER TABLE vrs.film_category
	ADD CONSTRAINT FK_FilmCategory_Category FOREIGN KEY (category_id)
		REFERENCES vrs.category (category_id);

ALTER TABLE vrs.film_category
	ADD CONSTRAINT FK_FilmCategory_Film FOREIGN KEY (film_id)
		REFERENCES vrs.film (film_id);

ALTER TABLE vrs.film
	ADD CONSTRAINT FK_Film_Language FOREIGN KEY (language_id)
		REFERENCES vrs.[language] (language_id);

ALTER TABLE vrs.film_actor
	ADD CONSTRAINT FK_FilmActor_Film FOREIGN KEY (film_id)
		REFERENCES vrs.film (film_id);

ALTER TABLE vrs.film_actor
	ADD CONSTRAINT FK_FilmActor_Actor FOREIGN KEY (actor_id)
		REFERENCES vrs.actor (actor_id);

ALTER TABLE vrs.inventory
	ADD CONSTRAINT FK_Inventory_Film FOREIGN KEY (film_id)
		REFERENCES vrs.film (film_id);

ALTER TABLE vrs.inventory
	ADD CONSTRAINT FK_Inventory_Store FOREIGN KEY (store_id)
		REFERENCES vrs.store (store_id);

ALTER TABLE vrs.rental
	ADD CONSTRAINT FK_Rental_Inventory FOREIGN KEY (inventory_id)
		REFERENCES vrs.inventory (inventory_id);

ALTER TABLE vrs.rental
	ADD CONSTRAINT FK_Rental_Customer FOREIGN KEY (customer_id)
		REFERENCES vrs.customer (customer_id);

ALTER TABLE vrs.rental
	ADD CONSTRAINT FK_Rental_Staff FOREIGN KEY (staff_id)
		REFERENCES vrs.staff (staff_id);

ALTER TABLE vrs.payment
	ADD CONSTRAINT FK_Payment_Customer FOREIGN KEY (customer_id)
		REFERENCES vrs.customer (customer_id);

ALTER TABLE vrs.payment
	ADD CONSTRAINT FK_Payment_Staff FOREIGN KEY (staff_id)
		REFERENCES vrs.staff (staff_id);

ALTER TABLE vrs.payment
	ADD CONSTRAINT FK_Payment_Rental FOREIGN KEY (rental_id)
		REFERENCES vrs.rental (rental_id);

ALTER TABLE vrs.customer
	ADD CONSTRAINT FK_Customer_Address FOREIGN KEY (address_id)
		REFERENCES vrs.[address] (address_id);

ALTER TABLE vrs.customer
	ADD CONSTRAINT FK_Customer_Store FOREIGN KEY (store_id)
		REFERENCES vrs.store (store_id);

ALTER TABLE vrs.store
	ADD CONSTRAINT FK_Store_Address FOREIGN KEY (address_id)
		REFERENCES vrs.[address] (address_id);

ALTER TABLE vrs.store
	ADD CONSTRAINT FK_Store_Staff FOREIGN KEY (manager_staff_id)
		REFERENCES vrs.staff (staff_id);

ALTER TABLE vrs.staff
	ADD CONSTRAINT FK_Staff_Address FOREIGN KEY (address_id)
		REFERENCES vrs.[address] (address_id);

ALTER TABLE vrs.staff
	ADD CONSTRAINT FK_Staff_Store FOREIGN KEY (store_id)
		REFERENCES vrs.store (store_id);

ALTER TABLE vrs.city
	ADD CONSTRAINT FK_City_Country FOREIGN KEY (country_id)
		REFERENCES vrs.country (country_id);

ALTER TABLE vrs.[address]
	ADD CONSTRAINT FK_Address_City FOREIGN KEY (city_id)
		REFERENCES vrs.city (city_id);
GO