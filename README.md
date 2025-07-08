Database: Sejong_Univer

This script demonstrates a variety of SQL operations on the Sejong_Univer schema, including SELECT, UPDATE, INSERT, DELETE, aggregate functions, and different types of joins.

Key Operations Performed

1. Basic Retrieval and Updates
	•	Retrieve instructors in the Physics department and double their salaries.
	•	Retrieve and update classroom capacity for specific rooms.
	•	Update a student’s total credits by half based on specific criteria.

2. Schema Inspection
	•	View the structure of the student table.
	•	Display all data from the course table.

3. Record Deletion
	•	Remove a course with ID 'BIO-399' after verifying its data.

4. Conditional Updates
	•	Update time slot ID for a specific section.
	•	Insert a new instructor and assign a department if missing.
	•	Update high-salary instructors and rename a specific student.

5. Aggregation and Grouping
	•	Count total classrooms and unique buildings.
	•	Calculate total and average budgets.
	•	Determine minimum and maximum values from various tables.
	•	Compute department-wise total and minimum salaries.

6. Joins
	•	Perform INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN between course and department.
	•	Retrieve detailed room allocation from section and classroom.
	•	Fetch course prerequisites.
	•	Match students with the same advisor.
	•	Retrieve full course enrollment details including student and instructor info.

Execution Notes
	•	Ensure the schema Sejong_Univer is properly loaded.
	•	Run each statement in order to verify successful data manipulation.
	•	Intended for academic purposes and practice in relational database concepts.
