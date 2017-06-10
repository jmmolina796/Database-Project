-- Type: sexo_cliente
-- Tables: aux_apellidos, aux_nombres, aux_entidades, cat_bancos, clientes
-- Functions: randomNumber


CREATE OR REPLACE FUNCTION curp(f_last_name VARCHAR, m_last_name VARCHAR, name VARCHAR, birth_date DATE, state_letter VARCHAR, sexo VARCHAR) RETURNS VARCHAR AS $$
	DECLARE
		f_last_name_first VARCHAR;
		f_last_name_vowel VARCHAR;
		space_position INT;
		
		f_last_name_req VARCHAR;
		m_last_name_req VARCHAR;
		name_req VARCHAR;
		birth_date_req VARCHAR;
		f_last_name_req2 VARCHAR;
		m_last_name_req2 VARCHAR;
		name_req2 VARCHAR;
		number_dup_req VARCHAR;
		random_number_req VARCHAR;

		curp_generated VARCHAR;
	BEGIN

		--Father's last name: first letter and first vowel
		f_last_name_first := UPPER(LEFT(f_last_name,1));

		f_last_name_vowel := SUBSTRING(UPPER(SUBSTR(f_last_name, 2, CHAR_LENGTH(f_last_name))), '[AEIOU]{1}');

		IF f_last_name_vowel IS NULL THEN
			f_last_name_req := f_last_name_first::VARCHAR || 'X'::VARCHAR;
		ELSE
			f_last_name_req := f_last_name_first::VARCHAR || f_last_name_vowel::VARCHAR;
		END IF;

		--Mother's last name: first letter
		m_last_name_req := UPPER(LEFT(m_last_name,1));

		--Name: first letter
		space_position := POSITION(' ' in name);
		name := UPPER(name);
		IF space_position > 0 AND (name LIKE 'MARIA%' OR name LIKE 'JOSE%') THEN
			name_req := substr(name ,POSITION(' ' in name)+1,1);
		ELSE
			name_req := LEFT(name,1);
		END IF;

		--Birth Date: format YYYYMMDD
		birth_date_req = TO_CHAR(birth_date, 'YYMMDD');

		--Father's last name: first internal consonant
		f_last_name_req2 := SUBSTRING(UPPER(SUBSTR(f_last_name, 2, CHAR_LENGTH(f_last_name))), '[QWRTYPSDFGHJKLMNBVCXZ]{1}');

		IF f_last_name_req2 IS NULL THEN
			f_last_name_req2 := 'X';
		END IF;

		--Mother's last name: first internal consonant
		m_last_name_req2 := SUBSTRING(UPPER(SUBSTR(m_last_name, 2, CHAR_LENGTH(m_last_name))), '[QWRTYPSDFGHJKLMNBVCXZ]{1}');

		IF m_last_name_req2 IS NULL THEN
			m_last_name_req2 := 'X';
		END IF;

		--Name: first internal consonant
		space_position := POSITION(' ' in name);
		name_req2 := UPPER(name);
		IF space_position > 0 AND (name LIKE 'MARIA%' OR name LIKE 'JOSE%') THEN
			name_req2 := SUBSTRING(UPPER(SUBSTR(name, POSITION(' ' in name)+2, CHAR_LENGTH(name))), '[QWRTYPSDFGHJKLMNBVCXZ]{1}');
		ELSE
			name_req2 := SUBSTRING(UPPER(SUBSTR(m_last_name, 2, CHAR_LENGTH(m_last_name))), '[QWRTYPSDFGHJKLMNBVCXZ]{1}');
		END IF;

		IF name_req2 IS NULL THEN
			name_req2 := 'X';
		END IF;

		curp_generated := f_last_name_req::VARCHAR || m_last_name_req::VARCHAR || name_req::VARCHAR || birth_date_req::VARCHAR || sexo::VARCHAR || state_letter::VARCHAR || f_last_name_req2::VARCHAR || m_last_name_req2::VARCHAR || name_req2::VARCHAR;
		
		--Change all Ñ to X
		IF POSITION('Ñ' in curp_generated) > 0 THEN
			curp_generated := REPLACE(curp_generated, 'Ñ', 'X');
		END IF;

		--Avoid duplication
		number_dup_req := LPAD( (COUNT(*) + 1)::VARCHAR, 2, '0') FROM clientes WHERE LEFT(curp, 16) = curp_generated;

		--Avoid duplication
		--number_dup_req := randomNumber(0,9);

		--Random number
		--random_number_req := randomNumber(0,9);

		curp_generated := curp_generated || number_dup_req::VARCHAR;

		RETURN curp_generated;
	END;
$$ LANGUAGE plpgsql;
/*
	Generates a curp.

	Parameters:
		f_last_name VARCHAR 
		m_last_name VARCHAR
		name VARCHAR
		birth_date DATE
		state_letter VARCHAR
		sexo VARCHAR
*/


CREATE OR REPLACE FUNCTION rfc(curp VARCHAR) RETURNS VARCHAR AS $$
	BEGIN
		RETURN LEFT(curp,13)::VARCHAR || RIGHT(curp,2)::VARCHAR;
	END;
$$ LANGUAGE plpgsql;
/*
	Generates a rfc from a curp, it takes its first ten characters.

	Parameters:
		curp VARCHAR
*/


CREATE OR REPLACE FUNCTION generateClientes() RETURNS VOID AS $$
DECLARE
	num INT;
BEGIN
	num := COUNT(*)  FROM cat_bancos;
	FOR i IN 1..num LOOP
		INSERT INTO clientes
			SELECT final_1.num_cliente, 
				final_1.nombre,
				final_1.ap_pat,
				final_1.ap_mat,
				rfc(final_1.curp),
				final_1.curp,
				final_1.fecha_nac,
				final_1.sexo
			FROM (
				SELECT fin_2.num_cliente, 
					fin_2.nombre,
					fin_2.ap_pat,
					fin_2.ap_mat,
					curp(fin_2.ap_mat, fin_2.ap_pat, fin_2.nombre::VARCHAR, fin_2.fecha_nac, fin_2.entidad, fin_2.sexo::VARCHAR) AS curp,
					fin_2.fecha_nac,
					fin_2.sexo
				FROM (
					SELECT (LEFT((SELECT id_banco FROM (SELECT ROW_NUMBER() OVER () indx_b, id_banco FROM cat_bancos) AS inx WHERE indx_b = i)::VARCHAR, 3) || LPAD( (ROW_NUMBER() OVER ())::VARCHAR, 5, '0' ) )::INT num_cliente,
						fin_ap_nom.nombre, 
						fin_ap_nom.ap_pat,
						fin_ap_nom.ap_mat,
						(SELECT clave FROM aux_entidades WHERE id_entidad = fin_ap_nom.id_entidad::INT) AS entidad,
						CAST('1960-01-01 15:16'::DATE + '35 year'::INTERVAL * RANDOM()  AS DATE) AS fecha_nac,
						fin_ap_nom.sexo
					FROM (
						SELECT ROW_NUMBER() OVER () AS idnom, fin_an.nombre, fin_ap.ap_pat, fin_ap.ap_mat, randomNumber(1,32) AS id_entidad, fin_an.sexo
						FROM (
							SELECT an1.nombre || ' ' || an2.nombre AS nombre, an1.sexo
							FROM ( SELECT nombre, sexo
								FROM aux_nombres
								ORDER BY RANDOM()
								LIMIT 25) AS an1
							INNER JOIN (SELECT nombre, sexo
								FROM aux_nombres
								ORDER BY RANDOM()
								LIMIT 25) AS an2
							ON an1.sexo = an2.sexo
							LIMIT 210
						) AS fin_an
						CROSS JOIN (
							SELECT ap1.apellido AS ap_pat, ap2.apellido AS ap_mat
							FROM ( SELECT apellido
								FROM aux_apellidos
								ORDER BY RANDOM()
								LIMIT 20
							) AS ap1
							CROSS JOIN (
								SELECT apellido
								FROM aux_apellidos
								ORDER BY RANDOM()
								LIMIT 25
							) AS ap2
						) AS fin_ap
						LIMIT 99999
					) AS fin_ap_nom
				) AS fin_2
			) AS final_1;
	END LOOP;
END;
$$ LANGUAGE plpgsql;


/*14 * 15 = 210
20 * 25 = 500

210*500 = 105,000*/
