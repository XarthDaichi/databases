create table Bodega (
    codigo int,
    constraint PKB PRIMARY KEY (codigo)
);

create table Producto (
    codigo int,

    constraint PKP PRIMARY KEY (codigo)
);

create table Inventario(
    tipo int,
    B int,
    P int,
    cant int,
    minim int,
    reorder int,
    constraint FKIB FOREIGN KEY (B) references Bodega(codigo),
    constraint FKIP FOREIGN KEY (P) references Producto(codigo)
);

create table Movimiento (
    tipo int,
    p int, 
    cant,
    b int,
    fecha Date
);

create table OrdenDeProduccion (
    producto int,
    reorder int,
    fecha Date,
    hora Time,
    usuario int,
    constraint FKOP FOREIGN KEY (producto) references Producto(codigo),
);

create or replace procedure P0037 (fecha1 Date, fecha2 Date)
IS
    wtipo Movimiento.tipo%TYPE;
    wp Movimiento.p%TYPE;
    wcant Movimiento.cant%TYPE;
    wb Movimiento.b%TYPE;
    c1 SYS_REFCURSOR;
BEGIN
    OPEN c1 FOR
    SELECT * FROM Movimiento
    WHERE fecha >= fecha1 AND fecha <= fecha2;
    LOOP
        FETCH c1 INTO wtipo, wp, wcant, wb;

        EXIT WHEN c1%NOTFOUND;

        IF wtipo = 1 THEN
            UPDATE Inventario
            SET cant = cant - wcant
            WHERE P = wp AND B = wb;
        ELSE 
            UPDATE Inventario
            SET cant = cant + wcant
            WHERE P = wp AND B = wb;
        END IF;
    END LOOP;
    CLOSE c1;
END;
/

create or replace procedure P0075(wP, wReorder)
BEGIN

create or replace trigger tr027
AFTER UPDATE on Inventario
FOR EACH ROW
BEGIN
    IF :NEW.cant <= :OLD.minim THEN
        P0075(:NEW.P, :NEW.reorder)
    END IF;
END;
/