# MOdels

É o concieto principal por traz do dbt

O que vamos ver nessa seçâo:

img-08

## O que são blocos

+ São os principais blocos lógocos do nosso projeto dbt. 
+ Corresponde a arquivos sql que fazem uma consulta select u criam uma views, materializando a consulta sql
+ Os `models` ficam na pasta `models/`
+ MOdels não é só um select estático, podema pontar para templates, macros além de usar o jinja

img-09

## CTE

Os models vâo costumar ser feito com um conjunto de CTE, onde cada CTE pega dados e cria algo como uma tabela temproarias, que será resferencias em outros lugares no arquivo `.sql`

img=10

img-11

## Criando o nosso primeiro model

OBS:Por default, todos os models sâo views e nâo necessáriamente tabelas.

Vamos pprimeira criar nosso arquivos `sources`, será basicamente consultas que fazem um `SELECT *` e modifica umpouco só o nome de algumas colunas.

img: etapa de consturaçao de camada staging, camada de source

img-12

OBS: Você pode começar testantando essas consultar prmeiro no próprio snowflake, e depois joga no arquivo model.

image; testando no snowflake

img-13

`models/src/src_listings.sql`

```sql
WITH raw_listings AS (
	SELECT
		*
	FROM
		AIRBNB.RAW.RAW_LISTINGS
)
SELECT
	id AS listing_id,
	name AS listing_name,
	listing_url,
	room_type,
	minimum_nights,
	host_id,
	price AS price_str,
	created_at,
	updated_at
FROM
	raw_listings
```

`models/src/src_reviews.sql`

```sql
WITH raw_reviews AS (
	SELECT
		*
	FROM
		AIRBNB.RAW.RAW_REVIEWS
)
SELECT
	listing_id,
	date AS review_date,
	reviewer_name,
	comments AS review_text,
	sentiment AS review_sentiment
FROM
	raw_reviews

```

`models/src/src_hosts.sql`

```sql
WITH raw_hosts AS (
	SELECT
		*
	FROM
		AIRBNB.RAW.RAW_HOSTS
)
SELECT
	id AS host_id,
	NAME AS host_name,
	is_superhost,
	created_at,
	updated_at
FROM
	raw_hosts
```

OBS: Ao executar o projeto dbt com os model ...
+ Executa com `dbt run` no meio do projteto
  - Desde que esteja devidamente conectado `dbt debug` vai rodar certinho
+ Vai criar um schema `DEV` que terá as views esses arquivos

img: executando `dbt` no nnosso repo local, vai mandar os comandos para snwoflake e ele vai criar a view em Dev

img-14

OBS: 
_ FUncinou perfeitamente 14/10/2022
+ O codigo do repo é difenrete porque recebera refs (macro jinjas) por qnquanto vamos cru mesmo

Mais adiante no curso vai converter para a refernica seguri essa fora

```sql
WITH raw_listings AS (
        SELECT * FROM {{ source('airbnb', 'listings') }}
)
