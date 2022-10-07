# dbt Fundamentals

## Welcome to dbt FUndamentals

odels, sources, testes, documentations,deployment

## Intro ao que será o curso

Sâo 6 partes
0 - INtro, a importnacia do data analytics e como usar dbt em cloud
1 - Models
2 - Sources
3 - Testes
Documentation
Deployment

## FAC - Frequently Asked Questions

How long does this course take to complete? 

We estimate that this course  takes about five hours to complete. There are two hours of video and approximately three hours of practice for someone who is new to dbt. 

What is the structure of the course? 

The very first video in the course gives a brief overview of the course. I recommend starting there for how to get the most out of the course. 

How do I earn the dbt Fundamentals badge? 

To receive the dbt Fundamentals badge, you should watch all the video lessons, practice with the exercises, and complete the Check for Understandings with 100% accuracy.  Don't worry - you have unlimited attempts for each Check for Understanding.  Note: You need to click "mark as complete" for each lesson to be marked complete.

## Whos is an analitcs engineer?

Learning Objectives
+ Explain the structure of traditional data teams.
+ Explain how advances in technology enabled the transition from ETL to ELT.
+ Explain the role of analytics engineer and the modern data team.
+ Explain how dbt fits into the modern data stack.
Understand the structure of a dbt project.

### Traditional data teams

Em times tradicioanis de dados há dois papeis: Data Analyst e Data engineers

Data enginer: cuida do banco de dados, e do procesos de ETL
+ Tem que saber: SQL, python, java, ETL e orquestraâo

Data analyst: COntruçao de Dashboard, Relatorios. Precisa saber bem Excel e SQL tambem.

### ETL vc ELT

ETL é feito mais por data enginers e requer ferramentas como python e airflow. O tradicional do ETL é extrari os dados, por em algum lugar temporario, fazer a tranformaçao nesse local temporario e depoois mandar para o BD destino

Hoje os Data warehouse em cloud sao banco de dados combinoados a um super computadaor capaz de tranforam dados. **ISSO MUDA TUDO, AGORA NAO PRECISAMOS POR O L DE LOAD NO FINAL, PODEMOS POR OS DADOS CRU LÁ NO DW E LÁ MESMO FAZER A TRANFORMAÇAO: ELT**

Isso economiza, assim o E e o L ficam sendo a mesma coisa praticmente eveitando ter que usar um espaço temporario para fazer as tranformações.

Além disso, fazendo isso na nuvem temmpos scalabiladade para processamento e aramzenamento.

### Analytics Enginner

DW em clouds possibilitam fazer de ETL para ELT.

Assim agora podemos ter Analytics Enginer: Alguem que fica encarregado de trangformar os ddos brutos apra a camada de BI, pois agora com Cloud o E e L ficam bem simples, e podemos focar mais só no T, que é o papel do dbt

[What is a  Analytics Engineer](
https://blog.getdbt.com/what-is-an-analytics-engineer/)

img-01

### The modern sta stack and dbt

Data sources: Hupsport, Sale Force, Data base and etc

Data plataform: Snowflake, Redhsift, BigQuery, Databricks ....

par amover da fonte para a plataforma de dados podemos usar pytohn, Java ou libs de ETL

Os dados da Data Platfoem podem ser usadaos para

BI tool: QUick Sense, PBI, Tableu
+ ML Model: Hex, Censue e etc..
+ Analycs Analisis

o dbt atua na dataplatfome otimizando a entrada e saida de dados

### Review

**Traditional Data Teams**

- Data engineers are responsible for maintaining data infrastructure and the ETL process for creating tables and views.
- Data analysts focus on querying tables and views to drive business insights for stakeholders.

**ETL and ELT**

- ETL (extract transform load) is the process of creating new database objects by extracting data from multiple data sources, transforming it on a local or third party machine, and loading the transformed data into a data warehouse.
- ELT (extract load transform) is a more recent process of creating new database objects by first extracting and loading raw data into a data warehouse and then transforming that data directly in the warehouse.
- The new ELT process is made possible by the introduction of cloud-based data warehouse technologies.

**Analytics Engineering**

- Analytics engineers focus on the transformation of raw data into transformed data that is ready for analysis. This new role on the data team changes the responsibilities of data engineers and data analysts.
- Data engineers can focus on larger data architecture and the EL in ELT.
- Data analysts can focus on insight and dashboard work using the transformed data.
- Note: At a small company, a data team of one may own all three of these roles and responsibilities. As your team grows, the lines between these roles will remain blurry.

**dbt**

- dbt empowers data teams to leverage software engineering principles for transforming data.
- The focus of this course is to build your analytics engineering mindset and dbt skills to give you more leverage in your work.



## Questions

What technological changes have contributed to the evolution of Extract-Transform-Load (ETL) to Extract-Load-Transform (ELT)?

Modern cloud-based data warehouses with scalable storage and comp

Off-the-shelf data pipeline/extraction tools (ex: Stitch, Fivetran)

Self-service business intelligence tools increased the ability for stakeholders to access and analyze data

All above (X)



dbt is part of which step of the Extract-Load-Transform (ELT) process?

=> Tranform



Which one of the following is true about dbt in the context of the modern data stack?

=> dbt connects directly to your data platform to model data



Which one of the following is true about YAML files in dbt?

=> YAML files are used for configuring generic tests





## Set Up CLoud dbt



# Learning Objectives

- Load training data into your data platform
- Set up an empty repository and connect your GitHub account to dbt Cloud.
- Set up your warehouse and repository connections.
- Navigate the dbt Cloud IDE.
- Complete a simple development workflow in the dbt Cloud IDE.



# dbt, data platforms, and version control

If you are new to dbt, the underlying architecture may be new to you. First, read this quick overview and then follow the steps for creating the necessary accounts. There are effectively two ways in which to use dbt: dbt CLI and dbt Cloud.

- **dbt Cloud** is a hosted version that streamlines development with an online Integrated Development Environment (IDE) and an interface to run dbt on a schedule.
- **dbt Core** is a command line tool that can be run locally.

This course will assume you are using dbt Cloud, but the concepts and practices can easily be extended to dbt CLI.

## Data platform

dbt is designed to handle the transformation layer of the ‘extract-load-transform’ framework for data platforms. dbt creates a connection to a data platform and runs SQL code against the warehouse to transform data. 

In our demos, we will be using Snowflake as our data warehouse. You will need access to your own data platform to complete the practice exercises. Read more in our documentation on [dbt's supported databases.](https://docs.getdbt.com/docs/supported-databases/)

## Version control

dbt also enables developers to leverage a version control system to manage their code base. A popular version control system is git. If you are unfamiliar with git, don’t worry, dbt Cloud provides a UI that makes it simple to use a git workflow.

In this course, we will be demoing with **GitHub** to host the code base that we build. If you would prefer to use another service for version control with dbt Cloud, check out our [documentation for other version control options](https://docs.getdbt.com/docs/dbt-cloud/cloud-configuring-dbt-cloud/cloud-using-a-managed-repository).

All in all, dbt is going to be the transformation interface between the code we write (stored and managed in a git repository) and the sample data we have to work with (stored and transformed in your data platform).

Now let’s start setting up your individual accounts. In the following lessons, we will work to ensure all of these are connected appropriately.







## Setting up dbt Cloud and your data platform

As a learner, it is extremely beneficial to practice what you learn to lock in the learning. To complete the practice exercises, you will need a connection to a data platform. Before you proceed with the course, we highly recommend getting access to one of the follow data platforms: **BigQuery, Databricks, Redshift, or Snowflake.**

The following pages will walk you through setting up your data platform and connecting to dbt Cloud. Once you finish connecting dbt Cloud to your data platform, return here to continue your learning.

#### Starting from scratch??

If you are starting from scratch, choose one of the following links to set up a data platform from scratch.  You should complete the entire tutorial on those pages and then return here for the rest of the course.

- [Getting started with BigQuery](https://docs.getdbt.com/tutorial/getting-set-up/setting-up-bigquery)
- [Getting started with Databricks](https://docs.getdbt.com/tutorial/getting-set-up/setting-up-databricks)
- [Getting started with Redshift](https://docs.getdbt.com/tutorial/getting-set-up/setting-up-redshift)
- [Getting started with Snowflake](https://docs.getdbt.com/tutorial/getting-set-up/setting-up-snowflake)

#### Already have access to data platform??

If you already have access to a data platform, jump into a later section of those guides with the links here. You should complete the entire tutorial on those pages and then return here for the rest of the course.

- [Loading data into BigQuery](https://docs.getdbt.com/tutorial/getting-set-up/setting-up-bigquery#loading-data)
- [Loading data into Databricks](https://docs.getdbt.com/tutorial/getting-set-up/setting-up-databricks#loading-data)
- [Loading data into Redshift](https://docs.getdbt.com/tutorial/getting-set-up/setting-up-redshift#loading-data)
- [Loading data into Snowflake](https://docs.getdbt.com/tutorial/getting-set-up/setting-up-snowflake#loading-data)





# Review

## Cloud IDE

A quick tour of the Cloud IDE. The IDE can be found by choosing the hamburger menu in the top left and selecting "Develop."

![img](https://files.cdn.thinkific.com/file_uploads/342803/images/e51/fd4/6d1/Annotated_IDE.png)

### **Git controls**

- All git commands in the IDE are completed here.
- This will change dynamically based on the git status of your project.

### **File tree**

- This is the main view into your dbt project.
- This is where a dbt project is built in the form of .sql, .yml, and other file types.

### **Text editor**

- This is where individual files are edited. You can open files by selecting them from the file tree to the left.
- You can open multiple files in tabs so you can easily switch between files.
- Statement tabs allow you to run SQL against your data warehouse while you are developing, but they are not saved in your project. If you want to save SQL queries, you can create .sql files in the analysis folder.

### **Preview / Compile SQL**

- These two buttons apply to statements and SQL files.
- `Preview` will compile and run your query against the data warehouse. The results will be displayed in the "Query Results" tab along the bottom of your screen.
- `Compile SQL` will compile any Jinja into pure SQL. This will be displayed in the Info Window in the "Compiled SQL" tab along the bottom of your screen.

### **Info window**

- This window will show results when you click on Preview or Compile SQL.
- This is helpful for troubleshooting errors during development.
- The "Lineage" will also show a diagram of the model that is currently open in the text editor and its ancestors and dependencies.

### **Command line**

- This is where you can execute specific dbt commands (e.g. `dbt run`, `dbt test`).
- This will pop up to show the results as they are processed. Logs can also be viewed here.

### **View docs**

- This button will display the documentation for your dbt project.
- More details on this in the documentation module.



## Questions

1 - What is required to materialize a model in your data platform with dbt?

A dbt project with .sql files saved in a models directory AND

A connection to a data warehouse with raw data loaded in



2 - When working in dbt, which one of the following should always be unique for each dbt developer when working in development?

=> Target Schema

3 - Which one of the following is a true statement about dbt connections?

Data is stored in the data platform and code is stored in the git repository

4 - Which of the following is true about version control with git in dbt?

Separate branches allow dbt developers to simultaneously work on the same code base without impacting production