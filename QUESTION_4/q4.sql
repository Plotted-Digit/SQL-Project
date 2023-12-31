--Select Database
use adventureworks;

with --Create Temp Table to run future query on it
    temptable as (
        --This table is to group all sales for each shipping method
        SELECT
            shipmethod.ShipMethodID as Id,
            shipmethod.Name as ShipMethod,
            year (ShipDate) as Year,
            monthname (ShipDate) as Month,
            round(
                sum(TotalDue) / count(salesorderheader.ShipMethodID),
                4
            ) as AverageSale
        FROM
            adventureworks.salesorderheader
            left join shipmethod on salesorderheader.ShipMethodID = shipmethod.ShipMethodID
        group by
            Year,
            month,
            Id,
            ShipMethod
        order by
            Id,
            ShipMethod,
            Year,
            month
    ),
    ship1 as (
        --This table is to extract all sales for 1st type of shipping method
        select
            ShipMethod,
            Year,
            Month,
            AverageSale
        from
            temptable
        where
            Id = 1
    ),
    ship2 as (
        --This table is to extract all sales for 2nd type of shipping method
        select
            ShipMethod,
            Year,
            Month,
            AverageSale
        from
            temptable
        where
            Id = 5
    )
select
    ship1.Year,
    ship1.Month,
    concat_ws ('/', ship1.Month, ship1.Year) as FullDate,
    ship1.ShipMethod,
    ship1.AverageSale,
    ship2.ShipMethod,
    ship2.AverageSale
from
    ship1
    left join ship2 on ship1.Year = ship2.Year
    and ship1.Month = ship2.Month
union
--As full join isnt working we did an union of left and right join to get our required output
select
    ship1.Year,
    ship1.Month,
    concat_ws ('/', ship1.Month, ship1.Year) as FullDate,
    --We arranged all sales for each shipping method side by side according to the month and year
    ship1.ShipMethod,
    ship1.AverageSale,
    ship2.ShipMethod,
    ship2.AverageSale
from
    ship1
    right join ship2 on ship1.Year = ship2.Year
    and ship1.Month = ship2.Month
order by
    Year,
    month;