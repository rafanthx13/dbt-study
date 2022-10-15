# Analyses and Seeds

## Learning Objectives

- Explain the purposes of analyses in contrast to models
- Explain the role of seeds in a dbt project
- Write and compile analyses and find the compiled SQL in the targets folder
- Add a seed to a project and materialize in the data warehouse
- Select from, test, and documents seeds

----

-----

-----



----

-----

----

## Practice

### Analyses

Using you new knowledge of analyses, create an analysis file in the `analysis` folder called `total_revenue.sql` that uses the `stg_payments` model and sums the amount of successful payments. (Remember to use Jinja in this rather than the raw table name)

### Seeds

Using your new knowledge of seeds, create a seed file in the `seeds` folder (or if you're using a dbt version prior to 1.0.0, it will be called the `data` folder) called `employees.csv` with the following values:

```sql
employee_id,email,customer_id
3425, mike@jaffleshop.com, 1
2354, sarah@jaffleshop.com, 6
2342, frank@jaffleshop.com, 8
1234, jennifer@jaffleshop.com, 9
```

Build this seed into your data warehouse by running `dbt seed`.

## Exemplar

`analysis/total_revenue.sql`

```sql
with payments as (
	select * from {{ ref('stg_payments') }}
),
	
aggregated as (
	select 
		sum(amount) as total_revenue 
    from paymentswhere 
    status = 'success'
)
	
select * from aggregated
```

`data/employees.csv`

```
employee_id, email, customer_id
3425, mike@jaffleshop.com, 1
2354, sarah@jaffleshop.com, 6
2342, frank@jaffleshop.com, 8
1234, jennifer@jaffleshop.com, 9
```

## Review

### Analyses

- Analyses are .sql files that live in the analyses folder.
- Analyses will not be run with `dbt run` like models. However, you can still compile these from Jinja-SQL to pure SQL using `dbt compile`. These will compile to the target folder.
- Analyses are useful for training queries, one-off queries, and audits

### Seeds

- Seeds are .csv files that live in the `seeds` folder (or if you're using a dbt version prior to 1.0.0, it will be called the `data` folder) .
- When executing `dbt run`, seeds will be built in your Data Warehouse as tables. Seeds can be references using the `ref` macro - just like models!
- ✅ Seeds **should** be used for data that doesn't change frequently.
- ⛔️ Seeds **should not** be the process for uploading data that changes frequently
- Seed are useful for loading country codes, employee emails, or employee account IDs
  - Note: If you have a rapidly growing or large company, this may be better addressed through an orchestrated loading solution.