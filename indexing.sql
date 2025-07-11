
CREATE TABLE student1 (
    student_id VARCHAR(50),
    name VARCHAR(50),
    dept_name VARCHAR(50),
    tot_cred INT
);

DELIMITER $$

CREATE PROCEDURE insert_students()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 50000 DO
    INSERT INTO student1 (student_id, name, dept_name, tot_cred)
    VALUES (
      CONCAT('sejong', LPAD(i, 5, '0')),
      CONCAT(ELT(FLOOR(1 + (RAND() * 4)), 'alex', 'Kim', 'Joshua', 'smth'), i),
      ELT(FLOOR(1 + (RAND() * 8)), 'CS', 'biology', 'chemistry', 'Ai', 'paper', 'art', 'databse', 'javaDev'),
      FLOOR(RAND() * 150)
    );
    SET i = i + 1;
  END WHILE;
END $$

DELIMITER ;

CALL insert_students();

SELECT * FROM student1;
SELECT * FROM student1 LIMIT 50000;

select dept_name , count(name) from student group by dept_name;

explain select dept_name , count(name) from student group by dept_name;
ALTER TABLE student1 DROP INDEX idn_dept_name;

show indexes from student1;

select * from student1;

select * from student1
order by tot_cred desc
limit 5;

create index idx_tot_cred on student1(tot_cred desc);

drop index idx_tot_cred on student1;
create index idx_tot_cred2 on student1(tot_cred desc);

select * from student1
order by tot_cred desc
limit 5;

explain select * from student1
order by tot_cred desc
limit 5;


set @start := now();
select * from student1 order by tot_cred desc limit 5;
set @end := now();
select timediff(@end, @start) as duration;



create index idx_section_course_semester on section(course_id, semester);

select * from section
where course_id = 'CS101' and semester = 'Fall';

create index idx_ID on student1(student_id);

select student_id from student1 where student_id>'sejong00050';

drop index idx_ID on student1;

show index from student1;

CREATE OR REPLACE VIEW course_details AS
SELECT course_id, title, department_name, credits
FROM course
WHERE credits >= 2;


use Sejong_Univer;
select * from student;

create index idx_dept_name on student(dept_name);
explain select * from student where dept_name='Physics';
alter table student drop index idx_dept_name;

select * from instructor;

create index idx_instructor_name on instructor(name);
drop index idx_instructor_name on instructor;
show index from instructor;

select * from course;

SHOW INDEX FROM student WHERE Key_name = 'idx_dept_name';

SELECT CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'Sejong_Univer'
  AND TABLE_NAME = 'student'
  AND COLUMN_NAME = 'dept_name';
  
select * from takes;
create  index idx_takes_id_courseID on takes(ID,course_id);

DROP INDEX idx_takes_id_courseID ON takes;
select * from takes;

select * from advisor;
create unique index idx_studentID on advisor(s_id);
drop index idx_studentID on advisor;

create fulltext index idx_title on course(title);

SELECT * FROM course 
WHERE MATCH(title) AGAINST('Intro');

drop index idx_title on course;

select * from student;
create view cs_students as
select ID,name,tot_cred from student where dept_name='Physics';


create view high_credit_students as 
select ID,name,dept_name,tot_cred from student where tot_cred>100;
select * from high_credit_students;


create view department_stats as
select 
  s.dept_name, 
  count(s.ID) as total_students, 
  avg(i.salary) as avg_salary
from 
  student s 
join 
  instructor i 
on 
  s.dept_name = i.dept_name 
group by 
  s.dept_name;
  
  
select * from department_stats;



SELECT * FROM course_details
WHERE department_name = 'Computer Science';

CREATE OR REPLACE VIEW instructor_assignments AS
SELECT i.instructor_id, i.name AS instructor_name, i.department_name,
       t.course_id, t.section_id, t.semester, t.year
FROM instructor i
JOIN teaches t ON i.instructor_id = t.instructor_id
JOIN section s ON t.course_id = s.course_id 
              AND t.section_id = s.section_id 
              AND t.semester = s.semester 
              AND t.year = s.year;

SELECT instructor_name, course_id, semester, year
FROM instructor_assignments
WHERE department_name = 'Biology';

CREATE OR REPLACE VIEW course_details AS
SELECT c.course_id, c.title, c.department_name, c.credits, d.budget AS department_budget
FROM course c
JOIN department d ON c.department_name = d.department_name
WHERE c.credits >= 2;

DROP VIEW IF EXISTS course_details;

CREATE OR REPLACE VIEW high_credit_course AS
SELECT course_id, title, department_name, credits
FROM course
WHERE credits >= 3
WITH CHECK OPTION;

INSERT INTO high_credit_course (course_id, title, department_name, credits)
VALUES ('CS9999', 'Test Course', 'Computer Science', 2);

UPDATE high_credit_course
SET credits = 4
WHERE course_id = 'CS101';

CREATE OR REPLACE VIEW student_grade AS
SELECT s.student_id, s.name, t.course_id, t.grade
FROM student s
JOIN takes t ON s.student_id = t.student_id
WHERE t.semester = 'Fall' AND t.year = 2024;

GRANT SELECT ON student_grade TO 'username'@'localhost';

CREATE OR REPLACE VIEW classroom_usage AS
SELECT s.building, s.room_number, s.time_slot_id, c.capacity
FROM section s
JOIN classroom c ON s.building = c.building AND s.room_number = c.room_number
WHERE s.semester = 'Fall' AND s.year = 2009;

SELECT building, room_number, time_slot_id
FROM classroom_usage
WHERE capacity > 50;

create view department_stats as
select 
  s.dept_name, 
  count(s.ID) as total_students, 
  avg(i.salary) as avg_salary
from 
  student s 
join 
  instructor i 
on 
  s.dept_name = i.dept_name 
group by 
  s.dept_name;
  
  
select * from student;
select * from instructor;
select * from department;

create index idx_dept_name on instructor(dept_name);
drop index idx_dept_name on instructor;

select * from section;

create index idx_sr on section(semester,year);

create unique index idx_name on course(title,dept_name);
drop index idx_name on course;

drop index idx_intrcutor_dept_name on instructor;

show index from student;

select * from student;
select * from instructor;
select * from department;
select * from course;
select * from takes;
select * from classroom;

create or replace view say as
select s.ID,s.name,s.tot_cred, a.s_id, i.name
from student s join advisor a on s.ID= a.s_id
join  instructor i on a.i_id=i.ID;


create view hi as 
select * from classroom where capacity > 50;
select * from hi;


select * from student;
select * from instructor;
select * from department;
select * from course;
select * from takes;
select * from teaches;

create view hi as
select s.name, t.semester, c.title, s.tot_cred 
from student s join takes t on s.ID= t.ID 
join course c on t.course_id= c.course_id;





 






