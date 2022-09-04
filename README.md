# PostgreSQL common-db-schema (plpgsql-common-library)
plpgSQL schema with many useful functions

## Requirements

- postgresql
- liquibase

## Database preparation and migrations

NOTE: do not use angle brackets in entity names, substitute by the actual names instead!

1. Create a liquibase user under which the migrations will be applied:
    ```sql
    CREATE USER <liquibase_user> CREATEROLE ENCRYPTED PASSWORD 'aPassword';
    ```

   NOTE: be sure you have the same `<liquibase_user>` and `aPassword` in the `liquibase.properties`.

   HINT: you can use the same liquibase user as for endpoint project for which the `common` schema is installing.

1. Connect to endpoint project database and create schema `common` (owner must be `liquibase_user`, use `AUTHORIZATION` option for the `CREATE SCHEMA` command):
    ```sql
    CREATE SCHEMA common AUTHORIZATION <liquibase_user>;
    ```

1. Now you can run `liquibase` to migrate initial schema (be sure you are in the project's root and the `liquibase.properties` file is placed here):
    ```shell
    $ liquibase update
    ```

   NOTE: you might have to add the `classpath: /path/to/the/postgresql-jdbc-driver.jar` into the `liquibase.properties` file
   unless your liquibase installation contains the postgresql JDBC driver
   (you also can place the driver jar file manually into the `lib` directory of the liquibase installation).

   NOTE: in the case of remote database you have to put the correct jdbc connection string into your `liquibase.properties` like this:
    ```ini
    url: jdbc:postgresql://<host>[:<port>]/<db_name>?ssl=true&prepareThreshold=0
    ```
   See more options here: https://jdbc.postgresql.org/documentation/head/connect.html

### Further migrations

Update the project content (`git pull` or any other way you like) and just run:
```shell
$ liquibase update
```
