import oracledb

username="sys as sysdba"
userpwd ="X_v.E2023"
host = "localhost"
port = 1521
service_name = "XE"

dsn = f'{username}/{userpwd}@{host}:{port}/{service_name}'

with oracledb.connect(dsn) as connection:
        with connection.cursor() as cursor:
                sql = """select sysdate from dual"""
                for r in cursor.execute(sql):
                        print(r)
