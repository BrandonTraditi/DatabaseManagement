--Brandon Traditi--
--Database Management Lab 10--
--11/27/17--

--#1--

create or replace function PreReqsFor(int, REFCURSOR) returns refcursor as
$$
declare
   course_num  int       := $1;
   preReqs     REFCURSOR := $2;
begin
   open preReqs for 
      select preReqNum
      from Prerequisites
      where  courseNum = course_num;
   return preReqs;
end;
$$ 
language plpgsql;

--Result 1--


select PreReqsFor(499, 'results1');
Fetch all from results1;




--#2--
create or replace function IsPreReqFor(int, REFCURSOR) returns refcursor as
$$
declare
    course_num    int       := $1;
    isPreReqs       REFCURSOR := $2;
begin
    open isPreReqs for
       select preReqNum
       from Prerequisites
       where preReqNum = course_num;
    return isPreReqs;
end;
$$
language plpgsql;


--Result 2--


select IsPreReqFor(308, 'results2');
Fetch all from results2;




--I'm more of an R2-D2 kinda guy--
