
#Employee table:
#+----+-------+--------+-----------+
#| id | name  | salary | managerId |
#+----+-------+--------+-----------+
#| 1  | Joe   | 70000  | 3         |
#| 2  | Henry | 80000  | 4         |
#| 3  | Sam   | 60000  | Null      |
#| 4  | Max   | 90000  | Null      |
#+----+-------+--------+-----------+
#Output: 
#+----------+
#| Employee |
#+----------+
#| Joe      |
#+----------+
#Explanation: Joe is the only employee who earns more than his manager.
#SELECT e1.name AS Employee
#FROM Employee e1
#JOIN Employee e2 ON e1.managerId = e2.id
#WHERE e1.salary > e2.salary;


SELECT e1.name AS Employee
FROM Employee e1
JOIN Employee e2 ON e1.managerId = e2.id
WHERE e1.salary > e2.salary;
