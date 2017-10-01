--Brandon Traditi--
--Database Management Lab 5--
--10/9/17--




--#1--

SELECT a.city
FROM  agents a,
      orders o
WHERE o.aid = a.aid
  AND o.cid = 'c006' ;
    
--#2--

SELECT DISTINCT ord2.pid
FROM customers c,
     orders ord1 FULL OUTER JOIN orders ord2 ON ord1.aid = ord2.aid
WHERE c.city = 'Beijing'
  AND c.cid  = ord1.cid
ORDER BY ord2.pid DESC;

--#3--

SELECT name
FROM customers
WHERE cid NOT IN ( SELECT cid
                   FROM orders
                 );

--#4--

SELECT c.name
FROM customers c LEFT OUTER JOIN orders o ON c.cid = o.cid
WHERE o.cid is null ;


--#5--

SELECT DISTINCT c.name AS "Customer_Name" , a.name AS "Agent_Name"
FROM customers c, 
     agents a, 
     orders o
WHERE o.cid = c.cid 
  AND o.aid = a.aid
  AND c.city = a.city ;
  
  
--#6--

SELECT c.name AS "Customer_Name" , a.name AS "Agent_Name" , a.city AS "Shared_city"
FROM customers c INNER JOIN agents a ON a.city = c.city ;

--#7--

SELECT name, city
FROM customers
WHERE city IN ( SELECT city
                FROM products
                GROUP BY city
                ORDER BY COUNT(*) ASC 
                LIMIT 1
              );