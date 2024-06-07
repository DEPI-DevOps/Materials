import psycopg2
from dotenv import dotenv_values


sql = "SELECT * FROM users;"
conf = dotenv_values('.env')

try:
    conn = psycopg2.connect(host=conf['HOST'],
                            port=conf['PORT'],
                            dbname=conf['DATABASE'],
                            user=conf['USER'],
                            password=conf['PASSWORD']
                            )

    cur = conn.cursor()
    cur.execute(sql)
    rows = cur.fetchall()

    print("Fetched data:")

    for row in rows:
        print(row)

    conn.commit()
    cur.close()

except (Exception, psycopg2.Error) as error:
    print("Error while connecting to PostgreSQL", error)

print("PostgreSQL connection closed")
