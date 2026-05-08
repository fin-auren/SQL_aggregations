DROP DATABASE college;

CREATE DATABASE college;

USE college;

CREATE TABLE student (
rollno INT PRIMARY KEY,
name VARCHAR(50),
marks INT NOT NULL,
grade VARCHAR(1),
city VARCHAR(20)
);

INSERT INTO student (rollno, name, marks, grade, city)VALUES
(101,"anil", 78, "C", "PUNE"),
(102,"bhumi",93 , "A", "Varansi"),
(103,"chetan",88 , "B", "Mumbai"),
(104,"dhruv", 96, "A", "Delhi"),
(105,"Emily", 52, "F", "Delhi"),
(106,"Ganesh",60 , "C", "Nagpur");

SELECT name, marks FROM student;


SELECT * FROM student;

SELECT DISTINCT city FROM student;

SELECT * FROM student WHERE marks - 10 >= 80  OR city = "Mumbai";

SELECT * FROM student WHERE marks BETWEEN 80 AND 90;

SELECT * FROM student WHERE city IN ("Mumbai", "Varanasi"); 

SELECT * FROM student WHERE city IN ("Mumbai", "Varanasi") LIMIT 1; 

SELECT * FROM student ORDER BY city ASC;

SELECT * FROM student ORDER BY marks ASC;

SELECT * FROM student ORDER BY marks DESC LIMIT 3;

SELECT city , count(rollno) FROM student GROUP BY city, name;

SELECT city, name , count(rollno) FROM student GROUP BY city, name;

SELECT city, AVG(marks) FROM student GROUP BY city ORDER BY AVG(marks) ASC;



