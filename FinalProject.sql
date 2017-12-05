---------------------------------|
---Brandon Traditi               |
---Traditi Property Management   |
---Database Management           |
---12/4/17                       |
---------------------------------|


----------------------------------|
---Drop Statements                |
----------------------------------|

DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS UsersPaymentInfo;
DROP TABLE IF EXISTS Bank;
DROP TABLE IF EXISTS CardInformation;
DROP TABLE IF EXISTS Cities;
DROP TABLE IF EXISTS Tenant;
DROP TABLE IF EXISTS Property;
DROP TABLE IF EXISTS Landlord;
DROP TABLE IF EXISTS PropertyDetails;
DROP TABLE IF EXISTS RentTransaction;

----------------------------------|
---Create Statements              |
----------------------------------|
CREATE TABLE Bank (
    bankID char(6) not null,
    bankName text not null,
    routingNum int not null,
    accountNum int not null,
primary key(bankID)
);

CREATE TABLE CardInformation (
    payCardID char(6) not null,
    cardCompany text not null,
    nameOnCard text not null,
    cardNum varchar(16) not null,
    expirationDate varchar(5) not null,
    securityCode int not null,
primary key(payCardID)
);

CREATE TABLE UsersPaymentInfo (
    paymentID char(6) not null,
    payCardID char(6) references CardInformation(payCardID),
    bankID char(6) references Bank(bankID),
primary key(paymentID)
);
 

CREATE TABLE Cities(
	cityID char(6) not null,
	cityName text not null,
	zipCode int not null,
	stateUSA text not null,
primary key(cityID)
);

CREATE TABLE Users (
    userID char(6) not null,
    paymentID char(6) not null references UsersPaymentInfo(paymentID),
    cityID char(6) not null references Cities(cityID),
    firstName text not null,
    lastName text not null,
	gender char(1) not null,
    email text not null,
    phoneNum varchar(10),
    password varchar(25) not null,
CONSTRAINT CHK_gender CHECK (gender = 'M' OR gender = 'F'),
primary key(userID)
);

CREATE TABLE PropertyDetails(
	propertyDetailID char(6) not null,
	typeOfProperty text not null,
	bedroomNum varchar(2),
	bathroomNum varchar(2),
	squareFootage int,
	yearBuilt varchar(4),
CONSTRAINT CHK_type CHECK (typeOfProperty = 'Apartment' OR typeOfProperty = 'House'),
primary key(propertyDetailID)
);

CREATE TABLE Landlord(
	landlordID char(6) not null,
	userID char(6) not null references Users(userID),
primary key(landlordID)
);

CREATE TABLE Property(
	propertyID char(6) not null,
	cityID char(6) not null references Cities(cityID),
	propertyDetailID char(6) not null references PropertyDetails(propertyDetailID),
	landlordID char(6) not null references Landlord(landlordID),
	isRented boolean not null,
	address text not null,
primary key(propertyID)
);

CREATE TABLE Tenant(
	tenantID char(6) not null,
	userID char(6) not null references Users(userID),
	propertyID char(6) not null references Property(propertyID),
primary key(tenantID)
);

CREATE TABLE RentTransaction(
	transactionID char(6) not null,
	propertyID char(6) not null references Property(propertyID),
	landlordID char(6) not null references Landlord(landlordID),
	tenantID char(6) not null references Tenant(tenantID),
	amountUSD int not null,
	monthRented char(9) not null,
primary key(transactionID)
);

----------------------------------|
---Stored Procedure/Trigger       |
----------------------------------|
	
CREATE OR REPLACE FUNCTION update_property_rented()
RETURNS TRIGGER AS
$$
BEGIN
IF NEW.transactionID is NOT NULL THEN
UPDATE Property
SET isRented = TRUE
WHERE NEW.propertyID = Property.propertyID;
END IF;
RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;

CREATE TRIGGER update_property_trigger
BEFORE INSERT ON RentTransaction
FOR EACH ROW
EXECUTE PROCEDURE update_property_rented();


----------------------------------|
---Views                          |
----------------------------------|
DROP VIEW IF EXISTS availableProperties;
CREATE VIEW availableProperties as (
SELECT p.propertyID,
        p.landlordID
    FROM Property p INNER JOIN Landlord l
        ON p.landlordID = l.landlordID
    WHERE p.isRented = FALSE
);


DROP VIEW IF EXISTS landlordCities;
CREATE VIEW landlordCities as (
SELECT c.cityName,
        p.landlordID
    FROM Property p INNER JOIN Cities c
        ON p.cityID = c.cityID
);

----------------------------------|
---Queries                        |
----------------------------------|

---Query1---

SELECT SUM(amountUSD) AS totRevenue
FROM rentTransaction
WHERE landlordID = 'LLid01' AND monthRented = 'March'

---Query2---

SELECT t.propertyID, t.tenantID, p.landlordID
FROM Property p INNER JOIN tenant t
        ON p.propertyID = t.propertyID
ORDER BY propertyID


---Query3---

SELECT l.landlordID,p.address
FROM Landlord l INNER JOIN Property p
        ON p.landlordID = l.landlordID
WHERE p.landlordID = 'LLid01'


----------------------------------|
---Insert Statements              |
----------------------------------|

---Bank---

INSERT INTO Bank(bankID, bankName, routingNum, accountNum)
	VALUES('bk001', 'Chase',198567575 ,100015889 );

INSERT INTO Bank(bankID, bankName, routingNum, accountNum)
	VALUES('bk002', 'Bank of America',156342008 ,300115581 );
	
INSERT INTO Bank(bankID, bankName, routingNum, accountNum)
	VALUES('bk003', 'Morgan Stanley',541288639 ,512544013 );
	
INSERT INTO Bank(bankID, bankName, routingNum, accountNum)
	VALUES('bk004', 'TD Bank',900310255 ,653295671 );
	
INSERT INTO Bank(bankID, bankName, routingNum, accountNum)
	VALUES('bk005', 'Capital One',850006732 ,123854401 );
	
INSERT INTO Bank(bankID, bankName, routingNum, accountNum)
	VALUES('bk006', 'Wells Fargo',650011255 ,320115586 );

INSERT INTO Bank(bankID, bankName, routingNum, accountNum)
	VALUES('bk007', 'Citigroup',990051236 ,455336201 );
	
INSERT INTO Bank(bankID, bankName, routingNum, accountNum)
	VALUES('bk008', 'Wells Fargo',650011300 ,653526301 );
	
INSERT INTO Bank(bankID, bankName, routingNum, accountNum)
	VALUES('bk009', 'Bank of America',156342960 ,543600189 );
	
INSERT INTO Bank(bankID, bankName, routingNum, accountNum)
	VALUES('bk010', 'Chase',198567200 ,638894521 );
	
INSERT INTO Bank(bankID, bankName, routingNum, accountNum)
	VALUES('bk011', 'TD Bank',900310555 ,639945231 );

INSERT INTO Bank(bankID, bankName, routingNum, accountNum)
	VALUES('bk012', 'Capital One',850006744 ,152239875 );
	
INSERT INTO Bank(bankID, bankName, routingNum, accountNum)
	VALUES('bk013', 'Chase',198567330 ,442158756 );
	
INSERT INTO Bank(bankID, bankName, routingNum, accountNum)
	VALUES('bk014', 'Morgan Stanley',541288452 ,542269785 );
	
INSERT INTO Bank(bankID, bankName, routingNum, accountNum)
	VALUES('bk015', 'Bank of America',156342100 ,302456112 );
	
---Card Information---

INSERT INTO CardInformation(payCardID, cardCompany, nameOnCard, cardNum, expirationDate, securityCode)
	VALUES('pc001', 'Visa', 'Brandon Traditi', '5245321065236895', '07/19', 131);
	
INSERT INTO CardInformation(payCardID, cardCompany, nameOnCard, cardNum, expirationDate, securityCode)
	VALUES('pc002', 'Master Card', 'Allison McBride', '7545215463120235', '06/20', 125);
	
INSERT INTO CardInformation(payCardID, cardCompany, nameOnCard, cardNum, expirationDate, securityCode)
	VALUES('pc003', 'Discover', 'Frank Sills', '7542865430215569', '01/20', 553);
	
INSERT INTO CardInformation(payCardID, cardCompany, nameOnCard, cardNum, expirationDate, securityCode)
	VALUES('pc004', 'Visa', 'Adam West', '8532412000365698', '12/22', 856);
	
INSERT INTO CardInformation(payCardID, cardCompany, nameOnCard, cardNum, expirationDate, securityCode)
	VALUES('pc005', 'American Express', 'Jill Neal', '4521963256859944', '11/20', 654);
	
INSERT INTO CardInformation(payCardID, cardCompany, nameOnCard, cardNum, expirationDate, securityCode)
	VALUES('pc006', 'Discover', 'Lee Wi', '1203458755623022', '02/22', 525);
	
INSERT INTO CardInformation(payCardID, cardCompany, nameOnCard, cardNum, expirationDate, securityCode)
	VALUES('pc007', 'American Express', 'Keith Amerson', '1523625895420345', '05/21', 778);
	
INSERT INTO CardInformation(payCardID, cardCompany, nameOnCard, cardNum, expirationDate, securityCode)
	VALUES('pc008', 'Visa', 'George Anderson', '4523698745201569', '06/20', 458);
	
INSERT INTO CardInformation(payCardID, cardCompany, nameOnCard, cardNum, expirationDate, securityCode)
	VALUES('pc009', 'Master Card', 'Victoria Jackson', '6325785512036958', '12/19', 856);
	
INSERT INTO CardInformation(payCardID, cardCompany, nameOnCard, cardNum, expirationDate, securityCode)
	VALUES('pc010', 'Visa', 'Mary Hillbert', '4525566323559863', '09/18', 320);
	
INSERT INTO CardInformation(payCardID, cardCompany, nameOnCard, cardNum, expirationDate, securityCode)
	VALUES('pc011', 'Master Card', 'Donte Jones', '023536987996510', '06/20', 111);
	
INSERT INTO CardInformation(payCardID, cardCompany, nameOnCard, cardNum, expirationDate, securityCode)
	VALUES('pc012', 'Discover', 'Peter Griffin', '4563022159875632', '04/20', 152);
	
INSERT INTO CardInformation(payCardID, cardCompany, nameOnCard, cardNum, expirationDate, securityCode)
	VALUES('pc013', 'American Express', 'Courtney Killigan', '9635458632158599', '01/22', 632);
	
INSERT INTO CardInformation(payCardID, cardCompany, nameOnCard, cardNum, expirationDate, securityCode)
	VALUES('pc014', 'American Express', 'Fred Slate', '4302125568663201', '10/20', 420);
		
INSERT INTO CardInformation(payCardID, cardCompany, nameOnCard, cardNum, expirationDate, securityCode)
	VALUES('pc015', 'Visa', 'Alan Labouseur', '7598653211202300', '12/22', 667);
	
---User Payment Info---

INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid001','pc001','bk001');
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid002',NULL,'bk002');
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid003','pc002',NULL);
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid004','pc003','bk003');
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid005',NULL,'bk004');
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid006','pc004',NULL);
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid007','pc005','bk005');
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid008','pc006',NULL);
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid009',NULL,'bk006');
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid010',NULL,'bk007');
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid011',NULL,'bk008');
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid012','pc007',NULL);
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid013',NULL,'bk009');
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid014','pc008',NULL);
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid015','pc009',NULL);
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid016','pc010',NULL);
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid017',NULL,'bk010');
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid018','pc011','bk011');
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid019','pc012',NULL);
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid020',NULL,'bk012');
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid021',NULL,'bk013');
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid022','pc013',NULL);
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid023','pc014',NULL);
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid024',NULL,'bk014');
	
INSERT INTO UsersPaymentInfo(paymentID, payCardID, bankID)
	VALUES('pid025','pc015','bk015');

---Cities---

INSERT INTO Cities(cityID, cityName, zipCode, stateUSA)
	VALUES('ct0010', 'Poughkeepsie', 12601, 'New York');

INSERT INTO Cities(cityID, cityName, zipCode, stateUSA)
	VALUES('ct0001','New York',10001,'New York');
	
INSERT INTO Cities(cityID, cityName, zipCode, stateUSA)
	VALUES('ct0100','Los Angeles',90001,'California');
	
INSERT INTO Cities(cityID, cityName, zipCode, stateUSA)
	VALUES('ct0320','Miami',33124,'Florida');
	
INSERT INTO Cities(cityID, cityName, zipCode, stateUSA)
	VALUES('ct0241','Honolulu',96801,'Hawaii');

---Users---

INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid001','pid001','ct0001','Brandon','Traditi','M','BrandonTraditi@gmail.com',8452263312,'HeyItsMe101');
	
INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid002','pid002','ct0320','Julio','Johnson','M','Julio.Johnson@yahoo.com',9145563214,'footballlover22');
	
INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid003','pid003','ct0241','Allison','McBride','F','McBride21@yahoo.com',2105633852,'ddk21l');
	
INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid004','pid004','ct0001','Frank','Sills','M','Frank.Sills10@hotmail.com',5421036645,'bouldershoulder2');
	
INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid005','pid005','ct0320','Jessica','Linguini','F','LinguiniLover11@gmail.com',7523694512,'Pastamaker22');

INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid006','pid006','ct0241','Adam','West','M','Adam.West100@gmail.com',1802301514,'TownMayor123');
	
INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid007','pid007','ct0001','Jill','Neal','F','J.Neal1@hotmail.com',4102516485,'InsertDogName111');
	
INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid008','pid008','ct0100','Lee','Wi','M','Lee.Wi@yahoo.com',9145623152,'Mr.Fantastic101');
	
INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid009','pid009','ct0001','Derick','Wall','M','D.Wall@gmail.com',7501235208,'Yankeesfan15');
	
INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid010','pid010','ct0100','Austin','Java','M','Javaman@aol.com',8501567542,'coderForLife123');

INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid011','pid011','ct0010','Gale','Keller','F','GKell@hotmail.com',5186423301,'Jamamaam56');
	
INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid012','pid012','ct0010','Keith','Amerson','M','KeithAmerson@gmail.com',7520561234,'Uhj2kl2');
	
INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid013','pid013','ct0320','Paul','Mack','M','MackAttack@hotmail.com',4512236695,'TakeOne1');
	
INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid014','pid014','ct0320','George','Anderson','M','George.Anderson1@yahoo.com',4506642152,'HillsBills201');
	
INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid015','pid015','ct0100','Victoria','Jackson','F','JacksonFive@aol.com',4501251145,'LikeMike5');

INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid016','pid016','ct0241','Mary','Hillbert','F','M.Hillbert@gmail.com',8025421123,'JaxHill23');
	
INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid017','pid017','ct0001','Jerry','Hicks','M','Hicks.Jerry@aol.com',1502203062,'Madmax560');
	
INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid018','pid018','ct0001','Donte','Jones','M','Donte.Jones45@gmail.com',8452562231,'NFLbound350');
	
INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid019','pid019','ct0001','Peter','Griffin','M','email@gmail.com',5423026525,'password');
	
INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid020','pid020','ct0100','Harry','Deforest','M','Deforest50@yahoo.com',450256623,'JambaJuice82');
	
INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid021','pid021','ct0001','Eric','Thomas','M','E.Thomas@gmail.com',7502105234,'Nosleep240');
	
INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid022','pid022','ct0010','Courtney','Killigan','F','C.Killigan@hotmail.com',4502130205,'Snowboarderchick101');
	
INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid023','pid023','ct0001','Fred','Slate','M','FredMan21@aol.com',1203658520,'MegaMan101');
	
INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid024','pid024','ct0010','John','Stewart','M','J.Stewart@gmail',542030152,'ChickenNuggets56');
	
INSERT INTO Users(userID, paymentID, cityID, firstName, lastName, gender, email, phoneNum, password)
	VALUES('uid025','pid025','ct0010','Alan','Labouseur','M','PleaseGiveMeAnA@Marist.edu',8456145230,'Alpaca');

---Property Details---

INSERT INTO PropertyDetails(propertyDetailID, typeOfProperty, bedroomNum, bathroomNum, squareFootage, yearBuilt)
	VALUES('pdid01','Apartment',1,1,1000,2000);
	
INSERT INTO PropertyDetails(propertyDetailID, typeOfProperty, bedroomNum, bathroomNum, squareFootage, yearBuilt)
	VALUES('pdid02','Apartment',2,1,1500,2005);
	
INSERT INTO PropertyDetails(propertyDetailID, typeOfProperty, bedroomNum, bathroomNum, squareFootage, yearBuilt)
	VALUES('pdid03','House',3,2,3000,1990);
	
INSERT INTO PropertyDetails(propertyDetailID, typeOfProperty, bedroomNum, bathroomNum, squareFootage, yearBuilt)
	VALUES('pdid04','House',4,2,4000,2010);
	
---Landlord---

INSERT INTO Landlord(landlordID, userID)
	VALUES('LLid01','uid001');
	
INSERT INTO Landlord(landlordID, userID)
	VALUES('LLid02','uid010');
	
INSERT INTO Landlord(landlordID, userID)
	VALUES('LLid03','uid025');

---Property---

INSERT INTO Property(propertyID, cityID, propertyDetailID, landlordID, isRented, address)
	VALUES('prop01','ct0010','pdid02','LLid03','True','39 Inwood Avenue');

INSERT INTO Property(propertyID, cityID, propertyDetailID, landlordID, isRented, address)
	VALUES('prop02','ct0010','pdid02','LLid03','True','63 Sunset Avenue');

INSERT INTO Property(propertyID, cityID, propertyDetailID, landlordID, isRented, address)
	VALUES('prop03','ct0010','pdid01','LLid03','false','5 West Cedar');

INSERT INTO Property(propertyID, cityID, propertyDetailID, landlordID, isRented, address)
	VALUES('prop04','ct0001','pdid01','LLid01','True','201 Madison Avenue');

INSERT INTO Property(propertyID, cityID, propertyDetailID, landlordID, isRented, address)
	VALUES('prop05','ct0001','pdid01','LLid01','True','10 West Lane');

INSERT INTO Property(propertyID, cityID, propertyDetailID, landlordID, isRented, address)
	VALUES('prop06','ct0001','pdid02','LLid01','True','300 Wall Street');

INSERT INTO Property(propertyID, cityID, propertyDetailID, landlordID, isRented, address)
	VALUES('prop07','ct0001','pdid02','LLid01','True','250 Park Avenue');

INSERT INTO Property(propertyID, cityID, propertyDetailID, landlordID, isRented, address)
	VALUES('prop08','ct0001','pdid02','LLid01','True','300 East Lane');

INSERT INTO Property(propertyID, cityID, propertyDetailID, landlordID, isRented, address)
	VALUES('prop09','ct0100','pdid02','LLid02','True','361 Beverly Bloulevard');

INSERT INTO Property(propertyID, cityID, propertyDetailID, landlordID, isRented, address)
	VALUES('prop10','ct0100','pdid01','LLid02','True','42 Oak Drive');

INSERT INTO Property(propertyID, cityID, propertyDetailID, landlordID, isRented, address)
	VALUES('prop11','ct0100','pdid02','LLid02','False','1 Hills Lane');

INSERT INTO Property(propertyID, cityID, propertyDetailID, landlordID, isRented, address)
	VALUES('prop12','ct0320','pdid04','LLid03','True','100 Club Lane');

INSERT INTO Property(propertyID, cityID, propertyDetailID, landlordID, isRented, address)
	VALUES('prop13','ct0241','pdid03','LLid01','True','11 Sunny Lane');

INSERT INTO Property(propertyID, cityID, propertyDetailID, landlordID, isRented, address)
	VALUES('prop14','ct0241','pdid04','LLid01','False','25 Mountain Drive');

---Tenant---

INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid001','uid002','prop04');
	
INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid002','uid003','prop13');
	
INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid003','uid004','prop07');
	
INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid004','uid005','prop04');
	
INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid005','uid006','prop13');
	
INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid006','uid007','prop08');
	
INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid007','uid008','prop09');
	
INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid008','uid009','prop05');

INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid009','uid011','prop02');
	
INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid010','uid012','prop01');
	
INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid011','uid013','prop12');
	
INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid012','uid014','prop12');
	
INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid013','uid015','prop10');
	
INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid014','uid016','prop13');
	
INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid015','uid017','prop06');
	
INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid016','uid018','prop07');
	
INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid017','uid019','prop08');
	
INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid018','uid020','prop09');
	
INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid019','uid021','prop04');
	
INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid020','uid022','prop01');
	
INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid021','uid023','prop06');
	
INSERT INTO Tenant(tenantID, userID, propertyID)
	VALUES('Tid022','uid024','prop02');
	
---Rent Transaction---

INSERT INTO RentTransaction(transactionID, propertyID, landlordID, tenantID, amountUSD, monthRented)
	Values('Tran01','prop01','LLid03','Tid020',1000,'March');
	
INSERT INTO RentTransaction(transactionID, propertyID, landlordID, tenantID, amountUSD, monthRented)
	Values('Tran02','prop04','LLid01','Tid019',1250,'September');
	
INSERT INTO RentTransaction(transactionID, propertyID, landlordID, tenantID, amountUSD, monthRented)
	Values('Tran03','prop07','LLid01','Tid016',750,'June');
	
INSERT INTO RentTransaction(transactionID, propertyID, landlordID, tenantID, amountUSD, monthRented)
	Values('Tran04','prop10','LLid02','Tid013',900,'November');
	
INSERT INTO RentTransaction(transactionID, propertyID, landlordID, tenantID, amountUSD, monthRented)
	Values('Tran05','prop12','LLid03','Tid001',1500,'June');
	
INSERT INTO RentTransaction(transactionID, propertyID, landlordID, tenantID, amountUSD, monthRented)
	Values('Tran06','prop13','LLid01','Tid014',2000,'July');
	
INSERT INTO RentTransaction(transactionID, propertyID, landlordID, tenantID, amountUSD, monthRented)
	Values('Tran07','prop06','LLid01','Tid021',1000,'January');
	
INSERT INTO RentTransaction(transactionID, propertyID, landlordID, tenantID, amountUSD, monthRented)
	Values('Tran08','prop02','LLid03','Tid022',650,'Febuary');
	
INSERT INTO RentTransaction(transactionID, propertyID, landlordID, tenantID, amountUSD, monthRented)
	Values('Tran09','prop09','LLid02','Tid018',1200,'October');
	
INSERT INTO RentTransaction(transactionID, propertyID, landlordID, tenantID, amountUSD, monthRented)
	Values('Tran10','prop08','LLid01','Tid017',1200,'March');

----------------------------------|
---Security                       |
----------------------------------|

DROP ROLE IF EXISTS ADMIN;
DROP ROLE IF EXISTS USERS;

CREATE ROLE ADMIN;
GRANT ALL ON ALL TABLES IN SCHEMA PUBLIC TO ADMIN;

CREATE ROLE USERS;
REVOKE ALL ON ALL TABLES IN SCHEMA PUBLIC FROM USERS;
GRANT INSERT ON Users, UsersPaymentInfo, cardInformation, Bank TO USERS;
GRANT UPDATE ON Users, UsersPaymentInfo, cardInformation, Bank TO USERS;



