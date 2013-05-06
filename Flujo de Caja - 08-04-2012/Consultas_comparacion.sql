--<<
-- Consultas para el mes de noviembre flujo de caja Ricardo
-->>


SELECT SUM(t.trfcdiapm) DIA, 
       SUM(t.trfcrvca) ValorRealCargo,
       SUM(t.trfcrvtm) ValorRealTipoMov
FROM TEREFLCJ_SAP t
 WHERE trfcanoe = 2012 
   AND trfcmese = 11;


SELECT SUM(i.valor) FROM inreflcj_sap i
 WHERE ano = 2012
   AND mes = 11;

SELECT SUM(valor) FROM ctabflcj_sap
 WHERE ano = 2012 
   AND mes = 11;
   
   
--<<
-- Consulta para el mes de noviembre flujo de caja
-->>   


SELECT SUM(NVL(trfcps1m, 0)) sem1, 
       SUM(NVL(trfcps2m, 0)) sem2,
       SUM(NVL(trfcps3m, 0)) sem3, 
       SUM(NVL(trfcps4m, 0)) sem4,
       SUM(NVL(trfcps1m, 0)) + SUM(NVL(trfcps2m, 0)) + SUM(NVL(trfcps3m, 0)) + SUM(NVL(trfcps4m, 0)) Total_Semanas,
       SUM(NVL(trfcrvca, 0)) ValorRealCargo,
       SUM(NVL(trfcrvtm, 0)) ValorRealTipoMov
  FROM TEREFLCJ t
 WHERE trfcanoe = 2012 
   AND trfcmese = 11;








SELECT SUM(valor) FROM inreflcj i
 WHERE ano = 2012
   AND mes = 11;

SELECT SUM(valor) FROM ctabflcj c
 WHERE ano = 2012 
   AND mes = 11;
   
   
   
   
   SELECT * FROM TEREFLCJ_SAP t;
   
   SELECT * FROM TEREFLCJ t;
   
   
   
--<<
-- 1. Comparacion factconc_sap Vs factconc
-->>


SELECT SUM(facovlor) FROM factconc_sap
 WHERE facoanoe = 2012
   AND facomese = 11;
   
SELECT SUM(facovlor) FROM factconc
 WHERE facoanoe = 2012
   AND facomese = 11;   
   
-- Diferencia
SELECT (SELECT SUM(facovlor) 
          FROM factconc
         WHERE facoanoe = 2012
           AND facomese = 11 ) -
       (SELECT SUM(facovlor) 
         FROM factconc_sap
         WHERE facoanoe = 2012
           AND facomese = 11) 
FROM dual;

--<<
-- 3. Comparacion recaproy_sap Vs recaproy
-->>

SELECT SUM(reprdiapm) 
  FROM recaproy_sap
 WHERE repranoe  = 2012
   AND reprmese = 11;

SELECT SUM(r.reprs1m1) sem1,  SUM(r.reprs2m1) sem2, SUM(r.reprs3m1) sem3, SUM(r.reprs4m1) sem4,
       SUM(r.reprs1m1) + SUM(r.reprs2m1) + SUM(r.reprs3m1) + SUM(r.reprs4m1)
  FROM recaproy r
 WHERE r.repranoe  = 2012
   AND r.reprmese = 11;
   
   
-- diferencia
SELECT (SELECT SUM(reprdiapm) 
          FROM recaproy_sap
         WHERE repranoe  = 2012
           AND reprmese = 11) - 
       (SELECT SUM(r.reprs1m1) + SUM(r.reprs2m1) + SUM(r.reprs3m1) + SUM(r.reprs4m1)
          FROM recaproy r
         WHERE r.repranoe  = 2012
           AND r.reprmese = 11) 
FROM dual;

-- Revisar la diferencia que existe entre movicuba_sap y movicuba
SELECT (SELECT nvl(sum(nvl(MVCBVLOR,0)),0) 
      FROM movicuba_sap
     WHERE mvcbtimv in (313,334,1069,994)
       AND to_char(mvcbfeapl, 'DD/MM/YYYY') >= '01/11/2012'
       AND to_char(mvcbfeapl, 'DD/MM/YYYY') <= '30/11/2012') - 
       (SELECT nvl(sum(nvl(MVCBVLOR,0)),0) 
      FROM movicuba
     WHERE mvcbtimv in (313,334,1069,994)
       AND to_char(mvcbfeapl, 'DD/MM/YYYY') >= '01/11/2012'
       AND to_char(mvcbfeapl, 'DD/MM/YYYY') <= '30/11/2012')FROM dual;


SELECT COUNT(*) cantidad, SUM(NVL(m.mvcbvlor,0)) valorTotal FROM movicuba_sap m
 WHERE mvcbtimv in (313,334,1069,994)
   AND to_char(mvcbfeapl, 'DD/MM/YYYY') >= '01/11/2012'
   AND to_char(mvcbfeapl, 'DD/MM/YYYY') <= '30/11/2012';
   
SELECT COUNT(*) cantidad, SUM(NVL(m.mvcbvlor,0)) valorTotal FROM movicuba m
 WHERE mvcbtimv in (313,334,1069,994)
   AND to_char(mvcbfeapl, 'DD/MM/YYYY') >= '01/11/2012'
   AND to_char(mvcbfeapl, 'DD/MM/YYYY') <= '30/11/2012';

SELECT * FROM movicuba;

SELECT * FROM ldc_flujocaja
WHERE ano = 2012
AND mes = 11;



--<<
-- 5. Comparacion inreflcj_sap Vs5. inreflcj 
-->>

SELECT SUM(NVL(valor,0)) FROM inreflcj_sap
 WHERE ano = 2012
   AND mes = 11; 

SELECT SUM(NVL(valor,0)) FROM inreflcj
 WHERE ano = 2012
   AND mes = 11; 


-- Diferencia
SELECT (SELECT SUM(NVL(valor,0)) 
          FROM inreflcj_sap
         WHERE ano = 2012
           AND mes = 11) - 
       (SELECT SUM(NVL(valor,0)) 
          FROM inreflcj
         WHERE ano = 2012
           AND mes = 11) 
FROM dual;


--<<
-- 7. Comparacion ctabflcj_sap Vs ctabflcj
-->>

SELECT SUM(nvl(valor,0)) 
  FROM ctabflcj_sap
 WHERE ano = 2012
   AND mes = 11;

SELECT sum(NVL(valor,0)) 
  FROM ctabflcj
 WHERE ano = 2012
   AND mes = 11;


-- diferencia (Mirar porque estos valores no son iguales)
SELECT (SELECT SUM(valor) 
          FROM ctabflcj_sap
         WHERE ano = 2012
           AND mes = 11) - 
       (SELECT sum(NVL(valor,0)) 
          FROM ctabflcj
         WHERE ano = 2012
           AND mes = 11) 
  FROM dual;

--
