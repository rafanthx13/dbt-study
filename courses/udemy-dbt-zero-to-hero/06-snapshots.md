# Snapshots

img-20

## Criando Snapshots

**Type 2 Slowing CHanging Dimensions**
+ A ideia das diemneoes é serm dados que mudem bem pouco, mas mesmo aasim pode aocntecer de muda rmesmo
- Exemplo: Temo um mysql com dados de um usuario e um DW. Acoentece que o usuario resolveu mudar de email, entao vai mudar no mysql (faz um update nas e no DW? precisa ser umupdate? SCD descrever froams de tratar esse caso
+ O tipo 2 conssite em por datas, de star e ane, e o dado masi valido será aquele com a data de end como null

NO DBT há duas formas de se fazer isso:

img-21

- time
- cheks  

O que são Snaphots:
+ 




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

