/*
  En la tabla ldc_encaintesap(Encabezado de la Interfaz Contable de SAP) en el campo txtcabec en el campo txtcabec 
  (Texto Cabecera) concatenarle un guion (-) y la informacion que ahi en asiecons (Consecutivo del tipo de movimiento)
  de la tabla asiento_sap (asientos de diario).
  
  en la linea 2676: -> ldc_pkinterfazsurti.vaGENDOCU_ENVIA_SAP = 'A' <- se asigno la 'A' para que le infomacion no se 
  envie a SAP
  
  mirar las lineas 501, 561 y 1115   
  
  estos son documentos que se envian y se parten en varios registros de un tamaño maximo 
*/

select CLAVCONT, CLASECTA, INDICCME, INDICIVA, CONDPAGO, FECHBASE, REFFACTR, BASEIMPT,
          CENTROCO, ORDENINT, CANTIDAD, ASIGNACN, TXTPOSCN, CENTROBE, SEGMENTO, OBJCOSTO,
          CLAVREF1, CLAVREF2, CLAVREF3, SOCIEDGL, MATERIAL, TIPORETC, INDRETEC, BASERETC,
          COD_CENTROBENEF, COD_GRUPOCONCE, COD_CAUSACARGO, FECHVALOR, CTADIV, ICLIFECH, 
          ICLIFECR, sum(IMPOMTRX) IMPOMTRX, sum(IMPOMSOC) IMPOMSOC
     from LDC_INCOLIQU
    WHERE ICLINUDO = 7804--nuICLINUDO
      AND a.docenvio_sap = iclinudo
  group by CLAVCONT, CLASECTA, INDICCME, INDICIVA, CONDPAGO, FECHBASE, REFFACTR, BASEIMPT,
          CENTROCO, ORDENINT, CANTIDAD, ASIGNACN, TXTPOSCN||'-'||a.asiecons, CENTROBE, SEGMENTO, OBJCOSTO,
          CLAVREF1, CLAVREF2, CLAVREF3, SOCIEDGL, MATERIAL, TIPORETC, INDRETEC, BASERETC,
          COD_CENTROBENEF, COD_GRUPOCONCE, COD_CAUSACARGO, FECHVALOR, CTADIV, ICLIFECH, 
          ICLIFECR
    order by COD_CENTROBENEF, COD_GRUPOCONCE, COD_CAUSACARGO;
    
    
    
    
    SELECT a.asiecons FROM asiento_sap a;
    
    SELECT * FROM ldc_encaintesap e
     WHERE e.cod_interfazldc = 103;
     
    
    SELECT * FROM ldc_detaintesap d
     WHERE d.cod_interfazldc = 103; 
    
    SELECT * FROM LDC_INCOLIQU i
     WHERE i.iclinudo = 103;
    
    
    SELECT * FROM asiento_sap a, ldc_incoliqu i 
     WHERE a.docenvio_sap = i.iclinudo 
       AND a.asietimv NOT IN (103);
    
      
    
    
    
    
    
    
