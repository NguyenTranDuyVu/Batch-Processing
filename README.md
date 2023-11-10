## 1. Introduction 
Using classicmodels dataset about sale data of a company in 2004 as source data, assume the company's analytic teams is interested in understanding their business situation in the this year. We will build ETL pipelines which will transform raw data into actionable insights, store them in OLTP database (MySQL) then load data to a star schema data mart(Amazon Redshift) for enhanced data analytics capabilities.

Data include tables : <b> <i> customers, products, productlines, orders, orderdetails, payments, employees, offices </i> </b>

### Technologies used
- Python
- MySQL
- Airflow
- AWS services: Redshift (data warehouse & dashboards)
- Docker

## 2. Implementation overview 
Design data model for data warehouse (Amazon Redshift). Build an ETL pipeline to transform raw data fromMySQL to Amazon Redshift for enhanced data analytics . Using Airflow to orchestrate pipeline workflow, Redshift Serverless for datawarehouse, and Docker to deploy Airflow.

<img src = assets/architecture.png alt = "architecture">

## 3. Design 
<div style="display: flex; flex-direction: column;">
  <img src=assets/source_schema.png alt="Data model" width="600" height="500">
  <p style="text-align: center;"> <b> <i> Data model for MySQL </i> </b> </p>
</div>

<br> <br>

<div style="display: flex; flex-direction: column;">
  <img src=assets/dw_schema.png alt="Star schema" width="600" height="500">
  <p style="text-align: center;"> <b> <i> Data model (star schema) for Redshift </i> </b> </p>
</div>

<br> <br>

<div style="display: flex; flex-direction: column;">
  <img src=assets/airflow_workflow.png alt="Airflow workflow" width="900" height="500">
  <p style="text-align: center;"> <b> <i> Airflow workflow </i> </b> </p>
</div>

## 4. Settings

### Prerequisites
- AWS account 
- Docker 

### Important note

<b> You must specify AWS credentials for each of the following </b>
- Redshift access : Make Redshift workgroup available to public and create a superuser, then add a Redshift connection to the Airflow connection store to use for ETL pipelines.

## 5. Implementation
### 5.1 Load sales data into MySQL database

<b> Airflow task </b>

```python

setup_source = SQLExecuteQueryOperator(
    task_id='setup_source',
    conn_id='classicmodels',
    sql='./sql_queries/setup/source_setup.sql',
    dag=dag
)    
```
<b> setup_source: </b> Run setup queries to create tables and add data to source database


### 5.2 Load sales data from MySQL into Redshift
<b> Airflow tasks </b>

```python
# setup datawarehouse tables
setup_dw = SQLExecuteQueryOperator(
    task_id='setup_dw',
    conn_id='classicmodels',
    sql='./sql_queries/setup/dw_setup.sql',
    dag=dag
)

#ingest dimension tables
ingest_products = GenericTransfer(
    task_id='ingest_products',
    sql='./sql_queries/extract/product_extract.sql',
    destination_table='classicmodels_dw.products',
    source_conn_id='classicmodels',
    destination_conn_id='classicmodels',
    insert_args={'target_fields':['productCode','productName', 'productLine', 'productScale', 'productVendor', 'productDescription']},
    dag=dag
)

ingest_customers = GenericTransfer(
    task_id='ingest_customers',
    sql='./sql_queries/extract/customer_extract.sql',
    destination_table='classicmodels_dw.customers',
    source_conn_id='classicmodels',
    destination_conn_id='classicmodels',
    insert_args={'target_fields':['customerNumber', 'customerName', 'contactLastName', 'contactFirstName', 'phone', 
'addressLine1', 'addressLine2', 'city', 'state', 'postalCode', 'country']},
    dag=dag
)

ingest_employees = GenericTransfer(
    task_id='ingest_employees',
    sql='./sql_queries/extract/employee_extract.sql',
    destination_table='classicmodels_dw.employees',
    source_conn_id='classicmodels',
    destination_conn_id='classicmodels',
    insert_args={'target_fields':['employeeNumber', 'lastName', 'firstName', 'extension', 'email']},
    dag=dag
)

ingest_offices = GenericTransfer(
    task_id='ingest_offices',
    sql='./sql_queries/extract/office_extract.sql',
    destination_table='classicmodels_dw.offices',
    source_conn_id='classicmodels',
    destination_conn_id='classicmodels',
    insert_args={'target_fields':['officeCode', 'city', 'phone', 'addressLine1', 'addressLine2', 'state', 'country', 'postalCode', 'territory']},
    dag=dag
)

#ingest staging table
shipped_orders_staging = GenericTransfer(
    task_id='shipped_orders_staging',
    sql='./sql_queries/extract/shipped_orders_staging.sql',
    destination_table='classicmodels_dw.shipped_orders_detail_staging',
    source_conn_id='classicmodels',
    destination_conn_id='classicmodels',
    insert_args={'target_fields':['customerNumber','productCode','employeeNumber','officeCode', 'orderNumber','quantityOrdered',
                                  'priceEach','value','shippedDate']},
    dag=dag
)
```
<br>
<b> setup_dw: </b> Run setup queries to create datawarehouse tables

<b> ingest_products: </b> Ingest products dimension from MySQL to Redshift

<b> ingest_customers: </b> Ingest customers dimension from MySQL to Redshift

<b> ingest_employees: </b> Ingest employees dimension from MySQL to Redshift

<b> ingest_offices: </b> Ingest offices dimension from MySQL to Redshift

<b> shipped_orders_staging: </b> Ingest sale data from MySQL to Redshift
<br>

### 5.3 Complete fact table in Redshift
<b> Airflow task </b>

```python

#staging to fact
staging_to_fact = SQLExecuteQueryOperator(
    task_id='staging_to_fact',
    conn_id="classicmodels",
    database='classicmodels_dw',
    sql='./sql_queries/fact/staging_to_fact.sql',
    dag=dag
    )
```

<b> staging_to_fact: </b> Transform data from staging table to fact table to deal with Slow Changing Dimensions (SCD) 