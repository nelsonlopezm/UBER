CREATE OR REPLACE VIEW medios_pago_clientes AS
    SELECT
        u.id                      cliente,
        UPPER((u.name || ' ' || u.last_name)) nombre_cliente,
        upm.id                    medio_pago_id,
        pmt.name                  tipo,
        upm.payment_information   detalles_medio_pago,
        upm.business_account      empresarial,
        upm.company_name          nombre_empresa
    FROM
        users u,
        user_payment_methods upm,
        payment_methods_types pmt
    WHERE
        upm.user_id = u.id
        AND upm.payment_method_type = pmt.id
    ORDER BY 1;

   
CREATE OR REPLACE VIEW VIAJES_CLIENTES AS
SELECT
    t.pickup           fecha_viaje,
    (SELECT upper( (u.name || ' ' || u.last_name) ) nombre_cliente FROM users WHERE id = dv.user_id) nombre_conductor,
    v.vehichle_plate   placa_vehiculo,
    (SELECT upper((u.name || ' ' || u.last_name)) nombre_cliente FROM users WHERE id = t.user_id) nombre_cliente,
    t.trip_fare        valor_total,
    t.dinamic_fare     tarifa_dinamica,
    v.service          tipo_servicio,
    c.name             ciudad_viaje
FROM
    trips t,
    users u,
    cities c,
    driver_vehichles dv,
    vehichles v    
WHERE
    t.user_id = u.id
    AND t.driver_id = dv.id
    AND dv.vehichle_id = v.id
    AND u.location = c.id;

	
CREATE OR REPLACE PACKAGE Assigment_2 AS

-- Funcion que recibe dos parametros p_distance y p_city y devuelve la multiplicacion del parametro p_distance por el campo 
-- value_per_kilometer del la tabla cities, si no encuentra la ciudad retorna 0  
-- Assigment_2.distance_value (p_distance, p_city)
FUNCTION distance_value (
    p_distance   NUMBER,
    p_city       cities.name%TYPE
) RETURN NUMBER;


-- Funcion que recibe dos parametros p_minutes y p_city y devuelve la multiplicacion del parametro p_minutes por el campo 
-- value_per_minutes del la tabla cities, si no encuentra la ciudad retorna 0  
-- Assigment_2.time_value (p_minutes, p_city)
FUNCTION time_value (
    p_minutes   NUMBER,
    p_city       cities.name%TYPE
) RETURN NUMBER;

END Assigment_2;
/

CREATE OR REPLACE PACKAGE BODY Assigment_2 AS

-- Funcion que recibe dos parametros p_distance y p_city y devuelve la multiplicacion del parametro p_distance por el campo 
-- value_per_kilometer del la tabla cities, si no encuentra la ciudad retorna 0  
-- Assigment_2.distance_value (p_distance, p_city)
FUNCTION distance_value (
    p_distance   NUMBER,
    p_city       cities.name%TYPE
) RETURN NUMBER IS
    value_distance_city   NUMBER;
BEGIN    
    SELECT
        ROUND((value_per_kilometer * p_distance ),4)
    INTO value_distance_city
    FROM
        cities
    WHERE
        UPPER(name) = UPPER(p_city)
        AND ROWNUM < 2;    
    
    RETURN value_distance_city;
END distance_value;


-- Funcion que recibe dos parametros p_minutes y p_city y devuelve la multiplicacion del parametro p_minutes por el campo 
-- value_per_minutes del la tabla cities, si no encuentra la ciudad retorna 0  
-- Assigment_2.time_value (p_minutes, p_city)
FUNCTION time_value (
    p_minutes   NUMBER,
    p_city       cities.name%TYPE
) RETURN NUMBER IS
    value_distance_city   NUMBER;
BEGIN    
    SELECT
        ROUND((value_per_minute * p_minutes ),5)
    INTO value_distance_city
    FROM
        cities
    WHERE
        UPPER(name) = UPPER(p_city)
        AND ROWNUM < 2;    
    
    RETURN value_distance_city;
END time_value;

END Assigment_2;
/