

CREATE OR REPLACE FUNCTION generateCuentas() RETURNS VOID AS $$
DECLARE
	num INT;
	id_banco_c int;
	id_banco_l int;
	contador int;
BEGIN
	num := COUNT(*)  FROM cat_bancos;
	FOR i IN 1..num LOOP
		id_banco_c := my.id_banco FROM ( 
		 									SELECT row_number() over() AS numb, cb.id_banco 
		 									FROM cat_bancos cb 
		 								) AS my WHERE numb = i;


		id_banco_l := left(my.id_banco::VARCHAR,3) FROM ( 
															SELECT row_number() over() AS numb, cb.id_banco 
															FROM cat_bancos cb 
														) AS my WHERE numb = i;
		FOR v IN 1..3 LOOP
			contador := COUNT(*) FROM cuentas WHERE left(num_cuenta::VARCHAR,3) = id_banco_l::VARCHAR;

			INSERT INTO cuentas
				SELECT  ( id_banco_l::VARCHAR || LPAD( ( (ROW_NUMBER() OVER () )::int + contador ) ::VARCHAR, 6, '0' )::VARCHAR )::INT AS num_cuenta, id_banco_c AS id_banco, cli.num_cliente
								FROM clientes cli
								WHERE left(cli.num_cliente::VARCHAR,3)  = id_banco_l::VARCHAR;
		END LOOP;
	END LOOP;
END;
$$ LANGUAGE plpgsql;