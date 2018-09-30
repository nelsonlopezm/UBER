CREATE TABLE countries
( id INT NOT NULL,   
  code INT NOT NULL,  
  name VARCHAR2(255 CHAR) NOT NULL,  
  national_currency VARCHAR2(20 CHAR) DEFAULT 'USD' NOT NULL,
  CONSTRAINT countries_pk PRIMARY KEY (id)  
);

CREATE SEQUENCE countries_seq
START WITH 0
INCREMENT BY 1
NOCYCLE;

CREATE TABLE states
( id INT NOT NULL,   
  country_id INT NOT NULL,
  code INT,  
  name VARCHAR2(255 CHAR) NOT NULL,    
  CONSTRAINT states_pk PRIMARY KEY (id),
  CONSTRAINT fk_country_id FOREIGN KEY (country_id) REFERENCES countries(id)
);

CREATE SEQUENCE states_seq
START WITH 0
INCREMENT BY 1
NOCYCLE;

CREATE TABLE cities
( id INT NOT NULL,   
  state_id INT NOT NULL,
  code INT NOT NULL,  
  name VARCHAR2(255 CHAR) NOT NULL,    
  CONSTRAINT states_pk PRIMARY KEY (id),
  CONSTRAINT fk_country_id FOREIGN KEY (country_id) REFERENCES countries(id)
);

CREATE SEQUENCE cities_seq
START WITH 0
INCREMENT BY 1
NOCYCLE;

CREATE TABLE users
( id INT NOT NULL, 
  user_type VARCHAR2(50 CHAR) NOT NULL,  
  tributary_id_type VARCHAR2(10 CHAR) NOT NULL,
  tributary_id VARCHAR2(30 CHAR) NOT NULL,  
  name VARCHAR2(255 CHAR) NOT NULL,  
  last_name VARCHAR2(255 CHAR) NOT NULL,  
  phone_number INT NOT NULL, 
  profile_photho VARCHAR2(255 CHAR),  
  location INT NOT NULL,
  language VARCHAR2(50 CHAR) NOT NULL,    
  CONSTRAINT users_pk PRIMARY KEY (id),
  CONSTRAINT fk_location FOREIGN KEY (location) REFERENCES countries(id)
);

CREATE UNIQUE INDEX users_idx
  ON users (tributary_id);

CREATE SEQUENCE users_seq
START WITH 0
INCREMENT BY 1
NOCYCLE;

CREATE TABLE user_credit_cards
( id INT NOT NULL,   
  user_id INT NOT NULL,
  card_number INT NOT NULL,  
  security_code INT NOT NULL,  
  expiration_month INT NOT NULL,  
  expiration_year INT NOT NULL,  
  name VARCHAR2(255 CHAR) NOT NULL,    
  CONSTRAINT user_credit_cards_pk PRIMARY KEY (id),
  CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE SEQUENCE user_credit_cards_seq
START WITH 0
INCREMENT BY 1
NOCYCLE;


CREATE TABLE user_emails
( id INT NOT NULL,   
  user_id INT NOT NULL,    
  email VARCHAR2(255 CHAR) NOT NULL,   
  payment_option VARCHAR2(50 CHAR) NOT NULL,
  user_credit_card_id INT,  
  CONSTRAINT user_emails_pk PRIMARY KEY (id),
  CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_user_credit_card_id FOREIGN KEY (user_credit_card_id) REFERENCES user_credit_cards(id)
);

CREATE SEQUENCE user_emails_seq
START WITH 0
INCREMENT BY 1
NOCYCLE;


CREATE TABLE concepts
( id INT NOT NULL,     
  code VARCHAR2(20 CHAR) NOT NULL,
  name VARCHAR2(255 CHAR) NOT NULL,  
  type_concept_use VARCHAR2(255 CHAR) NOT NULL, -- INCEMENTO, DECREMENTO  
  type_concept_value VARCHAR2(255 CHAR) NOT NULL, -- PORCENTAJE, VALOR  
  value DOUBLE DEFAULT 0 NOT NULL,  
  description VARCHAR2(255 CHAR),  
  CONSTRAINT concepts_pk PRIMARY KEY (id)  
);

CREATE UNIQUE INDEX concepts_idx
  ON concepts (code);

CREATE SEQUENCE concepts_seq
START WITH 0
INCREMENT BY 1
NOCYCLE;


CREATE TABLE user_invite_codes
( id INT NOT NULL,   
  user_id INT NOT NULL,    
  invite_code VARCHAR2(20 CHAR) NOT NULL,    
  concept_id INT NOT NULL,    
  CONSTRAINT user_invite_codes_pk PRIMARY KEY (id),
  CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_concept_id FOREIGN KEY (concept_id) REFERENCES concepts(id)
);

CREATE UNIQUE INDEX user_invite_codes_idx
  ON user_invite_codes (invite_code);

CREATE SEQUENCE user_invite_codes_seq
START WITH 0
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
  CONSTRAINT fk_concept_id FOREIGN KEY (concept_id) REFERENCES concepts(id)
);

CREATE UNIQUE INDEX promotions_idx
  ON concepts (code);

CREATE SEQUENCE promotions_seq
START WITH 0
INCREMENT BY 1
NOCYCLE;

CREATE TABLE vehichles
( id INT NOT NULL,     
  vehichle_plate VARCHAR2(20 CHAR) NOT NULL,
  name VARCHAR2(255 CHAR) NOT NULL,  
  brand VARCHAR2(255 CHAR) NOT NULL,  
  model VARCHAR2(255 CHAR) NOT NULL,  
  year INT NOT NULL,  
  service VARCHAR2(255 CHAR) NOT NULL,  
  CONSTRAINT vehichles_pk PRIMARY KEY (id)  
);

CREATE UNIQUE INDEX vehichles_idx
  ON vehichles (vehichle_plate);

CREATE SEQUENCE vehichles_seq
START WITH 0
INCREMENT BY 1
NOCYCLE;


CREATE TABLE driver_vehiches
( id INT NOT NULL,   
  user_id INT NOT NULL,    
  vehichle_id INT NOT NULL,  
  CONSTRAINT driver_vehiches_pk PRIMARY KEY (id),
  CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_vehichle_id FOREIGN KEY (vehichle_id) REFERENCES vehichles(id)
);

CREATE SEQUENCE user_invite_codes_seq
START WITH 0
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
  credit_card_id INT NOT NULL,
  promotional_code_id INT NOT NULL,  
  fare DOUBLE DEFAULT 0, 
  status VARCHAR2(20 CHAR) DEFAULT 'ACTVE' NOT NULL, -- ACTIVE, FINISHED, CANCELED  
  CONSTRAINT trips_pk PRIMARY KEY (id),
  CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT fk_driver_id FOREIGN KEY (driver_id) REFERENCES driver_vehiches(id),
  CONSTRAINT fk_concept_id FOREIGN KEY (concept_id) REFERENCES concepts(id)
);

CREATE SEQUENCE trips_seq
START WITH 0
INCREMENT BY 1
NOCYCLE;

CREATE TABLE trip_concepts
( id INT NOT NULL,   
  trip_id INT NOT NULL,    
  concept_id INT NOT NULL,  
  CONSTRAINT trip_concepts_pk PRIMARY KEY (id),
  CONSTRAINT fk_trip_id FOREIGN KEY (trip_id) REFERENCES trips(id),
  CONSTRAINT fk_concept_id FOREIGN KEY (concept_id) REFERENCES concepts(id)
);

CREATE SEQUENCE trip_concepts_seq
START WITH 0
INCREMENT BY 1
NOCYCLE;

CREATE TABLE trip_coordinates
( id INT NOT NULL,   
  trip_id INT NOT NULL,
  date_time DATE NOT NULL,
  latitude DOUBLE NOT NULL,
  longitude DOUBLE NOT NULL,
  CONSTRAINT trip_coordinates_pk PRIMARY KEY (id),
  CONSTRAINT fk_trip_id FOREIGN KEY (trip_id) REFERENCES trips(id)  
);

CREATE SEQUENCE trip_coordinates_seq
START WITH 0
INCREMENT BY 1
NOCYCLE;


