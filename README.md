# DBT - Data Build Tool

## Resumo

DBT é uma ferraemnta para fazer o T do ETL (Transformation) usando SQL.

A ideia é criar selects qua automaticamente geram view, em seguida encadeia as viewa té no finalmaterializar e tendo assim a nova tabela.

Ele tem uma interface web que é gratuito quando é somente 1 pessoa, e paga para o pkano de Teams: 80 USD por pessoa.

O Dbt É sqlpuro. A ideia dele é: conectar a um DW: Rddshift, Sinapse, BigQuey, Snowlfale, Spark e operar sobre ele.

## BigQuery

Dos DW disponiveis no mercaod, o BigQuery do google é o unico que tem umplano 100% freeque permite fazer as coisa sem problema.

Apesar disso,será neces´sario cadastrar uuma *billing account* e conectar ao ´rojeto do *gcp* para ssim conseguir usar:

Plano Free do BigQuey:
+ 1TB de transaçôes DML (INSERT, DELETE, SELECT, UDPATE)
+ Armazenamento free até 10 GB
  
Eternamente free. Apesar disso, reomva os dados após usar
