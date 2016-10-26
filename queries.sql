-- Find all time entries
SELECT * FROM time_entries;
-- returned 500 rows


-- Find the developer who joined most recently.
SELECT * FROM developers
ORDER BY joined_on
LIMIT 1;
result: "4"	"Kellen Brown PhD"	"gabrielle@becker.org"	"2012-10-18"	"2015-07-14 16:15:18.510722"	"2015-07-14 16:15:18.510722"

-- Find the number of projects for each client.
SELECT c.name, count(p.id)
FROM clients c
LEFT JOIN projects p ON p.client_id = c.id
GROUP BY c.id;
-- returned 12 rows

-- Find all time entries, and show each one's client name next to it.
SELECT t.*, c.name
FROM time_entries t
LEFT JOIN projects p ON t.project_id = p.id
LEFT JOIN clients c ON p.client_id = c.id;
-- returned 500 rows

-- Find all developers in the "Ohio sheep" group.
SELECT d.*
FROM developers d
LEFT JOIN group_assignments ga ON d.id = ga.developer_id
LEFT JOIN groups g ON ga.group_id = g.id
WHERE g.name = "Ohio sheep";
-- returned 3 rows

-- Find the total number of hours worked for each client.
SELECT c.*, SUM(t.duration)
FROM time_entries t
LEFT JOIN projects p ON t.project_id = p.id
LEFT JOIN clients c ON p.client_id = c.id
GROUP BY c.id;
-- returns 9 rows

-- Find the client for whom Mrs. Lupe Schowalter (the developer) has worked the greatest number of hours.
SELECT d.name, c.*, c.id, SUM(t.duration) as sum
FROM developers d
LEFT JOIN time_entries t ON d.id = t.developer_id
LEFT JOIN projects p ON t.project_id = p.id
LEFT JOIN clients c ON p.client_id = c.id
WHERE d.name = 'Mrs. Lupe Schowalter'
GROUP BY c.id
ORDER BY sum DESC
LIMIT 1;
-- "Mrs. Lupe Schowalter"	"9"	"Kuhic-Bartoletti"	"Beauty"	"2015-07-14 16:15:18.379047"	"2015-07-14 16:15:18.379047"	"9"	"11"

-- List all client names with their project names (multiple rows for one client is fine). Make sure that clients still show up even if they have no projects.
SELECT c.name as client_name, p.name as project_name
FROM clients c
LEFT JOIN projects p ON c.id = p.client_id;
-- 33 rows

-- Find all developers who have written no comments.
SELECT d.*, c.id
FROM developers d
LEFT JOIN comments c ON d.id = c.developer_id
WHERE c.id IS NULL;
-- 13 rows

-- Find all developers with at least five comments.
SELECT d.id, d.name, COUNT(c.id) as count
FROM developers d
LEFT JOIN comments c ON c.developer_id = d.id
GROUP BY d.id
HAVING count >= 5;
-- 1 row, Joelle Hermann, exactly 5 comments

-- Find the developer who worked the fewest hours in January of 2015.
SELECT d.id, d.name, SUM(t.duration)
FROM developers d
LEFT JOIN time_entries t ON d.id = t.developer_id
WHERE t.worked_on >= '2015-01-01' AND t.worked_on <= '2015-01-31'
GROUP BY d.id
ORDER BY SUM(t.duration) asc
LIMIT 1;
-- Ms. Tremayne Kuhn, 0 hours

-- Find all time entries which were created by developers who were not assigned to that time entry's project.
SELECT t.*, d.name, t.duration, t.developer_id, pa.developer_id, t.project_id, pa.project_id
FROM time_entries t
LEFT JOIN developers d ON t.developer_id = d.id
LEFT JOIN project_assignments pa ON t.developer_id = pa.developer_id AND t.project_id = pa.project_id
WHERE pa.project_id IS NULL;
-- 481 rows

-- Find all developers with no time put towards at least one of their assigned projects.
SELECT d.*, pa.project_id, SUM(t.duration)
FROM developers d
LEFT JOIN project_assignments pa ON d.id = pa.developer_id
LEFT JOIN time_entries t ON t.developer_id = pa.developer_id AND t.project_id = pa.project_id
GROUP BY d.id, pa.project_id
HAVING (SUM(t.duration) IS NULL OR SUM(t.duration) = 0);
-- 36 rows

-- Find all pairs of developers who are in two or more different groups together
SELECT d.name as dev_one, d2.name as dev_two, COUNT(*)
FROM developers d
LEFT JOIN group_assignments ga ON d.id = ga.developer_id
LEFT JOIN group_assignments ga2 ON ga.group_id = ga2.group_id AND ga2.developer_id <> d.id and ga.developer_id < ga2.developer_id
LEFT JOIN developers d2 ON ga2.developer_id = d2.id
GROUP BY d.id, d2.id
HAVING COUNT(*) >= 2;
-- Amy Dickinson and Rashad Kohler were the only pair

-- For all clients, find the duration of the time entry which was entered most recently for that particular client.
select sq.name, t.duration
from
	(SELECT c.name, c.id as client_id, MAX(t.created_at) as most_recent_time
	FROM clients c
	LEFT JOIN projects p ON c.id = p.client_id
	LEFT JOIN time_entries t ON p.id = t.project_id
	GROUP BY c.id
	) as sq
JOIN projects p ON sq.client_id = p.client_id
JOIN time_entries t ON t.project_id = p.id and t.created_at = sq.most_recent_time;
-- 11 rows returned
