use Sejong_Univer;
select * from instructor where dept_name='Physics';
update instructor set salary=salary*2 where dept_name='Physics';

select * from classroom where building ='Taylor' and room_no=3128;
update classroom set capacity=99 where building='Taylor'and room_no=3128;

select* from student where ID=98988;
update student set tot_cred=tot_cred/2 where ID=98988 and name='Tanaka';

describe student;
select * from course;

select * from course where course_id='BIO-399';
delete from course where course_id='BIO-399';

select * from section;
update section set time_slot_id='xxxxx' where course_id='CS-101' and sec_id=1 and semester='Fall' and year=2009 and room_no='101';

select * from instructor;
insert into instructor (id,name,salary) values (77777,'padrickky',909090);

update instructor set dept_name='database' where dept_name is null and ID=77777;

select* from instructor;
select * from instructor where salary > 90000;
update instructor set salary = 10 where salary>90000 and ID=22222;

select* from student;
update student set name='alex' where ID=128 and dept_name='Comp. Sci.' and tot_cred>100;
select * from student;

select count(*) as total_classroom from classroom;

select * from instructor;

select count(dept_name) as number from instructor;

select * from classroom;

select count(distinct building) as total from classroom;

select * from department;

select sum(budget) as total_budged from department;

select * from classroom;

select sum(capacity) from classroom where building='Watson';


select * from instructor;

select dept_name, sum(salary) as total from instructor where salary is not null
 group by dept_name;
 
 select * from department;
 
 select avg(budget) as average from department where dept_name !='Biology';
 
 select * from classroom;
 
 select min(capacity) as minimum from classroom;
 
select * from time_slot;

select min(start_time) as minTime from time_slot;

select * from instructor;

select dept_name, min(salary) as minimum_wage from instructor group by dept_name;

select * from classroom;

select max(capacity) as maximum from classroom;

select * from department;

select max(budget) as max from department;

select building,  max(budget) as max from department group by building;

select * from course;
select * from department;

select course.course_id, course.title, department.dept_name, department.building
from course
inner join department on course.dept_name = department.dept_name;

 
select * from classroom;
select * from section;

select section.course_id, section.sec_id, section.semester, section.year,
classroom.building, classroom.room_no, classroom.capacity from section inner join classroom on section.building = classroom.building and classroom.room_no=section.room_no;

select course.course_id, course.title, department.dept_name, department.budget
from course
left join department on course.dept_name = department.dept_name;

select department.dept_name, department.building, course.course_id, course.title
from course
right join department on course.dept_name = department.dept_name;

select department.dept_name, department.budget, instructor.instructor_id, instructor.name
from instructor
right join department on instructor.dept_name = department.dept_name;


select course.course_id, course.title, department.dept_name, department.building
from course
full join department on course.dept_name = department.dept_name;


select c1.course_id as course, c1.title as course_title,
       c2.course_id as prerequisite, c2.title as prereq_title
from course as c1
left join prereq on c1.course_id = prereq.course_id
left join course as c2 on prereq.prereq_id = c2.course_id;

select a1.student_id as student1, s1.name as name1,
       a2.student_id as student2, s2.name as name2,
       a1.instructor_id
from advisor as a1
join advisor as a2 on a1.instructor_id = a2.instructor_id and a1.student_id < a2.student_id
join student as s1 on a1.student_id = s1.student_id
join student as s2 on a2.student_id = s2.student_id;


select student.student_id, student.name, course.course_id, course.title, instructor.name as instructor_name
from student
join takes on student.student_id = takes.student_id
join section on takes.course_id = section.course_id
  and takes.sec_id = section.sec_id
  and takes.semester = section.semester
  and takes.year = section.year
join course on section.course_id = course.course_id
join teaches on section.course_id = teaches.course_id
  and section.sec_id = teaches.sec_id
  and section.semester = teaches.semester
  and section.year = teaches.year
join instructor on teaches.instructor_id = instructor.instructor_id;


select title, 
(select max(salary) from instructor) as max 
from course;

select dept_name,
(select count(*) from course) as whole_course
from department;

select dept_name, budget
from department
 where budget > (select avg(budget) from department);

select name,salary from instructor where salary>(select min(salary) from instructor where dept_name='Physics');

select name
from instructor
where instructor_id in (
    select instructor_id
    from teaches
    where course_id in (
        select course_id
        from course
        where dept_name = 'Comp. Sci.'
    )
);

select name
from student
where student_id in (
  select student_id
  from takes
  where course_id in (
    select course_id
    from course
    where credits > 3
  )
);

select name, salary from instructor 
where salary> all
(select salary from instructor 
where dept_name='history');

select avg(capacity) as avgClassroom 
from (
  select distinct classroom.capacity 
  from section 
  join classroom 
    on section.building = classroom.building 
    and section.room_number = classroom.room_number 
  where section.course_id in (
    select course_id 
    from course 
    where dept_name = 'AI Studies'
  ) 
  and section.semester = 'Fall' 
  and section.year = 2023
) as physics_classroom;

select dept_name,
(
  select count(*)
  from instructor i
  where i.dept_name = d.dept_name
    and i.salary > (
      select avg(salary)
      from instructor
    )
) as high_salary_instructors
from department d;

select instructor_id, name, 
coalesce(dept_name, 'No Department') as department
from instructor;


select student_id, name, tot_cred,
case
  when tot_cred >= 90 then 'senior'
  when tot_cred >= 60 then 'junior'
  when tot_cred >= 30 then 'sophomore'
  when tot_cred > 0 then 'freshman'
  else 'no credits'
end as academic_level
from student
order by tot_cred desc;


select getdate() as current_datetime, sysdatetime() as current_datetime2;


select now() as current_datetime;


select date_add('2025-05-10', interval 7 day) as one_week_later;

select date_sub('2025-05-10', interval 2 month) as two_month_earlier;

select date_add('2025-05-10', interval 7 day) as one_week_later;

select date_sub('2025-05-10', interval 2 month) as two_month_earlier;

select timestampdiff(year, '2023-01-15', '2025-05-10') as years_diff;

select 
  year('2025-05-10 14:30:00') as year,
  month('2025-05-10 14:30:00') as month,
  day('2025-05-10 14:30:00') as day;
  
  
  
select name, hire_date 
from employee 
where hire_date between '2023-01-01' and '2024-12-31';

select name, timestampdiff(year, hire_date, '2025-05-10') as years_employed 
from employee;

select name, date_add(hire_date, interval 6 month) as six_month_later 
from employee;

select name, date_format(last_login, '%M %d, %Y %h:%i %p') as formatted_login 
from employee;



