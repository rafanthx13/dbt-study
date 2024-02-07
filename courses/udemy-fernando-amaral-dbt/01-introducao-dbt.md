# 01 - Introdução ao dbt - data build tool

## O que é dbt resumidamente

**Resumo:** O dbt é uma ferramenta baseada em modelos que formam um pipeline de transformação de dados. Cada modelo é um arquivo SQL que gera uma tabela como saída. Os modelos podem ter outros modelos como entrada e também podem servir de entrada para outros modelos, facilitando a criação de fluxos de trabalho de transformação de dados mais complexos e organizados.

DBT é uma ferramenta para transformação de dados usando SQL, e suas características incluem:

+ Criação de pipelines utilizando SQL, uma linguagem de fácil entendimento.
+ Utilizando a engine do Jina, oferece mais recursos que o SQL padrão.
+ O Jija no dbt permite controle de fluxo de dados, reutilização de lógica, configuração dinâmica, geração de código SQL e injeção de código externo, ampliando as capacidades além do SQL padrão.
+ É um projeto git, possibilitando a realização de pull requests e colaboração de equipe no mesmo projeto.

Ele é uma ferramenta para realizar transformações dentro do banco de dados e se encaixa bem no esquema de arquitetura medalhão: bronze (raw/landing), Silver (refinado), Gold (agrupado para ser usado).

## O que é dbt pelo ChatGPT

O dbt (data build tool) desempenha um papel importante no Modern Data Stack, que é uma abordagem de arquitetura para organizar e gerenciar as operações de dados em uma empresa. O Modern Data Stack normalmente envolve uma combinação de ferramentas e serviços para ingestão, armazenamento, processamento e análise de dados. O dbt é frequentemente associado à camada de transformação e modelagem de dados. Aqui estão alguns dos papéis principais do dbt no Modern Data Stack:

1. **Transformação de Dados:**
   + O dbt é usado para transformar dados brutos armazenados em um data warehouse em modelos analíticos prontos para consulta. Ele facilita a escrita e execução de consultas SQL complexas para criar agregações, calcular métricas e realizar outras transformações necessárias para análises.

2. **Camada de Modelagem:**
   + O dbt organiza a lógica de transformação em modelos, proporcionando uma camada de abstração sobre os dados brutos. Isso facilita o desenvolvimento e a manutenção de modelos analíticos, garantindo consistência e reusabilidade.

3. **Workflow Baseado em Git:**
   + O dbt é muitas vezes integrado a sistemas de controle de versão como o Git. Isso permite que os analistas de dados colaborem, versionem e rastreiem alterações nas transformações dos dados de maneira semelhante ao desenvolvimento de software.

4. **Autodocumentação:**
   + O dbt gera automaticamente documentação para os modelos, que pode incluir descrições, dependências, e até mesmo a origem das colunas. Isso facilita a compreensão dos dados e a comunicação entre os membros da equipe.

5. **Testes de Qualidade de Dados:**
   + O dbt suporta a criação de testes automatizados para garantir a qualidade dos dados. Os testes podem verificar a integridade dos dados, a consistência de cálculos e outras condições necessárias para garantir a precisão das análises.

6. **Integração com o Data Warehouse:**
   + O dbt se integra diretamente com diversos data warehouses, como BigQuery, Snowflake, Redshift, entre outros, facilitando a execução eficiente das transformações diretamente no ambiente de armazenamento de dados.

7. **Orquestração de Jobs:**
   + Embora o dbt em si não seja uma ferramenta de orquestração de fluxo de trabalho, é comum vê-lo sendo usado em conjunto com ferramentas de orquestração, como Apache Airflow ou dbt Cloud, para agendar e coordenar a execução dos jobs de transformação.

O dbt é uma ferramenta poderosa que simplifica e organiza a camada de transformação de dados, proporcionando eficiência e estrutura ao desenvolvimento de análises e relatórios em ambientes modernos de dados. Ele se encaixa bem na abordagem do Modern Data Stack ao oferecer uma solução especializada para a transformação e modelagem de dados.

