SELECT * FROM asiento_sap a
 WHERE /*a.asiedist = 1
   AND a.asietimv = 313
   AND*/ a.asiecons = 380752
   AND a.asiecons IN (471842, 471844);

--<<
-- Mirar si los datos estan llegando a sap
-->>
SELECT * FROM ldc_mesaenvws m
 where m.mesaextid IN (60062,60067); 
   
--<<
-- Tabla donde esta el encabezado del documento que se envia a sap
-->> 
SELECT * FROM ldc_encaintesap e
 WHERE e.cod_interfazldc = 61467; 


--<<
-- Tabla donde esta el detalle del documento que se envia a sap
-->> 
SELECT * FROM ldc_detaintesap e
 WHERE e.cod_interfazldc IN (60062,60067);    
 
 
 SELECT * FROM ldc_detaintesap d, ldc_encaintesap e, asiento_sap a
  WHERE d.cod_interfazldc = e.cod_interfazldc
    AND d.num_documentosap = e.num_documentosap
    AND d.ordenint = a.asienit;
    
    
  SELECT *FROM ldc_detaintesap d, asiento_sap a
  WHERE d.ordenint = a.asienit;                                       

SELECT * FROM asiento_sap a
 WHERE a.asietimv = 313
   AND to_char(a.asiefech, 'DD/MM/YYYY') = '12/12/2012';


UPDATE asiento_sap 
SET docenvio_sap = NULL
WHERE docenvio_sap IN (61838, 61839);

SELECT * FROM asiento_sap
WHERE docenvio_sap IN (61838, 61839);


SELECT * FROM ldc_detaintesap d
WHERE d.cod_interfazldc IN (61838, 61839);

SELECT * FROM ldc_encaintesap e
WHERE e.cod_interfazldc IN (61838, 61839);

SELECT * FROM ldc_detaintesap d
WHERE d.cod_interfazldc IN (61835, 61833);

SELECT * FROM ldc_encaintesap e
WHERE e.cod_interfazldc IN (61838, 61839);



SELECT substr('Jose-Ricardo-Gallego','-Gallego') FROM dual;

SELECT REPLACE('PEPE PEREZ','PEREZ','') FROM DUAL; 


-- Consulta para definir que interfaz tomar
-- se tomara 10494

SELECT * 
  FROM ldc_encaintesap e, asiento_sap a
 WHERE e.cod_interfazldc = a.docenvio_sap
   AND a.asietimv = 313;

 
SELECT * 
  FROM asiento_sap a
 WHERE a.asietimv = 313
   AND to_char(a.asiefech, 'DD/MM/YYYY') = '19/04/2012'; 
   
 
UPDATE asiento_sap a
   SET a.docenvio_sap = NULL
 WHERE a.asietimv = 313
   AND to_char(a.asiefech, 'DD/MM/YYYY') = '19/04/2012'; 
 
 
 
 
 SELECT d.cod_interfazldc, d.txtposcn 
  FROM ldc_detaintesap d
 WHERE d.cod_interfazldc IN (SELECT a.docenvio_sap 
                              FROM asiento_sap a
                             WHERE a.asietimv = 313
                               AND to_char(a.asiefech, 'DD/MM/YYYY') = '19/04/2012')
 ORDER BY 1;
 
SELECT e.cod_interfazldc, e.txtcabec
  FROM ldc_encaintesap e
 WHERE e.cod_interfazldc IN (SELECT a.docenvio_sap 
                               FROM asiento_sap a
                              WHERE a.asietimv = 313
                                AND to_char(a.asiefech, 'DD/MM/YYYY') = '19/04/2012')
  ORDER BY 1;
 
 SELECT a.docenvio_sap, a.asiecons 
  FROM asiento_sap a
 WHERE a.asietimv = 313
   AND to_char(a.asiefech, 'DD/MM/YYYY') = '19/04/2012'
  ORDER BY 1;
 
SELECT * 
  FROM ldc_detaintesap d
 WHERE d.cod_interfazldc = 61469;
 
SELECT * 
  FROM ldc_encaintesap e
 WHERE e.cod_interfazldc = 61469;

 
 
-- ya da�e esta parte
 
SELECT * 
  FROM asiento_sap a
 WHERE a.docenvio_sap = 61469; 
 
SELECT * 
  FROM asiento_sap a
 WHERE a.asiecons = 380754;  
 
 SELECT * 
  FROM asiento_sap a
 WHERE a.asiecons = 380754;
 
 
UPDATE asiento_sap a
   SET a.docenvio_sap = NULL
 WHERE a.docenvio_sap = 61467;

 
SELECT * 
  FROM ldc_mesaenvws m
 WHERE m.mesaextid = 61467;
 
 
 
 
 
 
 
  
