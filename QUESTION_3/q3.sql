--Select Database
use adventureworks;
--Make a temp table from the existing tables
with TempTable as(
    --Select required columns from required tables
    SELECT salesorderheadersalesreason.SalesReasonID,
        salesreason.Name,
        salesreason.ReasonType,
        round(sum(salesorderheader.TotalDue), 4) as Sales --Select base table
    FROM salesorderheader --Do required joins for retiving data from another tables
        left join salesorderheadersalesreason on salesorderheader.SalesOrderID = salesorderheadersalesreason.SalesOrderID
        left join salesreason on salesorderheadersalesreason.SalesReasonID = salesreason.SalesReasonID --Group data as per requirement
    group by SalesReasonID --Make a table with proper order of Sale amount
    order by Sales desc
) --Now Make the final potput from previous temp table
select Name as SaleReason,
    ReasonType as SaleReasonType,
    Sales as TotalSalePerReason,
    --As we need to calculate the best and worst performing Sales Reason
    --We create a new column where we put some description as per performance
    case
        when Sales = (
            select max(Sales)
            from TempTable
        ) then "Best Performing Sales Reason"
        when Sales = (
            select min(Sales)
            from TempTable
        ) then "Worst Performing Sales Reason" --We just need the best and worst performing sales Reason so we filled other fields with null
        else null
    end --The name of the new created colums is provided here
    as Performance --Selecting the TempTable as source table which we generater Previously
from TempTable --Ordered the table data as per the Sale amount
order by Sales desc;