USE Sejong_Univer;

DELIMITER $$

DROP TRIGGER IF EXISTS trg_before_insert_student $$
CREATE TRIGGER trg_before_insert_student
BEFORE INSERT ON student
FOR EACH ROW
BEGIN
  SET NEW.tot_cred = IFNULL(NEW.tot_cred, 0);
END $$
SELECT * FROM student $$

DROP TRIGGER IF EXISTS trg_after_insert_takes $$
CREATE TRIGGER trg_after_insert_takes
AFTER INSERT ON takes
FOR EACH ROW
BEGIN
  UPDATE student 
  SET tot_cred = tot_cred + (SELECT credits FROM course WHERE course_id = NEW.course_id) 
  WHERE ID = NEW.ID;
END $$
SELECT * FROM takes $$

DROP TRIGGER IF EXISTS trg_after_delete_takes $$
CREATE TRIGGER trg_after_delete_takes
AFTER DELETE ON takes
FOR EACH ROW
BEGIN
  UPDATE student 
  SET tot_cred = tot_cred - (SELECT credits FROM course WHERE course_id = OLD.course_id) 
  WHERE ID = OLD.ID;
END $$
SELECT * FROM takes $$

DROP TRIGGER IF EXISTS trg_before_insert_course $$
CREATE TRIGGER trg_before_insert_course
BEFORE INSERT ON course
FOR EACH ROW
BEGIN
  SET NEW.credits = IFNULL(NEW.credits, 3);
END $$
SELECT * FROM course $$

DROP TRIGGER IF EXISTS trg_after_insert_teaches $$
CREATE TRIGGER trg_after_insert_teaches
AFTER INSERT ON teaches
FOR EACH ROW
BEGIN
  INSERT INTO section(course_id, sec_id, semester, year) 
  VALUES (NEW.course_id, NEW.sec_id, NEW.semester, NEW.year);
END $$
SELECT * FROM teaches $$

DROP TRIGGER IF EXISTS trg_after_update_instructor $$
CREATE TRIGGER trg_after_update_instructor
AFTER UPDATE ON instructor
FOR EACH ROW
BEGIN
  INSERT INTO log_instructor(ID, name, dept_name, salary, action_time) 
  VALUES (OLD.ID, OLD.name, OLD.dept_name, OLD.salary, NOW());
END $$
SELECT * FROM instructor $$

DROP TRIGGER IF EXISTS trg_after_delete_student $$
CREATE TRIGGER trg_after_delete_student
AFTER DELETE ON student
FOR EACH ROW
BEGIN
  DELETE FROM advisor WHERE s_id = OLD.ID;
END $$
SELECT * FROM student $$

DROP TRIGGER IF EXISTS trg_after_insert_prereq $$
CREATE TRIGGER trg_after_insert_prereq
AFTER INSERT ON prereq
FOR EACH ROW
BEGIN
  UPDATE course 
  SET title = CONCAT(title, ' (Prereq)') 
  WHERE course_id = NEW.course_id;
END $$
SELECT * FROM prereq $$

DROP TRIGGER IF EXISTS trg_before_delete_course $$
CREATE TRIGGER trg_before_delete_course
BEFORE DELETE ON course
FOR EACH ROW
BEGIN
  DELETE FROM prereq 
  WHERE course_id = OLD.course_id OR prereq_id = OLD.course_id;
END $$
SELECT * FROM course $$

DROP TRIGGER IF EXISTS trg_after_insert_classroom $$
CREATE TRIGGER trg_after_insert_classroom
AFTER INSERT ON classroom
FOR EACH ROW
BEGIN
  UPDATE department 
  SET budget = budget + 10000 
  WHERE building = NEW.building;
END $$
SELECT * FROM classroom $$

DROP TRIGGER IF EXISTS trg_after_update_department $$
CREATE TRIGGER trg_after_update_department
AFTER UPDATE ON department
FOR EACH ROW
BEGIN
  UPDATE student 
  SET dept_name = NEW.dept_name 
  WHERE dept_name = OLD.dept_name;
END $$
SELECT * FROM department $$

DROP TRIGGER IF EXISTS trg_after_insert_advisor $$
CREATE TRIGGER trg_after_insert_advisor
AFTER INSERT ON advisor
FOR EACH ROW
BEGIN
  INSERT INTO log_advisor(s_id, i_id, action_time) 
  VALUES (NEW.s_id, NEW.i_id, NOW());
END $$
SELECT * FROM advisor $$

DROP TRIGGER IF EXISTS trg_before_insert_instructor $$
CREATE TRIGGER trg_before_insert_instructor
BEFORE INSERT ON instructor
FOR EACH ROW
BEGIN
  SET NEW.salary = IFNULL(NEW.salary, 50000);
END $$
SELECT * FROM instructor $$

DROP TRIGGER IF EXISTS trg_after_insert_time_slot $$
CREATE TRIGGER trg_after_insert_time_slot
AFTER INSERT ON time_slot
FOR EACH ROW
BEGIN
  UPDATE section 
  SET time_slot_id = NEW.time_slot_id 
  WHERE section.time_slot_id IS NULL;
END $$
SELECT * FROM time_slot $$

DROP TRIGGER IF EXISTS trg_after_delete_teaches $$
CREATE TRIGGER trg_after_delete_teaches
AFTER DELETE ON teaches
FOR EACH ROW
BEGIN
  DELETE FROM section 
  WHERE course_id = OLD.course_id AND sec_id = OLD.sec_id AND semester = OLD.semester AND year = OLD.year;
END $$
SELECT * FROM teaches $$

DROP TRIGGER IF EXISTS trg_after_update_student $$
CREATE TRIGGER trg_after_update_student
AFTER UPDATE ON student
FOR EACH ROW
BEGIN
  INSERT INTO student_audit(ID, name, dept_name, tot_cred, updated_on) 
  VALUES (OLD.ID, OLD.name, OLD.dept_name, OLD.tot_cred, NOW());
END $$
SELECT * FROM student $$

DROP TRIGGER IF EXISTS trg_after_delete_instructor $$
CREATE TRIGGER trg_after_delete_instructor
AFTER DELETE ON instructor
FOR EACH ROW
BEGIN
  DELETE FROM advisor 
  WHERE i_id = OLD.ID;
END $$
SELECT * FROM instructor $$

DROP TRIGGER IF EXISTS trg_before_insert_takes_grade_check $$
CREATE TRIGGER trg_before_insert_takes_grade_check
BEFORE INSERT ON takes
FOR EACH ROW
BEGIN
  SET NEW.grade = IFNULL(NEW.grade, 'N');
END $$
SELECT * FROM takes $$

DROP TRIGGER IF EXISTS trg_after_insert_section $$
CREATE TRIGGER trg_after_insert_section
AFTER INSERT ON section
FOR EACH ROW
BEGIN
  UPDATE classroom 
  SET capacity = capacity - 1 
  WHERE building = NEW.building AND room_no = NEW.room_no;
END $$
SELECT * FROM section $$

DROP TRIGGER IF EXISTS trg_after_insert_department $$
CREATE TRIGGER trg_after_insert_department
AFTER INSERT ON department
FOR EACH ROW
BEGIN
  INSERT INTO log_department(dept_name, building, budget, created_on) 
  VALUES (NEW.dept_name, NEW.building, NEW.budget, NOW());
END $$
SELECT * FROM department $$

DROP TRIGGER IF EXISTS trg_before_insert_teaches $$
CREATE TRIGGER trg_before_insert_teaches
BEFORE INSERT ON teaches
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT * FROM teaches 
    WHERE ID = NEW.ID AND course_id = NEW.course_id AND sec_id = NEW.sec_id AND semester = NEW.semester AND year = NEW.year
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate teaching assignment';
  END IF;
END $$
SELECT * FROM teaches $$

DROP TRIGGER IF EXISTS trg_after_delete_course_cleanup $$
CREATE TRIGGER trg_after_delete_course_cleanup
AFTER DELETE ON course
FOR EACH ROW
BEGIN
  DELETE FROM takes 
  WHERE course_id = OLD.course_id;
END $$
SELECT * FROM course $$

DROP TRIGGER IF EXISTS trg_after_update_classroom $$
CREATE TRIGGER trg_after_update_classroom
AFTER UPDATE ON classroom
FOR EACH ROW
BEGIN
  UPDATE section 
  SET building = NEW.building, room_no = NEW.room_no 
  WHERE building = OLD.building AND room_no = OLD.room_no;
END $$
SELECT * FROM classroom $$

DROP TRIGGER IF EXISTS trg_before_insert_section $$
CREATE TRIGGER trg_before_insert_section
BEFORE INSERT ON section
FOR EACH ROW
BEGIN
  IF NOT EXISTS (
    SELECT * FROM classroom 
    WHERE building = NEW.building AND room_no = NEW.room_no
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid classroom';
  END IF;
END $$
SELECT * FROM section $$

DROP TRIGGER IF EXISTS trg_after_delete_advisor $$
CREATE TRIGGER trg_after_delete_advisor
AFTER DELETE ON advisor
FOR EACH ROW
BEGIN
  INSERT INTO advisor_audit(s_id, i_id, deleted_on) 
  VALUES (OLD.s_id, OLD.i_id, NOW());
END $$
SELECT * FROM advisor $$

DELIMITER ;