![[app.sql]]

```mermaid
erDiagram
	Inventario ||--|{ Bodega : contenido
	Inventario {
		int cantidad_minima
		int cantidad
		int reorder
		int B FK
		int P FK
		int Q
	}
	Inventario ||--|{ Producto : contiene
```

```mermaid
---
title: P037 (F1 Date, F2 Date)
---
stateDiagram-v2
	s2 : Cargar Movimiento
	s3 : TM <- count(monto)
	s4 : Lee Monto
	s5 : Actualizar Bodega
	s6 : TM <- Monto actualizado
	s7 : Cerrar Monitor
	[*] --> Inicia
	Inicia --> s2
	s2 --> s3
	s3 --> s4
	s4 --> s5
	s5 --> s6
	s6 --> s5
	s6 --> s7
	s7 --> if_state : TM = TMA
	if_state --> Commit : if TM = TMA
	if_state --> Rollback : if TM != TMA
	Commit --> Fin
	Rollback --> Fin
	Fin --> [*]
```
```mermaid
---
title : F0038 (B, P, C, t)
---
stateDiagram-v2
	s1 : OK = 0
	s2 : Return Ok
	s3 : OK = 1
	[*] --> Actualiza
	Actualiza --> s1
	s1 --> Actualizarlo?
	Actualizarlo? --> s3 : Si
	Actualizarlo? --> s2 : No
	s3 --> [*]
	s2 --> [*]
```
```sql
create table Bodega (
	int codigo,
	constraint PKB PRIMARY KEY (codigo)
);

create table Producto (
	int codigo,
	constraint PKP PRIMARY KEY (codigo)
);


create table Inventario (
	int Q,
	int B,
	int P,
	int cant,
	int minim,
	int reorder,
	constraint PKI PRIMARY KEY (Q),
	constraint FK1 references Producto(P),
	constraint FK2 references Bodega(B)
);



create trigger tr027
after update on Inventario
for each row
BEGIN
	IF new.cantidad<=old.minimo
		P0075(P, reorder),
	END IF;
END;
```

