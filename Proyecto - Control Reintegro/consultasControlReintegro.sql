SELECT * from parametr p 
 where paracodi = 'TIPOMOVCONSIGOLI';
 
SELECT * from asiento_sap a
 where asietimv = 527
   AND asiedebi > 0
   ORDER BY asiefech DESC; 
   
   
SELECT * FROM parametr
WHERE paracodi = 'GENDOCU_ENVIA_SAP';


UPDATE asiento_sap a
SET a.docenvio_sap = NULL
WHERE a.docenvio_sap = 61110;

UPDATE parametr
SET paravast = '21000643'
WHERE paracodi = 'COD_RECA_OLIM_OI';


SELECT * FROM parametr
WHERE paracodi = 'GENDOCU_ENVIA_SAP';