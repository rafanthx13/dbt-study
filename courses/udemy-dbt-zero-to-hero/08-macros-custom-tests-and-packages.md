# Macros, Custom Tests and Packages

img-24

## O que sâo macros

São templates Jinja que você pode criar de forma personalizado no seu projeto podendo usar nas pastas  `models/` e `test/`

Existe a macro special chamada `test` que permite criar seu próprio generic test

## Criando uma macro

`macros/no_nulls_in_columns.sql`

```
{% macro no_nulls_in_columns(model) %}
	SELECT * FROM {{ model }} WHERE
		{% for col in adapter.get_columns_in_relation(model) -%}
			{{ col.column }} IS NULL OR
		{% endfor %}
	FALSE
{% endmacro %}
```

O jinja permtite criiar coisa como variaveis, IF e for. Busque masi na documentação.

**O que está fazendo**
+ Vai verificar várias colunas com OR e no final da expressâo terá o FALSE que é nulo no 'OR'.
+ Lembrnaod que  jinja é compilado depois

Agora vamos criar o nosso testse que vai usar essa macro

`tests/no_nulls_in_dim_listings.sql`

```
{{ no_nulls_in_columns(ref('dim_listings_cleansed')) }}

## Criando um generic test como macro

usamos a macro `test` para dizer que é onosso generic test

`macros/positive_value.sql`

```
{% test positive_value(model, column_name) %}
SELECT
*	
FROM
	{{ model }}
WHERE
	{{ column_name}} < 1
{% endtest %}
```

Para usála, colocamos em  `schema.yml`

```yml
    - name: minimun_nights
      tests:
        - positive_value
```
 deps de dependencies
## Usando pacotes do dbt

Site com os packages: hub.getdbt.com

Você só precisa colocar em `package.yml` que fica na raiz do projeto (caso ao tiver,cire ele)

Pra instalar o package você executa `dbt deps`

Vamos usar algumas macros no arquivo de `fact`

`models/fct_reviews.sql`

```sql
{{
	config(
		materialized = 'incremental',
		on_schema_change='fail'
	)
}}

WITH src_reviews AS (
	SELECT * FROM {{ ref('src_reviews') }}
)

SELECT
	{{ dbt_utils.surrogate_key(['listing_id', 'review_date', 'reviewer_name', 'review_text']) }} AS review_id,
	*
FROM 
	src_reviews
WHERE 
	review_text is not null
{% if is_incremental() %}
	AND review_date > (select max(review_date) from {{ this }})
{% endif %}
```

