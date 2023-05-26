create table clientes(codigo int, nombre varchar, saldoActual number(10.2));

insert into clientes (codigo, nombre, saldoActual) values (1, 'Diego', 2); 
insert into clientes (codigo, nombre, saldoActual) values (2, 'Jorge', 4);
insert into clientes (codigo, nombre, saldoActual) values (3, 'Luis', 2000);
insert into clientes (codigo, nombre, saldoActual) values (4, 'Majid', 5000); 

create or replace procedure P001 (wcliente int, wmonto int)
IS
BEGIN
update clientes Set clientes.saldoActual = cliente.saldoActual - wmonto) where clientes.codigo = wcliente;
commit;
END P001;
/

