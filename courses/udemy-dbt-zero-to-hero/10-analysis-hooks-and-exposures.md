# Analysis, Hooks e Exposure

Vamos ver três tópicos avançados: Analysis, Hooks e Exposure  no dbt

img-28

## Analisys

Colocamos na pasta `analysis/`. Podemo usar as macro jinja e ao compilar, na pasta target, vai gerar o código que dá pra ser executado no snowflake.

`analyses/full_moon_no_sleep.sql`

```
WITH mart_fullmoon_reviews AS (
 SELECT * FROM ref('mart_fullmoon_reviews')
)

SELECT
 is_full_moon,
 review_sentiment,
 COUNT(*) as reviews
FROM
 mart_fullmoon_reviews
GROUP BY
 is_full_moon,
 review_sentiment
ORDER BY
 is_full_moon,
 review_sentiment
```

Execute com :

```
dbt compile
```

e assim na pasta target vai ter o analysis compilado

## Hooks

img-29

Hookes: Sâo consultas SQL executadas anstes ou depois de todos os passos do dbt

Para fazer isos vamos ter que configurar algumas cosias no snowflake

```sql
USE ROLE ACCOUNTADMIN;
CREATE ROLE IF NOT EXISTS REPORTER;
CREATE USER IF NOT EXISTS PRESET
 PASSWORD='presetPassword123'
 LOGIN_NAME='preset'
 MUST_CHANGE_PASSWORD=FALSE
 DEFAULT_WAREHOUSE='COMPUTE_WH'
 DEFAULT_ROLE='REPORTER'
 DEFAULT_NAMESPACE='AIRBNB.DEV'
 COMMENT='Preset user for creating reports';

GRANT ROLE REPORTER TO USER PRESET;
GRANT ROLE REPORTER TO ROLE ACCOUNTADMIN;
GRANT ALL ON WAREHOUSE COMPUTE_WH TO ROLE REPORTER;
GRANT USAGE ON DATABASE AIRBNB TO ROLE REPORTER;
GRANT USAGE ON SCHEMA AIRBNB.DEV TO ROLE REPORTER;
GRANT SELECT ON ALL TABLES IN SCHEMA AIRBNB.DEV TO ROLE REPORTER;
GRANT SELECT ON ALL VIEWS IN SCHEMA AIRBNB.DEV TO ROLE REPORTER;
GRANT SELECT ON FUTURE TABLES IN SCHEMA AIRBNB.DEV TO ROLE REPORTER;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA AIRBNB.DEV TO ROLE REPORTER;
```

Coloque ese trecho no `dbt_project.yml` no final.

```
+post-hook:
    - "GRANT SELECT ON {{ this }} TO ROLE REPORTER"
```

## Exposure

Exposue serve para referenciar a algo externo do dbt.

Vamos começar criando o arquivo `dashboard.yml` no `models/`

`models/dashboard.yml`

```yml
version: 2

exposures:
  - name: Executive Dashboard
    type: dashboard
    maturity: low
    url: https://7e942fbd.us2a.app.preset.io:443/r/2
    description: Executive Dashboard about Airbnb listings and hosts

    depends_on:
      - ref('dim_listings_w_hosts')
      - ref('mart_fullmoon_reviews')

    owner:
      name: Zoltan C. Toth
      email: hello@learndbt.com
```

**ESSE EXPOSURE SERVE PARA ADICIONAR UMA SEÇÂO DE DASHBOARD NA NOSSA DOCUMENTAÇÂO, LINKADO COM O LINK DO PRESET E COLOCANDO MAIS COISAS**

img-30
