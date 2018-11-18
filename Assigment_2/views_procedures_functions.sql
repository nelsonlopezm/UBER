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
        users u INNER JOIN user_payment_methods upm ON upm.user_id = u.id
        INNER JOIN payment_methods_types pmt ON upm.payment_method_type = pmt.id        
    ORDER BY u.id;

   
CREATE OR REPLACE VIEW viajes_clientes AS
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
    trips t INNER JOIN users u ON t.user_id = u.id
    INNER JOIN cities c ON AND t.city_id = c.id;
    INNER JOIN driver_vehichles dv ON t.driver_id = dv.id
    INNER JOIN vehichles v ON dv.vehichle_id = v.id;

	
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


-- Procedimiento que permite calcular el valor de un viaje, el cual recibe como parametro el id del viaje
-- Assigment_2.calcular_tarifa (p_id_viaje);
PROCEDURE calcular_tarifa (
    p_id_viaje IN INT
); 

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


-- Procedimiento que permite calcular el valor de un viaje, el cual recibe como parametro el id del viaje
-- EXECUTE Assigment_2.calcular_tarifa (p_id_viaje);

PROCEDURE calcular_tarifa (
    p_id_viaje IN INT
) AS

    estado_viaje      trips.trip_status%TYPE := NULL;
    ciudad_viaje      cities.name%TYPE := NULL;
    tarifa_base       cities.value_base_rate%TYPE := 0;
    tiempo_viaje      trips.trip_time%TYPE := 0;
    distancia         trips.trip_distance%TYPE := 0;
    detalles_viaje    NUMBER := 0;
    valor_tiempo      NUMBER := 0;
    valor_distancia   NUMBER := 0;
    valor_tarifa      NUMBER := 0;
BEGIN
    	SELECT DISTINCT
        t.trip_status,
        c.value_base_rate,
        t.trip_time,
        t.trip_distance,
        COALESCE(SUM(tc.concept_value) OVER(PARTITION BY tc.trip_id), NULL, 0),
        c.name
    INTO
        estado_viaje,
        tarifa_base,
        tiempo_viaje,
        distancia,
        detalles_viaje,
        ciudad_viaje
    FROM
        trips t
        INNER JOIN cities c ON t.city_id = c.id
        LEFT JOIN trip_concepts tc ON t.id = tc.trip_id 
    WHERE
        t.id = p_id_viaje;
        
    IF ( upper(estado_viaje) = upper('FINISHED') ) THEN -- Si el estafo de viaje es FINISHED procede a actualizar el valor de la tarifa
        valor_tarifa := 0;
        valor_tiempo := assigment_2.time_value(tiempo_viaje,ciudad_viaje);
        valor_distancia := assigment_2.distance_value(distancia,ciudad_viaje);
        valor_tarifa := tarifa_base + valor_tiempo + valor_distancia + detalles_viaje;
        UPDATE trips t
        SET
            t.trip_fare = valor_tarifa
        WHERE
            t.id = p_id_viaje;
        COMMIT;
        dbms_output.put_line('Se actualiza la tarifa del viaje ' || p_id_viaje || 'por un valor de $' || valor_tarifa || ' correctamente');

    ELSE -- De otro modo si el estado es ACTIVE o CANCELED simplemente no actualiza dicho valor
        dbms_output.put_line('No es posible actualizar la tarifa del viaje');
    END IF;
    
END;

END Assigment_2;
/