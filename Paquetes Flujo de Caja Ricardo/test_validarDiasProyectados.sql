--<<
-- Validar que los dias proyectados tengan la misma valores que las semanas proyectadas
-- Los dias son los dias del mes y las semanas son 4 por meses
-->>

DECLARE

  porcdiam1           NUMBER := 0;
  TotalPorDias        NUMBER := 0;
  
  
  porcs1m1            NUMBER := 0;
  porcs2m1            NUMBER := 0;
  porcs3m1            NUMBER := 0;
  porcs4m1            NUMBER := 0;
  
  TatalPorSemanas     NUMBER := 0;       
  
BEGIN 
  
  FOR i IN 1..30 LOOP
    
     SELECT NVL(reprdiapm,0)/100 INTO porcdiam1
       FROM recaproy_sap
      WHERE repranoe = 2012
        AND reprmese = 11
        AND to_char(reprdiae, 'DD') = i
        AND reprfunc = -1;  
        
     TotalPorDias := TotalPorDias + porcdiam1;   
    --dbms_output.put_line(i||'. '|| porcdiam1);
  END LOOP; 

  SELECT NVL(reprs1m1,0)/100,NVL(reprs2m1,0)/100,NVL(reprs3m1,0)/100,NVL(reprs4m1,0)/100 INTO porcs1m1,porcs2m1,porcs3m1,porcs4m1
    FROM recaproy
   WHERE repranoe = 2012
     AND reprmese = 11
     AND reprfunc = -1;
     
    TatalPorSemanas := porcs1m1 + porcs2m1 + porcs3m1 + porcs4m1;
    
    dbms_output.put_line('Tatal por dias:  '|| TotalPorDias ||'  Tatal por semanas:  ' ||TatalPorSemanas);  
  
END; 
