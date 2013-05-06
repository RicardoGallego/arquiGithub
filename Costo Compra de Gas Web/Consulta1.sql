-- SELECT * FROM GAS.LDC_ENVDOCSAP WHERE ENDOCLAS='LF' ORDER BY ENDOFEEN DESC ;

SELECT DISTINCT(endoclas) FROM GAS.LDC_ENVDOCSAP 
 WHERE ENDOCLAS LIKE '%L%' 
 AND endoano = 2012
 AND endomes = 10;
 
 
 SELECT d.ROWID, d.cod_interfazldc, d.impomtrx, d.clavref3, d.* 
   FROM GAS.LDC_DETAINTESAP d 
  WHERE cod_interfazldc IN (SELECT endonume FROM GAS.LDC_ENVDOCSAP 
                             WHERE ENDOCLAS='LF' 
                               AND endoano = 2012
                               AND endomes = 10)
    AND clavcont = 31
    /*OR clavcont = 50*/;      
    
    
    SELECT d.*, d.ROWID FROM GAS.LDC_DETAINTESAP d WHERE cod_interfazldc= 39151; 
                        
