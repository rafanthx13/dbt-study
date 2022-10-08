# Tests

## Learning Objectives

- Explain why testing is crucial for analytics.
- Explain the role of testing in analytics engineering.
- Configure and run generic tests in dbt.
- Write, configure, and run specific tests in dbt.

---

---

---

## What is testing?

É criar assertivas e garantir que seus dados estejam de acordo com elas. Sâo necessárias para que seus dados estejam integros e asism possa gerar BI/ML/Analytics corretos.

Usamos para garantir que os dados estâo corretos e com alta qualidade.

Pra rodar os tests no dbt basta digitar:

```
dbt run tests
```

E assim rodará todos os testes do projeto.

Você pode testar sobre os seus models e até mesmo sobre o que vai em produção.

Há duas classes de testes:
+ Singuar tests
  + **Testar com uma consulta SQL Customizada**
  + Testar algo bem específico. 
  + Pega 1 ou 2 models no máximo
+ Generics test
  + **Definir testes bem específicos em arquiv `.yml`**
  + `unique`
  + `not_null`
  + `accepted_values`
  + `relationships`
+ Há também pacaotes que exploram outras possibilidades ou você mesmo pode fazer seu próprio pacote

### Generic tests

Os 4 testes genéricos.

Como fazer:

1 - Crie um arquivo `.yml` junto na pasta model.
  - Seguindo o nosso exemplo temos os seguinte: `models/staging/jaffle_shop/stg_jaffle_shop.yml`

```yml
version: 2

models:
  - name: stg_customers
    columns: 
      - name: customer_id
        tests:
          - unique
          - not_null
```

Executando

```
dbt test -s stg_customers
```

Onde com a flag `-s` você pode especificar qual model será testado exclusivamente.

O DBT vai compilar em linguagem DML/DLL/SQL e conferir.

### Testing Sources

`models/staging/jaffle_shop/src_jaffle_shop.yml`

Para executar soomente os tetes dos arquivos `.yml` digite

```
dbt test --select source:jaffle_shop
```

```yml
version: 2

sources:
  - name: jaffle_shop
    database: raw
    schema: jaffle_shop
    tables:
      - name: customers
        columns:
          - name: id
            tests:
              - unique
              - not_null
            
      - name: orders
        columns:
          - name: id
            tests:
              - unique              
              - not_null
        loaded_at_field: _etl_loaded_at
        freshness:
          warn_after: {count: 12, period: hour}
          error_after: {count: 24, period: hour}
```



### Singular tests

É necessário criar um arquivo `.sql` para a consulta customizada:

`tests/assert_positive_total_for_payments.sql`

```sql
-- Refunds have a negative amount, so the total amount should always be >= 0.
-- Therefore return records where this isn't true to make the test fail.
select
    order_id,
    sum(amount) as total_amount
from {{ ref('stg_payments') }}
group by 1
having not(total_amount >= 0)
```

**dbt Commands**

+ Execute dbt test to run all generic and singular tests in your project.
+ Execute dbt test `--select test_type:generic` to run only generic tests in your project.
+ Execute dbt test `--select test_type:singular` to run only singular tests in your project.

----

----

----

## Practice

Using the resources in this module, complete the following exercises in your dbt project:

### Generic Tests

- Add tests to your jaffle_shop staging tables:
  - Create a file called `stg_jaffle_shop.yml` for configuring your tests.
  - Add `unique` and `not_null` tests to the keys for each of your staging tables.
  - Add an `accepted_values` test to your `stg_orders` model for status.
  - Run your tests.

```yaml
models/staging/jaffle_shop/stg_jaffle_shop.yml
version: 2

models:
  - name: stg_customers
    columns: 
      - name: customer_id
        tests:
          - unique
          - not_null

  - name: stg_orders
    columns:
      - name: order_id
        tests:
          - unique
          - not_null
      - name: status
        tests:
          - accepted_values:
              values:
                - completed
                - shipped
                - returned
                - return_pending
                - placed
```

### Singular Tests

- Add the test `tests/assert_positive_value_for_total_amount.sql` to be run on your `stg_payments` model.
- Run your tests.

```
tests/assert_positive_value_for_total_amount.sql
-- Refunds have a negative amount, so the total amount should always be >= 0.
-- Therefore return records where this isn't true to make the test fail.
select
  order_id,
	sum(amount) as total_amount
from {{ ref('stg_payments') }}
group by 1
having not(total_amount >= 0)
```

### Extra Credit

- Add a `relationships` test to your `stg_orders` model for the customer_id in `stg_customers.`
- Add tests throughout the rest of your models.
- Write your own specific tests.

## Exemplar

Add a `relationships` test to your `stg_orders` model for the customer_id in `stg_customers.`

```
**models/staging/jaffle_shop/stg_jaffle_shop.yml**
version: 2

models:
  - name: stg_customers
    columns: 
      - name: customer_id
        tests:
          - unique
          - not_null
  - name: stg_orders
    columns: 
      - name: order_id
        tests:
          - unique
          - not_null
      - name: status
        tests:
          - accepted_values:
              values:
                - completed
                - shipped
                - returned
                - placed
                - return_pending
      - name: customer_id
        tests:
          - relationships:
              to: ref('stg_customers')
              field: customer_id
```

## Review

### Testing

- **Testing** is used in software engineering to make sure that the code does what we expect it to.
- In Analytics Engineering, testing allows us to make sure that the SQL transformations we write produce a model that meets our assertions.
- In dbt, tests are written as select statements. These select statements are run against your materialized models to ensure they meet your assertions.

### Tests in dbt

- In dbt, there are two types of tests - schema tests and data tests:
  - **Generic tests** are written in YAML and return the number of records that do not meet your assertions. These are run on specific columns in a model.
  - **Singular tests** are specific queries that you run against your models. These are run on the entire model.
- dbt ships with four built in tests: unique, not null, accepted values, relationships.
  - **Unique** tests to see if every value in a column is unique
  - **Not_null** tests to see if every value in a column is not null
  - **Accepted_values** tests to make sure every value in a column is equal to a value in a provided list
  - **Relationships** tests to ensure that every value in a column exists in a column in another model (see: [referential integrity](https://en.wikipedia.org/wiki/Referential_integrity))
- Generic tests are configured in a YAML file, whereas singular tests are stored as select statements in the tests folder.
- Tests can be run against your current project using a range of commands:
  - `dbt test` runs all tests in the dbt project
  - `dbt test --select test_type:generic`
  - `dbt test --select test_type:singular`
  - `dbt test --select one_specific_model`
- Read more here in [testing documentation](https://docs.getdbt.com/reference/node-selection/test-selection-examples).
- In development, dbt Cloud will provide a visual for your test results. Each test produces a log that you can view to investigate the test results further.

![img](https://files.cdn.thinkific.com/file_uploads/342803/images/5aa/5ee/52f/testing-dev.png)

In production, dbt Cloud can be scheduled to run `dbt test`. The ‘Run History’ tab provides a similar interface for viewing the test results.

![img](https://files.cdn.thinkific.com/file_uploads/342803/images/412/557/27e/testing-prod.png)



## Questions

+ 1 - What file type is used for specifying which generic tests to run by model and column?

  + `.yml`

+ 2 - What are the four generic tests that dbt ships with?

  + Not_null, unique, relationships, accepted_values

+ 3 - In what folder should singular tests be saved in your dbt project?

  + tests

+ 4 - What command would you use to only run tests configured on a source named my_raw_data?

  + ```
    dbt test --select source:my_raw_data
    ```

    

+ 5 - Based on the YAML file below, which one of the following statements is true?

  + ```
    models:
      - name: customers
        columns: 
          - name: customer_id
            tests:
              - not_null
      - name: payments
        columns: 
          - name: payment_id
            tests:
              - unique
              - not_null
          - name: payment_method
            tests:
              - accepted_values:
                  values: 
                    - credit_card
                    - ach_transfer
                    - paypal
      - name: orders
        columns: 
          - name: order_id
            tests:
              - unique
    
    ```

  + The accepted values test will fail if one of the values in the payment_method column is not equal to credit_card, paypal, or ach_transfer

+ 6 -  How do you associate a singular test with a particular dbt model or source?

  + Using the ref or source macro in the SQL query in the singular test file

+ 7 - What query would you use to create a singular test to assert that no record in cool_model has a value in Column A that is less than the value in  Column B?

  + ```
    select * from {{ ref( ‘cool_model’) }} where Column A < Column B
    ```

+ 8 - What is most likely true if a generic test on your sources fails?

  + An assumption about your raw data is no longer true
