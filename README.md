### Description of the project

the project is a task manager API built with Ruby on Rails. It enables users to manage their tasks efficiently, and it should provide endpoints for creating, reading, updating, and deleting a task. 

## Requirement
- PostreSQL (psql) for database management
- Node
- Ruby
- Create `.env` file and copie the content of [env.template](.env.template)

### Initial set up
- Run the command below
```bash
 bundle install && bin/rails db:prepare db:create db:migrate db:fixtures:load
```
- it will
    - prepare and create the database
    - do all migration
    - Load fixtures

### Launch server
- Run the command below
```bash
rails server 
```

Open your browser and go to <http://127.0.0.1:3000/>

