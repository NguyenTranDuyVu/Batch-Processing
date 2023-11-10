import pendulum
from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.operators.generic_transfer import GenericTransfer

dag = DAG(
    dag_id='etl_mysql_redshift',
    start_date=pendulum.now('UTC'),
    schedule=None
)

# # set up databases
# setup_source = SQLExecuteQueryOperator(
#     task_id='setup_source',
#     conn_id='classicmodels',
#     sql='./sql_queries/setup/source_setup.sql',
#     dag=dag
# )    

# setup_dw = SQLExecuteQueryOperator(
#     task_id='setup_dw',
#     conn_id='classicmodels_dw',
#     sql='./sql_queries/setup/dw_setup.sql',
#     dag=dag
# )

# #ingest dimension tables
# ingest_products = GenericTransfer(
#     task_id='ingest_products',
#     sql='./sql_queries/extract/product_extract.sql',
#     destination_table='classicmodels_dw.products',
#     source_conn_id='classicmodels',
#     destination_conn_id='classicmodels_dw',
#     insert_args={'target_fields':['productCode','productName', 'productLine', 'productScale', 'productVendor']},
#     dag=dag
# )

# ingest_customers = GenericTransfer(
#     task_id='ingest_customers',
#     sql='./sql_queries/extract/customer_extract.sql',
#     destination_table='classicmodels_dw.customers',
#     source_conn_id='classicmodels',
#     destination_conn_id='classicmodels_dw',
#     insert_args={'target_fields':['customerNumber', 'customerName', 'contactLastName', 'contactFirstName', 'phone', 
# 'addressLine1', 'addressLine2', 'city', 'state', 'postalCode', 'country']},
#     dag=dag
# )

# ingest_employees = GenericTransfer(
#     task_id='ingest_employees',
#     sql='./sql_queries/extract/employee_extract.sql',
#     destination_table='classicmodels_dw.employees',
#     source_conn_id='classicmodels',
#     destination_conn_id='classicmodels_dw',
#     insert_args={'target_fields':['employeeNumber', 'lastName', 'firstName', 'extension', 'email']},
#     dag=dag
# )

# ingest_offices = GenericTransfer(
#     task_id='ingest_offices',
#     sql='./sql_queries/extract/office_extract.sql',
#     destination_table='classicmodels_dw.offices',
#     source_conn_id='classicmodels',
#     destination_conn_id='classicmodels_dw',
#     insert_args={'target_fields':['officeCode', 'city', 'phone', 'addressLine1', 'addressLine2', 'state', 'country', 'postalCode', 'territory']},
#     dag=dag
# )

# #ingest staging table
# shipped_orders_staging = GenericTransfer(
#     task_id='shipped_orders_staging',
#     sql='./sql_queries/extract/shipped_orders_staging.sql',
#     destination_table='classicmodels_dw.shipped_orders_detail_staging',
#     source_conn_id='classicmodels',
#     destination_conn_id='classicmodels_dw',
#     insert_args={'target_fields':['customerNumber','productCode','employeeNumber','officeCode', 'orderNumber','quantityOrdered',
#                                   'priceEach','value','shippedDate']},
#     dag=dag
# )

#staging to fact
staging_to_fact = SQLExecuteQueryOperator(
    task_id='staging_to_fact',
    conn_id="classicmodels_dw",
    sql='./sql_queries/fact/staging_to_fact.sql',
    dag=dag
    ) 
    
#setup_source >> setup_dw >> [ingest_products,ingest_customers, ingest_employees, ingest_offices, shipped_orders_staging] >> 
staging_to_fact
    
