##Select Database
use adventureworks;

##Get all fields from Tables
select

##To Generate Customer Name We used concat_ws function which has seperator value ' ' and all other fields insted of concat function as there are some null fields
concat_ws(' ', contact.Title, contact.FirstName,contact.MiddleName,contact.LastName) as CustomerName, 

##All fields of customer's address
addresstype.Name as AddressType, address.AddressLine1, address.City, address.StateProvinceID,  address.PostalCode,

##Total sale per customer, we used sum to add all values and used round function to get 4 digits after decimal point 
round(sum(salesorderheader.TotalDue), 4) as Sales

##Choose our base table
from salesorderheader

##Joining all other tables required to get all details
join customeraddress on salesorderheader.CustomerID = customeraddress.CustomerID
join address on customeraddress.AddressID = address.AddressID
join addresstype on customeraddress.AddressTypeID = addresstype.AddressTypeID
join Contact on Contact.ContactID=salesorderheader.ContactID

##Grouping all fields as per our requirement
group by CustomerName, AddressType, AddressLine1, City, StateProvinceID, PostalCode

##As we need maximum sales so we sorted our data from higher to lower sale amount
order by Sales desc

##We just need top 10 data so we limited our table for only top 10
limit 10;