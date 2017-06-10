-- Tables: cuentas, cat_bancos, tarjetas
-- Functions: randomNumber


CREATE OR REPLACE FUNCTION generateTarjetas() RETURNS VOID AS $$
DECLARE
	num INT;
	id_banco_v INT;
	id_tarjeta_v INT;
BEGIN
	num := COUNT(*)  FROM cat_bancos;
	FOR i IN 1..num LOOP
		id_banco_v := id_banco FROM (SELECT ROW_NUMBER() OVER () indx_b, id_banco FROM cat_bancos) AS indx WHERE indx.indx_b = i;
		id_tarjeta_v := id_tarjeta FROM cat_bancos WHERE id_banco = id_banco_v;

		INSERT INTO tarjetas
			SELECT cn1.num_tarjeta::INT,
				cn1.num_cuenta,
				randomNumber(100,99999)::INT AS saldo,
				( CASE WHEN cn1.tipo_tarjeta = '1' THEN NULL WHEN cn1.tipo_tarjeta = '2' THEN randomNumber(100000,200000) END )::INT AS limite,
				(ENUM_RANGE(NULL::tipo_tarjeta))[cn1.tipo_tarjeta]
			FROM (
				(SELECT ( id_tarjeta_v || LPAD( (ROW_NUMBER() OVER ())::VARCHAR, 6, '0')::VARCHAR)::INT num_tarjeta,
				num_cuenta::INT,
				randomNumber(1,3)::INT AS tipo_tarjeta
				FROM cuentas
				WHERE id_banco = id_banco_v)
			) AS cn1;
	END LOOP;
END;
$$ LANGUAGE plpgsql;



