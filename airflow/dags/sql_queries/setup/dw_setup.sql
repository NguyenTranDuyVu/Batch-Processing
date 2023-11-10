drop schema if exists classicmodels_dw cascade;
create schema classicmodels_dw;

create table classicmodels_dw.products (
	productId int identity(1, 1) primary key ,
    productCode varchar(15) NOT NULL,
    productName varchar(70),
    productLine varchar(50),
    productScale varchar(10),
    productVendor varchar(50)
);

create table classicmodels_dw.customers (
customerId int identity(1, 1) primary key ,
customerNumber int NOT NULL,
customerName varchar(50),
contactLastName varchar(50),
contactFirstName varchar(50),
phone varchar(50),
addressLine1 varchar(50),
addressLine2 varchar(50),
city varchar(50),
state varchar(50),
postalCode varchar(50),
country varchar(50)
);
create table classicmodels_dw.employees (
employeeId int identity(1, 1) primary key,
employeeNumber int NOT NULL,
lastName varchar(50),
firstName varchar(50),
extension varchar(10),
email varchar(100)
);

create table classicmodels_dw.offices (
officeId int identity(1, 1) primary key ,
officeCode int NOT NULL,
city varchar(50),
phone varchar(50),
addressLine1 varchar(50),
addressLine2 varchar(50),
state varchar(50),
country varchar(50),
postalCode varchar(15),
territory varchar(10)
);

create table classicmodels_dw.shipped_orders_detail_staging (
customerNumber int,
productCode varchar(15), 
employeeNumber int,
officeCode int,
orderNumber int,
quantityOrdered int,
priceEach decimal(10,2),
value decimal(10,2),
shippedDate date
);

create table classicmodels_dw.shipped_orders_detail (
shippedOrdersDetailId int identity(1, 1) primary key ,
customerId int,
productId int, 
employeeId int,
officeId int,
orderNumber int,
quantityOrdered int,
priceEach decimal(10,2),
value decimal(10,2),
shippedDate date,
foreign key(productId) references classicmodels_dw.products(productId),
foreign key(customerId) references classicmodels_dw.customers(customerId),
foreign key(employeeId) references classicmodels_dw.employees(employeeId),
foreign key(officeId) references classicmodels_dw.offices(officeId)
);

