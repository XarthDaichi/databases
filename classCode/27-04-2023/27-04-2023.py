import cx_Oracle

try:
    connection = cx_Oracle.connect('testing_user/root@localhost:12541/XE')
except cx_Oracle.DatabaseError as er:
    print('There is an error in the Oracle databse: ', er)
else:
    try:
        cursor = connection.cursor()
        cursor.callproc("P001", [4,200])
    except cx_Oracle.DatabseError as er:
        print('There is an error in the Oracle databse: ', er)
    except Exception as er:
        print('Error: ', er)
    finally:
        if cursor:
            cursor.close()
finally:
    if connection:
        connection.close()