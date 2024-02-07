# 05 - Apredentendo DBT apartir de um projeto prático

![img-01](img/udemy-fa-dbt-01.png)

## Repositório do projeto final

https://github.com/FernandoAmara/dbtproject

## O que será feito

+ 1 - Remover clientes duplicados (tabela customers)
  + Quando uma pessoa tem o mesmo par de ``company_name`` e ``contact_name``
  
+ 2 - Criar algumas colunas calculadas (tabela employees)
  + Age (birth_date)
  + length_of_service (a partir do hire_date)
  + nome completo (first_name + last_name)

+ 3 - Detalhes do pedido
  + Calcular o total e discount da tabela `order_detail` usando dados da tabela `products`

+ 4 - Desnormalizar tabelas para criar uma tabela Fato de DW
  + Vamos criar várias tabelas para ter várias views de forma a ter uma tabela fato final muito boa para consulta DW

+ 5 - Particionamento
  + Vamos particionar por `order.order_date` para termos uma tabela para cada ano, 2012, 2022, 2023

+ OBS: Uma vez feitas essas modificações, criamos uma nova tabela, assim, deixamos de usar `source` e passamos a usar `ref`

## 01 - source.yaml

Definimos o arquivo de `source.yaml` para especificar de onde vai vir os dados e quais são as tabelas

````yaml
version: 2

sources:
    - name: sources # nome a ser usado no dbt para definir esse source
      database: dbt-study-412923 #database do bigQuery
      schema: dbt_example # schem do Bigquery
      tables: # Tabelas que vamos pegar do bigQuery
        - name: categories
        - name: products
        - name: suppliers
        - name: employees
        - name: order_details
        - name: customers
        - name: orders
        - name: shippers
````

## 02 - Arquivo `customers.sql`

Podemos começar esse arquivo de duas formas

````sql
select * from {{source('sources','customers')}}

-- Ou dessa outra, referenciando direto
-- select * from `dbt-study-412923.dbt_example.customers`
````

Após fazer isso, clique em preview que assim **VAI EXECUTAR A CONSULTA E MOSTRAR O RESULTADO, MAS AINDA A TABELA NÃO FOI GERADA**

![img-01](img/udemy-fa-dbt-05.png)

Se você voltar no `source.yaml` vai perceber que na parte de `Lineage` você consegue ver que esse arquivo está referenciando uma das tabelas definadas no arquivo.

![img-01](img/udemy-fa-dbt-04.png)

O arquiv ficará: 

````sql
--customer model

-- Etapa 1 - Usamos WINDOWS FUNCTIONS para adicionar uma coluna que vai ter valor
with markup as (
    select * , 
    first_value(customer_id)
    over(
        partition by company_name, contact_name -- vou particionar por essa colunas
        order by company_name -- ordenar pelo nome, nesse caso, é totalmente opcional
        rows between unbounded preceding and unbounded following -- A windows vai começar na 1° janela da particao
    ) as result
    from {{source('sources','customers')}}
), removed as (
    select distinct result from markup
), final as (
    select * from {{source('sources','customers')}} 
    where customer_id in (select result from removed)
)

select * from final
-- Antes eram 94 linhas, ao ifnal, deverá ser 91 linhas
````

Agora execute para consolidar mesmo

````sh
dbt run 
````

mas no caso podemos só especificar e rodar um unico modelo:

````sh
$ dbt run --select customer
````

E assim dever aparecer um novo schema contendo essa view nova lá no DW..

OBS: Pode ser necessário
+ Fazer PR da branch para outra
+ Fazer um `dbt build` e resetar as coisas.
  
Aí deve aparecer como a imagem a seguir, onde mostra um novo schema, com só view, no caso no meu nome.

![img-01](img/udemy-fa-dbt-06.png)