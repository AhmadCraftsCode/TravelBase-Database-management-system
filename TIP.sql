-- Delete database if existing
DROP DATABASE TIP;
USE MASTER;

-- Create a database
CREATE DATABASE TIP;
USE TIP;

-- 1. Customers Table
CREATE TABLE customers (
    customerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
	Gender VARCHAR(25) NOT NULL,
    Email VARCHAR(255) UNIQUE,
    PhoneNo VARCHAR(20) UNIQUE,
    Address VARCHAR(255) NOT NULL
); 

-- 2. Destinations Table
CREATE TABLE destinations (
    destinationID INT IDENTITY(1,1) PRIMARY KEY,
    country VARCHAR(100) NOT NULL,
    city VARCHAR(100) UNIQUE,
	category VARCHAR(100) NOT NULL,
	rating DECIMAL(2,1) NOT NULL,
	CHECK (rating >= 0 AND rating <= 4)
);

-- 3. Flights Table
CREATE TABLE flights (
    flightID INT IDENTITY(1,1) PRIMARY KEY,
    airline VARCHAR(100) UNIQUE,
    departureCity VARCHAR(100) NOT NULL,
    arrivalCity VARCHAR(100) NOT NULL,
	duration INT NOT NULL,
	CHECK (duration > 0),
);

-- 4. Transportation Table
CREATE TABLE transportation (
    transportationID INT IDENTITY(1,1) PRIMARY KEY,
    transportationType VARCHAR(100) UNIQUE,
    companyName VARCHAR(100) NOT NULL,
	price INT NOT NULL,
	class_type VARCHAR(20) NOT NULL,
	CHECK (price > 0)
);

-- 5. Guides Table
CREATE TABLE guides (
    guideID INT IDENTITY(1,1) PRIMARY KEY,
    fullName VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    contactNumber VARCHAR(20) UNIQUE,
	experience INT NOT NULL,
	charges INT NOT NULL, -- TBN
	available VARCHAR(20) NOT NULL,
	CHECK (charges > 0)
);

-- 6. Packages Table
CREATE TABLE packages (
    packageID INT IDENTITY(1,1) PRIMARY KEY,
    packageName VARCHAR(100) NOT NULL,
    description VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
	durationDays INT NOT NULL,
	meal_plan VARCHAR(20) NOT NULL,
    destinationID INT NOT NULL,
	CHECK (price > 0),
	CHECK (durationDays > 0)
);

ALTER TABLE packages
ADD CONSTRAINT FK_Packages_Destinations
FOREIGN KEY (destinationID) REFERENCES destinations(destinationID);

-- 8. Bookings Table
CREATE TABLE bookings (
    bookingID INT IDENTITY(1,1) PRIMARY KEY,
    customerID INT NOT NULL,
    packageID INT NOT NULL,
    flightID INT NOT NULL,
    transportationID INT NOT NULL,
    numPassengers INT NOT NULL,
	bookingDate DATE NOT NULL,
    guideID INT,
	status VARCHAR(20) NOT NULL,
    FOREIGN KEY (customerID) REFERENCES customers(customerID),
    FOREIGN KEY (packageID) REFERENCES packages(packageID),
    FOREIGN KEY (flightID) REFERENCES flights(flightID),
    FOREIGN KEY (transportationID) REFERENCES transportation(transportationID),
    FOREIGN KEY (guideID) REFERENCES guides(guideID)
);

-- 9. Activities Table
CREATE TABLE activities (
    activityID INT IDENTITY(1,1) PRIMARY KEY,
    activityName VARCHAR(100) UNIQUE,
    price DECIMAL(10,2) NOT NULL, -- TBN
    description VARCHAR(255) NOT NULL,
	CHECK (price > 0) -- TBN
);

-- 10. BookingActivities Table
CREATE TABLE bookingActivities (
    bookingActivitiesID INT IDENTITY(1,1) PRIMARY KEY,
    bookingID INT NOT NULL,
    activityID INT NOT NULL,
    FOREIGN KEY (bookingID) REFERENCES bookings(bookingID),
    FOREIGN KEY (activityID) REFERENCES activities(activityID)
);

-- 11. Hotels Table
CREATE TABLE hotels (
    hotelID INT IDENTITY(1,1) PRIMARY KEY,
    hotelName VARCHAR(100) NOT NULL,
	city VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    country VARCHAR(100) NOT NULL,
    contactNumber VARCHAR(20) UNIQUE
);

-- 12. Hotel Booking Table
CREATE TABLE hotelBooking (
    hotelBookingID INT IDENTITY(1,1) PRIMARY KEY,
    bookingID INT NOT NULL,
    hotelID INT NOT NULL,
    checkInDate DATE NOT NULL,
    checkOutDate DATE NOT NULL,
    CHECK (checkInDate <= checkOutDate),
    FOREIGN KEY (bookingID) REFERENCES bookings(bookingID),
    FOREIGN KEY (hotelID) REFERENCES hotels(hotelID)
);

-- 13. Expenses Table
CREATE TABLE expenses (
    expenseID INT IDENTITY(1,1) PRIMARY KEY,
    bookingID INT NOT NULL,
    expenseAmount DECIMAL(10,2) NOT NULL,
    expenseType VARCHAR(100) NOT NULL, 
	CHECK (expenseAmount > 0),
    FOREIGN KEY (bookingID) REFERENCES bookings(bookingID)
);

-- 13. Payments Table
CREATE TABLE payments (
    paymentID INT IDENTITY(1,1) PRIMARY KEY,
    bookingID INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    paymentMethod VARCHAR(50) NOT NULL,
	CHECK (amount > 0),
    FOREIGN KEY (bookingID) REFERENCES bookings(bookingID),
);

-- 14. Cancellation_Refunds Table
CREATE TABLE cancellation_refunds (
    cancellationID INT IDENTITY(1,1) PRIMARY KEY,
    bookingID INT NOT NULL,
    cancellationReason VARCHAR(255) NOT NULL,
    refundAmount DECIMAL(10,2),
    CHECK(refundAmount >= 0),
    FOREIGN KEY (bookingID) REFERENCES bookings(bookingID)
);

-- Simple alter and update queries
ALTER TABLE Customers
ADD Gender VARCHAR(25) NOT NULL
    CONSTRAINT CHK_Customers_Gender CHECK (Gender IN ('Male', 'Female'));

UPDATE Destinations
SET city = 'berlin'
WHERE destinationID = 10;

-- Insert data into customers
INSERT INTO customers (FirstName, LastName, Gender, Email, PhoneNo, Address) VALUES
('Ali', 'Khan', 'Male', 'ali.khan@example.com', '03001234567', 'Lahore, Pakistan'),
('Sara', 'Naveed','Female', 'sara.naveed@example.com', '03211234567', 'Karachi, Pakistan'),
('Hassan', 'Raza','Male', 'hassan.raza@example.com', '03451234567', 'Islamabad, Pakistan'),
('Zain', 'Iqbal','Male', 'zain.iqbal@example.com', '03007654321', 'Multan, Pakistan'),
('Aisha', 'Khalid','Female', 'aisha.khalid@example.com', '03119876543', 'Faisalabad, Pakistan'),
('Bilal', 'Javed','Male', 'bilal.javed@example.com', '03335678912', 'Rawalpindi, Pakistan'),
('Noor', 'Fatima','Female', 'noor.fatima@example.com', '03456789012', 'Hyderabad, Pakistan'),
('Omer', 'Saleem','Male', 'omer.saleem@example.com', '03012345678', 'Quetta, Pakistan'),
('Maha', 'Hussain','Female', 'maha.hussain@example.com', '03211223344', 'Peshawar, Pakistan'),
('Yasir', 'Ali','Male', 'yasir.ali@example.com', '03123456789', 'Sialkot, Pakistan');

-- Insert data into destinations
INSERT INTO destinations (country, city, category, rating) VALUES
('UAE', 'Dubai', 'Luxury, Modern', 4),
('Turkey', 'Istanbul', 'Historical, Scenic', 3),
('Malaysia', 'Kuala Lumpur', 'Urban, Shopping', 3),
('France', 'Paris', 'Romantic, Cultural', 4),
('USA', 'New York', 'Urban, Entertainment', 4),
('UK', 'London', 'Historical, Business', 3),
('Japan', 'Tokyo', 'Technology, Urban', 4),
('Italy', 'Rome', 'Historical, Cultural', 4),
('Thailand', 'Bangkok', 'Nightlife, Cultural', 3),
('Germany', 'Berlin', 'Historical, Urban', 3);

-- Insert data into flights 
INSERT INTO flights (airline, departureCity, arrivalCity, duration) VALUES
('Emirates', 'Lahore', 'Dubai', 2),
('Turkish Airlines', 'Karachi', 'Istanbul', 2),
('Malaysia Airlines', 'Islamabad', 'Kuala Lumpur', 3),
('Air France', 'Multan', 'Paris', 8),
('American Airlines', 'Faisalabad', 'New York', 5),
('British Airways', 'Rawalpindi', 'London', 7),
('Japan Airlines', 'Hyderabad', 'Tokyo', 5),
('Qatar Airways', 'Quetta', 'Rome', 10),
('Singapore Airlines', 'Peshawar', 'Bangkok', 4),
('Cathay Pacific', 'Sialkot', 'Berlin', 7);

-- Insert data into transportation
INSERT INTO transportation (transportationType, companyName, price, class_type) VALUES
('Bus', 'ABC Travels',20,'Family'),
('Private Car', 'XYZ Rentals',50,'AC'),
('Train', 'Pakistan Railways',15,'AC'),
('Flight', 'Emirates',80,'Business'),
('Cruise', 'Royal Caribbean',60,'Family'),
('Taxi', 'Uber',30,'Non-AC'),
('Private Coach', 'Tour Coaches Inc.',50,'Business'),
('Boat', 'Blue Water Tours',40,'Family'),
('Bicycle', 'CycloTours',15,'Solo'),
('Helicopter', 'SkyRides',100,'Business');

-- Insert data into guides
INSERT INTO guides (fullName, email, contactNumber,experience,charges,Available) VALUES
('John Smith', 'john.smith@example.com', '0123456789',7,170,'Yes'),
('Sarah Johnson', 'sarah.johnson@example.com', '0987654321',5,150,'Yes'),
('Michael Brown', 'michael.brown@example.com', '0192837465',2,100,'No'),
('Emily Davis', 'emily.davis@example.com', '0147628391',10,200,'No'),
('James Williams', 'james.williams@example.com', '0194738291',3,120,'Yes'),
('Olivia Clark', 'olivia.clark@example.com', '0182837465',4,130,'Yes'),
('David Lewis', 'david.lewis@example.com', '0152837461',4,140,'No'),
('Isabella Martinez', 'isabella.martinez@example.com', '0146578290',3,120,'Yes'),
('Ethan Wilson', 'ethan.wilson@example.com', '0134782915',8,180,'No'),
('Sophia Taylor', 'sophia.taylor@example.com', '0192847365',5,150,'Yes');

-- Insert data into packages
INSERT INTO packages (packageName, description, price, durationDays, destinationID,meal_plan) VALUES
('Beach Paradise', 'A relaxing vacation at a luxurious beach resort', 1200.00,7, 1,'Inclusive'),  -- Package 1: Dubai
('Cultural Tour', 'Explore the cultural heritage of the city with guided tours', 1000.00,5, 2,'Inclusive'),  -- Package 2: Istanbul
('Mountain Expedition', 'Trek through the beautiful mountain ranges with expert guides', 1500.00,10, 3,'Exclusive'),  -- Package 3: Kuala Lumpur
('City Exploration', 'Discover the historic landmarks and modern attractions of the city', 1300.00,8, 4,'Inclusive'),  -- Package 4: Paris
('Luxury Cruise', 'A cruise to exotic destinations with all-inclusive services', 2000.00,21, 5,'Exclusive'),  -- Package 5: New York
('Adventure Seekers', 'For those seeking thrill, activities like bungee jumping, hiking, and more', 1800.00, 14, 6,'Exlusive'),  -- Package 6: London
('Safari Expedition', 'Experience the wildlife and beauty of Africa through safari tours', 2200.00,25, 7,'Inclusive'),  -- Package 7: Tokyo
('Desert Oasis', 'Explore the desert landscapes with luxury camping and dune adventures', 1600.00,20, 8,'Inclusive'),  -- Package 8: Rome
('Historical Journey', 'Visit the ancient landmarks and monuments of historic civilizations', 1400.00,14, 9,'Exclusive'),  -- Package 9: Berlin
('Island Getaway', 'Escape to a tropical island with luxury resorts and water activities', 1700.00,18, 10,'Exclusive');  -- Package 10: Bangkok

-- Insert data into bookings
INSERT INTO bookings (customerID, packageID, flightID, transportationID, numPassengers, bookingDate, guideID, status) VALUES
(10, 10, 10, 5, 3, '2023-12-12', 9, 'Confirmed'), -- Past
(1, 1, 1, 2, 5, '2024-05-17', 1, 'Confirmed'),  -- Past
(3, 8, 8, 5, 3, '2024-06-12', 7, 'Confirmed'),  -- Past
(9, 4, 4, 2, 2, '2025-02-14', NULL, 'Confirmed'),  -- Future
(6, 4, 4, 2, 2, '2025-02-15', NULL, 'Confirmed'), -- Future
(7, 7, 7, 6, 4, '2025-02-22', 3, 'Confirmed'),  -- Future
(3, 9, 9, 7, 12, '2025-02-28', 9, 'Confirmed'),  -- Future
(1, 10, 10, 3, 7, '2025-03-01', 4, 'Confirmed'),  -- Future
(5, 6, 6, 9, 1, '2025-03-12', NULL, 'Confirmed'),  -- Future
(4, 6, 6, 9, 1, '2025-03-15', NULL, 'Cancelled'),  -- Future
(2, 2, 2, 5, 12, '2025-03-28', 7, 'Confirmed');  -- Future

-- Insert data into activities
INSERT INTO activities (activityName, price, description) VALUES
('Scuba Diving', 200.00, 'Underwater adventure with trained instructors'),
('Sky Diving', 500.00, 'Jump from a plane with a parachute'),
('Hot Air Balloon', 150.00, 'See the city from the skies'),
('Bungee Jumping', 180.00, 'Extreme free-fall experience'),
('Museum Visit', 50.00, 'Explore history and artifacts'),
('Hiking Trip', 70.00, 'Trekking in beautiful landscapes'),
('City Bus Tour', 40.00, 'Guided tour around the city'),
('Boat Cruise', 120.00, 'Luxury ride across the river'),
('Theme Park', 90.00, 'Enjoy thrilling rides and shows'),
('Safari Tour', 220.00, 'Explore wildlife in natural habitat');

-- Insert data into bookingActivities
INSERT INTO bookingActivities (bookingID, activityID) VALUES
(1, 1), (1, 7), (1, 9),
(2, 3),
(3, 5), (3, 6),
(4, 7), (4, 8), (4, 10), (4, 4),
(5, 9), (5, 10),
(6, 1), (6, 5), 
(7, 2), (7, 6), 
(8, 3), (8, 7), 
(9, 4), 
(10, 9), (10, 10),  
(11, 9), (11, 10);  

-- Insert data into hotels
INSERT INTO hotels (hotelName, city, address, country, contactNumber) VALUES
('Burj Al Arab', 'Dubai', 'Jumeirah, Dubai', 'UAE', '0421234567'),
('Four Seasons', 'Istanbul', 'Sultanahmet, Istanbul', 'Turkey', '0212123456'),
('Shangri-La', 'Kuala Lumpur', 'Jalan Sultan, KL', 'Malaysia', '0323456789'),
('Ritz Paris', 'Paris', 'Place Vendome, Paris', 'France', '0123456789'),
('The Plaza', 'New York', 'Fifth Avenue, NY', 'USA', '001212345678'),
('Savoy Hotel', 'London', 'Strand, London', 'UK', '0201234567'),
('Park Hyatt', 'Tokyo', 'Shinjuku, Tokyo', 'Japan', '0312345678'),
('Rome Cavalieri', 'Rome', 'Via Alberto, Rome', 'Italy', '0391234567'),
('Adlon Kempinski', 'Berlin', 'Unter den Linden, Berlin', 'Germany', '0491234567'),
('Mandarin Oriental', 'Bangkok', 'Chao Phraya River, Bangkok', 'Thailand', '0661234567');

-- Insert data into hotelBooking
INSERT INTO hotelBooking (bookingID, hotelID, checkInDate, checkOutDate) VALUES
(9, 1, '2025-04-21', '2025-04-29'),
(6, 3, '2025-04-18', '2025-04-26'),
(7, 1, '2025-04-01', '2025-04-26'),
(3, 2, '2025-04-10', '2025-04-24'),
(1, 5, '2025-04-01', '2025-04-19'),
(5, 2, '2025-04-12', '2025-04-26'),
(4, 3, '2025-04-18', '2025-04-30'),
(2, 1, '2025-03-28', '2025-04-03');

-- Insert data into expenses
INSERT INTO expenses (bookingID, expenseAmount, expenseType) VALUES
-- Booking ID 1
(1, 1700.00, 'Package Cost'),
(1, 60.00, 'Transportation'),
(1, 200.00, 'Activity'),
(1, 40.00, 'Activity'),
(1, 90.00, 'Activity'),
(1, 180.00, 'Tour Guide'),

-- Booking ID 2 
(2, 1200.00, 'Package Cost'),
(2, 50.00, 'Transportation'),
(2, 150.00, 'Activity'),
(2, 170.00, 'Tour Guide'),

-- Booking ID 3 
(3, 1500.00, 'Package Cost'),
(3, 60.00, 'Transportation'),
(3, 50.00, 'Activity'),
(3, 70.00, 'Activity'),
(3, 140.00, 'Tour Guide'),

-- Booking ID 4 
(4, 1300.00, 'Package Cost'),
(4, 50.00, 'Transportation'),
(4, 40.00, 'Activity'),
(4, 120.00, 'Activity'),
(4, 180.00, 'Activity'),
(4, 220.00, 'Activity'),

-- Booking ID 5
(5, 1300.00, 'Package Cost'),
(5, 50.00, 'Transportation'),
(5, 90.00, 'Activity'),
(5, 220.00, 'Activity'),

-- Booking ID 6 
(6, 2200.00, 'Package Cost'),
(6, 30.00, 'Transportation'),
(6, 200.00, 'Activity'),
(6, 50.00, 'Activity'),
(6, 100.00, 'Tour Guide'),

-- Booking ID 7 
(7, 1400.00, 'Package Cost'),
(7, 50.00, 'Transportation'),
(7, 500.00, 'Activity'),
(7, 70.00, 'Activity'),
(7, 180.00, 'Tour Guide'),

-- Booking ID 8 
(8, 1700.00, 'Package Cost'),
(8, 15.00, 'Transportation'),
(8, 150.00, 'Activity'),
(8, 40.00, 'Activity'),
(8, 200.00, 'Tour Guide'),

-- Booking ID 9 
(9, 1800.00, 'Package Cost'),
(9, 15.00, 'Transportation'),
(9, 180.00, 'Activity'),

-- Booking ID 10 
(10, 1800.00, 'Package Cost'),
(10, 15.00, 'Transportation'),
(10, 90.00, 'Activity'),
(10, 220.00, 'Activity'),

-- Booking ID 11
(11, 1000.00, 'Package Cost'),
(11, 60.00, 'Transportation'),
(11, 90.00, 'Activity'),
(11, 220.00, 'Activity'),
(11, 140.00, 'Tour Guide');

-- Insert data into payments
INSERT INTO payments (bookingID, amount, paymentMethod) VALUES
(1, 2090.00, 'Credit Card'),
(2, 1570.00, 'Bank Transfer'),
(3, 1820.00, 'PayPal'),
(4, 1910.00, 'Cash'),
(5, 1660.00, 'Credit Card'),
(6, 2580.00, 'Debit Card'),
(7, 2200.00, 'Bank Transfer'),
(8, 2105.00, 'PayPal'),
(9, 1995.00, 'Cash'),
(10, 2125.00, 'Credit Card'),
(11, 1510.00, 'Credit Card');

-- Insert data into cancellation_refunds
INSERT INTO cancellation_refunds (bookingID, cancellationReason, refundAmount) VALUES
(10, 'Personal Reason', 2180.00);

--                                      :::::: VISUAL TABLES ::::::
SELECT * FROM customers;
SELECT * FROM destinations;
SELECT * FROM flights;
SELECT * FROM transportation;
SELECT * FROM guides;
SELECT * FROM packages;
SELECT * FROM bookings;
SELECT * FROM activities;
SELECT * FROM bookingActivities;
SELECT * FROM hotels;
SELECT * FROM hotelBooking;
SELECT * FROM payments;
SELECT * FROM expenses;
SELECT * FROM cancellation_refunds;

--                                          :::::: VIEWS SECTION ::::::
-- 1. Customers who are on tour
CREATE VIEW Customers_on_tour AS 
SELECT 
  c.firstname + ' ' + c.lastname AS customerName, 
  p.packagename, 
  b.bookingID, 
  h.hotelname, 
  hb.checkOutDate 
FROM 
  bookings AS b 
  JOIN customers AS c ON b.customerID = c.customerID 
  JOIN packages AS p ON b.packageID = p.packageID 
  JOIN hotelBooking AS hb ON hb.bookingID = b.bookingID 
  JOIN hotels AS h ON hb.hotelID = h.hotelID 
WHERE 
  hb.checkOutDate > getdate();

-- Check view
SELECT * FROM Customers_on_tour;

-- 2. See available guides
CREATE VIEW Available_guides AS 
SELECT * FROM guides 
WHERE 
  available = 'Yes';

-- Check view
SELECT * FROM Available_guides;

-- 3. Which hotel was booked how many times
CREATE VIEW most_selected_hotels AS 
SELECT 
  hb.hotelID, 
  h.hotelname, 
  h.country, 
  h.city, 
  COUNT(*) AS booked 
FROM 
  hotelBooking AS hb 
  JOIN hotels AS h on h.hotelID = hb.hotelID 
GROUP BY 
  hb.hotelID, 
  h.hotelname, 
  h.country, 
  h.city;

-- Check view
SELECT * FROM most_selected_hotels;

-- 4. Packages expense only
CREATE VIEW packages_expense AS 
SELECT 
  p.packageName, 
  e.expenseAmount 
FROM 
  expenses AS e 
  JOIN bookings AS b ON b.bookingID = e.bookingID 
  JOIN packages AS p on b.packageID = p.packageID 
WHERE 
  e.expenseType = 'Package Cost';

-- Check view
SELECT * FROM packages_expense;

-- 5. Amount earned from transportation
CREATE VIEW transportation_expense AS 
SELECT 
  t.transportationType, 
  e.expenseAmount 
FROM 
  expenses AS e 
  JOIN bookings AS b ON b.bookingID = e.bookingID 
  JOIN transportation AS t on t.transportationID = b.transportationID 
WHERE 
  e.expenseType = 'Transportation'; 

-- Check view
SELECT * FROM transportation_expense;

-- 6. Amount earned from activities
CREATE VIEW Activities_expense AS 
SELECT 
  b.bookingID, 
  e.expenseAmount 
FROM 
  expenses AS e 
  JOIN bookings AS b ON b.bookingID = e.bookingID 
WHERE 
  e.expenseType = 'Activity'; 

-- Check view
SELECT * FROM Activities_expense;

-- 7. Amount earned from guides 
CREATE VIEW guides_expense AS 
SELECT 
  g.fullName, 
  e.expenseAmount 
FROM 
  expenses AS e 
  JOIN bookings AS b ON b.bookingID = e.bookingID 
  JOIN guides AS g on b.guideID = g.guideID 
WHERE 
  e.expenseType = 'Tour Guide';
  
-- Check view
SELECT * FROM guides_expense;

--                                     :::::: BACKUP TABLES ::::::
SELECT * INTO customers_backup FROM customers WHERE 1=0;
SELECT * INTO destinations_backup FROM destinations WHERE 1=0;
SELECT * INTO flights_backup FROM flights WHERE 1=0;
SELECT * INTO transportation_backup FROM transportation WHERE 1=0;
SELECT * INTO guides_backup FROM guides WHERE 1=0;
SELECT * INTO packages_backup FROM packages WHERE 1=0;
SELECT * INTO bookings_backup FROM bookings WHERE 1=0;
SELECT * INTO activities_backup FROM activities WHERE 1=0;
SELECT * INTO bookingActivities_backup FROM bookingActivities WHERE 1=0;
SELECT * INTO hotels_backup FROM hotels WHERE 1=0;
SELECT * INTO hotelBooking_backup FROM hotelBooking WHERE 1=0;
SELECT * INTO payments_backup FROM payments WHERE 1=0;
SELECT * INTO expenses_backup FROM expenses WHERE 1=0;
SELECT * INTO cancellation_refunds_backup FROM cancellation_refunds WHERE 1=0;

--                              :::::: TRIGGERS TO INSERT INTO BACKUP TABLES :::::::

-- 1. Customers Table Trigger
CREATE TRIGGER trg_Customers_Backup
ON customers
AFTER DELETE
AS
BEGIN
    SET IDENTITY_INSERT customers_backup ON;
    
    INSERT INTO customers_backup (customerID, FirstName, LastName, Email, PhoneNo, Address)
    SELECT customerID, FirstName, LastName, Email, PhoneNo, Address FROM deleted;

    SET IDENTITY_INSERT customers_backup OFF; 
END;



-- 2. Destinations Table Trigger
CREATE TRIGGER trg_Destinations_Backup
ON destinations
AFTER DELETE
AS
BEGIN
    INSERT INTO destinations_backup (destinationID, country, city,category,rating)
    SELECT destinationID, country, city,category,rating FROM deleted;
END;
GO

-- 3. Flights Table Trigger
CREATE TRIGGER trg_Flights_Backup
ON flights
AFTER DELETE
AS
BEGIN
    SET IDENTITY_INSERT flights_backup ON;
    INSERT INTO flights_backup (flightID, airline, departureCity, arrivalCity, duration)
    SELECT flightID, airline,  departureCity, arrivalCity, duration FROM deleted;
    SET IDENTITY_INSERT flights_backup OFF;
END;
GO

-- 4. Transportation Table Trigger
CREATE TRIGGER trg_Transportation_Backup
ON transportation
AFTER DELETE
AS
BEGIN
    INSERT INTO transportation_backup (transportationID, transportationType, companyName, price,class_type)
    SELECT transportationID, transportationType, companyName, price,class_type FROM deleted;
END;
GO

-- 6. Guides Table Trigger
CREATE TRIGGER trg_Guides_Backup
ON guides
AFTER DELETE
AS
BEGIN
    INSERT INTO guides_backup (guideID, fullName, email, contactNumber,experience,charges,available)
    SELECT guideID, fullName, email, contactNumber, experience,charges, Available FROM deleted;
END;
GO

-- 7. Packages Table Trigger
CREATE TRIGGER trg_Packages_Backup
ON packages
AFTER DELETE
AS
BEGIN
    INSERT INTO packages_backup (packageID, packageName, description,price,durationDays,meal_plan, destinationID)
    SELECT packageID, packageName, description,price,durationDays, meal_plan, destinationID FROM deleted;
END;
GO

-- 8. Bookings Table Trigger
CREATE TRIGGER trg_Bookings_Backup
ON bookings
AFTER DELETE
AS
BEGIN
    SET IDENTITY_INSERT bookings_backup ON;
    INSERT INTO bookings_backup (bookingID, customerID, packageID, bookingDate, numPassengers, flightID, transportationID,  guideID,status)
    SELECT bookingID, customerID, packageID, bookingDate, numPassengers, flightID, transportationID,guideID, status FROM deleted;
    SET IDENTITY_INSERT bookings_backup OFF;
END;
GO

-- 9. Activities Table Trigger
CREATE TRIGGER trg_Activities_Backup
ON activities
AFTER DELETE
AS
BEGIN
    INSERT INTO activities_backup (activityID, activityName, price, description)
    SELECT activityID, activityName, price, description FROM deleted;
END;
GO

-- 10. Booking Activities Table Trigger
CREATE TRIGGER trg_BookingActivities_Backup
ON bookingActivities
AFTER DELETE
AS
BEGIN
    INSERT INTO bookingActivities_backup (bookingActivitiesID, bookingID, activityID)
    SELECT bookingActivitiesID, bookingID, activityID FROM deleted;
END;
GO

-- 11. Hotels Table Trigger
CREATE TRIGGER trg_Hotels_Backup
ON hotels
AFTER DELETE
AS
BEGIN
    INSERT INTO hotels_backup (hotelID, hotelName, city, address, country, contactNumber)
    SELECT hotelID, hotelName, city, address, country, contactNumber FROM deleted;
END;
GO

-- 12. Hotel Booking Table Trigger
CREATE TRIGGER trg_HotelBooking_Backup
ON hotelBooking
AFTER DELETE
AS
BEGIN
    INSERT INTO hotelBooking_backup (hotelBookingID, bookingID, hotelID, checkInDate, checkOutDate)
    SELECT hotelBookingID, bookingID, hotelID, checkInDate, checkOutDate FROM deleted;
END;
GO

-- 13. Payments Table Trigger
CREATE TRIGGER trg_Payments_Backup
ON payments
AFTER DELETE
AS
BEGIN
    INSERT INTO payments_backup (paymentID, bookingID,  amount, paymentMethod)
    SELECT paymentID, bookingID, amount, paymentMethod FROM deleted;
END;
GO

-- 14. Expenses Table Trigger
CREATE TRIGGER trg_Expenses_Backup
ON expenses
AFTER DELETE
AS
BEGIN
    INSERT INTO expenses_backup (expenseID, bookingID, expenseAmount, expenseType)
    SELECT expenseID, bookingID, expenseAmount, expenseType FROM deleted;
END;
GO

-- 15. Cancellation Refunds Table Trigger
CREATE TRIGGER trg_CancellationRefunds_Backup
ON cancellation_refunds
AFTER DELETE
AS
BEGIN
    INSERT INTO cancellation_refunds_backup (cancellationID, bookingID, cancellationReason,  refundAmount)
    SELECT cancellationID, bookingID, cancellationReason, refundAmount FROM deleted;
END;
GO
--                                         :::::: QUERIES :::::: 
-- (i) BASIC
-- (ii) AGGREGATES
-- (iii) INNER JOIN
-- (iv) LEFT JOIN
-- (v) RIGHT JOIN
-- (vi) FULL OUTER JOIN
-- (vii) SUB-QUERY

--1️.Retrieve all bookings made by a specific customer
SELECT 
  bookingID, 
  customerID, 
  bookingDate 
FROM 
  Bookings 
WHERE 
  customerID = 3;

--2️.List all destinations for a given booking
SELECT 
  b.bookingID, 
  d.destinationID, 
  d.city, 
  d.country AS location 
From 
  destinations d, 
  bookings b 
where 
  bookingID = 7 
  and destinationID in (
    select 
      destinationID 
    from 
      packages P 
    where 
      P.packageID = B.packageID
  );

--3️.Find the total number of bookings made in the system
SELECT 
  COUNT(*) AS TOTAL_BOOKINGS 
FROM 
  bookings;

--4️.Calculate the total revenue generated from all bookings
SELECT 
  SUM(amount) AS TOTAL_REVENUE 
FROM 
  payments;

--5️.Retrieve a list of customers along with their booked destinations
SELECT 
  B.bookingID, 
  B.customerID, 
  C.firstName + ' ' + C.lastname AS customerName, 
  D.city AS destinationName 
FROM 
  Bookings AS B 
  JOIN customers AS C ON C.customerID = B.customerID 
  JOIN packages AS P ON P.packageID = B.packageID 
  JOIN destinations AS D ON P.destinationID = D.destinationID;

--6️.Find all customers who have not booked any trips
SELECT 
  C.customerID, 
  C.firstName + ' ' + C.lastName AS customer_name 
FROM 
  customers AS C 
  LEFT JOIN bookings AS B ON C.customerID = B.customerID 
WHERE 
  B.customerID IS NULL;

--7️.Retrieve all destinations that cost more than the average booking cost
SELECT 
  D.city AS DESTINATION, 
  P.price AS CHARGES 
FROM 
  packages AS P, 
  Destinations d 
WHERE 
  price > (
    SELECT 
      AVG(price) AS AVG_COST 
    FROM 
      packages
  ) 
  and D.destinationID = P.destinationID;

--8️.Find the details of the customer who made the most expensive booking
SELECT 
  Top 1 C.customerID, 
  B.bookingID, 
  C.firstName + ' ' + C.lastName AS customer_name, 
  SUM(E.expenseAmount) AS TOTAL_EXPENSE 
FROM 
  Bookings AS B 
  JOIN Customers AS C ON B.customerID = C.customerID 
  JOIN Expenses AS E on E.bookingID = B.bookingID 
GROUP BY 
  C.customerID, 
  B.bookingID, 
  C.firstName, 
  C.lastName 
ORDER BY 
  TOTAL_EXPENSE DESC;

--9️.Find all bookings that include a guide
SELECT 
  b.bookingID, 
  c.firstName + ' ' + c.lastName AS customer_name, 
  g.guideID, 
  g.fullName 
FROM 
  bookings AS b 
  JOIN customers AS c On c.customerID = b.customerID 
  JOIN guides AS g on g.guideID = b.guideID 
WHERE 
  b.guideID IS NOT NULL;

--10.List all transportation options used for each booking
SELECT 
  b.bookingID, 
  c.firstName + ' ' + c.lastName AS customer_name, 
  t.transportationID, 
  t.transportationType 
FROM 
  bookings AS b 
  JOIN customers AS c on b.customerID = c.customerID 
  JOIN transportation AS t ON t.transportationID = b.transportationID 
ORDER BY 
  b.bookingID;

--1️1.What activities are planned at First destination
select 
  a.activityID, 
  a.activityName, 
  d.destinationID 
from 
  activities as a, 
  bookingActivities as ba, 
  bookings as b, 
  destinations as d, 
  packages as p 
where 
  a.activityID = ba.activityID 
  and ba.bookingID = b.bookingID 
  and b.packageID = p.packageID 
  and d.destinationID = p.destinationID 
  and d.destinationID = 1;

--12️.What are the expenses for a given booking -
select 
  bookingID, 
  expenseID, 
  expenseType, 
  expenseAmount 
from 
  expenses 
where 
  bookingID = 4;

--13️.Question: What is the average cost of all bookings?
select 
  avg(expenseAmount) as average_booking_cost 
from 
  expenses;

--14️.How many customers have booked at least one trip?
select 
  count(distinct customerID) as total_customers_with_bookings 
from 
  customers 
where 
  customerID in (
    select 
      CustomerID 
    from 
      bookings
  );

--15.Which customers have booked a trip to destination 'Paris'?
select 
  B.bookingID, 
  C.customerID, 
  C.firstName + ' ' + C.lastName AS customer_name, 
  D.city as destinationName 
from 
  customers as C, 
  bookings as B, 
  destinations as D, 
  flights as F 
where 
  C.customerID = B.customerID 
  and B.flightID = F.flightID 
  and D.city = F.arrivalCity 
  and D.city = 'Paris';

--16️.How many times has each destination been booked?
select 
  D.city as DestinationName, 
  count(B.BookingID) as times_booked 
from 
  Destinations as D 
  join Flights as F on D.city = F.arrivalCity 
  join bookings as B on F.FlightID = B.FlightID 
group by 
  D.city;

--17️.Which customers booked the same destination multiple times?
select 
  C.customerID, 
  C.FirstName, 
  C.lastName, 
  D.city as destinationName, 
  count(b.bookingID) as times_booked 
from 
  customers as C, 
  bookings as B, 
  destinations as D, 
  flights as F 
where 
  C.customerID = B.customerID 
  and B.flightID = F.flightID 
  and D.city = F.arrivalCity 
group by 
  C.customerID, 
  C.FirstName, 
  C.lastName, 
  D.city 
having 
  count(b.bookingID)> 1;

--18️.Which three customers have spent the most?
select 
  top 3 C.customerID, 
  C.FirstName, 
  C.LastName, 
  sum(E.expenseAmount) as TotalSpent 
from 
  customers as C 
  join bookings as B on B.customerID = C.customerID 
  join expenses as E on B.bookingID = E.bookingID 
group by 
  C.customerID, 
  C.FirstName, 
  C.LastName 
order by 
  sum(E.expenseAmount) desc;

--19️.Which bookings were canceled and what were the refund details?
select 
  B.bookingID, 
  C.FirstName, 
  C.LastName, 
  CR.refundAmount, 
  CR.cancellationReason 
from 
  bookings B, 
  Customers C, 
  Cancellation_refunds as CR 
where 
  C.customerID = B.customerID 
  and B.bookingID = CR.bookingID;

--20.Which hotel is booked for a given booking ?
select 
  HB.BookingID, 
  HB.HotelID, 
  H.HotelName, 
  H.address 
from 
  Hotels H, 
  HotelBooking HB 
where 
  H.HotelID = hB.HotelID 
  and bookingID = 1;

--21.How many Trips each customer booked?
select 
  B.CustomerID, 
  count(C.customerID) as total_trips 
from 
  customers C 
  join Bookings B on C.customerID = B.customerID 
group by 
  b.CustomerID 
order by 
  total_trips;

--22.Retrieve total number of customers with bookings?
select 
  count(b.customerID) as total_customers_with_bookings 
from 
  customers C 
  join Bookings B on C.customerID = B.customerID;

--23.Which flight is booked for a given booking ?
select 
  b.bookingID, 
  b.flightid, 
  f.departureCity, 
  f.arrivalCity 
from 
  flights as f, 
  bookings as b 
where 
  f.flightID = b.flightID 
  and b.bookingID = 5;

--24.How many customers have booked trips to Berlin?
select 
  count(c.customerID) as Total_Dubai_Customers 
from 
  customers as c 
  join bookings as b on c.customerID = b.customerID 
  join flights as f on b.flightID = f.flightID 
  join destinations as d on d.city = f.arrivalCity 
where 
  d.city = 'berlin';

--25.What is the total amount spent by each customer
select 
  c.customerID, 
  c.FirstName, 
  c.LastName, 
  sum(e.expenseAmount) as Total_Amount 
from 
  customers as c 
  join bookings as b on b.customerID = c.customerID 
  join expenses as e on b.bookingID = e.bookingID 
group by 
  c.customerID, 
  c.FirstName, 
  c.LastName;

--26.Which destinations are more expensive than the average
Select 
  d.city 
from 
  destinations as d 
where 
  d.destinationID IN (
    select 
      p.destinationID 
    from 
      packages AS p 
    where 
      p.price > (
        select 
          AVG(p1.price) 
        from 
          packages AS p1
      )
  );

--28.Get a list of all hotels and their booking information, including hotels that have no bookings.
select 
  * 
from 
  hotels as h 
  left join hotelBooking as hb on h.hotelID = hb.hotelID;

--29.Find all packages and their associated bookings, if any.
select 
  p.packageID, 
  p.packageName, 
  p.destinationID, 
  b.customerID, 
  b.bookingID 
from 
  packages as p 
  left join bookings as b on p.packageID = b.packageID;

--30.Display all activities and their associated bookings, if any.
select 
  ba.bookingID, 
  a.activityID, 
  a.activityName, 
  a.price, 
  ba.bookingActivitiesID 
from 
  activities as a 
  left join bookingactivities as ba on a.activityID = ba.activityID;

--32.Display all bookings and their associated customers, including bookings that may not have a customer linked.
select 
  b.bookingID, 
  b.bookingDate, 
  c.customerID, 
  c.FirstName, 
  c.LastName 
from 
  customers as c 
  right join bookings as b on b.customerID = c.customerID;

--33.List all transportation options and their bookings, including those that may not have a booking linked.
select 
  t.transportationID, 
  t.companyName, 
  t.transportationType, 
  b.bookingID, 
  b.bookingDate 
from 
  bookings as b 
  right join transportation as t on t.transportationID = b.transportationID;

--34.Show all guides and their associated bookings, even if there are no bookings linked to a guide.
select 
  g.guideID, 
  g.fullName, 
  g.email, 
  b.bookingID, 
  b.bookingDate 
from 
  bookings as b 
  right join guides as g on g.guideID = b.guideID;

--35.Find all flight information and associated bookings, including flights that have not been booked.
select 
  f.flightID, 
  f.arrivalCity, 
  f.arrivalCity, 
  f.duration, 
  b.bookingID, 
  b.bookingDate 
from 
  bookings as b 
  right join flights as f on f.flightID = b.flightID;

--36.Get a list of all payments and their corresponding bookings, even if a booking doesn’t have a payment yet
select 
  p.paymentID, 
  p.amount, 
  p.paymentMethod, 
  b.bookingID, 
  b.bookingDate 
from 
  bookings as b 
  right join payments as p on p.bookingID = b.bookingID;

--37.Retrieve all customers and their bookings,
--including customers who haven't made a booking and bookings without a matching customer
select 
  b.bookingID, 
  c.customerID, 
  c.FirstName, 
  c.LastName 
from 
  customers as c full 
  outer join bookings as b on b.customerID = c.customerID;

--38.Retrieve all flights and their bookings,
--including flights that have never been booked and bookings that do not have a matching flight
select 
  b.bookingID, 
  f.flightID, 
  f.airline, 
  f.duration 
from 
  bookings as b full 
  outer join flights as f on b.flightID = f.flightID;

--39.Retrieve all hotels and their bookings,
--including hotels that have never been booked and hotel bookings that do not have a matching hotel
select 
  h.hotelID, 
  h.hotelName, 
  hb.hotelBookingID 
from 
  hotels as h full 
  outer join hotelBooking as hb on h.hotelID = hb.hotelID;

--40.Retrieve all bookings and their payments,
--including bookings that have not been paid and payments that do not have a matching booking
select 
  p.paymentID, 
  p.amount, 
  p.paymentMethod, 
  b.bookingID, 
  b.bookingDate 
from 
  bookings as b full 
  outer join payments as p on p.bookingID = b.bookingID;

--41.Retrieve all travel packages and their destinations,
--including packages that are not assigned to a destination and destinations that do not have any linked package
select 
  * 
from 
  packages as p full 
  outer join destinations as d on p.destinationID = d.destinationID;

--42.Retrieve all activities and their related bookings,
--including activities that have never been booked and bookings that do not have any activity assigned
select 
  ba.bookingID, 
  a.activityID, 
  a.activityName, 
  a.price, 
  ba.bookingActivitiesID 
from 
  activities as a full 
  outer join bookingactivities as ba on a.activityID = ba.activityID;

--                                        :::::: TRIGGERS ::::::

-- 1.Package Expense Trigger
CREATE TRIGGER trg_packageExpense
ON bookings  
AFTER INSERT  
AS  
BEGIN  
    INSERT INTO expenses (bookingID, expenseAmount, expenseType)  
    SELECT b.bookingID, p.price, 'package'
    FROM inserted b  
    JOIN packages as p ON p.packageID = b.packageID;
END;

-- 2.Transport Expense Trigger
CREATE TRIGGER trg_transportExpense
ON bookings  
AFTER INSERT  
AS  
BEGIN  
    INSERT INTO expenses (bookingID, expenseAmount, expenseType)  
    SELECT b.bookingID, t.price, t.transportationType
    FROM inserted b  
    JOIN transportation t ON b.transportationID = t.transportationID; 
END;

-- 3.Guide Expense Trigger
CREATE TRIGGER trg_GuideExpense
ON bookings  
AFTER INSERT  
AS  
BEGIN  
    INSERT INTO expenses (bookingID, expenseAmount, expenseType)  
    SELECT b.bookingID,g.charges , 'Guide'
    FROM inserted b  
    JOIN guides as g ON b.guideID = g.guideID; 
END;

-- 4.Activity Expense trigger
CREATE TRIGGER trg_ActivityExpense
ON bookingactivities 
AFTER INSERT  
AS  
BEGIN  
    INSERT INTO expenses (bookingID, expenseAmount, expenseType)  
    SELECT b.bookingID,a.price , a.activityName  
    FROM inserted ba  
    JOIN activities as a ON ba.activityID = a.activityID
	join bookings as b on b.bookingID=ba.bookingID; 
END;

-- 5.Set booking status cancelled when payment is rfunded
CREATE TRIGGER trg_set_booking_status_cancelled
ON cancellation_refunds
AFTER INSERT
AS
BEGIN
    UPDATE bookings
    SET status = 'Cancelled'
    WHERE bookingID IN (SELECT bookingID FROM inserted);
END;

-- 6.Auto set booking status on confirmed when payment is paid
CREATE TRIGGER trg_set_booking_status_confirmed
ON payments
AFTER INSERT
AS
BEGIN
    UPDATE bookings
    SET status = 'Confirmed'
    WHERE bookingID IN (SELECT bookingID FROM inserted);
END;

-- 7.Check whether a Guide is available or not before choosing it
CREATE TRIGGER trg_check_guide_availability
on bookings
instead of insert
as
begin
    if exists (
        SELECT 1
        FROM inserted i
        JOIN guides g ON i.guideID = g.guideID
        WHERE g.available <> 'Yes'
    )
    BEGIN
        RAISERROR('This guide is not available.', 16, 1);
        ROLLBACK;
        RETURN;
    end
    insert into bookings (
        customerID, packageID, flightID, transportationID, numPassengers, 
        bookingDate, guideID, status
    )
    select customerID, packageID, flightID, transportationID, numPassengers,
           bookingDate, guideID, status
    from inserted;
END;

-- 8.Check if refundAmount is greater than total amount paid for the booking
CREATE TRIGGER trg_refund_does_not_exceed_payment
ON cancellation_refunds
INSTEAD OF INSERT
AS
BEGIN
    
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN (
            SELECT bookingID, SUM(amount) AS totalPayment
            FROM payments
            GROUP BY bookingID
        ) p ON i.bookingID = p.bookingID
        WHERE i.refundAmount > p.totalPayment
    )
    BEGIN
        RAISERROR('Refund amount cannot exceed total payment.', 16, 1);
        ROLLBACK;
        RETURN;
    END
    INSERT INTO cancellation_refunds (bookingID, cancellationReason, refundAmount)
    SELECT bookingID, cancellationReason, refundAmount
    FROM inserted;
END;


-- Disable triggers
DISABLE TRIGGER trg_packageExpense ON bookings;
DISABLE TRIGGER trg_transportExpense ON bookings;
DISABLE TRIGGER trg_GuideExpense ON bookings;
DISABLE TRIGGER trg_ActivityExpense ON bookingactivities;
DISABLE TRIGGER trg_set_booking_status_cancelled ON cancellation_refunds;
DISABLE TRIGGER trg_set_booking_status_confirmed ON payments;
DISABLE TRIGGER trg_check_guide_availability ON bookings;
DISABLE TRIGGER trg_refund_does_not_exceed_payment ON cancellation_refunds;

