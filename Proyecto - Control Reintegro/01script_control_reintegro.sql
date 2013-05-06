DECLARE
 
 NURET   NUMBER;
  
BEGIN

  pkinterfaz.rgCuenTiDo.cutdtido := 70;  

  --<<
  --ejecuta el procesamiento de la informacion.    
  -->>
  NURET := LDC_PKINTERFAZSURTI.FNUCONTROLREINTEGRO(TO_DATE('19/09/2012','DD/MM/YYYY'),TO_DATE('19/09/2012','DD/MM/YYYY'));
  
END;
