---Brandon Traditi---
---Database MAnagement Lab 3----
---9/18/17---

---#1---
select ordno, totalUSD
from orders;
---#2---
select name, city
from Agents
where name = 'Smith';
---#3---
select pid, name, priceUSD
from Products
where qty > 200010;
---#4---
select name, city
from Customers
where city = 'Duluth';
---#5---
select name
from Agents
where city !='Dulutch' and city != 'New York';
---#6---
select * 
from Products
where city != 'Dallas' and city !='Duluth' and priceUSD >= 1;
---#7---
select *
from Orders
where month = 'Mar' or month = 'May';
---#8---
select *
from Orders
where month = 'Feb' and totalUSD >= '500';
---#9---
select *
from Orders 
where cid = 'c005';

