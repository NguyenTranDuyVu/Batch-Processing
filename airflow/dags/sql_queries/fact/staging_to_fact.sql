insert into classicmodels_dw.shipped_orders_detail (customerId, productId,employeeId, officeId, orderNumber, quantityOrdered, priceEach, value, shippedDate) 
SELECT c.customerId, p.productId, e.employeeId, ofi.officeId, staging.orderNumber, staging.quantityOrdered, staging.priceEach, staging.value,staging.shippedDate as shippedDate  FROM 
(select * from classicmodels_dw.shipped_orders_detail_staging where shippedDate >= '2004-01-01' and shippedDate < '2005-01-01') staging
inner join classicmodels_dw.customers c on staging.customerNumber = c.customerNumber 
inner join classicmodels_dw.products p on staging.productCode = p.productCode
inner join classicmodels_dw.employees e on staging.employeeNumber = e.employeeNumber
inner join classicmodels_dw.offices ofi on staging.officeCode = ofi.officeCode;