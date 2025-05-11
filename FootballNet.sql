-- Создание базы данных
USE master;
GO
DROP DATABASE IF EXISTS FootballFanNetwork;
GO
CREATE DATABASE FootballFanNetwork;
GO
USE FootballFanNetwork;
GO

-- Создание узлов (Nodes)
CREATE TABLE Fan (
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL
) AS NODE;
GO

CREATE TABLE Country (
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    continent NVARCHAR(50) NOT NULL
) AS NODE;
GO

CREATE TABLE Club (
    id INT NOT NULL PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    country_id INT NOT NULL
) AS NODE;
GO

-- Создание рёбер (Edges)
CREATE TABLE FriendOf AS EDGE;
GO
CREATE TABLE LivesIn AS EDGE;
GO
CREATE TABLE Supports AS EDGE;
GO
CREATE TABLE LocatedIn AS EDGE;
GO

-- Определение связей между узлами
ALTER TABLE FriendOf ADD CONSTRAINT EC_FriendOf CONNECTION (Fan TO Fan);
GO
ALTER TABLE LivesIn ADD CONSTRAINT EC_LivesIn CONNECTION (Fan TO Country);
GO
ALTER TABLE Supports ADD CONSTRAINT EC_Supports CONNECTION (Fan TO Club);
GO
ALTER TABLE LocatedIn ADD CONSTRAINT EC_LocatedIn CONNECTION (Club TO Country);
GO

-- Вставка стран
INSERT INTO Country (id, name, continent) VALUES
(1, N'Германия', N'Европа'),
(2, N'Испания', N'Европа'),
(3, N'Италия', N'Европа'),
(4, N'Англия', N'Европа'),
(5, N'Франция', N'Европа'),
(6, N'Португалия', N'Европа'),
(7, N'Нидерланды', N'Европа'),
(8, N'Бельгия', N'Европа'),
(9, N'Австрия', N'Европа'),
(10, N'Швейцария', N'Европа');
GO

-- Вставка клубов
INSERT INTO Club (id, name, country_id) VALUES
(1, N'Бавария', 1),
(2, N'Барселона', 2),
(3, N'Ювентус', 3),
(4, N'Манчестер Юнайтед', 4),
(5, N'Пари Сен-Жермен', 5),
(6, N'Порту', 6),
(7, N'Аякс', 7),
(8, N'Андерлехт', 8),
(9, N'РБ Зальцбург', 9),
(10, N'Базель', 10);
GO

-- Вставка фанатов
INSERT INTO Fan (id, name) VALUES
(1, N'Алексей'),
(2, N'Мария'),
(3, N'Дмитрий'),
(4, N'Екатерина'),
(5, N'Сергей'),
(6, N'Иван'),
(7, N'Ольга'),
(8, N'Константин'),
(9, N'Юлия'),
(10, N'Максим');
GO

-- Связи "дружит с"
INSERT INTO FriendOf ($from_id, $to_id)
VALUES ((SELECT $node_id FROM Fan WHERE id = 1), (SELECT $node_id FROM Fan WHERE id = 2)),
       ((SELECT $node_id FROM Fan WHERE id = 1), (SELECT $node_id FROM Fan WHERE id = 5)),
       ((SELECT $node_id FROM Fan WHERE id = 2), (SELECT $node_id FROM Fan WHERE id = 3)),
       ((SELECT $node_id FROM Fan WHERE id = 3), (SELECT $node_id FROM Fan WHERE id = 1)),
       ((SELECT $node_id FROM Fan WHERE id = 3), (SELECT $node_id FROM Fan WHERE id = 6)),
       ((SELECT $node_id FROM Fan WHERE id = 4), (SELECT $node_id FROM Fan WHERE id = 2)),
       ((SELECT $node_id FROM Fan WHERE id = 5), (SELECT $node_id FROM Fan WHERE id = 4)),
       ((SELECT $node_id FROM Fan WHERE id = 6), (SELECT $node_id FROM Fan WHERE id = 7)),
       ((SELECT $node_id FROM Fan WHERE id = 6), (SELECT $node_id FROM Fan WHERE id = 8)),
       ((SELECT $node_id FROM Fan WHERE id = 8), (SELECT $node_id FROM Fan WHERE id = 3)),
       ((SELECT $node_id FROM Fan WHERE id = 9), (SELECT $node_id FROM Fan WHERE id = 10)),
       ((SELECT $node_id FROM Fan WHERE id = 10), (SELECT $node_id FROM Fan WHERE id = 7));
GO

-- Связи "живет в"
INSERT INTO LivesIn ($from_id, $to_id) VALUES
((SELECT $node_id FROM Fan WHERE id = 1), (SELECT $node_id FROM Country WHERE id = 4)),
((SELECT $node_id FROM Fan WHERE id = 2), (SELECT $node_id FROM Country WHERE id = 9)),
((SELECT $node_id FROM Fan WHERE id = 3), (SELECT $node_id FROM Country WHERE id = 2)),
((SELECT $node_id FROM Fan WHERE id = 4), (SELECT $node_id FROM Country WHERE id = 2)),
((SELECT $node_id FROM Fan WHERE id = 5), (SELECT $node_id FROM Country WHERE id = 5)),
((SELECT $node_id FROM Fan WHERE id = 6), (SELECT $node_id FROM Country WHERE id = 3)),
((SELECT $node_id FROM Fan WHERE id = 7), (SELECT $node_id FROM Country WHERE id = 5)),
((SELECT $node_id FROM Fan WHERE id = 8), (SELECT $node_id FROM Country WHERE id = 6)),
((SELECT $node_id FROM Fan WHERE id = 9), (SELECT $node_id FROM Country WHERE id = 1)),
((SELECT $node_id FROM Fan WHERE id = 10), (SELECT $node_id FROM Country WHERE id = 2));
GO

-- Связи "поддерживает"
INSERT INTO Supports ($from_id, $to_id) VALUES
((SELECT $node_id FROM Fan WHERE id = 1), (SELECT $node_id FROM Club WHERE id = 3)),
((SELECT $node_id FROM Fan WHERE id = 2), (SELECT $node_id FROM Club WHERE id = 4)),
((SELECT $node_id FROM Fan WHERE id = 3), (SELECT $node_id FROM Club WHERE id = 2)),
((SELECT $node_id FROM Fan WHERE id = 4), (SELECT $node_id FROM Club WHERE id = 1)),
((SELECT $node_id FROM Fan WHERE id = 5), (SELECT $node_id FROM Club WHERE id = 2)),
((SELECT $node_id FROM Fan WHERE id = 6), (SELECT $node_id FROM Club WHERE id = 10)),
((SELECT $node_id FROM Fan WHERE id = 7), (SELECT $node_id FROM Club WHERE id = 7)),
((SELECT $node_id FROM Fan WHERE id = 8), (SELECT $node_id FROM Club WHERE id = 3)),
((SELECT $node_id FROM Fan WHERE id = 9), (SELECT $node_id FROM Club WHERE id = 9)),
((SELECT $node_id FROM Fan WHERE id = 10), (SELECT $node_id FROM Club WHERE id = 8));
GO

--Связь "клуб в стране"
INSERT INTO LocatedIn ($from_id, $to_id) VALUES
((SELECT $node_id FROM Club WHERE id = 1), (SELECT $node_id FROM Country WHERE id = 1)),
((SELECT $node_id FROM Club WHERE id = 2), (SELECT $node_id FROM Country WHERE id = 2)),
((SELECT $node_id FROM Club WHERE id = 3), (SELECT $node_id FROM Country WHERE id = 3)),
((SELECT $node_id FROM Club WHERE id = 4), (SELECT $node_id FROM Country WHERE id = 4)),
((SELECT $node_id FROM Club WHERE id = 5), (SELECT $node_id FROM Country WHERE id = 5)),
((SELECT $node_id FROM Club WHERE id = 6), (SELECT $node_id FROM Country WHERE id = 6)),
((SELECT $node_id FROM Club WHERE id = 7), (SELECT $node_id FROM Country WHERE id = 7)),
((SELECT $node_id FROM Club WHERE id = 8), (SELECT $node_id FROM Country WHERE id = 8)),
((SELECT $node_id FROM Club WHERE id = 9), (SELECT $node_id FROM Country WHERE id = 9)),
((SELECT $node_id FROM Club WHERE id = 10), (SELECT $node_id FROM Country WHERE id = 10));
GO
-- 1. Кто друзья Алексея?
SELECT Fan1.name AS Фанат, Fan2.name AS Друг
FROM Fan AS Fan1, FriendOf, Fan AS Fan2
WHERE MATCH(Fan1-(FriendOf)->Fan2) AND Fan1.name = N'Алексей';
GO

-- 2. Какие клубы поддерживают друзья Марии?
SELECT Fan2.name AS Фанат, Club.name AS Клуб
FROM Fan AS Fan1, FriendOf, Fan AS Fan2, Supports, Club
WHERE MATCH(Fan1-(FriendOf)->Fan2-(Supports)->Club) AND Fan1.name = N'Мария';
GO
 
--3.Какие клубы поддерживают друзья Алексея
SELECT Fan2.name AS Фанат, Club.name AS Клуб
FROM Fan AS Fan1, FriendOf, Fan AS Fan2, Supports, Club
WHERE MATCH(Fan1-(FriendOf)->Fan2-(Supports)->Club) AND Fan1.name = N'Алексей';
GO

-- 4.Найти фанатов, которые дружат друг с другом за 3 шага
SELECT Fan1.name AS Фанат1, Fan2.name AS Фанат2
FROM Fan AS Fan1,
     FriendOf AS F1,
     Fan AS Fan2,
     FriendOf AS F2,
     Fan AS Fan3,
     FriendOf AS F3
WHERE MATCH(Fan1-(F1)->Fan2-(F2)->Fan3-(F3)->Fan2)
  AND Fan1.name = N'Алексей';
GO
--5.  Максимальная социальная сеть Екатерины (шаблон "+") SHORTEST_PATH with +
SELECT Fan1.name AS [Фанат],
       STRING_AGG(Fan2.name, ' -> ') WITHIN GROUP (GRAPH PATH) AS [Друзья]
FROM Fan AS Fan1, FriendOf FOR PATH AS F, Fan FOR PATH AS Fan2
WHERE MATCH(SHORTEST_PATH(Fan1(-(F)->Fan2)+)) AND Fan1.name = N'Екатерина';
GO

GO
--6. За какие команды болеют друзья Константина
SELECT DISTINCT Club.name AS [Клуб]
FROM Fan AS Source,
     FriendOf AS f,
     Fan AS Friend,
     Supports AS s,
     Club AS Club
WHERE MATCH(Source - (f) -> Friend - (s) -> Club)
  AND Source.name = N'Константин';
GO
--SQL-запросы для визуализации в Power BI

--Список фанатов и стран проживания
SELECT 
    Fan.name AS FanName,
    CONCAT(N'Fan', Fan.id, '.webp') AS [Fan Image],
    Country.name AS CountryName,
    CONCAT(N'Country', Country.id, '.png') AS [Country Image]
FROM Fan, LivesIn, Country
WHERE MATCH(Fan-(LivesIn)->Country);

-- Фанаты и клубы, которые они поддерживают
SELECT 
    Fan.name AS FanName,
    CONCAT(N'Fan', Fan.id, '.webp') AS [Fan Image],
    Club.name AS ClubName,
    CONCAT(N'Club', Club.id, '.png') AS [Club Image]
FROM Fan, Supports, Club
WHERE MATCH(Fan-(Supports)->Club);

--Клубы и страны, где они расположены
SELECT 
    Club.name AS ClubName,
    CONCAT(N'Club', Club.id, '.png') AS [Club Image],
    Country.name AS CountryName,
    CONCAT(N'Country', Country.id, '.png') AS [Country Image]
FROM Club, LocatedIn, Country
WHERE MATCH(Club-(LocatedIn)->Country);




--Дружба между фанатами (двунаправленная визуализация)
SELECT 
    f1.name AS Fan1Name,
    CONCAT(N'Fan', f1.id, '.webp') AS [Fan1 Image],
    f2.name AS Fan2Name,
    CONCAT(N'Fan', f2.id, '.webp') AS [Fan2 Image]
FROM Fan AS f1, FriendOf, Fan AS f2
WHERE MATCH(f1-(FriendOf)->f2);




--Фанаты, клубы и страны клубов

SELECT 
    Fan.name AS FanName,
    CONCAT(N'Fan', Fan.id, '.webp') AS [Fan Image],
    Club.name AS ClubName,
    CONCAT(N'Club', Club.id, '.png') AS [Club Image],
    Country.name AS CountryName,
    CONCAT(N'Country', Country.id, '.png') AS [Country Image]
FROM Fan, Supports, Club, LocatedIn, Country
WHERE MATCH(Fan-(Supports)->Club-(LocatedIn)->Country);




	--Клубы и фанаты (для графовой визуализации поддержки)
SELECT 
    Fan.id AS SourceID,
    CONCAT(N'Fan', Fan.id, '.webp') AS [Fan Image],
    Club.id AS TargetID,
    CONCAT(N'Club', Club.id, '.png') AS [Club Image],
    'Supports' AS Relationship
FROM Fan, Supports, Club
WHERE MATCH(Fan-(Supports)->Club);


