# Documentation

## Learning Objectives

- Explain why documentation is crucial for analytics.
- Understand the documentation features of dbt.
- Write documentation for models, sources, and columns in .yml files.
- Write documentation in markdown using doc blocks.
- Generate and view documentation in development.
- View and navigate the lineage graph to understand the dependencies between models.

----

----

----

## O que é a documentação?

Para Data Analytics, serve para saber de onde está vindo os dados.

O dbt faz a documentação já pela *lineage* das DAGs.

Mas você também pode por a sua própria descrição apra enriquecer.

A documentação no dbt acontece enquanto você construiu o *model* no mesmo lugar,  no mesmo arquivo.

### Colocando doc no model `.yml`

**FORMA 1** por `description` no `name` e nas `columns`

**FORMA 2** : Ao inveś de por só uma descriçâo é possível referenciar a um arquivo markdown

Exemplo: Para o yml a seguir, colocou-se algumas docs

`models/staging/jaffle_shop/stg_jaffle_shop.yml`

```
version: 2

models:
  - name: stg_customers
    description: Staged customer data from our jaffle shop app.
    columns: 
      - name: customer_id
        description: The primary key for customers.
        tests:
          - unique
          - not_null

  - name: stg_orders
    description: Staged order data from our jaffle shop app.
    columns: 
      - name: order_id
        description: Primary key for orders.
        tests:
          - unique
          - not_null
      - name: status
        description: "{{ doc('order_status') }}"
        tests:
          - accepted_values:
              values:
                - completed
                - shipped
                - returned
                - placed
                - return_pending
      - name: customer_id
        description: Foreign key to stg_customers.customer_id.
        tests:
          - relationships:
              to: ref('stg_customers')
              field: customer_id
```

Perceba que em `description: "{{ doc('order_status') }}"` deve referenicar um arquivo, que seria o a aeguir

`models/staging/jaffle_shop/\**jaffle_shop.md`

```
{% docs order_status %}
	
One of the following values: 

| status         | definition                                       |
|----------------|--------------------------------------------------|
| placed         | Order placed, not yet shipped                    |
| shipped        | Order has been shipped, not yet been delivered   |
| completed      | Order has been received by customers             |
| return pending | Customer indicated they want to return this item |
| returned       | Item has been returned                           |

{% enddocs %}
```

### Documentado sources

Docuemntar os arquivos de `src` é da mesma forma que os  `models`

Para gera a documentação

```
dbt docs generate
```

Na IDE dbt vai gerar no topo um link para ir e conferir a documentação gerada.

----

----

----

## Practice

Using the resources in this module, complete the following in your dbt project:

### Write documentation

- Add documentation to the file `models/staging/jaffle_shop/stg_jaffle_shop.yml`.
- Add a description for your `stg_customers` model and the column `customer_id`.
- Add a description for your `stg_orders` model and the column `order_id`.

### Create a reference to a doc block

- Create a doc block for your `stg_orders` model to document the `status` column.
- Reference this doc block in the description of `status` in `stg_orders`.

**`models/staging/jaffle_shop/stg_jaffle_shop.yml`**

```yaml
version: 2

models:
  - name: stg_customers
    description: Staged customer data from our jaffle shop app.
    columns: 
      - name: customer_id
        description: The primary key for customers.
        tests:
          - unique
          - not_null

  - name: stg_orders
    description: Staged order data from our jaffle shop app.
    columns: 
      - name: order_id
        description: Primary key for orders.
        tests:
          - unique
          - not_null
      - name: status
        description: "{{ doc('order_status') }}"
        tests:
          - accepted_values:
              values:
                - completed
                - shipped
                - returned
                - placed
                - return_pending
      - name: customer_id
        description: Foreign key to stg_customers.customer_id.
        tests:
          - relationships:
              to: ref('stg_customers')
              field: customer_id
```

**`models/staging/jaffle_shop/jaffle_shop.md`**

```
{% docs order_status %}
	
One of the following values: 

| status         | definition                                       |
|----------------|--------------------------------------------------|
| placed         | Order placed, not yet shipped                    |
| shipped        | Order has been shipped, not yet been delivered   |
| completed      | Order has been received by customers             |
| return pending | Customer indicated they want to return this item |
| returned       | Item has been returned                           |

{% enddocs %}
```

### Generate and view documentation

- Generate the documentation by running `dbt docs generate`.
- View the documentation that you wrote for the `stg_orders` model.
- View the Lineage Graph for your project.

### Extra Credit

- Add documentation to the other columns in `stg_customers` and `stg_orders`.
- Add documentation to the `stg_payments` model.
- Create a doc block for another place in your project and generate this in your documentation.





## Review

### Documentation

- Documentation is essential for an analytics team to work effectively and efficiently. Strong documentation empowers users to self-service questions about data and enables new team members to on-board quickly.
- Documentation often lags behind the code it is meant to describe. This can happen because documentation is a separate process from the coding itself that lives in another tool.
- Therefore, documentation should be as automated as possible and happen as close as possible to the coding.
- In dbt, models are built in SQL files. These models are documented in YML files that live in the same folder as the models.

### Writing documentation and doc blocks

- Documentation of models occurs in the YML files (where generic tests also live) inside the models directory. It is helpful to store the YML file in the same subfolder as the models you are documenting.
- For models, descriptions can happen at the model, source, or column level.
- If a longer form, more styled version of text would provide a strong description, **doc blocks** can be used to render markdown in the generated documentation.

### Generating and viewing documentation

- In the command line section, an updated version of documentation can be generated through the command `dbt docs generate`. This will refresh the `view docs` link in the top left corner of the Cloud IDE.
- The generated documentation includes the following:
  - Lineage Graph
  - Model, source, and column descriptions
  - Generic tests added to a column
  - The underlying SQL code for each model
  - and more...



## Questions

+ 1 - What command will generate documentation for your project in development?
  
  + ```
    dbt docs generate
    ```
  
    
+ 2 - Which one of the following statements is true about documentation in dbt?
  
  + dbt will automatically pull descriptions from your dbt project and metadata about your models and sources into the documentation site
+ 3 - What is the correct way to reference the doc block called ‘orders’, contained in a file `called docs_jaffle_shop.md`?
  
  + ```
    description: ‘{{ doc(“orders”) }}’
    ```
  
    
+ 4 - What aspects of the generated DAG can help you understand your data flow?
  
  + B & C
    + B: Descriptions of the models listed in the lineage graph help you see exactly what each model does
    + C: The selector can help narrow the scope of the shown DAG, which allows you to see how your specific model is used upstream and/or downstream
