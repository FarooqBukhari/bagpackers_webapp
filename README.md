
# Ruby version: 2.6.6
# Rails Version: 6.0.3.3
# Postgresql Version: 12

# Commands to run in the terminal to setup the Project:
1. Git clone
2. bundle install
3. Create Postgres User using following steps:
  * `psql postgres`
  * `CREATE USER root WITH ENCRYPTED PASSWORD 'root';`
  * `CREATE DATABASE bagpackers_development;`
  * `CREATE DATABASE bagpackers_test;`
  * `ALTER USER root WITH SUPERUSER;`
  * `GRANT ALL PRIVILEGES ON DATABASE bagpackers_test TO root;`
  * `GRANT ALL PRIVILEGES ON DATABASE bagpackers_development TO root;`
  * `\q`

4. `EDITOR=vim rails credentials:edit` => (Copy paste the next lines)
***
`stripe:
  development:
    publishable_key: 'pk_test_K7zdMSeymVJ9DlCyPxPY2Skd00j6IJX7ZX'
    secret_key: 'sk_test_m6E9WtDjb4lpaIo7FQnYtTcu008Um2ym8O'`
***
Press escape then type <:wq> 

5. rails db:schema:load
6. rails db:seed
7. yarn install
8. rails s
