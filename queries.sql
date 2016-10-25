-- Find all time entries
SELECT * FROM time_entries
-- returned 500 rows


-- Find the developer who joined most recently.
SELECT * FROM developers
ORDER BY created_at
LIMIT 1
result: "50"	"Mr. Leopold Carter"	"bart.smith@reichert.name"	"2015-01-31"	"2015-07-14 16:15:19.600858"	"2015-07-14 16:15:19.600858"

-- Find the number of projects for each client.
SELECT c.name, count(*)
FROM projects p
LEFT JOIN clients c ON p.client_id = c.id
GROUP BY c.name
-- returned 9 rows

-- Find all time entries, and show each one's client name next to it.
SELECT t.*, c.name
FROM time_entries t
LEFT JOIN projects p ON t.project_id = p.id
LEFT JOIN clients c ON p.client_id = c.id
-- returned 500 rows

-- Find all developers in the "Ohio sheep" group.
SELECT d.name
FROM developers d
LEFT JOIN group_assignments ga ON d.id = ga.developer_id
LEFT JOIN groups g ON ga.group_id = g.id
WHERE g.name = "Ohio sheep"
-- returned 3 rows

-- Find the total number of hours worked for each client.
SELECT c.name, SUM(t.duration)
FROM time_entries t
LEFT JOIN projects p ON t.project_id = p.id
LEFT JOIN clients c ON p.client_id = c.id
GROUP BY c.name
-- returns 9 rows

-- Find the client for whom Mrs. Lupe Schowalter (the developer) has worked the greatest number of hours.
SELECT d.name, c.name, SUM(t.duration)
FROM developers d
LEFT JOIN time_entries t ON d.id = t.developer_id
LEFT JOIN projects p ON t.project_id = p.id
LEFT JOIN clients c ON p.client_id = c.id
WHERE d.name = 'Mrs. Lupe Schowalter'
GROUP BY c.name
-- Kuhic-Bartoletti
