CREATE TABLE cat_apellidos(
	id_apellido INT NOT NULL,
	apellido VARCHAR(100),
	PRIMARY KEY(id_apellido)
);

CREATE TABLE cat_nombres(
	id_nombre INT NOT NULL,
	nombre VARCHAR(100),
	sexo sexo_cliente,
	PRIMARY KEY(id_nombre)
);
