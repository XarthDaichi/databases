import cx_Oracle

try:
    con = cx_Oracle.connect(user='u1', password='u1', host="localhost", port=1521, service_name="orclpdb")
except cx_Oracle.DatabaseError as er:
    print('There is error in the Oracle database: ', er)


else:
    try:
        cur = con.cursor()
        cur.execute('select * from sys.t1')
        rows = cur.fetchall()
        print(rows)
    except cx_Oracle.DatabaseError as er:
        print('There is error in the Oracle database: ', er)
    except Exception as er:
        print('Error: ', er)
    finally:
        if cur:
            cur.close()
            
finally:
    if con:
        con.close()
