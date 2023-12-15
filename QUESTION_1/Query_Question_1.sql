--Select Database
use adventureworks;
SELECT --Select table fields ProductID and sum of LineTotal for each ProductID
    ProductID,
    round(sum(LineTotal), 4) as Sales --Define the Source Table
FROM adventureworks.salesorderdetail --Partioning the table for each ProductID
group by ProductID --Arrange all data in descending order of Sales
order by Sales desc --Show top 10 rows only
limit 10;