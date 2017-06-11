/* These scripts must execute in this order */

SELECT generateClientes();
-- Generates: 99,999 clients * banks (20) = 1,999,980 rows

SELECT generateCuentas();
-- Generates: 3 accounts * client (99,999) * bank (20) = 5,999,940 rows

SELECT generateTarjetas();
-- Generates: 1 card * account (5,999,940) = 5,999,940 rows 

SELECT generateMovimientos();
-- Generates: 18 transactions * card (5,999,940) = 107,998,920 rows


/*
	
	Total of rows = 121,998,780

*/