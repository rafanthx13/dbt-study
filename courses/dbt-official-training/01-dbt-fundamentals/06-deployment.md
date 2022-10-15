# Deployment

## Learning Objectives

- Understand why it's necessary to deploy your project.
- Explain the purpose of creating a deployment environment.
- Schedule a job in dbt Cloud.
- Review the results and artifacts of a scheduled job in dbt Cloud.

----

-----

-----





----

----

----

## Review

### Development vs. Deployment

- Development in dbt is the process of building, refactoring, and organizing different files in your dbt project. This is done in a development environment using a development schema (`dbt_jsmith`) and typically on a *non-default* branch (i.e. feature/customers-model, fix/date-spine-issue). After making the appropriate changes, the development branch is merged to main/master so that those changes can be used in deployment.
- Deployment in dbt (or running dbt in production) is the process of running dbt on a schedule in a deployment environment. The deployment environment will typically run from the *default* branch (i.e., main, master) and use a dedicated deployment schema (e.g., `dbt_prod`). The models built in deployment are then used to power dashboards, reporting, and other key business decision-making processes.
- The use of development environments and branches makes it possible to continue to build your dbt project *without* affecting the models, tests, and documentation that are running in production.

### Creating your Deployment Environment

- A deployment environment can be configured in dbt Cloud on the Environments page.

- **General Settings:** You can configure which dbt version you want to use and you have the option to specify a branch other than the default branch.

- **Data Warehouse Connection:** You can set data warehouse specific configurations here. For example, you may choose to use a dedicated warehouse for your production runs in Snowflake.

- Deployment Credentials:

  Here is where you enter the credentials dbt will use to access your data warehouse:

  - IMPORTANT: When deploying a real dbt Project, you should set up a **separate data** **warehouse account** for this run. This should not be the same account that you personally use in development.
- IMPORTANT: The schema used in production should be **different** from anyone's development schema.

### Scheduling a job in dbt Cloud

- Scheduling of future jobs can be configured in dbt Cloud on the Jobs page.
- You can select the deployment environment that you created before or a different environment if needed.
- **Commands:** A single job can run multiple dbt commands. For example, you can run `dbt run` and `dbt test` back to back on a schedule. You don't need to configure these as separate jobs.
- **Triggers:** This section is where the schedule can be set for the particular job.
- After a job has been created, you can manually start the job by selecting `Run Now`

### Reviewing Cloud Jobs

- The results of a particular job run can be reviewed as the job completes and over time.
- The logs for each command can be reviewed.
- If documentation was generated, this can be viewed.
- If `dbt source freshness` was run, the results can also be viewed at the end of a job.

## Questions

+ 1 - Which one of the following are true about running your dbt project in production?

  + C: Running dbt in production should use a different database schema than I used in development

+ 2 - When does a dbt job run?

  + At whatever cadence you set up for the job

+ 3 - The following commands are configured for a production job in dbt Cloud.

  + ```
    dbt seed
    
    dbt test --select source:*
    
    dbt run
    
    dbt test --exclude source:*
    ```

  + If any of the tests on sources fails, how will dbt Cloud handle the rest of the commands?  

  + **ANSWER:** dbt will not execute any further commands

+ 4 - Consider a production job where you have the following commands and have enabled docs generation.

  + ```
    dbt run
    
    dbt test
    ```

  + What will be the correct order of invoked dbt commands in the run history after ‘clone git repository’ and ‘create profile from connection’?

  + **ANSWER:** `dbt deps >> dbt run >> dbt test >> dbt docs generate`

+ 5 - Which one of the following is true about development and deployment environments?

  + B: Deployment environments are used for running code on a schedule and development environments are used for developing code.

+ 6 - After developing models in dbt, which one of the following steps is the final step to ensure your code runs in production?

  + The code has been reviewed and merged into the default branch

  