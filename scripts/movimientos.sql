-- Tables: tarjetas


CREATE OR REPLACE FUNCTION generateMovimientos() RETURNS VOID AS $$
DECLARE
	num INT;
	num_tarjeta_n int;
BEGIN
	num := COUNT(*)  FROM tarjetas;
	FOR i IN 1..num LOOP
		num_tarjeta_n := num_tarjeta FROM tarjetas LIMIT 1 OFFSET (i-1);
		FOR v IN 1..18 LOOP
			INSERT INTO movimientos
				SELECT num_tarjeta,
					CAST('1965-01-01 15:16'::TIMESTAMP + '51 YEAR'::INTERVAL * RANDOM()  AS TIMESTAMP) AS fecha,
					(ENUM_RANGE(NULL::tipo_movimiento))[tipo_importe::INT] AS tipo,
					(CASE WHEN (tipo_tarjeta = (ENUM_RANGE(NULL::tipo_tarjeta))[1]) AND (tipo_importe = '2') THEN 
						randomNumber(0,99999)
					WHEN (tipo_tarjeta = (ENUM_RANGE(NULL::tipo_tarjeta))[1] ) AND (tipo_importe = '1') THEN
						randomNumber(0,saldo)
					WHEN (tipo_tarjeta = (ENUM_RANGE(NULL::tipo_tarjeta))[2] ) AND (tipo_importe = '2') THEN
						randomNumber(0,saldo)
					WHEN (tipo_tarjeta = (ENUM_RANGE(NULL::tipo_tarjeta))[2] ) AND (tipo_importe = '1') THEN 
						randomNumber(0, (limite-saldo) )
					END )::REAL AS importe
				FROM (
					SELECT num_tarjeta,
						tipo AS tipo_tarjeta,
						saldo,
						limite,
						randomNumber(1,3) AS tipo_importe
					FROM tarjetas
					WHERE num_tarjeta = num_tarjeta_n
				) AS mov_1;
		END LOOP;
	END LOOP;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER update_saldo AFTER INSERT ON movimientos FOR EACH ROW EXECUTE PROCEDURE update_saldo_func();

CREATE OR REPLACE FUNCTION update_saldo_func() RETURNS TRIGGER AS $$
	DECLARE
		num_tarjeta_n INT;
		tipo_importe_n INT;
		importe_n REAL;
		tipo_tarjeta_n INT;
		saldo_n REAL;
	BEGIN

		num_tarjeta_n := new.num_tarjeta;
		tipo_importe_n := new.tipo;
		importe_n := new.importe;
		tipo_tarjeta_n := tipo FROM tarjetas WHERE num_tarjeta = num_tarjeta_n;
		saldo_n := saldo FROM tarjetas WHERE num_tarjeta = num_tarjeta_n;

   		UPDATE tarjetas 
   		SET saldo = 
	    	(CASE WHEN (tipo_tarjeta_n = 1) AND (tipo_importe_n = 2) THEN 
				saldo_n + importe_n
			WHEN (tipo_tarjeta_n = 1 ) AND (tipo_importe_n = 1) THEN
				saldo_n - importe_n 
			WHEN (tipo_tarjeta_n = 2 ) AND (tipo_importe_n = 2) THEN
				saldo_n - importe_n
			WHEN (tipo_tarjeta_n = 2 ) AND (tipo_importe_n = 1) THEN 
				saldo_n + importe_n
			END )
		WHERE num_tarjeta = num_tarjeta_n;

      RETURN NEW;
	END;
$$ LANGUAGE plpgsql;