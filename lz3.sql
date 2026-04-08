--ИНСЕРТЫ ПОДХОДЯТ НЕ ДЛЯ ВСЕХ ЗАДАНИЯ
--ИНСЕРТЫ СОЗДАНЫ НЕЙРОНКОЙ
USE master
DROP DATABASE vefu57_lz3
CREATE DATABASE vefu57_lz3
USE vefu57_lz3

CREATE TABLE subj (
	id INT PRIMARY KEY IDENTITY(1,1),
	subj NVARCHAR(50) UNIQUE NOT NULL,
	[hours] INT NOT NULL
)

CREATE TABLE teach (
	id INT PRIMARY KEY IDENTITY(1,1),
	last_name NVARCHAR(30) NOT NULL,
	f_name NVARCHAR(30) NOT NULL,
	s_name NVARCHAR(30),
	br_date Date NOT NULL,
	start_work_date DATE NOT NULL
)

CREATE TABLE faculty (
	id INT PRIMARY KEY IDENTITY(1,1),
	faculty_name NVARCHAR(70) UNIQUE NOT NULL,
)

CREATE TABLE form (
	id INT PRIMARY KEY IDENTITY(1,1),
	form_name NVARCHAR(30) UNIQUE NOT NULL,
)

CREATE TABLE [hours] (
	id INT PRIMARY KEY IDENTITY(1,1),
	course INT NOT NULL,
	faculty_id INT,
	form_id INT NOT NULL,
	all_h INT NOT NULL,
	inclass_h INT NOT NULL,

	FOREIGN KEY (faculty_id) REFERENCES faculty(id),
	FOREIGN KEY (form_id) REFERENCES form(id),
)

CREATE TABLE work (
	teach_id INT,
	subj_id INT,
	hours_id INT,

	PRIMARY KEY (teach_id, subj_id, hours_id),
	FOREIGN KEY (teach_id) REFERENCES teach(id),
	FOREIGN KEY (subj_id) REFERENCES subj(id),
	FOREIGN KEY (hours_id) REFERENCES [hours](id),
)


CREATE TABLE stud (
	id INT PRIMARY KEY IDENTITY(1,1),
	last_name NVARCHAR(30) NOT NULL,
	f_name NVARCHAR(30) NOT NULL,
	s_name NVARCHAR(30),
	br_date Date NOT NULL,
	in_date DATE NOT NULL,
	exm FLOAT NOT NULL
)

CREATE TABLE process (
	stud_id INT,
	hours_id INT,
	
	PRIMARY KEY (stud_id, hours_id),
	FOREIGN KEY (stud_id) REFERENCES stud(id),
	FOREIGN KEY (hours_id) REFERENCES [hours](id)
)

-- 1. Факультеты
INSERT INTO faculty (faculty_name) VALUES (N'ФПК'), (N'ФПМ');

-- 2. Формы обучения
INSERT INTO form (form_name) VALUES (N'Очная'), (N'Заочная');

-- 3. Предметы (некоторые повторяются по логике для разных факультетов далее)
INSERT INTO subj (subj, [hours]) VALUES 
(N'Высшая математика', 120),
(N'Программирование', 150),
(N'Психология', 72),
(N'История', 54),
(N'Базы данных', 100);

-- 4. Преподаватели (есть люди без отчеств)
INSERT INTO teach (last_name, f_name, s_name, br_date, start_work_date) VALUES 
(N'Иванов', N'Петр', N'Сергеевич', '1975-05-12', '2000-09-01'),
(N'Смит', N'Джон', NULL, '1980-03-20', '2010-02-15'), -- Без отчества
(N'Козлова', N'Анна', N'Игоревна', '1988-11-30', '2015-01-10'),
(N'Ван', N'Ли', NULL, '1970-07-07', '1995-09-01'); -- Без отчества

-- 5. Учебные планы (hours)
-- Привязываем предметы к курсам и факультетам
INSERT INTO [hours] (course, faculty_id, form_id, all_h, inclass_h) VALUES 
(1, 2, 1, 120, 60), -- ФПК Очка
(1, 1, 1, 120, 60), -- ФПК Очка
(1, 2, 1, 120, 60), -- ФПМ Очка (одинаковый предмет будет через таблицу work)
(3, 1, 2, 100, 20), -- ФПК Заочка (для студентов 37+)
(2, 2, 1, 150, 80);

-- 6. Распределение нагрузки (work)
INSERT INTO work (teach_id, subj_id, hours_id) VALUES 
(1, 1, 1), (1, 1, 2), -- Один препод ведет Математику на обоих факультетах
(2, 2, 4), (3, 3, 3);

-- 7. Студенты 
INSERT INTO stud (last_name, f_name, s_name, br_date, in_date, exm) VALUES 
-- Студенты 2014-2016 годов поступления, часть без отчеств, разные возрасты
(N'Иванова', N'Ольга', N'Игоревна', '1975-02-10', '2014-09-01', 5.5),  -- Старше 45, поступила в 2014, слабоуспевающая
(N'Браун', N'Кевин', NULL, '1995-11-12', '2015-09-01', 8.1),          -- Без отчества, иностранец
(N'Кузнецов', N'Артем', N'Павлович', '1980-04-25', '2016-09-01', 7.8), -- Старше 37, поступил в 2016
(N'Васильев', N'Дмитрий', N'Олегович', '1998-07-07', '2016-09-01', 4.5),-- Слабоуспевающий
(N'Ли', N'Мей', NULL, '2000-01-01', '2018-09-01', 9.2),               -- Отличница, без отчества
(N'Морозов', N'Сергей', N'Петрович', '1972-03-15', '2015-09-01', 8.0), -- Старше 45, поступил в 2015
(N'Новикова', N'Алина', N'Юрьевна', '1984-09-20', '2014-09-01', 9.9),  -- Заочница (будет в process), отличница
(N'Павлов', N'Илья', N'Николаевич', '2002-12-30', '2020-09-01', 5.8), -- Слабоуспевающий
(N'Смирнов', N'Андрей', N'Викторович', '1978-05-14', '2016-09-01', 7.9),-- Оценка ~8.0 (на 20% меньше макс)
(N'Попова', N'Екатерина', NULL, '1999-08-22', '2017-09-01', 9.0),      -- Без отчества, отличница
(N'Соколов', N'Роман', N'Борисович', '1981-11-03', '2015-09-01', 5.1), -- Старше 37, слабоуспевающий
(N'Лебедев', N'Никита', N'Аркадьевич', '1970-12-12', '2014-09-01', 7.5),-- Старше 45
(N'Козлов', N'Михаил', N'Евгеньевич', '1996-02-28', '2014-09-01', 10.0),-- Максимальный балл университета
(N'Тихонов', N'Павел', NULL, '1983-06-18', '2016-09-01', 4.2),         -- Без отчества, слабоуспевающий
(N'Белова', N'Инна', N'Сергеевна', '1985-10-10', '2015-09-01', 8.1),    -- Заочница
(N'Федоров', N'Денис', N'Григорьевич', '2001-04-04', '2019-09-01', 6.5),
(N'Макаров', N'Антон', N'Валентинович', '1974-09-09', '2015-09-01', 8.0),-- Старше 45
(N'Зайцев', N'Владимир', NULL, '1982-01-20', '2014-09-01', 5.9),       -- Без отчества, слабоуспевающий
(N'Беляев', N'Максим', N'Юрьевич', '1997-11-11', '2015-09-01', 9.1),
(N'Жукова', N'Анжела', N'Олеговна', '1980-03-03', '2016-09-01', 7.7);

-- 8. Учебный процесс (связь студентов с курсами)
-- 1. Студенты на ФПК (Очная) - hours_id = 1
INSERT INTO process (stud_id, hours_id)
SELECT id, 1 FROM stud WHERE last_name IN (N'Иванова', N'Козлов', N'Макаров', N'Беляев');

-- 2. Студенты на ФПМ (Очная) - hours_id = 2
INSERT INTO process (stud_id, hours_id)
SELECT id, 2 FROM stud WHERE last_name IN (N'Кузнецов', N'Смирнов', N'Тихонов', N'Зайцев', N'Жукова');

-- 3. Студенты на Заочку (ФПК) - hours_id = 3 (туда отправляем тех, кто 37+)
INSERT INTO process (stud_id, hours_id)
SELECT id, 3 FROM stud WHERE last_name IN (N'Васильев', N'Павлов', N'Соколов', N'Лебедев', N'Федоров');

-- 4. Курс без иностранцев (ФПМ) - hours_id = 4
INSERT INTO process (stud_id, hours_id)
SELECT id, 4 FROM stud WHERE last_name IN (N'Новикова', N'Попова', N'Белова', N'Морозов');

-- 5. Иностранцев (Браун, Ли) запишем на отдельный курс, чтобы не смешивать с "чистым" курсом
INSERT INTO process (stud_id, hours_id)
SELECT id, 1 FROM stud WHERE last_name IN (N'Браун', N'Ли');



SELECT * FROM faculty
SELECT * FROM stud
SELECT * FROM process
SELECT * FROM [hours]
SELECT * FROM form

SELECT stud.last_name, stud.f_name, stud.s_name, stud.br_date, stud.in_date, stud.exm, faculty.faculty_name, [hours].course, [hours].all_h, [hours].inclass_h, form.form_name FROM stud
	JOIN process ON process.stud_id = stud.id
	JOIN [hours] ON [hours].id = process.hours_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN form ON form.id = [hours].form_id
	

SELECT teach.last_name, teach.f_name, teach.s_name, faculty.faculty_name, subj.subj, subj.[hours] FROM work
	JOIN teach ON teach.id = work.teach_id
	JOIN subj ON subj.id = work.subj_id
	JOIN [hours] ON [hours].id = work.hours_id
	JOIN faculty ON faculty.id = [hours].faculty_id

-- Задание по SELECT
--1
SELECT AVG(exm) FROM stud 
	WHERE id IN (
		SELECT stud_id FROM process 
			WHERE hours_id IN (
			SELECT id FROM [hours]
				WHERE form_id=2
			)
		)

--2
SELECT faculty.faculty_name, MAX(stud.exm) FROM process
	JOIN stud ON stud.id = process.stud_id
	JOIN [hours] ON [hours].id = process.hours_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	GROUP BY faculty.faculty_name

--3
SELECT faculty.faculty_name, AVG(stud.exm) FROM process
	JOIN stud ON stud.id = process.stud_id
	JOIN [hours] ON [hours].id = process.hours_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	GROUP BY faculty.faculty_name
	HAVING AVG(stud.exm) > 7

--4
SELECT [hours].course, faculty.faculty_name, form.form_name, AVG(stud.exm) as avg_exm FROM process
	JOIN stud ON stud.id = process.stud_id
	JOIN [hours] ON [hours].id = process.hours_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN form ON form.id = [hours].form_id
	GROUP BY [hours].course, faculty.faculty_name, form.form_name
	HAVING AVG(stud.exm) > 7.5

--5
SELECT [hours].course, faculty.faculty_name, MIN(stud.exm) as min_exm FROM process
	JOIN stud ON stud.id = process.stud_id
	JOIN [hours] ON [hours].id = process.hours_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	GROUP BY [hours].course, faculty.faculty_name

--6
SELECT faculty.faculty_name, form.form_name, MIN(stud.exm) as min_exm FROM process
	JOIN stud ON stud.id = process.stud_id
	JOIN [hours] ON [hours].id = process.hours_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN form ON form.id = [hours].form_id
	GROUP BY faculty.faculty_name, form.form_name
	HAVING MIN(stud.exm) > 6

--7
SELECT [hours].all_h - [hours].inclass_h FROM process
	JOIN stud ON stud.id = process.stud_id
	JOIN [hours] ON [hours].id = process.hours_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN form ON form.id = [hours].form_id
	WHERE faculty.faculty_name = 'ФПК' AND [hours].course = 3 AND form.form_name = 'Заочная'

--8
SELECT faculty.faculty_name, [hours].course, form.form_name FROM process
	JOIN stud ON stud.id = process.stud_id
	JOIN [hours] ON [hours].id = process.hours_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN form ON form.id = [hours].form_id
	WHERE [hours].all_h - [hours].inclass_h > 150
	GROUP BY faculty.faculty_name, [hours].course, form.form_name

--9
SELECT teach.last_name, COUNT(work.subj_id) FROM work
	JOIN teach ON teach.id = work.teach_id
	JOIN subj ON subj.id = work.subj_id
	GROUP BY teach.last_name

--10
SELECT faculty.faculty_name, COUNT(teach.id) FROM work
	JOIN teach ON teach.id = work.teach_id
	JOIN [hours] ON [hours].id = work.hours_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	GROUP BY faculty.faculty_name

--11
SELECT subj.subj, MAX(subj.[hours]) FROM subj
	GROUP BY subj.subj

--12
SELECT teach.last_name FROM work
	JOIN teach ON teach.id = work.teach_id
	JOIN subj ON subj.id = work.subj_id
	GROUP BY teach.last_name
	HAVING COUNT(subj.subj) > 1

--13
SELECT [hours].course, faculty.faculty_name, SUM(subj.[hours]) FROM process
	JOIN stud ON stud.id = process.stud_id
	JOIN [hours] ON [hours].id = process.hours_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN work ON work.[hours_id] = [hours].id
	JOIN subj ON subj.id = work.subj_id
	GROUP BY [hours].course, faculty.faculty_name

--14
SELECT COUNT(subj.subj), faculty.faculty_name FROM [hours]
	JOIN work ON work.hours_id = [hours].id
	JOIN subj ON subj.id = work.subj_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	WHERE [hours].course = 2
	GROUP BY faculty.faculty_name
	ORDER BY faculty.faculty_name DESC

--15
SELECT COUNT(subj.subj), faculty.faculty_name FROM work
	JOIN subj ON subj.id = work.subj_id
	JOIN teach ON teach.id = work.teach_id
	JOIN [hours] ON [hours].id = work.hours_id
	JOIN faculty ON faculty.id = work.hours_id
	WHERE teach.s_name IS NULL
	GROUP BY faculty.faculty_name


-- Задание по JOIN
--1
SELECT faculty.faculty_name, [hours].course FROM [hours]
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN process ON process.hours_id = [hours].id
	JOIN stud ON stud.id = process.stud_id
	WHERE DATEDIFF(DAY, stud.br_date, GETDATE()) <= 37 * 365.25
	GROUP BY faculty.faculty_name, [hours].course

--2
SELECT faculty.faculty_name, COUNT(stud.id) from process
	JOIN stud ON stud.id = process.stud_id
	JOIN [hours] ON [hours].id = process.hours_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	GROUP BY faculty.faculty_name

--3
SELECT form.form_name, COUNT(stud.id) from process
	JOIN stud ON stud.id = process.stud_id
	JOIN [hours] ON [hours].id = process.hours_id
	JOIN form ON form.id = [hours].form_id
	GROUP BY form.form_name

--4
SELECT faculty.faculty_name, AVG(DATEDIFF(DAY, stud.br_date, DATEFROMPARTS(YEAR(GETDATE()), 12, 31)) / 365.25) from process
	JOIN stud ON stud.id = process.stud_id
	JOIN [hours] ON [hours].id = process.hours_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	GROUP BY faculty.faculty_name

--5
SELECT stud.in_date, faculty.faculty_name, [hours].course, form.form_name FROM [hours]
	JOIN form ON form.id = [hours].form_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN process ON process.hours_id = [hours].id
	JOIN stud ON stud.id = process.stud_id
	WHERE stud.s_name IS NULL

--6
SELECT TOP (1) faculty.faculty_name, COUNT(stud.id) AS students FROM [hours]
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN process ON process.hours_id = [hours].id
	JOIN stud ON stud.id = process.stud_id
	WHERE YEAR(stud.in_date) = 2015
	GROUP BY faculty.faculty_name
	ORDER BY students DESC

--7
SELECT faculty.faculty_name, form.form_name, COUNT(stud.id) FROM [hours]
	JOIN form ON form.id = [hours].form_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN process ON process.hours_id = [hours].id
	JOIN stud ON stud.id = process.stud_id
	WHERE YEAR(stud.in_date) = 2014
	GROUP BY faculty.faculty_name, form.form_name

--8
SELECT faculty.faculty_name FROM [hours]
	JOIN form ON form.id = [hours].form_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	WHERE form.form_name = 'Заочная'
	GROUP BY faculty.faculty_name

--9
SELECT faculty.faculty_name, form.form_name, [hours].course FROM [hours]
	JOIN form ON form.id = [hours].form_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	GROUP BY faculty.faculty_name, form.form_name, [hours].course
	
--10
SELECT faculty.faculty_name, form.form_name, COUNT(stud.id) FROM [hours]
	JOIN form ON form.id = [hours].form_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN process ON process.hours_id = [hours].id
	JOIN stud ON stud.id = process.stud_id
	GROUP BY faculty.faculty_name, form.form_name

--11
SELECT COUNT(stud.id), faculty.faculty_name, form.form_name, [hours].course FROM [hours]
	JOIN form ON form.id = [hours].form_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN process ON process.hours_id = [hours].id
	JOIN stud ON stud.id = process.stud_id
	WHERE [hours].course = 1 OR [hours].course = 3
	GROUP BY faculty.faculty_name, form.form_name, [hours].course

--12
SELECT COUNT(stud.id), faculty.faculty_name, [hours].course FROM [hours]
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN process ON process.hours_id = [hours].id
	JOIN stud ON stud.id = process.stud_id
	WHERE stud.s_name IS NULL
	GROUP BY faculty.faculty_name, [hours].course

--13
SELECT COUNT(stud.id), faculty.faculty_name, [hours].course FROM [hours]
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN process ON process.hours_id = [hours].id
	JOIN stud ON stud.id = process.stud_id
	WHERE stud.exm >= 7.5
	GROUP BY faculty.faculty_name, [hours].course

--14
SELECT faculty.faculty_name, form.form_name, COUNT(stud.id) FROM [hours]
	JOIN form ON form.id = [hours].form_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN process ON process.hours_id = [hours].id
	JOIN stud ON stud.id = process.stud_id
	WHERE DATEDIFF(DAY, stud.br_date, GETDATE()) >= 45 * 365.25
	GROUP BY faculty.faculty_name, form.form_name

--15
SELECT faculty.faculty_name, form.form_name, [hours].course, COUNT(stud.id) FROM [hours]
	JOIN form ON form.id = [hours].form_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN process ON process.hours_id = [hours].id
	JOIN stud ON stud.id = process.stud_id
	WHERE DATEDIFF(DAY, stud.br_date, GETDATE()) <= 27 * 365.25
	GROUP BY faculty.faculty_name, form.form_name, [hours].course

--16
SELECT faculty.faculty_name, COUNT(stud.id) FROM [hours]
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN process ON process.hours_id = [hours].id
	JOIN stud ON stud.id = process.stud_id
	WHERE stud.last_name LIKE 'С%'
	GROUP BY faculty.faculty_name, stud.last_name


-- Задание по подзапросам
--1
SELECT stud.id FROM stud, (
	SELECT MAX(stud.exm) as max_exm FROM stud
	) AS sel 
	WHERE stud.exm = sel.max_exm * 0.8

--2
SELECT stud.id FROM stud, (
	SELECT MAX(stud.exm) as max_exm FROM stud
	) AS sel 
	WHERE stud.exm = sel.max_exm

--3
SELECT stud.last_name FROM (
	SELECT MAX(faculty.faculty_name) AS max_faculty FROM [hours]
		JOIN faculty ON faculty.id = [hours].faculty_id
		JOIN process ON process.hours_id = [hours].id
		JOIN stud ON stud.id = process.stud_id
	) AS sel, stud
	JOIN process ON process.stud_id = stud.id
	JOIN [hours] ON [hours].id = process.hours_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	WHERE faculty.faculty_name = sel.max_faculty
--!
--4
SELECT * FROM (
	SELECT stud.last_name, stud.s_name, form.form_name, [hours].course, faculty.faculty_name FROM [hours]
		JOIN process ON process.hours_id = [hours].id
		JOIN stud ON stud.id = process.stud_id
		JOIN form ON form.id = [hours].form_id
		JOIN faculty ON faculty.id = [hours].faculty_id
	) AS sel
	WHERE sel.s_name IS NOT NULL

--5
SELECT sel.last_name FROM (
	SELECT stud.last_name, [hours].course, faculty.faculty_name FROM [hours]
		JOIN process ON process.hours_id = [hours].id
		JOIN stud ON stud.id = process.stud_id
		JOIN faculty ON faculty.id = [hours].faculty_id
	) AS sel
	WHERE sel.course = (SELECT [hours].course FROM [hours]
							JOIN process ON process.hours_id = [hours].id
							JOIN stud ON stud.id = process.stud_id
							WHERE stud.last_name = 'Ботяновского'
						)
						AND
						sel.faculty_name = (SELECT faculty.faculty_name FROM [hours]
							JOIN process ON process.hours_id = [hours].id
							JOIN stud ON stud.id = process.stud_id
							JOIN faculty ON faculty.id = [hours].faculty_id
							WHERE stud.last_name = 'Ботяновского'
						)

--6 зайцева и зингель на одном курсе?
SELECT sel.last_name, sel.course FROM (
	SELECT stud.last_name, [hours].course, faculty.faculty_name FROM [hours]
		JOIN process ON process.hours_id = [hours].id
		JOIN stud ON stud.id = process.stud_id
		JOIN faculty ON faculty.id = [hours].faculty_id
	) AS sel
	WHERE sel.course IN (SELECT [hours].course FROM [hours]
							JOIN process ON process.hours_id = [hours].id
							JOIN stud ON stud.id = process.stud_id
							WHERE stud.last_name = 'Зингель' OR stud.last_name = 'Зайцева'
						)

--7 не понял факультет курс и форма это общее или отдельно? НЕ ПЕРЕЖИВАЙ ОТДЕЛЬНО ОТ REXA
SELECT stud.last_name, stud.s_name, form.form_name, [hours].course, faculty.faculty_name FROM [hours]
	JOIN process ON process.hours_id = [hours].id
	JOIN stud ON stud.id = process.stud_id
	JOIN form ON form.id = [hours].form_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	WHERE faculty.faculty_name IN (SELECT faculty.faculty_name
										FROM stud
										JOIN process ON process.stud_id = stud.id
										JOIN [hours] ON [hours].id = process.hours_id
										JOIN faculty ON faculty.id = [hours].faculty_id
										GROUP BY faculty.faculty_name
										HAVING SUM(CASE WHEN stud.s_name IS NULL THEN 1 ELSE 0 END) > 1
									)
								OR
								[hours].course IN (SELECT [hours].course
										FROM stud
										JOIN process ON process.stud_id = stud.id
										JOIN [hours] ON [hours].id = process.hours_id
										GROUP BY [hours].course
										HAVING SUM(CASE WHEN stud.s_name IS NULL THEN 1 ELSE 0 END) > 1
									)
								OR
								form.form_name IN (SELECT form.form_name
										FROM stud
										JOIN process ON process.stud_id = stud.id
										JOIN [hours] ON [hours].id = process.hours_id
										JOIN form ON form.id = [hours].form_id
										GROUP BY form.form_name
										HAVING SUM(CASE WHEN stud.s_name IS NULL THEN 1 ELSE 0 END) > 1
									)

--8
SELECT stud.last_name, faculty.faculty_name, [hours].course, sel.all_stud FROM stud
	JOIN process ON process.stud_id = stud.id
	JOIN [hours] ON [hours].id = process.hours_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN (
		SELECT [hours].faculty_id, [hours].course, COUNT(process.stud_id) AS all_stud FROM [hours]
			JOIN process ON process.hours_id = [hours].id
			GROUP BY [hours].faculty_id, [hours].course
	) AS sel ON sel.faculty_id = faculty.id AND sel.course = [hours].course
	WHERE stud.s_name IS NULL


--Задание по процедурам
--1
GO
CREATE PROCEDURE CalculateStudents 
	@faculty_name NVARCHAR(70),
	@form_name NVARCHAR(30)
	AS
BEGIN
	SELECT COUNT(stud.id), faculty.faculty_name, form.form_name FROM [hours]
		JOIN form ON form.id = [hours].form_id
		JOIN faculty ON faculty.id = [hours].faculty_id
		JOIN process ON process.hours_id = [hours].id
		JOIN stud ON stud.id = process.stud_id
		WHERE faculty.faculty_name = @faculty_name AND form.form_name = @form_name
		GROUP BY faculty.faculty_name, form.form_name
END

EXEC CalculateStudents 'ИТ', 'Очная'

--2
GO
CREATE PROCEDURE CalculateSubj 
	AS
BEGIN
	DECLARE @all_subj_int INT
	SELECT @all_subj_int = COUNT(subj.id) FROM [hours]
		JOIN faculty ON faculty.id = [hours].faculty_id
		JOIN work ON work.hours_id = [hours].id
		JOIN subj ON subj.id = work.subj_id

	DECLARE @fpm_subj_int INT
	SELECT @fpm_subj_int = COUNT(subj.id) FROM [hours]
		JOIN faculty ON faculty.id = [hours].faculty_id
		JOIN work ON work.hours_id = [hours].id
		JOIN subj ON subj.id = work.subj_id
		WHERE faculty.faculty_name = 'ФПМ'
	
	DECLARE @fpk_subj_int INT
	SELECT @fpk_subj_int = COUNT(subj.id) FROM [hours]
		JOIN faculty ON faculty.id = [hours].faculty_id
		JOIN work ON work.hours_id = [hours].id
		JOIN subj ON subj.id = work.subj_id
		WHERE faculty.faculty_name = 'ФПК'

	DECLARE @same_subj_int INT
	SELECT @same_subj_int = COUNT(subj.subj) FROM [hours]
		JOIN faculty ON faculty.id = [hours].faculty_id
		JOIN work ON work.hours_id = [hours].id
		JOIN subj ON subj.id = work.subj_id
		WHERE faculty.faculty_name = 'ФПМ' AND faculty.faculty_name = 'ФПК'
	PRINT('Для ФПК читается ' + CONVERT(CHAR, @fpk_subj_int) + 'предметов, для ФПМ читается ' + CONVERT(CHAR, @fpm_subj_int) + 'предметов, всего' + CONVERT(CHAR, @all_subj_int) + 'предметов (' + CONVERT(CHAR, @same_subj_int) + ' из которых идентичны)')
END

EXEC CalculateSubj

--3
GO
CREATE PROCEDURE AddStud 
	@faculty_name NVARCHAR(70),
	@form_name NVARCHAR(30),
	@br_date Date,
	@in_date Date,
	@last_name NVARCHAR(30),
	@f_name NVARCHAR(30),
	@s_name NVARCHAR(30)
	AS
BEGIN 
	INSERT INTO stud (last_name, f_name, s_name, br_date, in_date, exm) VALUES (@last_name, @f_name, @s_name, @br_date, @in_date, 0.0)

	BEGIN TRY
		DECLARE @hours_id INT
		SELECT @hours_id = [hours].id FROM [hours]
			JOIN faculty ON faculty.id = [hours].faculty_id
			JOIN form ON form.id = [hours].form_id
			WHERE faculty.faculty_name = @faculty_name AND form.form_name = @form_name AND course = 1
		INSERT INTO process (stud_id, hours_id) (SELECT IDENT_CURRENT('stud'), @hours_id)
	END TRY
	BEGIN CATCH
		PRINT('Ошибка при заполнении таблицы hours')
	END CATCH
END

EXEC AddStud 'ФПК', 'Очная', '2000-01-01', '2016-01-01', 'ДФамилия', 'ДИмя', 'ДОтчество'


--Задание по функциям
--1
GO
CREATE FUNCTION dbo.GetCountryInfo (@s_name NVARCHAR(30))
	RETURNS NVARCHAR(10)
AS
BEGIN
	IF (@s_name IS NULL)
		BEGIN
			RETURN 'иностранец'
		END
	RETURN 'гражданин'
END
GO

SELECT dbo.GetCountryInfo(NULL)

--2
GO
CREATE FUNCTION dbo.GetTeachersHours ()
	RETURNS TABLE
AS
RETURN (SELECT teach.last_name, SUM(subj.[hours]) as total_hours FROM work
			JOIN teach ON teach.id = work.teach_id
			JOIN subj ON subj.id = work.subj_id
			GROUP BY teach.last_name
		)
GO

SELECT * FROM dbo.GetTeachersHours()


--Задание по VIEW
--1
CREATE VIEW dbo.StudInfo
AS
SELECT stud.last_name, stud.f_name, stud.s_name, [hours].course, form.form_name FROM stud
	JOIN process ON process.stud_id = stud.id
	JOIN [hours] ON [hours].id = process.hours_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN form ON form.id = [hours].form_id
	WHERE faculty.faculty_name = 'ФПК'
GO

CREATE VIEW dbo.HoursInfo
AS
SELECT faculty.faculty_name, [hours].course, [hours].all_h FROM stud
	JOIN process ON process.stud_id = stud.id
	JOIN [hours] ON [hours].id = process.hours_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN form ON form.id = [hours].form_id
	WHERE form.form_name = 'Заочная'
	GROUP BY faculty.faculty_name, [hours].course, [hours].all_h
GO

CREATE VIEW dbo.GoodStudsInfo
AS
SELECT faculty.faculty_name, [hours].course, form.form_name, COUNT(stud.id) AS quantity FROM stud
	JOIN process ON process.stud_id = stud.id
	JOIN [hours] ON [hours].id = process.hours_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN form ON form.id = [hours].form_id
	WHERE stud.exm > 8
	GROUP BY faculty.faculty_name, [hours].course, form.form_name
GO

CREATE VIEW dbo.BadStudsInfo
AS
SELECT stud.last_name, stud.exm FROM stud
	JOIN process ON process.stud_id = stud.id
	JOIN [hours] ON [hours].id = process.hours_id
	JOIN faculty ON faculty.id = [hours].faculty_id
	JOIN form ON form.id = [hours].form_id
	WHERE stud.exm < 6 AND stud.exm != 0
	GROUP BY stud.last_name, stud.exm
GO

--2
--Все представления только читают, т.к. они не вносят изменения в БД.

--Задания по UNION
--1
SELECT teach.last_name, SUM(subj.hours) AS total_hours, '20%' AS bonus FROM teach
	JOIN work ON teach.id = work.teach_id
	JOIN subj ON work.subj_id = subj.id
	GROUP BY teach.last_name
	HAVING SUM(subj.hours) >= 450
UNION ALL

SELECT teach.last_name, SUM(subj.hours) AS total_hours, '10%' AS bonus FROM teach
	JOIN work ON teach.id = work.teach_id
	JOIN subj ON work.subj_id = subj.id
	GROUP BY teach.last_name
	HAVING SUM(subj.hours) BETWEEN 300 AND 449
UNION ALL

SELECT teach.last_name, SUM(subj.hours) AS total_hours, '0%' AS bonus FROM teach
	JOIN work ON teach.id = work.teach_id
	JOIN subj ON work.subj_id = subj.id
	GROUP BY teach.last_name
	HAVING SUM(subj.hours) < 300
	ORDER BY teach.last_name

--2
SELECT stud.last_name, 'student', (CASE WHEN stud.s_name IS NOT NULL THEN 'РБ' ELSE 'иностранное' END) FROM stud
	GROUP BY stud.last_name, stud.s_name

UNION ALL

SELECT teach.last_name, 'teacher', (CASE WHEN teach.s_name IS NOT NULL THEN 'РБ' ELSE 'иностранное' END) FROM teach
	GROUP BY teach.last_name, teach.s_name

--3
SELECT teach.last_name FROM teach
	JOIN work ON teach.id = work.teach_id
	JOIN [hours] ON work.hours_id = [hours].id
	JOIN faculty ON [hours].faculty_id = faculty.id
	WHERE faculty.faculty_name = 'ФПК'

UNION

SELECT teach.last_name FROM teach
	JOIN work ON teach.id = work.teach_id
	JOIN [hours] ON work.hours_id = [hours].id
	JOIN faculty ON [hours].faculty_id = faculty.id
	WHERE faculty.faculty_name = 'ФПМ'

--4
SELECT teach.last_name FROM teach
	JOIN work ON teach.id = work.teach_id
	JOIN [hours] ON work.hours_id = [hours].id
	JOIN faculty ON [hours].faculty_id = faculty.id
	WHERE faculty.faculty_name = 'ФПК'

EXCEPT

SELECT teach.last_name FROM teach
	JOIN work ON teach.id = work.teach_id
	JOIN [hours] ON work.hours_id = [hours].id
	JOIN faculty ON [hours].faculty_id = faculty.id
	WHERE faculty.faculty_name = 'ФПМ'

--5
SELECT 'Студентов', COUNT(stud.id) FROM stud

UNION ALL

SELECT 'Преподавателей', COUNT(teach.id) FROM teach

UNION ALL

SELECT 'Всего человек', (SELECT COUNT(stud.id) FROM stud) + (SELECT COUNT(teach.id) FROM teach)
