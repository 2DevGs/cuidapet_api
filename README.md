
## _CuidaPet API_

This project is a basic API made to support the Cuidapet Mobile project.

To start this project, it will be necessary to use two documents:
- .env 
- docker-compose.yaml

For the .env use this structure:

```dart
databaseHost=localhost
databaseUser=root
databasePassword=YOURPASSWORD
databasePort=3306
databaseName=YOURDBNAME (Preferably cuidapet_db)
jwtSecret=YOURKEY
```

For the docker-compose.yaml use the structure:

```dart
version: '3.1'
services:
  db:
    image: mysql:8.0.23
    command: --default-authentication-plugin=mysql_native_password
    ports:
      - 3306:3306
    environment:
      MYSQL_DATABASE: YOURDBNAME (Preferably cuidapet_db)
      MYSQL_ROOT_PASSWORD: YOURPASSWORD
    volumes:
      - ../mysql_data:/var/lib/mysql
```

## SECURITY FAILURES

> I am a beginner and there may be some security flaws, 
> but all flaws will be fixed 
> and invalidated according to progress.

## NOTES

This project is just a support for the Cuidapet Mobile found in the repository:

- [Cuidapet Mobile](https://github.com/2DevGs/cuidapet_mobile)

You may find some unnecessary files in this project, just ignore it may be a note.

| dependencies | Version |
| ------ | ------ |
| Flutter | 3.24.4 |
| Dart | 3.5.4 |
| args | ^2.4.0 |
| shelf | ^1.4.0 |
| shelf_router | ^1.1.0 |
| dotenv | ^4.2.0 |
| mysql1 | ^0.20.0 |
| get_it | ^8.0.3 |
| logger | ^2.5.0 |
| injectable | ^2.5.0 |
| injectable_generator | ^2.6.2 |
| jaguar_jwt | ^3.0.0 |

| devDependencies | Version |
| ------ | ------ |
| http | ^1.1.0 |
| lints | ^4.0.0 |
| test | ^1.24.0 |
| build_runner | ^2.4.13 |
| shelf_router_generator | ^1.1.0 |
  
## Tech

- [Docker](https://www.docker.com/) - Docker is an open-source platform that enables developers to automate the deployment, scaling, and management of applications within lightweight, portable containers. Containers package an application and its dependencies, ensuring consistent performance across different environments. Docker uses operating system-level virtualization to deliver software in packages called containers, which are isolated from one another and bundle their own software, libraries, and configuration files.
- [VSCode](https://code.visualstudio.com/) - Visual Studio Code is a source code editor developed by Microsoft for Windows, Linux, and macOS. It includes support for debugging, built-in Git version control, syntax highlighting, intelligent code completion, snippets, and code refactoring. It is customizable, allowing users to change the editor's theme, shortcut keys, and preferences. It is free and open-source software, although the official download is under a proprietary license.
