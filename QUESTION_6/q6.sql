with basetable as (
    --Gather all sale details as a table
    SELECT TerritoryID,
        SalesPersonID,
        year(ShipDate) as shipyear,
        month(ShipDate) as shipmonth,
        round(sum(TotalDue), 4) as totalsale,
        ROW_NUMBER() OVER (
            PARTITION BY TerritoryID,
            year(ShipDate),
            month(ShipDate)
            order by sum(TotalDue) desc
        ) AS row_id
    FROM adventureworks.salesorderheader
    group by TerritoryID,
        year(ShipDate),
        month(ShipDate),
        SalesPersonID
),
datatable as (
    --Get all top 3 selling sales persons
    select TerritoryID as TerritoryType,
        shipyear as Year,
        shipmonth as Month,
        concat(shipmonth, '/', shipyear) as datecode,
        row_id as SaleRank,
        SalesPersonID as SalesPersonId,
        totalsale as TotalSale
    from basetable
    where row_id = 1
        or row_id = 2
        or row_id = 3
),
dates as (
    --Get a date list for each month of each year to use it as a base table
    select distinct(datecode)
    from datatable
),
topsale1 as (
    --Get the top saler for each territory
    select datatable.TerritoryType,
        datatable.Year,
        datatable.Month,
        datatable.datecode,
        datatable.SaleRank,
        datatable.SalesPersonId,
        datatable.TotalSale
    from dates
        left join datatable on dates.datecode = datatable.datecode
        and datatable.SaleRank = 1
),
topsale2 as (
    --Get the second top saler for each territory
    select datatable.TerritoryType,
        datatable.Year,
        datatable.Month,
        datatable.datecode,
        datatable.SaleRank,
        datatable.SalesPersonId,
        datatable.TotalSale
    from dates
        left join datatable on dates.datecode = datatable.datecode
        and datatable.SaleRank = 2
),
topsale3 as (
    --Get the 3rd top saler for each territory
    select datatable.TerritoryType,
        datatable.Year,
        datatable.Month,
        datatable.datecode,
        datatable.SaleRank,
        datatable.SalesPersonId,
        datatable.TotalSale
    from dates
        left join datatable on dates.datecode = datatable.datecode
        and datatable.SaleRank = 3
),
salewithrank as (
    --Put 1st, 2nd and 3rd top sellers side by side with their selling amount
    select dates.datecode as monthyear,
        topsale1.year as Year,
        topsale1.month as Month,
        topsale1.TerritoryType as Territory,
        topsale1.SalesPersonId as TopSalesPerson,
        topsale1.TotalSale TopSaleAmt,
        topsale2.SalesPersonId as 2ndTopSalesPerson,
        topsale2.TotalSale 2ndTopSaleAmt,
        topsale3.SalesPersonId as 3ndTopSalesPerson,
        topsale3.TotalSale 3rdTopSaleAmt
    from dates
        left join topsale1 on dates.datecode = topsale1.datecode
        left join topsale2 on dates.datecode = topsale2.datecode
        and topsale1.TerritoryType = topsale2.TerritoryType
        left join topsale3 on dates.datecode = topsale3.datecode
        and topsale2.TerritoryType = topsale3.TerritoryType
    order by Territory,
        Year,
        Month
)
select salesterritory.Name as TerritoryName,
    salewithrank.monthyear,
    salewithrank.TopSalesPerson,
    salewithrank.TopSaleAmt,
    salewithrank.2ndTopSalesPerson,
    salewithrank.2ndTopSaleAmt,
    salewithrank.3ndTopSalesPerson,
    salewithrank.3rdTopSaleAmt
from salewithrank
    left join salesterritory on salesterritory.TerritoryID = salewithrank.Territory --Get territory names as per territory id
order by Territory,
    Year,
    Month;