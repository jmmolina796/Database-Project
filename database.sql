CREATE DATABASE project;


/* cat_bancos */

CREATE TABLE cat_bancos(
	id_banco INT NOT NULL,
	nombre VARCHAR(10) NOT NULL,
	id_tarjeta INT NOT NULL,
	PRIMARY KEY(id_banco),
	UNIQUE(id_tarjeta)
	CHECK(id_banco > 0),
	CHECK(id_tarjeta > 0)
);

--INSERT INTO cat_bancos(id_banco, nombre, id_tarjeta) VALUES(0, 'as', 4);

/* cat_bancos */



/* clientes */

CREATE TYPE sexo_cliente AS ENUM('M', 'H');

CREATE TABLE clientes(
	num_cliente INT NOT NULL,
	nombre VARCHAR(10) NOT NULL,
	ap_pat VARCHAR(15) NOT NULL,
	ap_mat VARCHAR(15) NOT NULL,
	rfc VARCHAR(13) NOT NULL,
	curp VARCHAR(18) NOT NULL,
	fecha_nac DATE NOT NULL,
	sexo sexo_cliente,
	PRIMARY KEY(num_cliente),
	UNIQUE(rfc),
	UNIQUE(curp),
	CHECK(num_cliente > 0)
);

--INSERT INTO clientes(num_cliente, nombre, ap_pat, ap_mat, rfc, curp, fecha_nac, sexo) VALUES(10, 'Peter', 'Slim', 'Mendez', 'ewefew', 'dwqd23e', '2001-12-21', 'M');
--INSERT INTO clientes(num_cliente, nombre, ap_pat, ap_mat, rfc, curp, fecha_nac, sexo) VALUES(10, 'Peter', 'Slim', 'Mendez', 'ewefew', 'dwqd23e', '2001-12-21', 'I');

/* clientes */



/* cuentas */

CREATE TABLE cuentas(
	num_cuenta INT NOT NULL,
	id_banco INT NOT NULL,
	num_cliente INT NOT NULL,
	PRIMARY KEY(num_cuenta),
	UNIQUE(id_banco),
	UNIQUE(num_cliente),
	FOREIGN KEY(id_banco) REFERENCES cat_bancos(id_banco),
	FOREIGN KEY(num_cliente) REFERENCES clientes(num_cliente)
);

/* cuentas */



/* tarjeta */

--Saldo

CREATE TYPE tipo_tarjeta AS ENUM(1, 2);

CREATE TABLE tarjetas(
	num_tarjeta int NOT NULL,
	num_cuenta INT NOT NULL,
	saldo INT NOT NULL,
	limite INT NOT NULL,
	tipo tipo_tarjeta NOT NULL,
	PRIMARY KEY(num_tarjeta),
	UNIQUE(num_cuenta),
	CHECK(num_tarjeta > 0),
	CHECK(saldo > 0),
	CHECK(limite >= 0),
	FOREIGN KEY(num_cuenta) REFERENCES cuentas(num_cuenta)
);

/* tarjeta */



/* movimientos */

--importe

CREATE TYPE tipo_movimiento AS ENUM(1, 2);

CREATE TABLE movimientos(
	num_tarjeta INT NOT NULL,
	fecha DATETIME NOT NULL,
	tipo tipo_movimiento NOT NULL,
	importe REAL NOT NULL,
	PRIMARY KEY(num_tarjeta, fecha),
	CHECK(num_tarjeta > 0 ),
	CHECK(importe > 0 ),
	FOREIGN KEY(num_tarjeta) REFERENCES tarjetas(num_tarjeta)
);

/* movimientos */