CREATE DATABASE PlaybillDB
SET DATEFORMAT DMY

--Категории
CREATE TABLE Categories
(
id INT IDENTITY PRIMARY KEY NOT NULL,
Name NVARCHAR(255) NOT NULL UNIQUE
)

CREATE NONCLUSTERED INDEX i_Categoies_name ON Categories(name)

--Возрастной рейтинг
CREATE TABLE AgeRating
(
id INT IDENTITY PRIMARY KEY NOT NULL,
Name NVARCHAR(255) NOT NULL UNIQUE CHECK(Name Like'%+')
)

CREATE NONCLUSTERED INDEX i_AgeRatings_name ON AgeRating(name)

--Страны
CREATE TABLE Countries
(
id int IDENTITY PRIMARY KEY NOT NULL,
Name NVARCHAR(255) NOT NULL UNIQUE
)

CREATE NONCLUSTERED INDEX i_countries_name ON Countries(Name)

--Города
CREATE TABLE Towns
(
id int IDENTITY PRIMARY KEY NOT NULL,
Name NVARCHAR(255) NOT NULL
)

CREATE NONCLUSTERED INDEX i_towns_name ON Towns(name)

--Places
CREATE TABLE Places
(
id int IDENTITY PRIMARY KEY NOT NULL,
Name NVARCHAR(255) NOT NULL,
Address NVARCHAR(255) NOT NULL 
)

CREATE NONCLUSTERED INDEX i_places_name ON Places(name)

--Клиенты
CREATE TABLE Clients
(
id INT IDENTITY PRIMARY KEY NOT NULL,
Name NVARCHAR(255) NOT NULL,
Mail NVARCHAR(255) NOT NULL UNIQUE CHECK(Mail LIKE'%@%.%'),
BornDate NVARCHAR(255) NOT NULL 
)

--События
CREATE TABLE Events
(
id INT IDENTITY PRIMARY KEY NOT NULL,
Name NVARCHAR(255) NOT NULL,
StartDate Date NOT NULL,
EndDate Date NOT NULL, 
Country INT CONSTRAINT FK_Events_Countries FOREIGN KEY REFERENCES Countries(id) NOT NULL,
Town INT CONSTRAINT FK_Events_Towns FOREIGN KEY REFERENCES Towns(id) NOT NULL,
Place INT CONSTRAINT FK_Events_Places FOREIGN KEY REFERENCES Places(id) NOT NULL,
StartTime Time(0) NULL,
EndTime Time(0) NULL,
Rating INT CONSTRAINT FK_Events_AgeRating FOREIGN KEY REFERENCES AgeRating(id) NOT NULL,
Category INT CONSTRAINT FK_Events_Category FOREIGN KEY REFERENCES Categories(id) NOT NULL,
Discription NVARCHAR(255) NULL,
Price FLOAT NULL,
MaxTicketsQuantity INT NOT NULL,
SoldTicketsQuantity INT,
Archive BIT NULL
)

--Проданные билеты
CREATE TABLE Sold_Tickets
(
id INT IDENTITY PRIMARY KEY NOT NULL,
Event_id INT CONSTRAINT FK_Tickets_Events FOREIGN KEY REFERENCES Events(id) NOT NULL,
Client_id INT CONSTRAINT FK_Tickets_Clients FOREIGN KEY REFERENCES Clients(id) NOT NULL,
)

