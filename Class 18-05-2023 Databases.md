
```css
.mermaid svg rect.note {
	fill: #b3aef2 !imporant;
	stroke: magenta !important;
}
```

```mermaid
graph LR
	f-->z;
	subgraph haha
		z-->y
	end
```


>[! Hay que implementarlo en app]
>![[app-bases/app.sql]]

```css
.label > g > foreingObject {
	color: red;
	background-color: blue;
}

.node > g > g > foreignObject > div {
	color: green;
	stroke: blue;
}

.mermaid svg .cluster rect {
	fill: pink !important;
	stroke: yellow !important;
}

.mermaid svg .node rect {
	fill: magenta !important
	stroke: green !important;
}
```
```mermaid
erDiagram
	Producto ||--|{ Familia : contiene
	Producto {
		int codigo PK
		varchar nombre
		float precio
		float costo
		float utilidad
		int familia FK
	}
	Familia {
		int id PK
		varchar nombre
		int total_productos
	}
	Componente ||--|{ Producto : hecho
	Componente {
		int codigo PK
		int producto FK
	}
	Formula ||--|{ Componente : utilizando
	Formula {
		int materia FK
		int componente FK
		int cantidad
	}
	Formula ||--|{ Materia_Prima : utilizando
	Materia_Prima {
		int codigo PK
		float precio
		int cantidad
		int cantidad_minima
		int proveedor FK
		int reorder
	}
	Materia_Prima ||--|{ Proveedor : provee
	Proveedor {
		int codigo PK
		varchar nombre
	}
```



```mermaid
	graph RL
		A:::someclass --> B
		classDef someclass fill:#f96;
		linkStyle default fill:none, stroke-width:3px,stroke:red

		C --> D

```




# Requerimientos
## Departamento de Ventas:
1. Lista de precios con el siguiente formato. (Familia, Producto, nombre, precio_venta, porcentaje, precio_nuevo), ordenado por familia, producto, precio. **SOLUCIÓN:** Procedimiento almacenado p048(porcentaje_aumento float)