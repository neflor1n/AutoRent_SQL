create database autorentSergachev;
use autorentSergachev;




CREATE TABLE auto(
autoID int not null Primary key identity(1,1),
regNumber char(6) UNIQUE,
markID int,
varv varchar(20),
v_aasta int,
kaigukastID int,
km decimal(6,2)
);
SELECT * FROM auto

CREATE TABLE mark(
markID int not null Primary key identity(1,1),
autoMark varchar(30) UNIQUE
);


INSERT INTO mark(autoMark)
VALUES ('Ziguli');
INSERT INTO mark(autoMark)
VALUES ('Lambordzini');
INSERT INTO mark(autoMark)
VALUES ('BMW');
SELECT * FROM mark;



CREATE TABLE kaigukast(
kaigukastID int not null Primary key identity(1,1),
kaigukast varchar(30) UNIQUE
);
INSERT INTO kaigukast(kaigukast)
VALUES ('Automaat');
INSERT INTO kaigukast(kaigukast)
VALUES ('Manual');
SELECT * FROM kaigukast;



ALTER TABLE auto
ADD FOREIGN KEY (markID) REFERENCES mark(markID);
ALTER TABLE auto
ADD FOREIGN KEY (kaigukastID) REFERENCES kaigukast(kaigukastID);


-- Loo tabeli "tootaja"

CREATE TABLE tootaja (
    tootajaID INT NOT NULL PRIMARY KEY identity(1,1),
    tootajaNimi VARCHAR(50),
    ametID int,
    FOREIGN KEY (ametID) REFERENCES amet(ametID)
);

-- Loo tabeli "klient"

create table klient(
    klientID int not null PRIMARY KEY identity(1,1),
    kliendiNimi varchar(50),
    telefon varchar(20),
    aadress varchar(50),
    soiduKogemus varchar(30));

-- Loo tabeli "rendileping"
create table rendileping(
    lepingID int not null PRIMARY KEY identity(1,1),
    rendiAlgus date,
    rendiLopp date,
    klientID int,
    regNumber char(6),
    rendiKestvus int,
    hindKokku decimal(5,2),
    tootajaID int,
    foreign key (klientID) REFERENCES klient(klientID),
    FOREIGN KEY (regNumber) REFERENCES auto(regNumber),
    foreign key (tootajaID) REFERENCES tootaja(tootajaID));
drop table rendileping

-- lisa andmeid tabelisse "klient"

INSERT INTO klient (kliendiNimi, telefon, aadress, soiduKogemus)
VALUES 
('John Doe', '+123456789', '123 Main St', '5 years'),
('Jane Smith', '+987654321', '456 Oak Ave', '3 years'),
('Robert Johnson', '+112233445', '789 Pine Rd', '7 years');


-- lisa andmeid tabelisse "rendileping"

INSERT INTO rendileping (rendiAlgus, rendiLopp, klientID, regNumber, rendiKestvus, hindKokku, tootajaID) 
VALUES 
('2024-09-01', '2024-09-10', 1, '283JGM', 10, 150.00, 2),
('2024-09-05', '2024-09-15', 2, '281FAS', 10, 200.00, 1),
('2024-09-10', '2024-09-20', 3, '252FDS', 10, 180.00, 3);


-- lisa andmeid tabelisse "tootaja"

INSERT INTO tootaja (tootajaNimi, ametID)
VALUES 
('Alice Johnson', 1),
('Bob Smith', 2),
('Charlie Brown', 3);


-- Loo tabeli "lisavarustus"

CREATE TABLE lisavarustus (
    lisavarustusID INT NOT NULL PRIMARY KEY identity(1,1),
    nimi VARCHAR(100) NOT NULL,  
    hind DECIMAL(10, 2) NOT NULL  
);

-- lisa andmeid tabelisse "auto"

INSERT INTO auto (regNumber, markID, varv, v_aasta, kaigukastID, km) VALUES ('283JGM', 1, 'Crimson', 1997, 1, 1423.12),
 ('281FAS', 2, 'Blue', 2001, 2, 1200.50),
 ('252FDS', 3, 'Black', 2010, 1, 876.25)

 -- ülessane number 3

 SELECT 
    t.tootajaNimi,
    a.regNumber,
    a.varv,
    a.v_aasta,
    r.rendiAlgus,
    r.rendiLopp,
    r.hindKokku
FROM 
    rendileping r
INNER JOIN 
    auto a ON r.regNumber = a.regNumber
INNER JOIN 
    tootaja t ON r.tootajaID = t.tootajaID;


-- ulessane number 4

SELECT 
    COUNT(*) AS summaarne_autode_arv,
    SUM(hindKokku) AS summaarne_maksumus
FROM 
    rendileping;


 select * from auto, mark, kaigukast
where mark.markID=auto.markID and kaigukast.kaigukastID=auto.kaigukastID


select * from auto
INNER JOIN mark ON mark.markID=auto.markID
INNER JOIN kaigukast ON kaigukast.kaigukastID=auto.kaigukastID


-- loo protseduur "InsertRendileping"


CREATE PROCEDURE InsertRendileping
    @rendiAlgus DATE,
    @rendiLopp DATE,
    @klientID INT,
    @regNumber CHAR(6),
    @rendiKestvus INT,
    @hindKokku DECIMAL(5, 2),
    @tootajaID INT
AS
BEGIN
    INSERT INTO rendileping (rendiAlgus, rendiLopp, klientID, regNumber, rendiKestvus, hindKokku, tootajaID)
    VALUES (@rendiAlgus, @rendiLopp, @klientID, @regNumber, @rendiKestvus, @hindKokku, @tootajaID);

    
END;

-- Kontrollime protseduur "InsertRendileping"

EXEC InsertRendileping '2024-09-01', '2024-09-10', 1, '283JGM', 10, 150.00, 2;

-- loo protseduur "DeleteRendileping"

CREATE PROCEDURE DeleteRendileping
    @lepingID INT
AS
BEGIN
    DELETE FROM rendileping WHERE lepingID = @lepingID;
END;

-- Kontrollime protseduur "DeleteRendileping"

EXEC DeleteRendileping @lepingID = 1;

-- loo protseduur "UpdateRendileping"

CREATE PROCEDURE UpdateRendileping
    @lepingID INT,
    @newRendiKestvus INT,
    @newHindKokku DECIMAL(5, 2)
AS
BEGIN
    UPDATE rendileping
    SET rendiKestvus = @newRendiKestvus, 
        hindKokku = @newHindKokku
    WHERE lepingID = @lepingID;
END;

-- Kontrollime protseduur "UpdateRendileping"

EXEC UpdateRendileping @lepingID = 1, @newRendiKestvus = 12, @newHindKokku = 200.00;

--Õiguste määramine

grant select, insert ON rendileping to tootaja;

