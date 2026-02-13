create database employee_managemnet;
use employee_managemnet;
 CREATE TABLE JobDepartment (
    Job_ID INT PRIMARY KEY,
    jobdept VARCHAR(50),
    name VARCHAR(100),
    description TEXT,
    salaryrange VARCHAR(50));
select *from jobdepartment;


CREATE TABLE SalaryBonus (
    salary_ID INT PRIMARY KEY,
    Job_ID INT,
    amount DECIMAL(10,2),
    annual DECIMAL(10,2),
    bonus DECIMAL(10,2),
    CONSTRAINT fk_salary_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(Job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
select *from Salarybonus;

CREATE TABLE Employee (
    emp_ID INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    contact_add VARCHAR(100),
    emp_email VARCHAR(100) UNIQUE,
    emp_pass VARCHAR(50),
    Job_ID INT,
    CONSTRAINT fk_employee_job FOREIGN KEY (Job_ID)
        REFERENCES JobDepartment(Job_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
select *from Employee;


CREATE TABLE Qualification (
    QualID INT PRIMARY KEY,
    Emp_ID INT,
    Position VARCHAR(50),
    Requirements VARCHAR(255),
    Date_In DATE,
    CONSTRAINT fk_qualification_emp FOREIGN KEY (Emp_ID)
        REFERENCES Employee(emp_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE);
select *from Qualification;

CREATE TABLE Leaves (
    leave_ID INT PRIMARY KEY,
    emp_ID INT,
    date DATE,
    reason TEXT,
    CONSTRAINT fk_leave_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE);
select *from leaves;

CREATE TABLE Payroll (
    payroll_ID INT PRIMARY KEY,
    emp_ID INT,
    job_ID INT,
    salary_ID INT,
    leave_ID INT,
    date DATE,
    report TEXT,
    total_amount DECIMAL(10,2),
    CONSTRAINT fk_payroll_emp FOREIGN KEY (emp_ID) REFERENCES Employee(emp_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_job FOREIGN KEY (job_ID) REFERENCES JobDepartment(job_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_salary FOREIGN KEY (salary_ID) REFERENCES SalaryBonus(salary_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_payroll_leave FOREIGN KEY (leave_ID) REFERENCES Leaves(leave_ID)
        ON DELETE SET NULL ON UPDATE CASCADE
);
select *from payroll;


#Analysis Questions
#1. EMPLOYEE INSIGHTS
#How many unique employees are currently in the system?
select count(distinct(emp_id))  AS COUNT_OF_EMPLOYEES from employee;

#Which departments have the highest number of employees?
select j.jobdept,count(e.emp_id) as total_emp 
from employee as e
join jobdepartment as j 
group by jobdept 
order by total_emp desc;

#What is the average salary per department?
select j.jobdept, avg(s.amount)
from Salarybonus as s
join jobdepartment as j
on j.job_id=s.job_id
group by jobdept;  

#Who are the top 5 highest-paid employees?
select e.firstname , s.amount 
from employee as e
join salarybonus as s
order by s.amount desc
limit 5;
select *from employee;
select*from salarybonus;

#What is the total salary expenditure across the company?
select sum(amount)+sum(bonus) as total_expenditure
from salarybonus;

#2. JOB ROLE AND DEPARTMENT ANALYSIS
#How many different job roles exist in each department?
select jobdept,COUNT(DISTINCT(jobdept)) as no_of_roles
from jobdepartment
group by jobdept;

#What is the average salary range per department?
select jobdept, min(salaryrange) 
from  jobdepartment
group by jobdept;




#Which job roles offer the highest salary?
select j.name,max(s.amount) as highest_salary
from jobdepartment as j 
join salarybonus as s
on j.job_id=s.job_id
group by j.name
order by highest_salary desc
limit 1;


#Which departments have the highest total salary allocation?
select j.name,max(s.amount) as highest_salary
from jobdepartment as j 
join salarybonus as s
on j.job_id=s.job_id
group by j.name
order by highest_salary desc
limit 1;


#3. QUALIFICATION AND SKILLS ANALYSIS
#How many employees have at least one qualification listed?
select q.requirements,sum(e.emp_id)
from employee as e
join qualification as q
on e.emp_id=q.emp_id
group by q.requirements;


#Which positions require the most qualifications?
select position,count(requirements)
from qualification 
group by position; 


#Which employees have the highest number of qualifications?
select e.emp_id,count(q.requirements) 
from employee as e
join qualification as q
on e.emp_id =q.emp_id
group by e.emp_id;

#4. LEAVE AND ABSENCE PATTERNS
#Which year had the most employees taking leaves?
select count(emp_id),extract(year from date) as year_
from leaves 
group by emp_id,year_;
#order by count(emp_id) desc;



#What is the average number of leave days taken by its employees per department?
SELECT t.jobdept,AVG(t.leave_count) AS avg_leave_days
FROM (SELECT e.emp_ID,j.jobdept,COUNT(l.leave_ID) AS leave_count
FROM employee  as e
LEFT JOIN leaves  as l
ON e.emp_ID = l.emp_ID
JOIN jobdepartment as  j
ON e.Job_ID = j.Job_ID
gROUP BY e.emp_ID, j.jobdept) t
GROUP BY t.jobdept;



#Which employees have taken the most leaves?
select emp_id ,count(extract(day from date)) as most_leaves
from leaves 
group by emp_id;

#What is the total number of leave days taken company-wide?
select count(leave_id) as no_of_leaves
from leaves;

#How do leave days correlate with payroll amounts?
SELECT p.emp_id,count(l.leave_id),sUM(p.total_amount) AS total_payroll
FROM payroll as p
left JOIN leaves  as l
ON p.leave_id = l.leave_id
GROUP BY p.emp_id
ORDER BY count(l.leave_id) desc;

#5. PAYROLL AND COMPENSATION ANALYSIS
#What is the total monthly payroll processed?
select*from payroll;
select report as monthly_payroll,sum(total_amount)
from payroll
group by report;

#What is the average bonus given per department?
select j.jobdept,avg(s.bonus)
from salarybonus as s
join jobdepartment as j
on s.job_id=j.job_id
group by jobdept;


#Which department receives the highest total bonuses?
select j.jobdept,sum(s.bonus) as total_bonus
from salarybonus as s
join jobdepartment as j
on s.job_id=j.job_id
group by jobdept
order by total_bonus desc
limit 1;

#What is the average value of total_amount after considering leave deductions?
select*from payroll;
select*from leaves;
select LEAVE_ID,avg(total_amount) as avg_amount
from payroll AS P
GROUP BY LEAVE_ID;












