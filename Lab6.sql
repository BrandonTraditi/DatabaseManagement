--Brandon Traditi--
--DataBase Management Lab 6--
--10/16/17--



--#1--

SELECT name, city
FROM customers
WHERE city IN ( SELECT city
                FROM products
                GROUP BY city
                ORDER BY count(*) DESC
                LIMIT 1 
              );

--#2--

SELECT name
FROM products
WHERE priceUSD > ( SELECT AVG(priceUSD)
                   FROM products
                 )
ORDER BY name DESC ;

--#3--

SELECT c1.name, c2.cid, o.pid, SUM(totalUSD) AS totalUSD
FROM Customers c1, Customers c2, Orders o
WHERE c1.cid = c2.cid
  AND c2.cid = o.cid
GROUP BY c1.name, c2.cid, o.pid
ORDER BY totalUSD ASC ;

--#4--

SELECT c.name, COALESCE(sum(totalUSD), '0.00') AS sumTotalUSD
FROM Customers c LEFT OUTER JOIN Orders o ON c.cid = o.cid
GROUP BY o.cid, c.name
ORDER BY c.name DESC;


--#5--

SELECT c.name AS "Customer", p.name AS "Product", a.name AS "Agent"
FROM Customers c, Agents a, Products p, Orders o
WHERE a.city = 'Newark'
  AND o.cid  = c.cid
  AND o.aid  = a.aid
  AND o.pid  = p.pid ;			


--#6--

DROP VIEW IF EXISTS checkDollars ;
CREATE VIEW checkDollars
AS
SELECT o.ordno, c.discountPct, p.priceUSD, o.quantity, 
       ((o.quantity * p.priceUSD) - (o.quantity * p.priceUSD * (c.discountPct/100))) AS viewCheckDollars_totalUSD
FROM Customers c, Orders o, Products p
WHERE o.cid = c.cid
  AND o.pid = p.pid ;

SELECT o.*, v.viewCheckDollars_totalUSD AS "CorrectTotalUSD" 
FROM Orders o, checkDollars v -- v represents the view
WHERE v.ordno = o.ordno
  AND v.viewCheckDollars_totalUSD != o.totalUSD ;
  
  -- had working but then I changed something and not sure of the error--

--#7--

/*
When establishing an Outer Join with either a left or right side
you declare one to be a strong side. When you declare that strong side, 
the return of the query will be all of the strong side rows and
only the rows that matches on the weak side. Ex) if we declared a Right
Outer join, then all the rows in the table to the right would be displayed 
and only the matches to these rows from the left. An example of an Outer Join 
could be to determine if a customer hasn't placed an order.

SELECT customer.cid
FROM customer LEFT OUTER JOIN orders on orders.cid = customer.cid
WHERE ordno IS NULL;

*/























