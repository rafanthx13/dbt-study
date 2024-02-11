# Materialization

O que vamos ver nesa seçao

img-15

## 4 formas de materializaçâo

img-16

+ View
  + Usamos quando nâo queremos recriar uma tabela. Deve ser algo leve pois como é uma view, vai executar um select toda vez que é chamadas
+ Table
  + Vai criar relamente uma tabela na ao executar o dbt
  + Será recriada toda vez que executarmos o pipeline
  
+ Incremental
  + Serácomoo o table mas vai incrementar a tabela já existente com novos dados ao invez de reocmeçar tudo do zero .
  + Uasmo para apenas adicionar novos registros. Ideal apra tabelas fato

+ Ephmereal
  + É uma forma de simplicar. Serve mais apra ser um apelido par alguma tabela
  + Usamo apra simplificar umpaso intermediário do nosso ETL

## Criando algumas dimensões

img-17

Garanta que tenha os `SRC` nas view do Schema `dev` no SNowflake

Vamos criar as tabelas dimensôes e as tabelas fato

`models/dim/dim_listings_cleansed.sql`

```sql
WITH src_listings AS (

 SELECT *
 FROM {{ ref('src_listings') }}

)
SELECT
 listing_id,
 listing_name,
 room_type,
 CASE
  WHEN minimum_nights = 0 THEN 1
  ELSE minimum_nights
 END AS minimum_nights,
 host_id,
 REPLACE(
  price_str,
  '$'
  ) :: NUMBER(
  10,
  2
 ) AS price,
 created_at,
 updated_at
FROM
 src_listings
```

```sql
{
 config(
 materialized = 'view'
)
}}

WITH src_hosts AS (
 SELECT
  *
 FROM
  {{ ref('src_hosts') }}
)
SELECT
 host_id,
 NVL(
  host_name,
  'Anonymous'
 ) AS host_name,
 is_superhost,
 created_at,
 updated_at
FROM
 src_hosts
```

**Observaçôes**

+ 1 - Estamos usando jinja em `{{ ref('src_hosts') }}`, ou seja, vai buscar o model de noome `src_host.sql` e de lá será nosso `source`
+ 2 - NLV serve como ReplaceNullValue, o que tiver nulo na copluna *param1* será substituido por *param2*

## Especifiando as formas de materializaçô

Favemos isso em `dbt_project.yml` na raiz do projeto dbt.

No techo a seguir forçamsos a por sempre view e para o que estiver  na pasta dim, vai se materrializar com table

```yaml
models:
  dbtlearn:
    +materialized: view
    dim:
      +materialized: table
```

## Criando tabela fato

`fct/fct_reviews.sql`

```sql
-- Especificando 'incremntal' matealization
{{
 config(
  materialized = 'incremental',
  on_schema_change='fail'
 )
}}

WITH src_reviews AS (
 SELECT * FROM {{ ref('src_reviews') }}
)

SELECT * FROM src_reviews
WHERE review_text is not null
-- Especificando como fazer esse incremental
{% if is_incremental() %}
 AND review_date > (select max(review_date) from {{ this }})
{% endif %}
```

Oque estamos fazendo:

+ Vai ser do tipo incremental, e se o schema da tabela mudar vai falahar, porque nao pdoe tentar incrementar em outro formato
+ Perceba queo condigo de baixao será executado se for incremntal (que é o nosso caso)

Eeceute com `dbt run`

Agora para tetsar o cinremntal faça o seguite:

+ 1 - `INSERT INTO "AIRBNB"."RAW"."RAW_REVIEWS"
VALUES (3176, CURRENT_TIMESTAMP(), 'Zoltan', 'excellent stay!', 'positive');`

+ 3- O seguinte comando apra ver se o incremental foi mesmo eecutado
  + SELECT * FROM "AIRBNB"."DEV"."FCT_REVIEWS" WHERE listing_id=3176;

+ 2 - Execute `dbt run --full-refresh` para executar tudo do zero, caso prceisar

## última tabela dimensao e tabela ephemeral

`dim/dim_listings_w_hosts.sql`

```sql
WITH
l AS (
 SELECT
  *
 FROM
  {{ ref('dim_listings_cleansed') }}
),

h AS (
 SELECT *
 FROM {{ ref('dim_hosts_cleansed') }}
)

SELECT
 l.listing_id,
 l.listing_name,
 l.room_type,
 l.minimum_nights,
 l.price,
 l.host_id,
 h.host_name,
 h.is_superhost as host_is_superhost,
 l.created_at,
 GREATEST(l.updated_at, h.updated_at) as updated_at
FROM l
LEFT JOIN h 
 ON (h.host_id = l.host_id)
```

**NÃO PRECISAMOS DO src materilizado**

Nem mesmo precisamos da views, pois a unica coisa que faz é selecionar colunas e renomear algumas coisa.

ENtao podemos colocar NESSE caso, os models quesTâo em src para ehpemeral

Assim o `dbt__project.yml` vai ficar

```yml
models:
  dbtlearn:
    +materialized: view
    dim:
      +materialized: table
    src:
      +materialized: ephemeral
```

Assim, podemos também deletar as view de rc que estâo lá ainda

```sql
DROP VIEW AIRBNB.DEV.SRC_HOSTS;
DROP VIEW AIRBNB.DEV.SRC_LISTINGS;
DROP VIEW AIRBNB.DEV.SRC_REVIEWS;
```

Dessa forma, o scr vai ser convateido para uma CTE, a ser usado ==a no nsso codigo.

**COmo funciona o epeheral e o dbt**

==> **DBT tme o jinja e tudo masi mas no fim é apenas SQL. ELE COMPILA O JINJJA E TUDO APRA SQL.**

Ao executar com `dbt run` vai criar uma pasta `target/` que é onde tem o SQL compilado.

É nele que [e possíveç er que onde chama o `src` (que agora é `epehemral`) vai está substituido por uma CTE;
