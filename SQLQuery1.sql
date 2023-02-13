CREATE TABLE Hosts 
(
Hid int Primary key,
Hname varchar(50),
Hnat varchar(50)
)

CREATE TABLE Customers
(
Cid int Primary key,
Cusername varchar(50) unique,
Cemail varchar(50) unique,
Caddres varchar(50),
Cnat varchar(50),
CDob DATE
)

CREATE TABLE Payments
(
Pid int Primary key,
Pamount int,
Pdate DATE,
Ptype varchar(50)
)

CREATE TABLE Properties
(
PRid int Primary key,
PRname varchar(50),
PRdesc varchar(50),
PRaddres varchar(50),
PRcheckin DATETIME,
PRcheckout DATETIME,
PRnrpeople int,
PRprice int,
PRcancelationFree int,
Hid int References Hosts(Hid)
)

CREATE TABLE Bookings(
Cid int REFERENCES Customers(Cid),
PRid int References Properties(PRid),
Primary key(Cid,PRid),
BstartData DATE,
BendDate DAte,
Pid int References Payments(Pid)

)

--2)

CREATE OR ALTER PROCEDURE AddPaymentToBooking(@Pid int,@PDate DATE, @PType varchar(50),@Cid int,@PRid int)
AS
	IF (SELECT Pid FROM Bookings WHERE Cid=@Cid and PRid=@PRid) IS NOT  NULL
		BEGIN
			
			UPDATE Payments
			SET Pdate=@PDate, Ptype=@PType
			WHERE Pid=@Pid
		END
		ELSE
		BEGIN
			
			UPDATE Bookings
			SET Pid=@Pid
			WHERE Cid=@Cid and PRid=@PRid

		END

GO

EXEC AddPaymentToBooking 1,'05-12-2012','Paypal',1,1



--3)


CREATE OR ALTER VIEW MostProperties AS
SELECT Hname
FROM Hosts
WHERE Hid IN
(
	SELECT P.Hid FROM Properties P JOIN Hosts H ON P.Hid=H.Hid
	GROUP BY P.Hid
	HAVING COUNT(P.PRid)=
	(SELECT TOP 1 COUNT(P.PRid) mycount FROM Properties P JOIN Hosts H ON P.Hid=H.Hid
	GROUP BY P.Hid)
	
)


SELECT * FROM MostProperties


--4)

Create FUNCTION MoreRBookings(@R int)
RETURNS TABLE
AS
 RETURN
 SELECT * FROM 
 Customers
 WHERE Cid
 IN
 (
 SELECT B.Cid FROM Customers C JOIN Bookings B ON C.Cid=B.Cid
 JOIN Payments P on P.Pid=B.Pid
 WHERE Ptype='cash'
 Group by B.Cid
 HAVING COUNT(B.Pid)>=@R
 )

GO


SELECT *
FROM MoreRBookings(1)

INSERT INTO Hosts(Hid,Hname,Hnat)
VALUES(3,'kl','Romania')

INSERT INTO Properties(PRid,PRname,PRdesc,PRaddres,PRcheckin,PRcheckout,PRnrpeople,PRprice,PRcancelationFree,Hid)
VALUES(7,'Property7','very cool','blabla',convert(datetime,'18-06-12 10:34:09 PM',5),convert(datetime,'18-06-12 12:34:09 PM',5),2,2000,1,3)

INSERT INTO Customers(Cid,Cusername,Cemail,Caddres,Cnat,CDob)
VALUES(2,'alex','A','cluj','romania','05-26-2002')

INSERT INTO Payments(Pid,Pamount,Pdate,Ptype)
VALUES(3,1000,'03-14-2012','cash')

INSERT INTO Bookings(Cid,PRid,BstartData,BendDate,Pid)
Values(1,2,'03-14-2012','07-14-2012',2)


SELECT * FROM Hosts
SELECT * FROm Bookings
SELECT * FROM Properties
SELECT * FROM Payments
SELECT * FROM Customers

