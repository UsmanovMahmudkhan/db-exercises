use Sejong_Univer;
SELECT * FROM department;
SELECT * FROM student;
SELECT * FROM instructor;
SELECT * FROM classroom;
SELECT * FROM section;
SELECT name, dept_name, 
  ROW_NUMBER() OVER (PARTITION BY dept_name ORDER BY name) AS row_num
FROM student;

SELECT title, dept_name,
  ROW_NUMBER() OVER (PARTITION BY dept_name ORDER BY title) AS course_order
FROM course;

SELECT name, dept_name, salary,
  ROW_NUMBER() OVER (PARTITION BY dept_name ORDER BY salary DESC) AS salary_rank
FROM instructor;

SELECT course_id, semester, year,
  ROW_NUMBER() OVER (ORDER BY year, semester) AS sequence
FROM section;

SELECT building, room_no, capacity,
  ROW_NUMBER() OVER (PARTITION BY building ORDER BY capacity DESC) AS capacity_rank
FROM classroom;

SELECT name, dept_name, tot_cred,
  RANK() OVER (PARTITION BY dept_name ORDER BY tot_cred DESC) AS credit_rank
FROM student;

SELECT title, credits, dept_name,
  RANK() OVER (PARTITION BY dept_name ORDER BY credits DESC) AS credit_rank
FROM course;

SELECT name, salary, dept_name,
  RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM instructor;

SELECT course_id, time_slot_id,
  RANK() OVER (ORDER BY time_slot_id) AS time_rank
FROM section;

SELECT course_id, sec_id, semester, year, grade,
  RANK() OVER (PARTITION BY course_id, sec_id ORDER BY grade DESC) AS grade_rank
FROM takes;


SELECT name, tot_cred, dept_name,
  DENSE_RANK() OVER (PARTITION BY dept_name ORDER BY tot_cred DESC) AS dense_cred_rank
FROM student;

SELECT course_id, COUNT(*) AS enrollments,
  DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS enrollment_rank
FROM takes
GROUP BY course_id;

SELECT building, room_no, capacity,
  DENSE_RANK() OVER (ORDER BY capacity DESC) AS capacity_rank
FROM classroom;

SELECT dept_name,
  SUM(salary) OVER (PARTITION BY dept_name) AS dept_salary_total
FROM instructor;

SELECT course_id,
  SUM(1) OVER (PARTITION BY course_id) AS total_students
FROM takes;

SELECT dept_name, salary,
  AVG(salary) OVER (PARTITION BY dept_name) AS dept_avg_salary
FROM instructor;

SELECT ID, tot_cred,
  AVG(tot_cred) OVER (ORDER BY ID ROWS 5 PRECEDING) AS rolling_avg
FROM student;

SELECT title, dept_name, credits,
  LEAD(credits) OVER (PARTITION BY dept_name ORDER BY title) AS next_course_credits
FROM course;

SELECT name, salary,
  LAG(salary) OVER (ORDER BY salary) AS prev_salary
FROM instructor;

SELECT building, room_no, capacity,
  LAG(capacity) OVER (PARTITION BY building ORDER BY room_no) AS prev_room_capacity
FROM classroom;

SELECT ID, grade,
  SUM(grade) OVER (PARTITION BY ID ORDER BY year, semester) AS cumulative_grade
FROM takes;

SELECT course_id, semester, year, COUNT(*) AS enrollments,
  RANK() OVER (ORDER BY COUNT(*) DESC) AS enrollment_rank
FROM takes
GROUP BY course_id, semester, year;

SELECT ID, dept_name, tot_cred,
  AVG(tot_cred) OVER (PARTITION BY dept_name) AS dept_avg,
  tot_cred - AVG(tot_cred) OVER (PARTITION BY dept_name) AS diff_from_avg
FROM student;