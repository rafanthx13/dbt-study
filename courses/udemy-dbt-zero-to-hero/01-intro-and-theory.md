# Intro and Theory

## Normalização

A normaizaçâo é um processo para garantir ue não haja
+ Duplicaçao de dados
+ REdundância de dados
+ ANomalias
Serve também para fica rmais simples de entender

**1NF**
Para ser 1NF precisa ter:
+ 1. As tabelas e as colunas das tabelas tem que serem atômicas
  - Nâo deve ser posśivel dividar os dados de uma célula
  - Por exmeplo: Nomes: separar nos 3 nomes: first, middle e las
  - Por exemplo: Se você tem uma tabela que informa quais comodos tme na suala nao pode ter por exemplo uma row com 'air-conditional, pool, root', 
    * SOluçâo: dividir em novas colunas
+ 2. Tem que haver um ID únicao par acada tabela, basicmente uma primary key
  - Isso garante que n^ao haja row total,ente  duplicadas

**2NF**
+ COnsiste em dividir melhor os atributos, e na criaçao de novas entendades se houver colunas que nâo estejam relacionadas com as outras
+ POr coseugnecia haverá entâo tabelas para relacionas as primary keys das tabelas geradas pelo 2NF

***3NF**
+ Se houver duas colunas que estão relacionadas, basstate relacionadas, formando quase que um par, ao invez de deixar as duas em uma tabela, cria-se uma nova tabelas.
+ mUito usadas para criar tabelas com cosntnaes

## SCD - Slowly Changing Dimensions

O SCD é uma sigla que significa Slowly Changing Dimensions (Dimensões que Mudam Lentamente, em português) e retrata as dimensões que sofrem atualizações em seus campos e os classifica pelo tipo de mudança existente em cada uma delas.

**é um tipo de estrutura que ocorre a consturçâo de DW**


**SCD é uma denominaçao para colunas no DW**


### SCD Tipo 0 - retain original

The Type 0 dimension attributes never change and are assigned to attributes that have durable values or are described as 'Original'. Examples: Date of Birth, Original Credit Score. Type 0 applies to most date dimension attributes.

**Nâo muda o dado**


### SCD Tipo 1 - overwrite

O SCD Tipo 1 é a alteração que não armazena histórico na dimensão, ou seja, não é feito o versionamento do registro modificado. Trata-se do tipo mais simples, pois não há nenhum controle específico para a atualização dos dados, havendo apenas a sobreposição.

**Sobrescreve e perde o histórico de mudanças, chamado traking**


### SCD Tipo 2 - add new row

This method overwrites old with new data, and therefore does not track historical data.

O SCD Tipo 2 é a técnica mais utilizada para atualizações de dimensões. Nesse tipo de SCD é adicionado um novo registro com as mudanças, preservando sempre os dados anteriores. Dessa forma, os registros da tabela fato vão apontar para a versão correspondente nas dimensões de acordo com a data de referência.

**Adicionamos colunas informando o periodo em que aquela row é valida, asism , há registros repetidos (mantendo tracking) mas as datas ficam difenrets**

**Ex: Voce infroam a data de star e end do registro, e no registro mais atual tem a 'end_date' como null**


### SCD Tipo 3 - add new attribute

O SCD Tipo 3 permite manter as modificações no mesmo registro. Essa técnica funciona com a adição de uma nova coluna na tabela de dimensão, onde é armazenada a atualização, mantendo na antiga coluna o valor anterior.

**Ao invez de criar uma row, cria uma nova colunas para a coluna a ser mudada.Assi há algo como 'antigo-endereço' e 'novo-endereço' na mesma tabela


## Use-Caea Airbnbn dbt

img-01

img-02

img-03

img-04


