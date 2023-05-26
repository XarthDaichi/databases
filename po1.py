import cx_Oracle
try:
    con = cx_Oracle.connect('u1/u1@localhost:1521/XE')

except cx_Oracle.DatabaseError as er:
    print('There is error in the Oracle databse: ', er)

else:
    try:
        cur = con.cursor()
        cur.execute('select * from sys.t1')
        rows = cur.fetchall()
        print(rows)

    except cx_Oracle.DatabaseError as er:
        print('There is error in the Oracle databse: ', er)

    except Exception as er:
        print('Error: ', er)

    finally:
        if cur:
            cur.close()
finally:
    if con:
        con.close()
