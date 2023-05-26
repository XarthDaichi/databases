CREATE DATABASE DIRTI;

USE DIRTI;

create table Dp (
    cedula integer,
    nombre varchar(30),
    salario float,
    constraint PKDp Primary Key (cedula)
);

create table Pr (
    cedula integer,
    nombre varchar(30),
    salario float,
    constraint PKPr Primary Key (cedula)
);

create table Area (
    idArea integer,
    nombreArea varchar(15),
    constraint PKArea Primary Key (idArea)
);

create table Proyecto (
    idProyecto integer,
    nombreProyecto varchar(30),
    costo float, 
    constraint PKProyecto Primary Key (idProyecto)
);

create table Programa (
    idPrograma integer,
    nombrePrograma varchar(30),
    costo float,
    lenguaje varchar(15),
    cantidadLineas integer,
    idProyecto integer,
    constraint PKPrograma Primary Key (idPrograma),
    constraint foreign key (idProyecto) references Proyecto (idProyecto)
);


create table Tarea (
    idTarea integer,
    cedulaDp integer,
    cedulaPr integer,
    idPrograma integer,
    fechaInicio date,
    fechaFinDeseada date,
    fechaFin date,
    constraint PKTarea Primary Key (idTarea, fechaInicio, fechaFinDeseada),
    constraint foreign key (cedulaDp) references Dp(cedulaDp),
    constraint foreign key (cedulaPr) references Pr(cedulaPr),
    constraint foreign key (idPrograma) references Programa(idPrograma)
);

create table participa (
    idProyecto integer,
    cedulaDp integer,
    fechaInicio date,
    fechaFinDeseada date,
    fechaFin date,
    constraint PKRParticia Primary Key (idProyecto, cedulaDp, fechaInicio, fechaFinDeseada),
    constraint foreign key (idProyecto) references Proyecto(idProyecto),
    constraint foreign key (cedulaDp) references Dp(cedulaDp)
);

create table pertenece (
    idProyecto integer, 
    idArea integer,
    constraint PKRPertenece Primary Key (idProyecto, idArea)
);


insert into 