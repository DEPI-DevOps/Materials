# Sample Java Spring App

## Build

```bash
./mvnw package
```

## Test

```bash
./mvnw test
```

## Run

```bash
java -jar target/main-0.0.1-SNAPSHOT.jar
```

## Docker

```bash
docker build -t app_java .
docker run --rm -it -p8080:8080 app_java
```

## Try

```bash
chromium http://localhost:8080/hello?myName=Ahmed
```

## Publish to GitHub packages

- Add this snippet to your `pom.xml`

```xml
<distributionManagement>
    <repository>
        <id>github</id>
        <name>GitHub Packages</name>
        <url>https://maven.pkg.github.com/USER/REPO</url>
    </repository>
</distributionManagement>
```

- Add server connection snippet to your `~/.m2/settings.xml`

```xml
<settings>
    <servers>
        <server>
        <id>github</id>
            <username>USER</username>
            <password>GH_TOKEN_WITH_PKG_WRITE_ACCESS</password>
        </server>
    </servers>
</settings>
```

- Run the deploy command

```bash
./mvnw deploy
```

## Publish to Local Nexus server

```bash
# Run server
docker run -d -p 8081:8081 --name nexus sonatype/nexus3

# Get the admin password
docker exec -it nexus bash -c 'cat /nexus-data/admin.password' 

# Access the web UI. Login as admin and do the initial configurations
chromium http://localhost:8081

```

- Add server connection snippet to your `~/.m2/settings.xml`

```xml
<server>
    <id>nexus</id>
    <username>USERNAME</username>
    <password>PASSWORD</password>
</server>
```

- Run the deploy command

```bash
mvn deploy:deploy-file -DgeneratePom=false -DrepositoryId=nexus -Durl=http://localhost:8081/repository/maven-snapshots -DpomFile=pom.xml -Dfile=target/main-0.0.1-SNAPSHOT.jar
```
