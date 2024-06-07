 

[TOC]

# Key-Value Store databases: Redis

Redis (Remote Dictionary Server) is an open source in-memory key-value store, which can be used as a database, cache or a message broker.

- It's a NoSQL database where data is modified/retrieved in the main memory (RAM) for fast retrieval.
    - Disk is still used to persist data and store/load snapshots
- Large companies like Twitter, Pinterest, and Snapchat adopted Redis into their systems to cache results from relational databases for efficiency.
- Every data point in Redis is a key associated with a value.

    - Redis supports different kinds of abstract data structures
    ![](https://estuary.dev/static/4ff882a8a0e3d2ffe69114d10bc2ca58/6435f/02_Redis_Data_Types_Data_Types_51e474ec05.png)


## Quick Start
> Experiment in browser at: https://try.redis.io/
- Run a local Redis server in the background using Docker
    ```bash
    docker run -d -p6379:6379 --name my-redis redis
    ```
- Connect to the server using redis-cli
    ```bash
    docker exec -it my-redis redis-cli
    ```
- Run commands to create and read data
    ```
    127.0.0.1:6379> SET mykey myvalue
    OK
    127.0.0.1:6379> GET mykey
    "myvalue"
    127.0.0.1:6379> exit
    ```
- You can also use [DataGrip](https://www.jetbrains.com/pages/datagrip-for-redis/), or download a special GUI to interact with redis easier
    - [Another Redis Desktop Manager](https://goanother.com/): simple, open-source cross-platform GUI for basic Redis management.
    - [RedisInsight](https://redis.io/insight) (by RedisLabs): for advanced features, real-time insights, and integration with other RedisLabs products.
    ![](https://cdn.jsdelivr.net/gh/qishibo/img/1630655843497-status.png)

## Demo
> Complete list of Redis commands: https://redis.io/docs/latest/commands/
- Run the following common commands to experiment with different redis commands and datatypes
    ```bash
    SET mykey myvalue
    GET mykey
    MSET k1 v1 k2 v2
    GET k2
    
    SET ctr 5
    INCR ctr
    INCRBY ctr 2
    DECR ctr
    DECRBY ctr 2
    GET ctr
    
    LPUSH mylist 3 2 1 
    RPUSH mylist 4 5 6
    LPOP mylist
    RPOP mylist
    LRANGE mylist 0 -1
    
    ZADD mysortedset 1 A 2 B
    ZINCRBY mysortedset 2 A
    ZRANGE mysortedset 0 1 REV WITHSCORES
    
    HMSET myhash f1 v1 f2 v2
    HGET myhash f1
    HGETALL myhash
    ```

## Exercise
- Imagine we need to create a data model to handle player balance (coins) in a game. The system should support the following functionalities:
    - `earn(player_id, amount)`: adds a certain amount to the player wallet
    - `spend(player_id, amount)`: deducts a certain amount from the player wallet (if they have sufficient funds).
    - `transaction_history(player_id)`: returns the history of transactions a certain player performed. 
    - `get_balance(player_id)`: returns current number of coins a player has, based on the history of transactions.
        - Question: why not just have a value storing current balance for each player?
- Player actions are very frequent in the game, so we need a very fast system to update and retrieve such information.demos

- The same functions used in the demo above can be executed against the database from Python using Redis SDK. Complete and test the following code.

    ```python
    import redis
    import json
    
    def earn(player_id, amount):
        r.lpush(f'player_transactions:{player_id}', json.dumps({
            'timestamp': '.'.join(map(str, r.time())),
            'delta': amount
        }))
    
    def spend(player_id, amount):
        pass # TODO: deduct amount from player
    
    def history(player_id):
        pass # TODO: return transaction history for the player
    
    def get_balance(player_id):
        pass # TODO: calculate and return player balance based on history
    
    if __name__ == '__main__':
        r = redis.Redis(
            host='localhost',
            port='6379',
            password='',
            decode_responses=True)
    
        r.flushall()
    
        earn(1, 5)
        earn(2, 5)
        spend(2, 3)
        spend(1, 2)
    
        print(get_balance(1)) # 3
        print(get_balance(2)) # 2
    
        print(history(1)) # ['{"timestamp": "1715033333.141515", "delta": -2}', '{"timestamp": "1715033333.138924", "delta": 5}']
        print(history(2)) # ['{"timestamp": "1715033333.141515", "delta": -2}', '{"timestamp": "1715033333.138924", "delta": 5}']
    ```

## Appendix
Linux commands used during the practical demonstration
```bash
# Install docker
sudo apt update && sudo apt install docker.io

# Add current user to the docker group to execute docker commands without sudo
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# Test docker installation
docker run hello-world

# Run redis server in the background
docker run -d --name my-redis redis

# Exec inside the container to connect to the db and run queries
docker exec -it my-redis redis-cli

# Exec inside the container with a shell to run scripts
docker exec -it my-redis bash

# Install required packages to code Python in terminal
apt install python3 python3-pip python3.11-venv nano

# Create Python virtual environemt and install redis SDK inside
cd /tmp
python3 -m venv venv
source venv/bin/activate
pip3 install redis

# Code
nano main.py # save with Ctrl+X --> Y --> Enter
```



# Wide-Column databases: Apache Cassandra

Cassandra is an open-source wide-column database popular for its reliability and performance with distributed large (petabytes) volumes of data.

- It's a general-purpose NoSQL database, with use cases for e-commerce, content management, audit logging, and more.
- Cassandra is used by large companies like Apple, Discord, SoundCloud, and Netflix.

![](https://cassandra.apache.org/_/_images/diagrams/apache-cassandra-diagrams-01.jpg)


## Architecture
> Overview: https://cassandra.apache.org/doc/latest/cassandra/architecture/overview.html
- Data is distributed over nodes (i.e., peers organized in a ring structure). Any peer may accept read/write operations.
- Peers communicate and share information using [Gossip protocol](https://www.geeksforgeeks.org/gossip-protocol-in-cassandra/)
- Each node is responsible for a subset (partition) of data. However, replication mechanisms are used to ensure reliability.
- Data is organized in *keyspaces*, each containing one or more *tables*, each having one or more *columns*.
    - A keyspace is the container of all data in Cassandra. Replication is specified at the keyspace level.
    - A table (or column family) has a flexible schema, meaning that rows can have different sets of columns, allowing for sparse data storage.

![](https://www.researchgate.net/publication/274174394/figure/fig6/AS:668443506384898@1536380759059/cassandra-data-model.ppm)


## Cassandra Query Language (CQL)
> Documentation: https://cassandra.apache.org/doc/stable/cassandra/cql/

- CQL is similar to SQL in terms of syntax, it supports native types (e.g., `VARCHAR, BOOLEAN, INT, FLOAT, DOUBLE, DATE, BLOB, ...`) and three types of collections (`map`, `set`, and `list`).

- CQL does not support joins by design.

    - In an RDBMS, one may create separate tables (`user`, `posts`, and `comments`) and join them as needed.
    - The corrspondnig approach in Cassandra would be to create tables like `posts_by_user` and `comments_by_user` to speed-up retrieval for common queries.

- CQL supports Indexes and User-Defined Functions (UDFs), but does not directly implement the conventional SQL views, triggers, or stored procedures.


## Quick Start
> Official Guide: https://cassandra.apache.org/doc/latest/cassandra/getting-started/cassandra-quickstart.html

1. Run a Cassandra instance using Docker
    ```bash
    docker run -it -p9042:9042 -d --name cassandra cassandra
    ```

2. Wait for some time for the DB to fully initialize, you can inspect the logs to see if everything is working as expected with
    ```bash
    docker logs -f cassandra
    ```

3. Exec into the container to get a CQL shell. By default it'll try to connect to `localhost:9042` but you can set `CQLSH_HOST` and `CQLSH_PORT` environment variables to use a different hostname and port number.
    ```bash
    docker exec -it cassandra cqlsh
    ```
    
    > Alternatively, you can specify option `-p9042:9042` with the `docker run` command to expose Cassandra port. Then connect using a GUI like [NoSQL Manager](https://www.mongodbmanager.com/cassandra/download) or [DataGrip](https://www.jetbrains.com/datagrip/) 

4. Run CQL queries to create a keyspace, a table and insert some data
    > Reading 1: [Key types in Cassandra](https://stackoverflow.com/questions/24949676/difference-between-partition-key-composite-key-and-clustering-key-in-cassandra)
    > Reading 2: [Cassandra Data Modeling](https://www.moelzayat.com/cassandra-data-modeling/)
    ```sql
    -- Create a keyspace named "userspace".
    -- Replication factor specifies replica count in the cluster 
    CREATE KEYSPACE IF NOT EXISTS userspace WITH replication =
    { 'class' : 'SimpleStrategy', 'replication_factor' : 3 };
    
    -- To make the script rerunnable
    DROP TABLE IF EXISTS userspace.users;
    
    -- Create a member table named "users" in the keyspace
    CREATE TABLE userspace.users (
      user_id int,
      username text,
      gender text,
      age int,
      city text,
      interests list<text>,
      PRIMARY KEY ((age, user_id)) -- age: partition key, user_id: clustering key
    );
    
    -- Insert sample data
    INSERT INTO userspace.users (user_id, username, gender, age)
    VALUES (123, 'JohnDoe', 'M', 20);
    
    INSERT INTO userspace.users (user_id, username, gender, age, city)
    VALUES (456, 'JaneDoe', 'F', 25, 'New York');
    
    INSERT INTO userspace.users (user_id, username, gender, age, interests)
    VALUES (789, 'TechGuru', 'M', 30, ['Programming', 'AI']);
    
    -- Create an index on gender column
    CREATE INDEX IF NOT EXISTS idx_gender ON userspace.users(gender);
    ```

5. Query the data as usual
    > Note: for the query to be performant, an index on the `gender` column was needed. 

    ```cql
    cqlsh> SELECT avg(age) AS avg_male_age FROM userspace.users WHERE gender = 'M';
    
     avg_male_age
    --------------
               25
    
    (1 rows)
    ```

## Exercise

- Install Python Cassandra SDK
    ```bash
    pip install cassandra-driver
    ```

- Connect to the db and run a test query
    ```bash
    from cassandra.cluster import Cluster
    
    cluster = Cluster(['localhost'])
    session = cluster.connect('userspace')
    
    res = session.execute('SELECT * FROM userspace.users;')
    
    for row in res:
        print(row)
    
    session.shutdown()
    cluster.shutdown()
    ```

- Design a table
    ```
    player_stats (
        int player_id,
        int kills,
        int exp,
        list<int> inventory;
        float playtime;    
    )
- Write Python functions for `login`, `logout`, `pickup_item`, `kill_enemy` and test them in main.
    ```python
    def login(player_id):
        pass # start monitoring playtime
    
    def logout(player_id):
        pass # accumulate playtime
    
    def pickup_item(player_id, item_id):
        pass # put item in inventory and get +5 Exp
    
    def kill_enemy(player_id, points):
        pass # increment kills and get +points Exp
        
    def main():
        # player 1 logs in,
        #  picks up sword (item_id=1234) (show inventory),
        #  kills an enemy to get 10 Exp (show exp),
        #  then logs out (show total playtime).
        # do the above logic twice.
        
    ```



# Document & Graph Databases: MongoDB & Neo4J

## MongoDB
MongoDB is a document-oriented database that's popular for its flexibility and scalability.
- Data is organized into collections.
    - Collections help with sharding (horizontal scalability)
- A collection consists of one or more JSON-like documents
    - Each docuemnt in the collection is automatically assigned a unique ID.
    - A document consists of (field, value) pairs
    - Common datatypes for values include String, Double, Int32, Int64, Date. Lists and nested objects are permitted.

![](https://miro.medium.com/v2/resize:fit:1400/1*xt4HBiJX9gwv2jJPmbrEJQ.jpeg)


### Getting started
- Run a local MongoDB server in the background using Docker
    ```bash
    docker run -d -p27017:27017 --name mongo mongo
    ```
- Connect to the server using `mongosh`
    ```bash
    docker exec -it mongo mongosh
    ```
- Run commands to do some CRUD operations
    > Mongodb queries use a syntax similar to Javascript. Different types of queries (filteration, aggregation, geopspatial) are supported.

    ```javascript
    test> show dbs
    admin   40.00 KiB
    config  12.00 KiB
    local   40.00 KiB
      
    testdb> use testdb
    switched to db testdb
      
    testdb> db.users.insertOne({ name: "Alice", age: 30 })
    {
      acknowledged: true,
      insertedId: ObjectId('664b7e95a584c6f9852202d9')
    }
      
    testdb> db.users.insertMany([{ name: "Bob", age: 25, city: "London" },
                                 { name: "Charlie", age: 40, city: "Paris" }])
    {
      acknowledged: true,
      insertedIds: {
        '0': ObjectId('664b7e9ba584c6f9852202da'),
        '1': ObjectId('664b7e9ba584c6f9852202db')
      }
    }
      
    testdb> show collections    
    users
    
    testdb> db.users.find({age: { $gt: 25, $lte: 30 }})
    [
      {
        _id: ObjectId('664b7e95a584c6f9852202d9'),
        name: 'Alice',
        age: 30,
        city: 'New York'
      }
    ]
      
    testdb> db.users.updateOne({name: "Bob"}, { $set: { name: "Robert" }})
   {
      acknowledged: true,
      insertedId: null,
      matchedCount: 1,
      modifiedCount: 1,
      upsertedCount: 0
    } 
    
    testdb> db.users.deleteOne({_id: ObjectId('664b7e95a584c6f9852202d9')})
    { acknowledged: true, deletedCount: 1 }
   ```
- You can also use [DataGrip](https://www.jetbrains.com/pages/datagrip/), or use [MongoDB Compass](https://www.mongodb.com/try/download/compass) to interact with mongo easier.

## Neo4j
Neo4j is a very popular ACID-compliant database that uses a graph model for modeling and storing data. It is used in multiple areas, including social networks, knowledge graphs, and recommendation systems. 

**Essential Terminology**
- **Nodes** represent entities
- **Edges** represent relations between nodes
- **Properties** are key-value pairs that store data about nodes/edges.

Neo4j Queries are written in Cypher. Nodes are surrounded by parenthesis. They connect to other nodes by arrows via edges surrounded by brackets

Example queries to model a follow relationship between two users. Then display the graph.
```cypher
CREATE (:User {name: "Bob"}) -[:FOLLOWS]-> (:User {name: "Alice"})
```

```cypher
MATCH (x:User) RETURN x
```

### Getting Started

- Run a local Neo4j server in the background using Docker
    ```bash
    docker run -d -p7474:7474 -p7687:7687 --env=NEO4J_AUTH=none --name neo4j neo4j
    ```
- Connect to the web UI from the browser at http://localhost:7474
    - The database service is accessible at `localhost:7687`
    ![](https://dist.neo4j.com/wp-content/uploads/neo4j_22_browser.png)

- The WebUI comes with a sample movie database and an interactive tutorial for getting started with Neo4j and Cypher. Follow the tutorial!

## Exercise

Consider a system of users following each other, modeled in SQL, MongoDB, and Neo4j. Write a query in SQL, MongoDB, and Cypher to return the names of all users following "Alice".
- Sample data is inserted to the DB as follows.
- Compare the complexity of the query in each case.

### SQL
```sql
-- Inserting into the users table
INSERT INTO users (user_id, username) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'David');

-- Inserting into the follows table
INSERT INTO follows (follower_id, followed_id) VALUES
(1, 2),
(1, 3),
(2, 1),
(3, 2),
(4, 1);
```

### MongoDB

```json
// Inserting into the users collection
db.users.insertMany([
    { user_id: 1, username: "Alice" },
    { user_id: 2, username: "Bob" },
    { user_id: 3, username: "Charlie" },
    { user_id: 4, username: "David" }
]);

// Inserting into the follows collection
db.follows.insertMany([
    { follower_id: 1, followed_id: 2 },
    { follower_id: 1, followed_id: 3 },
    { follower_id: 2, followed_id: 1 },
    { follower_id: 3, followed_id: 2 },
    { follower_id: 4, followed_id: 1 }
]);
```

### Neo4j (Cypher)
```cypher
// Creating nodes for users
CREATE (:User { user_id: 1, username: 'Alice' }),
       (:User { user_id: 2, username: 'Bob' }),
       (:User { user_id: 3, username: 'Charlie' }),
       (:User { user_id: 4, username: 'David' });

// Creating relationships for follows
MATCH (a:User { user_id: 1 }), (b:User { user_id: 2 })
CREATE (a)-[:FOLLOWS]->(b);

MATCH (a:User { user_id: 1 }), (b:User { user_id: 3 })
CREATE (a)-[:FOLLOWS]->(b);

MATCH (a:User { user_id: 2 }), (b:User { user_id: 1 })
CREATE (a)-[:FOLLOWS]->(b);

MATCH (a:User { user_id: 3 }), (b:User { user_id: 2 })
CREATE (a)-[:FOLLOWS]->(b);

MATCH (a:User { user_id: 4 }), (b:User { user_id: 1 })
CREATE (a)-[:FOLLOWS]->(b);
```
