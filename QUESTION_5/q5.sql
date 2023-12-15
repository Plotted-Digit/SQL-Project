--Select Database
use adventureworks;

with --generate a customized temp table to gather all require data from database
    baseTable as (
        SELECT
            year (salesorderheader.ShipDate) as year,
            month (salesorderheader.ShipDate) as month,
            concat_ws (
                '-',
                monthname (salesorderheader.ShipDate),
                year (salesorderheader.ShipDate)
            ) as fullDate,
            round(sum(salesorderheader.TotalDue), 4) as totalSale,
            count(salesorderheader.SalesOrderID) as orderCount,
            creditcard.CardType as cardType
        FROM
            adventureworks.salesorderheader
            left join creditcard on salesorderheader.CreditCardID = creditcard.CreditCardID
        group by
            year,
            month,
            fullDate,
            cardType
        order by
            year,
            month,
            fullDate,
            totalSale desc
    ),
    allCardSale as (
        select
            fullDate,
            max(
                case
                    when cardType = 'Vista' then orderCount
                end
            ) as NoOfsaleByVista,
            max(
                case
                    when cardType = 'Vista' then totalSale
                end
            ) as saleByVista,
            max(
                case
                    when cardType = 'Distinguish' then orderCount
                end
            ) as NoOfsaleByDistinguish,
            max(
                case
                    when cardType = 'Distinguish' then totalSale
                end
            ) as saleByDistinguish,
            max(
                case
                    when cardType = 'ColonialVoice' then orderCount
                end
            ) as NoOfsaleByColonialVoice,
            max(
                case
                    when cardType = 'ColonialVoice' then totalSale
                end
            ) as saleByColonialVoice,
            max(
                case
                    when cardType = 'SuperiorCard' then orderCount
                end
            ) as NoOfsaleBySuperiorCard,
            max(
                case
                    when cardType = 'SuperiorCard' then totalSale
                end
            ) as saleBySuperiorCard,
            max(
                case
                    when cardType is null then orderCount
                end
            ) as NoOfsaleByOther,
            max(
                case
                    when cardType is null then totalSale
                end
            ) as saleByOther
        from
            baseTable
        group by
            fullDate
    ),
    maxSale as (
        --Ranking all sales as per their performance from best to worst and generate a temptable
        select
            *,
            row_number() over (
                partition by
                    year,
                    month
                order by
                    year,
                    month,
                    fullDate,
                    totalSale desc
            ) as position
        from
            baseTable
    ),
    minSale as (
        --Ranking all sales as per their performance from worst to best and generate a temptable
        select
            *,
            row_number() over (
                partition by
                    year,
                    month
                order by
                    year,
                    month,
                    fullDate,
                    totalSale
            ) as position
        from
            baseTable
    )
select --Generating the output
    maxSale.year,
    maxSale.month,
    maxSale.fullDate,
    count(salesorderheader.SalesOrderID) as TotalNoOfSale,
    round(sum(salesorderheader.TotalDue), 4) as TotalSale,
    maxSale.fullDate,
    maxSale.cardType as maxSallingCard,
    maxSale.totalSale as saleByCard,
    maxSale.orderCount as NoOfSales,
    minSale.cardType as minSallingCard,
    minSale.totalSale as saleByCard,
    minSale.orderCount as NoOfSales,
    allCardSale.NoOfsaleByVista,
    allCardSale.saleByVista,
    allCardSale.NoOfsaleByDistinguish,
    allCardSale.saleByDistinguish,
    allCardSale.NoOfsaleByColonialVoice,
    allCardSale.saleByColonialVoice,
    allCardSale.NoOfsaleBySuperiorCard,
    allCardSale.saleBySuperiorCard,
    allCardSale.NoOfsaleByOther,
    allCardSale.saleByOther
from
    maxSale
    join minSale on maxSale.fullDate = minSale.fullDate
    join allCardSale on maxSale.fullDate = allCardSale.fullDate
    join salesorderheader on year (salesorderheader.ShipDate) = maxSale.year
    and month (salesorderheader.ShipDate) = maxSale.month
where
    maxSale.position = 1
    and minSale.position = 2
group by
    year,
    month,
    maxSale.fullDate,
    maxSale.cardType,
    maxSale.totalSale,
    minSale.cardType,
    minSale.totalSale,
    minSale.orderCount
order by
    year,
    month;