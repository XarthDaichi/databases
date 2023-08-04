drop table solicitud_compra;
drop table requisicion_materiales;
drop table orden_trabajo;
drop table orden_produccion;
drop table inventario_bodega;
drop table bodegas;
drop table componentes;
drop table materias_primas;
drop table productos;
drop table familia_productos;
drop table facturas;
drop table clientes;
drop table tipo_clientes;
drop table zonas;
drop table vendedores;
drop table temp_triggers;

create table vendedores (
    codigo int GENERATED BY DEFAULT ON NULL AS IDENTITY,
    nombre varchar(30),
    total_vendido int,
    comision_anual int,
    constraint pkvendedor primary key (codigo)
);

create table zonas (
    codigo int GENERATED BY DEFAULT ON NULL AS IDENTITY,
    nombre varchar(30),
    total_clientes int,
    total_ventas int,
    constraint pkzonas primary key (codigo)
);

create table tipo_clientes (
    codigo int GENERATED BY DEFAULT ON NULL AS IDENTITY,
    descuento int,
    limite_credito int,
    plazo_maximo int,
    constraint pktipo_cliente primary key (codigo)
);

create table clientes (
    codigo int GENERATED BY DEFAULT ON NULL AS IDENTITY,
    nombre varchar(30),
    total_compra int,
    tipo_cliente int,
    zona int,
    vendedor int,
    constraint pkcliente primary key (codigo),
    constraint fkcliente1 foreign key (vendedor) references vendedores(codigo),
    constraint fkcliente2 foreign key (tipo_cliente) references tipo_clientes(codigo),
    constraint fkcliente3 foreign key (zona) references zonas (codigo)
);

create table facturas (
    numero int GENERATED BY DEFAULT ON NULL AS IDENTITY,
    fecha_creacion date,
    tipo_factura int,
    subtotal_factura int,
    total_impuesto int, 
    total_descuento int,
    total_factura int, 
    saldo_factura int,
    cliente int,
    estado int,
    constraint pkfactura primary key (numero),
    constraint fkfactura1 foreign key (cliente) references clientes(codigo)
);

create table familia_productos (
    codigo int GENERATED BY DEFAULT ON NULL AS IDENTITY,
    descripcion varchar(30),
    constraint pkfamilia_productos primary key (codigo)
);

create table productos (
    codigo int GENERATED BY DEFAULT ON NULL AS IDENTITY,
    nombre varchar(30),
    precio_venta int,
    utilidad int,
    familia int, 
    constraint pkproducto primary key (codigo),
    constraint fkproducto foreign key (familia) references familia_productos (codigo)
);

create table materias_primas (
    codigo int GENERATED BY DEFAULT ON NULL AS IDENTITY,
    nombre varchar(30),
    cantidad_actual int,
    cantidad_minima int,
    cantidad_reorder int,
    ultimo_precio int,
    proveedor int,
    constraint pkmaterias_primas primary key (codigo)
);

create table componentes (
    producto int,
    materia_prima int,
    cantidad int,
    constraint pkcomponentes primary key (producto, materia_prima),
    constraint fkcomponentes1 foreign key (producto) references productos (codigo),
    constraint fkcomponentes2 foreign key (materia_prima) references materias_primas (codigo)
);

create table bodegas (
    codigo int GENERATED BY DEFAULT ON NULL AS IDENTITY, 
    zona int,
    constraint pkbodega primary key (codigo),
    constraint fkbodega foreign key (zona) references zonas (codigo)
);

create table inventario_bodega (
    bodega int,
    producto int,
    cantidad_actual int,
    cantidad_minima int,
    cantidad_reorder int,
    constraint pkinventario_bodega primary key (bodega, producto),
    constraint fkinventario_bodega1 foreign key (bodega) references bodegas (codigo),
    constraint fkinventario_bodega2 foreign key (producto) references productos (codigo)
);

create table orden_produccion (
    numero int GENERATED BY DEFAULT ON NULL AS IDENTITY,
    producto int, 
    cantidad int,
    bodega int,
    fecha date,
    estado int, -- 1. pendiente | 2. rechazada | 3. cumplida
    constraint pkorden_produccion primary key (numero),
    constraint fkorden_produccion1 foreign key (producto) references productos (codigo),
    constraint fkorden_produccion2 foreign key (bodega) references bodegas (codigo)
);

create table orden_trabajo (
    numero int GENERATED BY DEFAULT ON NULL AS IDENTITY,
    orden_produccion int,
    fecha date,
    estado int, -- 1. pendiente | 2. rechazada | 3. cumplida
    constraint pkorden_trabajo primary key (numero),
    constraint fkorden_trabajo foreign key (orden_produccion) references orden_produccion (numero)
);

create table requisicion_materiales (
    orden_trabajo int,
    materia int,
    cantidad int,
    estado int, -- 1. pendiente | 2. rechazada | 3. cumplida
    constraint pkrequsicion primary key (orden_trabajo, materia),
    constraint fkrequisicion_materiales1 foreign key (orden_trabajo) references orden_trabajo (numero),
    constraint fkrequisicion_materiales2 foreign key (materia) references materias_primas (codigo)
);

create table solicitud_compra (
    proveedor int, 
    materia int, 
    cantidad int, 
    fecha date, 
    estado int,
    constraint fksolicitud_compra foreign key (materia) references materias_primas (codigo)
);

create or replace type bodeguero as object (
    nombre VARCHAR(30),
    member function actualizar_requisicion (worden_trabajo int, wmateria int) return INTEGER,
    member function actualizar_requisiciones return INTEGER
);
/

create or replace type body bodeguero as
    member function actualizar_requisicion (worden_trabajo int, wmateria int) return INTEGER IS

    cantidad_requisicion requisicion_materiales.cantidad%TYPE;


    wcantidad_actual materias_primas.cantidad_actual%TYPE;
    wcantidad_minima materias_primas.cantidad_minima%TYPE;
    BEGIN
        SELECT cantidad_actual, cantidad_minima into wcantidad_actual, wcantidad_minima from materias_primas where codigo = wmateria;
        IF wcantidad_actual >= wcantidad_minima THEN
            select cantidad into cantidad_requisicion from requisicion_materiales where orden_trabajo = worden_trabajo and materia = wmateria;
            update materias_primas
            set cantidad_actual = cantidad_actual - cantidad_requisicion
            where codigo = wmateria;
            update requisicion_materiales
            set estado = 3
            where orden_trabajo = worden_trabajo and materia = wmateria;
        ELSE
            update requisicion_materiales
            set estado = 2
            where orden_trabajo = worden_trabajo and materia = wmateria;
        END IF;

        RETURN 1;
        EXCEPTION
            WHEN OTHERS THEN
                RETURN 0;
    END;

    member function actualizar_requisiciones return INTEGER is
        worden_trabajo requisicion_materiales.orden_trabajo%TYPE;
        wmateria requisicion_materiales.materia%TYPE;

        CURSOR cur IS
            SELECT orden_trabajo, materia
            FROM requisicion_materiales;

        result INTEGER;
    BEGIN
        open cur;

        LOOP
            FETCH cur into worden_trabajo, wmateria;

            EXIT WHEN cur%NOTFOUND;

            result := actualizar_requisicion(worden_trabajo, wmateria);
            IF result = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Fallo al hacer una requisicion');
            END IF;

        END LOOP;

        CLOSE cur;

        RETURN 1;

        EXCEPTION
            WHEN OTHERS THEN
                RETURN 0;
    end;
end;
/

create table temp_triggers (
    orden_produccion int,
    cantidad_reordering int,
    producto_reordering int,
    constraint pktemp_triggers primary key (orden_produccion)
);

create or replace trigger tr001
after update on inventario_bodega
for each row
BEGIN
    if :NEW.cantidad_actual < :OLD.cantidad_minima THEN
        insert into orden_produccion (producto, cantidad, bodega, fecha, estado)
            values (:OLD.producto, :OLD.cantidad_reorder, :NEW.bodega, sysdate, 1);
    end if;
end;
/

create or replace trigger tr002
after insert on orden_produccion
for each row
BEGIN
    insert into temp_triggers (orden_produccion, cantidad_reordering, producto_reordering) values (:NEW.numero, :NEW.cantidad, :NEW.producto);
    insert into orden_trabajo (orden_produccion, fecha, estado) values (:NEW.numero, sysdate, 1);
end;
/

create or replace trigger tr003
after insert on orden_trabajo
for each row
DECLARE
    wproducto temp_triggers.producto_reordering%TYPE;
    wcantidad temp_triggers.cantidad_reordering%TYPE;
    wproducto_componentes componentes.producto%TYPE;
    wmateria_componentes componentes.materia_prima%TYPE;
    wcantidad_componentes componentes.cantidad%TYPE;

    CURSOR cur1 IS
        SELECT producto, materia_prima, cantidad
        FROM componentes;
BEGIN
    select producto_reordering, cantidad_reordering into wproducto, wcantidad
    from temp_triggers
    where orden_produccion = :NEW.orden_produccion;

    open cur1;

    LOOP
        FETCH cur1 into wproducto_componentes, wmateria_componentes, wcantidad_componentes;

        EXIT WHEN cur1%NOTFOUND;
        IF wproducto_componentes = wproducto THEN
            insert into requisicion_materiales (orden_trabajo,materia,cantidad,estado) values (:NEW.numero, wmateria_componentes, wcantidad_componentes * wcantidad, 1);
        END IF;
    END LOOP;
    CLOSE cur1;
end;
/

create or replace trigger tr004
after update on materias_primas
for each row
BEGIN
    if :NEW.cantidad_actual < :OLD.cantidad_minima THEN
        insert into solicitud_compra (proveedor, materia, cantidad, fecha, estado)
            values (:OLD.proveedor, :OLD.codigo, :OLD.cantidad_reorder, sysdate, 1);
    end if;
end;
/

create or replace trigger tr005
after update on requisicion_materiales
for each row
DECLARE
    amount_green int,
    westado int,
    CURSOR cur2 IS
        SELECT estado
        FROM requisicion_materiales
        WHERE orden_trabajo = :OLD.orden_trabajo;
BEGIN
    amount_green = 0;
    open cur2;
    LOOP 
        FETCH cur2 into westado;
        EXIT WHEN cur2%NOTFOUND;
        if westado = 3 THEN
            amount_green = amount_green +1;
        END IF;
    END LOOP;
    IF :NEW.estado <> :OLD.estado THEN
        IF :NEW.estado = 3 THEN
            amount_green = amount_green +1;
            IF amount_green = cur2%ROWCOUNT THEN
                select estado into westado from orden_trabajo where numero = :OLD.orden_trabajo;
                IF westado <> 2 THEN
                    update orden_trabajo set estado = 3 where numero = :OLD.orden_trabajo;
                END IF;
            END IF;
        ELSIF :NEW.estado = 2 THEN
            update orden_trabajo set estado = 2 where numero = :OLD.orden_trabajo;
        END IF;
    END IF;
    close cur2;
end;
/

create or replace trigger tr006
after update on orden_trabajo
for each row
BEGIN
    IF :OLD.estado <> :NEW.estado THEN
        IF :NEW.estado = 3 THEN
            update orden_produccion set estado = 3 where numero = :OLD.orden_produccion;
        ELSIF :NEW.estado = 2 THEN
            update orden_produccion set estado = 2 where numero = :OLD.orden_produccion;
        END IF;
    END IF:
END;
/

create or replace trigger tr007
after update on orden_produccion
for each row
BEGIN
    IF :OLD.estado <> :NEW.estado and :NEW.estado = 3 THEN
        update inventario_bodega set cantidad_actual = cantidad_actual + :OLD.cantidad where producto = :OLD.producto and bodega = :OLD.bodega;
    END IF;
END;
/

insert into familia_productos (descripcion) values ('test1');
insert into productos (nombre, precio_venta,utilidad,familia) values ('Pan', 1000, 70, 1);
insert into productos (nombre, precio_venta,utilidad,familia) values ('Arroz', 2000, 60, 1);
insert into productos (nombre, precio_venta,utilidad,familia) values ('Cafe', 3000, 50, 1);
insert into materias_primas (nombre,cantidad_actual,cantidad_minima,cantidad_reorder,ultimo_precio,proveedor) values ('Harina', 30, 5, 50, 300, 1);
insert into materias_primas (nombre,cantidad_actual,cantidad_minima,cantidad_reorder,ultimo_precio,proveedor) values ('Huevos', 30, 5, 50, 300, 1);
insert into materias_primas (nombre,cantidad_actual,cantidad_minima,cantidad_reorder,ultimo_precio,proveedor) values ('Cafeina', 20, 10, 30, 400, 2);
insert into componentes (producto, materia_prima, cantidad) values (1, 1, 2);
insert into componentes (producto, materia_prima, cantidad) values (1, 2, 2);
insert into componentes (producto, materia_prima, cantidad) values (3, 3, 5);
insert into zonas (nombre,total_clientes,total_ventas) values ('Guapiles', 4, 4);
insert into bodegas (zona) values (1);
insert into bodegas (zona) values (1);
insert into inventario_bodega (bodega,producto,cantidad_actual,cantidad_minima,cantidad_reorder) values (1, 1, 500, 100, 10);
insert into inventario_bodega (bodega,producto,cantidad_actual,cantidad_minima,cantidad_reorder) values (2, 3, 600, 50, 50);
update inventario_bodega set cantidad_actual = 0 where bodega = 1 and producto = 1;
update inventario_bodega set cantidad_actual = 0 where bodega = 2 and producto = 3;

select * from materias_primas;
select * from requisicion_materiales;

set serveroutput on size 30000;
declare
    juan bodeguero;
BEGIN
    juan := bodeguero('Juan');
    dbms_output.put_line('result = ' || juan.actualizar_requisiciones);
END;
/

select * from requisicion_materiales;
select * from materias_primas;