# Learning Objectives

- Explain the purpose of sources in dbt.
- Configure and select from sources in your data warehouse.
- View sources in the lineage graph.
- Check the last time sources were updated and raise warnings if stale.


## What are sources?

Sabemos que SOurces referencia ao raw data, ou seja, a uma tabela em uma cloud.

Aocntece que, e se agente mudar o nome dessa table, vai ter que busar em todo os arquivos do dbt e fazer o replace.

É possível contonar esse tipo de coisa usando SOurce.

SOuces sâo configuraos em um arquivo .yml onde referncia direto:
+ Databse
+ Schema
+ Nome da tabela

Assim, com isso, na parte do `FROM` das consultas SQL podem fica rbem menores: VOcÊ cria um alias que já aponta direto para esas 3 coisas.

Assima o invez de escrevre

raw.stripe.payments, voce pode screver {{ source('stripe','payments') }}

Assim Quando compila, vai converter de uma cosia pra outras.

2 upser power daso por soucres
+ Atuzliar nome de tabela fica em u só lugar no arquivo YAMl.
+ Melhora a visualizaçao das raw table no seu lineage
  + É definido esse source que msotra um node verde na linha que referencia a um source

## Configure and select from sources







#### Reference: Code Snippets

**models/staging/jaffle_shop/src_jaffle_shop.yml**

```yaml
version: 2

sources:
  - name: jaffle_shop
    database: raw
    schema: jaffle_shop
    tables:
      - name: customers
      - name: orders
```

**models/staging/jaffle_shop/stg_customers.sql**

```sql
select 
    id as customer_id,
    first_name,
    last_name
from {{ source('jaffle_shop', 'customers') }}
```

**models/staging/jaffle_shop/stg_orders.sql**

```sql
select
    id as order_id,
    user_id as customer_id,
    order_date,
    status
from {{ source('jaffle_shop', 'orders') }}
```



## Source freshness



Pesquisar mais o que esse codigo abaixo faz no dbt



*Note: Since the data you loaded into your data warehouse for this course is static, you might not see the same results if you follow the workflow here. Bookmark this lesson for when you want to try this in the future in your own dbt project.*

#### Reference: Code Snippets

**models/staging/jaffle_shop/src_jaffle_shop.yml**

```yaml
version: 2
sources: 
- name: jaffle_shop  
  database: raw  
  schema: jaffle_shop  
  tables:   
    - name: customers   
    - name: orders    
      loaded_at_field: _etl_loaded_at    
      freshness:     
        warn_after: {count: 12, period: hour}     
        error_after: {count: 24, period: hour}
```


# Practice

Using the resources in this module, complete the following in your dbt project.

## Configure sources

- Configure a source for the tables `raw.jaffle_shop.customers` and `raw.jaffle_shop.orders` in a file called `src_jaffle_shop.yml`.

**`models/staging/jaffle_shop/src_jaffle_shop.yml`**

```yaml
version: 2

sources:
  - name: jaffle_shop
    database: raw
    schema: jaffle_shop
    tables:
      - name: customers
      - name: orders
```

- Extra credit: Configure a source for the table `raw.stripe.payment` in a file called `src_stripe.yml`.

## Refactor staging models

- Refactor `stg_customers.sql` using the source function.

**`models/staging/jaffle_shop/stg_customers.sql`**

```sql
select 
    id as customer_id,
    first_name,
    last_name
from {{ source('jaffle_shop', 'customers') }}
```

- Refactor `stg_orders.sql` using the source function.

**`models/staging/jaffle_shop/stg_orders.sql`**

```sql
select
    id as order_id,
    user_id as customer_id,
    order_date,
    status
from {{ source('jaffle_shop', 'orders') }}
```

- Extra credit: Refactor `stg_payments.sql` using the source function.

## Extra credit

- Configure your Stripe payments data to check for source freshness.
- Run `dbt source freshness`.



You can configure your `sources.yml` file as below:

```
version: 2

sources:
  - name: stripe
    database: dbt-tutorial
    schema: stripe
    tables:
      - name: payment
        loaded_at_field: _batched_at
        freshness:
          warn_after: {count: 12, period: hour}
          error_after: {count: 24, period: hour}
```









# Exemplar

## Self-check `src_stripe` and `stg_payments`

*Use this page to check your work.*

**`models/staging/stripe/src_stripe.yml`**

```yaml
version: 2

sources:
  - name: stripe
    database: raw
    schema: stripe
    tables:
      - name: payment
```

**`models/staging/stripe/stg_payments.sql`**

```sql
select
    id as payment_id,
    orderid as order_id,
    paymentmethod as payment_method,
    status,
    -- amount is stored in cents, convert it to dollars
    amount / 100 as amount,
    created as created_at
from {{ source('stripe', 'payment') }}
```











# Review

## Sources

- Sources represent the raw data that is loaded into the data warehouse.

- We *can* reference tables in our models with an explicit table name (`raw.jaffle_shop.customers`).

- However, setting up Sources in dbt and referring to them with the

   

  ```
  source
  ```

   

  function enables a few important tools.

  - Multiple tables from a single source can be configured in one place.
  - Sources are easily identified as green nodes in the Lineage Graph.
  - You can use `dbt source freshness` to check the freshness of raw tables.

## Configuring sources

- Sources are configured in YML files in the models directory.
- The following code block configures the table `raw.jaffle_shop.customers` and `raw.jaffle_shop.orders`:

```yaml
version: 2

sources:
  - name: jaffle_shop
    database: raw
    schema: jaffle_shop
    tables:
      - name: customers
      - name: orders
```

- View the full documentation for configuring sources on the [source properties](https://docs.getdbt.com/reference/source-properties) page of the docs.

## Source function

- The `ref` function is used to build dependencies between models.
- Similarly, the `source` function is used to build the dependency of one model to a source.
- Given the source configuration above, the snippet `{{ source('jaffle_shop','customers') }}` in a model file will compile to `raw.jaffle_shop.customers`.
- The Lineage Graph will represent the sources in green.

![img](https://files.cdn.thinkific.com/file_uploads/342803/images/ea4/909/31e/DAG_sources.png)

## Source freshness

- Freshness thresholds can be set in the YML file where sources are configured. For each table, the keys `loaded_at_field` and `freshness` must be configured.

```yaml
version: 2

sources:
  - name: jaffle_shop
    database: raw
    schema: jaffle_shop
    tables:
      - name: orders
        loaded_at_field: _etl_loaded_at
        freshness:
          warn_after: {count: 12, period: hour}
          error_after: {count: 24, period: hour}
```

- A threshold can be configured for giving a warning and an error with the keys `warn_after` and `error_after`.
- The freshness of sources can then be determined with the command `dbt source freshness`.



## Quaestions



1 - By default, where in your dbt project will dbt look for source configurations?

A .yml file in the models folder





2 - Which of the following is NOT a benefit of using the sources feature?

O que está errado:

+ You can modify and append to raw tables in your data warehouse

O que está certo:

+ You can document raw tables in your data warehouse
+ You can visualize raw tables in your DAG
+ You can build dependencies between models and raw tables in your DAG



43 -  Consider the YAML file below. Which of the following lines of code will select all columns from the products table?

```
**models/staging/payments_sources.yml**
```



```ynk
version: 2

sources:
  - name: salesforce
    database: raw
    schema: sfdc
    tables:
      - name: customers
      - name: opportunities
      - name: products
  - name: quickbooks   
    database: raw
    schema: qb
    tables:
      - name: payments
      - name: customers
```

Nâo ppe C

Letra D: `select * from {{ source(‘salesforce’, ‘products’) }}`

### QUESTION 4 OF 6

![img](https://files.cdn.thinkific.com/file_uploads/342803/images/cbf/da6/dd7/1651257429677.jpg)Consider the DAG of a dbt project listed above.  What was most likely missed by the data team working on this project?



C: They did not use the source function to build a dependency between staging models and sources



QUestao 5- Consider the YAML above. What does the freshness block accomplish?

```
version: 2

sources:
  - name: jaffle_shop
    description: A clone of a Postgres application database
    database: raw
    schema: jaffle_shop
    tables:
      - name: customers
        description: Raw customers data.
        columns:
          - name: id
            description: Primary key for customers data.
            tests:
              - unique
              - not_null
      - name: orders
        description: Raw orders data.
        columns:
          - name: id
            description: Primary key for orders data.
            tests:
              - unique
              - not_null
        loaded_at_field: _etl_loaded_at
        freshness:
          warn_after: {count: 12, period: hour}
          error_after: {count: 24, period: hour}
```

Éa etra A ==> dbt will warn if the max(_etl_loaded_at)  > 12 hours old, and error if max(_etl_loaded_at) > 24 hours old in the orders table when checking source freshness.



Questao 6 - What is the correct command to test your source freshness, assuming the freshness config block is correct?



dbt source freshness