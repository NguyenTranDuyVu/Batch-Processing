## 1. Introduction 
Using classicmodels dataset about sale data of a company in 2003,assume the company's analytic teams is interested in understanding their business situation in the last year. We will build ETL pipelines which will transform raw data into actionable insights, store them in OLTP database (MySQL) then load data to a star schema data mart(Amazon Redshift) for enhanced data analytics capabilities.

Data include tables : <b> <i> customers, products, productlines, orders, orderdetails, payments, employees, offices </i> </b>

### Technologies used
- Python
- MySQL
- Airflow
- AWS services: Redshift (data warehouse)
- Docker

## 3. Design 
<div style="display: flex; flex-direction: column;">
  <img src=assets/source_schema.png alt="Data model" width="600" height="500">
  <p style="text-align: center;"> <b> <i> Data model for MySQL </i> </b> </p>
</div>

<br> <br>

<div style="display: flex; flex-direction: column;">
  <img src=assets/DW_schema.png alt="Star schema" width="600" height="500">
  <p style="text-align: center;"> <b> <i> Data model (star schema) for Redshift </i> </b> </p>
</div>

<br> <br>

<div style="display: flex; flex-direction: column;">
  <img src=assets/airflow_workflow.png alt="Airflow workflow" width="900" height="500">
  <p style="text-align: center;"> <b> <i> Airflow workflow </i> </b> </p>
</div>
