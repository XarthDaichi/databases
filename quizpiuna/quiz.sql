create table pago(
    fecha date,
    monto int,
    factura int,
    constraint pago_facFK FOREIGN KEY (factura) references factura(factura)
);

create table forma_pago(
    forma_pago int,
    nombre_forma_pago varchar(10),
    constraint forma_pagoPK PRIMARY KEY(forma_pago)
);

create table factura(
    factura int,
    fecha_original date,
    monto int,
    saldo int,
    forma_pago int,
    constraint facturaPK PRIMARY KEY (factura),
    constraint factura_FPFK FOREIGN KEY (forma_pago) references forma_pago(forma_pago)
);

create table tipo(
    tipo int, 
    nombre_tipo varchar(10),
    constraint tipoPK PRIMARY KEY(tipo)
);

create table proveedor(
    codigo int,
    nombre varchar(10),
    tipo int,
    limite_credito int,
    total_comprado int,
    constraint proveedorPK PRIMARY KEY (codigo),
    constraint proveedor_TFK FOREIGN KEY (tipo) references tipo(tipo)
);
