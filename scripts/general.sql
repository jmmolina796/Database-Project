CREATE OR REPLACE FUNCTION randomNumber(start_num INT, end_num INT) RETURNS VARCHAR AS $$
	BEGIN
		RETURN TRUNC(RANDOM() * (end_num-start_num) + start_num);
	END;
$$ LANGUAGE plpgsql;
/*
	Generates random numbers.

	Parameters:
		start_num INT: specifies the first number of the range.
		end_num INT: specifies the last number of the range.
*/