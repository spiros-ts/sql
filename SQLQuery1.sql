CREATE TABLE Ordered_table (
    id int,
    time_stamp datetime2,
);



CREATE trigger TimeStampGenerator
on Ordered_table
AFTER insert as
begIN	
	DECLARE @STAMP DATETIME2,@ID INT 	
	SET @ID=(SELECT id FROM inserted)	
	SET @STAMP=( SELECT SYSDATETIME() )

	UPDATE Ordered_table
	SET time_stamp=@STAMP
	WHERE id=@ID

	WAITFOR DELAY '00:00:00.01'

end


INSERT INTO Ordered_table(id) VALUES (1);
INSERT INTO Ordered_table(id) VALUES (2);
INSERT INTO Ordered_table(id) VALUES (3);
INSERT INTO Ordered_table(id) VALUES (4);
INSERT INTO Ordered_table(id) VALUES (5);
INSERT INTO Ordered_table(id) VALUES (6);
INSERT INTO Ordered_table(id) VALUES (7);
INSERT INTO Ordered_table(id) VALUES (8);
INSERT INTO Ordered_table(id) VALUES (9);
INSERT INTO Ordered_table(id) VALUES (10);

select * from Ordered_table




CREATE PROCEDURE first_element 
AS  
BEGIN  
	select * from Ordered_table
	where time_stamp in (select MIN(time_stamp) from Ordered_table)
END  


CREATE PROCEDURE last_element 
AS  
BEGIN  
	select * from Ordered_table
	where time_stamp in (select MAX(time_stamp) from Ordered_table)
END  


CREATE PROCEDURE prior_element 
(@id int)
AS  
BEGIN  
	Declare @timestamp datetime2
	Declare @temp datetime2

	select @timestamp=time_stamp from Ordered_table
	where id=@id

	Select @temp= MAX(time_stamp) from Ordered_table
	where  time_stamp in (
		select time_stamp from Ordered_table
		where time_stamp<@timestamp
	) 
	select id, time_stamp from Ordered_table
	where time_stamp=@temp
	
END  


CREATE PROCEDURE next_element 
(@id int)
AS  
BEGIN  
	Declare @timestamp datetime2
	Declare @temp datetime2

	select @timestamp=time_stamp from Ordered_table
	where id=@id

	Select @temp= MIN(time_stamp) from Ordered_table
	where  time_stamp in (
		select time_stamp from Ordered_table
		where time_stamp>@timestamp
	) 
	select id, time_stamp from Ordered_table
	where time_stamp=@temp
	
END


CREATE PROCEDURE swap
(@item1 INT, @item2 INT)
AS  
BEGIN  
	Declare @temp datetime2	
	Declare @time2 datetime2

	select @temp=time_stamp from Ordered_table
	where id=@item1

	select @time2=time_stamp from Ordered_table
	where id=@item2


	UPDATE Ordered_table
	set time_stamp=@time2
	where id=@item1 

	UPDATE Ordered_table
	set time_stamp=@temp
	where id=@item2 

	
END    


select * from Ordered_table

execute first_element

execute last_element

execute next_element 9

execute prior_element 1

execute swap 
1,10

select * from Ordered_table
order by time_stamp