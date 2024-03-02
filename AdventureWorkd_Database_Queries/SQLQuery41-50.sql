Use AdventureWorks2019
--41 and --42--
Select 
    soh.SalesOrderID
    ,CONCAT(cp.FirstName,' ',cp.LastName) as 'CustomerName'
    ,Case When cp.PersonType = 'IN' Then 'Inividual Customer'
	  When cp.PersonType = 'SC' Then 'Store Contact'
	  Else Null End as 'PersonType'
    ,Case When CONCAT(sp.FirstName,' ',sp.LastName) = ' ' 
	  Then 'No Sales Person'
	  Else CONCAT(sp.FirstName,' ',sp.LastName) End  as 'SalesPerson'
    ,OrderDate
    ,Sum(OrderQTY) as ProductQty
From Sales.SalesOrderHeader soh
    Inner Join Sales.SalesOrderDetail sod on soh.SalesOrderID = sod.SalesOrderID
    Inner Join Sales.Customer c on c.CustomerID = soh.CustomerID
    Inner Join Person.Person cp on cp.BusinessEntityID = c.PersonID
    Left Join Person.Person sp on sp.BusinessEntityID = soh.SalesPersonID
Group by 
    soh.SalesOrderID
    ,CONCAT(cp.FirstName,' ',cp.LastName)
    ,cp.PersonType
    ,OrderDate
    ,CONCAT(sp.FirstName,' ',sp.LastName)

--43--
/* a. How many Sales people are meeting their YTD Quota? Use an Inner query (subquery) to show a single value meeting this criteria

b. How many Sales People have YTD sales greater than the average Sales Person YTD sales. Also use an Inner Query to show a single value of those meeting this criteria. */

--a--

SELECT
     COUNT(*) as CNT
FROM 
    (SELECT *
	FROM Sales.SalesPerson 
	WHERE SalesYTD > SalesQuota) a

--b--
SELECT
      COUNT(*) as CNT
FROM Sales.SalesPerson sp
WHERE SalesYTD > 
            (SELECT AVG(SalesYTD)
			FROM Sales.SalesPerson)

--44-
/*
Question 44
a. Create a stored procedure called "Sales_Report_YTD" without an output parameter that will show the sales

people the following information:

BusinessEntityID

CommissionPct

SalesYTD

Commission

Bonus

b. Execute the Stored Procedure

c. Delete the Stored Procedure



Hint:
(SalesYTD x CommissionPct) = Commission

Use the salesperson table */
--a--
Create Procedure Sales_Report_YTD
as (
    Select 
        BusinessEntityID
        ,Format(CommissionPct,'p') as CommissionPct
        ,Format(SalesYTD,'$#,#') as SalesYTD
        ,Format((CommissionPct * SalesYTD),'$#,#') as Commission
        ,Format(Bonus,'$#,#') as Bonus
    From Sales.SalesPerson)
 
--b.
Exec Sales_Report_YTD
	
 
--c.
Drop Procedure Sales_Report_YTD

--45--
/*Question 45
Complete Question 44 before attempting Question 45

In Question 44 we created a stored Procedure called "Sales_Report_YTD." In this question we are going to create the same stored procedure with a single parameter. In Question 44 when we execute the stored procedure it shows all the sales information for each BusinessEntity. Lets assume this information is highly sensitive and each sales person should only know their unique BusinessEntityID. Add a parameter that would require a user to input their BusinessEntityID to view their own personal sale information. */

--a. 
Create Procedure Sales_Report_YTD
	@BusinessEntityID int
as (
	Select 
		BusinessEntityID
		,Format(CommissionPct,'p') as CommissionPct
		,Format(SalesYTD,'$#,#') as SalesYTD
		,Format((CommissionPct * SalesYTD),'$#,#') as Commission
		,Format(Bonus,'$#,#') as Bonus
	From Sales.SalesPerson
	Where BusinessEntityID = @BusinessEntityID)
	
--b.
Exec Sales_Report_YTD @BusinessEntityID = '279'
 
--c.
Drop Procedure Sales_Report_YTD

--46--
/* 
Question 46
In this question we are going to be working with Purchasing.Vendor.



a. Show each credit rating by a count of vendors

b. Use a case statement to specify each rating by a count of vendors:

1 = Superior

2 = Excellent

3 = Above Average

4 = Average

5 = Below Average

c. Using the Choose Function accomplish the same results as part b (Don't use case statement).

1 = Superior

2 = Excellent

3 = Above Average

4 = Average

5 = Below Average

d. Using a case statement show the PreferredVendorStatus by a count of Vendors. (This might seem redundant, but This exercise will help you learn when to use a case statement and when to use the choose function).

0 = Not Preferred

1 = Preferred

e. Using the Choose Function accomplish the same results as part d (Don't use case statement).  Why doesn't the Choose Function give the same results as part d? Which is correct?

0 = Not Preferred

1 = Preferred */

--47--
/* Question 46
In this question we are going to be working with Purchasing.Vendor.



a. Show each credit rating by a count of vendors

b. Use a case statement to specify each rating by a count of vendors:

1 = Superior

2 = Excellent

3 = Above Average

4 = Average

5 = Below Average

c. Using the Choose Function accomplish the same results as part b (Don't use case statement).

1 = Superior

2 = Excellent

3 = Above Average

4 = Average

5 = Below Average

d. Using a case statement show the PreferredVendorStatus by a count of Vendors. (This might seem redundant, but This exercise will help you learn when to use a case statement and when to use the choose function).

0 = Not Preferred

1 = Preferred

e. Using the Choose Function accomplish the same results as part d (Don't use case statement).  Why doesn't the Choose Function give the same results as part d? Which is correct?

0 = Not Preferred

1 = Preferred */
--a.

Select

CreditRating

,Count(name) as CNT

From Purchasing.Vendor

Group by CreditRating



--b.

Select

Case When CreditRating = 1 Then 'Superior'

     When CreditRating = 2 Then 'Excellent'

When CreditRating = 3 Then 'Above Average'

When CreditRating = 4 Then 'Average'

When CreditRating = 5 Then 'Below Average'

Else Null End as CreditRating

,Count(name) as CNT

From Purchasing.Vendor

Group by CreditRating



--c.

Select

Choose(CreditRating

  ,'Superior'

  ,'Excellent'

  ,'Above Average'

  ,'Average'

  ,'Below Average') as CreditRating

,Count(name) as CNT

From Purchasing.Vendor

Group by CreditRating


--d--
Select

Case When PreferredVendorStatus = 0 Then 'Not Preferred'

     When PreferredVendorStatus = 1 Then 'Preferred'

Else Null End as VendorStatus

,Count(name) as CNT

From Purchasing.Vendor

Group by PreferredVendorStatus

--e--
Select

Choose(PreferredVendorStatus

,'Not Preferred','Preferred') as VendorStatus

,Count(name) as CNT

From Purchasing.Vendor

Group by PreferredVendorStatus

Question 48
/*Complete Question 46 before attempting this question.



In Question 46 we wrote two scripts that gave the same output/results. One script we used a case statement the other statement we used a choose function. In this question we are going to write very similar scripts and it might seem redundant to answer these questions but this will help you learn when to use Case, Choose, and IIf. In question 46 we learned that the credit rating has a description (i.e. 1 = Superior). However, in this question we are going to assume that AdventureWorks only deems a vendor as "Approved" if they have a "Superior" credit rating. If the vendor has any other rating then they are "Not Approved". Credit Rating Grouping:

1 = Approved

2 = Not Approved

3 = Not Approved

4 = Not Approved

5 = Not Approved



a. Using a case statement show a count of vendors by "Approved" vs. "Not Approved".



b. Using the Choose function show a count of vendors by "Approved" vs. "Not Approved".



c. Using the IIF function show a count of vendors by "Approved" vs. "Not Approved". */

--a
Select 
	Case When CreditRating = 1 Then 'Approved'
		 Else 'Not Approved' End as CreditRating
	,Count(name) as CNT
From Purchasing.Vendor
Group by 
	Case When CreditRating = 1 Then 'Approved'
		 Else 'Not Approved' End
--b
Select 
	Choose(CreditRating
		   ,'Approved'
		   ,'Not Approved'
		   ,'Not Approved'
		   ,'Not Approved'
		   ,'Not Approved') as CreditRating
	,Count(name) as CNT
From Purchasing.Vendor
Group by 
	Choose(CreditRating
		   ,'Approved'
		   ,'Not Approved'
		   ,'Not Approved'
		   ,'Not Approved'
		   ,'Not Approved')


--c
Select  
	IIF(CreditRating = 1
		,'Approved'
		,'Not Approved') as CreditRating
	,Count(name) as CNT
From Purchasing.Vendor
Group by 
	IIF(CreditRating = 1
		,'Approved'
		,'Not Approved')

/*
Question 49
Before attempting this question complete questions 46 and 47.



a. Write an Alter Statement that will add a column to the Purchasing.Vendor. Name the Column - CreditRatingDesc" (varchar(100) data type).

b. Using the credit rating and a case statement (Question 46 part b)  or a Choose function (Question 46 part c) update "CreditRatingDesc".

1 = Superior

2 = Excellent

3 = Above Average

4 = Average

5 = Below Average

c. Drop the "CreditRatingDesc" Column. */


--a. 
Alter Table Purchasing.Vendor
Add CreditRatingDesc varchar(100)
 
--b. 
Update Purchasing.Vendor
Set CreditRatingDesc = a.CreditRating
From Purchasing.Vendor v
	Inner Join (Select 
	              BusinessEntityID
		     ,Choose(CreditRating
		     ,'Superior'
		     ,'Excellent'
		     ,'Above Average'
		     ,'Average'
		     ,'Below Average') as CreditRating
		From Purchasing.Vendor) a
		    on v.BusinessEntityID = a.BusinessEntityID
--c. 
Alter Table Purchasing.Vendor
Drop Column CreditRatingDesc

/*Question  50 */
This Question is precursor to Question 50.

a. Using the INFORMATION_SCHEMA.COLUMNS table find the data type for Vendor.Name



b. Does this data type have an alias? In other words, is it a user defined data type? If so, what is it?



c. Using the INFORMATION_SCHEMA.COLUMNS table show a count of data types by user defined data types. */

--a. 
Select DATA_TYPE
From INFORMATION_SCHEMA.COLUMNS
Where TABLE_NAME = 'Vendor'
	and COLUMN_NAME = 'Name'
 
--b. 
Select 
	DOMAIN_SCHEMA
	,DOMAIN_NAME
From INFORMATION_SCHEMA.COLUMNS
Where TABLE_NAME = 'Vendor'
	and COLUMN_NAME = 'Name'
--c.
Select 
	DOMAIN_SCHEMA
	,DOMAIN_NAME
	,Count(*)
From INFORMATION_SCHEMA.COLUMNS
Group by 
	DOMAIN_SCHEMA
	,DOMAIN_NAME

--50--
/*Question 50
Answer Question 49 before attempting this question.



We question 49 we learned there are 6 user defined data types in the AdventureWorks database. In this question we are going to create a new user defined data type.



a. Using INFORMATION_SCHEMA.COLUMNS write a query that will show every column that has the columnName = Status.  What is the data type for these columns?



b. Create a new User defined data type named 'Status." The data type will be tinyint and notice that in the   INFORMATION_SCHEMA.COLUMNS table the IS_NULLABLE column says 'No.' This means when you're creating the user defined data type be sure to specify Not Null.



c. Write an Alter statement to change the data type on PurchaseOrderHeader.Status from tinyint to the new User Defined data type, status. Did the Domain Name in INFORMATION_SCHEMA.COLUMNS change?



d. Try to Drop the Status User Defined Data Type. You will get an error. Why?



e. Write an Alter Statement to change the data type on PurchaseOrderHeader.Status back to the tinyint

   (don't forget the NOT NULL).



f. Now Drop the Status User Defined Data Type */
--a. 
Select *
From INFORMATION_SCHEMA.COLUMNS
Where COLUMN_NAME = 'status'
 
--b. 
Create Type [Status]
From tinyint Not NUll
 
--c. 
Alter Table Purchasing.PurchaseOrderHeader
Alter Column [Status] status
 
--d. 
Drop Type Status
 
--e. 
Alter Table Purchasing.PurchaseOrderHeader
Alter Column [Status] tinyint NOT NULL
 
--f. 
Drop Type Status


