-- Active: 1694352153144@@127.0.0.1@3306
CREATE DATABASE 
    DEFAULT CHARACTER SET = 'utf8mb4';
Q1   
   SELECT *
FROM CITY
WHERE CountryCode = 'USA' AND Population > 100000;

Q2
  SELECT NAME
FROM CITY
WHERE CountryCode = 'USA' AND Population > 120000;

Q3
  SELECT *
FROM CITY;

Q4
 SELECT *
FROM CITY
WHERE ID = 1661;

Q5
SELECT *
FROM CITY
WHERE CountryCode = 'JPN';

Q6
SELECT NAME
FROM CITY
WHERE CountryCode = 'JPN';

Q7
SELECT CITY, STATE
FROM STATION;

Q8
SELECT DISTINCT CITY
FROM STATION
WHERE MOD(ID, 2) = 0;

Q9
SELECT COUNT(*) - COUNT(DISTINCT CITY) AS Difference
FROM STATION;

Q10
SELECT CITY, LENGTH(CITY) AS Name_Length
FROM STATION
ORDER BY LENGTH(CITY) DESC, CITY
LIMIT 1;

Q11
SELECT DISTINCT CITY
FROM STATION
WHERE CITY REGEXP '^[aeiouAEIOU]';

Q12
SELECT DISTINCT CITY
FROM STATION
WHERE CITY REGEXP '[aeiouAEIOU]$';

Q13
SELECT DISTINCT CITY
FROM STATION
WHERE CITY NOT REGEXP '^[aeiouAEIOU]';

Q14
SELECT DISTINCT CITY
FROM STATION
WHERE CITY NOT REGEXP '[aeiouAEIOU]$';

Q15
SELECT DISTINCT CITY
FROM STATION
WHERE CITY NOT REGEXP '^[aeiouAEIOU]' OR CITY NOT REGEXP '[aeiouAEIOU]$';

Q16
SELECT DISTINCT CITY
FROM STATION
WHERE CITY NOT REGEXP '^[aeiouAEIOU]' AND CITY NOT REGEXP '[aeiouAEIOU]$';

Q17
SELECT p.product_id, p.product_name
FROM Product p
LEFT JOIN Sales s ON p.product_id = s.product_id
WHERE s.sale_date BETWEEN '2019-01-01' AND '2019-03-31'
GROUP BY p.product_id, p.product_name
HAVING COUNT(s.product_id) = 1 OR COUNT(s.product_id) IS NULL;

Q18
SELECT DISTINCT author_id AS id
FROM Views
WHERE author_id = viewer_id
ORDER BY id;

Q19
SELECT ROUND((SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS immediate_percentage
FROM Delivery;

Q20
SELECT ad_id,
       CASE
           WHEN SUM(action = 'Clicked') + SUM(action = 'Viewed') = 0 THEN 0
           ELSE ROUND(SUM(action = 'Clicked') / (SUM(action = 'Clicked') + SUM(action = 'Viewed')) * 100, 2)
       END AS ctr
FROM Ads
WHERE action <> 'Ignored'
GROUP BY ad_id
ORDER BY ctr DESC, ad_id ASC;

Q21
SELECT e.employee_id, COUNT(*) AS team_size
FROM Employee e
JOIN Employee t ON e.team_id = t.team_id
GROUP BY e.employee_id;

Q22
SELECT c.country_name,
       CASE
           WHEN AVG(w.weather_state) <= 15 THEN 'Cold'
           WHEN AVG(w.weather_state) >= 25 THEN 'Hot'
           ELSE 'Warm'
       END AS weather_type
FROM Countries c
LEFT JOIN Weather w ON c.country_id = w.country_id
WHERE w.day BETWEEN '2019-11-01' AND '2019-11-30'
GROUP BY c.country_name;

Q23
SELECT u.product_id,
       ROUND(SUM(p.price * u.units) / SUM(u.units), 2) AS average_price
FROM UnitsSold u
JOIN Prices p
ON u.product_id = p.product_id
AND u.purchase_date >= p.start_date
AND u.purchase_date <= p.end_date
GROUP BY u.product_id;

Q24
SELECT player_id, MIN(event_date) AS first_login
FROM Activity
GROUP BY player_id;

Q25
WITH RankedActivity AS (
    SELECT player_id, device_id, event_date,
           ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY event_date) AS rn
    FROM Activity
)

SELECT player_id, device_id
FROM RankedActivity
WHERE rn = 1;

Q26
SELECT p.product_name, SUM(o.unit) AS unit
FROM Products p
LEFT JOIN Orders o
ON p.product_id = o.product_id
AND o.order_date >= '2020-02-01'
AND o.order_date <= '2020-02-29'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100;

Q27
SELECT user_id, name, mail
FROM Users
WHERE mail REGEXP '^[a-zA-Z][a-zA-Z0-9_.-]*@leetcode\.com$';

Q28
WITH MonthlySpending AS (
    SELECT
        c.customer_id,
        c.name AS customer_name,
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        SUM(p.price * o.quantity) AS total_spending
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    JOIN Product p ON o.product_id = p.product_id
    WHERE DATE_FORMAT(o.order_date, '%Y-%m') IN ('2020-06', '2020-07')
    GROUP BY c.customer_id, month
    HAVING SUM(p.price * o.quantity) >= 100
)

SELECT DISTINCT customer_id, customer_name
FROM MonthlySpending
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT month) = 2;

Q29
SELECT DISTINCT c.title
FROM TVProgram tp
JOIN Content c ON tp.content_id = c.content_id
WHERE tp.program_date >= '2020-06-01' AND tp.program_date < '2020-07-01'
  AND c.Kids_content = 'Y'
  AND c.content_type = 'Movies';

Q30
SELECT q.id, q.year, COALESCE(n.npv, 0) AS npv
FROM Queries q
LEFT JOIN NPV n ON q.id = n.id AND q.year = n.year;

Q31
SELECT
    q.id,
    q.year,
    COALESCE(n.npv, 0) AS npv
FROM
    Queries q
LEFT JOIN
    NPV n
ON
    q.id = n.id AND q.year = n.year;

Q32
SELECT e.name, eu.unique_id
FROM Employees e
LEFT JOIN EmployeeUNI eu
ON e.id = eu.id;

Q33
SELECT u.name, COALESCE(SUM(r.distance), 0) AS travelled_distance
FROM Users u
LEFT JOIN Rides r ON u.id = r.user_id
GROUP BY u.id, u.name
ORDER BY travelled_distance DESC, u.name;

Q34
SELECT
    p.product_name,
    SUM(o.unit) AS amount
FROM
    Products p
JOIN
    Orders o ON p.product_id = o.product_id
WHERE
    o.order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY
    p.product_name
HAVING
    SUM(o.unit) >= 100;

Q35
WITH UserMovieCounts AS (
    SELECT
        u.name AS user_name,
        COUNT(DISTINCT mr.movie_id) AS movie_count
    FROM
        Users u
    LEFT JOIN
        MovieRating mr ON u.user_id = mr.user_id
    GROUP BY
        u.name
),
MovieAvgRatings AS (
    SELECT
        m.title AS movie_title,
        AVG(mr.rating) AS avg_rating
    FROM
        Movies m
    LEFT JOIN
        MovieRating mr ON m.movie_id = mr.movie_id
    WHERE
        mr.created_at BETWEEN '2020-02-01' AND '2020-02-29'
    GROUP BY
        m.title
)
SELECT
    user_name AS results
FROM
    UserMovieCounts
WHERE
    movie_count = (
        SELECT
            MAX(movie_count)
        FROM
            UserMovieCounts

Q36
SELECT
    u.name,
    COALESCE(SUM(r.distance), 0) AS travelled_distance
FROM
    Users u
LEFT JOIN
    Rides r ON u.id = r.user_id
GROUP BY
    u.name
ORDER BY
    travelled_distance DESC, u.name ASC;

Q37
SELECT e.id AS unique_id, e.name
FROM Employees e
LEFT JOIN EmployeeUNI eu ON e.id = eu.id
ORDER BY e.id;

Q38
SELECT s.id, s.name
FROM Students s
LEFT JOIN Departments d ON s.department_id = d.id
WHERE d.id IS NULL;

Q39
WITH DistinctPairs AS (
  SELECT DISTINCT
    CASE WHEN from_id < to_id THEN from_id ELSE to_id END AS person1,
    CASE WHEN from_id < to_id THEN to_id ELSE from_id END AS person2
  FROM Calls
)

SELECT
  dp.person1,
  dp.person2,
  COUNT(*) AS call_count,
  SUM(duration) AS total_duration
FROM DistinctPairs dp
JOIN Calls c ON (dp.person1 = c.from_id AND dp.person2 = c.to_id) OR (dp.person1 = c.to_id AND dp.person2 = c.from_id)
GROUP BY dp.person1, dp.person2;

Q40
WITH ProductSales AS (
  SELECT
    u.product_id,
    p.price,
    u.units
  FROM UnitsSold u
  JOIN Prices p ON u.product_id = p.product_id
    AND u.purchase_date >= p.start_date
    AND u.purchase_date <= p.end_date
)

SELECT
  product_id,
  ROUND(SUM(price * units) / SUM(units), 2) AS average_price
FROM ProductSales
GROUP BY product_id;

Q41
SELECT
    w.name AS warehouse_name,
    SUM(p.Width * p.Length * p.Height * w.units) AS volume
FROM Warehouse w
JOIN Products p ON w.product_id = p.product_id
GROUP BY w.name;

Q42
WITH AppleSales AS (
    SELECT sale_date, SUM(sold_num) AS apple_sold
    FROM Sales
    WHERE fruit = 'apples'
    GROUP BY sale_date
),
OrangeSales AS (
    SELECT sale_date, SUM(sold_num) AS orange_sold
    FROM Sales
    WHERE fruit = 'oranges'
    GROUP BY sale_date
)
SELECT s1.sale_date, COALESCE(apple_sold, 0) - COALESCE(orange_sold, 0) AS diff
FROM (SELECT DISTINCT sale_date FROM Sales) s1
LEFT JOIN AppleSales a ON s1.sale_date = a.sale_date
LEFT JOIN OrangeSales o ON s1.sale_date = o.sale_date
ORDER BY s1.sale_date;

Q43
WITH PlayerFirstLogin AS (
    SELECT
        player_id,
        MIN(event_date) AS first_login_date
    FROM
        Activity
    GROUP BY
        player_id
),
PlayerSecondLogin AS (
    SELECT
        a.player_id
    FROM
        Activity a
    JOIN
        PlayerFirstLogin p ON a.player_id = p.player_id
    WHERE
        a.event_date = DATE_ADD(p.first_login_date, INTERVAL 1 DAY)
)
SELECT
    ROUND(COUNT(DISTINCT psl.player_id) / COUNT(DISTINCT a

Q44

SELECT e1.name
FROM Employee e1
JOIN (
    SELECT managerId, COUNT(*) AS direct_reports
    FROM Employee
    GROUP BY managerId
    HAVING COUNT(*) >= 5
) e2 ON e1.id = e2.managerId;

Q45
SELECT d.dept_name, COUNT(s.student_id) AS student_number
FROM Department d
LEFT JOIN Student s ON d.dept_id = s.dept_id
GROUP BY d.dept_name, d.dept_id
ORDER BY student_number DESC, d.dept_name;

Q46
SELECT DISTINCT c.customer_id
FROM Customer c
LEFT JOIN Product p ON c.product_key = p.product_key
GROUP BY c.customer_id
HAVING COUNT(DISTINCT c.product_key) = (SELECT COUNT(*) FROM Product);

Q47

WITH MaxExperience AS (
    SELECT
        p.project_id,
        MAX(e.experience_years) AS max_experience
    FROM Project p
    JOIN Employee e ON p.employee_id = e.employee_id
    GROUP BY p.project_id
)

SELECT
    p.project_id,
    p.employee_id
FROM Project p
JOIN Employee e ON p.employee_id = e.employee_id
JOIN MaxExperience mx ON p.project_id = mx.project_id
WHERE e.experience_years = mx.max_experience

Q48
SELECT b.book_id, b.name
FROM Books b
LEFT JOIN (
    SELECT book_id, SUM(quantity) AS total_quantity
    FROM Orders
    WHERE dispatch_date >= DATE_SUB('2019-06-23', INTERVAL 1 YEAR)
    GROUP BY book_id
) o ON b.book_id = o.book_id
WHERE o.total_quantity IS NULL OR o.total_quantity < 10
AND DATEDIFF('2019-06-23', b.available_from) >= 30;

Q49
WITH GroupScores AS (
    SELECT
        p.group_id,
        m.first_player AS player_id,
        SUM(CASE WHEN m.first_player = p.player_id THEN m.first_score ELSE m.second_score END) AS total_points
    FROM Players p
    LEFT JOIN Matches m ON p.player_id = m.first_player OR p.player_id = m.second_player
    GROUP BY p.group_id, player_id
)

SELECT g.group_id, 
       CASE
           WHEN g.total_points = MAX(g.total_points) OVER (PARTITION BY g.group_id) THEN MIN(g.player_id) OVER (PARTITION BY g.group_id, g.total_points)
           ELSE g.player_id
       END AS player_id
FROM GroupScores g







