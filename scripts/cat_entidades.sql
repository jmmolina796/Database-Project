CREATE TABLE cat_entidades(
	id_entidad INT NOT NULL,
	clave VARCHAR(2) NOT NULL,
	entidad VARCHAR(20) NOT NULL,
	PRIMARY KEY(id_entidad),
	UNIQUE (id_entidad),
	SERIAL (id_entidad)
);

INSERT INTO cat_entidades (clave,entidad) 
VALUES  ('AS','AGUASCALIENTES'),
		('BC','BAJA CALIFORNIA'),
		('BS','BAJA CALIFORNIA SUR'),
		('CC','CAMPECHE'),
		('CL','COAHUILA'),
		('CM','COLIMA'),
		('CS','CHIAPAS'),
		('CH','CHIHUAHUA'),
		('CD','CIUDAD DE MEXICO'),
		('DG','DURANGO'),
		('GT','GUANAJUATO'),
		('GR','GUERRERO'),
		('HG','HIDALGO'),
		('JC','JALISCO'),
		('MC','MEXICO'),
		('MN','MICHOACAN'),
		('MS','MORELOS'),
		('NT','NAYARIT'),
		('NL','NUEVO LEON'),
		('OC','OAXACA'),
		('PL','PUEBLA'),
		('QT','QUERETARO'),
		('QR','QUINTANA ROO'),
		('SP','SAN LUIS POTOSI'),
		('SL','SINALOA'),
		('SR','SONORA'),
		('TC','TABASCO'),
		('TS','TAMAULIPAS'),
		('TL','TLAXCALA'),
		('VZ','VERACRUZ'),
		('YN','YUCATAN'),
		('ZS','ZACATECAS');


