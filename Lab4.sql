--Brandon Traditi--
--DataBase Management Lab 4--
--10/2/17--



--#1--

SELECT distinct city
FROM agents
WHERE aid IN ( SELECT aid
               FROM orders
               WHERE cid = 'c006'
             );

--#2--

SELECT distinct pid
FROM orders
WHERE aid IN ( SELECT aid
               FROM orders
               WHERE cid in ( SELECT cid
                              FROM customers
                              WHERE city = 'Beijing'
                            ) 
             )
ORDER BY pid DESC ;

--#3--

SELECT cid, name
FROM customers
WHERE cid IN ( SELECT cid
               FROM orders
               WHERE aid != 'a03'
             );
			 
--Not sure why I couldnt get this to work--

--#4--

SELECT distinct cid
FROM orders
WHERE pid='p01'
  AND cid IN ( SELECT cid
               FROM orders
               WHERE pid = 'p07'
             );

--#5--

SELECT distinct pid
FROM orders
WHERE aid NOT IN ( SELECT aid
					FROM orders
					WHERE aid = 'a02' OR aid = 'a03' )
ORDER BY pid DESC;					


--#6--

SELECT name, discountPct , city
FROM customers
WHERE cid IN ( SELECT cid
               FROM orders
               WHERE aid IN ( SELECT aid
                              FROM agents
                              WHERE city IN ( 'Tokyo' , 'New York' )
                            ) 
             );

--#7--

SELECT name
FROM customers
WHERE city NOT IN ( 'Duluth' , 'London' ) 
  AND discountPct IN ( SELECT discountPct
                    FROM customers
                    WHERE city IN ( 'Duluth' , 'London' )
                  );

-- STILL DO THE KAST OSRT




