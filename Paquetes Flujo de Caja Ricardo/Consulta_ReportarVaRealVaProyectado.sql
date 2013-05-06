--<<
-- Flcj_Ricardo 
-->>

SELECT SUM(t.trfcdiapm) DIA, 
       SUM(t.trfcrvca) ValorRealCargo,
       SUM(t.trfcrvtm) ValorRealTipoMov
FROM TEREFLCJ_SAP t
 WHERE trfcanoe = 2012 
   AND trfcmese = 11;
  
  
--<<
-- Flcj 
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


   
--<<
-- Valor Real
-->>
SELECT SUM(NVL(t.trfcrvca,0)+NVL(t.trfcrvtm,0))
  FROM TEREFLCJ_SAP t
 WHERE trfcanoe = 2012 
   AND trfcmese = 11;
   
--<<
-- Valor Proyectado
-->>
SELECT SUM(NVL(t.trfcdiapm,0)) 
 FROM TEREFLCJ_SAP t
WHERE trfcanoe = 2012 
  AND trfcmese = 12; 


--<<
-- Diferencia Flcj_Ricardo Flcj
-->>  
  
SELECT (SELECT SUM(t.trfcdiapm) 
          FROM TEREFLCJ_SAP t
         WHERE trfcanoe = 2012 
           AND trfcmese = 11) 
       - 
       (SELECT SUM(NVL(trfcps1m, 0)) + SUM(NVL(trfcps2m, 0)) + SUM(NVL(trfcps3m, 0)) + SUM(NVL(trfcps4m, 0))
          FROM TEREFLCJ t
         WHERE trfcanoe = 2012 
           AND trfcmese = 11) 
       DifernciaValorProyectado,
       
       (SELECT SUM(NVL(t.trfcrvca,0))
          FROM TEREFLCJ_SAP t
         WHERE trfcanoe = 2012 
           AND trfcmese = 11)
       -
       (SELECT SUM(NVL(trfcrvca, 0)) 
          FROM TEREFLCJ t
         WHERE trfcanoe = 2012 
           AND trfcmese = 11)
       DiferenciaVaRealCargo,
       
       (SELECT SUM(NVL(t.trfcrvtm,0))
          FROM TEREFLCJ_SAP t
         WHERE trfcanoe = 2012 
           AND trfcmese = 11)
       -
       (SELECT SUM(NVL(trfcrvtm, 0)) 
          FROM TEREFLCJ t
         WHERE trfcanoe = 2012 
           AND trfcmese = 11)
       DiferenciaVaRealTipMotivo,
       (SELECT SUM( NVL(t.trfcrvca,0)  + NVL(t.trfcrvtm,0))
          FROM TEREFLCJ_SAP t
         WHERE trfcanoe = 2012 
           AND trfcmese = 11)
       -
       (SELECT SUM((NVL(trfcrvca, 0)) + (NVL(trfcrvtm, 0))) 
          FROM TEREFLCJ t
         WHERE trfcanoe = 2012 
           AND trfcmese = 11)
       DiferenciaValorReal

FROM dual;



--<<
-- Select para el valor real
-->>

SELECT t.trfcdepa, t.trfcloca, t.trfcgrup, t.trfcconc, 
       t.trfcfltr, t.trfctipo, t.trfcdiae, t.trfcrvtm, 
       t.trfcrvca 
  FROM TEREFLCJ_SAP t
 WHERE trfcanoe = 2012 
   AND trfcmese = 11;
   

--<<
-- Select para el valor Proyectado
-->>

SELECT t.trfcdepa, t.trfcloca, t.trfcgrup, t.trfcconc, 
       t.trfcfltr, t.trfctipo, t.trfcdiae, t.trfcdiapm 
  FROM TEREFLCJ_SAP t
 WHERE trfcanoe = 2012 
   AND trfcmese = 11;
   
 
pkflujocaja
 
 
 
 
