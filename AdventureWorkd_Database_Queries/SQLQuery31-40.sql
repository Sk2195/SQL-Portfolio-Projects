USE AdventureWorks2019


 /* 
 Question 31:
Ken Sánchez, the CEO of AdventureWorks, has recently changed his email address.

a. What is Ken's current email address?

b. Update his email address to 'Ken.Sánchez@adventure-works.com' */

--a--
SELECT
      CONCAT(p.FirstName, ' ' , p.LastName) as Full_Name,
	  p.BusinessEntityID,
	  ea.EmailAddress
FROM Person.Person p 
INNER JOIN Person.EmailAddress ea ON ea.BusinessEntityID = p.BusinessEntityID
WHERE
     CONCAT(p.FirstName, ' ', p.LastName) = 'Ken Sánchez' 

SELECT
      ea.EmailAddress -- 'ken0@adventure-works.com
From Person.Person p 
	Inner Join HumanResources.Employee e on e.BusinessEntityID = p.BusinessEntityID
	Inner Join Person.EmailAddress ea on ea.BusinessEntityID = p.BusinessEntityID
Where p.FirstName ='Ken'
	and p.LastName = 'Sánchez'
 

--b--
UPDATE Person.EmailAddress
SET EmailAddress = 'Ken.Sánchez@adventure-works.com'
WHERE BusinessEntityID = 1
      

--32-
/*Question 32:
As we learned in Question 31 there are two individuals in the AdventureWorks Database named Ken Sánchez. One is the CEO of the Company the other is a retail customer. Lets assume for this question that you used the following script to update the email address:

        Update Person.EmailAddress
	Set EmailAddress = 'Ken.Sánchez@adventure-works.com'
	Where p.FirstName ='Ken'
	  and p.LastName = 'Sánchez'
The script above is not correct and would update both records. One of which is not the Ken Sánchez we are wanting to update. In this question we are going to set Ken's (the CEO) email back to the original email (assuming it has been updated from question 31). Then we are going to use BEGIN TRANSACTION, ROLLBACK, and COMMIT to fix/correct a mistake.



a. Update Ken's Email Address to the orginial address using the script below:

        Update Person.EmailAddress
	Set EmailAddress = 'ken0@adventure-works.com'
	Where BusinessEntityID = 1
b. Check the number of open transactions by running: Select @@TranCount

c. Start the transaction with the BEGIN TRAN statement. You can use BEGIN TRANSACTION or BEGIN TRAN. Then check the number of open transactions again.

d. Run our incorrect update statement

        Update Person.EmailAddress
	Set EmailAddress = 'Ken.Sánchez@adventure-works.com'
	From Person.EmailAddress ea
	    Inner Join Person.Person p on p.BusinessEntityID = ea.BusinessEntityID
	Where p.FirstName ='Ken'
	  and p.LastName = 'Sánchez'
e. Correct the mistake/error by running the ROLLBACK statement

f. Check to see if the mistake has been fixed.

g. Start the transaction, run the correct update statement, COMMIT the transaction

h. Question 33 we will automate whether the Transaction commits or rollsback. */

---a--
UPDATE Person.EmailAddress 
SET EmailAddress = 'ken0@adventure-works.com'
WHERE BusinessEntityID = 1


--b-
SELECT @@TRANCOUNT as OpenTransactions


--c--
Update Person.EmailAddress 
SET EmailAddress =  'Ken.Sánchez@adventure-works.com'
FROM Person.EmailAddress ea 
INNER JOIN Person.Person p on p.BusinessEntityID = ea.BusinessEntityID
WHERE p.FirstName ='Ken' and p.LastName = 'Sánchez';

--d--
ROLLBACK

--f--
SELECT*
FROM Person.EmailAddress
Where EmailAddress = 'Ken.Sánchez@adventure-works.com'


--g
BEGIN TRAN

Update Person.EmailAddress
SET EmailAddress = 'Ken.Sánchez@adventure-works.com'
WHERE BusinessEntityID = 1


COMMIT
 
--33-
/* 
Question 33:
Complete questions 31 and 32 before attempting this question.



Before starting this question be sure the email address for both Ken Sánchez's are updated to their original emails. Run the statements below to be sure:

        Update Person.EmailAddress
	Set EmailAddress = 'ken0@adventure-works.com'
	Where BusinessEntityID = 1
 
	Update Person.EmailAddress
	Set EmailAddress = 'ken3@adventure-works.com'
	Where BusinessEntityID = 1726


In Question 32 we used BEGIN TRAN, ROLLBACK, and COMMIT to be sure that our updates work properly. Write a script that will commit if the update is correct. If the update is not correct then rollback. For example, If we know how many rows need to be updated then we can use a @@ROWCOUNT and if that number doesn't meet the condition then rollsback. If it does meet the condition then it commits.



Use the same update statement used in Question 32 (see below):

        Update Person.EmailAddress
	Set EmailAddress = 'Ken.Sánchez@adventure-works.com'
	Where BusinessEntityID = 1 


**There are many ways to accomplish this. Again, find a solution that works for you.** */

BEGIN TRAN
     Update Person.EmailAddress 
	 SET EmailAddress = 'Ken.Sánchez@adventure-works.com'
	 WHERE BusinessEntityID =1

	 IF @@ROWCOUNT = 1
	 COMMIT
	 ELSE 
	 ROLLBACK

--34--
/*Question 34:
a. Using the RANK function rank the employees in the Employee table by the hiredate. Label the column as 'Seniority'

b. Assuming Today is March 3, 2014, add 3 columns for the number of days, months, and years the employee has been employed. */

--a--
SELECT
      RANK() OVER (ORDER BY HireDate ASC) as 'Seniority',
	  *
FROM HumanResources.Employee
      
--b--
SELECT
      RANK() OVER (ORDER BY HireDate ASC) as 'Seniority',
	  DATEDIFF(Day, HireDate, '2014-03-03') as 'DaysEmployed',
	  DATEDIFF(Month, HireDate, '2014-03-03') as 'MonthsEmployed',
	  DATEDIFF(Year, HireDate, '2014-03-03') as 'YearsEmployed',
	 *
FROM HumanResources.Employee
      


Declare @CurrentDate date = '2014-03-03'
 
Select 
	Rank() Over(Order by Hiredate asc) as 'Seniority'
	,DATEDIFF(Day,HireDate,@CurrentDate) as 'DaysEmployed'
	,DATEDIFF(Month,HireDate,@CurrentDate) as 'MonthsEmployed'
	,DATEDIFF(Year,HireDate,@CurrentDate) as 'YearsEmployed'
	,* 
from HumanResources.Employee

--35--
/* a. Using a Select Into Statement put this table into a Temporary Table. Name the table '#Temp1'

b. Run this statement:

Select * 
From #Temp1
Where BusinessEntityID in ('288','286')
Notice that these two Employees have worked for AdventureWorks for 10 months; however, the YearsEmployed says "1." The DateDiff Function I used in our statement above does simple math:(2014 - 2013 = 1). Update the YearsEmployed to "0" for these two Employees.

c. Using the Temp table, how many employees have worked for AdventureWorks over 5 years and 6 months?

d. Create a YearsEmployed Grouping like below:

Employed Less Than 1 Year

Employed 1-3 Years

Employed 4-6

Employed Over 6 Years

Show a count of Employees in each group



d. Show the average VacationHours and SickLeaveHours by the YearsEmployed Group. Which Group has the highest average Vacation and SickLeave Hours? */


--a--
Select 
	Rank() Over (Order by Hiredate asc) as 'Seniority'
	,DATEDIFF(Day,HireDate,'2014-03-03') as 'DaysEmployed'
	,DATEDIFF(Month,HireDate,'2014-03-03') as 'MonthsEmployed'
	,DATEDIFF(Year,HireDate,'2014-03-03') as 'YearsEmployed'
	,* 
Into #Temp1
From HumanResources.Employee

--b--
SELECT *
FROM #Temp1
WHERE BusinessEntityID IN ('288', '286')

--c--
Update #Temp1
SET YearsEmployed = 0
WHERE BusinessEntityID IN ('288', '286')

--36--
/* 
Question 36:
AdventureWorks leadership has asked you to put together a report. Follow the steps below to build the report.

a. Pull a distinct list of every region. Use the SalesTerritory as the region.

b. Add the Sum(TotalDue) to the list of regions

c. Add each customer name. Concatenate First and Last Names

d. Using ROW_NUMBER and a partition rank each customer by region. For example, Australia is a region and we want to rank each customer by the Sum(TotalDue).  */

--a--
SELECT 
     DISTINCT st.Name AS SalesTerritory
FROM Sales.SalesTerritory st

--b--
SELECT
     DISTINCT st.Name as SalesTerritory,
	 FORMAT(SUM(soh.TotalDue), 'C', 'en-us') as RegionTotal
FROM Sales.SalesTerritory st
INNER JOIN Sales.SalesOrderHeader soh ON soh.TerritoryID = st. TerritoryID
GROUP BY st.Name
ORDER BY 2 DESC;

--c--
Select 
	distinct st.Name as RegionName
	,Concat(p.FirstName,' ',p.LastName) as CustomerName
	,Format(Sum(TotalDue),'C0') as TotalDue
From Sales.SalesTerritory st
	Inner Join Sales.SalesOrderHeader soh on soh.TerritoryID = st.TerritoryID
	Inner Join Sales.Customer c on c.CustomerID = soh.CustomerID
	Inner Join Person.Person p on p.BusinessEntityID = c.PersonID
Group by 
	st.Name
	,Concat(p.FirstName,' ',p.LastName) 

--37-
/* 
Question 37:
Complete Question 36 before attempting this question.

In Question 36 the leadership team asked you to build a report. Based on those results the leadership team has decided to start a loyalty program and gift the top 25 customers (in terms of totaldue/sales) a free loyalty membership.

Below is the script we wrote in question 36:

Select 
	distinct st.Name as RegionName
	,Concat(p.FirstName,' ',p.LastName) as CustomerName
	,Format(Sum(TotalDue),'C0') as TotalDue
	,ROW_NUMBER() Over(Partition by st.Name Order by Sum(TotalDue) desc) as RowNum
From Sales.SalesTerritory st
	Inner Join Sales.SalesOrderHeader soh on soh.TerritoryID = st.TerritoryID
	Inner Join Sales.Customer c on c.CustomerID = soh.CustomerID
	Inner Join Person.Person p on p.BusinessEntityID = c.PersonID
Group by 
	st.Name
	,Concat(p.FirstName,' ',p.LastName) 
a. Limit the results in question 36 to only show the top 25 customers in  each region. There are 10 regions so you should have 250 rows.

b. What is the average TotalDue per Region? Leave the top 25 filter */



Hint:
--a. 
WITH customer_table AS (Select * 
From (	
	Select 
		distinct st.Name as RegionName
		,Concat(p.FirstName,' ',p.LastName) as CustomerName
		,Sum(TotalDue) as TotalDue
		,ROW_NUMBER() Over(Partition by st.Name Order by Sum(TotalDue) desc) as RowNum
	From Sales.SalesTerritory st
		Inner Join Sales.SalesOrderHeader soh on soh.TerritoryID = st.TerritoryID
		Inner Join Sales.Customer c on c.CustomerID = soh.CustomerID
		Inner Join Person.Person p on p.BusinessEntityID = c.PersonID
	Group by 
		st.Name
		,Concat(p.FirstName,' ',p.LastName))a
Where RowNum <= 25 )

SELECT
      RegionName,
	  FORMAT(AVG(TotalDue), 'C0') as AvgTotalDue,
	  AVG(TotalDue) as Sort
FROM customer_table
Group by 
	RegionName
Order by 3 desc
 
 
--b.
Select 
	RegionName
	,Format(AVG(TotalDue),'C0') as AvgTotalDue
	,AVG(TotalDue) as Sort
From (	
	Select 
		distinct st.Name as RegionName
		,Concat(p.FirstName,' ',p.LastName) as CustomerName
		,Sum(TotalDue) as TotalDue
		,ROW_NUMBER() Over(Partition by st.Name Order by Sum(TotalDue) desc) as RowNum
	From Sales.SalesTerritory st
		Inner Join Sales.SalesOrderHeader soh on soh.TerritoryID = st.TerritoryID
		Inner Join Sales.Customer c on c.CustomerID = soh.CustomerID
		Inner Join Person.Person p on p.BusinessEntityID = c.PersonID
	Group by 
		st.Name
		,Concat(p.FirstName,' ',p.LastName))a
Group by 
	RegionName
Order by 3 desc

--38--

SELECT 
     FORMAT(SUM(Freight), 'C0') as Total_Freight
FROM Sales.SalesOrderHeader
     
--b--
SELECT 
     YEAR(ShipDate) AS ShipYear,
     FORMAT(SUM(Freight), 'C0') as Total_Freight
FROM Sales.SalesOrderHeader
GROUP BY Year(ShipDate)

--c--

Select 
	Year(ShipDate) as ShipYear
	,Format(Sum(Freight),'C0') as TotalFreight
	,Format(Avg(Freight),'C0') as AvgFreight 
From Sales.SalesOrderHeader
Group by Year(ShipDate)
ORDER BY 1 ASC
 

 --d--
Select 
	ShipYear
	,Format(TotalFreight,'C0') as TotalFreight
	,Format(AvgFreight,'C0') as AvgFreight
	,Format(Sum(TotalFreight) Over (Order by ShipYear),'C0') as RunningTotal
From(
	Select 
		Year(ShipDate) as ShipYear
		,Sum(Freight) as TotalFreight
		,Avg(Freight) as AvgFreight 
	From Sales.SalesOrderHeader
	Group by 
		Year(ShipDate))a
--

--39--
/*Question 39
In Question 38 we did some simple analysis on Freight costs by year. However, the TotalFreight value could be skewed by incomplete years. Take the script written in Question 38 (see below) and answer the following questions.



Select 
	ShipYear
	,Format(TotalFreight,'C0') as TotalFreight
	,Format(AvgFreight,'C0') as AvgFreight
	,Format(Sum(TotalFreight) Over (Order by ShipYear),'C0') as RunningTotal
From(
	Select 
		Year(ShipDate) as ShipYear
		,Sum(Freight) as TotalFreight
		,Avg(Freight) as AvgFreight 
	From Sales.SalesOrderHeader
	Group by 
		Year(ShipDate))a


a. How many months were completed in each Year. Obviously    a full year has 12 months, but some of these years

   could be partial. Leave all of the columns, just add the count of completed months in each Year.

b. Calculate the average Total Freight by completed month */

WITH YearlyFreight AS (
    SELECT 
        YEAR(ShipDate) AS ShipYear,
        SUM(Freight) AS TotalFreight,
        AVG(Freight) AS AvgFreight,
        COUNT(DISTINCT MONTH(ShipDate)) AS CompletedMonths -- Count of unique months per year
    FROM 
        Sales.SalesOrderHeader
    GROUP BY 
        YEAR(ShipDate)
),
FreightWithRunningTotal AS (
    SELECT 
        ShipYear,
        TotalFreight,
        AvgFreight,
        CompletedMonths,
        SUM(TotalFreight) OVER (ORDER BY ShipYear) AS RunningTotal -- Calculate running total
    FROM YearlyFreight
)
SELECT 
    ShipYear,
    FORMAT(TotalFreight, 'C0') AS TotalFreight,
    FORMAT(AvgFreight, 'C0') AS AvgFreight,
    FORMAT(RunningTotal, 'C0') AS RunningTotal,
    CompletedMonths,
    FORMAT(TotalFreight / NULLIF(CompletedMonths, 0), 'C0') AS AvgFreightPerCompletedMonth -- Average total freight by completed month
FROM 
    FreightWithRunningTotal
ORDER BY 
    ShipYear;

/* Question 40
In Question 38 and 39 we analyzed the Freight costs by Year.

In Question 39 we adjusted some of those calculations by accounting for incomplete years. In this question we are going to analyze freight costs at the Monthly level.

a. Start by writing a query that shows freight costs by Month (use ShipDate). Be sure to include year. Include two Month columns one where month is 1-12 and another with the full month written out (i.e. January)

b. Add an average

c. Add a cumulative sum start with June 2011 and go to July 2014. July 2014 should reconile to the Freight in

   totality ($3,183,430)

d. Add a yearly cumulative Sum, which means every January will start over.

Hint:
a. Use the DateName function

c. Use the Over clause and an Inner Query (subquery)

d. Add a partition to the Over Clause */

Select 
	Year(ShipDate) as ShipYear
	,Month(ShipDate) as ShipMonth
	,DateName(month,ShipDate) as 'MonthName'
	,Format(Sum(Freight),'C0') as TotalFreight 
From Sales.SalesOrderHeader
Group by 
	Year(ShipDate)
	,Month(ShipDate)
	,DateName(month,ShipDate)
Order by 1, 2 asc
 
--b. 
Select 
	Year(ShipDate) as ShipYear
	,Month(ShipDate) as ShipMonth
	,DateName(month,ShipDate) as 'MonthName'
	,Format(Sum(Freight),'C0') as TotalFreight 
	,Format(Avg(Freight),'C0') as AvgFreight
From Sales.SalesOrderHeader
Group by 
	Year(ShipDate)
	,Month(ShipDate)
	,DateName(month,ShipDate)
Order by 1, 2 asc
 
--c. 
Select * 
	,Format(Sum(TotalFreight) Over (Order by ShipYear,ShipMonth),'C0') as RunningTotal
From(
    Select 
	Year(ShipDate) as ShipYear
	,Month(ShipDate) as ShipMonth
	,DateName(month,ShipDate) as 'MonthName'
	,Sum(Freight) as TotalFreight 
	,Avg(Freight) as AvgFreight
    From Sales.SalesOrderHeader
    Group by 
    	Year(ShipDate)
	,Month(ShipDate)
	,DateName(month,ShipDate))a
 
--d. 
Select * 
    ,Format(Sum(TotalFreight) Over (Order by ShipYear,ShipMonth),'C0') as RunningTotal
    ,Format(Sum(TotalFreight) Over (Partition by ShipYear 
    Order by ShipYear,ShipMonth),'C0') as YTDRunningTotal
From(
    Select 
	Year(ShipDate) as ShipYear
	,Month(ShipDate) as ShipMonth
	,DateName(month,ShipDate) as 'MonthName'
	,Sum(Freight) as TotalFreight 
	,Avg(Freight) as AvgFreight
    From Sales.SalesOrderHeader
    Group by 
	Year(ShipDate)
	,Month(ShipDate)
	,DateName(month,ShipDate))a