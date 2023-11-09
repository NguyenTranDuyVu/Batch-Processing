insert into shipped_orders_detail (customerId, productId,employeeId, officeId, orderNumber, quantityOrdered, priceEach, value, shippedDate) 
SELECT c.customerId, p.productId, e.employeeId, ofi.officeId, staging.orderNumber, staging.quantityOrdered, staging.priceEach, staging.value, staging.shippedDate FROM 
(select * from shipped_orders_detail_staging where shippedDate >= 20030101 and shippedDate < 20040101) staging
inner join customers c on staging.customerNumber = c.customerNumber 
inner join products p on staging.productCode = p.productCode
inner join employees e on staging.employeeNumber = e.employeeNumber
inner join offices ofi on staging.officeCode = ofi.officeCode;