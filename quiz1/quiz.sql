create table Zona (
    codigo int,
    nombre varchar(30),
    constraint zonaPK PRIMARY KEY (codigo)
);

create table Producto (
    codigo int,
    costo int,
    utilidad int,
    precio int,
    constraint productoPK PRIMARY KEY (codigo)
);

create table Inventario (
    zona int,
    producto int,
    cantidad int,
    cantidad_minima int,
    constraint inventarioPK PRIMARY KEY (zona, producto),
    constraint inventarioFKzona FOREIGN KEY (Zona) references Zona(codigo),
    constraint inventarioFKproducto FOREIGN KEY (Producto) references producto(codigo)
);

create table Movimiento (
    codigo_producto int,
    zona int,
    cantidad int,
    tipo_mov int
);

insert into Zona (codigo, nombre) values (1, 'Alajuela');
insert into Zona (codigo, nombre) values (2, 'HEREDIA');
insert into Zona (codigo, nombre) values (4, 'GUAPILES');
insert into Producto (codigo, costo, utilidad, precio) values (32, 100, 10, 110);
insert into Inventario (producto, zona, cantidad, cantidad_minima) values (32, 1, 10, 5);
insert into Inventario (producto, zona, cantidad, cantidad_minima) values (32, 2, 5, 5);
insert into Inventario (producto, zona, cantidad, cantidad_minima) values (32, 4, 0, 0);
insert into Movimiento (codigo_producto, zona, cantidad, tipo_mov) values (32, 2, 3, 1);
insert into Movimiento (codigo_producto, zona, cantidad, tipo_mov) values (32, 4, 10, 2);
insert into Movimiento (codigo_producto, zona, cantidad, tipo_mov) values (32, 1, 2, 3);
insert into Movimiento (codigo_producto, zona, cantidad, tipo_mov) values (32, 2, 1, 4);

select * from Inventario;

select * from Movimiento;

create or replace procedure P001_Movimiento
IS 
    -- CURSOR cur_filas IS SELECT codigo_producto, zona, cantidad, tipo_mov FROM Movimiento;
    CURSOR cur_filas IS REF;
    var_producto INT;
    var_zona INT;
    var_cantidad INT;
    var_tipo_mov INT;
BEGIN
    OPEN cur_filas for SELECT codigo_producto, zona, cantidad, tipo_mov FROM Movimiento;
    FETCH cur_filas INTO var_codigo_producto, var_zona, var_cantidad, var_tipo_move;
    WHILE cur_filas%FOUND LOOP
        IF var_tipo_mov = 1 OR var_tipo_mov = 4 THEN
            update Inventario SET cantidad = cantidad - var_cantidad
            WHERE zona = var_zona AND producto = var_codigo_producto;
        ELSE
            update Inventario SET cantidad = cantidad + var_cantidad
            WHERE zona = var_zona AND producto = var_codigo_producto;
        END IF;
        commit;
        FETCH cur_filas INTO var_codigo_producto, var_zona, var_cantidad, var_tipo_move;
    END LOOP;
    CLOSE cur_filas;
END;
/

execute P001_Movimiento;

select * from Inventario;
