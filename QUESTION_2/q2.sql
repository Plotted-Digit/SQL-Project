--Select Database
use adventureworks;

select --Get all fields from Tables
    concat_ws (
        --To Generate Customer Name We used concat_ws function which has seperator value ' ' and all other fields insted of concat function as there are some null fields
        ' ',
        contact.Title,
        contact.FirstName,
        contact.MiddleName,
        contact.LastName
    ) as CustomerName,
    --All fields of customer's address
    addresstype.Name as AddressType,
    address.AddressLine1,
    address.City,
    address.StateProvinceID,
    address.PostalCode,
    round(sum(salesorderheader.TotalDue), 4) as Sales --Total sale per customer, we used sum to add all values and used round function to get 4 digits after decimal point 
from
    salesorderheader --Choose our base table
    --Joining all other tables required to get all details
    join customeraddress on salesorderheader.CustomerID = customeraddress.CustomerID
    join address on customeraddress.AddressID = address.AddressID
    join addresstype on customeraddress.AddressTypeID = addresstype.AddressTypeID
    join Contact on Contact.ContactID = salesorderheader.ContactID
group by --Grouping all fields as per our requirement
    CustomerName,
    AddressType,
    AddressLine1,
    City,
    StateProvinceID,
    PostalCode
order by --As we need maximum sales so we sorted our data from higher to lower sale amount
    Sales desc
limit --We just need top 10 data so we limited our table for only top 10
    10;