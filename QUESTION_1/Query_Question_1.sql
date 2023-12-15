--Select Database
use adventureworks;

SELECT --Select table fields ProductID and sum of LineTotal for each ProductID
    ProductID,
    round(sum(LineTotal), 4) as Sales
FROM --Define the Source Table
    adventureworks.salesorderdetail
group by --Partioning the table for each ProductID
    ProductID
order by --Arrange all data in descending order of Sales
    Sales desc
limit --Show top 10 rows only
    10;