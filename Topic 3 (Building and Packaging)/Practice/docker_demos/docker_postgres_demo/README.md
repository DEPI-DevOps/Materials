# Docker PostgreSQL Demo

- Create an initialization SQL script `init.sql` for your database.

  - Script may create some tables and insert sample data for testing your application logic during development
  - Try to make the script re-runnable (i.e., by dropping the database if exists before creating it)

## Option #1: Using CLI

- Run a containerized PostgreSQL database server in one command (similar commands exist for your DB/service of choice)

  ```bash
  docker run -d --name postgres --user postgres -e POSTGRES_PASSWORD=postgres -p5432:5432 postgres:alpine
  ```

- Verify the container is running

  ```bash
  docker ps
  ```

- Inspect container log to check if everything works as expected

  ```bash
  docker logs -f postgres
  ```

- Copy initialization script from host to container

  ```bash
  docker cp ./init.sql postgres:/tmp/init.sql
  ```

- Get a shell into the container (you may use `sh` if `bash` is not there in some containers)

  ```bash
  docker exec -it postgres /bin/bash
  $ cat /tmp/init.sql # check the file is there
  ...
  $ psql -f /tmp/init.sql # run the script
  ...
  ```

## Option #2: Using Dockerfile

- Create a Dockerfile to build a custom image (based on the original one) with the initialization script included.

- Build and run the image

  ```bash
  docker build -t my-postgres .
  docker run --rm -it --name my-postgres -p5432:5432 my-postgres
  ```

## Check Results

- Try connecting to your DB at `localhost:5432`. You can connect to it ...

  - Using the CLI (e.g., `psql`)

    ```bash
    docker exec -it my-postgres psql
    ```

  - From source code (e.g., Python)

  - Using DBMS (e.g., [pgAdmin](https://www.pgadmin.org/download/)) or from IDE (e.g., [DataGrip](https://www.jetbrains.com/datagrip/download/), VSCode extensions).

    ![pgAdmin](https://www.w3schools.com/postgresql/screenshot_postgresql_pgadmin4_6.png)
