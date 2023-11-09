drop schema if exists classicmodels_dw;
create schema classicmodels_dw;

create table classicmodels_dw.products (
	productId int primary key auto_increment,
    productCode varchar(15) NOT NULL,
    productName varchar(70),
    productLine varchar(50),
    productScale varchar(10),
    productVendor varchar(50),
    productDescription text
);

create table classicmodels_dw.customers (
customerId int primary key auto_increment,
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
employeeId int primary key auto_increment,
employeeNumber int NOT NULL,
lastName varchar(50),
firstName varchar(50),
extension varchar(10),
email varchar(100)
);

create table classicmodels_dw.offices (
officeId int primary key auto_increment,
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

create table classicmodels_dw.shipped_orders_detail (
shippedOrdersDetailId int primary key auto_increment,
customerId int,
productId int, 
employeeId int,
officeId int,
orderNumber int,
quantityOrdered int,
priceEach decimal(10,2),
value decimal(10,2),
shippedDate int,
foreign key(customerId) references customers(customerId),
foreign key(productId) references products(productId),
foreign key(employeeId) references employees(employeeId),
foreign key(officeId) references offices(officeId)
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
shippedDate int
);

