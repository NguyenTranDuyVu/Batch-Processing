select c.customerNumber, p.productCode, e.employeeNumber, ofi.officeCode, od.orderNumber, od.quantityOrdered, od.priceEach,
od.quantityOrdered * od.priceEach as value, o.shippedDate
from classicmodels.orderdetails od inner join classicmodels.products p on od.productCode = p.productCode 
inner join classicmodels.orders o on od.orderNumber = o.orderNumber 
inner join classicmodels.customers c on o.customerNumber = c.customerNumber 
inner join classicmodels.employees e on c.salesRepEmployeeNumber = e.employeeNumber 
inner join classicmodels.offices ofi on e.officeCode = ofi.officeCode
where o.status = 'Shipped' and o.shippedDate >= '2004-01-01' and o.shippedDate < '2005-01-01'  