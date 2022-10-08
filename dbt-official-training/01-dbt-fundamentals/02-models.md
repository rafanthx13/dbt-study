# Models

## Learning Objectives

+ Explain what models are in a dbt project.
+ Build your first dbt model.
+ Explain how to apply modularity to analytics with dbt.
+ Modularize your project with the ref function.
+ Review a brief history of modeling paradigms.
+ Identify common naming conventions for tables.
+ Reorganize your project with subfolders.

## O que são Models

Modeling é a modelagem de como converter o dado raw até a forma final tranformado.

No dbt, models sâo SQL SELECT statements no seu projeto.

Cada um rerpesenta uma peça lógica do seu processo de tansformaçao. 

COmo functiona:
+ Eles ficam na pasta 'models'
+ Cada model tem relaao 1:1 com a tabela/view do DW
+ Você vai escreevr o seu SQL SELECT e o DBT vai cuidad do DDL/DML para materializar aquilo no seu DW.

## Building yout first model

Note about UI changes in dbt Cloud:

As the dbt evolves, you will notice that the videos don't exactly match the latest version of dbt. For example, 'Run SQL' is now 'Preview'. The command `dbt run --models` (or `dbt run -m`) has been replaced by `dbt run --select` (or `dbt run -s)`. If you need clarification on anything, please post in #learn-on-demand in the dbt Community Slack.

`dim_customers.sql`

```sql
with customers as (

    select
        id as customer_id,
        first_name,
        last_name

    from raw.jaffle_shop.customers

),

orders as (

    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status

    from raw.jaffle_shop.orders

),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),


final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders

    from customers

    left join customer_orders using (customer_id)

)

select * from final
```

bloco de configurçao apra ao invez de criar view criar uma tabela (coloque ele na primeira linha)

```
{{ config (
    materialized="table"
)}}
```

**OBS BigQuery**

O exemplo do curso utilzia snowflake, mas estou usando bigquery. Para pegar o equivalente em bigquery use o site

https://docs.getdbt.com/guides/getting-started/building-your-first-project/build-your-first-models


```sql
with customers as (

    select
        id as customer_id,
        first_name,
        last_name

    from `dbt-tutorial`.jaffle_shop.customers

),

orders as (

    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status

    from `dbt-tutorial`.jaffle_shop.orders

),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders

    from customers

    left join customer_orders using (customer_id)

)

select * from final
```

Essa consulta funciona tanto no bigquery quanto no dbt

## What is modularity?

O que  fizeoms em `dim_customers.sql`

 Basicament epgamos 3 tabelas, com as 2 CTE e pegamos somentes os dados que queriamos delas. E no final nos juntamos tudo.

É asism que o dbt é usado, cheio de CTE para tornar as coisa ais modulares, pedaço por pedaço.

Isos se chama modularizaço, ao invez de fazer tudo de uma vez, vamos coms os models do dbt, vamos tambem modularizar em:

stg_customers, stg_orders, e por fim dim_costumers que e=é o o final.

Ao fazer com esse 2 stg_customers **PODEMOS REAPORIVETAR ESSE MESMO CÓDIGO EM OUTROS ARQUIVOS,É como salavar uma CTE. E isso só é possíveln  o dbt**

no big querry

==> `models/stg_customers.sql`

```sql
select
    id as customer_id,
    first_name,
    last_name

from `dbt-tutorial`.jaffle_shop.customers
```

==> `models/stg_orders.sql`

```sql
select
    id as order_id,
    user_id as customer_id,
    order_date,
    status

from `dbt-tutorial`.jaffle_shop.orders
```

==> `models/customers.sql`

```sql
with customers as (

    select * from {{ ref('stg_customers') }}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders

    from customers

    left join customer_orders using (customer_id)

)

select * from final
```

O que quermos fazer é

![img-07](/home/rhavel/Documentos/DATA-ENGINEERING-PROJECTS/dbt-study/dbt-official-training/imgs/img-07.jpeg)

exxecute tudo com 'dbt run'

deu certo

![img-08](/home/rhavel/Documentos/DATA-ENGINEERING-PROJECTS/dbt-study/dbt-official-training/imgs/img-08.png)

usamos `{{ ref('stg_orders') }}` para referenciar outro model, se nao estiver startado entao ele o será;

**Dessa formas podemos criar pequenos script sql e reaproveitálos com dbt**

## Quick history of data modeling

Traditional Modelinsg

+ Star Schema
+ Kimball
+ Data Vault

Mas aqui no dbt, devido ao grande poder computacional de cloud, vamos trablhar com desnormalzçao, chamada dtambe de 'agile analitysc' 'ad hoc analytics'

### Naming conventions

Convençâo para os Models no dbt

+ Sources Models (/sórci)
 - The raw data que já está carregado

+ Staging Models (/isteigin)
  - Limpa e normaliza os dados,
  - relaciona um a um com uma tabela source

+ Intermediate MOdels
  - Usam os models staging, está entre a camada de staging e a do modelo final

+ Fact Model
  - Serve para registar coisa que aconteceram
  - Tabela com poucas colunas mas muitas linhas
  - Registras, clisk, eventos, votos

+ Dim Models
  - Represetna coisa que existem mesmo
  - Exmeplo: pesosa, ususarios, companias, produtos, clientse


esse será o projeto que vaoms cria rneste curso

O que está em verde sao os sources.

![img-07](/home/rhavel/Documentos/DATA-ENGINEERING-PROJECTS/dbt-study/dbt-official-training/imgs/img-09.png)




### Reorganize your project

Vamos regorganiar o nosos projeto e deixar como o da imagme acima

E vamos muda ro aqruivo `dbt_project.yml` na parte de modls e por:

```
models:
  jaffle_shop:
    marts:
      core:
        materialized:table
  staging:
      materialized: view
```

E modar a pasta de modls para o seguinte formato

```
├── models
    └── marts
        └── core
            └── dim_customers.sql  
    └── staging
        └── jaffle_shop
            ├── stg_customers.sql
            └── stg_orders.sql 
```





----

Apartir de agor aé proposto um exercício e msotrado uma solução

----

## Practice

Using the resources in this module, complete the following in your dbt project:

## Quick Project Polishing

- In your `dbt_project.yml` file, change the name of your project from `my_new_project` to `jaffle_shop` (line 5 AND 35)

## Staging Models

- Create a `staging/jaffle_shop` directory in your models folder.
- Create a `stg_customers.sql` model for `raw.jaffle_shop.customers`

```sql
select
    id as customer_id,
    first_name,
    last_name

from raw.jaffle_shop.customers
```

- Create a `stg_orders.sql` model for `raw.jaffle_shop.orders`

```sql
select
    id as order_id,
    user_id as customer_id,
    order_date,
    status

from raw.jaffle_shop.orders
```

## Mart Models

- Create a `marts/core` directory in your models folder.
- Create a `dim_customers.sql` model

```sql
with customers as (

    select * from {{ ref('stg_customers')}}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders

    from customers

    left join customer_orders using (customer_id)

)

select * from final
```

## Configure your materializations

- In your `dbt_project.yml` file, configure the staging directory to be materialized as views.

```yaml
models:
  jaffle_shop:
    staging:
      +materialized: view
```

- In your `dbt_project.yml` file, configure the marts directory to be materialized as tables.

```yaml
models:
  jaffle_shop:
  ...
    marts:
      +materialized: table
```

## Building a fct_orders Model

***This part is designed to be an open ended exercise - see the exemplar on the next page to check your work.***

- Use a statement tab or Snowflake to inspect `raw.stripe.payment`

- Create a `stg_payments.sql` model in `models/staging/stripe`

- Create a

   

  ```
  fct_orders.sql
  ```

   

  (not

   

  ```
  stg_orders
  ```

  ) model with the following fields.  Place this in the

   

  ```
  marts/core
  ```

   

  directory.

  - order_id
  - customer_id
  - amount (hint: this has to come from payments)

## Refactor your dim_customers Model

- Add a new field called

   

  ```
  lifetime_value
  ```

   

  to the

   

  ```
  dim_customers
  ```

   

  model:

  - `lifetime_value`: the total amount a customer has spent at `jaffle_shop`
  - Hint: The sum of lifetime_value is $1,672



## Exemplar

## Self-check `stg_payments`, `orders`, `customers`

*Use this page to check your work on these three models.*

**`staging/stripe/stg_payments.sql`**

```sql
select
    id as payment_id,
    orderid as order_id,
    paymentmethod as payment_method,
    status,

    -- amount is stored in cents, convert it to dollars
    amount / 100 as amount,
    created as created_at

from raw.stripe.payment 
```

**`marts/core/fct_orders.sql`**

```sql
with orders as  (
    select * from {{ ref('stg_orders' )}}
),

payments as (
    select * from {{ ref('stg_payments') }}
),

order_payments as (
    select
        order_id,
        sum(case when status = 'success' then amount end) as amount

    from payments
    group by 1
),

final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce(order_payments.amount, 0) as amount

    from orders
    left join order_payments using (order_id)
)

select * from final
```

**`marts/core/dim_customers.sql`** 

*Note: This is different from the original `dim_customers.sql` - you may refactor `fct_orders` in the process.

```sql
with customers as (
    select * from {{ ref('stg_customers')}}
),
orders as (
    select * from {{ ref('fct_orders')}}
),
customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
        sum(amount) as lifetime_value
    from orders
    group by 1
),
final as (
    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        customer_orders.lifetime_value
    from customers
    left join customer_orders using (customer_id)
)
select * from final
```

## Questions

+ 1 - In the dbt context, what is a model?
  + A select statement written in SQL
+ 2 - What file type is used for building a model?
  + .sql
+ 3 - What is the default materialization of a model if you don't proactively configure the 3 -materialization for a model?
  + View
+ 4 - A given model called `events` is configured to be materialized as a view in dbt_project.yml and configured as a table in a config block at the top of the model. When you execute dbt run, what will happen in dbt?
  + dbt will build the `events` model as a table (local tem mais poder que o clobal)
+ 5 - How do you build dependencies between models?
  + Use the 'ref' function in the from clause of a model
+ 6 - Which command below will attempt to only materialize dim_customers and its downstream models
  + É letra C
+ 7 - Which one of the following is true about staging models as defined in this course?
  + Staging models are used to perform light touch transformations to shape the data to how you wish it looked
+ 8 - Which of the following is a benefit of using subdirectories in your models directory?
  + Subdirectories allow you to configure materializations at the folder level for a collection of models