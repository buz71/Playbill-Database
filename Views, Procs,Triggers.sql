--Отобразите все актуальные события на конкретную дату. Дата указывается в качестве параметра.
--В данной задаче не совсем понятно условие. Если имеется ввиду, что актуальные события, это котороы не прошли еще то варинат 1,
--если же имеется ввиду событие только в конкретный день, то варинат 2
--Вариант 1:
CREATE PROC ActualEventOnDate @date date
AS
BEGIN
SELECT * FROM Events 
WHERE StartDate>=@date OR EndDate>=@date AND Archive=0 ORDER BY StartDate
END
--Вариант 2:
CREATE PROC ActualOnDate @date date
AS
BEGIN
SELECT * FROM Events 
WHERE StartDate<=@date AND EndDate>=@date AND Archive=0 ORDER BY StartDate
END

--Отобразите все актуальные события из конкретной категории. Категория указывается в качестве параметра
CREATE PROC ActualEventByCategory @category nvarchar(255)
AS
BEGIN
IF @category='Спектакль'
SELECT * FROM Events WHERE category=1 AND (StartDate>=(CONVERT(date,GETDATE())) OR EndDate>=(CONVERT(date,GETDATE())) AND Archive=0) ORDER BY StartDate
IF @category='Концерт'
SELECT * FROM Events WHERE category=2 AND (StartDate>=(CONVERT(date,GETDATE())) OR EndDate>=(CONVERT(date,GETDATE())) AND Archive=0) ORDER BY StartDate
IF @category='Выставка'
SELECT * FROM Events WHERE category=3 AND (StartDate>=(CONVERT(date,GETDATE())) OR EndDate>=(CONVERT(date,GETDATE())) AND Archive=0) ORDER BY StartDate
IF @category='Цирк'
SELECT * FROM Events WHERE category=4 AND (StartDate>=(CONVERT(date,GETDATE())) OR EndDate>=(CONVERT(date,GETDATE())) AND Archive=0) ORDER BY StartDate
IF @category='Спорт'
SELECT * FROM Events WHERE category=5 AND (StartDate>=(CONVERT(date,GETDATE())) OR EndDate>=(CONVERT(date,GETDATE())) AND Archive=0) ORDER BY StartDate
IF @category='Семинары и тренинги'
SELECT * FROM Events WHERE category=6 AND (StartDate>=(CONVERT(date,GETDATE())) OR EndDate>=(CONVERT(date,GETDATE())) AND Archive=0) ORDER BY StartDate
IF @category='Кино'
SELECT * FROM Events WHERE category=7 AND (StartDate>=(CONVERT(date,GETDATE())) OR EndDate>=(CONVERT(date,GETDATE())) AND Archive=0) ORDER BY StartDate
IF @category='Юмор'
SELECT * FROM Events WHERE category=8 AND (StartDate>=(CONVERT(date,GETDATE())) OR EndDate>=(CONVERT(date,GETDATE())) AND Archive=0) ORDER BY StartDate
IF @category='Вечеринки'
SELECT * FROM Events WHERE category=9 AND (StartDate>=(CONVERT(date,GETDATE())) OR EndDate>=(CONVERT(date,GETDATE())) AND Archive=0) ORDER BY StartDate
IF @category='Детям'
SELECT * FROM Events WHERE category=10 AND (StartDate>=(CONVERT(date,GETDATE())) OR EndDate>=(CONVERT(date,GETDATE())) AND Archive=0) ORDER BY StartDate
IF @category='Другое'
SELECT * FROM Events WHERE category=11 AND (StartDate>=(CONVERT(date,GETDATE())) OR EndDate>=(CONVERT(date,GETDATE())) AND Archive=0) ORDER BY StartDate
ELSE
print 'Неверная категория'
END

--Отобразите все актуальные события со стопроцентной продажей билетов
CREATE VIEW v_actual_max_sold_tickets
AS
SELECT id, Name AS 'Название', StartDate AS 'Дата начала', EndDate AS 'Дата окончания', 
Country AS 'Страна', Town AS 'Город', Place AS 'Место проведения', 
StartTime AS 'Время начала', EndTime AS 'Время окончания',
Rating AS 'Рейтинг', Category AS 'Категория', Discription AS 'Описание',
Price AS 'Цена', MaxTicketsQuantity AS 'Максимальное ко-во билетов', SoldTicketsQuantity AS 'Продано билетов'
FROM Events
WHERE (MaxTicketsQuantity = SoldTicketsQuantity AND Archive=0) AND (EndDate>=(CONVERT(date,GETDATE())))

--Отобразите топ-3 самых популярных актуальных событий (по количеству приобретенных билетов)
SELECT TOP 3 id, Name AS 'Название', StartDate AS 'Дата начала', EndDate AS 'Дата окончания', 
Country AS 'Страна', Town AS 'Город', Place AS 'Место проведения', 
StartTime AS 'Время начала', EndTime AS 'Время окончания',
Rating AS 'Рейтинг', Category AS 'Категория', Discription AS 'Описание',
Price AS 'Цена', MaxTicketsQuantity AS 'Максимальное ко-во билетов', SoldTicketsQuantity AS 'Продано билетов'
FROM  Events
WHERE Archive=0 AND (EndDate>=(CONVERT(date,GETDATE())))
ORDER BY SoldTicketsQuantity DESC

--Отобразите топ-3 самых популярных категорий событий(по количеству всех приобретенных билетов). Архив событий учитывается
SELECT TOP 3 Category as 'Категория',SUM(SoldTicketsQuantity) as 'Количество проданных билетов'
FROM Events
GROUP BY category
ORDER BY 'Количество проданных билетов' DESC

--Отобразите самое популярное событие в конкретном городе. Город указывается в качестве параметра
CREATE PROC MostPopularEventInTown @town_id int
AS
BEGIN
SELECT TOP 1 Name AS 'Название', Discription AS 'Описание', 
StartDate AS 'Дата начала', EndDate AS 'Дата окончания', StartTime AS 'Время начала', EndTime AS 'Время окончания',
SoldTicketsQuantity AS 'Кол-во проданных билетов'
FROM Events
WHERE town=@town_id AND Archive=0
ORDER BY SoldTicketsQuantity DESC
END

--Покажите информацию о самом активном клиенте (по количеству купленных билетов)
CREATE VIEW v_mostactive_client_by_tickets
AS
SELECT TOP 1 c.Name as 'ФИО', COUNT(c.Name) AS 'Всего куплено билетов'
FROM Clients c, Sold_Tickets st
WHERE st.Client_id=c.id
GROUP BY c.Name
ORDER BY 'Всего куплено билетов' DESC

--Покажите информацию о самой непопулярной категории (по количеству событий). Архив событий учитывается.
SELECT TOP 1 Category as 'Категория',COUNT(Category) as 'Количество событий'
FROM Events
GROUP BY category
ORDER BY 'Количество событий' ASC

--Покажите все события, которые пройдут сегодня в указанное время. Время передаётся в качестве параметра
CREATE PROC TodayEventOnTime @time time
AS
BEGIN
SELECT name AS 'Название',  StartDate AS 'Дата начала',EndDate AS 'Дата окончания',StartTime AS 'Время начала',EndTime AS 'Время окончания'
FROM Events
WHERE StartTime='13:00' AND ((StartDate<=(CONVERT(date,GETDATE())) AND EndDate>=(CONVERT(date,GETDATE())) AND Archive=0))
END

--Покажите название городов, в которых сегодня пройдут события
CREATE VIEW v_towns_with_events_today
AS
SELECT tw.name AS 'Города в которых сегодня пройдут события'
FROM Events EV, Towns tw
WHERE (StartDate<=CONVERT (date,GETDATE()) AND EndDate>=CONVERT (date,GETDATE()) AND Archive=0) AND EV.town=tw.id
GROUP BY tw.name

--При вставке нового клиента нужно проверять, нет ли его уже в базе данных. Если такой клиент есть, генерировать ошибку с описанием возникшей проблемы
CREATE TRIGGER Clients_Update
ON Clients
INSTEAD OF INSERT
AS
DECLARE @name nvarchar(255)=(SELECT Name FROM INSERTED)
DECLARE @mail nvarchar(255)=(SELECT Mail FROM INSERTED)
DECLARE @bordate date = (SELECT BornDate FROM INSERTED)
BEGIN
	IF EXISTS (SELECT name FROM Clients WHERE Name=@name AND Mail=@mail AND BornDate=@bordate)
		PRINT 'ERROR! Данный клиент уже есть в базe! Операция отменена.'
	ELSE 
		INSERT INTO Clients SELECT Name,Mail,BornDate FROM INSERTED
END

--При вставке нового события нужно проверять, нет ли его уже в базе данных. Если такое событие есть, генерировать ошибку с описанием возникшей проблемы

CREATE TRIGGER Events_Update
ON Events
INSTEAD OF INSERT
AS
DECLARE @name nvarchar(255) = (SELECT Name FROM INSERTED)
DECLARE @StartDate date = (SELECT StartDate FROM INSERTED)
DECLARE @EndDate date = (SELECT EndDate FROM INSERTED)
DECLARE @Country int = (SELECT Country FROM INSERTED)
DECLARE @Town int = (SELECT Town FROM INSERTED)
DECLARE @Place int = (SELECT Place FROM INSERTED)
DECLARE @StartTime time = (SELECT StartTime FROM INSERTED)
DECLARE @EndTime time = (SELECT EndTime FROM INSERTED)
DECLARE @Rating int = (SELECT Rating FROM INSERTED)
DECLARE @Category int = (SELECT Category FROM INSERTED)
DECLARE @Discription nvarchar(255) = (SELECT Discription FROM INSERTED)
BEGIN
	IF EXISTS (SELECT * FROM Events
				WHERE 
				Name=@name AND StartDate=@StartDate AND EndDate=@EndDate
				AND Country=@Country AND Town=@Town AND Place = @Place
				AND StartTime=@StartTime AND EndTime=@EndTime
				AND Rating=@Rating AND Category=@Category AND Discription = @Discription)
		PRINT 'ERROR! Данное событие уже есть в базe! Операция отменена.'
	ELSE 
		INSERT INTO Events SELECT Name,StartDate,EndDate,Country,Town,Place,StartTime,EndTime,Rating,Category,Discription,Price,MaxTicketsQuantity,SoldTicketsQuantity,0 
		FROM INSERTED
END

--При удалении прошедших событий необходимо их переносить в архив событий
CREATE TRIGGER Event_Delete
ON Events
INSTEAD OF DELETE
AS
BEGIN
	UPDATE Events SET Archive=1 WHERE id=(SELECT id FROM DELETED)
	PRINT 'Событие перемещено в архив'
END

--При попытке покупки билета проверять не достигнуто ли уже максимальное количество билетов. 
--Если максимальное количество достигнуто, генерировать ошибку с информацией о возникшей проблеме
CREATE PROC BuyingTicket @id int, @id_client int
AS
DECLARE @Max int = (SELECT MaxTicketsQuantity FROM Events WHERE id=@id)
DECLARE @Sold int = (SELECT SoldTicketsQuantity FROM Events WHERE id=@id)
BEGIN
IF (@Max=@Sold)
	PRINT 'Билетов на данное событие больше нет'
ELSE BEGIN
	UPDATE Events
	SET SoldTicketsQuantity=SoldTicketsQuantity+1
	WHERE id=@id

	INSERT INTO Sold_Tickets
	VALUES((SELECT name FROM Events WHERE id=@id),@id_client)
END
END

--При попытке покупки билета проверять возрастные ограничения. 
--Если возрастное ограничение нарушено, генерировать ошибку с информацией о возникшей проблеме

CREATE PROC BuyingTicketsAge @client_id int, @event_id int
AS
DECLARE @now date = cast(getdate()as date)
DECLARE @age int
DECLARE @Rating int =(SELECT Rating FROM Events WHERE id=@event_id)
DECLARE @MaxAge int 
	IF (@Rating=1)
	SET @maxAge = 6
	IF (@Rating=2)
	SET @maxAge=12
	IF (@Rating=3)
	SET @maxAge=16
	IF (@Rating=4)
	SET @maxAge=18
	IF(@Rating=5)
	SET @maxAge=18
BEGIN
SET @age=CAST((DATEDIFF(dd,(SELECT BornDate FROM Clients WHERE id=@client_id),@now)/365) AS int) --Вычисление возраста
	IF(EXISTS(SELECT * FROM Clients WHERE id=@client_id))
		BEGIN
			IF (@age>@maxAge OR @age>=18)
			BEGIN
			print 'Возраст подходит'
			END
			ELSE 
			BEGIN
			print 'Нарушен возрастной рейтинг'
			END
		END
	ELSE
		BEGIN
		print 'Клиента нет в базе'
		END
END
