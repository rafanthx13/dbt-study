# Tests

img-22

## 2 tipso de test

img-23

**Singular Test**:
+ É uma consulta SQL que se espera retornar null
+ Se retornar algo quer dizer que não passou

**Generic Test**:
+ Há 4 defaults: `unique`, `not_null`, `accepted_values`, `Relashioships` mas vocÊ também pode usar mais pacotes com masi opçoes ou até mesmo especificar o seu própri coonstarint

## Generic Test

Sâo definiidos no arquivo `schema.yml` na própria pasta `models/`

```yml
version: 2

models:
  - name: dim_listings_cleansed
    columns:
    
    - name: listing_id
      tests:
        - unique
        - not_null

    - name: host_id
        tests:
          - not_null
          - relationships:
              to: ref('dim_hosts_cleansed')
              field: host_id

    - name: room_type
      tests:
        - accepted_values:
          values: ['Entire home/apt',
            'Private room',
            'Shared room',
            'Hotel room']
```

Execute `dbt test` para executar só os teests.

## Singular Test

Sâo os tests feito com SQL statement

Você coloca eles na pasta `test/`

```sql
SELECT
	*	
FROM
	{{ ref('dim_listings_cleansed') }}
WHERE minimum_nights < 1
LIMIT 10
```

Para executar só esse test unicamente, use o código a seguir:

```sh
dbt test --select dim_listings_cleansed
```

**Outro Singular Test**

`tests/consistent_created_at.sql`

```sql
SELECT * FROM {{ ref('dim_listings_cleansed') }} l
INNER JOIN {{ ref('fct_reviews') }} r
USING (listing_id)
WHERE l.created_at >= r.review_date
```


```
