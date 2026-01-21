# hana_hw_2
Q1)Find the Average, Maximum, and Minimum marks obtained in the Day 1 Exam to see how the class performed as a whole.

select 
AVG (total_score) as avg_score, 
MAX (total_score) as max_score,
MIN (total_score) as min_score 
from day_1_exam;

Q2) List the names of MBA students who scored above 35 on Day 2.

select
t1.hall_ticket_no,
t1.total_score,
t2.student_name
from day_2_exam as t1
join day_1_exam as t2 
on t1.hall_ticket_no = t2.hall_ticket_no
where t1.total_score >'35'

Q3)Identify students whose Day 2 score was strictly higher than their Day 1 score.

select
t1.hall_ticket_no,
t1.total_score as day_1,
t2.total_score as day_2,
t2.student_name
from day_2_exam as t1
join day_1_exam as t2 
on t1.hall_ticket_no = t2.hall_ticket_no
where t2.total_score > t1.total_score

Q4)Do passing students work faster? Join day_2_exam with qaday2 to find the average 'Total Time' for students who 'Pass' vs those who 'Fail'.

select 
t1.result_status,
AVG(t2."Total Time") AS avg_total_time
FROM day_2_exam as t1
JOIN qaday2 as t2
ON t1.hall_ticket_no = t2.hall_ticket_no
GROUP BY 1

Q5)Which students have NULLs in Q1 or Q2 but still passed the Day 2 exam? (This helps identify students who skip but are still accurate).

select
t1.hall_ticket_no
FROM day_2_exam as t1
left JOIN qaday2 as t2
ON t1.hall_ticket_no = t2.hall_ticket_no
WHERE t1.result_status = 'Pass'
AND (t2."Q1" IS NULL OR t2."Q2" IS NULL);

Q6)For each department, show the total number of registrations, total students who took Day 1, and total students who took Day 2.

select
r.department_name,
COUNT(DISTINCT r.hall_ticket_no) AS registrations,
COUNT(DISTINCT d1.hall_ticket_no) AS attended_day1,
COUNT(DISTINCT d2.hall_ticket_no) AS attended_day2
FROM "RSVP_New" as r
LEFT JOIN day_1_exam as d1
ON r.hall_ticket_no = d1.hall_ticket_no
LEFT JOIN day_2_exam d2
ON r.hall_ticket_no = d2.hall_ticket_no
GROUP BY r.department_name;

Q7)Using the dob (Date of Birth) in RSVP_New, identify students born before the year 2000 as 'Senior Students' and those born in 2000 or later as 'Junior Students'.

select 
full_name,
dob,
CASE 
WHEN dob < '2000-01-01' THEN 'Senior Student'
ELSE 'Junior Student'
END AS age_group
FROM "RSVP_New";

Q8)Join day_2_exam with qaday2. Create a logic: If 'Total Time' is less than 1000 and 'Result' is 'Pass', label them as 'High Efficiency'. If they passed but took longer, label them as 'Hard Worker'.

select
t1.hall_ticket_no,
t1.result_status,
t2."Total Time" AS "Total Time",
CASE
WHEN t1.result_status = 'Pass' AND t2."Total Time" < 1000 THEN 'High Efficiency'
WHEN t1.result_status = 'Pass' AND t2."Total Time" >= 1000 THEN 'Hard Worker'
ELSE 'Needs Support'
END AS efficiency_rank
FROM day_2_exam as t1
JOIN qaday2 as t2
ON t1.hall_ticket_no = t2.hall_ticket_no;

Q9)If a student finished Question 1 (Q1) in under 15 seconds, they are 'Quick to Fall in Love.' If they took over 60 seconds, they are 'Hard to Get.' If they skipped (NULL), they are 'Focusing on their Career'.

select
hall_ticket_no,
"Q1",
CASE
WHEN "Q1" IS NULL THEN 'Focusing on their Career'
WHEN "Q1" < 15 THEN 'Quick to Fall in Love'
WHEN "Q1"> 60 THEN 'Hard to Get'
ELSE 'Waiting for the Right One'
END AS love_logic
FROM qaday2;

Q10)Get the full details from RSVP_New for the student who got the absolute maximum score on Day 2.(use subquery)

select *
FROM "RSVP_New"
WHERE hall_ticket_no = (SELECT hall_ticket_no
FROM day_2_exam
ORDER BY total_score DESC
LIMIT 1) 

Q11)Who registered for the class before 'AMENAH AHSAN'?(use subquery)

select 
full_name,
created_at
FROM "RSVP_New"
WHERE created_at < (
SELECT created_at
FROM "RSVP_New"
WHERE full_name = 'AMENAH AHSAN'
)
ORDER BY created_at;

Q12)Show the details of students who are among the 5 fastest finishers of the Day 2 exam.

select
r.hall_ticket_no,
r.surname,
r.full_name,
r.contact_no,
r.email,
r.college_name,
r.department_name,
r.dob,
r.created_at
FROM qaday2 q
JOIN "RSVP_New" AS r
ON q.hall_ticket_no = r.hall_ticket_no
ORDER BY q."Total Time" ASC
LIMIT 5;
