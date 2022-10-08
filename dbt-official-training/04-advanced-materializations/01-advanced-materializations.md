# Advanced Materializations

## Learning Objectives:

- Explain the five main types of materializations in dbt.
- Configure materializations in configuration files and in models.
- Explain the differences and tradeoffs between tables, views, and ephemeral models.
- Build intuition for incremental models.
- Build intuition for snapshots.

----

----

----



----

----

----

## Practice

### Tables, views, and ephemeral Models

To gain a deeper understanding of tables, views, and ephemeral models, try making the following changes to your project. However, don't commit these changes to your git repository. Use this solely as a chance to experiment with these materializations.

### Incremental Models

**The following incremental model was used in the incremental models demo. Use this as a starting place for implementing an incremental model in a future dbt project with real event data!**

**In this free, public version of the course, there is not currently a means for exposing this live event data for practice. If you have similar event data in your data warehouse, feel free to modify the SQL below a**

**nd apply it to your use case.**

Configure a new source in the folder `models/staging/snowplow` called `src_snowplow.yml`.

```yaml
version: 2

sources:
  - name: snowplow
    database: raw
    loaded_at_field: collector_tstamp
    freshness:
      error_after: {count: 1, period: hour}
    tables:
      - name: events
```

- Create an incremental model with the following code snippet in the folder `models/staging/snowplow` called `stg_page_views.sql`.

```sql
{{ config(
    materialized = 'incremental',
    unique_key = 'page_view_id'
) }}
with events as (
    select * from {{ source('snowplow', 'events') }}
    {% if is_incremental() %}
    where collector_tstamp >= (select max(max_collector_tstamp) from {{ this }})
    {% endif %}
),
page_views as (
    select * from events
    where event = 'page_view'
),
aggregated_page_events as (
    select
        page_view_id,
        count(*) * 10 as approx_time_on_page,
        min(derived_tstamp) as page_view_start,
        max(collector_tstamp) as max_collector_tstamp
    from events
    group by 1
),
joined as (
    select
        *
    from page_views
    left join aggregated_page_events using (page_view_id)
)
select * from joined
```

**Sample exercise if your data warehouse has access to live event data:** 

- Run the incremental model for the first time by running `dbt run -m stg_page_views`.
- Navigate to [learn.getdbt.com/lessons/incremental](https://courses.getdbt.com/courses/take/advanced-materializations/texts/learn.getdbt.com/lessons/incremental) and click through the slides to add page views.
- After about 10 minutes or so execute `dbt run -m stg_page_views` and your incremental model will process an incremental build. Take a look at the logs to see the DDL/DML used to build this model incrementally.
- Rebuild the entire model again by running `dbt run --full-refresh`

### Snapshots

Snapshots are difficult to practice without genuine type 2, slowly changing dimension data. For this exercise, use the following code snippets to practice snapshots. **You may need to adjust the Snowflake snippets based on your data warehouse.**

- **(In Snowflake)** Create a table called mock_orders in your development schema. You will have to replace `dbt_kcoapman` in the snippet below.

```sql
create or replace transient table analytics.dbt_kcoapman.mock_orders (
    order_id integer,
    status varchar (100),
    created_at date,
    updated_at date
);
```

- **(In Snowflake)** Insert values into the mock_orders table in your development schema. You will have to replace `dbt_kcoapman` in the snippet below.

```sql
insert into analytics.dbt_kcoapman.mock_orders (order_id, status, created_at, updated_at)
values (1, 'delivered', '2020-01-01', '2020-01-04'),
       (2, 'shipped', '2020-01-02', '2020-01-04'),
       (3, 'shipped', '2020-01-03', '2020-01-04'),
       (4, 'processed', '2020-01-04', '2020-01-04');
commit;
```

- **(In dbt Cloud)** Create a new snapshot in the folder `snapshots` with the filename `mock_orders.sql` with the following code snippet. Note: Jinja is being used here to create a new, dedicated schema.

```sql
{% snapshot mock_orders %}

{% set new_schema = target.schema + '_snapshot' %}

{{
    config(
      target_database='analytics',
      target_schema=new_schema,
      unique_key='order_id',

      strategy='timestamp',
      updated_at='updated_at',
    )
}}

select * from analytics.{{target.schema}}.mock_orders

{% endsnapshot %}
	
	
```

- **(In dbt Cloud)** Run snapshots by executing `dbt snapshot`.
- **(In dbt Cloud)** Run the following snippet in a statement tab to see the current snapshot table. You will have to replace `dbt_kcoapman` with your development schema. Take note of how dbt has added three columns.

```sql
select * from analytics.dbt_kcoapman_snapshot.mock_orders
```

- **(In Snowflake)** Recreate a table called mock_orders in your development schema. You will have to replace `dbt_kcoapman` in the snippet below.

```sql
create or replace transient table analytics.dbt_kcoapman.mock_orders (
    order_id integer,
    status varchar (100),
    created_at date,
    updated_at date
);
```

- **(In Snowflake)** Insert these new values into the mock_orders table in your development schema. You will have to replace `dbt_kcoapman` in the snippet below.

```sql
insert into analytics.dbt_kcoapman.mock_orders (order_id, status, created_at, updated_at)
values (1, 'delivered', '2020-01-01', '2020-01-05'),
       (2, 'delivered', '2020-01-02', '2020-01-05'),
       (3, 'delivered', '2020-01-03', '2020-01-05'),
       (4, 'delivered', '2020-01-04', '2020-01-05');
commit;
```

- **(In dbt Cloud)** Re-run snapshots by executing `dbt snapshot`.
- **(In dbt Cloud)** Run the following snippet in a statement tab to see the current snapshot table. You will have to replace `dbt_kcoapman` with your development schema. Now take note of how dbt has 'snapshotted' the data to capture the changes over time!

```sql
select * from analytics.dbt_kcoapman_snapshot.mock_orders
```

Note: If you want to start this process over, you will need to drop the snapshot table by running the following in Snowflake. This will force dbt to create a new snapshot table in step 4. (Again, you will need to swap in your development schema for `dbt_kcoapman`)

```sql
drop table analytics.dbt_kcoapman_snapshot.mock_orders
```



## Review

### Tables

- Built as tables in the database
- Data is stored on disk
- Slower to build
- Faster to query
- Configure in dbt_project.yml or with the following config block

```sql
{{ config(
    materialized='table'
)}}
```

### Views

- Built as views in the database
- Query is stored on disk
- Faster to build
- Slower to query
- Configure in dbt_project.yml or with the following config block

```sql
{{ config(
    materialized='view'
)}}
```

### Ephemeral Models

- Does not exist in the database
- Imported as CTE into downstream models
- Increases build time of downstream models
- Cannot query directly
- [Ephemeral Documentation](https://docs.getdbt.com/docs/building-a-dbt-project/building-models/materializations#ephemeral)
- Configure in dbt_project.yml or with the following config block

```sql
{{ config(
    materialized='ephemeral'
)}}
```

### Incremental Models 

- Built as table in the database
- On the first run, builds entire table
- On subsequent runs, only appends new records*
- Faster to build because you are only adding new records
- Does not capture 100% of the data all the time
- [Incremental Documentation](https://docs.getdbt.com/docs/building-a-dbt-project/building-models/materializations#incremental)
- [Discourse post on Incrementality](https://discourse.getdbt.com/t/on-the-limits-of-incrementality/303)
- Configuration is more advanced in this case. Consult the dbt documentation for building your first incremental model.

### Snapshots

- Built as a table in the database, usually in a dedicated schema.
- On the first run, builds entire table and adds four columns: `dbt_scd_id`, `dbt_updated_at`, `dbt_valid_from`, and `dbt_valid_to`
- In future runs, dbt will scan the underlying data and append new records based on the configuration that is made.
- This allows you to capture historical data
- [Snapshots Documentation](https://docs.getdbt.com/docs/building-a-dbt-project/snapshots)
- Configuration is more advanced in this case. Consult the dbt documentation for writing your first snapshot.