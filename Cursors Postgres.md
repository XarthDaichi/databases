##### Por Oracle
```sql
create procedure P001
	(C1 out sys.REFCURSOR)
IS
BEGIN
	OPEN C1 for Select
	// ...
END;
```

VS.
```sql
create procedure P001
IS
	C1 "select ..."
BEGIN

//...
```

##### Por cx.Oracle
```python
connect.()
CA.cursor()

# connects to database etc...
```

Reducción de memoria
Sigma Pi
