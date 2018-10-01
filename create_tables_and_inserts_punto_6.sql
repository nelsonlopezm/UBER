CREATE TABLE countries
( id INT NOT NULL,   
  code VARCHAR2(10 CHAR) NOT NULL,
  name VARCHAR2(255 CHAR) NOT NULL,  
  national_currency VARCHAR2(20 CHAR) DEFAULT 'USD' NOT NULL,
  CONSTRAINT countries_pk PRIMARY KEY (id)  
);

CREATE SEQUENCE countries_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE TABLE states
( id INT NOT NULL,   
  country_id INT NOT NULL,
  code VARCHAR2(10 CHAR) NOT NULL,
  name VARCHAR2(255 CHAR) NOT NULL,    
  CONSTRAINT states_pk PRIMARY KEY (id),
  CONSTRAINT fk_country_id FOREIGN KEY (country_id) REFERENCES countries(id)
);

CREATE SEQUENCE states_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE TABLE cities
( id INT NOT NULL,   
  state_id INT NOT NULL,
  code VARCHAR2(10 CHAR) NOT NULL,
  name VARCHAR2(255 CHAR) NOT NULL,    
  CONSTRAINT cities_pk PRIMARY KEY (id),
  CONSTRAINT fk_state_id FOREIGN KEY (state_id) REFERENCES states(id)
);

CREATE SEQUENCE cities_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE TABLE users
( id INT NOT NULL, 
  user_type VARCHAR2(50 CHAR) NOT NULL,  
  tributary_id_type VARCHAR2(10 CHAR) NOT NULL,
  tributary_id VARCHAR2(30 CHAR) NOT NULL,  
  name VARCHAR2(255 CHAR) NOT NULL,  
  last_name VARCHAR2(255 CHAR) NOT NULL,  
  phone_number VARCHAR2(30 CHAR) NOT NULL, 
  profile_photho VARCHAR2(255 CHAR),  
  location INT NOT NULL,
  language VARCHAR2(50 CHAR) NOT NULL,    
  CONSTRAINT users_pk PRIMARY KEY (id),
  CONSTRAINT fk_location FOREIGN KEY (location) REFERENCES cities(id)
);

CREATE UNIQUE INDEX users_idx
  ON users (tributary_id);

CREATE SEQUENCE users_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE TABLE user_credit_cards
( id INT NOT NULL,   
  user_id INT NOT NULL,
  card_number VARCHAR2(50 CHAR) NOT NULL,  
  security_code VARCHAR2(10 CHAR) NOT NULL,  
  expiration_month VARCHAR2(10 CHAR) NOT NULL,  
  expiration_year VARCHAR2(10 CHAR) NOT NULL,  
  name VARCHAR2(255 CHAR) NOT NULL,    
  CONSTRAINT user_credit_cards_pk PRIMARY KEY (id),
  CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE SEQUENCE user_credit_cards_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;


CREATE TABLE user_emails
( id INT NOT NULL,   
  user_id INT NOT NULL,    
  email VARCHAR2(255 CHAR) NOT NULL,   
  payment_option VARCHAR2(50 CHAR) NOT NULL,
  user_credit_card_id INT,  
  CONSTRAINT user_emails_pk PRIMARY KEY (id),
  CONSTRAINT fk_ue_user_id FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_ue_user_credit_card_id FOREIGN KEY (user_credit_card_id) REFERENCES user_credit_cards(id)
);

CREATE SEQUENCE user_emails_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

-- INCEMENTO, DECREMENTO   
-- PORCENTAJE, VALOR  
CREATE TABLE concepts
( id INT NOT NULL,
  concept_code VARCHAR2(20 CHAR) NOT NULL,
  concept_name VARCHAR2(255 CHAR) NOT NULL,
  type_concept_use VARCHAR2(255 CHAR) NOT NULL,
  type_concept_value VARCHAR2(255 CHAR) NOT NULL,
  concept_value NUMBER(12,2),
  concept_description VARCHAR2(255 CHAR),
  CONSTRAINT concepts_pk PRIMARY KEY (id)  
);

CREATE UNIQUE INDEX concepts_idx
  ON concepts (concept_code);

CREATE SEQUENCE concepts_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;


CREATE TABLE user_invite_codes
( id INT NOT NULL,   
  user_id INT NOT NULL,    
  invite_code VARCHAR2(20 CHAR) NOT NULL,    
  concept_id INT NOT NULL,    
  CONSTRAINT user_invite_codes_pk PRIMARY KEY (id),
  CONSTRAINT fk_uic_user_id FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_uic_concept_id FOREIGN KEY (concept_id) REFERENCES concepts(id)
);

CREATE UNIQUE INDEX user_invite_codes_idx
  ON user_invite_codes (invite_code);

CREATE SEQUENCE user_invite_codes_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE TABLE promotions
( id INT NOT NULL,   
  code VARCHAR2(20 CHAR) NOT NULL,    
  name VARCHAR2(255 CHAR) NOT NULL,    
  start_promotion DATE NOT NULL,
  end_promotion DATE,
  STATUS VARCHAR2(20 CHAR) DEFAULT 'ACTVE' NOT NULL, -- 'ACTIVE, INACTIVE'    
  description VARCHAR2(255 CHAR),
  concept_id INT NOT NULL,      
  CONSTRAINT promotions_pk PRIMARY KEY (id),
  CONSTRAINT fk_promo_concept_id FOREIGN KEY (concept_id) REFERENCES concepts(id)
);

CREATE UNIQUE INDEX promotions_idx
  ON promotions (code);

CREATE SEQUENCE promotions_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE TABLE vehichles
( id INT NOT NULL,     
  vehichle_plate VARCHAR2(20 CHAR) NOT NULL,  
  brand VARCHAR2(255 CHAR) NOT NULL,  
  model VARCHAR2(255 CHAR) NOT NULL,  
  year INT NOT NULL,  
  service VARCHAR2(255 CHAR) NOT NULL,  
  CONSTRAINT vehichles_pk PRIMARY KEY (id)  
);

CREATE UNIQUE INDEX vehichles_idx
  ON vehichles (vehichle_plate);

CREATE SEQUENCE vehichles_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;


CREATE TABLE driver_vehiches
( id INT NOT NULL,   
  user_id INT NOT NULL,    
  vehichle_id INT NOT NULL,  
  CONSTRAINT driver_vehiches_pk PRIMARY KEY (id),
  CONSTRAINT fk_dv_user_id FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_dv_vehichle_id FOREIGN KEY (vehichle_id) REFERENCES vehichles(id)
);

CREATE SEQUENCE driver_vehiches_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;


CREATE TABLE trips
( id INT NOT NULL,  
  pickup DATE NOT NULL, 
  user_id INT NOT NULL,
  driver_id INT NOT NULL,
  origin_address VARCHAR2(255 CHAR) NOT NULL,
  destination_address VARCHAR2(255 CHAR) NOT NULL,
  payment_option VARCHAR2(50 CHAR) NOT NULL,
  credit_card_id INT,
  promotional_code_id INT NOT NULL,  
  fare NUMBER(12,2) DEFAULT 0, 
  status VARCHAR2(20 CHAR) DEFAULT 'ACTVE' NOT NULL, -- ACTIVE, FINISHED, CANCELED  
  CONSTRAINT trips_pk PRIMARY KEY (id),
  CONSTRAINT fk_tr_user_id FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_tr_driver_id FOREIGN KEY (driver_id) REFERENCES driver_vehiches(id),
  CONSTRAINT fk_tr_credit_card_id FOREIGN KEY (credit_card_id) REFERENCES user_credit_cards(id)
);

CREATE SEQUENCE trips_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE TABLE trip_concepts
( id INT NOT NULL,   
  trip_id INT NOT NULL,    
  concept_id INT NOT NULL,  
  CONSTRAINT trip_concepts_pk PRIMARY KEY (id),
  CONSTRAINT fk_tc_trip_id FOREIGN KEY (trip_id) REFERENCES trips(id),
  CONSTRAINT fk_tc_concept_id FOREIGN KEY (concept_id) REFERENCES concepts(id)
);

CREATE SEQUENCE trip_concepts_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE TABLE trip_coordinates
( id INT NOT NULL,   
  trip_id INT NOT NULL,
  date_time TIMESTAMP NOT NULL,
  latitude VARCHAR2(50) NOT NULL,
  longitude VARCHAR2(50) NOT NULL,
  elevation VARCHAR2(50) NOT NULL,
  CONSTRAINT trip_coordinates_pk PRIMARY KEY (id),
  CONSTRAINT fk_tripc_trip_id FOREIGN KEY (trip_id) REFERENCES trips(id)  
);

CREATE SEQUENCE trip_coordinates_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;



-- INSERTS 

-- COUNTRIES
INSERT INTO countries (ID,CODE,NAME,NATIONAL_CURRENCY)
VALUES (countries_seq.NEXTVAL,'169','COLOMBIA','COP');

-- STATES
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '05' , 'ANTIOQUIA');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '08' , 'ATLANTICO');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '11' , 'BOGOTA');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '13' , 'BOLIVAR');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '15' , 'BOYACA');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '17' , 'CALDAS');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '18' , 'CAQUETA');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '19' , 'CAUCA');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '20' , 'CESAR');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '23' , 'CORDOBA');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '25' , 'CUNDINAMARCA');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '27' , 'CHOCO');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '41' , 'HUILA');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '44' , 'LA GUAJIRA');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '47' , 'MAGDALENA');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '50' , 'META');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '52' , 'NARI�O');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '54' , 'N. DE SANTANDER');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '63' , 'QUINDIO');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '66' , 'RISARALDA');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '68' , 'SANTANDER');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '70' , 'SUCRE');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '73' , 'TOLIMA');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '76' , 'VALLE DEL CAUCA');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '81' , 'ARAUCA');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '85' , 'CASANARE');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '86' , 'PUTUMAYO');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '88' , 'SAN ANDRES');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '91' , 'AMAZONAS');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '94' , 'GUAINIA');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '95' , 'GUAVIARE');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '97' , 'VAUPES');
INSERT INTO states (id, country_id, code, name) VALUES (states_seq.NEXTVAL,2, '99' , 'VICHADA');
COMMIT;

-- CITIES
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'001', 'MEDELLIN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'002', 'ABEJORRAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'004', 'ABRIAQUI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'021', 'ALEJANDRIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'030', 'AMAGA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'031', 'AMALFI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'034', 'ANDES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'036', 'ANGELOPOLIS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'038', 'ANGOSTURA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'040', 'ANORI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'042', 'SANTAFE DE ANTIOQUIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'044', 'ANZA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'045', 'APARTADO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'051', 'ARBOLETES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'055', 'ARGELIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'059', 'ARMENIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'079', 'BARBOSA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'086', 'BELMIRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'088', 'BELLO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'091', 'BETANIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'093', 'BETULIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'101', 'CIUDAD BOLIVAR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'107', 'BRICE�O');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'113', 'BURITICA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'120', 'CACERES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'125', 'CAICEDO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'129', 'CALDAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'134', 'CAMPAMENTO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'138', 'CA�ASGORDAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'142', 'CARACOLI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'145', 'CARAMANTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'147', 'CAREPA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'148', 'EL CARMEN DE VIBORAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'150', 'CAROLINA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'154', 'CAUCASIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'172', 'CHIGORODO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'190', 'CISNEROS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'197', 'COCORNA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'206', 'CONCEPCION');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'209', 'CONCORDIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'212', 'COPACABANA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'234', 'DABEIBA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'237', 'DON MATIAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'240', 'EBEJICO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'250', 'EL BAGRE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'264', 'ENTRERRIOS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'266', 'ENVIGADO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'282', 'FREDONIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'284', 'FRONTINO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'306', 'GIRALDO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'308', 'GIRARDOTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'310', 'GOMEZ PLATA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'313', 'GRANADA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'315', 'GUADALUPE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'318', 'GUARNE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'321', 'GUATAPE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'347', 'HELICONIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'353', 'HISPANIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'360', 'ITAGUI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'361', 'ITUANGO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'364', 'JARDIN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'368', 'JERICO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'376', 'LA CEJA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'380', 'LA ESTRELLA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'390', 'LA PINTADA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'400', 'LA UNION');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'411', 'LIBORINA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'425', 'MACEO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'440', 'MARINILLA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'467', 'MONTEBELLO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'475', 'MURINDO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'480', 'MUTATA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'483', 'NARI�O');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'490', 'NECOCLI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'495', 'NECHI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'501', 'OLAYA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'541', 'PE�OL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'543', 'PEQUE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'576', 'PUEBLORRICO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'579', 'PUERTO BERRIO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'585', 'PUERTO NARE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'591', 'PUERTO TRIUNFO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'604', 'REMEDIOS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'607', 'RETIRO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'615', 'RIONEGRO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'628', 'SABANALARGA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'631', 'SABANETA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'642', 'SALGAR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'647', 'SAN ANDRES DE CUERQUIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'649', 'SAN CARLOS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'652', 'SAN FRANCISCO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'656', 'SAN JERONIMO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'658', 'SAN JOSE DE LA MONTA�A');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'659', 'SAN JUAN DE URABA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'660', 'SAN LUIS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'664', 'SAN PEDRO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'665', 'SAN PEDRO DE URABA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'667', 'SAN RAFAEL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'670', 'SAN ROQUE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'674', 'SAN VICENTE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'679', 'SANTA BARBARA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'686', 'SANTA ROSA DE OSOS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'690', 'SANTO DOMINGO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'697', 'EL SANTUARIO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'736', 'SEGOVIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'756', 'SONSON');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'761', 'SOPETRAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'789', 'TAMESIS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'790', 'TARAZA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'792', 'TARSO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'809', 'TITIRIBI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'819', 'TOLEDO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'837', 'TURBO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'842', 'URAMITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'847', 'URRAO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'854', 'VALDIVIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'856', 'VALPARAISO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'858', 'VEGACHI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'861', 'VENECIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'873', 'VIGIA DEL FUERTE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'885', 'YALI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'887', 'YARUMAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'890', 'YOLOMBO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'893', 'YONDO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '05'),'895', 'ZARAGOZA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'001', 'BARRANQUILLA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'078', 'BARANOA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'137', 'CAMPO DE LA CRUZ');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'141', 'CANDELARIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'296', 'GALAPA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'372', 'JUAN DE ACOSTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'421', 'LURUACO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'433', 'MALAMBO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'436', 'MANATI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'520', 'PALMAR DE VARELA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'549', 'PIOJO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'558', 'POLONUEVO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'560', 'PONEDERA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'573', 'PUERTO COLOMBIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'606', 'REPELON');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'634', 'SABANAGRANDE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'638', 'SABANALARGA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'675', 'SANTA LUCIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'685', 'SANTO TOMAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'758', 'SOLEDAD');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'770', 'SUAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'832', 'TUBARA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '08'),'849', 'USIACURI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '11'),'001', 'BOGOTA, D.C.');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'001', 'CARTAGENA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'006', 'ACHI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'030', 'ALTOS DEL ROSARIO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'042', 'ARENAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'052', 'ARJONA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'062', 'ARROYOHONDO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'074', 'BARRANCO DE LOBA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'140', 'CALAMAR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'160', 'CANTAGALLO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'188', 'CICUCO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'212', 'CORDOBA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'222', 'CLEMENCIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'244', 'EL CARMEN DE BOLIVAR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'248', 'EL GUAMO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'268', 'EL PE�ON');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'300', 'HATILLO DE LOBA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'430', 'MAGANGUE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'433', 'MAHATES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'440', 'MARGARITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'442', 'MARIA LA BAJA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'458', 'MONTECRISTO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'468', 'MOMPOS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'490', 'NOROSI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'473', 'MORALES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'549', 'PINILLOS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'580', 'REGIDOR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'600', 'RIO VIEJO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'620', 'SAN CRISTOBAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'647', 'SAN ESTANISLAO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'650', 'SAN FERNANDO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'654', 'SAN JACINTO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'655', 'SAN JACINTO DEL CAUCA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'657', 'SAN JUAN NEPOMUCENO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'667', 'SAN MARTIN DE LOBA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'670', 'SAN PABLO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'673', 'SANTA CATALINA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'683', 'SANTA ROSA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'688', 'SANTA ROSA DEL SUR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'744', 'SIMITI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'760', 'SOPLAVIENTO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'780', 'TALAIGUA NUEVO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'810', 'TIQUISIO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'836', 'TURBACO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'838', 'TURBANA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'873', 'VILLANUEVA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '13'),'894', 'ZAMBRANO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'001', 'TUNJA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'022', 'ALMEIDA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'047', 'AQUITANIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'051', 'ARCABUCO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'087', 'BELEN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'090', 'BERBEO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'092', 'BETEITIVA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'097', 'BOAVITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'104', 'BOYACA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'106', 'BRICE�O');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'109', 'BUENAVISTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'114', 'BUSBANZA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'131', 'CALDAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'135', 'CAMPOHERMOSO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'162', 'CERINZA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'172', 'CHINAVITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'176', 'CHIQUINQUIRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'180', 'CHISCAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'183', 'CHITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'185', 'CHITARAQUE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'187', 'CHIVATA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'189', 'CIENEGA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'204', 'COMBITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'212', 'COPER');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'215', 'CORRALES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'218', 'COVARACHIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'223', 'CUBARA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'224', 'CUCAITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'226', 'CUITIVA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'232', 'CHIQUIZA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'236', 'CHIVOR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'238', 'DUITAMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'244', 'EL COCUY');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'248', 'EL ESPINO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'272', 'FIRAVITOBA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'276', 'FLORESTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'293', 'GACHANTIVA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'296', 'GAMEZA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'299', 'GARAGOA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'317', 'GUACAMAYAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'322', 'GUATEQUE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'325', 'GUAYATA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'332', 'GsICAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'362', 'IZA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'367', 'JENESANO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'368', 'JERICO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'377', 'LABRANZAGRANDE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'380', 'LA CAPILLA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'401', 'LA VICTORIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'403', 'LA UVITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'407', 'VILLA DE LEYVA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'425', 'MACANAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'442', 'MARIPI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'455', 'MIRAFLORES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'464', 'MONGUA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'466', 'MONGUI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'469', 'MONIQUIRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'476', 'MOTAVITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'480', 'MUZO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'491', 'NOBSA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'494', 'NUEVO COLON');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'500', 'OICATA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'507', 'OTANCHE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'511', 'PACHAVITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'514', 'PAEZ');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'516', 'PAIPA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'518', 'PAJARITO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'522', 'PANQUEBA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'531', 'PAUNA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'533', 'PAYA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'537', 'PAZ DE RIO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'542', 'PESCA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'550', 'PISBA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'572', 'PUERTO BOYACA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'580', 'QUIPAMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'599', 'RAMIRIQUI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'600', 'RAQUIRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'621', 'RONDON');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'632', 'SABOYA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'638', 'SACHICA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'646', 'SAMACA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'660', 'SAN EDUARDO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'664', 'SAN JOSE DE PARE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'667', 'SAN LUIS DE GACENO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'673', 'SAN MATEO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'676', 'SAN MIGUEL DE SEMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'681', 'SAN PABLO DE BORBUR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'686', 'SANTANA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'690', 'SANTA MARIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'693', 'SANTA ROSA DE VITERBO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'696', 'SANTA SOFIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'720', 'SATIVANORTE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'723', 'SATIVASUR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'740', 'SIACHOQUE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'753', 'SOATA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'755', 'SOCOTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'757', 'SOCHA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'759', 'SOGAMOSO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'761', 'SOMONDOCO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'762', 'SORA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'763', 'SOTAQUIRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'764', 'SORACA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'774', 'SUSACON');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'776', 'SUTAMARCHAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'778', 'SUTATENZA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'790', 'TASCO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'798', 'TENZA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'804', 'TIBANA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'806', 'TIBASOSA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'808', 'TINJACA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'810', 'TIPACOQUE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'814', 'TOCA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'816', 'TOGsI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'820', 'TOPAGA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'822', 'TOTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'832', 'TUNUNGUA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'835', 'TURMEQUE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'837', 'TUTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'839', 'TUTAZA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'842', 'UMBITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'861', 'VENTAQUEMADA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'879', 'VIRACACHA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '15'),'897', 'ZETAQUIRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'001', 'MANIZALES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'013', 'AGUADAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'042', 'ANSERMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'050', 'ARANZAZU');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'088', 'BELALCAZAR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'174', 'CHINCHINA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'272', 'FILADELFIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'380', 'LA DORADA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'388', 'LA MERCED');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'433', 'MANZANARES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'442', 'MARMATO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'444', 'MARQUETALIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'446', 'MARULANDA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'486', 'NEIRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'495', 'NORCASIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'513', 'PACORA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'524', 'PALESTINA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'541', 'PENSILVANIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'614', 'RIOSUCIO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'616', 'RISARALDA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'653', 'SALAMINA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'662', 'SAMANA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'665', 'SAN JOSE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'777', 'SUPIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'867', 'VICTORIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'873', 'VILLAMARIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '17'),'877', 'VITERBO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '18'),'001', 'FLORENCIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '18'),'029', 'ALBANIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '18'),'094', 'BELEN DE LOS ANDAQUIES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '18'),'150', 'CARTAGENA DEL CHAIRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '18'),'205', 'CURILLO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '18'),'247', 'EL DONCELLO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '18'),'256', 'EL PAUJIL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '18'),'410', 'LA MONTA�ITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '18'),'460', 'MILAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '18'),'479', 'MORELIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '18'),'592', 'PUERTO RICO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '18'),'610', 'SAN JOSE DEL FRAGUA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '18'),'753', 'SAN VICENTE DEL CAGUAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '18'),'756', 'SOLANO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '18'),'785', 'SOLITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '18'),'860', 'VALPARAISO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'001', 'POPAYAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'022', 'ALMAGUER');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'050', 'ARGELIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'075', 'BALBOA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'100', 'BOLIVAR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'110', 'BUENOS AIRES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'130', 'CAJIBIO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'137', 'CALDONO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'142', 'CALOTO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'212', 'CORINTO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'256', 'EL TAMBO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'290', 'FLORENCIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'300', 'GUACHENE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'318', 'GUAPI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'355', 'INZA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'364', 'JAMBALO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'392', 'LA SIERRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'397', 'LA VEGA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'418', 'LOPEZ');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'450', 'MERCADERES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'455', 'MIRANDA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'473', 'MORALES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'513', 'PADILLA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'517', 'PAEZ');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'532', 'PATIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'533', 'PIAMONTE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'548', 'PIENDAMO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'573', 'PUERTO TEJADA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'585', 'PURACE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'622', 'ROSAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'693', 'SAN SEBASTIAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'698', 'SANTANDER DE QUILICHAO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'701', 'SANTA ROSA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'743', 'SILVIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'760', 'SOTARA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'780', 'SUAREZ');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'785', 'SUCRE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'807', 'TIMBIO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'809', 'TIMBIQUI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'821', 'TORIBIO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'824', 'TOTORO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '19'),'845', 'VILLA RICA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'001', 'VALLEDUPAR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'011', 'AGUACHICA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'013', 'AGUSTIN CODAZZI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'032', 'ASTREA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'045', 'BECERRIL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'060', 'BOSCONIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'175', 'CHIMICHAGUA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'178', 'CHIRIGUANA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'228', 'CURUMANI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'238', 'EL COPEY');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'250', 'EL PASO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'295', 'GAMARRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'310', 'GONZALEZ');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'383', 'LA GLORIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'400', 'LA JAGUA DE IBIRICO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'443', 'MANAURE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'517', 'PAILITAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'550', 'PELAYA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'570', 'PUEBLO BELLO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'614', 'RIO DE ORO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'621', 'LA PAZ');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'710', 'SAN ALBERTO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'750', 'SAN DIEGO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'770', 'SAN MARTIN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '20'),'787', 'TAMALAMEQUE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'001', 'MONTERIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'068', 'AYAPEL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'079', 'BUENAVISTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'090', 'CANALETE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'162', 'CERETE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'168', 'CHIMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'182', 'CHINU');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'189', 'CIENAGA DE ORO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'300', 'COTORRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'350', 'LA APARTADA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'417', 'LORICA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'419', 'LOS CORDOBAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'464', 'MOMIL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'466', 'MONTELIBANO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'500', 'MO�ITOS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'555', 'PLANETA RICA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'570', 'PUEBLO NUEVO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'574', 'PUERTO ESCONDIDO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'580', 'PUERTO LIBERTADOR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'586', 'PURISIMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'660', 'SAHAGUN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'670', 'SAN ANDRES SOTAVENTO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'672', 'SAN ANTERO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'675', 'SAN BERNARDO DEL VIENTO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'678', 'SAN CARLOS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'686', 'SAN PELAYO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'807', 'TIERRALTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '23'),'855', 'VALENCIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'001', 'AGUA DE DIOS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'019', 'ALBAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'035', 'ANAPOIMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'040', 'ANOLAIMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'053', 'ARBELAEZ');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'086', 'BELTRAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'095', 'BITUIMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'099', 'BOJACA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'120', 'CABRERA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'123', 'CACHIPAY');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'126', 'CAJICA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'148', 'CAPARRAPI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'151', 'CAQUEZA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'154', 'CARMEN DE CARUPA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'168', 'CHAGUANI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'175', 'CHIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'178', 'CHIPAQUE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'181', 'CHOACHI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'183', 'CHOCONTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'200', 'COGUA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'214', 'COTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'224', 'CUCUNUBA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'245', 'EL COLEGIO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'258', 'EL PE�ON');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'260', 'EL ROSAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'269', 'FACATATIVA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'279', 'FOMEQUE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'281', 'FOSCA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'286', 'FUNZA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'288', 'FUQUENE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'290', 'FUSAGASUGA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'293', 'GACHALA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'295', 'GACHANCIPA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'297', 'GACHETA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'299', 'GAMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'307', 'GIRARDOT');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'312', 'GRANADA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'317', 'GUACHETA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'320', 'GUADUAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'322', 'GUASCA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'324', 'GUATAQUI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'326', 'GUATAVITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'328', 'GUAYABAL DE SIQUIMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'335', 'GUAYABETAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'339', 'GUTIERREZ');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'368', 'JERUSALEN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'372', 'JUNIN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'377', 'LA CALERA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'386', 'LA MESA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'394', 'LA PALMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'398', 'LA PE�A');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'402', 'LA VEGA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'407', 'LENGUAZAQUE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'426', 'MACHETA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'430', 'MADRID');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'436', 'MANTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'438', 'MEDINA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'473', 'MOSQUERA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'483', 'NARI�O');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'486', 'NEMOCON');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'488', 'NILO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'489', 'NIMAIMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'491', 'NOCAIMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'506', 'VENECIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'513', 'PACHO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'518', 'PAIME');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'524', 'PANDI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'530', 'PARATEBUENO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'535', 'PASCA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'572', 'PUERTO SALGAR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'580', 'PULI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'592', 'QUEBRADANEGRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'594', 'QUETAME');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'596', 'QUIPILE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'599', 'APULO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'612', 'RICAURTE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'645', 'SAN ANTONIO DEL TEQUENDAMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'649', 'SAN BERNARDO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'653', 'SAN CAYETANO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'658', 'SAN FRANCISCO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'662', 'SAN JUAN DE RIO SECO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'718', 'SASAIMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'736', 'SESQUILE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'740', 'SIBATE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'743', 'SILVANIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'745', 'SIMIJACA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'754', 'SOACHA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'758', 'SOPO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'769', 'SUBACHOQUE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'772', 'SUESCA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'777', 'SUPATA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'779', 'SUSA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'781', 'SUTATAUSA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'785', 'TABIO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'793', 'TAUSA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'797', 'TENA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'799', 'TENJO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'805', 'TIBACUY');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'807', 'TIBIRITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'815', 'TOCAIMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'817', 'TOCANCIPA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'823', 'TOPAIPI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'839', 'UBALA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'841', 'UBAQUE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'843', 'VILLA DE SAN DIEGO DE UBATE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'845', 'UNE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'851', 'UTICA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'862', 'VERGARA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'867', 'VIANI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'871', 'VILLAGOMEZ');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'873', 'VILLAPINZON');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'875', 'VILLETA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'878', 'VIOTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'885', 'YACOPI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'898', 'ZIPACON');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '25'),'899', 'ZIPAQUIRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'001', 'QUIBDO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'006', 'ACANDI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'025', 'ALTO BAUDO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'050', 'ATRATO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'073', 'BAGADO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'075', 'BAHIA SOLANO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'077', 'BAJO BAUDO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'099', 'BOJAYA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'135', 'EL CANTON DEL SAN PABLO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'150', 'CARMEN DEL DARIEN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'160', 'CERTEGUI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'205', 'CONDOTO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'245', 'EL CARMEN DE ATRATO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'250', 'EL LITORAL DEL SAN JUAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'361', 'ISTMINA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'372', 'JURADO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'413', 'LLORO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'425', 'MEDIO ATRATO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'430', 'MEDIO BAUDO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'450', 'MEDIO SAN JUAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'491', 'NOVITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'495', 'NUQUI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'580', 'RIO IRO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'600', 'RIO QUITO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'615', 'RIOSUCIO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'660', 'SAN JOSE DEL PALMAR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'745', 'SIPI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'787', 'TADO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'800', 'UNGUIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '27'),'810', 'UNION PANAMERICANA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'001', 'NEIVA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'006', 'ACEVEDO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'013', 'AGRADO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'016', 'AIPE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'020', 'ALGECIRAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'026', 'ALTAMIRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'078', 'BARAYA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'132', 'CAMPOALEGRE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'206', 'COLOMBIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'244', 'ELIAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'298', 'GARZON');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'306', 'GIGANTE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'319', 'GUADALUPE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'349', 'HOBO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'357', 'IQUIRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'359', 'ISNOS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'378', 'LA ARGENTINA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'396', 'LA PLATA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'483', 'NATAGA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'503', 'OPORAPA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'518', 'PAICOL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'524', 'PALERMO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'530', 'PALESTINA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'548', 'PITAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'551', 'PITALITO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'615', 'RIVERA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'660', 'SALADOBLANCO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'668', 'SAN AGUSTIN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'676', 'SANTA MARIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'770', 'SUAZA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'791', 'TARQUI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'797', 'TESALIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'799', 'TELLO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'801', 'TERUEL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'807', 'TIMANA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'872', 'VILLAVIEJA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '41'),'885', 'YAGUARA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '44'),'001', 'RIOHACHA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '44'),'035', 'ALBANIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '44'),'078', 'BARRANCAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '44'),'090', 'DIBULLA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '44'),'098', 'DISTRACCION');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '44'),'110', 'EL MOLINO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '44'),'279', 'FONSECA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '44'),'378', 'HATONUEVO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '44'),'420', 'LA JAGUA DEL PILAR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '44'),'430', 'MAICAO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '44'),'560', 'MANAURE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '44'),'650', 'SAN JUAN DEL CESAR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '44'),'847', 'URIBIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '44'),'855', 'URUMITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '44'),'874', 'VILLANUEVA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'001', 'SANTA MARTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'030', 'ALGARROBO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'053', 'ARACATACA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'058', 'ARIGUANI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'161', 'CERRO SAN ANTONIO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'170', 'CHIBOLO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'189', 'CIENAGA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'205', 'CONCORDIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'245', 'EL BANCO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'258', 'EL PI�ON');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'268', 'EL RETEN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'288', 'FUNDACION');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'318', 'GUAMAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'460', 'NUEVA GRANADA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'541', 'PEDRAZA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'545', 'PIJI�O DEL CARMEN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'551', 'PIVIJAY');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'555', 'PLATO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'570', 'PUEBLOVIEJO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'605', 'REMOLINO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'660', 'SABANAS DE SAN ANGEL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'675', 'SALAMINA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'692', 'SAN SEBASTIAN DE BUENAVISTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'703', 'SAN ZENON');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'707', 'SANTA ANA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'720', 'SANTA BARBARA DE PINTO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'745', 'SITIONUEVO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'798', 'TENERIFE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'960', 'ZAPAYAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '47'),'980', 'ZONA BANANERA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'001', 'VILLAVICENCIO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'006', 'ACACIAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'110', 'BARRANCA DE UPIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'124', 'CABUYARO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'150', 'CASTILLA LA NUEVA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'223', 'CUBARRAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'226', 'CUMARAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'245', 'EL CALVARIO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'251', 'EL CASTILLO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'270', 'EL DORADO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'287', 'FUENTE DE ORO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'313', 'GRANADA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'318', 'GUAMAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'325', 'MAPIRIPAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'330', 'MESETAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'350', 'LA MACARENA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'370', 'URIBE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'400', 'LEJANIAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'450', 'PUERTO CONCORDIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'568', 'PUERTO GAITAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'573', 'PUERTO LOPEZ');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'577', 'PUERTO LLERAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'590', 'PUERTO RICO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'606', 'RESTREPO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'680', 'SAN CARLOS DE GUAROA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'683', 'SAN JUAN DE ARAMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'686', 'SAN JUANITO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'689', 'SAN MARTIN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '50'),'711', 'VISTAHERMOSA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'001', 'PASTO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'019', 'ALBAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'022', 'ALDANA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'036', 'ANCUYA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'051', 'ARBOLEDA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'079', 'BARBACOAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'083', 'BELEN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'110', 'BUESACO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'203', 'COLON');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'207', 'CONSACA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'210', 'CONTADERO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'215', 'CORDOBA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'224', 'CUASPUD');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'227', 'CUMBAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'233', 'CUMBITARA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'240', 'CHACHAGsI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'250', 'EL CHARCO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'254', 'EL PE�OL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'256', 'EL ROSARIO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'258', 'EL TABLON DE GOMEZ');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'260', 'EL TAMBO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'287', 'FUNES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'317', 'GUACHUCAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'320', 'GUAITARILLA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'323', 'GUALMATAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'352', 'ILES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'354', 'IMUES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'356', 'IPIALES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'378', 'LA CRUZ');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'381', 'LA FLORIDA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'385', 'LA LLANADA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'390', 'LA TOLA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'399', 'LA UNION');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'405', 'LEIVA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'411', 'LINARES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'418', 'LOS ANDES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'427', 'MAGsI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'435', 'MALLAMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'473', 'MOSQUERA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'480', 'NARI�O');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'490', 'OLAYA HERRERA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'506', 'OSPINA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'520', 'FRANCISCO PIZARRO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'540', 'POLICARPA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'560', 'POTOSI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'565', 'PROVIDENCIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'573', 'PUERRES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'585', 'PUPIALES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'612', 'RICAURTE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'621', 'ROBERTO PAYAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'678', 'SAMANIEGO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'683', 'SANDONA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'685', 'SAN BERNARDO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'687', 'SAN LORENZO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'693', 'SAN PABLO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'694', 'SAN PEDRO DE CARTAGO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'696', 'SANTA BARBARA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'699', 'SANTACRUZ');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'720', 'SAPUYES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'786', 'TAMINANGO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'788', 'TANGUA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'835', 'SAN ANDRES DE TUMACO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'838', 'TUQUERRES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '52'),'885', 'YACUANQUER');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'001', 'CUCUTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'003', 'ABREGO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'051', 'ARBOLEDAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'099', 'BOCHALEMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'109', 'BUCARASICA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'125', 'CACOTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'128', 'CACHIRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'172', 'CHINACOTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'174', 'CHITAGA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'206', 'CONVENCION');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'223', 'CUCUTILLA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'239', 'DURANIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'245', 'EL CARMEN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'250', 'EL TARRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'261', 'EL ZULIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'313', 'GRAMALOTE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'344', 'HACARI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'347', 'HERRAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'377', 'LABATECA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'385', 'LA ESPERANZA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'398', 'LA PLAYA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'405', 'LOS PATIOS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'418', 'LOURDES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'480', 'MUTISCUA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'498', 'OCA�A');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'518', 'PAMPLONA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'520', 'PAMPLONITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'553', 'PUERTO SANTANDER');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'599', 'RAGONVALIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'660', 'SALAZAR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'670', 'SAN CALIXTO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'673', 'SAN CAYETANO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'680', 'SANTIAGO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'720', 'SARDINATA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'743', 'SILOS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'800', 'TEORAMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'810', 'TIBU');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'820', 'TOLEDO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'871', 'VILLA CARO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '54'),'874', 'VILLA DEL ROSARIO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '63'),'001', 'ARMENIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '63'),'111', 'BUENAVISTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '63'),'130', 'CALARCA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '63'),'190', 'CIRCASIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '63'),'212', 'CORDOBA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '63'),'272', 'FILANDIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '63'),'302', 'GENOVA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '63'),'401', 'LA TEBAIDA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '63'),'470', 'MONTENEGRO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '63'),'548', 'PIJAO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '63'),'594', 'QUIMBAYA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '63'),'690', 'SALENTO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '66'),'001', 'PEREIRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '66'),'045', 'APIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '66'),'075', 'BALBOA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '66'),'088', 'BELEN DE UMBRIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '66'),'170', 'DOSQUEBRADAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '66'),'318', 'GUATICA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '66'),'383', 'LA CELIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '66'),'400', 'LA VIRGINIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '66'),'440', 'MARSELLA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '66'),'456', 'MISTRATO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '66'),'572', 'PUEBLO RICO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '66'),'594', 'QUINCHIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '66'),'682', 'SANTA ROSA DE CABAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '66'),'687', 'SANTUARIO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'001', 'BUCARAMANGA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'013', 'AGUADA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'020', 'ALBANIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'051', 'ARATOCA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'077', 'BARBOSA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'079', 'BARICHARA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'081', 'BARRANCABERMEJA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'092', 'BETULIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'101', 'BOLIVAR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'121', 'CABRERA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'132', 'CALIFORNIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'147', 'CAPITANEJO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'152', 'CARCASI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'160', 'CEPITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'162', 'CERRITO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'167', 'CHARALA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'169', 'CHARTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'176', 'CHIMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'179', 'CHIPATA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'190', 'CIMITARRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'207', 'CONCEPCION');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'209', 'CONFINES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'211', 'CONTRATACION');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'217', 'COROMORO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'229', 'CURITI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'235', 'EL CARMEN DE CHUCURI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'245', 'EL GUACAMAYO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'250', 'EL PE�ON');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'255', 'EL PLAYON');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'264', 'ENCINO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'266', 'ENCISO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'271', 'FLORIAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'276', 'FLORIDABLANCA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'296', 'GALAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'298', 'GAMBITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'307', 'GIRON');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'318', 'GUACA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'320', 'GUADALUPE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'322', 'GUAPOTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'324', 'GUAVATA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'327', 'GsEPSA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'344', 'HATO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'368', 'JESUS MARIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'370', 'JORDAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'377', 'LA BELLEZA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'385', 'LANDAZURI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'397', 'LA PAZ');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'406', 'LEBRIJA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'418', 'LOS SANTOS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'425', 'MACARAVITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'432', 'MALAGA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'444', 'MATANZA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'464', 'MOGOTES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'468', 'MOLAGAVITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'498', 'OCAMONTE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'500', 'OIBA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'502', 'ONZAGA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'522', 'PALMAR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'524', 'PALMAS DEL SOCORRO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'533', 'PARAMO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'547', 'PIEDECUESTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'549', 'PINCHOTE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'572', 'PUENTE NACIONAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'573', 'PUERTO PARRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'575', 'PUERTO WILCHES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'615', 'RIONEGRO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'655', 'SABANA DE TORRES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'669', 'SAN ANDRES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'673', 'SAN BENITO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'679', 'SAN GIL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'682', 'SAN JOAQUIN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'684', 'SAN JOSE DE MIRANDA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'686', 'SAN MIGUEL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'689', 'SAN VICENTE DE CHUCURI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'705', 'SANTA BARBARA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'720', 'SANTA HELENA DEL OPON');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'745', 'SIMACOTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'755', 'SOCORRO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'770', 'SUAITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'773', 'SUCRE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'780', 'SURATA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'820', 'TONA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'855', 'VALLE DE SAN JOSE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'861', 'VELEZ');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'867', 'VETAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'872', 'VILLANUEVA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '68'),'895', 'ZAPATOCA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'001', 'SINCELEJO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'110', 'BUENAVISTA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'124', 'CAIMITO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'204', 'COLOSO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'215', 'COROZAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'221', 'COVE�AS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'230', 'CHALAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'233', 'EL ROBLE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'235', 'GALERAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'265', 'GUARANDA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'400', 'LA UNION');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'418', 'LOS PALMITOS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'429', 'MAJAGUAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'473', 'MORROA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'508', 'OVEJAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'523', 'PALMITO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'670', 'SAMPUES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'678', 'SAN BENITO ABAD');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'702', 'SAN JUAN DE BETULIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'708', 'SAN MARCOS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'713', 'SAN ONOFRE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'717', 'SAN PEDRO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'742', 'SAN LUIS DE SINCE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'771', 'SUCRE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'820', 'SANTIAGO DE TOLU');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '70'),'823', 'TOLU VIEJO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'001', 'IBAGUE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'024', 'ALPUJARRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'026', 'ALVARADO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'030', 'AMBALEMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'043', 'ANZOATEGUI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'055', 'ARMERO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'067', 'ATACO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'124', 'CAJAMARCA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'148', 'CARMEN DE APICALA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'152', 'CASABIANCA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'168', 'CHAPARRAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'200', 'COELLO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'217', 'COYAIMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'226', 'CUNDAY');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'236', 'DOLORES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'268', 'ESPINAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'270', 'FALAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'275', 'FLANDES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'283', 'FRESNO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'319', 'GUAMO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'347', 'HERVEO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'349', 'HONDA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'352', 'ICONONZO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'408', 'LERIDA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'411', 'LIBANO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'443', 'MARIQUITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'449', 'MELGAR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'461', 'MURILLO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'483', 'NATAGAIMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'504', 'ORTEGA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'520', 'PALOCABILDO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'547', 'PIEDRAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'555', 'PLANADAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'563', 'PRADO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'585', 'PURIFICACION');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'616', 'RIOBLANCO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'622', 'RONCESVALLES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'624', 'ROVIRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'671', 'SALDA�A');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'675', 'SAN ANTONIO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'678', 'SAN LUIS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'686', 'SANTA ISABEL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'770', 'SUAREZ');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'854', 'VALLE DE SAN JUAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'861', 'VENADILLO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'870', 'VILLAHERMOSA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '73'),'873', 'VILLARRICA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'001', 'CALI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'020', 'ALCALA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'036', 'ANDALUCIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'041', 'ANSERMANUEVO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'054', 'ARGELIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'100', 'BOLIVAR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'109', 'BUENAVENTURA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'111', 'GUADALAJARA DE BUGA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'113', 'BUGALAGRANDE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'122', 'CAICEDONIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'126', 'CALIMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'130', 'CANDELARIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'147', 'CARTAGO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'233', 'DAGUA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'243', 'EL AGUILA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'246', 'EL CAIRO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'248', 'EL CERRITO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'250', 'EL DOVIO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'275', 'FLORIDA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'306', 'GINEBRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'318', 'GUACARI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'364', 'JAMUNDI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'377', 'LA CUMBRE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'400', 'LA UNION');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'403', 'LA VICTORIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'497', 'OBANDO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'520', 'PALMIRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'563', 'PRADERA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'606', 'RESTREPO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'616', 'RIOFRIO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'622', 'ROLDANILLO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'670', 'SAN PEDRO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'736', 'SEVILLA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'823', 'TORO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'828', 'TRUJILLO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'834', 'TULUA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'845', 'ULLOA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'863', 'VERSALLES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'869', 'VIJES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'890', 'YOTOCO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'892', 'YUMBO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '76'),'895', 'ZARZAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '81'),'001', 'ARAUCA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '81'),'065', 'ARAUQUITA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '81'),'220', 'CRAVO NORTE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '81'),'300', 'FORTUL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '81'),'591', 'PUERTO RONDON');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '81'),'736', 'SARAVENA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '81'),'794', 'TAME');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '85'),'001', 'YOPAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '85'),'010', 'AGUAZUL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '85'),'015', 'CHAMEZA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '85'),'125', 'HATO COROZAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '85'),'136', 'LA SALINA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '85'),'139', 'MANI');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '85'),'162', 'MONTERREY');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '85'),'225', 'NUNCHIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '85'),'230', 'OROCUE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '85'),'250', 'PAZ DE ARIPORO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '85'),'263', 'PORE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '85'),'279', 'RECETOR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '85'),'300', 'SABANALARGA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '85'),'315', 'SACAMA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '85'),'325', 'SAN LUIS DE PALENQUE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '85'),'400', 'TAMARA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '85'),'410', 'TAURAMENA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '85'),'430', 'TRINIDAD');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '85'),'440', 'VILLANUEVA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '86'),'001', 'MOCOA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '86'),'219', 'COLON');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '86'),'320', 'ORITO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '86'),'568', 'PUERTO ASIS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '86'),'569', 'PUERTO CAICEDO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '86'),'571', 'PUERTO GUZMAN');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '86'),'573', 'LEGUIZAMO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '86'),'749', 'SIBUNDOY');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '86'),'755', 'SAN FRANCISCO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '86'),'757', 'SAN MIGUEL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '86'),'760', 'SANTIAGO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '86'),'865', 'VALLE DEL GUAMUEZ');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '86'),'885', 'VILLAGARZON');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '88'),'001', 'SAN ANDRES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '88'),'564', 'PROVIDENCIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '91'),'001', 'LETICIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '91'),'263', 'EL ENCANTO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '91'),'405', 'LA CHORRERA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '91'),'407', 'LA PEDRERA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '91'),'430', 'LA VICTORIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '91'),'460', 'MIRITI - PARANA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '91'),'530', 'PUERTO ALEGRIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '91'),'536', 'PUERTO ARICA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '91'),'540', 'PUERTO NARI�O');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '91'),'669', 'PUERTO SANTANDER');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '91'),'798', 'TARAPACA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '94'),'001', 'INIRIDA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '94'),'343', 'BARRANCO MINAS');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '94'),'663', 'MAPIRIPANA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '94'),'883', 'SAN FELIPE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '94'),'884', 'PUERTO COLOMBIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '94'),'885', 'LA GUADALUPE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '94'),'886', 'CACAHUAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '94'),'887', 'PANA PANA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '94'),'888', 'MORICHAL');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '95'),'001', 'SAN JOSE DEL GUAVIARE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '95'),'015', 'CALAMAR');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '95'),'025', 'EL RETORNO');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '95'),'200', 'MIRAFLORES');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '97'),'001', 'MITU');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '97'),'161', 'CARURU');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '97'),'511', 'PACOA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '97'),'666', 'TARAIRA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '97'),'777', 'PAPUNAUA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '97'),'889', 'YAVARATE');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '99'),'001', 'PUERTO CARRE�O');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '99'),'524', 'LA PRIMAVERA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '99'),'624', 'SANTA ROSALIA');
INSERT INTO cities (id, state_id, code, name) VALUES (cities_seq.NEXTVAL,(SELECT id FROM states WHERE code = '99'),'773', 'CUMARIBO');
COMMIT;

-- USERS 500 CUSTOMESRS
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1875358841, 'Paige', 'Strickler', '8124071376', 'http://dummyimage.com/240x232.bmp/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1502446295, 'Rhett', 'Bony', '4734871057', 'http://dummyimage.com/242x199.bmp/ff4444/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1200177507, 'Bailie', 'Draco', '4731692709', 'http://dummyimage.com/190x192.png/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1697512828, 'Homer', 'O''Day', '1427724521', 'http://dummyimage.com/127x211.jpg/5fa2dd/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1261093106, 'Morlee', 'Wrinch', '2848388889', 'http://dummyimage.com/124x149.png/ff4444/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1884457488, 'Normy', 'Bursnell', '3883526725', 'http://dummyimage.com/140x242.png/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1896238895, 'Lexi', 'Brucker', '8602954488', 'http://dummyimage.com/169x115.bmp/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1677605236, 'Wanda', 'Englishby', '3075578410', 'http://dummyimage.com/203x208.jpg/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1309971264, 'Burch', 'Featherstone', '8361069627', 'http://dummyimage.com/152x161.bmp/ff4444/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1338347176, 'Brandyn', 'Madgett', '2953808184', 'http://dummyimage.com/250x117.png/dddddd/000000', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1344572761, 'Rriocard', 'Featherstonhalgh', '1665649223', 'http://dummyimage.com/213x137.jpg/dddddd/000000', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1641425789, 'Nevins', 'Claque', '3051351938', 'http://dummyimage.com/155x227.bmp/5fa2dd/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1565105192, 'Heidie', 'Darbyshire', '1747604026', 'http://dummyimage.com/236x233.jpg/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1606067599, 'Micah', 'O''Donnell', '4329178194', 'http://dummyimage.com/133x130.jpg/ff4444/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1728272221, 'Mignon', 'Meysham', '4073043250', 'http://dummyimage.com/103x138.jpg/5fa2dd/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1840789808, 'Jarid', 'Blais', '4196014130', 'http://dummyimage.com/224x185.jpg/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1796561510, 'Noellyn', 'Wykey', '6286117472', 'http://dummyimage.com/101x115.bmp/dddddd/000000', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1675310426, 'Caterina', 'Showen', '8306217852', 'http://dummyimage.com/215x228.bmp/ff4444/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1442113709, 'Delbert', 'Snalom', '2859758725', 'http://dummyimage.com/218x129.png/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1303731026, 'Bo', 'Belsher', '8507768482', 'http://dummyimage.com/226x113.png/dddddd/000000', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1650939057, 'Trista', 'Arnaez', '7232300030', 'http://dummyimage.com/249x158.bmp/5fa2dd/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1810790805, 'Patrice', 'Craw', '5017261776', 'http://dummyimage.com/122x216.bmp/ff4444/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1839405574, 'Clarie', 'Hagland', '1054372264', 'http://dummyimage.com/227x241.jpg/5fa2dd/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1484285558, 'Daisey', 'Tunder', '7886317748', 'http://dummyimage.com/121x133.bmp/cc0000/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1267440683, 'Joelly', 'Scholling', '8526777871', 'http://dummyimage.com/168x221.jpg/cc0000/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1350475803, 'Roz', 'McInnerny', '7296106922', 'http://dummyimage.com/147x223.png/cc0000/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1463914623, 'Lucina', 'Caig', '4358486522', 'http://dummyimage.com/120x141.jpg/dddddd/000000', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1859898335, 'Gayel', 'Nacci', '7981924027', 'http://dummyimage.com/234x186.jpg/cc0000/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1281979647, 'Darrell', 'Lanmeid', '9422946778', 'http://dummyimage.com/200x211.png/cc0000/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1739252345, 'Juanita', 'Rignall', '6701899925', 'http://dummyimage.com/141x143.bmp/dddddd/000000', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1499102280, 'Brynn', 'Haggerstone', '2043044689', 'http://dummyimage.com/241x160.jpg/5fa2dd/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1713239324, 'Mendie', 'Penkman', '3414785899', 'http://dummyimage.com/172x249.jpg/5fa2dd/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1828952214, 'Rainer', 'Ossipenko', '5172270140', 'http://dummyimage.com/117x142.bmp/5fa2dd/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1788518791, 'Bernete', 'Ducaen', '9307823175', 'http://dummyimage.com/199x177.bmp/ff4444/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1185320549, 'Ellary', 'Richings', '7663823558', 'http://dummyimage.com/102x191.bmp/dddddd/000000', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1636756237, 'Sly', 'McClosh', '2885642630', 'http://dummyimage.com/230x150.bmp/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1164863090, 'Phylys', 'Rawkesby', '8758514316', 'http://dummyimage.com/138x218.bmp/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1551948358, 'Corly', 'Wardale', '3978257329', 'http://dummyimage.com/244x177.jpg/cc0000/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1840157098, 'Sara-ann', 'Mabe', '6465493747', 'http://dummyimage.com/236x143.png/cc0000/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1332335779, 'Sinclare', 'Halewood', '8762028411', 'http://dummyimage.com/172x106.bmp/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1129604488, 'Meredithe', 'Lyste', '5884221521', 'http://dummyimage.com/194x230.jpg/5fa2dd/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1199301921, 'Karoly', 'Enston', '2634648815', 'http://dummyimage.com/131x171.jpg/5fa2dd/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1921675745, 'Berri', 'Hadcock', '6521520184', 'http://dummyimage.com/244x225.bmp/cc0000/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1233354165, 'Pete', 'Vernham', '1887749342', 'http://dummyimage.com/207x180.bmp/dddddd/000000', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1579166875, 'Kincaid', 'Selway', '9438513756', 'http://dummyimage.com/129x121.bmp/cc0000/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1881577232, 'Elyssa', 'O''Sullivan', '9301747324', 'http://dummyimage.com/184x168.jpg/ff4444/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1579554384, 'Matthew', 'Ranstead', '8043136274', 'http://dummyimage.com/135x249.png/cc0000/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1155344746, 'Lonny', 'Bullan', '4007569974', 'http://dummyimage.com/192x148.png/5fa2dd/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1646449538, 'Janette', 'Austins', '9638096132', 'http://dummyimage.com/246x186.png/5fa2dd/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1194396173, 'Enrica', 'Delooze', '3346965254', 'http://dummyimage.com/146x127.png/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1836600333, 'Hasty', 'Bebbell', '8342830118', 'http://dummyimage.com/153x124.jpg/ff4444/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1326510781, 'Aimee', 'Lancashire', '7731920146', 'http://dummyimage.com/123x226.bmp/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1620778511, 'Carlie', 'Paull', '1124319541', 'http://dummyimage.com/106x159.png/ff4444/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1434383918, 'Elsey', 'Ferriman', '8669684096', 'http://dummyimage.com/167x217.png/cc0000/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1578564754, 'Ophelie', 'Jenny', '2717081850', 'http://dummyimage.com/132x228.png/5fa2dd/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1246883154, 'Fran', 'Paddy', '9742311283', 'http://dummyimage.com/193x219.bmp/ff4444/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1479539177, 'Cecelia', 'Rounds', '6701513714', 'http://dummyimage.com/182x198.bmp/dddddd/000000', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1196899595, 'Vern', 'Bangiard', '8973439303', 'http://dummyimage.com/208x143.jpg/dddddd/000000', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1362883587, 'Vere', 'Cicccitti', '1307240095', 'http://dummyimage.com/175x186.bmp/ff4444/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1643798646, 'Phyllys', 'Ludvigsen', '5021132588', 'http://dummyimage.com/203x113.png/5fa2dd/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1262198737, 'Gustav', 'Bayston', '3079168180', 'http://dummyimage.com/154x235.bmp/5fa2dd/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1902608396, 'Tamra', 'Grantham', '2853854478', 'http://dummyimage.com/209x159.png/dddddd/000000', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1883017737, 'Rae', 'Allington', '7904708930', 'http://dummyimage.com/203x198.png/5fa2dd/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1507456287, 'Ilsa', 'Dupey', '6941239225', 'http://dummyimage.com/164x151.bmp/cc0000/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1707942652, 'Dacie', 'Macveigh', '2097300570', 'http://dummyimage.com/125x114.jpg/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1602245466, 'Osborn', 'Jerratsch', '9538000519', 'http://dummyimage.com/230x153.png/5fa2dd/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1913407852, 'Leanora', 'Marquis', '9628477322', 'http://dummyimage.com/181x112.png/cc0000/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1611585041, 'Katey', 'Riddett', '6364747036', 'http://dummyimage.com/225x217.bmp/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1274336172, 'Reade', 'Feaks', '4012388710', 'http://dummyimage.com/169x210.png/5fa2dd/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1764609897, 'Stephanie', 'Hubbocks', '2681406728', 'http://dummyimage.com/151x120.png/ff4444/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1550151689, 'Mirabella', 'Buxy', '4511546752', 'http://dummyimage.com/218x149.png/ff4444/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1593628099, 'Adel', 'Isham', '7612671827', 'http://dummyimage.com/190x117.bmp/dddddd/000000', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1680545440, 'Johnath', 'Charer', '6377385976', 'http://dummyimage.com/226x222.png/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1815982433, 'Atlanta', 'Osgar', '3831168625', 'http://dummyimage.com/165x132.png/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1772300761, 'Harriett', 'Darkin', '1988330082', 'http://dummyimage.com/174x138.jpg/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1907207713, 'Meris', 'Antonias', '1795012525', 'http://dummyimage.com/207x107.bmp/dddddd/000000', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1548911650, 'Gabie', 'Guiett', '1622315590', 'http://dummyimage.com/163x118.jpg/5fa2dd/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1158232224, 'Izak', 'Leavy', '4856624031', 'http://dummyimage.com/182x153.bmp/ff4444/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1267582522, 'Percival', 'Pennycook', '7335657831', 'http://dummyimage.com/110x191.jpg/5fa2dd/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1794365188, 'Bea', 'Lewsey', '4339581708', 'http://dummyimage.com/136x218.jpg/5fa2dd/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1249582792, 'Harmon', 'Steuhlmeyer', '6602094393', 'http://dummyimage.com/115x105.bmp/cc0000/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1150490035, 'Pavia', 'Blunsen', '7824439348', 'http://dummyimage.com/196x155.bmp/ff4444/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1489381178, 'Sandi', 'Pinching', '5278347385', 'http://dummyimage.com/209x124.jpg/ff4444/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1218932453, 'Francklyn', 'Stump', '5779462407', 'http://dummyimage.com/209x191.bmp/cc0000/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1461689423, 'Tad', 'Probets', '8832223965', 'http://dummyimage.com/218x222.bmp/dddddd/000000', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1410694375, 'Angelo', 'Sybry', '7286126540', 'http://dummyimage.com/211x223.jpg/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1912280149, 'Karyn', 'Handrick', '3235644283', 'http://dummyimage.com/151x191.jpg/ff4444/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1680724088, 'Kean', 'Platt', '3181251950', 'http://dummyimage.com/100x163.jpg/5fa2dd/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1133106246, 'Rania', 'Jasiak', '3285928814', 'http://dummyimage.com/237x226.bmp/dddddd/000000', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1924968963, 'Hyacinthe', 'Gronno', '9832654643', 'http://dummyimage.com/197x113.jpg/5fa2dd/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1356545708, 'Jackie', 'Kennedy', '9775412366', 'http://dummyimage.com/232x141.bmp/dddddd/000000', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1306477625, 'Josselyn', 'Rafter', '6058256446', 'http://dummyimage.com/113x220.bmp/dddddd/000000', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1898993321, 'L;urette', 'Sarl', '9475474718', 'http://dummyimage.com/150x221.bmp/dddddd/000000', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1365647534, 'Parke', 'Bermingham', '1405798133', 'http://dummyimage.com/123x232.jpg/dddddd/000000', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1757739664, 'Maureene', 'Moquin', '7577156857', 'http://dummyimage.com/123x230.jpg/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1350360153, 'Washington', 'Ridge', '6547179183', 'http://dummyimage.com/116x168.jpg/dddddd/000000', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1225154670, 'Ruprecht', 'Poppleston', '2739150545', 'http://dummyimage.com/155x147.png/5fa2dd/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1423521442, 'Timothy', 'Simnel', '7316337278', 'http://dummyimage.com/233x153.png/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1249138844, 'Cory', 'Layland', '8778304205', 'http://dummyimage.com/147x108.jpg/cc0000/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1290728122, 'Marris', 'Vannar', '5583339368', 'http://dummyimage.com/118x216.bmp/cc0000/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1594439713, 'Mill', 'Belk', '5131520803', 'http://dummyimage.com/140x209.bmp/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1509883828, 'Carmina', 'Sutheran', '5239000678', 'http://dummyimage.com/192x115.png/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1255042145, 'Mollie', 'Lamprecht', '3295105080', 'http://dummyimage.com/166x141.bmp/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1448645165, 'Ricard', 'Sandison', '4651756156', 'http://dummyimage.com/193x217.bmp/5fa2dd/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1460558987, 'Ardra', 'Underhill', '5146201423', 'http://dummyimage.com/175x234.png/dddddd/000000', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1392487969, 'Myrtle', 'Temperton', '3442551673', 'http://dummyimage.com/197x131.bmp/dddddd/000000', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1870637043, 'Fields', 'Parcells', '9966306678', 'http://dummyimage.com/193x115.jpg/cc0000/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1717174001, 'Melodie', 'Gooch', '7609038885', 'http://dummyimage.com/176x154.bmp/cc0000/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1586027906, 'Alphonso', 'Newbigging', '7369533707', 'http://dummyimage.com/229x132.jpg/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1685579889, 'Deonne', 'Petyakov', '7899419423', 'http://dummyimage.com/150x188.bmp/cc0000/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1581728462, 'Carmel', 'Anderton', '1705495748', 'http://dummyimage.com/187x209.bmp/dddddd/000000', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1629345552, 'Cassondra', 'Bumfrey', '2705845501', 'http://dummyimage.com/200x139.jpg/5fa2dd/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1366694785, 'Katee', 'Boston', '7826034468', 'http://dummyimage.com/248x208.bmp/5fa2dd/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1366668015, 'Sallee', 'Gocke', '7332426542', 'http://dummyimage.com/179x203.jpg/5fa2dd/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1878542916, 'Mei', 'Silburn', '2129844805', 'http://dummyimage.com/173x199.bmp/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1485729004, 'Eadith', 'Lauderdale', '8873235444', 'http://dummyimage.com/214x123.png/cc0000/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1880913904, 'Madel', 'Lemmon', '3591643304', 'http://dummyimage.com/137x239.bmp/ff4444/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1906997789, 'Corby', 'Nuton', '9081995998', 'http://dummyimage.com/173x176.bmp/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1698443313, 'Gabriello', 'Gilardone', '7964040651', 'http://dummyimage.com/107x169.jpg/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1430133569, 'Justina', 'Mantrip', '5502870770', 'http://dummyimage.com/195x117.bmp/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1353556094, 'Salvador', 'Weakley', '6318958333', 'http://dummyimage.com/151x106.png/ff4444/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1613571722, 'Kippy', 'Edgecombe', '7746521553', 'http://dummyimage.com/120x205.png/5fa2dd/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1460791559, 'Leonora', 'Vassar', '9656395778', 'http://dummyimage.com/118x102.bmp/cc0000/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1242599770, 'Zitella', 'Bohler', '5519514188', 'http://dummyimage.com/152x202.png/dddddd/000000', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1681853587, 'Agnesse', 'Hartshorn', '4126000060', 'http://dummyimage.com/172x209.jpg/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1426630379, 'Tammy', 'Mayoral', '6432915455', 'http://dummyimage.com/178x185.jpg/5fa2dd/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1266163303, 'Ottilie', 'Cantopher', '3037990000', 'http://dummyimage.com/112x183.png/cc0000/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1160503026, 'Rustin', 'Surcombe', '3914232946', 'http://dummyimage.com/224x181.png/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1198122802, 'Eldridge', 'Hincks', '5028751444', 'http://dummyimage.com/212x103.jpg/ff4444/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1906053876, 'Stanly', 'Bumfrey', '2534610189', 'http://dummyimage.com/204x224.bmp/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1792691158, 'Eolande', 'Loudiane', '2798633721', 'http://dummyimage.com/146x220.bmp/cc0000/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1664811364, 'Dar', 'Jenno', '9658102355', 'http://dummyimage.com/141x206.jpg/5fa2dd/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1524541052, 'Dav', 'McClurg', '1123254243', 'http://dummyimage.com/110x159.png/5fa2dd/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1395440737, 'Logan', 'Ditts', '2233446083', 'http://dummyimage.com/202x163.jpg/5fa2dd/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1136292827, 'Oates', 'Copas', '3517789846', 'http://dummyimage.com/128x138.jpg/cc0000/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1194760218, 'Velvet', 'Eshelby', '7388135016', 'http://dummyimage.com/135x170.png/cc0000/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1441161180, 'Delly', 'Nisbet', '5559527324', 'http://dummyimage.com/166x163.jpg/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1865357199, 'Lyda', 'Ryce', '5134716691', 'http://dummyimage.com/177x100.jpg/ff4444/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1902551409, 'Cthrine', 'Rowes', '1903566907', 'http://dummyimage.com/118x120.bmp/cc0000/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1758116882, 'Elianora', 'Mac Giany', '8024125754', 'http://dummyimage.com/222x228.jpg/cc0000/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1543079441, 'Anni', 'O''Ferris', '2997925859', 'http://dummyimage.com/146x250.jpg/cc0000/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1314543649, 'Danny', 'Spiers', '5164865677', 'http://dummyimage.com/120x233.png/5fa2dd/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1311196238, 'Howard', 'Lomax', '9822197378', 'http://dummyimage.com/116x168.bmp/ff4444/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1808815094, 'Jobina', 'Souness', '8855124757', 'http://dummyimage.com/132x228.bmp/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1354816651, 'Yoko', 'Tattersall', '8683117861', 'http://dummyimage.com/154x239.bmp/5fa2dd/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1511224452, 'Aline', 'Blasing', '4231409440', 'http://dummyimage.com/125x227.jpg/ff4444/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1413406314, 'Babs', 'Bentham', '5577132265', 'http://dummyimage.com/121x129.png/cc0000/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1284790512, 'Scarface', 'Denk', '8203023305', 'http://dummyimage.com/154x103.jpg/dddddd/000000', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1291022289, 'Greggory', 'Grewe', '3722280902', 'http://dummyimage.com/166x237.bmp/cc0000/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1847060002, 'Myron', 'Zanettini', '9877628188', 'http://dummyimage.com/134x230.png/dddddd/000000', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1292601445, 'Conrado', 'Canadas', '1451090373', 'http://dummyimage.com/204x221.png/ff4444/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1539891238, 'Lindi', 'Folbige', '9036428816', 'http://dummyimage.com/244x146.bmp/5fa2dd/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1907203709, 'Arlyne', 'Toye', '1852364388', 'http://dummyimage.com/102x246.jpg/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1813614389, 'Goldy', 'Sawforde', '6509506', 'http://dummyimage.com/181x220.jpg/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1293005181, 'Leena', 'Friedman', '5458722594', 'http://dummyimage.com/160x208.bmp/cc0000/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1265123542, 'Vinson', 'Greatbach', '6358920751', 'http://dummyimage.com/119x142.png/5fa2dd/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1704523565, 'Gianina', 'Sells', '4903441257', 'http://dummyimage.com/184x188.png/dddddd/000000', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1828368413, 'Kelly', 'Jachtym', '1222036081', 'http://dummyimage.com/225x186.bmp/5fa2dd/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1247047947, 'Melisent', 'Folli', '9391358292', 'http://dummyimage.com/208x184.png/ff4444/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1439024951, 'Arlinda', 'Figger', '1954843710', 'http://dummyimage.com/224x148.bmp/dddddd/000000', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1517828440, 'Leicester', 'Clancy', '7876826289', 'http://dummyimage.com/238x162.bmp/5fa2dd/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1707323700, 'Emmye', 'Bottrell', '3219459858', 'http://dummyimage.com/170x206.png/dddddd/000000', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1740627059, 'Tessie', 'Pyser', '5544296019', 'http://dummyimage.com/206x227.png/cc0000/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1825427363, 'Marleah', 'Jardine', '1259887123', 'http://dummyimage.com/121x196.png/dddddd/000000', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1406288980, 'Janet', 'Offin', '4569992238', 'http://dummyimage.com/123x130.bmp/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1858187479, 'Carmelle', 'Laidlow', '6492263819', 'http://dummyimage.com/206x101.jpg/5fa2dd/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1919057648, 'Carolina', 'Tithecote', '3381369330', 'http://dummyimage.com/118x223.png/dddddd/000000', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1175449886, 'Say', 'Vass', '6102704170', 'http://dummyimage.com/197x107.jpg/5fa2dd/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1722891144, 'Michel', 'Beauchamp', '2732174620', 'http://dummyimage.com/100x105.png/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1474896152, 'Jodi', 'Milius', '5548843704', 'http://dummyimage.com/110x159.jpg/ff4444/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1304668588, 'Bern', 'McNeely', '2823715677', 'http://dummyimage.com/179x218.jpg/ff4444/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1613011043, 'Etheline', 'McVrone', '8699277346', 'http://dummyimage.com/171x114.bmp/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1923271140, 'Augustine', 'Pietruschka', '6434838873', 'http://dummyimage.com/232x234.png/5fa2dd/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1379319567, 'Grover', 'Rivenzon', '5428407146', 'http://dummyimage.com/247x223.bmp/dddddd/000000', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1901088902, 'Erin', 'Marskell', '6263281240', 'http://dummyimage.com/110x194.bmp/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1840406372, 'Torey', 'Fearne', '7754110930', 'http://dummyimage.com/160x123.png/ff4444/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1684527460, 'Wilfred', 'Sacchetti', '1218583184', 'http://dummyimage.com/246x118.jpg/cc0000/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1196267636, 'Blair', 'Heinle', '3088449905', 'http://dummyimage.com/143x189.jpg/dddddd/000000', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1333977505, 'Lauralee', 'Morter', '5977876346', 'http://dummyimage.com/169x155.bmp/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1130871743, 'Ailis', 'Rysdale', '7565478087', 'http://dummyimage.com/236x235.jpg/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1811210023, 'Benjy', 'Farrow', '1279255617', 'http://dummyimage.com/107x134.bmp/ff4444/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1867983086, 'Ebba', 'Simmens', '7138303170', 'http://dummyimage.com/198x120.bmp/ff4444/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1751315848, 'Ginny', 'Oke', '9549144751', 'http://dummyimage.com/127x221.jpg/cc0000/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1129661079, 'Chic', 'Yanshinov', '3838515853', 'http://dummyimage.com/193x109.jpg/ff4444/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1430912744, 'Bronnie', 'Porcas', '5062684490', 'http://dummyimage.com/220x213.bmp/cc0000/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1424927785, 'Griffith', 'Nangle', '6046377983', 'http://dummyimage.com/119x231.png/dddddd/000000', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1878995352, 'Othilie', 'Radage', '3967217994', 'http://dummyimage.com/238x184.bmp/5fa2dd/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1495794561, 'Derril', 'Londsdale', '8045573979', 'http://dummyimage.com/150x185.jpg/dddddd/000000', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1546859664, 'Albrecht', 'Girton', '7529959318', 'http://dummyimage.com/204x175.png/dddddd/000000', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1249167825, 'Gill', 'Anwyl', '9337094883', 'http://dummyimage.com/108x132.bmp/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1179389839, 'Lemuel', 'Salling', '4164891162', 'http://dummyimage.com/108x159.bmp/5fa2dd/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1812547952, 'Rodrique', 'Martlew', '2622111763', 'http://dummyimage.com/129x160.bmp/dddddd/000000', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1537053799, 'Helenka', 'Paeckmeyer', '6952978961', 'http://dummyimage.com/171x135.png/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1183154221, 'Maggie', 'Gother', '2356377373', 'http://dummyimage.com/170x185.jpg/cc0000/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1663881744, 'Halsey', 'Croan', '2718025121', 'http://dummyimage.com/174x153.bmp/dddddd/000000', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1646941680, 'Bren', 'Caps', '2057711173', 'http://dummyimage.com/120x226.jpg/5fa2dd/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1797500849, 'Delly', 'Gabbat', '4883690012', 'http://dummyimage.com/234x221.jpg/ff4444/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1598509944, 'Rachelle', 'Cockarill', '9215150193', 'http://dummyimage.com/114x115.bmp/5fa2dd/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1782958695, 'Francklin', 'Mantrup', '7481475822', 'http://dummyimage.com/186x180.jpg/5fa2dd/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1195005523, 'Sibley', 'Ciccarello', '2464745840', 'http://dummyimage.com/100x146.png/5fa2dd/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1696950353, 'Loleta', 'Tudhope', '8696166748', 'http://dummyimage.com/179x172.bmp/cc0000/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1595565273, 'Archibaldo', 'Ilyas', '1156398168', 'http://dummyimage.com/244x141.png/dddddd/000000', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1198670448, 'Inger', 'Mordanti', '4454879563', 'http://dummyimage.com/174x230.png/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1852334303, 'Maritsa', 'Hepher', '3929173273', 'http://dummyimage.com/167x246.bmp/ff4444/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1217950862, 'Bald', 'Acedo', '5969766279', 'http://dummyimage.com/116x107.png/dddddd/000000', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1328120088, 'Feodor', 'Loweth', '3259200673', 'http://dummyimage.com/222x195.jpg/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1829870566, 'Gris', 'Riall', '1536255050', 'http://dummyimage.com/180x157.png/5fa2dd/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1348108603, 'Sansone', 'Lytle', '9653433398', 'http://dummyimage.com/109x173.jpg/5fa2dd/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1191453526, 'Lacee', 'Scott', '5528005327', 'http://dummyimage.com/104x179.bmp/ff4444/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1538490348, 'Lena', 'Bradbeer', '6317930803', 'http://dummyimage.com/119x204.bmp/5fa2dd/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1287939061, 'Kendrick', 'Chapple', '5895160675', 'http://dummyimage.com/131x122.png/5fa2dd/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1278851752, 'Maude', 'Gorvin', '7128004771', 'http://dummyimage.com/240x218.jpg/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1145796638, 'Mildrid', 'Verity', '4376517014', 'http://dummyimage.com/127x189.bmp/cc0000/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1207317493, 'Robbie', 'Gobell', '4988878014', 'http://dummyimage.com/239x220.jpg/5fa2dd/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1888400186, 'Tildi', 'Gebhard', '7156214426', 'http://dummyimage.com/148x172.jpg/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1308420583, 'Krystalle', 'Insull', '4188597662', 'http://dummyimage.com/206x127.jpg/dddddd/000000', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1299093761, 'Cully', 'McPhaden', '3996118873', 'http://dummyimage.com/152x203.png/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1129194304, 'Shadow', 'Piggford', '1533989497', 'http://dummyimage.com/176x106.bmp/5fa2dd/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1820082495, 'Vidovic', 'Blackborne', '1367170772', 'http://dummyimage.com/242x166.jpg/dddddd/000000', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1569702170, 'Curry', 'Senchenko', '3169576599', 'http://dummyimage.com/209x249.bmp/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1517911099, 'Dukey', 'Hartburn', '8166069170', 'http://dummyimage.com/147x233.jpg/cc0000/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1877756792, 'Abner', 'Howton', '9991973711', 'http://dummyimage.com/109x191.png/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1620914286, 'Angy', 'Walder', '1066832995', 'http://dummyimage.com/118x245.png/cc0000/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1742667269, 'Paule', 'Beentjes', '6239809205', 'http://dummyimage.com/141x243.jpg/cc0000/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1403488614, 'Web', 'Dimitresco', '7032118595', 'http://dummyimage.com/230x113.jpg/5fa2dd/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1256488373, 'Demetri', 'Steggals', '9651246713', 'http://dummyimage.com/127x102.png/5fa2dd/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1370332172, 'Twyla', 'Hinksen', '9355304989', 'http://dummyimage.com/198x170.jpg/dddddd/000000', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1748989544, 'Emmery', 'Finders', '4594149814', 'http://dummyimage.com/116x212.bmp/cc0000/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1748028616, 'Guthrie', 'Slocket', '9105896741', 'http://dummyimage.com/117x233.jpg/cc0000/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1188740340, 'Leia', 'Osgordby', '1162189344', 'http://dummyimage.com/145x154.bmp/ff4444/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1602911132, 'Linell', 'Curtoys', '9791381208', 'http://dummyimage.com/122x157.jpg/cc0000/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1732541610, 'Noak', 'Camps', '6359641112', 'http://dummyimage.com/231x113.png/ff4444/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1176541531, 'Janette', 'Bidewel', '6156221209', 'http://dummyimage.com/165x133.png/cc0000/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1859654062, 'Dona', 'Jenkison', '1329323140', 'http://dummyimage.com/105x155.jpg/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1508388166, 'Edmund', 'Mussared', '4882539055', 'http://dummyimage.com/103x146.bmp/ff4444/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1596883863, 'Alaster', 'Sedworth', '3475911357', 'http://dummyimage.com/137x106.bmp/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1591465332, 'Onfre', 'MacLoughlin', '4093958635', 'http://dummyimage.com/175x180.bmp/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1758863202, 'Tina', 'Howsin', '6547155099', 'http://dummyimage.com/243x165.bmp/cc0000/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1435216586, 'Chaunce', 'Crofthwaite', '5359775658', 'http://dummyimage.com/201x103.png/ff4444/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1210415370, 'Ramon', 'McCallister', '4748318504', 'http://dummyimage.com/249x176.bmp/cc0000/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1801572271, 'Merry', 'Ollerhad', '8957513210', 'http://dummyimage.com/163x208.bmp/ff4444/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1524415870, 'Charissa', 'Baford', '9315202070', 'http://dummyimage.com/250x110.png/ff4444/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1650704833, 'Jarrid', 'Cronkshaw', '1876572183', 'http://dummyimage.com/148x145.png/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1298016321, 'Ignatius', 'Oldred', '6284305607', 'http://dummyimage.com/225x210.png/5fa2dd/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1772331060, 'Datha', 'MacCumiskey', '4291524906', 'http://dummyimage.com/192x141.bmp/ff4444/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1801725490, 'Halie', 'Churchyard', '1651633071', 'http://dummyimage.com/234x250.bmp/cc0000/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1209458924, 'Delcine', 'Reims', '2448267118', 'http://dummyimage.com/110x172.png/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1180341576, 'Sammie', 'Sybbe', '9071030591', 'http://dummyimage.com/151x120.jpg/ff4444/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1316413835, 'Faythe', 'Kingswood', '8123433577', 'http://dummyimage.com/250x203.png/ff4444/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1844769187, 'Tate', 'Bounde', '3488302986', 'http://dummyimage.com/227x185.jpg/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1676618602, 'Vilma', 'Bolter', '9869194790', 'http://dummyimage.com/217x175.bmp/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1685012500, 'Kellie', 'Gownge', '8376245330', 'http://dummyimage.com/236x175.bmp/5fa2dd/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1374561557, 'Lonee', 'Conkie', '4994506929', 'http://dummyimage.com/136x244.jpg/5fa2dd/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1707545244, 'Jocko', 'Guiraud', '5929794689', 'http://dummyimage.com/129x209.png/5fa2dd/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1563523806, 'Jeramie', 'Quarlis', '5883007792', 'http://dummyimage.com/129x171.bmp/dddddd/000000', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1849760485, 'Rosina', 'McAnalley', '8779979897', 'http://dummyimage.com/189x217.bmp/5fa2dd/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1388095997, 'Guglielma', 'Daborn', '9719441957', 'http://dummyimage.com/186x179.png/ff4444/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1602055340, 'Nicolis', 'Duplain', '6748074753', 'http://dummyimage.com/192x109.bmp/ff4444/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1187877217, 'Abbe', 'Borgars', '8056424539', 'http://dummyimage.com/155x182.jpg/dddddd/000000', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1741890836, 'Dulcia', 'Crippes', '4187966579', 'http://dummyimage.com/250x215.png/ff4444/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1164563068, 'Lorilee', 'Meeus', '6378565179', 'http://dummyimage.com/197x236.jpg/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1867008614, 'Issiah', 'Dawdary', '5786641528', 'http://dummyimage.com/242x108.jpg/ff4444/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1765273185, 'Irving', 'Wythill', '3623912744', 'http://dummyimage.com/138x159.bmp/dddddd/000000', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1606287174, 'Lane', 'Venard', '6451501818', 'http://dummyimage.com/144x180.png/5fa2dd/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1823048448, 'Kimmi', 'Tremayne', '9197533414', 'http://dummyimage.com/112x184.bmp/5fa2dd/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1176917149, 'Berti', 'Henricsson', '6679212523', 'http://dummyimage.com/221x180.bmp/ff4444/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1170228515, 'Tremain', 'Stoke', '9988011650', 'http://dummyimage.com/183x153.jpg/cc0000/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1820620419, 'Roscoe', 'Fluck', '6237541653', 'http://dummyimage.com/132x233.bmp/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1437817374, 'Sancho', 'Ratke', '3952435970', 'http://dummyimage.com/113x176.bmp/ff4444/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1233175677, 'Ninetta', 'Rubinowitsch', '2577034541', 'http://dummyimage.com/224x178.bmp/ff4444/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1736804150, 'Frasquito', 'Kirman', '2351390542', 'http://dummyimage.com/124x215.jpg/ff4444/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1219759602, 'Guido', 'Tregunna', '2636705812', 'http://dummyimage.com/122x165.jpg/ff4444/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1261414013, 'Reeba', 'Heale', '4297567771', 'http://dummyimage.com/100x166.png/cc0000/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1731988262, 'Alwyn', 'Bachman', '1899063426', 'http://dummyimage.com/200x101.jpg/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1673445201, 'Christabel', 'Geeritz', '3393678677', 'http://dummyimage.com/202x195.png/dddddd/000000', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1196082566, 'Tabitha', 'Fossitt', '7059454241', 'http://dummyimage.com/233x174.png/5fa2dd/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1266800136, 'Zebedee', 'Brazener', '4693825534', 'http://dummyimage.com/192x143.png/cc0000/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1225000839, 'Hewet', 'Crame', '7593913615', 'http://dummyimage.com/239x141.bmp/5fa2dd/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1259456088, 'Pollyanna', 'Hrishchenko', '2117849169', 'http://dummyimage.com/118x114.bmp/ff4444/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1688033354, 'Dollie', 'Gehricke', '3197671164', 'http://dummyimage.com/171x111.png/ff4444/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1252706877, 'Olly', 'Pepperd', '1106596709', 'http://dummyimage.com/128x204.jpg/cc0000/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1486074153, 'Yorgo', 'Crozier', '4772269141', 'http://dummyimage.com/153x190.png/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1861878364, 'Melinda', 'Ivushkin', '6667299814', 'http://dummyimage.com/113x164.jpg/ff4444/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1217175405, 'Concettina', 'Mityushkin', '4412649477', 'http://dummyimage.com/193x209.jpg/5fa2dd/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1146702040, 'Paxton', 'Scothron', '3326921915', 'http://dummyimage.com/161x206.bmp/ff4444/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1137252581, 'Annaliese', 'Aries', '6195846774', 'http://dummyimage.com/175x132.png/dddddd/000000', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1678623423, 'Amalita', 'Skeermor', '1905389758', 'http://dummyimage.com/241x176.jpg/cc0000/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1790962253, 'Lennard', 'Stuke', '9484578554', 'http://dummyimage.com/118x122.bmp/cc0000/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1574883240, 'Deana', 'Bartrap', '9721270541', 'http://dummyimage.com/186x229.jpg/cc0000/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1266759376, 'Hester', 'Kybbye', '4644408577', 'http://dummyimage.com/170x243.png/ff4444/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1765742067, 'Josie', 'Fautley', '5278705909', 'http://dummyimage.com/160x178.bmp/5fa2dd/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1300994673, 'Karissa', 'Babidge', '7203032905', 'http://dummyimage.com/193x111.bmp/ff4444/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1141690811, 'Timoteo', 'Hexter', '6337334756', 'http://dummyimage.com/164x210.jpg/dddddd/000000', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1898468286, 'Marion', 'Chaunce', '2509904995', 'http://dummyimage.com/204x154.jpg/5fa2dd/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1898356609, 'Skipper', 'Balding', '8879499179', 'http://dummyimage.com/129x130.png/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1715040791, 'Forester', 'Sallinger', '9276677836', 'http://dummyimage.com/239x133.bmp/5fa2dd/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1476717761, 'Emanuel', 'Clues', '2115984556', 'http://dummyimage.com/113x140.bmp/cc0000/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1178100885, 'Norma', 'Mazillius', '5771637468', 'http://dummyimage.com/163x151.jpg/5fa2dd/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1208627234, 'Marcy', 'Dutton', '5496469617', 'http://dummyimage.com/216x167.jpg/cc0000/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1414271967, 'Wilek', 'Matuszyk', '4684741646', 'http://dummyimage.com/238x171.jpg/ff4444/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1452005582, 'Hildegaard', 'Runacres', '8505001969', 'http://dummyimage.com/212x108.jpg/ff4444/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1572307026, 'Berti', 'O''Carney', '9664810744', 'http://dummyimage.com/203x182.bmp/cc0000/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1130084229, 'Evanne', 'Philpot', '8478276315', 'http://dummyimage.com/233x180.bmp/ff4444/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1644769574, 'Tabbie', 'Balsdone', '7856404341', 'http://dummyimage.com/231x241.jpg/5fa2dd/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1174173911, 'Tracee', 'Fergie', '9349941016', 'http://dummyimage.com/135x195.jpg/cc0000/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1237804832, 'Syman', 'Walczak', '6145278185', 'http://dummyimage.com/190x137.bmp/5fa2dd/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1454623202, 'Dido', 'Garrals', '9623285869', 'http://dummyimage.com/176x183.bmp/ff4444/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1825971761, 'Jeff', 'Epton', '5636060495', 'http://dummyimage.com/246x185.png/5fa2dd/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1287703896, 'Parker', 'Diviny', '4168206349', 'http://dummyimage.com/176x153.bmp/dddddd/000000', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1430405649, 'Erl', 'Armiger', '3617811068', 'http://dummyimage.com/168x158.png/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1628212191, 'Carl', 'Benion', '1297719686', 'http://dummyimage.com/156x153.png/cc0000/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1925888290, 'Elsy', 'Welden', '1815859978', 'http://dummyimage.com/192x144.bmp/cc0000/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1829520334, 'Nikki', 'Crielly', '2045749855', 'http://dummyimage.com/153x130.png/dddddd/000000', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1497628511, 'Leann', 'Slocket', '1214895867', 'http://dummyimage.com/178x105.png/cc0000/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1236081247, 'Bill', 'Gilderoy', '2016438881', 'http://dummyimage.com/148x146.bmp/dddddd/000000', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1144651470, 'Sigismund', 'Swithenby', '3588748699', 'http://dummyimage.com/128x114.png/cc0000/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1410856587, 'Maryjane', 'Charteris', '9783381295', 'http://dummyimage.com/171x182.png/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1577791195, 'Kirstyn', 'Queenborough', '8074112206', 'http://dummyimage.com/161x144.bmp/ff4444/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1140717844, 'Cyb', 'Gidden', '6294438444', 'http://dummyimage.com/126x105.png/cc0000/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1384371920, 'Cyndi', 'Cicconetti', '8807158327', 'http://dummyimage.com/224x172.jpg/ff4444/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1234511256, 'Rouvin', 'Gabbatiss', '6428930515', 'http://dummyimage.com/151x141.png/ff4444/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1451374935, 'Lu', 'Kellough', '6895274756', 'http://dummyimage.com/157x244.png/5fa2dd/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1798857182, 'Emogene', 'Riddiford', '6089865447', 'http://dummyimage.com/206x167.bmp/dddddd/000000', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1235619102, 'Lilllie', 'Fanthome', '1111538133', 'http://dummyimage.com/237x221.png/ff4444/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1399277649, 'Addy', 'Rubenfeld', '5682929385', 'http://dummyimage.com/219x177.png/5fa2dd/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1828177704, 'Dorena', 'Standen', '2873170786', 'http://dummyimage.com/221x105.bmp/5fa2dd/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1609954551, 'Mariette', 'Yair', '2262929731', 'http://dummyimage.com/127x116.bmp/5fa2dd/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1714390635, 'Madlin', 'MacConchie', '4477215947', 'http://dummyimage.com/147x203.bmp/dddddd/000000', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1206302998, 'Lea', 'Stubley', '9709757707', 'http://dummyimage.com/166x194.png/dddddd/000000', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1305718690, 'Olav', 'Sparsholt', '2485968383', 'http://dummyimage.com/224x113.png/5fa2dd/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1473871251, 'Carmelita', 'Busson', '9629943286', 'http://dummyimage.com/212x105.bmp/5fa2dd/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1441154238, 'Adolphe', 'Eberz', '9227764344', 'http://dummyimage.com/237x224.jpg/cc0000/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1614128151, 'Poul', 'Bottini', '1695598418', 'http://dummyimage.com/138x175.jpg/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1775015261, 'Rafaello', 'Counihan', '6925683732', 'http://dummyimage.com/135x183.jpg/ff4444/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1887787920, 'Berkie', 'Reignard', '1989272194', 'http://dummyimage.com/194x199.png/cc0000/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1255149779, 'Cornell', 'Ostick', '8308778141', 'http://dummyimage.com/191x231.jpg/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1579223639, 'Isadora', 'Gemlett', '4179312017', 'http://dummyimage.com/184x154.png/5fa2dd/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1261450247, 'Anastasia', 'Dockerty', '1546698810', 'http://dummyimage.com/217x230.bmp/5fa2dd/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1859192984, 'Mirabelle', 'Spurrett', '7603062236', 'http://dummyimage.com/243x196.bmp/ff4444/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1580881546, 'Jolie', 'Swale', '7745958319', 'http://dummyimage.com/166x143.bmp/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1146661616, 'Crosby', 'Sibbering', '2137252110', 'http://dummyimage.com/209x147.jpg/5fa2dd/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1147820311, 'Ernesta', 'Arthey', '2525013178', 'http://dummyimage.com/203x142.bmp/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1275864403, 'Kata', 'Trayling', '4678050549', 'http://dummyimage.com/242x248.jpg/dddddd/000000', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1571649202, 'Galven', 'Honig', '2978114310', 'http://dummyimage.com/237x249.png/cc0000/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1850312729, 'Aguste', 'Simenon', '7153885132', 'http://dummyimage.com/186x213.jpg/cc0000/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1292870630, 'Nial', 'Glenister', '8773056583', 'http://dummyimage.com/181x188.bmp/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1244477241, 'Betta', 'Baud', '3566637610', 'http://dummyimage.com/226x125.jpg/5fa2dd/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1308835363, 'Rance', 'Matfield', '9852318192', 'http://dummyimage.com/189x104.bmp/cc0000/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1629775756, 'Vida', 'Gyse', '6432378844', 'http://dummyimage.com/238x123.bmp/5fa2dd/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1634004525, 'Robinet', 'Oby', '2364872726', 'http://dummyimage.com/220x131.png/cc0000/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1292239062, 'Oralia', 'Plitz', '2481409475', 'http://dummyimage.com/106x176.bmp/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1535775321, 'Bryana', 'Gloy', '3897438670', 'http://dummyimage.com/215x160.png/5fa2dd/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1585960124, 'Kenneth', 'Oakey', '5372530301', 'http://dummyimage.com/129x192.jpg/5fa2dd/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1754844671, 'Charis', 'Steagall', '3437414341', 'http://dummyimage.com/205x103.png/ff4444/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1627057237, 'Abeu', 'Fourcade', '7041306597', 'http://dummyimage.com/194x239.jpg/ff4444/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1841594315, 'Immanuel', 'Bowle', '3154069530', 'http://dummyimage.com/149x114.bmp/5fa2dd/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1555971463, 'Ilyssa', 'Diegan', '2124932742', 'http://dummyimage.com/143x204.bmp/cc0000/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1805806681, 'Claudette', 'Dinzey', '6874097658', 'http://dummyimage.com/161x101.bmp/dddddd/000000', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1667804565, 'Crystal', 'Joannet', '4042670113', 'http://dummyimage.com/132x105.bmp/5fa2dd/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1885261881, 'Marshal', 'Ubee', '2219700143', 'http://dummyimage.com/226x229.png/5fa2dd/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1402642128, 'Abbi', 'Litherland', '3854639792', 'http://dummyimage.com/209x216.jpg/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1342511350, 'Chick', 'Dinjes', '4794550769', 'http://dummyimage.com/107x152.bmp/ff4444/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1911488597, 'Abner', 'Canelas', '3766331073', 'http://dummyimage.com/152x125.jpg/ff4444/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1792572574, 'Steve', 'Slowan', '5313936029', 'http://dummyimage.com/110x231.jpg/cc0000/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1792299200, 'Gladys', 'Fessions', '3528549537', 'http://dummyimage.com/219x236.bmp/cc0000/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1651123620, 'Grazia', 'Napolione', '3211372814', 'http://dummyimage.com/139x217.jpg/ff4444/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1601587635, 'Mayne', 'Proschke', '3518263891', 'http://dummyimage.com/209x153.png/5fa2dd/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1840646793, 'Tabby', 'McRoberts', '1523087844', 'http://dummyimage.com/181x172.jpg/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1814965484, 'Tyson', 'Ranyelld', '8681620790', 'http://dummyimage.com/205x176.bmp/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1431536974, 'Crichton', 'Fullerd', '7923019588', 'http://dummyimage.com/214x119.bmp/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1135249947, 'Erroll', 'Willmer', '9995179788', 'http://dummyimage.com/224x207.jpg/cc0000/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1870494664, 'Dale', 'Blackhall', '2035366477', 'http://dummyimage.com/128x202.png/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1474153241, 'Danice', 'Gilpin', '5882827215', 'http://dummyimage.com/211x196.bmp/ff4444/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1208660864, 'Alec', 'Fortie', '6659637185', 'http://dummyimage.com/114x144.jpg/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1530654865, 'Adham', 'Carlan', '3747762340', 'http://dummyimage.com/223x131.png/ff4444/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1589061252, 'Spike', 'Clampe', '6258941206', 'http://dummyimage.com/126x144.jpg/ff4444/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1649032701, 'Claudie', 'Doddridge', '2381316142', 'http://dummyimage.com/232x141.jpg/ff4444/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1357952144, 'Pietrek', 'Harriday', '2061405677', 'http://dummyimage.com/115x103.png/5fa2dd/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1489756001, 'Maighdiln', 'Drife', '1949109438', 'http://dummyimage.com/229x217.png/ff4444/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1625265360, 'Ase', 'Hixley', '8567355541', 'http://dummyimage.com/152x112.png/ff4444/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1844288891, 'Virginia', 'Neilus', '8393137343', 'http://dummyimage.com/197x193.bmp/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1325557211, 'Margaux', 'Drinkall', '5555445941', 'http://dummyimage.com/222x161.jpg/cc0000/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1157895343, 'Iolanthe', 'Summerrell', '1383467926', 'http://dummyimage.com/248x108.jpg/dddddd/000000', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1341668973, 'Cloe', 'Weigh', '2424176878', 'http://dummyimage.com/108x115.png/5fa2dd/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1599421030, 'Melessa', 'Taylot', '1844795469', 'http://dummyimage.com/229x170.bmp/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1314444472, 'Wiley', 'Tooley', '6849842160', 'http://dummyimage.com/237x238.bmp/5fa2dd/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1751578910, 'Karlene', 'Nise', '1275510542', 'http://dummyimage.com/189x149.png/cc0000/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1879769596, 'Aldus', 'Starr', '3055945248', 'http://dummyimage.com/159x220.bmp/5fa2dd/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1846113284, 'Yorke', 'Rodenhurst', '5586467546', 'http://dummyimage.com/210x156.jpg/cc0000/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1656425824, 'Jephthah', 'Staff', '8929747273', 'http://dummyimage.com/112x214.png/ff4444/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1425151281, 'Aviva', 'Bazylets', '9462998526', 'http://dummyimage.com/169x155.jpg/dddddd/000000', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1529242908, 'Ingemar', 'Drakeford', '5947743042', 'http://dummyimage.com/124x126.png/5fa2dd/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1563697206, 'Torre', 'Tesimon', '9754930708', 'http://dummyimage.com/188x146.jpg/dddddd/000000', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1503898501, 'Mommy', 'Hastelow', '1638991320', 'http://dummyimage.com/101x136.png/5fa2dd/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1214624202, 'Brnaba', 'Scown', '3621254971', 'http://dummyimage.com/129x115.jpg/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1781085549, 'Sheena', 'Sarl', '6007832567', 'http://dummyimage.com/165x226.png/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1461561903, 'Hube', 'Penticost', '9898251769', 'http://dummyimage.com/195x185.jpg/cc0000/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1334993393, 'Gardie', 'Cavey', '2555869356', 'http://dummyimage.com/140x222.bmp/dddddd/000000', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1134459897, 'Malina', 'Gosalvez', '2962480711', 'http://dummyimage.com/233x167.png/ff4444/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1439043806, 'Rosemarie', 'Conelly', '5029061547', 'http://dummyimage.com/176x205.bmp/5fa2dd/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1466692136, 'Jed', 'Whilde', '4681319537', 'http://dummyimage.com/225x207.jpg/ff4444/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1604469675, 'Catina', 'Cluff', '8921126367', 'http://dummyimage.com/163x188.bmp/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1626149506, 'Johna', 'MacGovern', '8626422696', 'http://dummyimage.com/123x234.bmp/cc0000/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1627418170, 'Allix', 'Wines', '7818335845', 'http://dummyimage.com/158x186.jpg/cc0000/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1542703097, 'Marlo', 'Axell', '4371467794', 'http://dummyimage.com/233x201.bmp/dddddd/000000', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1478086195, 'Burg', 'Raggles', '4491414555', 'http://dummyimage.com/159x184.jpg/dddddd/000000', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1406950338, 'Rollins', 'Bremley', '6326402383', 'http://dummyimage.com/225x247.jpg/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1150802981, 'Eduard', 'Joscelin', '2821251498', 'http://dummyimage.com/177x110.png/cc0000/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1141964779, 'Culver', 'Mathiassen', '7567253898', 'http://dummyimage.com/210x198.jpg/5fa2dd/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1200177866, 'Thibaut', 'Kemish', '1003563997', 'http://dummyimage.com/133x195.png/cc0000/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1668748317, 'Paolina', 'Capps', '4875893412', 'http://dummyimage.com/203x246.png/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1429708386, 'Marina', 'O''Flaherty', '2498948796', 'http://dummyimage.com/119x127.bmp/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1740694863, 'Shantee', 'Rubury', '5012279095', 'http://dummyimage.com/137x212.bmp/cc0000/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1462821072, 'Brennen', 'Bullent', '6469756727', 'http://dummyimage.com/233x184.jpg/ff4444/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1169843094, 'Hubert', 'Skone', '9818266134', 'http://dummyimage.com/138x117.jpg/ff4444/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1428303547, 'Ludovico', 'Fearnside', '3041111356', 'http://dummyimage.com/154x208.bmp/ff4444/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1170247296, 'Eliot', 'Mignot', '3727708359', 'http://dummyimage.com/240x107.bmp/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1925155744, 'Libby', 'Haile', '2162944884', 'http://dummyimage.com/106x170.bmp/cc0000/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1827096068, 'Bartie', 'Bastie', '3712178138', 'http://dummyimage.com/113x141.bmp/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1909502772, 'Bobette', 'Giraths', '3778590625', 'http://dummyimage.com/250x199.png/cc0000/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1708544575, 'Breanne', 'Inworth', '4465609404', 'http://dummyimage.com/231x160.jpg/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1509481506, 'Lissa', 'Brooke', '3163869527', 'http://dummyimage.com/167x194.bmp/dddddd/000000', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1435084481, 'Caroline', 'Kidder', '6204795226', 'http://dummyimage.com/247x127.jpg/5fa2dd/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1587080717, 'Korry', 'Gallatly', '5368187080', 'http://dummyimage.com/132x107.png/cc0000/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1540279466, 'Eilis', 'Dumpleton', '6746054191', 'http://dummyimage.com/173x130.png/5fa2dd/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1625128145, 'Fernande', 'O''Carran', '7738594126', 'http://dummyimage.com/194x138.bmp/5fa2dd/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1644151986, 'Giselle', 'Croley', '7025155949', 'http://dummyimage.com/207x117.bmp/ff4444/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1432662212, 'Chen', 'Maultby', '2243083080', 'http://dummyimage.com/182x209.png/ff4444/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1151717131, 'Robbie', 'Pack', '6656246798', 'http://dummyimage.com/106x203.bmp/5fa2dd/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1142453080, 'Tally', 'Colthard', '1482043057', 'http://dummyimage.com/127x174.png/5fa2dd/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1731654914, 'Evelyn', 'Creeber', '6267884913', 'http://dummyimage.com/151x114.bmp/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1833729715, 'Cosmo', 'Hindrich', '3004179816', 'http://dummyimage.com/173x148.png/ff4444/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1570485465, 'Clarey', 'Marzelle', '4766927096', 'http://dummyimage.com/102x122.jpg/dddddd/000000', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1838528502, 'Richie', 'Fearnside', '4279096320', 'http://dummyimage.com/114x128.jpg/dddddd/000000', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1592024044, 'Tucky', 'Brabbs', '5932800998', 'http://dummyimage.com/157x141.bmp/cc0000/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1926791110, 'Hillyer', 'Ligerton', '2589613472', 'http://dummyimage.com/242x118.png/5fa2dd/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1574245931, 'Eachelle', 'Everal', '5482648168', 'http://dummyimage.com/116x132.bmp/dddddd/000000', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1276560664, 'Rosella', 'Ratledge', '5965622934', 'http://dummyimage.com/239x109.png/cc0000/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1538823584, 'Reilly', 'Attack', '8369081783', 'http://dummyimage.com/135x142.jpg/dddddd/000000', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1850863535, 'Winifred', 'Massingham', '2376240943', 'http://dummyimage.com/117x176.jpg/5fa2dd/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1526835642, 'Legra', 'Rodda', '3594880761', 'http://dummyimage.com/219x189.jpg/5fa2dd/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1627670251, 'Meghan', 'Stedson', '8455613623', 'http://dummyimage.com/117x164.png/ff4444/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1597806577, 'Candis', 'Rubenovic', '4639182569', 'http://dummyimage.com/120x233.bmp/ff4444/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1308898696, 'Chip', 'Allender', '4179359116', 'http://dummyimage.com/233x238.bmp/dddddd/000000', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1837217457, 'Eleanore', 'Filler', '5755896092', 'http://dummyimage.com/186x209.jpg/dddddd/000000', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1255890436, 'Nyssa', 'Claw', '1346351809', 'http://dummyimage.com/203x222.png/dddddd/000000', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1687583426, 'Kev', 'Aitcheson', '4507217716', 'http://dummyimage.com/165x243.bmp/cc0000/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1780365479, 'Hedwig', 'Kingcote', '3533015231', 'http://dummyimage.com/192x156.bmp/ff4444/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1865567211, 'Octavius', 'De Bruyne', '3788612129', 'http://dummyimage.com/190x236.bmp/5fa2dd/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1286182404, 'Jerri', 'Wickmann', '5815632042', 'http://dummyimage.com/211x205.png/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1684517742, 'Axe', 'Merton', '3342318852', 'http://dummyimage.com/246x132.jpg/5fa2dd/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1687111292, 'Brok', 'Gunnell', '7907953129', 'http://dummyimage.com/182x187.bmp/dddddd/000000', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1714453542, 'Vivien', 'Nitti', '5245052089', 'http://dummyimage.com/177x127.jpg/dddddd/000000', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1313078913, 'Ernesta', 'Spafford', '6063083750', 'http://dummyimage.com/145x101.jpg/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1712638827, 'Latrina', 'O''Hegertie', '2288725247', 'http://dummyimage.com/169x196.bmp/cc0000/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1501253601, 'Andi', 'Blagden', '4102616216', 'http://dummyimage.com/213x183.png/cc0000/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1905315797, 'Lonnie', 'Matthew', '6064339917', 'http://dummyimage.com/217x157.bmp/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1420986548, 'Montgomery', 'Dinnies', '8121575333', 'http://dummyimage.com/188x156.bmp/ff4444/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1740131866, 'Brianne', 'Baudinelli', '5055518085', 'http://dummyimage.com/129x244.bmp/cc0000/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1886507342, 'Culver', 'Cheale', '2819748545', 'http://dummyimage.com/194x149.bmp/cc0000/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1905262967, 'Brien', 'Sheldrick', '6562066285', 'http://dummyimage.com/127x103.jpg/5fa2dd/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1212075037, 'Stephanus', 'Wiltshear', '7223411809', 'http://dummyimage.com/243x235.png/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1665952814, 'Pattie', 'Hurche', '4606935030', 'http://dummyimage.com/153x237.jpg/ff4444/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1916214183, 'Natalya', 'Ciciotti', '4231851224', 'http://dummyimage.com/160x235.png/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1672236752, 'Lyn', 'Westgarth', '9026568201', 'http://dummyimage.com/127x139.jpg/ff4444/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1513828663, 'Donaugh', 'Phelips', '7071955326', 'http://dummyimage.com/217x220.bmp/cc0000/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1314020255, 'Peder', 'Briscow', '8415345868', 'http://dummyimage.com/129x189.jpg/cc0000/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1451726295, 'Datha', 'Terzi', '1961809061', 'http://dummyimage.com/154x209.jpg/ff4444/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1415787635, 'Risa', 'Lathe', '9447795932', 'http://dummyimage.com/214x164.jpg/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1345282369, 'Orelia', 'Speechly', '4636297068', 'http://dummyimage.com/111x147.png/5fa2dd/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1526758698, 'Pace', 'Juanico', '6522302002', 'http://dummyimage.com/214x124.jpg/cc0000/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1359952114, 'Magda', 'Dummett', '7638883840', 'http://dummyimage.com/174x143.bmp/dddddd/000000', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1459354799, 'Toiboid', 'Strelitzki', '6295351596', 'http://dummyimage.com/123x176.jpg/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1626050835, 'Abel', 'St. Aubyn', '5789146112', 'http://dummyimage.com/139x169.bmp/dddddd/000000', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1155232861, 'Neile', 'Brattan', '3609212538', 'http://dummyimage.com/125x185.bmp/cc0000/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1232639800, 'Giulio', 'Morbey', '8221904201', 'http://dummyimage.com/228x241.jpg/dddddd/000000', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1239979320, 'Devi', 'Emmanueli', '1264143473', 'http://dummyimage.com/185x159.jpg/dddddd/000000', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1870532363, 'Montague', 'Geldart', '7478516337', 'http://dummyimage.com/117x111.jpg/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1895780529, 'Rowena', 'Lummasana', '9776974942', 'http://dummyimage.com/159x195.bmp/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1243335159, 'Evie', 'Hedgecock', '2677277980', 'http://dummyimage.com/183x244.png/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1389702854, 'Tarrance', 'Eddison', '3064161332', 'http://dummyimage.com/142x119.jpg/ff4444/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1163068332, 'Ellen', 'Tute', '4909204699', 'http://dummyimage.com/189x108.jpg/5fa2dd/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1330938816, 'Matelda', 'Busson', '4049504662', 'http://dummyimage.com/242x194.bmp/ff4444/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1740653507, 'Bertie', 'Hellmore', '7242525605', 'http://dummyimage.com/131x178.bmp/dddddd/000000', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1397538654, 'Christoforo', 'Ramard', '4647289115', 'http://dummyimage.com/244x125.bmp/dddddd/000000', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1517883948, 'Kevyn', 'Barras', '5539776669', 'http://dummyimage.com/209x177.jpg/5fa2dd/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1372623015, 'Eamon', 'Kelsey', '9527626218', 'http://dummyimage.com/140x134.jpg/ff4444/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1859368584, 'Ariela', 'Brierly', '9452272437', 'http://dummyimage.com/232x225.bmp/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1830522758, 'Yetta', 'Ephson', '8659306104', 'http://dummyimage.com/181x176.jpg/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1642608468, 'Aksel', 'Raymond', '3679563625', 'http://dummyimage.com/119x195.png/5fa2dd/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1420972420, 'Annaliese', 'Veldman', '4448238249', 'http://dummyimage.com/164x124.jpg/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1554495752, 'Theresa', 'Helliker', '3328448469', 'http://dummyimage.com/179x162.bmp/dddddd/000000', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1666351275, 'Zandra', 'Base', '3168551201', 'http://dummyimage.com/241x154.jpg/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1766406680, 'Georgine', 'Zylberdik', '3333569365', 'http://dummyimage.com/137x204.jpg/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1619178265, 'Revkah', 'Pharrow', '9824882077', 'http://dummyimage.com/237x139.bmp/cc0000/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1729711721, 'Brade', 'Loosemore', '9385227339', 'http://dummyimage.com/126x123.png/ff4444/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1709936956, 'Marty', 'Silvermann', '8275132730', 'http://dummyimage.com/107x238.jpg/5fa2dd/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1751106740, 'Everett', 'Laise', '4218589813', 'http://dummyimage.com/180x117.bmp/dddddd/000000', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1377366452, 'Lyell', 'Scolding', '5617757217', 'http://dummyimage.com/137x129.bmp/5fa2dd/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'CUSTOMER', 'CC', 1704127672, 'Chrisse', 'Dawnay', '4849369934', 'http://dummyimage.com/163x245.jpg/5fa2dd/ffffff', 604, 'ESPA�OL');
COMMIT; 

-- USERS 100 DRIVERS
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1645772515, 'Bobby', 'Trengrove', '2109012344', 'http://dummyimage.com/249x231.jpg/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1888409582, 'Corrie', 'Lightwing', '6437006313', 'http://dummyimage.com/245x214.bmp/cc0000/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1551178361, 'Whitby', 'Ingram', '8807581269', 'http://dummyimage.com/233x199.png/5fa2dd/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1156442594, 'Ricki', 'Dadson', '2183327286', 'http://dummyimage.com/123x117.bmp/5fa2dd/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1272552482, 'Libbey', 'Collingdon', '2977715094', 'http://dummyimage.com/148x101.bmp/ff4444/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1826652248, 'Alistair', 'Clapton', '8018557906', 'http://dummyimage.com/196x172.bmp/dddddd/000000', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1322241926, 'Luther', 'Darben', '6257071318', 'http://dummyimage.com/126x167.png/5fa2dd/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1529668603, 'Woodman', 'Leavry', '8471891179', 'http://dummyimage.com/193x126.jpg/ff4444/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1401903489, 'Dory', 'Flight', '2353569675', 'http://dummyimage.com/164x162.jpg/5fa2dd/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1870092241, 'Johannes', 'Crockford', '8849777388', 'http://dummyimage.com/141x128.bmp/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1801881729, 'Malachi', 'Tropman', '7892702007', 'http://dummyimage.com/154x227.bmp/ff4444/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1133066667, 'Natty', 'Mougin', '7187683893', 'http://dummyimage.com/152x220.png/cc0000/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1789499315, 'Iolande', 'Blesdill', '7939154757', 'http://dummyimage.com/173x212.jpg/cc0000/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1252324276, 'Charles', 'Ilyenko', '8112554149', 'http://dummyimage.com/146x107.jpg/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1365420842, 'Cleo', 'Sturman', '8748486109', 'http://dummyimage.com/249x210.bmp/dddddd/000000', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1662335095, 'Jackie', 'Maine', '5553771046', 'http://dummyimage.com/107x181.jpg/cc0000/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1906543673, 'Beverlee', 'Bertin', '1081081330', 'http://dummyimage.com/114x204.bmp/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1451676422, 'Sherlocke', 'Thurgood', '8628908560', 'http://dummyimage.com/195x113.png/cc0000/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1728062431, 'Pernell', 'McNamara', '3067425343', 'http://dummyimage.com/120x231.jpg/5fa2dd/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1609846610, 'Dorolisa', 'Measures', '2872878442', 'http://dummyimage.com/199x250.bmp/ff4444/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1729869395, 'Ernesto', 'Halladey', '6673600001', 'http://dummyimage.com/161x178.jpg/5fa2dd/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1486978288, 'Mirna', 'MacNally', '5823368371', 'http://dummyimage.com/192x199.bmp/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1701984005, 'Daniella', 'Dobrovolny', '7435266785', 'http://dummyimage.com/131x186.bmp/cc0000/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1550976602, 'Zarah', 'Prozillo', '4681296106', 'http://dummyimage.com/180x169.jpg/ff4444/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1717044416, 'Rosemary', 'Lefridge', '3707863663', 'http://dummyimage.com/144x223.png/dddddd/000000', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1864938097, 'Marian', 'Grunguer', '8611508513', 'http://dummyimage.com/167x133.png/ff4444/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1793688104, 'Evania', 'Hugonneau', '9973301984', 'http://dummyimage.com/234x122.png/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1165680821, 'Olivia', 'Vondrasek', '4171563842', 'http://dummyimage.com/178x196.jpg/5fa2dd/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1635462494, 'Ailyn', 'Champniss', '9204749179', 'http://dummyimage.com/219x220.png/dddddd/000000', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1723120206, 'Alix', 'Sprules', '2442539266', 'http://dummyimage.com/178x218.bmp/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1660960525, 'Mikol', 'Lonie', '1151581767', 'http://dummyimage.com/110x207.bmp/dddddd/000000', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1285385267, 'Tera', 'Beazey', '3478695667', 'http://dummyimage.com/125x135.jpg/dddddd/000000', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1863899722, 'Siegfried', 'Ryburn', '3884064305', 'http://dummyimage.com/198x201.png/ff4444/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1443739276, 'Ray', 'Cumo', '5003821458', 'http://dummyimage.com/195x163.bmp/5fa2dd/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1189742849, 'Carmela', 'Veschi', '4073460404', 'http://dummyimage.com/135x217.jpg/5fa2dd/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1584684386, 'Mickie', 'Harborow', '3117858270', 'http://dummyimage.com/189x212.bmp/cc0000/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1823876851, 'Opaline', 'Robbins', '7827291720', 'http://dummyimage.com/125x108.bmp/dddddd/000000', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1330778320, 'Scotty', 'Kemwal', '5785780262', 'http://dummyimage.com/204x239.png/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1896051616, 'Morgan', 'Restieaux', '2185194629', 'http://dummyimage.com/224x134.png/5fa2dd/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1303544138, 'Tabby', 'Howcroft', '6052479169', 'http://dummyimage.com/136x149.bmp/dddddd/000000', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1184899791, 'Millie', 'Whittock', '6881329992', 'http://dummyimage.com/227x155.bmp/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1651095847, 'Bobby', 'Lampet', '9097652556', 'http://dummyimage.com/226x152.bmp/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1554557829, 'Guillermo', 'Chate', '5944812623', 'http://dummyimage.com/145x164.jpg/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1400937974, 'Halley', 'Luckcuck', '1552685340', 'http://dummyimage.com/201x111.jpg/ff4444/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1206769502, 'Sybyl', 'Merrgan', '7947162643', 'http://dummyimage.com/211x179.bmp/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1815706512, 'Amaleta', 'Champley', '7807110467', 'http://dummyimage.com/233x179.png/5fa2dd/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1256768241, 'Jackie', 'Callear', '3245332266', 'http://dummyimage.com/233x196.png/cc0000/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1150320061, 'Darnall', 'Cicchillo', '9361916063', 'http://dummyimage.com/106x246.bmp/5fa2dd/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1563990978, 'Kelli', 'Burker', '4142572011', 'http://dummyimage.com/143x193.bmp/dddddd/000000', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1179535522, 'Brantley', 'Hanson', '7823108635', 'http://dummyimage.com/227x220.png/dddddd/000000', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1667308564, 'Sol', 'Sapir', '5179815825', 'http://dummyimage.com/222x131.png/dddddd/000000', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1407996297, 'Fernandina', 'Hulburt', '8428632401', 'http://dummyimage.com/181x101.png/ff4444/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1553142904, 'Almeria', 'Hanhardt', '9831388814', 'http://dummyimage.com/167x168.jpg/dddddd/000000', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1345504080, 'Guthrey', 'Crum', '7916661231', 'http://dummyimage.com/191x226.jpg/dddddd/000000', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1275737093, 'Gretchen', 'Borrill', '2335861704', 'http://dummyimage.com/174x115.bmp/dddddd/000000', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1518811399, 'Flin', 'Ewestace', '1017963121', 'http://dummyimage.com/145x136.png/5fa2dd/ffffff', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1559516847, 'Fran', 'Iliffe', '4864404871', 'http://dummyimage.com/105x177.png/ff4444/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1404430678, 'Romona', 'Duffy', '2897887175', 'http://dummyimage.com/220x122.png/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1191700425, 'Josie', 'Judgkins', '8428068320', 'http://dummyimage.com/139x182.png/cc0000/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1377031332, 'Addy', 'Walworth', '5362662443', 'http://dummyimage.com/173x208.png/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1336458064, 'Pierre', 'Ismail', '4595873886', 'http://dummyimage.com/166x186.bmp/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1471306670, 'Adrien', 'Worden', '5296839172', 'http://dummyimage.com/238x183.bmp/dddddd/000000', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1774063696, 'Pammy', 'Shower', '8473022931', 'http://dummyimage.com/222x234.jpg/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1608288884, 'Ginni', 'Boynton', '7007634532', 'http://dummyimage.com/108x174.png/dddddd/000000', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1567829216, 'Hedy', 'Winny', '1076862599', 'http://dummyimage.com/246x191.jpg/ff4444/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1893221797, 'Jesse', 'Frayn', '3447782707', 'http://dummyimage.com/213x119.jpg/5fa2dd/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1623707342, 'Tarrah', 'Giacopini', '4163180834', 'http://dummyimage.com/247x127.jpg/5fa2dd/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1374633396, 'Emelen', 'Payne', '4621478711', 'http://dummyimage.com/218x226.png/dddddd/000000', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1835778402, 'Simone', 'Sylvester', '1419985413', 'http://dummyimage.com/103x244.jpg/ff4444/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1906375214, 'Kyla', 'Tertre', '2967253460', 'http://dummyimage.com/171x202.jpg/ff4444/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1345158908, 'Verney', 'Chetham', '9468640298', 'http://dummyimage.com/217x171.jpg/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1874948294, 'Claudetta', 'Gahagan', '7047085047', 'http://dummyimage.com/123x148.jpg/cc0000/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1154385246, 'Isadore', 'Dislee', '1579597651', 'http://dummyimage.com/233x190.bmp/dddddd/000000', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1695705873, 'Allister', 'Connerly', '2124929399', 'http://dummyimage.com/192x127.png/5fa2dd/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1679417785, 'Ruby', 'Botting', '6682520692', 'http://dummyimage.com/231x115.png/dddddd/000000', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1455320788, 'Tito', 'Barr', '3702182488', 'http://dummyimage.com/210x157.jpg/dddddd/000000', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1208211442, 'Reagen', 'Babcock', '9948000188', 'http://dummyimage.com/142x180.png/ff4444/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1303446115, 'Ronnie', 'Playle', '8699399514', 'http://dummyimage.com/229x207.jpg/dddddd/000000', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1459087651, 'Oren', 'Scrivner', '4426846747', 'http://dummyimage.com/150x146.png/cc0000/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1338405346, 'Rhody', 'Sabater', '4072712381', 'http://dummyimage.com/215x249.png/5fa2dd/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1213332647, 'Rolph', 'McKinn', '7951625760', 'http://dummyimage.com/159x239.png/ff4444/ffffff', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1859312382, 'Martie', 'Sute', '6831837050', 'http://dummyimage.com/202x206.jpg/dddddd/000000', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1889060867, 'Ray', 'Polak', '5635498791', 'http://dummyimage.com/235x118.png/ff4444/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1585110078, 'Michelina', 'Snaddin', '8796638366', 'http://dummyimage.com/116x215.bmp/ff4444/ffffff', 604, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1151956611, 'Bradly', 'Sirette', '5486083629', 'http://dummyimage.com/128x109.png/cc0000/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1699833421, 'Wendy', 'Eastmond', '1512152088', 'http://dummyimage.com/110x150.jpg/dddddd/000000', 20, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1188277129, 'Perry', 'Foulds', '6392771086', 'http://dummyimage.com/158x152.png/cc0000/ffffff', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1570691727, 'Roland', 'Speeding', '7979865498', 'http://dummyimage.com/157x144.jpg/dddddd/000000', 127, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1777983007, 'Rachel', 'Dykins', '2131179306', 'http://dummyimage.com/132x219.png/ff4444/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1383978553, 'Brittany', 'Sackler', '7972607145', 'http://dummyimage.com/189x180.jpg/cc0000/ffffff', 150, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1142050381, 'Donetta', 'Tillerton', '6936770802', 'http://dummyimage.com/169x234.bmp/cc0000/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1719524913, 'Pammie', 'Boldry', '9407304618', 'http://dummyimage.com/241x153.bmp/dddddd/000000', 2, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1903729620, 'Dominica', 'Ellins', '1438263324', 'http://dummyimage.com/210x220.png/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1752405851, 'Merrick', 'Redd', '1039305405', 'http://dummyimage.com/224x221.png/5fa2dd/ffffff', 60, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1616978363, 'Elroy', 'Charlton', '5066597074', 'http://dummyimage.com/182x228.bmp/dddddd/000000', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1882781550, 'Franklyn', 'Hewins', '8006249605', 'http://dummyimage.com/243x127.png/dddddd/000000', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1224829160, 'Sarena', 'Denacamp', '3674905405', 'http://dummyimage.com/110x214.png/cc0000/ffffff', 42, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1546468714, 'Ursola', 'Oliver', '7326115543', 'http://dummyimage.com/222x191.bmp/5fa2dd/ffffff', 1005, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1490677041, 'Ches', 'Davenport', '1161494164', 'http://dummyimage.com/114x230.bmp/cc0000/ffffff', 151, 'ESPA�OL');
insert into USERS (ID, USER_TYPE, TRIBUTARY_ID_TYPE, TRIBUTARY_ID, NAME, LAST_NAME, PHONE_NUMBER, PROFILE_PHOTHO, LOCATION, LANGUAGE) values (users_seq.NEXTVAL, 'DRIVER', 'CC', 1385760775, 'Marlo', 'Torre', '7468854470', 'http://dummyimage.com/226x162.jpg/cc0000/ffffff', 127, 'ESPA�OL');
COMMIT;

-- VEHICHLES 
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'ILQ717', 'RENAULT', 'CLIO', 2013, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'RBI963', 'RENAULT', 'SANDERO', 2016, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'XKL219', 'RENAULT', 'CLIO', 2014, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'LTT056', 'RENAULT', 'LOGAN', 2015, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'IFI347', 'RENAULT', 'CLIO', 2012, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'BFM201', 'RENAULT', 'MEGANE', 2017, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'HRG328', 'RENAULT', 'CLIO', 2015, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'IMA242', 'RENAULT', 'LOGAN', 2014, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'IVV362', 'RENAULT', 'CLIO', 2013, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'EEK594', 'RENAULT', 'MEGANE', 2014, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'GZE444', 'RENAULT', 'CLIO', 2018, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'FJT544', 'RENAULT', 'MEGANE', 2014, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'LGY125', 'RENAULT', 'SANDERO', 2016, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'LEF230', 'RENAULT', 'SANDERO', 2016, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'VXA273', 'RENAULT', 'CLIO', 2018, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'PCZ251', 'RENAULT', 'MEGANE', 2014, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'NRD029', 'RENAULT', 'MEGANE', 2012, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'WDS357', 'RENAULT', 'MEGANE', 2017, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'ZYP390', 'RENAULT', 'SANDERO', 2017, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'IOH887', 'RENAULT', 'LOGAN', 2013, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'QWD615', 'RENAULT', 'KOLEOS', 2013, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'RAQ647', 'RENAULT', 'KOLEOS', 2014, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'WRK369', 'RENAULT', 'KOLEOS', 2014, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'CSN035', 'RENAULT', 'DUSTER', 2016, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'UBM848', 'RENAULT', 'DUSTER', 2012, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'PAB569', 'RENAULT', 'KOLEOS', 2016, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'DTN070', 'RENAULT', 'DUSTER', 2014, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'GVS201', 'RENAULT', 'KOLEOS', 2018, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'PXJ830', 'RENAULT', 'KOLEOS', 2014, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'ONQ510', 'RENAULT', 'KOLEOS', 2016, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'RIH905', 'RENAULT', 'KOLEOS', 2013, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'QBS858', 'RENAULT', 'KOLEOS', 2018, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'NFA090', 'RENAULT', 'KOLEOS', 2016, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'JMX422', 'RENAULT', 'KOLEOS', 2016, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'QWP004', 'RENAULT', 'DUSTER', 2014, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'DVF591', 'RENAULT', 'DUSTER', 2016, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'XKP934', 'RENAULT', 'DUSTER', 2013, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'BXT612', 'RENAULT', 'DUSTER', 2014, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'PZS512', 'RENAULT', 'KOLEOS', 2013, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'NFI198', 'RENAULT', 'KOLEOS', 2017, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'KBR350', 'AUDI', 'Q7', 2016, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'RAW248', 'AUDI', 'A3', 2018, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'UXB061', 'AUDI', 'A5', 2015, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'VRF373', 'AUDI', 'Q5', 2016, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'CRM222', 'AUDI', 'A6', 2016, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'VSQ654', 'AUDI', 'Q7', 2017, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'ZJT463', 'AUDI', 'A5', 2012, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'RMG864', 'AUDI', 'Q3', 2012, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'YJS471', 'AUDI', 'Q5', 2018, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'IZM545', 'AUDI', 'A4', 2016, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'FHT011', 'AUDI', 'Q5', 2017, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'OBB027', 'AUDI', 'A3', 2014, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'DZE133', 'AUDI', 'A3', 2018, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'USH628', 'AUDI', 'Q5', 2013, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'WNS481', 'AUDI', 'A6', 2012, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'FVX580', 'AUDI', 'A3', 2015, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'FYY364', 'AUDI', 'A3', 2018, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'LVY628', 'AUDI', 'A5', 2018, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'PVG008', 'AUDI', 'A3', 2013, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'EYQ831', 'AUDI', 'A3', 2016, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'NAR157', 'AUDI', 'A6', 2016, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'GZG731', 'AUDI', 'Q5', 2015, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'UZL189', 'AUDI', 'S6', 2018, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'BHA530', 'AUDI', 'A4', 2013, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'VTJ509', 'AUDI', 'A4', 2018, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'LNK119', 'AUDI', 'Q3', 2013, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'MRF331', 'AUDI', 'A5', 2016, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'LWW929', 'AUDI', 'A4', 2015, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'UHL710', 'AUDI', 'A4', 2017, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'VNR491', 'AUDI', 'Q7', 2018, 'UBER BLACK');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'XMA056', 'CHEVROLET', 'TAVERA', 2005, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'IOA803', 'CHEVROLET', 'CORSA WAGON', 2007, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'XXV663', 'CHEVROLET', 'LTZ', 2012, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'VXL633', 'CHEVROLET', 'EPICA', 2008, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'ZTN884', 'CHEVROLET', 'AVEO', 2012, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'CAX346', 'CHEVROLET', 'VOLT', 2007, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'BOH854', 'CHEVROLET', 'SAIL U-VA', 2005, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'DCA419', 'CHEVROLET', 'BLAZER', 2006, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'MKV074', 'CHEVROLET', 'CLASSIC', 2011, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'NWQ918', 'CHEVROLET', 'SPIN', 2009, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'QDP437', 'CHEVROLET', 'CLASSIC', 2010, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'FIF099', 'CHEVROLET', 'CORSA WAGON', 2011, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'ODB238', 'CHEVROLET', 'SS', 2005, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'NJH199', 'CHEVROLET', 'NIVA', 2008, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'KLZ180', 'CHEVROLET', 'ORLANDO', 2009, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'MMG203', 'CHEVROLET', 'SPARK', 2007, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'ZRN766', 'CHEVROLET', 'SS', 2007, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'CJQ302', 'CHEVROLET', 'CORVETTE', 2012, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'XSP783', 'CHEVROLET', 'TACUMA', 2009, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'GHX368', 'CHEVROLET', 'TRAX', 2011, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'QUZ165', 'CHEVROLET', 'SPIN', 2006, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'ONB269', 'CHEVROLET', 'CHEVY', 2011, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'DZU568', 'CHEVROLET', 'CAPTIVA', 2006, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'ZXD602', 'CHEVROLET', 'TRAVERSE', 2008, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'KVB153', 'CHEVROLET', 'VOLT', 2010, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'XXU488', 'CHEVROLET', 'AVEO', 2011, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'HWW403', 'CHEVROLET', 'DMAX', 2004, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'SIY822', 'CHEVROLET', 'SPIN', 2008, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'GFL627', 'CHEVROLET', 'EPICA', 2010, 'UBERX');
insert into VEHICHLES (ID, VEHICHLE_PLATE, BRAND, MODEL, YEAR, SERVICE) values (vehichles_seq.NEXTVAL, 'DCM125', 'CHEVROLET', 'CORSA WAGON', 2005, 'UBERX');



