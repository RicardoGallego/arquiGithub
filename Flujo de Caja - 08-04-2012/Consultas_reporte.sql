
SELECT SUM(t.trfcdiapm) DIA, 
       SUM(t.trfcrvca) ValorRealCargo,
       SUM(t.trfcrvtm) ValorRealTipoMov
FROM TEREFLCJ_SAP t
 WHERE trfcanoe = 2012 
   AND trfcmese = 11;

   
SELECT SUM(t.trfcdiapm) DiaProyectado, 
       SUM(t.trfcrvca) ValorRealCargo, 
       SUM(t.trfcrvtm) ValorRealTipoMov, 
       t.trfcdiae Dia
  FROM TEREFLCJ_SAP t
 WHERE t.trfcanoe = 2012 
   AND t.trfcmese = 11
 GROUP BY t.trfcdiae 
 ORDER BY t.trfcdiae;
 
 
SELECT SUM(t.trfcdiapm) DiaProyectado, 
       SUM(t.trfcrvca) ValorRealCargo,
       SUM(t.trfcdiapm)+SUM(t.trfcrvca) Total,
       t.trfcdiae Dia
  FROM TEREFLCJ_SAP t
 WHERE t.trfcanoe = 2012 
   AND t.trfcmese = 11
 GROUP BY t.trfcdiae 
 ORDER BY t.trfcdiae;
 
SELECT SUM(t.trfcdiapm)+SUM(t.trfcrvca) Total,
       t.trfcdiae Dia
  FROM TEREFLCJ_SAP t
 WHERE t.trfcanoe = 2012 
   AND t.trfcmese = 11
 GROUP BY t.trfcdiae 
-- ORDER BY t.trfcdiae
UNION ALL
 SELECT SUM(t.trfcdiapm)+SUM(t.trfcrvca) Total,
       t.trfcdiae Dia
  FROM TEREFLCJ_SAP t
 WHERE t.trfcanoe = 2012 
   AND t.trfcmese = 12
 GROUP BY t.trfcdiae 
 ORDER BY t.trfcdiae;
 
 
 
 
 
 SELECT * FROM (
    (SELECT SUM(t.trfcdiapm) DiaProyectado, 
           SUM(t.trfcrvca) ValorRealCargo, 
           SUM(t.trfcrvtm) ValorRealTipoMov, 
           t.trfcdiae Dia
      FROM TEREFLCJ_SAP t
     WHERE t.trfcanoe = 2012 
       AND t.trfcmese = 11
     GROUP BY t.trfcdiae)  
    -- ORDER BY t.trfcdiae
     UNION ALL
     (SELECT SUM(t.trfcdiapm) DiaProyectado, 
           SUM(t.trfcrvca) ValorRealCargo, 
           SUM(t.trfcrvtm) ValorRealTipoMov, 
           t.trfcdiae Dia
      FROM TEREFLCJ_SAP t
     WHERE t.trfcanoe = 2012 
       AND t.trfcmese = 12
     GROUP BY t.trfcdiae) ) x
     ORDER BY x.Dia
-- ORDER BY t.trfcdiae
 
 
SELECT SUM(t.trfcdiapm) DiaProyectado, 
       SUM(t.trfcrvca) ValorRealCargo, 
       SUM(t.trfcdiapm)+SUM(t.trfcrvca) Total,
       t.trfcdiae Dia
  FROM TEREFLCJ_SAP t
 WHERE t.trfcanoe = 2012 
   AND t.trfcmese = 11
 GROUP BY t.trfcdiae 
 ORDER BY t.trfcdiae;
 
