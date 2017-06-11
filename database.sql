CREATE DATABASE project;

/* Types */

CREATE TYPE sexo_cliente AS ENUM('M', 'H');
CREATE TYPE tipo_tarjeta AS ENUM('1', '2');
CREATE TYPE tipo_movimiento AS ENUM('1', '2');

/* Types */




/* Auxiliar Tables */

--aux_entidades
CREATE TABLE aux_entidades(
	id_entidad SERIAL NOT NULL,
	clave VARCHAR(2) NOT NULL,
	entidad VARCHAR(20) NOT NULL,
	PRIMARY KEY(id_entidad),
	UNIQUE (id_entidad)
);

--aux_apellidos
CREATE TABLE aux_apellidos(
	id_apellido INT NOT NULL,
	apellido VARCHAR(100),
	PRIMARY KEY(id_apellido)
);

--aux_nombres
CREATE TABLE aux_nombres(
	id_nombre INT NOT NULL,
	nombre VARCHAR(100) NOT NULL,
	sexo sexo_cliente NOT NULL,
	PRIMARY KEY(id_nombre)
);

/* Auxiliar Tables */




/* Project Tables */

--cat_bancos
CREATE TABLE cat_bancos(
	id_banco INT NOT NULL,
	nombre VARCHAR(20) NOT NULL,
	id_tarjeta INT NOT NULL,
	PRIMARY KEY(id_banco),
	UNIQUE(id_tarjeta),
	CHECK(id_banco > 0),
	CHECK(id_tarjeta > 0)
);

--clientes
CREATE TABLE clientes(
	num_cliente INT NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	ap_pat VARCHAR(30) NOT NULL,
	ap_mat VARCHAR(30) NOT NULL,
	rfc VARCHAR(15) NOT NULL,
	curp VARCHAR(18) NOT NULL,
	fecha_nac DATE NOT NULL,
	sexo sexo_cliente,
	PRIMARY KEY(num_cliente),
	CHECK(num_cliente > 0)
);

--cuentas
CREATE TABLE cuentas(
	num_cuenta INT NOT NULL,
	id_banco INT NOT NULL,
	num_cliente INT NOT NULL,
	PRIMARY KEY(num_cuenta),
	FOREIGN KEY(id_banco) REFERENCES cat_bancos(id_banco),
	FOREIGN KEY(num_cliente) REFERENCES clientes(num_cliente)
);


--tarjeta
CREATE TABLE tarjetas(
	num_tarjeta INT NOT NULL,
	num_cuenta INT NOT NULL,
	saldo REAL NOT NULL,
	limite INT,
	tipo tipo_tarjeta NOT NULL,
	PRIMARY KEY(num_tarjeta),
	UNIQUE(num_cuenta),
	CHECK(num_tarjeta > 0),
	CHECK(saldo > 0),
	CHECK(limite >= 0),
	FOREIGN KEY(num_cuenta) REFERENCES cuentas(num_cuenta)
);--Saldo

--movimientos
CREATE TABLE movimientos(
	num_tarjeta INT NOT NULL,
	fecha TIMESTAMP NOT NULL,
	tipo tipo_movimiento NOT NULL,
	importe REAL NOT NULL,
	PRIMARY KEY(num_tarjeta, fecha),
	CHECK(num_tarjeta > 0 ),
	CHECK(importe >= 0 ),
	FOREIGN KEY(num_tarjeta) REFERENCES tarjetas(num_tarjeta)
);--importe

/* Project Tables */

