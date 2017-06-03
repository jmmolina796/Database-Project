/* clientes */


CREATE OR REPLACE FUNCTION randomNumber(number INT) RETURNS VARCHAR AS $$
	BEGIN
		RETURN SUBSTR(CAST((RANDOM()) AS VARCHAR),3,number);
	END;
$$ LANGUAGE plpgsql;
/*
	Generates random numbers.

	Parameters:
		number INT: specify how many random numbers you want to generate.
*/

CREATE OR REPLACE FUNCTION curp(f_last_name VARCHAR, m_last_name VARCHAR, name VARCHAR, birth_date DATE) RETURNS VARCHAR AS $$
	BEGIN
		RETURN LEFT('Perez',2)::VARCHAR
	END;
$$ LANGUAGE plpgsql;





SELECT UPPER(LEFT('Olmedo',1))::VARCHAR;

SELECT REGEXP_MATCHES(LOWER(()), '[aeiou]{1}');




SELECT example('jas','asd','asd','1999-01-08');

SELECT example('Olmedo','asd','asd','1999-01-08');
SELECT example('Olm','asd','asd','1999-01-08');

SELECT example('Ñan','asd','asd','1999-01-08');
SELECT example('Ñn','asd','asd','1999-01-08');

SELECT example('Olmedo','Bautista','asd','1999-01-08');
SELECT example('Olmedo','Ñas','asd','1999-01-08');

SELECT example('Olmedo','Bautista','Maria Luisa','1999-01-08');
SELECT example('Olmedo','Bautista','Maria','1999-01-08');

SELECT example('Olmedo','Bautista','Maria Ñuisa','1999-01-08');




CREATE OR REPLACE FUNCTION example(f_last_name VARCHAR, m_last_name VARCHAR, name VARCHAR, birth_date DATE) RETURNS VARCHAR AS $$
	DECLARE
		f_last_name_first VARCHAR;
		f_last_name_vowel VARCHAR;
		f_last_name_req VARCHAR;
		m_last_name_req VARCHAR;
		birth_date_req VARCHAR;
		name_req VARCHAR;
		space_position INT;
		curp VARCHAR;
	BEGIN


		--Father's last name
		f_last_name_first := UPPER(LEFT(f_last_name,1));

		IF f_last_name_first = 'Ñ' THEN
			f_last_name_first := 'X';
		END IF;

		f_last_name_vowel := SUBSTRING(UPPER(SUBSTR(f_last_name, 2, CHAR_LENGTH(f_last_name))), '[AEIOU]{1}');

		IF f_last_name_vowel IS NULL THEN
			f_last_name_req := f_last_name_first::VARCHAR || 'X'::VARCHAR;
		ELSE
			f_last_name_req := f_last_name_first::VARCHAR || f_last_name_vowel::VARCHAR;
		END IF;

		--Mother's last name
		m_last_name_req := UPPER(LEFT(m_last_name,1));

		IF m_last_name_req = 'Ñ' THEN
			m_last_name_req := 'X';
		END IF;

		--Name
		space_position := POSITION(' ' in name);
		name := UPPER(name);
		IF space_position > 0 AND (name LIKE 'MARIA%' OR name LIKE 'JOSE%') THEN
			name_req := substr(name ,POSITION(' ' in name)+1,1);
		ELSE
			name_req := LEFT(name,1);
		END IF;

		birth_date_req = TO_CHAR(birth_date, 'YYYYMMDD');

		curp := f_last_name_req::VARCHAR || m_last_name_req::VARCHAR || name_req::VARCHAR || birth_date_req::VARCHAR;

		RETURN curp;
	END;
$$ LANGUAGE plpgsql;


myVar VARCHAR(50);

myVar := SUBSTRING(SUBSTR('Ash', 2, CHAR_LENGTH('Ash')), '[aeiou]{1}');

SELECT SUBSTRING(SUBSTR('Ash', 2, CHAR_LENGTH('Ash')), '[aeiou]{1}') IS NULL;


SELECT CHAR_LENGTH('');











CREATE OR REPLACE FUNCTION rfc(f_last_name VARCHAR, m_last_name VARCHAR, name VARCHAR, birth_date DATE) RETURNS VARCHAR AS $$
	BEGIN
		RETURN LEFT('Perez',2)::VARCHAR
	END;
$$ LANGUAGE plpgsql;








pg_typeof
