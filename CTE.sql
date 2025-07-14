use Sejong_Univer;
show tables from Sejong_Univer;

 with class as(select * from classroom where capacity >50)
 select c.building, c.room_no, c.capacity, d.dept_name from class c join department d on c.building = d. building order by c.capacity desc;

select * from department;
select * from instructor;

with cscourses as (
  select * from instructor where dept_name = 'Comp. Sci.'
)

select i.name,i.dept_name,t.year from cscourses i join teaches t on i.ID=t.ID where t.year=2009;

select * from student;
select * from takes;
select * from course;


with dept_count as (
  select dept_name, count(*) as student_count
  from student
  group by dept_name
)
select * from dept_count;

with instructor_salary as (
  select name, salary
  from instructor
)
select * from instructor_salary where salary > 70000;

with cs_courses as (
  select course_id, title
  from course
  where dept_name = 'computer science'
)
select * from cs_courses;

select * from takes;
select * from course;

with avg_salary as (
  select dept_name, avg(salary) as avg_salary
  from instructor
  group by dept_name
)
select * from avg_salary;

with course_sections as (
  select course_id, count(*) as section_count
  from section
  group by course_id
)
select * from course_sections;

with student_credits as (
  select name, tot_cred
  from student
)
select * from student_credits where tot_cred >= 100;

with courses_with_prereq as (
  select c.course_id, c.title, p.prereq_id
  from course c
  join prereq p on c.course_id = p.course_id
)
select * from courses_with_prereq;

with section_capacity as (
  select s.course_id, s.sec_id, c.capacity
  from section s
  join classroom c on s.building = c.building and s.room_no = c.room_no
)
select * from section_capacity;

with advisor_names as (
  select s.name as student_name, i.name as instructor_name
  from advisor a
  join student s on a.s_id = s.id
  join instructor i on a.i_id = i.id
)
select * from advisor_names;

with building_rooms as (
  select building, count(distinct room_no) as rooms
  from classroom
  group by building
)
select * from building_rooms;

with time_details as (
  select time_slot_id, min(start_time) as start_time, max(end_time) as end_time
  from time_slot
  group by time_slot_id
)
select * from time_details;

with department_courses as (
  select dept_name, count(*) as course_count
  from course
  group by dept_name
)
select * from department_courses;

with students_taking as (
  select id, count(*) as course_count
  from takes
  group by id
)
select * from students_taking;

with teaches_count as (
  select id, count(*) as sections_taught
  from teaches
  group by id
)
select * from teaches_count;

with course_grades as (
  select course_id, grade, count(*) as total
  from takes
  group by course_id, grade
)
select * from course_grades;

with total_capacity as (
  select sum(capacity) as total_capacity
  from classroom
)
select * from total_capacity;

with course_enrollment as (
  select course_id, count(*) as total_students
  from takes
  group by course_id
)
select * from course_enrollment;

select * from takes;
select * from course;

with instructors_per_dept as (
  select dept_name, count(*) as instructor_count
  from instructor
  group by dept_name
)
select * from instructors_per_dept;

with credit_sum as (
  select dept_name, sum(credits) as total_credits
  from course
  group by dept_name
)
select * from credit_sum;


with course_ranks as (
  select id, course_id, rank() over (partition by id order by grade desc) as rnk
  from takes
)
select * from course_ranks where rnk = 1;

with recursive_dept as (
  select dept_name, budget from department
  union all
  select d.dept_name, d.budget * 1.05
  from department d
  join recursive_dept r on d.dept_name = r.dept_name and d.budget < 1000000
)
select * from recursive_dept;

with building_usage as (
  select building, count(*) as course_count
  from section
  group by building
)
select * from building_usage;

with enrolled_students as (
  select s.id, s.name, t.course_id
  from student s
  join takes t on s.id = t.id
)
select course_id, count(distinct id) as num_students from enrolled_students group by course_id;

select * from takes;
select * from course;

with avg_grade as (
  select course_id, avg(case grade
    when 'a' then 4
    when 'b' then 3
    when 'c' then 2
    when 'd' then 1
    else 0 end) as gpa
  from takes
  group by course_id
)
select * from avg_grade;

with instructor_load as (
  select id, count(*) as loadi
  from teaches
  group by id
)
select * from instructor_load where loadi > 3;

with overlapping_sections as (
  select s1.course_id, s1.sec_id, s2.sec_id as overlap_sec
  from section s1
  join section s2 on s1.course_id = s2.course_id and s1.sec_id != s2.sec_id and s1.time_slot_id = s2.time_slot_id
)
select * from overlapping_sections;

with course_teachers as (
  select t.course_id, i.name
  from teaches t
  join instructor i on t.id = i.id
)
select * from course_teachers;

with full_classrooms as (
  select s.building, s.room_no, count(*) as usage_count
  from section s
  group by s.building, s.room_no
)
select * from full_classrooms order by usage_count desc;

delimiter $$

create procedure insert_student(in sid varchar(5), in sname varchar(20), in dept varchar(20), in credits int)
begin
  insert into student(id, name, dept_name, tot_cred) values(sid, sname, dept, credits);
end 

create procedure assign_advisor(in sid varchar(5), in iid varchar(5))
begin
  insert into advisor(s_id, i_id) values(sid, iid);
end 

create procedure get_student_courses(in sid varchar(5))
begin
  select course_id from takes where id = sid;
end 

create procedure increase_budget(in dept varchar(20), in percent decimal(5,2))
begin
  update department set budget = budget * (1 + percent / 100) where dept_name = dept;
end

create procedure delete_student(in sid varchar(5))
begin
  delete from takes where id = sid;
  delete from advisor where s_id = sid;
  delete from student where id = sid;
end 

create procedure update_grade(in sid varchar(5), in cid varchar(8), in newgrade char(1))
begin
  update takes set grade = newgrade where id = sid and course_id = cid;
end 

create procedure list_instructors_by_dept(in dept varchar(20))
begin
  select name from instructor where dept_name = dept;
end 

create procedure enroll_student(in sid varchar(5), in cid varchar(8), in secid varchar(8), in sem varchar(6), in yr int)
begin
  insert into takes(id, course_id, sec_id, semester, year) values(sid, cid, secid, sem, yr);
end 

create procedure assign_course(in iid varchar(5), in cid varchar(8), in secid varchar(8), in sem varchar(6), in yr int)
begin
  insert into teaches(id, course_id, sec_id, semester, year) values(iid, cid, secid, sem, yr);
end 

create procedure total_students_in_course(in cid varchar(8))
begin
  select count(*) as total_students from takes where course_id = cid;
end 

delimiter ;

select* from instructor;
select* from course;
select* from teaches;

select* from prereq;

