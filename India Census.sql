India Census Project

Dataset link - https://www.census2011.co.in/district.php
			   https://www.census2011.co.in/literacy.php

# both dataset are imported

select * from census.census1;
select * from census.census2;

# total no of rows in both datasets

select count(*) from census.census1;
select count(*) from census.census2;

# data only for Bihar and JH

select * from census.census1 where state in ('Jharkhand','Bihar')

#sum of population of india

select sum(population) as population from census.census2

# avg growth in percentage of india

select avg(growth)*100 as avg_growth from census.census1

# avg growth in percentage state wise

select state ,avg(growth)*100 as avg_growth from census.census1 group by state

# avg sex ratio state wise and ordered in desc order according to avg sex ratio

select state , round(avg(sex_ratio) , 0) as avg_sex_ratio from census.census1 group by state order by avg_sex_ratio desc;

# avg literacy state wise and ordered in desc order according to literacy

select state , round(avg(literacy) , 0) as avg_literacy from census.census1 group by state order by avg_literacy desc;

# value less than 90 

select state , round(avg(literacy) , 0) as avg_literacy from census.census1 group by state having round(avg(literacy),0)>90 order by avg_literacy desc;

# top 3 state with highest SR and Avg GR

select state ,avg(growth)*100 as avg_growth from census.census1 group by state order by avg_growth desc limit 3
select state ,avg(sex_ratio )*100 as avg_sex_ratio from census.census1 group by state order by avg_sex_ratio desc limit 3

#joining both tables on district (converting the sexratio which is in int to decimal by dividing it by 1000

select a.district , a.state , a.sex_ratio/1000, b.population from census.census1 a inner join census.census2 b on a.district = b.district order by population desc

#total number of males and females district wise using the above joined table and formula( population/(sex_ratio+1))

select c.district , c.state , round(c.population/(c.sex_ratio+1),0) as males , round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) as females from
 (select a.district , a.state , a.sex_ratio/1000 as sex_ratio, b.population from census.census1 a inner join census.census2 b on a.district = b.district) c

 # total no of males and females state wise
 
select d.state ,sum(d.males) as total_males,sum(d.females) as total_females from 
(select c.district , c.state , round(c.population/(c.sex_ratio+1),0) as males , round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) as females from
 (select a.district , a.state , a.sex_ratio/1000 as sex_ratio, b.population from census.census1 a inner join census.census2 b on a.district = b.district) c ) d 
 group by d.state
 
 # total no of literate and illiterate people in states
 
select c.state,sum(literate_people) as total_literate,sum(illiterate_people) as total_illiterate from 
(select d.district,d.state,round((d.literacy_ratio*d.population),0) literate_people,round((1-d.literacy_ratio)* d.population,0) illiterate_people from
(select a.district,a.state,a.literacy/100 as literacy_ratio,b.population from census.census1 as a 
inner join census.census2 as b on a.district=b.district) d) c
group by c.state

# top 3 district in each state whith high literacy rate

select a.* from
(select district , state , literacy , rank() over(partition by state order by literacy desc) as ranking from census.census1) as a 
where a.ranking in (1,2,3) order by state 
