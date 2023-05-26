CREATE DATABASE practica;

CREATE TABLE Autor(
	codigo varchar(30),
	nombre varchar(30),
	PRIMARY KEY (codigo)
);

CREATE TABLE Libro (
	codigo varchar(30),
	nombre varchar(30),
	asignatura varchar(30),
	preiodo_prestamo varchar(30)
	estudiante varchar(30),
	estudiante varchar(30),
	PRIMARY KEY (codigo),
	FOREIGN KEY (estante) REFERENCES Estante(codigo),
	FOREIGN KEY (estudiante) REFERENCES Estudiante(id)
);

CREATE TABLE Estante (
	piso int,
	codigo varchar(30),
	PRIMARY KEY (codigo)
);

CREATE TABLE Estudiante (
	nombre varchar(30),
	id varchar(30),
	PRIMARY KEY (id)
);
