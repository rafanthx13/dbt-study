# Documentatition

img-26

## ONde é feito a documentation

img-27

Feita em dois lugares:

+ EM arquivos `.yml`, você até pode aproveitar o `schema.yml`
+ EM arquivos markdown, e depois sâo referenciados em um aarquivo `.yml`

```yml
version: 2

models:
  - name: dim_listings_cleansed
    description: Cleansed table which contains Airbnb listings.
    columns:

      - name: listing_id
        description: Primary key for the listing
        tests:
          - unique
          - not_null
      
      - name: host_id
        description: The hosts's id. References the host table.
        tests:
          - not_null
          - relationships:
              to: ref('dim_hosts_cleansed')
              field: host_id

      - name: room_type
        description: Type of the apartment / room
        tests:
          - accepted_values:
              values: ['Entire home/apt', 'Private room', 'Shared room', 'Hotel room']


      - name: minimum_nights
        description: '{{ doc("dim_listing_cleansed__minimum_nights") }}'
        tests:
          - positive_value

  - name: dim_hosts_cleansed
    columns:
      - name: host_id
        tests:
          - not_null
          - unique

      - name: host_name
        tests:
          - not_null

      - name: is_superhost
        tests:
          - accepted_values:
              values: ['t', 'f']

  - name: fct_reviews
    columns:
      - name: listing_id
        tests:
          - relationships:
              to: ref('dim_listings_cleansed')
              field: listing_id

      - name: reviewer_name
        tests:
          - not_null

   - name: review_sentiment
   tests:
     - accepted_values:
         values: ['positive', 'neutral', 'negative']
```

Você gera com

```sh
dbt docs generate
```

Vai gerar os arquivos de docs na pasta `target/`

Depois apra cria o webserve

```sh
dbt docs serve
```

Vai criar um server na porta 8080

## Documentar com markdown

Na description ao invés de vocÊ colocar uma string/texto você especifica o arquivo markdown

```
        description: '{{ doc("dim_listing_cleansed__minimum_nights") }}'
```

**ARQUIVOS MARKDOWN**

`models/docs.md`

```
{% docs dim_listing_cleansed__minimum_nights %}

Minimum number of nights required to rent this property.
Keep in mind that old listings might have `minimum_nights` set
to 0 in the source tables. Our cleansing algorithm updates this to `1`.

{% enddocs %}
```

**ARQUIVO OVERVIEW**

Podeos configurar o arquivo inicial que abre o serve do docs pelo arquiv `overview.md`. demos que por `__overview`__` para fazer isso.

`models/overview.md`

```
{% docs __overview__ %}
# Airbnb pipeline

Hey, welcome to our Airbnb pipeline documentation!
Here is the schema of our input data:

![input schema](https://dbtlearn.s3.us-east-2.amazonaws.com/input_schema.png)
{% enddocs %}
```

**ASSET PATH**

Especifique no arquivo `dbt_project.yml` o `asset-path` para pegar arquivos de iamgme do repo para fazer o server.

Assim ao invés de chamar por

```
![input schema](https://dbtlearn.s3.us-east-2.amazonaws.com/input_schema.png)
```

chama por

```
![input schema](assets/input_schema.png)
```
