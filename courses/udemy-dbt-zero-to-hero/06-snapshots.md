# Snapshots

img-20

## O que sâo Snapshots

**Type 2 Slowing CHanging Dimensions**
+ A ideia das diemneoes é serm dados que mudem bem pouco, mas mesmo aasim pode aocntecer de muda rmesmo
- Exemplo: Temo um mysql com dados de um usuario e um DW. Acoentece que o usuario resolveu mudar de email, entao vai mudar no mysql (faz um update nas e no DW? precisa ser umupdate? SCD descrever froams de tratar esse caso
+ O tipo 2 conssite em por datas, de star e ane, e o dado masi valido será aquele com a data de end como null

NO DBT há duas formas de se fazer isso:

img-21

- time
- cheks

## Criando SNapohosts

+ 1 - Garanta que em `dbt__project` snaphots esteja apontando para a pasta `snapshots`




`snapshots/scd_raw_listings.sql`

```sql
{% snapshot scd_raw_listings %}

{{
	config(
		target_schema='dev',
		unique_key='id',
		strategy='timestamp',
		updated_at='updated_at',
		invalidate_hard_deletes=True
	)
}}

select * FROM {{ source('airbnb', 'listings') }}

{% endsnapshot %}
```

O que está fazenoddo:
+ O snaphos consiste em basicamente ser um select
  - nos vamos vigiar isso `select * FROM {{ source('airbnb', 'listings') }}`
+ A ultima configraçA^o `invalidate_hard_deletes` é opconal

Execute

```sh
dbt snapshot
```

O que acontece ao executar:
+ vai cirar uma tabela `scd_raw_listing` que terá os dados originais adicioandoas de colunas como `dbt_updated_at`, `dbt_valid_from`, `dbt_valid_to`

Executamos um UPDATE para mudar os dados mais um SELECT para vÊ se está mudado mesmo

```sql
UPDATE AIRBNB.RAW.RAW_LISTINGS SET MINIMUM_NIGHTS=30,
updated_at=CURRENT_TIMESTAMP() WHERE ID=3176;

SELECT * FROM AIRBNB.DEV.SCD_RAW_LISTINGS WHERE ID=3176;
```

**AGORA EXECUTE DENOVO APÓS TER FEITO O `ÙPDATE`**

```sh
dbt snapshot
```

O DBT vai comparar as duas taelas, a original e a de snapshot. Vai ver as difenrecça s e vai adicionar a nova row no snaphost do tipo TYPE-2-SCD. **MANTEM OS DOIS REGISTROS NO SNAPHOST, ENQUANTO QUE NA TABELA ORIGINAL TEM SÓ UMA LINHA, COM UM ATRIBUTO ALTERADO**

Execute o sql abaixo que vai mostrar esse dosi registros, com o mais recente com `dbt_valid_to` como `null`

```sql
SELECT * FROM AIRBNB.DEV.SCD_RAW_LISTINGS WHERE ID=3176;
```sql

### Outro Snaphost

`snapshots/scd_raw_hosts.sql`

```sql
{% snapshot scd_raw_hosts %}

{{
	config(
		target_schema='dev',
		unique_key='id',
		strategy='timestamp',
		updated_at='updated_at',
		invalidate_hard_deletes=True
	)
}}
select * FROM {{ source('airbnb', 'hosts') }}

{% endsnapshot %}
```

