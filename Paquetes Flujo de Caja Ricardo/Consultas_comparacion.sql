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




      SELECT '2012' ANO, trfcmese MES, TFCONFLCJ cdconcep, trfcfltr TIPOFLU,
               SUM(TRFCPS1M + TRFCPS2M + TRFCPS3M + TRFCPS4M + TRFCRVCA) VALOR, 
               'COP' MONEDA, to_date(SYSDATE - trfcmese,'YYYY-MM-DD') FECHA_DOC
        FROM TEREFLCJ_sap, tiflconc, TIPMOVFLCJA
        WHERE TRFCANOE = 2010
          AND TRFCMESE = 12
          AND TRFCCONC = TFCONCPTO
          AND TFCONFLCJ = TMFCCDGO
          AND TFCONCPTO = TRFCCONC  
        GROUP BY TRFCANOE, TRFCMESE, TFCONFLCJ, TRFCFLTR
        HAVING SUM(TRFCPS1M + TRFCPS2M + TRFCPS3M + TRFCPS4M + TRFCRVCA) > 0;
        







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

SELECT NVL(SUM(nvl(valor,0)),0) 
  FROM ctabflcj_sap
 WHERE ano = 2012
   AND mes = 11;

SELECT NVL(SUM(NVL(valor,0)),0) 
  FROM ctabflcj
 WHERE ano = 2012
   AND mes = 11;


-- diferencia (Mirar porque estos valores no son iguales)
SELECT (SELECT NVL(SUM(nvl(valor,0)),0) 
          FROM ctabflcj_sap
         WHERE ano = 2012
           AND mes = 11) - 
       (SELECT NVL(SUM(NVL(valor,0)),0) 
          FROM ctabflcj
         WHERE ano = 2012
           AND mes = 11) 
FROM dual;



--<<
-- Revisar el valor real
-- Revisar el procedimiento:
--            proconsvalrealingcarg (inreflcj_sap - valor)
--            proconsvalrealingtipmov (ctabflcj_sap)
-->>


SELECT SUM(valor) FROM inreflcj_sap
 WHERE ano = 2012
   AND mes = 11;

SELECT SUM(valor) FROM inreflcj
 WHERE ano = 2012
   AND mes = 11;

-- En este parte se ve que no existen diferencias y los valores reales son iguales
SELECT (SELECT SUM(valor) 
          FROM inreflcj_sap
         WHERE ano = 2012
           AND mes = 11) - 
       (SELECT SUM(valor) 
          FROM inreflcj
         WHERE ano = 2012
           AND mes = 11) 
FROM dual;


SELECT NVL(SUM(NVL(valor,0)),0)
  FROM ctabflcj_sap
 WHERE ano = 2012
   AND mes = 11;
   

SELECT NVL(SUM(NVL(valor,0)),0) 
  FROM ctabflcj
 WHERE ano = 2012
   AND mes = 11;

-- Existe diferencia entre estos dos valores
SELECT (SELECT NVL(SUM(NVL(valor,0)),0)
          FROM ctabflcj_sap
         WHERE ano = 2012
           AND mes = 11) - 
       (SELECT NVL(SUM(NVL(valor,0)),0) 
          FROM ctabflcj
         WHERE ano = 2012
           AND mes = 11) 
FROM dual;

--<<
-- Revisar Valores Proyectados
-- Revisar el procedimiento:
--            progeningreflcj (tereflcj_sap)
-->>


SELECT SUM(t.trfcdiapm) DIA, 
       SUM(t.trfcrvca) ValorRealCargo,
       SUM(t.trfcrvtm) ValorRealTipoMov
FROM tereflcj_sap t
 WHERE trfcanoe = 2012 
   AND trfcmese = 11;
   

SELECT SUM(NVL(trfcps1m, 0)) sem1, 
       SUM(NVL(trfcps2m, 0)) sem2,
       SUM(NVL(trfcps3m, 0)) sem3, 
       SUM(NVL(trfcps4m, 0)) sem4,
       SUM(NVL(trfcps1m, 0)) + SUM(NVL(trfcps2m, 0)) + SUM(NVL(trfcps3m, 0)) + SUM(NVL(trfcps4m, 0)) Total_Semanas,
       SUM(NVL(trfcrvca, 0)) ValorRealCargo,
       SUM(NVL(trfcrvtm, 0)) ValorRealTipoMov
  FROM tereflcj t
 WHERE trfcanoe = 2012 
   AND trfcmese = 11;


-- Total de dias Proyectados al mes
-- revisar la diferencia existente
-- e identificar que se esta haciendo mal 

SELECT (SELECT SUM(t.trfcdiapm)
          FROM tereflcj_sap t
         WHERE trfcanoe = 2012 
           AND trfcmese = 11) 
       - 
       (SELECT SUM(NVL(trfcps1m, 0)) + SUM(NVL(trfcps2m, 0)) + SUM(NVL(trfcps3m, 0)) + SUM(NVL(trfcps4m, 0))
          FROM tereflcj t
         WHERE trfcanoe = 2012 
           AND trfcmese = 11) 
FROM dual;

-- Calcular la diferencia del Valor Real por Cargo 
-- revisar la diferencia existente
-- e identificar que se esta haciendo mal 
SELECT (SELECT SUM(t.trfcrvca) 
          FROM tereflcj_sap t
         WHERE trfcanoe = 2012 
           AND trfcmese = 11)
       -
       (SELECT SUM(NVL(trfcrvca, 0))
          FROM tereflcj t
         WHERE trfcanoe = 2012 
           AND trfcmese = 11)
FROM dual;

-- Procedimiento que afecta la tabla tereflcj_sap

--<<
-- procarginreal
-->>

SELECT COUNT(*)Cantidad_registros, SUM(valor) Valor
  FROM (SELECT depa,loca,ano,mes,grupo,concep,nvl(SUM(valor),0) valor, dia
          FROM inreflcj_sap
         WHERE ano = 2012
           AND mes = 11
           AND func = -1
         GROUP BY depa,loca,ano,mes,grupo,concep, dia);


SELECT COUNT(*)Cantidad_registros, SUM(valor) Valor
  FROM (SELECT depa,loca,ano,mes,grupo,concep,nvl(SUM(valor),0) valor, dia
          FROM inreflcj_sap
         WHERE ano = 2012
           AND mes = 11
           AND func = -1
         GROUP BY depa,loca,ano,mes,grupo,concep, dia);


SELECT COUNT(*)Cantidad_registros, SUM(valor) Valor
  FROM (SELECT depa,loca,ano,mes,grupo,concep,nvl(SUM(valor),0) valor
          FROM inreflcj_sap
         WHERE ano = 2012
           AND mes = 11
           AND func = -1
         GROUP BY depa,loca,ano,mes,grupo,concep);

-- Diferencia entre valores
SELECT (SELECT SUM(valor) 
  FROM (SELECT depa,loca,ano,mes,grupo,concep,nvl(SUM(valor),0) valor, dia
          FROM inreflcj_sap
         WHERE ano = 2012
           AND mes = 11
           AND func = -1
         GROUP BY depa,loca,ano,mes,grupo,concep, dia)) 
       - 
       (SELECT SUM(valor) 
  FROM (SELECT depa,loca,ano,mes,grupo,concep,nvl(SUM(valor),0) valor
          FROM inreflcj_sap
         WHERE ano = 2012
           AND mes = 11
           AND func = -1
         GROUP BY depa,loca,ano,mes,grupo,concep)) 
FROM dual;    


SELECT * FROM ldc_flujocaja;

--<<
-- procarginrealtipmov
-->>

  SELECT depa,loca,ano,mes,grupo,tipmov,tipo,nvl(sum(valor),0) nuvalor
      FROM ctabflcj
     WHERE ano = 2012
       AND mes = 11
       --AND to_char(dia, 'DD/MM/YYYY') = to_char(dtdiafech, 'DD/MM/YYYY')
       AND func = -1
  GROUP BY depa,loca,ano,mes,grupo,tipmov,tipo;
  
  
  SELECT depa,loca,ano,mes,grupo,tipmov,tipo,nvl(sum(valor),0) nuvalor, dia dia
      FROM ctabflcj_sap
     WHERE ano = 2012
       AND mes = 11
       AND func = -1
  GROUP BY depa,loca,ano,mes,grupo,tipmov,tipo, dia;


-- diferencia

SELECT (SELECT nvl(sum(nvl(valor,0)),0) 
          FROM ctabflcj
         WHERE ano = 2012
           AND mes = 11
           AND func = -1
         GROUP BY depa,loca,ano,mes,grupo,tipmov,tipo)
       -
       (SELECT nvl(sum(nvl(valor,0)),0) 
          FROM ctabflcj_sap
         WHERE ano = 2012
           AND mes = 11
           AND func = -1
         GROUP BY depa,loca,ano,mes,grupo,tipmov,tipo, dia)
 FROM dual;

--<<
-- progeningreflcj
-->>

SELECT COUNT(*) FROM tereflcj_sap
 WHERE trfcanoe = 2012 
   AND trfcmese  = 11
   AND trfcdiapm > 0;

SELECT COUNT(*) FROM tereflcj
 WHERE trfcanoe = 2012 
   AND trfcmese  = 11
   AND trfcps1m + trfcps2m + trfcps3m + trfcps4m > 0;




SELECT count(*) cantidad, sum(suma) suma, SUM(care) care, sum(suma)-SUM(care) diferencia  
  FROM (SELECT trfcdepa depa,trfcloca loca,trfcgrup grup,
           SUM(trfcps1m)+SUM(trfcps2m)+SUM(trfcps3m)+SUM(trfcps4m) suma,
           SUM(trfcrvca) care,SUM(trfcrvtm) tm 
          FROM tereflcj 
         WHERE trfcanoe = 2012 
           AND trfcmese = 11 
           AND trfcfltr = 'I' 
           AND trfctipo IN('C','I') 
           AND trfcfunc = -1 
         GROUP BY trfcdepa,trfcloca,trfcgrup);


SELECT count(*) cantidad, sum(suma) suma, SUM(care) care, sum(suma)-SUM(care) diferencia 
  FROM (SELECT trfcdepa depa,trfcloca loca,trfcgrup grup,
           SUM (trfcdiapm) suma,
           SUM (trfcrvca) care,
           SUM (trfcrvtm) tm, 
           to_char(trfcdiae, 'DD/MM/YYYY') dia 
           FROM tereflcj_sap 
          WHERE trfcanoe = 2012 
            AND trfcmese = 11 
            AND trfcfltr = 'I' 
            AND trfctipo IN('C','I') 
            AND trfcfunc = -1 
          GROUP BY trfcdepa,trfcloca,trfcgrup, to_char(trfcdiae, 'DD/MM/YYYY'));



SELECT * FROM tereflcj_sap;

SELECT * FROM tereflcj;

pkflujocaja
