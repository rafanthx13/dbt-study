-- Scrript para criar tabelas no BigQuery
-- O Bigquery requer que especifique o 'schema'
-- A sintaaxex teveque ser modificada, pois nao tem varchar no bigquery, usa-se 'STRING' AO INVEZ DE 'VARCHAR'

CREATE TABLE dbt_example.categories (
    category_id INT64 NOT NULL,
    category_name STRING(15) NOT NULL,
    description STRING(255)
);
CREATE TABLE dbt_example.customers (
    customer_id STRING(40) NOT NULL,
    company_name STRING(40) NOT NULL,
    contact_name STRING(30),
    contact_title STRING(30),
    address STRING(60),
    city STRING(15),
    region STRING(15),
    postal_code STRING(10),
    country STRING(15),
    phone STRING(24)
);
CREATE TABLE dbt_example.employees (
    employee_id INT64 NOT NULL,
    last_name STRING(20) NOT NULL,
    first_name STRING(10) NOT NULL,
    title STRING(30),
    title_of_courtesy STRING(25),
    birth_date date,
    hire_date date,
    address STRING(60),
    city STRING(15),
    region STRING(15),
    postal_code STRING(10),
    country STRING(15),
    home_phone STRING(24),
    extension STRING(4),
    notes STRING(500),
    reports_to INT64,
    photo_path STRING(500),
	salary FLOAT64
);
CREATE TABLE dbt_example.order_details (
    order_id INT64 NOT NULL,
    product_id INT64 NOT NULL,
    unit_price FLOAT64 NOT NULL,
    quantity INT64 NOT NULL,
    discount FLOAT64 NOT NULL
);

CREATE TABLE dbt_example.orders (
    order_id INT64 NOT NULL,
    customer_id STRING(20),
    employee_id INT64,
    order_date date,
    required_date date,
    shipped_date date,
    ship_via INT64,
    freight FLOAT64,
    ship_name STRING(40),
    ship_address STRING(60),
    ship_city STRING(15),
    ship_region STRING(15),
    ship_postal_code STRING(10),
    ship_country STRING(15)
);
CREATE TABLE dbt_example.products (
    product_id INT64 NOT NULL,
    product_name STRING(40) NOT NULL,
    supplier_id INT64,
    category_id INT64,
    quantity_per_unit STRING(20),
    unit_price FLOAT64,
    units_in_stock INT64,
    units_on_order INT64,
    reorder_level INT64,
    discontinued integer NOT NULL
);

CREATE TABLE dbt_example.shippers (
    shipper_id INT64 NOT NULL,
    company_name STRING(40) NOT NULL,
    phone STRING(24)
);
CREATE TABLE dbt_example.suppliers (
    supplier_id INT64 NOT NULL,
    company_name STRING(40) NOT NULL,
    contact_name STRING(30),
    contact_title STRING(30),
    address STRING(60),
    city STRING(15),
    region STRING(15),
    postal_code STRING(10),
    country STRING(15),
    phone STRING(24),
    fax STRING(24),
    homepage STRING(255)
);
