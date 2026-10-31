USE master;
GO



CREATE DATABASE Insurance_Management ON
(NAME = Ins_dat,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.STUDSERVER\MSSQL\DATA\insdat.mdf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5)
LOG ON
(NAME = Ins_log,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.STUDSERVER\MSSQL\DATA\inslog.ldf',
    SIZE = 5 MB,
    MAXSIZE = 25 MB,
    FILEGROWTH = 5 MB);
GO 


