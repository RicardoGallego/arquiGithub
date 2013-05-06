CREATE OR REPLACE PACKAGE ldc_pkinterfazsurti IS
/************************************************************************
   PROPIEDAD INTELECTUAL DE GASES DE OCCIDENTE S.A E.S.P
   FUNCION   : ldc_pkinterfazsurti
   AUTOR     : Hector Javier Cuervo Ramirez
   FECHA     : 25-03-2012
   DESCRIPCION  : 
  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  Jorgemg  17/08/2012   Se agrega la validacion del tipo de movimiento
                        para efectos de contabilizacion de las reversiones  
                        del control reintegro asociadas al tipo de movimiento
                        771.    

************************************************************************/

  --<<
  --Definicion de variables  paquete
  -->>  
  nuEncabezado               number := 0;
  nuDetalle                  number := 0;
  nuIncoliqu                 number := 0;
  nuComodin                  number := 0;
  vaComodin                  varchar2(4);
  nuSeqICLINUDO              LDC_INCOLIQU.ICLINUDO%TYPE;
  vaGRLEDGER                 varchar2(20);   --Campo Ledger de la interfaz
  vaCODINTINTERFAZ           varchar2(2);    --Codigo de interfaz
  vaSOCIEDAD                 varchar2(20);   --Campo Sociedad de la interfaz
  vaCURRENCY                 varchar2(20);   --Campo moneda de la interfaz
  vaMensError                varchar2(4000); --Variable para el manejo de errores
  Error                      EXCEPTION;      --Manejo de exception para el paquete
  vaCODDOCUINTCONREI         varchar2(2);  -- Codigo de la interfaz de control reintegro en SAP
  nuCODDOCCONREIGAS          number;       -- Codigo de la interfaz de control reintegro en GASPLUS
  nuTIPOMOVCONSIG            number;       -- Tipo de movimiento de clase consignacion
  nuTIPOMOVCONSIGOLI         number;       -- Tipo de movimiento de clase consignacion olimpica
  vaCEBE_GENERAL             varchar2(10);
  vaTIPORECACTRLREIN         varchar2(1);  -- Tipo de banco que representa a una entidad para control reintegro
  VAGENDOCU_ENVIA_SAP        VARCHAR2(1);  -- Parametro que indica cuando se debe enviar una interfaz
  vaCod_centrocosto          ldc_costcebecuen.cod_centrocosto%type; 
  vaCODINTINGRESOS           varchar2(2);  -- Codigo de la interfaz de ingresos L1
  nuCODDOCINGRESOS           number;       -- Codigo del tipo de documento de ingresos
  vaNitGenerico              varchar2(10); -- Nit generico
  nuAsiecons                 asiento_sap.asiecons%TYPE:='';
  
  FUNCTION fnuSeq_ldc_incoliqu
  RETURN number;

  FUNCTION fnuINSELDC_INCOLIQU
  RETURN number;
  
  FUNCTION fnuGeneLDC_ENCAINTESAP(nuCOD_INTERFAZLDC   in LDC_ENCAINTESAP.COD_INTERFAZLDC%type,
                                  nuNUM_DOCUMENTOSAP  in LDC_ENCAINTESAP.NUM_DOCUMENTOSAP%type,
                                  vaCOD_CENTROBENEF   in LDC_ENCAINTESAP.COD_CENTROBENEF%type,
                                  nuCOD_GRUPOCONCE    in LDC_ENCAINTESAP.COD_GRUPOCONCE%type,
                                  NUCOD_CAUSACARGO    IN LDC_ENCAINTESAP.COD_CAUSACARGO%TYPE,
                                  dtFECHDCTO          in LDC_ENCAINTESAP.FECHDCTO%type,
                                  DTFECHCONT          IN LDC_ENCAINTESAP.FECHCONT%TYPE,
                                  VAGRLEDGER          IN LDC_ENCAINTESAP.GRLEDGER%TYPE,
                                  VAREFERENC          IN LDC_ENCAINTESAP.REFERENC%TYPE,
                                  VATXTCABEC          IN LDC_ENCAINTESAP.TXTCABEC%TYPE,
                                  vaCLASEDOC          in LDC_ENCAINTESAP.CLASEDOC%type,
                                  VASOCIEDAD          IN LDC_ENCAINTESAP.SOCIEDAD%TYPE,
                                  vaCURRENCY          in LDC_ENCAINTESAP.CURRENCY%type)
  RETURN number;


  FUNCTION fnuLDC_DETAINTESAP(nuCOD_INTERFAZLDC in LDC_DETAINTESAP.COD_INTERFAZLDC%type,
                              NUNUM_DOCUMENTOSAP IN LDC_DETAINTESAP.NUM_DOCUMENTOSAP%TYPE,
                              VACLAVCONT IN LDC_DETAINTESAP.CLAVCONT%TYPE,
                              VACLASECTA IN LDC_DETAINTESAP.CLASECTA%TYPE,
                              VAINDICCME IN LDC_DETAINTESAP.INDICCME%TYPE,
                              NUIMPOMTRX IN LDC_DETAINTESAP.IMPOMTRX%TYPE,
                              NUIMPOMSOC IN LDC_DETAINTESAP.IMPOMSOC%TYPE,
                              VAINDICIVA IN LDC_DETAINTESAP.INDICIVA%TYPE,
                              NUCONDPAGO IN LDC_DETAINTESAP.CONDPAGO%TYPE,
                              DTFECHBASE IN LDC_DETAINTESAP.FECHBASE%TYPE,
                              VAREFFACTR IN LDC_DETAINTESAP.REFFACTR%TYPE,
                              NUBASEIMPT IN LDC_DETAINTESAP.BASEIMPT%TYPE,
                              VACENTROCO IN LDC_DETAINTESAP.CENTROCO%TYPE,
                              VAORDENINT IN LDC_DETAINTESAP.ORDENINT%TYPE,
                              NUCANTIDAD IN LDC_DETAINTESAP.CANTIDAD%TYPE,
                              VAASIGNACN IN LDC_DETAINTESAP.ASIGNACN%TYPE,
                              VATXTPOSCN IN LDC_DETAINTESAP.TXTPOSCN%TYPE,
                              VACENTROBE IN LDC_DETAINTESAP.CENTROBE%TYPE,
                              VASEGMENTO IN LDC_DETAINTESAP.SEGMENTO%TYPE,
                              vaOBJCOSTO in LDC_DETAINTESAP.OBJCOSTO%type,
                              VACLAVREF1 IN LDC_DETAINTESAP.CLAVREF1%TYPE,
                              vaCLAVREF2 in LDC_DETAINTESAP.CLAVREF2%type,
                              VACLAVREF3 IN LDC_DETAINTESAP.CLAVREF3%TYPE,
                              VASOCIEDGL IN LDC_DETAINTESAP.SOCIEDGL%TYPE,
                              NUMATERIAL IN LDC_DETAINTESAP.MATERIAL%TYPE,
                              VATIPORETC IN LDC_DETAINTESAP.TIPORETC%TYPE,
                              VAINDRETEC IN LDC_DETAINTESAP.INDRETEC%TYPE,
                              NUBASERETC IN LDC_DETAINTESAP.BASERETC%TYPE,
                              DTFECHVALOR IN LDC_DETAINTESAP.FECHVALOR%TYPE,
                              VACTADIV    IN LDC_DETAINTESAP.CTADIV%TYPE,
                              NUCOD_CENTROBENEF IN LDC_DETAINTESAP.COD_CENTROBENEF%TYPE,
                              NUCOD_GRUPOCONCE  IN LDC_DETAINTESAP.COD_GRUPOCONCE%TYPE,
                              NUCOD_CAUSACARGO  IN LDC_DETAINTESAP.COD_CAUSACARGO%TYPE)
  RETURN number;

  
  FUNCTION fnuINSEINTESAP
  RETURN number;

  FUNCTION FNULDC_INCOLIQU(NUICLITIDO IN LDC_INCOLIQU.ICLITIDO%TYPE,
                           nuICLINUDO IN LDC_INCOLIQU.ICLINUDO%TYPE,
                           DTICLIFECH IN LDC_INCOLIQU.ICLIFECH%TYPE,
                           vaICLIUSUA IN LDC_INCOLIQU.ICLIUSUA%TYPE,
                           VAICLITERM IN LDC_INCOLIQU.ICLITERM%TYPE,
                           DTICLIFECR IN LDC_INCOLIQU.ICLIFECR%TYPE,
                           VACOD_CENTROBENEF IN LDC_INCOLIQU.COD_CENTROBENEF%TYPE,
                           NUCOD_GRUPOCONCE IN LDC_INCOLIQU.COD_GRUPOCONCE%TYPE,
                           NUCOD_CAUSACARGO IN LDC_INCOLIQU.COD_CAUSACARGO%TYPE,
                           VACLAVCONT IN LDC_INCOLIQU.CLAVCONT%TYPE,
                           VACLASECTA IN LDC_INCOLIQU.CLASECTA%TYPE,
                           VAINDICCME IN LDC_INCOLIQU.INDICCME%TYPE,
                           NUIMPOMTRX IN LDC_INCOLIQU.IMPOMTRX%TYPE,
                           NUIMPOMSOC IN LDC_INCOLIQU.IMPOMSOC%TYPE,
                           vaINDICIVA IN LDC_INCOLIQU.INDICIVA%TYPE,
                           VACONDPAGO IN LDC_INCOLIQU.CONDPAGO%TYPE,
                           DTFECHBASE IN LDC_INCOLIQU.FECHBASE%TYPE,
                           vaREFFACTR IN LDC_INCOLIQU.REFFACTR%TYPE,
                           NUBASEIMPT IN LDC_INCOLIQU.BASEIMPT%TYPE,
                           VACENTROCO IN LDC_INCOLIQU.CENTROCO%TYPE,
                           VAORDENINT IN LDC_INCOLIQU.ORDENINT%TYPE,
                           NUCANTIDAD IN LDC_INCOLIQU.CANTIDAD%TYPE,
                           VAASIGNACN IN LDC_INCOLIQU.ASIGNACN%TYPE,
                           VATXTPOSCN IN LDC_INCOLIQU.TXTPOSCN%TYPE,
                           VACENTROBE IN LDC_INCOLIQU.CENTROBE%TYPE,
                           VASEGMENTO IN LDC_INCOLIQU.SEGMENTO%TYPE,
                           VAOBJCOSTO IN LDC_INCOLIQU.OBJCOSTO%TYPE,
                           VACLAVREF1 IN LDC_INCOLIQU.CLAVREF1%TYPE,
                           VACLAVREF2 IN LDC_INCOLIQU.CLAVREF2%TYPE,
                           VACLAVREF3 IN LDC_INCOLIQU.CLAVREF3%TYPE,
                           VASOCIEDGL IN LDC_INCOLIQU.SOCIEDGL%TYPE,
                           vaMATERIAL IN LDC_INCOLIQU.MATERIAL%TYPE,
                           VATIPORETC IN LDC_INCOLIQU.TIPORETC%TYPE,
                           VAINDRETEC IN LDC_INCOLIQU.INDRETEC%TYPE,
                           NUBASERETC IN LDC_INCOLIQU.BASERETC%TYPE,
                           NUNUSEINSE IN LDC_INCOLIQU.NUSEINSE%TYPE,
                           DTFECHVALOR IN LDC_INCOLIQU.FECHVALOR%TYPE,
                           VACTADIV   IN LDC_INCOLIQU.CTADIV%TYPE)
  RETURN number;

  FUNCTION fnuUpdAsiento(nuASIECONS          IN   ASIENTO_SAP.ASIECONS%TYPE,
                       nuCOD_INTERFAZLDC   IN   LDC_ENCAINTESAP.COD_INTERFAZLDC%TYPE)
  RETURN NUMBER;

  FUNCTION FNUCONTROLREINTEGRO(DTFECHAINI    IN   DATE,
                               dtFechaFin    IN   DATE)
  RETURN number;
  
  FUNCTION fnuComiReca(dtFechaIni IN DATE,
                       dtFechaFin in date)
  RETURN number;
  
  FUNCTION fnuContFactSD(dtFechaIni IN DATE,
                         dtFechaFin in date)
  return number;

END ldc_pkinterfazsurti;
/
CREATE OR REPLACE PACKAGE BODY ldc_pkinterfazsurti
is
  /************************************************************************
  PROPIEDAD INTELECTUAL DE GASES DE OCCIDENTE S.A E.S.P
  FUNCION   : ldc_pkinterfazsurti
  AUTOR     : Hector Javier Cuervo Ramirez
  FECHA     : 25-03-2012
  DESCRIPCION  :
  Parametros de Entrada
  Parametros de Salida
  Historia de Modificaciones
  Autor     Fecha       Descripcion    
  cgonzalez 25-07-2012  Se agrega el  proceso de reportar en interfaz contable
                        la facturacion de internas a mutifamiliares
  Jorgemg  17/08/2012   Se agrega la validacion del tipo de movimiento
                        para efectos de contabilizacion de las reversiones  
                        del control reintegro asociadas al tipo de movimiento
                        771.                        
  ************************************************************************/
  --<<
  --Declaracion de tipos
  -->

  
type tyLDC_ENCAINTESAP
IS
  TABLE OF LDC_ENCAINTESAP%ROWTYPE INDEX BY BINARY_INTEGER;
  vtyLDC_ENCAINTESAP tyLDC_ENCAINTESAP;

type tyLDC_DETAINTESAP
IS  
  TABLE OF LDC_DETAINTESAP%ROWTYPE INDEX BY BINARY_INTEGER;
  vtyLDC_DETAINTESAP tyLDC_DETAINTESAP;
  
type tyLDC_INCOLIQU
IS
  TABLE OF LDC_INCOLIQU%ROWTYPE INDEX BY BINARY_INTEGER;
  vtyLDC_INCOLIQU tyLDC_INCOLIQU;
  
  


FUNCTION fnuSeq_ldc_incoliqu
  RETURN number
  /************************************************************************
  PROPIEDAD INTELECTUAL DE GASES DE OCCIDENTE S.A E.S.P
  FUNCION   : fnuSeq_ldc_incoliqu
  AUTOR     : Hector Javier Cuervo Ramirez
  FECHA     : 25-03-2012
  DESCRIPCION  :
  funcion que se encarga de obtener la secuencia para la
  interfaz
  Parametros de Entrada
  Parametros de Salida
  Historia de Modificaciones
  Autor    Fecha       Descripcion
  ************************************************************************/
is
  nuSeqincoliqu number := 0;
begin
  select seq_ldc_incoliqu.nextval into nuSeqincoliqu from dual;
  return(nuSeqincoliqu);
exception
when others then
  return(-1);
end fnuSeq_ldc_incoliqu;

FUNCTION fnuGeneLDC_ENCAINTESAP(
    nuCOD_INTERFAZLDC  in LDC_ENCAINTESAP.COD_INTERFAZLDC%type,
    nuNUM_DOCUMENTOSAP in LDC_ENCAINTESAP.NUM_DOCUMENTOSAP%type,
    vaCOD_CENTROBENEF  in LDC_ENCAINTESAP.COD_CENTROBENEF%type,
    nuCOD_GRUPOCONCE   in LDC_ENCAINTESAP.COD_GRUPOCONCE%type,
    nuCOD_CAUSACARGO   in LDC_ENCAINTESAP.COD_CAUSACARGO%type,
    dtFECHDCTO         in LDC_ENCAINTESAP.FECHDCTO%type,
    dtFECHCONT         in LDC_ENCAINTESAP.FECHCONT%type,
    vaGRLEDGER         in LDC_ENCAINTESAP.GRLEDGER%type,
    vaREFERENC         in LDC_ENCAINTESAP.REFERENC%type,
    vaTXTCABEC         in LDC_ENCAINTESAP.TXTCABEC%type,
    vaCLASEDOC         in LDC_ENCAINTESAP.CLASEDOC%type,
    vaSOCIEDAD         in LDC_ENCAINTESAP.SOCIEDAD%type,
    vaCURRENCY         in LDC_ENCAINTESAP.CURRENCY%type)
  return number
  /************************************************************************
  PROPIEDAD INTELECTUAL DE GASES DE OCCIDENTE S.A E.S.P
  FUNCION   : fnuGeneLDC_ENCAINTESAP
  AUTOR     : Hector Javier Cuervo Ramirez
  FECHA     : 20-05-2011
  DESCRIPCION  : Tiquete: 138009
  funcion que se encarga de insertar el encabezado de la tabla
  de interfaz para SAP.
  Parametros de Entrada
  Parametros de Salida
  Historia de Modificaciones
  Autor    Fecha       Descripcion
  ************************************************************************/
is
begin
  --<<
  --Insercion de los datos en la tabla plsql delete encabezado para SAP
  -->>
  if (vtyLDC_ENCAINTESAP.count                                             = 0) then
    ldc_pkinterfazsurti.nuEncabezado                                      := 1;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).COD_INTERFAZLDC  := nuCOD_INTERFAZLDC;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).NUM_DOCUMENTOSAP := nuNUM_DOCUMENTOSAP;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).COD_CENTROBENEF  := vaCOD_CENTROBENEF;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).COD_GRUPOCONCE   := nuCOD_GRUPOCONCE;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).COD_CAUSACARGO   := nuCOD_CAUSACARGO;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).FECHDCTO         := dtFECHDCTO;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).FECHCONT         := dtFECHCONT;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).GRLEDGER         := vaGRLEDGER;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).REFERENC         := vaREFERENC;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).TXTCABEC         := vaTXTCABEC;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).CLASEDOC         := vaCLASEDOC;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).SOCIEDAD         := vaSOCIEDAD;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).CURRENCY         := vaCURRENCY;
  else
    ldc_pkinterfazsurti.nuEncabezado                                      := ldc_pkinterfazsurti.nuEncabezado + 1;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).COD_INTERFAZLDC  := nuCOD_INTERFAZLDC;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).NUM_DOCUMENTOSAP := nuNUM_DOCUMENTOSAP;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).COD_CENTROBENEF  := vaCOD_CENTROBENEF;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).COD_GRUPOCONCE   := nuCOD_GRUPOCONCE;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).COD_CAUSACARGO   := nuCOD_CAUSACARGO;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).FECHDCTO         := dtFECHDCTO;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).FECHCONT         := dtFECHCONT;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).GRLEDGER         := vaGRLEDGER;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).REFERENC         := vaREFERENC;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).TXTCABEC         := vaTXTCABEC;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).CLASEDOC         := vaCLASEDOC;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).SOCIEDAD         := vaSOCIEDAD;
    vtyLDC_ENCAINTESAP(ldc_pkinterfazsurti.nuEncabezado).CURRENCY         := vaCURRENCY;
  end if;
  return(0);
exception
when others then
  ldc_pkinterfazsurti.vaMensError := '[fnuGeneLDC_ENCAINTESAP] - No pudo insertar el registro del encabezado '||sqlerrm;
  pkregidepu.pRegiMensaje('ldc_pkinterfazsurti.vaMensError:',ldc_pkinterfazsurti.vaMensError,'CRREIN');   
  RETURN(-1);
END FNUGENELDC_ENCAINTESAP;

FUNCTION fnuLDC_DETAINTESAP(
    nuCOD_INTERFAZLDC  in LDC_DETAINTESAP.COD_INTERFAZLDC%type,
    nuNUM_DOCUMENTOSAP in LDC_DETAINTESAP.NUM_DOCUMENTOSAP%type,
    vaCLAVCONT         in LDC_DETAINTESAP.CLAVCONT%type,
    vaCLASECTA         in LDC_DETAINTESAP.CLASECTA%type,
    vaINDICCME         in LDC_DETAINTESAP.INDICCME%type,
    nuIMPOMTRX         in LDC_DETAINTESAP.IMPOMTRX%type,
    nuIMPOMSOC         in LDC_DETAINTESAP.IMPOMSOC%type,
    vaINDICIVA         in LDC_DETAINTESAP.INDICIVA%type,
    nuCONDPAGO         in LDC_DETAINTESAP.CONDPAGO%type,
    dtFECHBASE         in LDC_DETAINTESAP.FECHBASE%type,
    vaREFFACTR         in LDC_DETAINTESAP.REFFACTR%type,
    nuBASEIMPT         in LDC_DETAINTESAP.BASEIMPT%type,
    vaCENTROCO         in LDC_DETAINTESAP.CENTROCO%type,
    vaORDENINT         in LDC_DETAINTESAP.ORDENINT%type,
    nuCANTIDAD         in LDC_DETAINTESAP.CANTIDAD%type,
    vaASIGNACN         in LDC_DETAINTESAP.ASIGNACN%type,
    vaTXTPOSCN         in LDC_DETAINTESAP.TXTPOSCN%type,
    vaCENTROBE         in LDC_DETAINTESAP.CENTROBE%type,
    vaSEGMENTO         in LDC_DETAINTESAP.SEGMENTO%type,
    vaOBJCOSTO         in LDC_DETAINTESAP.OBJCOSTO%type,
    vaCLAVREF1         in LDC_DETAINTESAP.CLAVREF1%type,
    vaCLAVREF2         in LDC_DETAINTESAP.CLAVREF2%type,
    vaCLAVREF3         in LDC_DETAINTESAP.CLAVREF3%type,
    vaSOCIEDGL         in LDC_DETAINTESAP.SOCIEDGL%type,
    nuMATERIAL         in LDC_DETAINTESAP.MATERIAL%type,
    vaTIPORETC         in LDC_DETAINTESAP.TIPORETC%type,
    vaINDRETEC         in LDC_DETAINTESAP.INDRETEC%type,
    nuBASERETC         in LDC_DETAINTESAP.BASERETC%type,
    dtFECHVALOR        in LDC_DETAINTESAP.FECHVALOR%type,
    vaCTADIV           in LDC_DETAINTESAP.CTADIV%type,
    nuCOD_CENTROBENEF  in LDC_DETAINTESAP.COD_CENTROBENEF%type,
    nuCOD_GRUPOCONCE   in LDC_DETAINTESAP.COD_GRUPOCONCE%type,
    nuCOD_CAUSACARGO   in LDC_DETAINTESAP.COD_CAUSACARGO%type)
  return number
is
  /************************************************************************
  PROPIEDAD INTELECTUAL DE GASES DE OCCIDENTE S.A E.S.P
  FUNCION   : fnuLDC_DETAINTESAP
  AUTOR     : Hector Javier Cuervo Ramirez
  FECHA     : 25-03-2012
  DESCRIPCION  :
  funcion que se encarga de insertar el detalle de la tabla
  de interfaz para SAP.
  Parametros de Entrada
  Parametros de Salida
  Historia de Modificaciones
  Autor    Fecha       Descripcion
  ************************************************************************/
begin
  --<<
  --Insercion de los registros del detalle de la interfaz
  -->>
  if (vtyLDC_DETAINTESAP.count                                          = 0) then
    ldc_pkinterfazsurti.nuDetalle                                      := 1;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).COD_INTERFAZLDC  := nuCOD_INTERFAZLDC;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).NUM_DOCUMENTOSAP := nuNUM_DOCUMENTOSAP;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).CLAVCONT         := vaCLAVCONT;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).CLASECTA         := vaCLASECTA;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).INDICCME         := vaINDICCME;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).IMPOMTRX         := nuIMPOMTRX;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).IMPOMSOC         := nuIMPOMSOC;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).INDICIVA         := vaINDICIVA;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).CONDPAGO         := nuCONDPAGO;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).FECHBASE         := dtFECHBASE;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).REFFACTR         := vaREFFACTR;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).BASEIMPT         := nuBASEIMPT;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).CENTROCO         := vaCENTROCO;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).ORDENINT         := vaORDENINT;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).CANTIDAD         := nuCANTIDAD;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).ASIGNACN         := vaASIGNACN;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).TXTPOSCN         := vaTXTPOSCN;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).CENTROBE         := vaCENTROBE;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).SEGMENTO         := vaSEGMENTO;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).OBJCOSTO         := vaOBJCOSTO;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).CLAVREF1         := vaCLAVREF1;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).CLAVREF2         := vaCLAVREF2;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).CLAVREF3         := vaCLAVREF3;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).SOCIEDGL         := vaSOCIEDGL;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).MATERIAL         := nuMATERIAL;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).TIPORETC         := vaTIPORETC;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).INDRETEC         := vaINDRETEC;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).BASERETC         := nuBASERETC;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).FECHVALOR        := dtFECHVALOR;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).CTADIV           := vaCTADIV;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).COD_CENTROBENEF  := nuCOD_CENTROBENEF;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).COD_GRUPOCONCE   := nuCOD_GRUPOCONCE;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).COD_CAUSACARGO   := nuCOD_CAUSACARGO;
  else
    ldc_pkinterfazsurti.nuDetalle                                      := ldc_pkinterfazsurti.nuDetalle + 1;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).COD_INTERFAZLDC  := nuCOD_INTERFAZLDC;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).NUM_DOCUMENTOSAP := nuNUM_DOCUMENTOSAP;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).CLAVCONT         := vaCLAVCONT;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).CLASECTA         := vaCLASECTA;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).INDICCME         := vaINDICCME;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).IMPOMTRX         := nuIMPOMTRX;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).IMPOMSOC         := nuIMPOMSOC;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).INDICIVA         := vaINDICIVA;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).CONDPAGO         := nuCONDPAGO;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).FECHBASE         := dtFECHBASE;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).REFFACTR         := vaREFFACTR;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).BASEIMPT         := nuBASEIMPT;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).CENTROCO         := vaCENTROCO;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).ORDENINT         := vaORDENINT;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).CANTIDAD         := nuCANTIDAD;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).ASIGNACN         := vaASIGNACN;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).TXTPOSCN         := vaTXTPOSCN;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).CENTROBE         := vaCENTROBE;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).SEGMENTO         := vaSEGMENTO;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).OBJCOSTO         := vaOBJCOSTO;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).CLAVREF1         := vaCLAVREF1;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).CLAVREF2         := vaCLAVREF2;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).CLAVREF3         := vaCLAVREF3;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).SOCIEDGL         := vaSOCIEDGL;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).MATERIAL         := nuMATERIAL;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).TIPORETC         := vaTIPORETC;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).INDRETEC         := vaINDRETEC;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).BASERETC         := nuBASERETC;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).FECHVALOR        := dtFECHVALOR;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).CTADIV           := vaCTADIV;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).COD_CENTROBENEF  := nuCOD_CENTROBENEF;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).COD_GRUPOCONCE   := nuCOD_GRUPOCONCE;
    vtyLDC_DETAINTESAP(ldc_pkinterfazsurti.nuDetalle).COD_CAUSACARGO   := nuCOD_CAUSACARGO;
  end if;
  return(0);
exception
when others then
  ldc_pkinterfazsurti.vaMensError := '[fnuLDC_DETAINTESAP] - No pudo insertar el registro del detalle de la interfaz. '||sqlerrm;
  RETURN(-1);
END FNULDC_DETAINTESAP;

FUNCTION fnuINSELDC_INCOLIQU
  return number
is
  /************************************************************************
  PROPIEDAD INTELECTUAL DE GASES DE OCCIDENTE S.A E.S.P
  FUNCION   : fnuINSELDC_INCOLIQU
  AUTOR     : Hector Javier Cuervo Ramirez
  FECHA     : 25-03-2012
  DESCRIPCION  :
  funcion que se encarga de volver persistente los datos de la
  tabla LDC_INCOLIQU
  Parametros de Entrada
  Parametros de Salida
  Historia de Modificaciones
  Autor    Fecha       Descripcion
  ************************************************************************/
begin
  --<<
  --Insercion de los encabezados
  -->>
  FORALL y IN vtyLDC_INCOLIQU.First..vtyLDC_INCOLIQU.Last
  INSERT INTO LDC_INCOLIQU VALUES vtyLDC_INCOLIQU(y);
  commit;
  vtyLDC_INCOLIQU.delete;
  return(0);
exception
when others then
  ldc_pkinterfazsurti.vaMensError := '[fnuINSELDC_INCOLIQU] - No se pudieron almacenar los registros tabla LDC_INCOLIQU. '||sqlerrm;
  return(-1);
END FNUINSELDC_INCOLIQU;

FUNCTION fnuINSEINTESAP
  return number
is
  /************************************************************************
  PROPIEDAD INTELECTUAL DE GASES DE OCCIDENTE S.A E.S.P
  FUNCION   : fnuINSEINTESAP
  AUTOR     : Hector Javier Cuervo Ramirez
  FECHA     : 25-03-2012
  DESCRIPCION  :
  funcion que se encarga de volver persistente los datos de la
  interfaz al modelo de SAP
  Parametros de Entrada
  Parametros de Salida
  Historia de Modificaciones
  Autor    Fecha       Descripcion
  ************************************************************************/
begin
  --<<
  --Insercion de los encabezados
  -->>
  FORALL y IN vtyLDC_ENCAINTESAP.First..vtyLDC_ENCAINTESAP.Last
  INSERT INTO LDC_ENCAINTESAP VALUES vtyLDC_ENCAINTESAP(y);
  --<<
  --Insercion delete detalle
  -->>
  FORALL y IN vtyLDC_DETAINTESAP.First..vtyLDC_DETAINTESAP.Last
  INSERT INTO LDC_DETAINTESAP VALUES vtyLDC_DETAINTESAP(y);
  commit;                                                
  
  vtyLDC_ENCAINTESAP.delete;
  vtyLDC_DETAINTESAP.delete;
  return(0);
exception
when others then
  ldc_pkinterfazsurti.vaMensError := '[fnuINSEINTESAP] - No se pudieron almacenar los registros de la interfaz de ingresos. '||sqlerrm;
  RETURN(-1);
END FNUINSEINTESAP;

FUNCTION fnuLDC_INCOLIQU
  (
    nuICLITIDO        IN LDC_INCOLIQU.ICLITIDO%TYPE,
    nuICLINUDO        IN LDC_INCOLIQU.ICLINUDO%TYPE,
    dtICLIFECH        IN LDC_INCOLIQU.ICLIFECH%TYPE,
    vaICLIUSUA        IN LDC_INCOLIQU.ICLIUSUA%TYPE,
    vaICLITERM        IN LDC_INCOLIQU.ICLITERM%TYPE,
    dtICLIFECR        IN LDC_INCOLIQU.ICLIFECR%TYPE,
    vaCOD_CENTROBENEF in LDC_INCOLIQU.COD_CENTROBENEF%type,
    nuCOD_GRUPOCONCE  in LDC_INCOLIQU.COD_GRUPOCONCE%type,
    nuCOD_CAUSACARGO  in LDC_INCOLIQU.COD_CAUSACARGO%type,
    vaCLAVCONT        IN LDC_INCOLIQU.CLAVCONT%TYPE,
    vaCLASECTA        IN LDC_INCOLIQU.CLASECTA%TYPE,
    vaINDICCME        IN LDC_INCOLIQU.INDICCME%TYPE,
    nuIMPOMTRX        IN LDC_INCOLIQU.IMPOMTRX%TYPE,
    nuIMPOMSOC        IN LDC_INCOLIQU.IMPOMSOC%TYPE,
    vaINDICIVA        IN LDC_INCOLIQU.INDICIVA%TYPE,
    vaCONDPAGO        IN LDC_INCOLIQU.CONDPAGO%TYPE,
    dtFECHBASE        IN LDC_INCOLIQU.FECHBASE%TYPE,
    vaREFFACTR        IN LDC_INCOLIQU.REFFACTR%TYPE,
    nuBASEIMPT        IN LDC_INCOLIQU.BASEIMPT%TYPE,
    vaCENTROCO        IN LDC_INCOLIQU.CENTROCO%TYPE,
    vaORDENINT        IN LDC_INCOLIQU.ORDENINT%TYPE,
    nuCANTIDAD        IN LDC_INCOLIQU.CANTIDAD%TYPE,
    vaASIGNACN        IN LDC_INCOLIQU.ASIGNACN%TYPE,
    vaTXTPOSCN        IN LDC_INCOLIQU.TXTPOSCN%TYPE,
    vaCENTROBE        IN LDC_INCOLIQU.CENTROBE%TYPE,
    vaSEGMENTO        IN LDC_INCOLIQU.SEGMENTO%TYPE,
    vaOBJCOSTO        IN LDC_INCOLIQU.OBJCOSTO%TYPE,
    vaCLAVREF1        IN LDC_INCOLIQU.CLAVREF1%TYPE,
    vaCLAVREF2        IN LDC_INCOLIQU.CLAVREF2%TYPE,
    vaCLAVREF3        IN LDC_INCOLIQU.CLAVREF3%TYPE,
    vaSOCIEDGL        IN LDC_INCOLIQU.SOCIEDGL%TYPE,
    vaMATERIAL        IN LDC_INCOLIQU.MATERIAL%TYPE,
    vaTIPORETC        IN LDC_INCOLIQU.TIPORETC%TYPE,
    vaINDRETEC        IN LDC_INCOLIQU.INDRETEC%TYPE,
    nuBASERETC        IN LDC_INCOLIQU.BASERETC%TYPE,
    nuNUSEINSE        IN LDC_INCOLIQU.NUSEINSE%type,
    dtFECHVALOR       in LDC_INCOLIQU.FECHVALOR%type,
    vaCTADIV          in LDC_INCOLIQU.CTADIV%type
  )
  return number
is
  /************************************************************************
  PROPIEDAD INTELECTUAL DE GASES DE OCCIDENTE S.A E.S.P
  FUNCION   : fnuLDC_INCOLIQU
  AUTOR     : Hector Javier Cuervo Ramirez
  FECHA     : 20-05-2011
  DESCRIPCION  : Tiquete: 138009
  funcion que se encarga de volver persistente los datos de la
  interfaz al modelo de SAP
  Parametros de Entrada
  Parametros de Salida
  Historia de Modificaciones
  Autor    Fecha       Descripcion
  ************************************************************************/
begin
  if (vtyLDC_INCOLIQU.count                                          = 0) then
    ldc_pkinterfazsurti.nuIncoliqu                                  := 1;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).ICLITIDO        := nuICLITIDO;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).ICLINUDO        := nuICLINUDO;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).ICLIFECH        := dtICLIFECH;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).ICLIUSUA        := vaICLIUSUA;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).ICLITERM        := vaICLITERM;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).ICLIFECR        := dtICLIFECR;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).COD_CENTROBENEF := vaCOD_CENTROBENEF;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).COD_GRUPOCONCE  := nuCOD_GRUPOCONCE;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).COD_CAUSACARGO  := nuCOD_CAUSACARGO;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).CLAVCONT        := vaCLAVCONT;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).CLASECTA        := vaCLASECTA;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).INDICCME        := vaINDICCME;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).IMPOMTRX        := nuIMPOMTRX;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).IMPOMSOC        := nuIMPOMSOC;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).INDICIVA        := vaINDICIVA;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).CONDPAGO        := vaCONDPAGO;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).FECHBASE        := dtFECHBASE;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).REFFACTR        := vaREFFACTR;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).BASEIMPT        := nuBASEIMPT;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).CENTROCO        := vaCENTROCO;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).ORDENINT        := vaORDENINT;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).CANTIDAD        := nuCANTIDAD;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).ASIGNACN        := vaASIGNACN;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).TXTPOSCN        := vaTXTPOSCN;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).CENTROBE        := vaCENTROBE;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).SEGMENTO        := vaSEGMENTO;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).OBJCOSTO        := vaOBJCOSTO;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).CLAVREF1        := vaCLAVREF1;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).CLAVREF2        := vaCLAVREF2;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).CLAVREF3        := vaCLAVREF3;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).SOCIEDGL        := vaSOCIEDGL;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).MATERIAL        := vaMATERIAL;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).TIPORETC        := vaTIPORETC;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).INDRETEC        := vaINDRETEC;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).BASERETC        := nuBASERETC;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).NUSEINSE        := nuNUSEINSE;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).FECHVALOR       := dtFECHVALOR;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).CTADIV          := vaCTADIV;
  ELSE
    ldc_pkinterfazsurti.nuIncoliqu                                  := ldc_pkinterfazsurti.nuIncoliqu + 1;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).ICLITIDO        := nuICLITIDO;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).ICLINUDO        := nuICLINUDO;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).ICLIFECH        := dtICLIFECH;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).ICLIUSUA        := vaICLIUSUA;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).ICLITERM        := vaICLITERM;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).ICLIFECR        := dtICLIFECR;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).COD_CENTROBENEF := vaCOD_CENTROBENEF;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).COD_GRUPOCONCE  := nuCOD_GRUPOCONCE;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).COD_CAUSACARGO  := nuCOD_CAUSACARGO;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).CLAVCONT        := vaCLAVCONT;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).CLASECTA        := vaCLASECTA;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).INDICCME        := vaINDICCME;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).IMPOMTRX        := nuIMPOMTRX;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).IMPOMSOC        := nuIMPOMSOC;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).INDICIVA        := vaINDICIVA;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).CONDPAGO        := vaCONDPAGO;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).FECHBASE        := dtFECHBASE;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).REFFACTR        := vaREFFACTR;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).BASEIMPT        := nuBASEIMPT;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).CENTROCO        := vaCENTROCO;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).ORDENINT        := vaORDENINT;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).CANTIDAD        := nuCANTIDAD;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).ASIGNACN        := vaASIGNACN;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).TXTPOSCN        := vaTXTPOSCN;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).CENTROBE        := vaCENTROBE;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).SEGMENTO        := vaSEGMENTO;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).OBJCOSTO        := vaOBJCOSTO;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).CLAVREF1        := vaCLAVREF1;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).CLAVREF2        := vaCLAVREF2;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).CLAVREF3        := vaCLAVREF3;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).SOCIEDGL        := vaSOCIEDGL;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).MATERIAL        := vaMATERIAL;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).TIPORETC        := vaTIPORETC;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).INDRETEC        := vaINDRETEC;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).BASERETC        := nuBASERETC;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).NUSEINSE        := nuNUSEINSE;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).FECHVALOR       := dtFECHVALOR;
    vtyLDC_INCOLIQU(ldc_pkinterfazsurti.nuIncoliqu).CTADIV          := vaCTADIV;
  END IF;
  return(0);
exception
when others then
  ldc_pkinterfazsurti.vaMensError := '[fnuLDC_INCOLIQU] - No se pudieron almacenar los registros en la tabla LDC_INCOLIQU. '||sqlerrm;
  return(-1);
END FNULDC_INCOLIQU;

function fnuGeneDocuSap(nuICLINUDO   in LDC_INCOLIQU.ICLINUDO%type)
return number
/************************************************************************
   PROPIEDAD INTELECTUAL DE GASES DE OCCIDENTE S.A E.S.P
   FUNCION   : fnuGeneDocuSap
   AUTOR     : Hector Javier Cuervo Ramirez
   FECHA     : 26-03-2012
   DESCRIPCION  :
                  funcion que se encarga de armar el resumen de la interfaz
  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
************************************************************************/
is

   --<<
   --Seleccion de datos del resumen de la interfaz de ingresos
   -->>
   cursor cuLDC_INCOLIQU(nuICLINUDO     in LDC_INCOLIQU.ICLINUDO%type)
   is
   select CLAVCONT, CLASECTA, INDICCME, INDICIVA, CONDPAGO, FECHBASE, REFFACTR, BASEIMPT,
          CENTROCO, ORDENINT, CANTIDAD, ASIGNACN, TXTPOSCN, CENTROBE, SEGMENTO, OBJCOSTO,
          CLAVREF1, CLAVREF2, CLAVREF3, SOCIEDGL, MATERIAL, TIPORETC, INDRETEC, BASERETC,
          COD_CENTROBENEF, COD_GRUPOCONCE, COD_CAUSACARGO, FECHVALOR, CTADIV, ICLIFECH, 
          ICLIFECR, sum(IMPOMTRX) IMPOMTRX, sum(IMPOMSOC) IMPOMSOC
     from LDC_INCOLIQU
    where ICLINUDO = nuICLINUDO
  group by CLAVCONT, CLASECTA, INDICCME, INDICIVA, CONDPAGO, FECHBASE, REFFACTR, BASEIMPT,
          CENTROCO, ORDENINT, CANTIDAD, ASIGNACN, TXTPOSCN, CENTROBE, SEGMENTO, OBJCOSTO,
          CLAVREF1, CLAVREF2, CLAVREF3, SOCIEDGL, MATERIAL, TIPORETC, INDRETEC, BASERETC,
          COD_CENTROBENEF, COD_GRUPOCONCE, COD_CAUSACARGO, FECHVALOR, CTADIV, ICLIFECH, 
          ICLIFECR
    order by COD_CENTROBENEF, COD_GRUPOCONCE, COD_CAUSACARGO;

   TYPE tycuLDC_INCOLIQU IS TABLE OF cuLDC_INCOLIQU%ROWTYPE INDEX BY BINARY_INTEGER;
   vtycuLDC_INCOLIQU tycuLDC_INCOLIQU;

   nuIndEnca   number := 0;
   nuRet       number := 0;
   nuDocumento number := 0;
   
begin

  pkregidepu.pRegiMensaje('Documento:',nuICLINUDO,'CRREIN');   
  pkregidepu.pRegiMensaje('ldc_pkinterfazsurti.vaGRLEDGER:',ldc_pkinterfazsurti.vaGRLEDGER,'CRREIN');
  pkregidepu.pRegiMensaje('ldc_pkinterfazsurti.vaCODINTINTERFAZ:',ldc_pkinterfazsurti.vaCODINTINTERFAZ,'CRREIN');
  pkregidepu.pRegiMensaje('ldc_pkinterfazsurti.vaSOCIEDAD:',ldc_pkinterfazsurti.vaSOCIEDAD,'CRREIN');
  pkregidepu.pRegiMensaje('dc_pkinterfazsurti.vaCURRENCY: ',ldc_pkinterfazsurti.vaCURRENCY,'CRREIN');
  
  pkregidepu.pRegiMensaje('nuICLINUDO:',nuICLINUDO,'CRREIN'); 
  pkregidepu.pRegiMensaje('nuIndEnca:',nuIndEnca,'CRREIN'); 
  pkregidepu.pRegiMensaje('ldc_pkinterfazsurti.vaGRLEDGER:',ldc_pkinterfazsurti.vaGRLEDGER,'CRREIN'); 
  pkregidepu.pRegiMensaje('ldc_pkinterfazsurti.vaCODINTINTERFAZ:',ldc_pkinterfazsurti.vaCODINTINTERFAZ,'CRREIN'); 
  pkregidepu.pRegiMensaje('ldc_pkinterfazsurti.vaSOCIEDAD:',ldc_pkinterfazsurti.vaSOCIEDAD,'CRREIN'); 
  pkregidepu.pRegiMensaje('ldc_pkinterfazsurti.vaCURRENCY:',ldc_pkinterfazsurti.vaCURRENCY,'CRREIN'); 

  --<<
  --Seleccion de datos para generar la informacion de los registros contables segun elmodelo de SAP
  -->>
  OPEN cuLDC_INCOLIQU(nuICLINUDO);
  FETCH cuLDC_INCOLIQU BULK COLLECT INTO vtycuLDC_INCOLIQU;
  CLOSE cuLDC_INCOLIQU;
  
  pkregidepu.pRegiMensaje('vtycuLDC_INCOLIQU.COUNT: ',vtycuLDC_INCOLIQU.COUNT,'CRREIN');
  IF (vtycuLDC_INCOLIQU.COUNT > 0) THEN
    --<<
    --Saca los detalles de la interfaz por grupo por concepto
    -->>
    FOR i IN vtycuLDC_INCOLIQU.First..vtycuLDC_INCOLIQU.Last LOOP
    
      --<<
      --Insercion encabezado del detalle de la interfaz
      -->>
      nuIndEnca := nuIndEnca + 1;
      
      IF (nuIndEnca = 1) THEN  
          
          nuDocumento := nuDocumento + 1;                     
          nuRet := ldc_pkinterfazsurti.fnuGeneLDC_ENCAINTESAP(nuICLINUDO,
                                                              nuDocumento,
                                                              null,
                                                              -1,
                                                              null,
                                                              TO_DATE(TO_CHAR(vtycuLDC_INCOLIQU(i).ICLIFECH,'DDMMYYYY'),'DDMMYYYY'),
                                                              TO_DATE(TO_CHAR(vtycuLDC_INCOLIQU(i).ICLIFECR,'DDMMYYYY'),'DDMMYYYY'),
                                                              ldc_pkinterfazsurti.vaGRLEDGER,                                                      
                                                              REPLACE(vtycuLDC_INCOLIQU(i).TXTPOSCN,'-'||TRUNC(vtycuLDC_INCOLIQU(i).ICLIFECR)),
                                                              REPLACE(vtycuLDC_INCOLIQU(i).TXTPOSCN,'-'||TRUNC(vtycuLDC_INCOLIQU(i).ICLIFECR)),
                                                              --vtycuLDC_INCOLIQU(i).TXTPOSCN,
                                                              --vtycuLDC_INCOLIQU(i).TXTPOSCN,
                                                              ldc_pkinterfazsurti.vaCODINTINTERFAZ,
                                                              ldc_pkinterfazsurti.vaSOCIEDAD,
                                                              ldc_pkinterfazsurti.vaCURRENCY);
  


        if (nuRet <> 0) then
           ldc_pkinterfazsurti.vaMensError := 'Error Generando el encabezado del documento.';
           raise Error;
        end if;
  
       END IF;
       
       --<<
       --Generacion de los detalles de la interfaz
       -->>
       nuRet := ldc_pkinterfazsurti.fnuLDC_DETAINTESAP(nuICLINUDO,
                                                    nuDocumento,
                                                    vtycuLDC_INCOLIQU(i).CLAVCONT,
                                                    vtycuLDC_INCOLIQU(i).CLASECTA,
                                                    vtycuLDC_INCOLIQU(i).INDICCME,
                                                    vtycuLDC_INCOLIQU(i).IMPOMTRX,
                                                    vtycuLDC_INCOLIQU(i).IMPOMSOC,
                                                    vtycuLDC_INCOLIQU(i).INDICIVA,
                                                    vtycuLDC_INCOLIQU(i).CONDPAGO,
                                                    vtycuLDC_INCOLIQU(i).FECHBASE,
                                                    vtycuLDC_INCOLIQU(i).REFFACTR,
                                                    vtycuLDC_INCOLIQU(i).BASEIMPT,
                                                    VTYCULDC_INCOLIQU(I).CENTROCO,
                                                    vtycuLDC_INCOLIQU(i).ORDENINT,
                                                    VTYCULDC_INCOLIQU(I).CANTIDAD,
                                                    vtycuLDC_INCOLIQU(i).ASIGNACN,                                            
                                                    REPLACE(VTYCULDC_INCOLIQU(I).TXTPOSCN,'-'||nuAsiecons, ''),
                                                    vtycuLDC_INCOLIQU(i).CENTROBE,
                                                    vtycuLDC_INCOLIQU(i).SEGMENTO,
                                                    vtycuLDC_INCOLIQU(i).OBJCOSTO,
                                                    vtycuLDC_INCOLIQU(i).CLAVREF1,
                                                    vtycuLDC_INCOLIQU(i).CLAVREF2,
                                                    vtycuLDC_INCOLIQU(i).CLAVREF3,
                                                    vtycuLDC_INCOLIQU(i).SOCIEDGL,
                                                    vtycuLDC_INCOLIQU(i).MATERIAL,
                                                    vtycuLDC_INCOLIQU(i).TIPORETC,
                                                    vtycuLDC_INCOLIQU(i).INDRETEC,
                                                    vtycuLDC_INCOLIQU(i).BASERETC,
                                                    vtycuLDC_INCOLIQU(i).FECHVALOR,
                                                    vtycuLDC_INCOLIQU(i).CTADIV,
                                                    vtycuLDC_INCOLIQU(i).COD_CENTROBENEF,
                                                    vtycuLDC_INCOLIQU(i).COD_GRUPOCONCE,
                                                    vtycuLDC_INCOLIQU(i).COD_CAUSACARGO);

          pkregidepu.pRegiMensaje('nuRet ',nuRet,'CRREIN');
          if (nuRet <> 0) then
              ldc_pkinterfazsurti.vaMensError := 'Error Generando el detalle del documento.';
              raise Error;
          end if;    
  
    end loop;
  END IF;
  --<<
  --Borrado de la tabla de agrupacion
  -->>
  vtycuLDC_INCOLIQU.DELETE;

  --<<
  --Llena los datos con las tablas temporales que se crearon en memoria
  -->>
  pkregidepu.pRegiMensaje('llama LDC_PKINTERFAZSURTI.FNUINSEINTESAP ',null,'CRREIN');
  nuRet := ldc_pkinterfazsurti.FNUINSEINTESAP;
  
  pkregidepu.pRegiMensaje('retorno LDC_PKINTERFAZSURTI.FNUINSEINTESAP ',nuRet,'CRREIN');
  if (nuRet <> 0) then
     ldc_pkinterfazsurti.vaMensError := ldc_pkinterfazsurti.vaMensError||' Error insertando los datos de los documentos. '||sqlerrm;
     raise Error;
  end if;

  return(0);
exception
when Error then
     vtycuLDC_INCOLIQU.DELETE;
     ldc_pkinterfazsurti.vaMensError := ldc_pkinterfazsurti.vaMensError||'-'||'[fnuGeneDocuSap] - Error generando los datos para el documento de SAP. '||sqlerrm;
     pkregidepu.pRegiMensaje('ldc_pkinterfazsurti.vaMensError ',ldc_pkinterfazsurti.vaMensError,'CRREIN');
     return(-1);
when others then
     vtycuLDC_INCOLIQU.DELETE;
     ldc_pkinterfazsurti.vaMensError := ldc_pkinterfazsurti.vaMensError||'-'||'[fnuGeneDocuSap] - Error generando los datos para el documento de SAP. '||sqlerrm;
     pkregidepu.pRegiMensaje('ldc_pkinterfazsurti.vaMensError ',ldc_pkinterfazsurti.vaMensError,'CRREIN');
     return(-1);
end fnuGeneDocuSap;

FUNCTION fvaConsCentCostoCta(vaCodcebe     in  ldc_costcebecuen.cod_centrobenef%type,
                             vaCuenCont    in  ldc_costcebecuen.cod_cuentacontable%type)
RETURN VARCHAR2
/************************************************************************
  PROPIEDAD INTELECTUAL DE GASES DE OCCIDENTE S.A E.S.P
  FUNCION   : fnuControlReintegro
  AUTOR     : Hector Javier Cuervo Ramirez
  FECHA     : 25-03-2012
  DESCRIPCION  : funcion que se encarga de armar el resumen de la interfaz
                 de control reintegro.
************************************************************************/
IS
  --<<
  --Cursor que obtiene el centro de costo de una cuenta
  -->>
  CURSOR cuCentCosto
  IS
  SELECT cod_centrocosto FROM LDC_COSTCEBECUEN
   WHERE cod_centrobenef = vaCodcebe
     and cod_cuentacontable = vaCuenCont;

  vaCentrocosto  LDC_COSTCEBECUEN.cod_centrocosto%type;

BEGIN

  --<<
  --Obtencion de los datos del centro de costo
  -->>
  IF (SUBSTR(vaCuenCont, 0,1) like '5%' OR SUBSTR(vaCuenCont, 0,1) LIKE '7%') 
  THEN

      OPEN cuCentCosto;
      FETCH cuCentCosto into vaCentrocosto;
      IF (cuCentCosto%NOTFOUND) THEN
          vaCentrocosto := '-1';
      END IF;
      CLOSE cuCentCosto;

  END IF;
  RETURN(vaCentrocosto);
EXCEPTION
WHEN OTHERS THEN
     ldc_pkinterfazsurti.vaMensError := ldc_pkinterfazsurti.vaMensError||'-'||'[fvaConsCentCostoCta] - Error al obtener el centro de costo de la cuenta. '||sqlerrm;
     return('-1');
END fvaConsCentCostoCta;

FUNCTION fnuUpdAsiento(nuASIECONS          IN   ASIENTO_SAP.ASIECONS%TYPE,
                       nuCOD_INTERFAZLDC   IN   LDC_ENCAINTESAP.COD_INTERFAZLDC%TYPE)
/************************************************************************
  PROPIEDAD INTELECTUAL DE GASES DE OCCIDENTE S.A E.S.P
  FUNCION   : fnuUpdAsiento
  AUTOR     : Hector Javier Cuervo Ramirez
  FECHA     : 25-03-2012
  DESCRIPCION  : Funcion que se encarga de actualizar los asientos de sap
                 con el consecutivo que se envio la informacion a SAP
*************************************************************************/
RETURN NUMBER
IS
BEGIN
  
   UPDATE ASIENTO_SAP
      SET DOCENVIO_SAP = nuCOD_INTERFAZLDC
    WHERE ASIECONS = nuASIECONS;
    COMMIT;

RETURN(0);
EXCEPTION
WHEN OTHERS THEN
  ldc_pkinterfazsurti.vaMensError := ldc_pkinterfazsurti.vaMensError||'-'||'[fnuUpdAsiento] - Error actualizando el asiento con el numero de envio a SAP. '||sqlerrm;
  return(-1);
END fnuUpdAsiento;

FUNCTION fnuControlReintegro(dtFechaIni IN DATE,
                             dtFechaFin in date)
return number
  /************************************************************************
  PROPIEDAD INTELECTUAL DE GASES DE OCCIDENTE S.A E.S.P
  FUNCION   : fnuControlReintegro
  AUTOR     : Hector Javier Cuervo Ramirez
  FECHA     : 25-03-2012
  DESCRIPCION  : funcion que se encarga de armar el resumen de la interfaz
                 de control reintegro.
               
                 Se selecciona la informacion del asiento contable (ASIENTO_SAP)
                 a partir de la fecha de creacion del registro.

                 Se homologan las cuentas de acuerdo a la configuracion del asiento
                 en CUCOTIMV_SAP.
               
                 Se debe validar con resoreria si actualmente existe algun
                 punto de reacudo que me consigne en un banco sobre el cual no
                 se tenga recaudo de los suscriptores.

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  Jorgemg  17/08/2012  Se agrega la validacion del tipo de movimiento
                       para efectos de contabilizacion de las reversiones  
                       del control reintegro asociadas al tipo de movimiento
                       771.
  Jorgemg  11/02/2013  Se modifica la generacion de la trama para reportar
                       por el campo de fecha de aplicacion no por fecha de
                       legalizacion del movimineto de ccrc                     

  ************************************************************************/
IS
  
  --<<
  --Lista de asientos contables que se van a enviar a sap
  -->>
  CURSOR cuAsientos(dtFini IN VARCHAR2,
                    dtFFin IN varchar2)
  IS
  SELECT A.ASIECONS, TO_DATE(A.ASIEFEAPL,'DD/MM/YYYY') ASIEFEAPL
    FROM ASIENTO_SAP A, CAUXASIE_SAP B
   WHERE A.ASIEDIST = B.CXASDISA
     AND A.ASIETIMV = B.CXASTIMV
     AND A.ASIECONS = B.CXASCONS
     AND A.ASIETIMV = ldc_pkinterfazsurti.nuTIPOMOVCONSIG  
     and A.DOCENVIO_SAP IS NULL
     --AND A.ASIECONS = 365876
     AND TRUNC(A.ASIEFECH) BETWEEN to_date(dtFini,'DD/MM/YYYY') AND to_date(dtFFin,'DD/MM/YYYY') 
     and (a.asiedist, a.asietimv, a.asiecons) in (select mvcbdisa, mvcbtmad, mvcbcasi from movicuba_sap)
  GROUP BY A.ASIECONS, ASIEFEAPL
  ORDER BY TO_DATE(A.ASIEFEAPL,'DD/MM/YYYY') ASC, A.ASIECONS;

  TYPE tycuAsientos IS TABLE OF cuAsientos%ROWTYPE INDEX BY BINARY_INTEGER;
  vtycuAsientos tycuAsientos;
  
  --<<
  --Informacion del asiento contable, tipo 313 que corresponde al tipo de todas
  --las consignaciones que se realizan que para el caso de surtigas solo aplicarian
  --para los recaudadores no financieros.
  -->>
  /*
  CURSOR cuConsignaciones(nuAsiento     ASIENTO_SAP.ASIECONS%type)
  IS
  SELECT A.ASIECONS, TRUNC(A.ASIEFECH) ASIEFECH, A.ASIETIMV, A.ASIEUNAD, B.CXASDISA, B.CXASNIT,
           B.CXASAGEN, B.CXASCTA, B.CXASNATU, TRUNC(SUM(B.CXASVLOR)) VALOR
    FROM ASIENTO_SAP A, CAUXASIE_SAP B
    WHERE A.ASIEDIST = B.CXASDISA
      AND A.ASIETIMV = B.CXASTIMV
      AND A.ASIECONS = B.CXASCONS
      and A.ASIECONS = nuAsiento
    GROUP BY A.ASIECONS, TRUNC(A.ASIEFECH), A.ASIETIMV, A.ASIEUNAD, B.CXASDISA, B.CXASAGEN, B.CXASNIT, B.CXASAGEN, B.CXASCTA, B.CXASNATU
    ORDER BY A.ASIECONS;
  */
  --<<
  -- Jorgemg - ArquitecSoft
  -- Fecha: 11/02/2013
  -- Cambio de la fecha de legalizacion del comando CCRC por 
  -- la fecha del movimiento realizado
  -->>
  CURSOR cuConsignaciones(nuAsiento     ASIENTO_SAP.ASIECONS%type)
  IS
  SELECT A.ASIECONS, TRUNC(A.ASIEFEAPL) ASIEFECH, A.ASIETIMV, A.ASIEUNAD, B.CXASDISA, B.CXASNIT,
           B.CXASAGEN, B.CXAS1DIG||B.CXAS2DIG||B.CXAS34DIG||B.CXAS56DIG CXASCTA, 
           B.CXASNATU, TRUNC(SUM(B.CXASVLOR)) VALOR
    FROM ASIENTO_SAP A, CAUXASIE_SAP B
    WHERE A.ASIEDIST = B.CXASDISA
      AND A.ASIETIMV = B.CXASTIMV
      AND A.ASIECONS = B.CXASCONS
      and A.ASIECONS = nuAsiento
    GROUP BY A.ASIECONS, TRUNC(A.ASIEFEAPL), A.ASIETIMV, A.ASIEUNAD, B.CXASDISA, B.CXASAGEN, 
             B.CXASNIT, B.CXASAGEN, B.CXAS1DIG||B.CXAS2DIG||B.CXAS34DIG||B.CXAS56DIG, B.CXASNATU
    ORDER BY A.ASIECONS;
    
  TYPE tycuConsignaciones IS TABLE OF cuConsignaciones%ROWTYPE INDEX BY BINARY_INTEGER;
  vtycuConsignaciones tycuConsignaciones;

  --<<
  --informacion de los centros de beneficio y segmentos
  -->>
  CURSOR cuUbicacion(vaUnid    asiento_sap.asieunad%type)
  IS
  SELECT COD_CENTROBENEF
    FROM UNIDADMI, LOCALIDA, LDC_CENTBENELOCA
   WHERE UNADDEPA = LOCADEPA
     AND UNADLOCA = LOCACODI
     AND COD_DEPARTAMENTO = LOCADEPA
     AND COD_LOCALIDAD    = LOCACODI
     AND UNADCODI = vaUnid;

  --<<
  --Cursor para seleccionar la informacion de la entidad no financiera
  -->>
  CURSOR cuBanco (vaNit    banco.bancnit%type)
  is
  SELECT * FROM BANCO
   WHERE bancnit = vaNit;

  TYPE tycuBanco IS TABLE OF cuBanco%ROWTYPE INDEX BY BINARY_INTEGER;
  vtycuBanco tycuBanco;

  --<<
  --informacion para obtener la clave de contabilizacion
  -->>
  CURSOR cuCUCOTIMV_SAP(vaCuenta     CUCOTIMV_SAP.CCTMCUEN_SAP%type,
                        vaCCTMTIMV   CUCOTIMV_SAP.CCTMTIMV%type,
                        vaCCTMDECR   CUCOTIMV_SAP.CCTMDECR%type)
  IS
  SELECT CCTMCLAV_SAP, CCTMCUEN_SAP FROM CUCOTIMV_SAP
  WHERE CCTMTIMV                 = vaCCTMTIMV
    AND CCTM1DIG||CCTM2DIG||CCTM34DIG||CCTM56DIG = vaCuenta
    and CCTMDECR                 = vaCCTMDECR;

  vtycuCUCOTIMV_SAP    cuCUCOTIMV_SAP%ROWTYPE;
  
  --<<
  --Obtencion de la informacion de las entidades financieras donde se consigna el recaudo
  -->>
  --<<
  -- Jorgemg - ArquitecSoft
  -- Se adiciona el campo COD_CENTROBENEF, para obtener el centro de beneficio
  -- asociado a la entidad financiera de tipo de control reintegro.
  -->>
  CURSOR cuEntRecaudo(vaSubacuba     SUCUBANC.SUBACUBA%TYPE)
  IS
  SELECT BANCNIT, BANCNOMB, SUBACUCO, COD_CENTROBENEF  
    FROM SUCUBANC, BANCO, LDC_CENTBENELOCA
   WHERE SUBABANC = BANCCODI
     AND BANCTIPO = ldc_pkinterfazsurti.vaTIPORECACTRLREIN
     AND SUBADEPA = COD_DEPARTAMENTO
     AND SUBALOCA = COD_LOCALIDAD
     AND SUBACUBA = vaSubacuba          
     AND ROWNUM = 1;          
  
  vtycuEntRecaudo   cuEntRecaudo%ROWTYPE;
   
  --<<
  --Es necesario consultas el movimeinto de la cuenta bancaria
  -->>
  cursor cuCuenta(nuAsiento      ASIENTO_SAP.ASIECONS%TYPE)
  is 
  SELECT mvcbcuba, MVCBFECH 
    FROM ASIENTO_SAP A, MOVICUBA_SAP B
    WHERE A.ASIEDIST = B.MVCBDISA
      AND A.ASIETIMV = B.MVCBTMAD
      AND A.ASIECONS = B.MVCBCASI 
      AND A.ASIETIMV = ldc_pkinterfazsurti.nuTIPOMOVCONSIG
      AND A.ASIECONS = nuAsiento;
  
  vtycuCuenta      cuCuenta%rowtype;
      
 
  vaCod_centrobenef ldc_centrobenef.cod_centrobenef%type;
  nuRet             NUMBER;
  nuCont            NUMBER := 0;--variable para detallar por consignacion.
  vaNITCTAENTFIN    VARCHAR2(20);
  vaCTADIVERGENTE   VARCHAR2(20);
  vaRet             VARCHAR2(1);
  vaBancNomb        banco.bancnomb%type;
  vaNit             banco.bancnit%type;
  vaContabiliza     varchar2(1) := 'S';
  vaAsignacion      ldc_detaintesap.asignacn%type; 
  dtFechaConsi      MOVICUBA_SAP.MVCBFECH%type;
  nuTipoDoco        tipodoco.tidccodi%TYPE := 0;
  sbNombre          VARCHAR2(2000) := NULL;
  
BEGIN

  --<<
  --Parametros
  -->>
  provapatapa('CODDOCUINTCONREI', 'S', nuComodin, ldc_pkinterfazsurti.vaCODDOCUINTCONREI);
  provapatapa('CODDOCCONREIGAS', 'N', ldc_pkinterfazsurti.nuCODDOCCONREIGAS, vaComodin);
  provapatapa('GRLEDGER', 'S', nuComodin, ldc_pkinterfazsurti.vaGRLEDGER);
  provapatapa('SOCIEDAD', 'S', nuComodin, ldc_pkinterfazsurti.vaSOCIEDAD);
  provapatapa('CURRENCY', 'S', nuComodin, ldc_pkinterfazsurti.vaCURRENCY);
  provapatapa('DOCUMENTO_CTRL-REINTEGRO', 'N', nuTipoDoco, vaComodin);
  provapatapa('CEBE_GENERAL', 'S', nuComodin, ldc_pkinterfazsurti.vaCEBE_GENERAL);
  provapatapa('TIPORECACTRLREIN', 'S', nuComodin, ldc_pkinterfazsurti.vaTIPORECACTRLREIN);
  provapatapa('GENDOCU_ENVIA_SAP', 'S', nuComodin, ldc_pkinterfazsurti.vaGENDOCU_ENVIA_SAP);
  
  --<<
  -- Jorgemg - ArquitecSoft
  -- Fecha: 17/08/2012
  -- Se valida el tipo de doucumento que se esta procesando
  -- para poder identificar el tipo de movimiento financiero a realizar
  -->>
  
  IF (pkinterfaz.rgCuenTiDo.cutdtido = nuTipoDoco) THEN
    
       --<<
       -- Movimiento Control Reintegro        
       -->>
       provapatapa('TIPOMOVCONSIG', 'N', ldc_pkinterfazsurti.nuTIPOMOVCONSIG, vaComodin);
       sbNombre := 'CRTL_REIN-';
       
  ELSE
    
       --<<
       -- Movimiento Reversion Control Reintegro        
       -->>       
       provapatapa('TIPOMOVREVCONSIG', 'N', ldc_pkinterfazsurti.nuTIPOMOVCONSIG, vaComodin); 
       sbNombre := 'REVER_CRTL_REIN-';      
    
  END IF;
  
  --<<
  -- 
  -->>
  
  --<<
  --Seteo el tipo de documento
  -->>
  ldc_pkinterfazsurti.vaCODINTINTERFAZ := ldc_pkinterfazsurti.vaCODDOCUINTCONREI;
  
  pkregidepu.pRegiMensaje('LDC_PKINTERFAZSURTI.NUTIPOMOVCONSIG:',ldc_pkinterfazsurti.NUTIPOMOVCONSIG,'CRREIN');
  
  
  OPEN cuAsientos(TO_CHAR(dtFechaIni,'DD/MM/YYYY'), TO_CHAR(dtFechaFin,'DD/MM/YYYY'));
  FETCH cuAsientos BULK COLLECT INTO vtycuAsientos;
  CLOSE cuAsientos;
  
  pkregidepu.pRegiMensaje('vtycuAsientos.COUNT:',vtycuAsientos.COUNT,'CRREIN');
  IF (vtycuAsientos.COUNT > 0) THEN
    
    --<<
    --Se recorren todos los asientos del dia y los procesa para que se pueda enviar la informacion a sap
    --asiento contable por asiento contable
    -->>
    FOR w IN vtycuAsientos.FIRST..vtycuAsientos.LAST LOOP
      
      nuAsiecons := vtycuAsientos(w).ASIECONS;
      --<<
      --Obtencion de los datos de las consignaciones para el control reintegro
      -->>
      open cuConsignaciones(vtycuAsientos(w).ASIECONS);
      fetch cuConsignaciones BULK COLLECT INTO vtycuConsignaciones;
      close cuconsignaciones;
      
      pkregidepu.pRegiMensaje('vtycuConsignaciones.COUNT:',vtycuConsignaciones.COUNT,'CRREIN');
    
      --<<
      --Valido que existan consignaciones para realizar los asientos contables
      -->>
      IF (vtycuConsignaciones.COUNT > 0) THEN
    
        --<<
        --Selecciono el consecutivo de la interfaz que se va a generar
        -->>
        ldc_pkinterfazsurti.nuSeqICLINUDO := ldc_pkinterfazsurti.fnuSeq_ldc_incoliqu;
    
        --<<
        --Recorro el cursos para obtener la informacion a procesar
        -->>
        FOR i IN vtycuConsignaciones.FIRST..vtycuConsignaciones.LAST LOOP
    
            nuCont := nuCont + 1;
            --<<
            --Selecciono la configuracion del movimiento financiero
            -->>
            OPEN CUCUCOTIMV_SAP(substr(vtycuConsignaciones(I).CXASCTA,0,6), 
                                ldc_pkinterfazsurti.nuTIPOMOVCONSIG,
                                vtycuConsignaciones(i).CXASNATU);
            FETCH cucucotimv_sap INTO VTYCUCUCOTIMV_SAP;
            CLOSE cucucotimv_sap;
            
            pkregidepu.pRegiMensaje('vtycuCUCOTIMV_SAP.CCTMCLAV_SAP',vtycuCUCOTIMV_SAP.CCTMCLAV_SAP,'CRREIN');
            --<<
            --Determino si la clave contable es para manejo de cuenta divergente si
            --la clave de contabilizacion es para manejo de divergente
            -->>
            vaRet := pkinterfazSAP.fnuCtaDiver(vtycuCUCOTIMV_SAP.CCTMCLAV_SAP);
            
            pkregidepu.pRegiMensaje('vtycuCUCOTIMV_SAP.CCTMCLAV_SAP vaRet',vaRet,'CRREIN');
       
            --<<
            --Es una cuenta divergente
            -->>
            IF (vaRet <> 'N') THEN
               --<<
               --Es una cuenta divergente, esto significa que se debe manejar por recaudador,
               --con esto se debe determinar si el centro de beneficio es centralizado
               --o corresponde a la localidad
               -->>
               pkregidepu.pRegiMensaje('vtycuConsignaciones(i).CXASNIT:',VTYCUCONSIGNACIONES(I).CXASNIT,'CRREIN');
               open cuBanco(vtycuConsignaciones(i).CXASNIT);
               fetch cuBanco BULK COLLECT INTO vtycuBanco;
               close cuBanco;
               
               pkregidepu.pRegiMensaje('vtycuBanco:',vtycuBanco.count,'CRREIN');
           
               --<<
               --Si el centro de beneficio es centralizado lo saca de un parametro de los
               --lo genera a partir de la agencia
               -->> 
               IF (VTYCUBANCO.COUNT > 0) THEN
                  FOR H IN VTYCUBANCO.FIRST..VTYCUBANCO.LAST LOOP

                    vaBancNomb := vtycuBanco(h).bancnomb;

                    IF (vtycuBanco(h).BANCCENT = 'S') THEN
                        vaCod_centrobenef := ldc_pkinterfazsurti.vaCEBE_GENERAL;
                    ELSE
                        open cuUbicacion(vtycuConsignaciones(i).ASIEUNAD);
                        fetch cuUbicacion into vaCod_centrobenef;
                        close cuUbicacion;
                    END IF;
                  END LOOP; 
               else 
                  vaContabiliza := 'N';   
               END IF;     
               
               vaNitCtaEntFin  := vtycuConsignaciones(i).CXASNIT;
               vaCtaDivergente := VTYCUCUCOTIMV_SAP.CCTMCUEN_SAP;
               vaNit           := vtycuConsignaciones(i).CXASNIT;
               vaAsignacion    := vtycuConsignaciones(i).CXASNIT;
               dtFechaConsi    := vtycuConsignaciones(i).ASIEFECH;

            ELSE
               
--               pkregidepu.pRegiMensaje('vtycuAsientos(w).ASIECONS:',vtycuAsientos(w).ASIECONS,'CRREIN');
               --<<
               --Obtiene la cuenta bancaria en al que se hizo la consignacion
               -->>
               open cuCuenta(vtycuAsientos(w).ASIECONS);
               fetch cuCuenta into vtycuCuenta;
               close cuCuenta;
               
--               pkregidepu.pRegiMensaje('vtycuCuenta.mvcbcuba:',vtycuCuenta.mvcbcuba,'CRREIN');
               --<<
               --Busca el nit de la entidad financiera en la cual se realizo la consignacion
               -->>
               open cuEntRecaudo(vtycuCuenta.mvcbcuba);
               fetch cuEntRecaudo into vtycuEntRecaudo;
               close cuEntRecaudo;
               
--               pkregidepu.pRegiMensaje('vtycuEntRecaudo.bancnit:',vtycuEntRecaudo.bancnit,'CRREIN');
--               pkregidepu.pRegiMensaje('vtycuEntRecaudo.bancnomb:',vtycuEntRecaudo.bancnomb,'CRREIN');
--               pkregidepu.pRegiMensaje('vtycuEntRecaudo.SUBACUCO:',vtycuEntRecaudo.SUBACUCO,'CRREIN');
                        
               vaNit           := vtycuEntRecaudo.bancnit;
               vaBancNomb      := vtycuEntRecaudo.bancnomb;
               vaNitCtaEntFin  := vtycuEntRecaudo.SUBACUCO;
               vaCtaDivergente := null;
               vaAsignacion    := vtycuEntRecaudo.bancnit;
               dtFechaConsi    := vtycuCuenta.MVCBFECH;
               --<<
               -- Jorgemg - ArquitecSoft 
               -- Fecha: 13-06-2012
               -- Se adiciona el codigo de centro de beneficio.
               -->>
               vaCod_centrobenef := vtycuEntRecaudo.Cod_Centrobenef;
               
            END IF;


            --<<
            --Registra el asiento contable en LDC_INCOLIQU
            -->> 
            nuRet := ldc_pkinterfazsurti.fnuLDC_INCOLIQU(ldc_pkinterfazsurti.nuCODDOCCONREIGAS,
                                                         ldc_pkinterfazsurti.nuSeqICLINUDO,
                                                         SYSDATE,
                                                         USER,
                                                         'SERVER',
                                                         vtycuConsignaciones(i).ASIEFECH,--,
                                                         vaCod_centrobenef,
                                                         -1,
                                                         nuCont,
                                                         vtycuCUCOTIMV_SAP.CCTMCLAV_SAP,
                                                         vaNitCtaEntFin,
                                                         NULL,
                                                         vtycuConsignaciones(i).VALOR,
                                                         vtycuConsignaciones(i).VALOR,
                                                         NULL,
                                                         NULL,
                                                         NULL,
                                                         NULL,
                                                         NULL,
                                                         NULL,
                                                         NULL,
                                                         NULL,
                                                         vaAsignacion,
                                                         sbNombre||vtycuConsignaciones(i).ASIEFECH||'-'||ldc_pkinterfazsurti.nuSeqICLINUDO||'-'||vtycuAsientos(w).asiecons,
                                                         vaCod_centrobenef,
                                                         NULL,
                                                         NULL,
                                                         vaNit,
                                                         NULL,
                                                         vaBancNomb,
                                                         NULL,
                                                         NULL,
                                                         NULL,
                                                         NULL,
                                                         NULL,
                                                         i,
                                                         vtycuConsignaciones(i).ASIEFECH,--vtycuConsignaciones(i).ASIEFECH,
                                                         vaCtaDivergente);
    
             IF (nuRet <> 0) THEN
                 raise Error;
             END IF;
    
        END LOOP;
    
        --<<
        --Insercion de los datos de la tabla
        --ldc_incoliqu
        -->>
        nuRet     := ldc_pkinterfazsurti.fnuINSELDC_INCOLIQU;
        if (nuRet <> 0) then
          raise Error;
        END IF;
      
        --<<
        --Genera la informacion de los documentos para SAP
        -->>
        nuRet     := ldc_pkinterfazsurti.fnuGeneDocuSap(ldc_pkinterfazsurti.nuSeqICLINUDO);
        if (nuRet <> 0) then
          raise Error;
        end if;
        
        --<<
        --Se verifica que sea posible enviar el asiento contable
        -->>
        if (vaContabiliza = 'S') THEN
          --<<
          --Envio de la informacion a traves del web service creado para este proceso
          -->>    
          IF (ldc_pkinterfazsurti.vaGENDOCU_ENVIA_SAP = 'S') THEN
              
              NULL;--LDC_PKINTERCONTABLEMESA.proEnviaDocContable(ldc_pkinterfazsurti.nuSeqICLINUDO);
          END IF;
        
          --<<
          --Actualiza los asientos contables, con el codigo que se envio a sap
          -->>
          nuRet := ldc_pkinterfazsurti.fnuUpdAsiento(vtycuAsientos(w).ASIECONS,
                                                   ldc_pkinterfazsurti.nuSeqICLINUDO);
                       
          if (nuRet <> 0) then  
              ldc_pkinterfazsurti.vaMensError := 'Error actualizando los asientos contables con el codigo de envio a SAP';
              raise Error;
          end if;               
          --<<
          --Elimina la tabla en memoria de las consignaciones
          -->>
          vtycuConsignaciones.DELETE;
          
        end if;
        
      END IF;
      
      vaContabiliza := 'S';
      
     END LOOP;
  END IF;
  
  --<<
  --Elimina todas las tablas teporales que estan en memoria
  -->>
  vtycuConsignaciones.DELETE;
  vtycuAsientos.DELETE;
  vtyLDC_ENCAINTESAP.DELETE;
  vtyLDC_DETAINTESAP.DELETE;
  vtyLDC_INCOLIQU.DELETE;
  
  RETURN(0);
exception
WHEN ERROR THEN
  ldc_pkinterfazsurti.vaMensError := ldc_pkinterfazsurti.vaMensError||'-'||'[fnuControlReintegro] - Error procesando la interfaz de control reintegro. '||sqlerrm;
  pkregidepu.pRegiMensaje('ldc_pkinterfazsurti.vaMensError',ldc_pkinterfazsurti.vaMensError,'CRREIN');
  vtycuConsignaciones.DELETE;
  vtycuAsientos.DELETE;
  vtyLDC_ENCAINTESAP.DELETE;
  vtyLDC_DETAINTESAP.DELETE;
  vtyLDC_INCOLIQU.DELETE;
  return(-1);
WHEN OTHERS THEN
  ldc_pkinterfazsurti.vaMensError := ldc_pkinterfazsurti.vaMensError||'-'||'[fnuControlReintegro] - Error procesando la interfaz de control reintegro. '||sqlerrm;
  pkregidepu.pRegiMensaje('ldc_pkinterfazsurti.vaMensError',ldc_pkinterfazsurti.vaMensError,'CRREIN');
  vtycuConsignaciones.DELETE;
  vtycuAsientos.DELETE;
  vtyLDC_ENCAINTESAP.DELETE;
  vtyLDC_DETAINTESAP.DELETE;
  vtyLDC_INCOLIQU.DELETE;
  return(-1);
END fnuControlReintegro;

-------------->>>>>>
FUNCTION fnuComiReca(dtFechaIni IN DATE,
                     dtFechaFin in date)
return number
  /************************************************************************
  PROPIEDAD INTELECTUAL DE GASES DE OCCIDENTE S.A E.S.P
  FUNCION   : fnuComiReca
  AUTOR     : Hector Javier Cuervo Ramirez
  FECHA     : 25-03-2012
  DESCRIPCION  : funcion que se encarga de armar el resumen de la interfaz
                 de contabilizacion de la comision de los recaudadores.

                 Se selecciona la informacion del asiento contable (ASIENTO_SAP)
                 a partir de la fecha de creacion del registro.
               
                 Se homologan las cuentas de acuerdo a la configuracion del asiento
                 en CUCOTIMV_SAP.

                 Se debe validar con resoreria si actualmente existe algun
                 punto de reacudo que me consigne en un banco sobre el cual no
                 se tenga recaudo de los suscriptores.

                 Registro del inidcador de IVA
                 vaINDICIVA codigo del indicador Iva
                 nuBASEIMPT el valor del base del calculo

                 Registro de la retencion
                 vaTIPORETC codigo del tipo de retencion
                 vaINDRETEC codigo del indicador
                 nuBASERETC base de la retencion

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  jorgemg  18/02/2013  Se adiciona control para que cada movimiento de 
                       asiento_sap sea reportado independientemente y no
                       consolidado.
                       
  Historia de Modificaciones
  Autor       Fecha       Descripcion
  jrgallego   15/04/2013  Se adiciona un parametro para determinar el valor 
                          del recuado de la orden interna de Olimpica                    
                       
  ************************************************************************/
IS

  --<<
  -- Jorgemg - ArquitecSoft
  -- Fecha: 18/02/2013 
  -- Cursor para proceso solo por movimiento SAP
  -->>
  CURSOR cuAsiento_SAP(dtFini IN VARCHAR2,
                       dtFFin IN varchar2)
      IS
  SELECT * FROM asiento_sap a
   WHERE a.asietimv = ldc_pkinterfazsurti.nuTIPOMOVCONSIGOLI  
     AND a.asiedebi IS NOT NULL
     AND a.asiecred IS NOT NULL
     AND a.docenvio_sap IS NULL
     AND TRUNC(a.asiefech) BETWEEN TO_DATE(dtFini,'DD/MM/YYYY') AND TO_DATE(dtFFin,'DD/MM/YYYY')
     ORDER BY a.asiecons, a.asiefeapl, a.asiefech;

  TYPE tycuAsiento_SAP IS TABLE OF cuAsiento_SAP%ROWTYPE INDEX BY BINARY_INTEGER;
  vtycuAsiento_SAP tycuAsiento_SAP;     

  --<<
  --Nits que se cobran la comision
  -->>
  CURSOR cuNitsComision(dtFini IN VARCHAR2,
                        dtFFin IN VARCHAR2,
                        nuCons IN asiento_sap.asiecons%TYPE)
  IS
  SELECT A.ASIENIT
    FROM ASIENTO_SAP A, CAUXASIE_SAP B
   WHERE A.ASIEDIST = B.CXASDISA
     AND A.ASIETIMV = B.CXASTIMV
     AND A.ASIECONS = B.CXASCONS
     AND A.ASIETIMV = ldc_pkinterfazsurti.nuTIPOMOVCONSIGOLI  
     AND A.ASIECONS = nuCons
     AND A.DOCENVIO_SAP IS NULL
     AND A.ASIEDEBI IS NOT NULL
     AND A.ASIECRED IS NOT NULL
     AND TRUNC(A.ASIEFECH) BETWEEN TO_DATE(DTFINI,'DD/MM/YYYY') AND TO_DATE(DTFFIN,'DD/MM/YYYY')
   GROUP BY A.ASIENIT;

  TYPE tycuNitsComision IS TABLE OF cuNitsComision%ROWTYPE INDEX BY BINARY_INTEGER;
  vtycuNitsComision tycuNitsComision;

  --<<
  --Distribucion de la cantidad de cupones afectadas por las consignaciones
  --que se registraron de olimpica
  -->>
  CURSOR cuDistCupo(dtFini IN VARCHAR2,
                    dtFFin IN varchar2,
                    vaNit  IN ASIENTO_SAP.ASIENIT%TYPE)
  IS
  SELECT COD_CENTROBENEF, SUM(CUPONES) CUPONES
    FROM LDC_CENTBENELOCA, (
    SELECT S.SUSCDEPA DEPA, S.SUSCLOCA LOCA, COUNT(DISTINCT pagocupo) CUPONES
     FROM ASIENTO_SAP A, MOVICUBA_SAP B, MVFCMVCB_SAP C, CONCFJCA D, PAGOS E, SERVSUSC F, SUSCRIPC S
    WHERE A.ASIEDIST = B.MVCBDISA
      AND A.ASIETIMV = B.MVCBTMAD
      AND A.ASIECONS = B.MVCBCASI 
      AND B.MVCBDIST = C.MFMBMVCBD
      AND B.MVCBCONS = C.MFMBMVCBN 
      AND C.MFMBMVFCD = D.COFLDIMF
      AND C.MFMBMVFCN = D.COFLCOMF
      AND D.COFLBANC = E.PAGOBANC
      AND D.COFLSUBA = E.PAGOSUBA
      AND D.COFLCONC = E.PAGOCONC
      AND F.SESUSUSC = S.SUSCCODI
      AND F.sesunuse = E.pagonuse 
      AND A.ASIETIMV = ldc_pkinterfazsurti.nuTIPOMOVCONSIG
      AND A.ASIENIT = vaNit
      AND A.ASIEFECH BETWEEN to_date(DTFINI||' 00:00:00','DD/MM/YYYY HH24:MI:SS') AND to_date(DTFFIN||' 23:59:59','DD/MM/YYYY HH24:MI:SS')      
    GROUP BY S.SUSCDEPA, S.SUSCLOCA)
    WHERE DEPA = COD_DEPARTAMENTO(+)
      AND LOCA = COD_LOCALIDAD(+)
    GROUP BY  COD_CENTROBENEF;

  TYPE tycuDistCupo IS TABLE OF cuDistCupo%ROWTYPE INDEX BY BINARY_INTEGER;
  vtycuDistCupo tycuDistCupo;

  --<<
  --Tipo de dato en donde armo el porcentaje de distribucion por cebe
  -->>
  TYPE PORCCUPOCECO
      IS RECORD (               
         COD_CENTROBENEF  LDC_CENTBENELOCA.COD_CENTROBENEF%TYPE,
         porcentaje       number(5,2),
         valor            integer);

  TYPE tyPORCCUPOCECO IS TABLE OF PORCCUPOCECO INDEX BY BINARY_INTEGER;
  vtyPORCCUPOCECO tyPORCCUPOCECO;

  --<<
  --Informacion del asiento contable, tipo 527 que corresponde a las comisiones
  --que se pagan  por el recaudo
  -->>
  CURSOR cuAsientoComision(dtFini IN VARCHAR2,
                           dtFFin IN VARCHAR2,
                           nuCons IN asiento_sap.asiecons%TYPE)
  IS
  SELECT A.ASIEDIST, A.ASIETIMV, A.ASIECONS, A.ASIEUNAD, B.CXASDISA, B.CXASNIT,
         B.CXASAGEN, B.CXAS1DIG||B.CXAS2DIG||B.CXAS34DIG||B.CXAS56DIG CXASCTA, 
         B.CXASNATU, TRUNC(SUM(B.CXASVLOR)) VALOR
    FROM ASIENTO_SAP A, CAUXASIE_SAP B
   WHERE A.ASIEDIST = B.CXASDISA
     AND A.ASIETIMV = B.CXASTIMV
     AND A.ASIECONS = B.CXASCONS
     AND A.ASIEDEBI IS NOT NULL
     AND A.ASIECRED IS NOT NULL
     AND A.ASIECONS = nuCons
     AND A.ASIETIMV = ldc_pkinterfazsurti.nuTIPOMOVCONSIGOLI
     AND TRUNC(A.ASIEFECH) BETWEEN TO_DATE(DTFINI,'DD/MM/YYYY') AND TO_DATE(DTFFIN,'DD/MM/YYYY')
   GROUP BY A.ASIEDIST, A.ASIETIMV, A.ASIECONS, A.ASIEUNAD, B.CXASDISA, B.CXASAGEN, B.CXASNIT, B.CXASAGEN, 
            B.CXAS1DIG||B.CXAS2DIG||B.CXAS34DIG||B.CXAS56DIG, B.CXASNATU
   ORDER BY A.ASIECONS;

  TYPE tycuAsientoComision IS TABLE OF cuAsientoComision%ROWTYPE INDEX BY BINARY_INTEGER;
  vtycuAsientoComision tycuAsientoComision;

  --<<
  --Informacion de los centros de beneficio
  -->>
  CURSOR cuUbicacion(vaUnid    asiento_sap.asieunad%type)
  IS
  SELECT COD_CENTROBENEF
    FROM UNIDADMI, LOCALIDA, LDC_CENTBENELOCA
   WHERE UNADDEPA = LOCADEPA
     AND UNADLOCA = LOCACODI
     AND COD_DEPARTAMENTO = LOCADEPA
     AND COD_LOCALIDAD    = LOCACODI
     AND UNADCODI = vaUnid;

  --<<
  --informacion para obtener la clave de contabilizacion
  -->>
  CURSOR cuCUCOTIMV_SAP(vaCuenta     CUCOTIMV_SAP.CCTMCUEN_SAP%type,
                        vaCCTMTIMV   CUCOTIMV_SAP.CCTMTIMV%type,
                        vaCCTMDECR   CUCOTIMV_SAP.CCTMDECR%type)
  IS
  SELECT CCTMCUEN_SAP, CCTMCLAV_SAP, CCTMINRE_SAP, CCTMTIRE_SAP
    FROM CUCOTIMV_SAP
   WHERE CCTMTIMV                 = vaCCTMTIMV
     AND CCTM1DIG||CCTM2DIG||CCTM34DIG||CCTM56DIG = vaCUENTA
     and CCTMDECR                 = vaCCTMDECR;

  TYPE tycuCUCOTIMV_SAP IS TABLE OF cuCUCOTIMV_SAP%ROWTYPE INDEX BY BINARY_INTEGER;
  vtycuCUCOTIMV_SAP tycuCUCOTIMV_SAP;

  --<<
  --Informacion complementaria de la cuenta contable
  -->>
  CURSOR cuLDC_CUENTACONTABLE(vaCOD_CUENTACONTABLE    LDC_CUENTACONTABLE.COD_CUENTACONTABLE%TYPE)
  IS
  SELECT * FROM LDC_CUENTACONTABLE
  WHERE COD_CUENTACONTABLE = vaCOD_CUENTACONTABLE;

  TYPE tycuLDC_CUENTACONTABLE IS TABLE OF cuLDC_CUENTACONTABLE%ROWTYPE INDEX BY BINARY_INTEGER;
  vtycuLDC_CUENTACONTABLE tycuLDC_CUENTACONTABLE;

  --<<
  --Cursor que obtiene el porcentaje de la tarifa del indicador
  -->>
  CURSOR cuLDC_INDICADOR(vaCOD_TIPORETENC   LDC_INDICADOR.COD_TIPORETENC%type,
                         VACOD_INDICADOR    LDC_INDICADOR.COD_INDICADOR%TYPE)
  IS
  SELECT * FROM LDC_INDICADOR
   WHERE COD_TIPORETENC = vaCOD_TIPORETENC
    and COD_INDICADOR   = vaCOD_INDICADOR;

  VACULDC_INDICADOR  CULDC_INDICADOR%ROWTYPE;
  
  vaCod_centrobenef ldc_centrobenef.cod_centrobenef%type;
  nuRet             NUMBER;
  nuCont            NUMBER := 0;--variable para detallar por consignacion.
  vaCTADIVERGENTE   VARCHAR2(20);
  vaRet             VARCHAR2(10);
  VANITCTA          VARCHAR2(20);
  vaIndicador       LDC_INDICADOR.COD_INDICADOR%TYPE;
  vaTiporeten       LDC_INDICADOR.COD_TIPORETENC%TYPE;
  vaINDICIVA        ldc_incoliqu.INDICIVA%type;
  nuBASEIMPT        ldc_incoliqu.BASEIMPT%type;
  vaTIPORETC        ldc_incoliqu.TIPORETC%type;
  vaINDRETEC        ldc_incoliqu.INDRETEC%type;
  NUBASERETC        LDC_INCOLIQU.BASERETC%TYPE;
  VANIT             VARCHAR2(20);
  nuTotalCupon      NUMBER := 0;
  nuTotalDistri     INTEGER := 0;
  vaCentrMayor      ldc_centrobenef.cod_centrobenef%type;
  nuCantCupo        NUMBER := 0;
  sbCodRecaOlim     VARCHAR2(20) := NULL;

BEGIN

  --<<
  --Parametros

  --<<
  -- jrgallego - ArquitecSoft
  -- Fecha: 15/04/2013 
  -- Parametro para determinar el valor del recuado de la orden interna
  -- de Olimpica
  -->>
  provapatapa('COD_RECA_OLIM_OI','S',nuComodin, sbCodRecaOlim);
  provapatapa('CODDOCUINTCONREI', 'S', nuComodin, ldc_pkinterfazsurti.vaCODDOCUINTCONREI);
  provapatapa('CODDOCCONREIGAS', 'N', ldc_pkinterfazsurti.nuCODDOCCONREIGAS, vaComodin);
  provapatapa('GRLEDGER', 'S', nuComodin, ldc_pkinterfazsurti.vaGRLEDGER);
  provapatapa('SOCIEDAD', 'S', nuComodin, ldc_pkinterfazsurti.vaSOCIEDAD);
  provapatapa('CURRENCY', 'S', nuComodin, ldc_pkinterfazsurti.vaCURRENCY);
  provapatapa('TIPOMOVCONSIGOLI', 'N', ldc_pkinterfazsurti.nuTIPOMOVCONSIGOLI, vaComodin);
  provapatapa('CEBE_GENERAL', 'S', nuComodin, ldc_pkinterfazsurti.vaCEBE_GENERAL);
  provapatapa('GENDOCU_ENVIA_SAP', 'S', nuComodin, ldc_pkinterfazsurti.vaGENDOCU_ENVIA_SAP);
  provapatapa('TIPOMOVCONSIG', 'N', ldc_pkinterfazsurti.nuTIPOMOVCONSIG, vaComodin);

  --<<
  --Seteo el tipo de documento
  -->>
  ldc_pkinterfazsurti.vaCODINTINTERFAZ := ldc_pkinterfazsurti.vaCODDOCUINTCONREI;
  
  --<<
  -- Jorgemg - ArquitecSoft
  -- Obtencion de los asiento_sap de la comision
  -->>
  open cuAsiento_SAP(to_char(dtFechaIni,'DD/MM/YYYY'), to_char(dtFechaFin,'DD/MM/YYYY'));
  fetch cuAsiento_SAP BULK COLLECT INTO vtycuAsiento_SAP;
  close cuAsiento_SAP;
  
  IF(vtycuAsiento_SAP.COUNT > 0) THEN
  
      --<<
      --Recorro el cursos para obtener la informacion a procesar
      -->>
      FOR z IN vtycuAsiento_SAP.FIRST..vtycuAsiento_SAP.LAST LOOP  

          --<<
          --Obtencion de los datos de las comisiones
          -->>
          open cuAsientoComision(to_char(dtFechaIni,'DD/MM/YYYY'), to_char(dtFechaFin,'DD/MM/YYYY'),vtycuAsiento_SAP(z).asiecons);
          fetch cuAsientoComision BULK COLLECT INTO vtycuAsientoComision;
          close cuAsientoComision;

          --<<
          --Valido que existan consignaciones para realizar los asientos contables
          -->>
          IF (vtycuAsientoComision.COUNT > 0) THEN

            --<<
            --Selecciono el consecutivo de la interfaz que se va a generar, se toma como
            --consecutivo el mismo codigo del asiento generado en gasplus
            -->>
            ldc_pkinterfazsurti.nuSeqICLINUDO := ldc_pkinterfazsurti.fnuSeq_ldc_incoliqu;

            --<<
            --Recorro el cursos para obtener la informacion a procesar
            -->>
            FOR i IN vtycuAsientoComision.FIRST..vtycuAsientoComision.LAST LOOP

               nuCont := nuCont + 1;

               --<<
               --Selecciono la configuracion del movimiento financiero
               -->>
                   
               open cucucotimv_sap(SUBSTR(vtycuAsientoComision(I).CXASCTA,0,6),
                                   ldc_pkinterfazsurti.nuTIPOMOVCONSIGOLI,
                                   vtycuAsientoComision(i).CXASNATU);
               fetch cucucotimv_sap BULK COLLECT INTO VTYCUCUCOTIMV_SAP;
               close cucucotimv_sap;

               --pkregidepu.pRegiMensaje('VTYCUCUCOTIMV_SAP.COUNT:',VTYCUCUCOTIMV_SAP.COUNT,'CRREIN');
                   

               IF (VTYCUCUCOTIMV_SAP.COUNT > 0) THEN

                   FOR j IN VTYCUCUCOTIMV_SAP.first..VTYCUCUCOTIMV_SAP.last LOOP

                       --<<
                       --Determina el centro de beneficio
                       -->>
                       open cuUbicacion(vtycuAsientoComision(i).ASIEUNAD);
                       fetch cuUbicacion into vaCod_centrobenef;
                       close cuUbicacion;

                       --<<
                       --Determino si la clave contable es para manejo de cuenta divergente
                       -->>
                       vaRet := pkinterfazSAP.fnuCtaDiver(to_char(vtycuCUCOTIMV_SAP(j).CCTMCLAV_SAP));

                       --<<
                       --Es una cuenta divergente
                       -->>
                       IF (vaRet = 'S') THEN

                           vaNitCta        := VTYCUASIENTOCOMISION(I).CXASNIT;
                           vaNit           := VTYCUASIENTOCOMISION(I).CXASNIT;
                           vaCtaDivergente := VTYCUCUCOTIMV_SAP(J).CCTMCUEN_SAP;

                       ELSE

                           vaNitCta        := VTYCUCUCOTIMV_SAP(J).CCTMCUEN_SAP;
                           vaNit           := VTYCUASIENTOCOMISION(I).CXASNIT;
                           vaCtaDivergente := null;

                       END IF;

                       --<<
                       --Obtengo la informacion del tipo de cuenta contable, para determinar el manejo
                       --de las bases de los indicadores
                       -->>             
                       open cuLDC_CUENTACONTABLE(VTYCUCUCOTIMV_SAP(J).CCTMCUEN_SAP);
                       fetch cuLDC_CUENTACONTABLE BULK COLLECT INTO vtycuLDC_CUENTACONTABLE;
                       close cuLDC_CUENTACONTABLE;

                       --pkregidepu.pRegiMensaje('vtycuLDC_CUENTACONTABLE.COUNT:',vtycuLDC_CUENTACONTABLE.COUNT,'CRREIN');
                       IF (vtycuLDC_CUENTACONTABLE.COUNT > 0) THEN

                         FOR M IN vtycuLDC_CUENTACONTABLE.FIRST..vtycuLDC_CUENTACONTABLE.LAST LOOP

                           --<<
                           --Valido los asientos contables para el manejo de los indicadores
                           -->>
                           vaIndicador := vtycuCUCOTIMV_SAP(j).CCTMINRE_SAP;
                           vaTipoReten := vtycuCUCOTIMV_SAP(j).CCTMTIRE_SAP;

                           --<<
                           --Obtengo la informacion del porcentaje de cada indicador
                           -->>
                           OPEN cuLDC_INDICADOR(vaTipoReten, vaIndicador);
                           FETCH cuLDC_INDICADOR INTO vacuLDC_INDICADOR;
                           IF (cuLDC_INDICADOR%notfound) THEN
                               vacuLDC_INDICADOR.porcentaje := 100;
                           END IF;
                           CLOSE cuLDC_INDICADOR;

                           --<<
                           --Valido el tipo de las cuentas contables para saber como se maneja
                           --inidcador
                           -->>
                           IF (vtycuLDC_CUENTACONTABLE(M).TIPO_CUENTACONTABLE = 'B') THEN

                             --<<
                             --No lleva ningun tipo de indicadores
                             -->>
                             vaTIPORETC := null;
                             vaINDRETEC := null;
                             nuBASERETC := null;
                             vaINDICIVA := null;
                             nuBASEIMPT := null;

                           ELSIF (vtycuLDC_CUENTACONTABLE(M).TIPO_CUENTACONTABLE = 'I') THEN

                             --<<
                             --Significa que el valor es de IVA
                             -->>
                             vaINDICIVA := vaIndicador;
                             vaTIPORETC := null;
                             nuBASEIMPT := ROUND(vtycuAsientoComision(i).VALOR / (vacuLDC_INDICADOR.porcentaje/100));
                             vaINDRETEC := null;
                             nuBASERETC := null;

                           ELSIF (vtycuLDC_CUENTACONTABLE(M).TIPO_CUENTACONTABLE = 'R') THEN

                             --<<
                             --Ya son las retenciones que se deben aplicar
                             -->>
                             vaTIPORETC := vaTiporeten;
                             vaINDRETEC := vaIndicador;
                             nuBASERETC := ROUND(vtycuAsientoComision(i).VALOR / (vacuLDC_INDICADOR.porcentaje/100));
                             vaINDICIVA := null;
                             nuBASEIMPT := null;

                           END IF;

                           --<<
                           --Determina que no es la cuenta del costo y la inserta
                           -->>
                          IF (vaNitCta not like('7%')) THEN

                           --pkregidepu.pRegiMensaje('INSERTA:',vaNitCta,'CRREIN');
                             --<<
                             --Registra el asiento contable en LDC_INCOLIQU
                             -->>
                             --<<
                             --dbms_output.put_line('vtycuAsiento_SAP(i).asiefech: '||vtycuAsiento_SAP(i).asiefech);
                             
                             nuRet := ldc_pkinterfazsurti.fnuLDC_INCOLIQU( ldc_pkinterfazsurti.nuCODDOCCONREIGAS,
                                                                           ldc_pkinterfazsurti.nuSeqICLINUDO,
                                                                           sysdate,
                                                                           user,
                                                                           'SERVER',
                                                                           vtycuAsiento_SAP(z).asiefeapl,
                                                                           vaCod_centrobenef,
                                                                           -1,
                                                                           nuCont,
                                                                           vtycuCUCOTIMV_SAP(j).CCTMCLAV_SAP,
                                                                           vaNitCta,
                                                                           null,
                                                                           vtycuAsientoComision(i).VALOR,
                                                                           vtycuAsientoComision(i).VALOR,
                                                                           vaINDICIVA,
                                                                           null,
                                                                           null,
                                                                           null,
                                                                           nuBASEIMPT,
                                                                           ldc_pkinterfazsurti.vaCod_centrocosto,
                                                                           null,
                                                                           NULL,
                                                                           vaNit,
                                                                           'COMIRECA-'||ldc_pkinterfazsurti.nuSeqICLINUDO||'-'||vtycuAsiento_SAP(z).asiefeapl,
                                                                           vaCod_centrobenef,
                                                                           NULL,
                                                                           NULL,
                                                                           vaNit,
                                                                           NULL,
                                                                           'SUPERTIENDAS OLIMPICA SA',
                                                                           null,
                                                                           null,
                                                                           vaTIPORETC,
                                                                           vaINDRETEC,
                                                                           nuBASERETC,
                                                                           I,
                                                                           vtycuAsiento_SAP(z).asiefeapl,
                                                                           vaCtaDivergente);                                                                  

                              IF (nuRet <> 0) THEN
                                 ldc_pkinterfazsurti.vaMensError := 'Error insertando los registros contables.';
                                 raise Error;
                              END IF;
                                  
                              NULL;

                           ELSE
                                 
                              --<<
                              --Nits que se cobran la comision
                              -->>
                              open cuNitsComision(to_char(dtFechaIni,'DD/MM/YYYY'), to_char(dtFechaFin,'DD/MM/YYYY'), vtycuAsiento_SAP(z).asiecons);
                              fetch cuNitsComision BULK COLLECT INTO vtycuNitsComision;
                              close cuNitsComision;

                              IF (vtycuNitsComision.COUNT > 0) THEN

                                FOR n IN vtycuNitsComision.FIRST..vtycuNitsComision.LAST LOOP
                                  --pkregidepu.pRegiMensaje('vtycuNitsComision(n).ASIENIT:',vtycuNitsComision(n).ASIENIT,'CRREIN');

                                  --<<
                                  --obtengo la distribucion de los cupones por departamento y localidad
                                  -->>
                                  open cuDistCupo(to_char(dtFechaIni,'DD/MM/YYYY'), to_char(dtFechaFin,'DD/MM/YYYY'), vtycuNitsComision(n).ASIENIT);
                                  fetch cuDistCupo BULK COLLECT INTO vtycuDistCupo;
                                  close cuDistCupo;

                                  --<<
                                  --Calculo el valor total de los cupones para cargar el total del porcentaje de consignacion por cebe
                                  -->>
                                  IF (vtycuDistCupo.COUNT > 0) THEN

                                      --<<
                                      --Calculo el total de cupones
                                      -->>
                                      nuCantCupo := 0;
                                      nuTotalCupon := 0;
                                      nuTotalDistri := 0;
                                          
                                      FOR q IN vtycuDistCupo.FIRST..vtycuDistCupo.LAST LOOP
                                          nuTotalCupon := nuTotalCupon + vtycuDistCupo(q).CUPONES;
                                              
                                          --<<
                                          --Determino cual es el centro de beneficio con mayor numero de cupones
                                          -->>
                                          IF (vtycuDistCupo(q).CUPONES > nuCantCupo) THEN
                                              vaCentrMayor := vtycuDistCupo(q).cod_centrobenef;
                                              nuCantCupo := vtycuDistCupo(q).CUPONES;
                                          END IF;
                                      END LOOP;

                                      --<<
                                      --Armo un regitro por cebe en donde determino el porcentaje de cupones por cebe y ceco
                                      -->>
                                      FOR q IN vtycuDistCupo.FIRST..vtycuDistCupo.LAST LOOP
                                          --<<
                                          --calculo el porcentaje y lo almaceno por centro de beneficio
                                          -->>
                                          vtyPORCCUPOCECO(vtycuDistCupo(q).cod_centrobenef).cod_centrobenef := vtycuDistCupo(q).cod_centrobenef;
                                          vtyPORCCUPOCECO(vtycuDistCupo(q).cod_centrobenef).porcentaje := ROUND(((vtycuDistCupo(q).CUPONES / nuTotalCupon)* 100),2);
                                          vtyPORCCUPOCECO(vtycuDistCupo(q).cod_centrobenef).valor := vtycuAsientoComision(i).VALOR * 
                                                                                                     (vtyPORCCUPOCECO(vtycuDistCupo(q).cod_centrobenef).porcentaje/100);

                                          nuTotalDistri := nuTotalDistri + vtyPORCCUPOCECO(vtycuDistCupo(q).cod_centrobenef).valor;
                                                                            
                                      END LOOP;

                                      vtyPORCCUPOCECO(vaCentrMayor).valor := vtyPORCCUPOCECO(vaCentrMayor).valor - (nuTotalDistri - vtycuAsientoComision(i).VALOR);

                                  END IF;
                                END LOOP;
                                                            
                              END IF;

                              --<<
                              --Determina que es la cuenta del costo y la distribuye por los cecos de donde
                              --se consigno
                              -->>
                              FOR c IN vtycuDistCupo.FIRST..vtycuDistCupo.LAST LOOP
                                 --<<
                                 --Obtiene el centro de costo del cebe
                                 -->>
                                 ldc_pkinterfazsurti.vaCod_centrocosto := ldc_pkinterfazsurti.fvaConsCentCostoCta(vtyPORCCUPOCECO(vtycuDistCupo(c).cod_centrobenef).cod_centrobenef,
                                                                                                                  vaNitCta);
                                       
                                 IF (ldc_pkinterfazsurti.vaCod_centrocosto = -1) THEN
                                                                 
                                     dbms_output.put_line('CEBE: '||vtyPORCCUPOCECO(vtycuDistCupo(c).cod_centrobenef).cod_centrobenef);
                                     dbms_output.put_line('Cuenta: '||vaNitCta);
                                       
                                 END IF;
                                                                                                                    
                                 vaINDICIVA := vaIndicador;
                                 VATIPORETC := NULL;
                                 nuBASEIMPT := null;
                                 vaINDRETEC := null;
                                 nuBASERETC := null; 

                                 --<<
                                 --Registra el asiento contable en LDC_INCOLIQU
                                 -->>
                                 --<<
                                 IF (vtyPORCCUPOCECO(vtycuDistCupo(c).cod_centrobenef).valor > 0) THEN

                                     nuRet := Pkinterfazsap.fnuLDC_INCOLIQU( ldc_pkinterfazsurti.nuCODDOCCONREIGAS,
                                                                                   ldc_pkinterfazsurti.nuSeqICLINUDO,
                                                                                   sysdate,
                                                                                   user,
                                                                                   'SERVER',
                                                                                   vtycuAsiento_SAP(z).asiefeapl,
                                                                                   vtyPORCCUPOCECO(vtycuDistCupo(c).cod_centrobenef).cod_centrobenef,
                                                                                   -1,
                                                                                   nuCont,
                                                                                   vtycuCUCOTIMV_SAP(j).CCTMCLAV_SAP,
                                                                                   vaNitCta,
                                                                                   null,
                                                                                   vtyPORCCUPOCECO(vtycuDistCupo(c).cod_centrobenef).valor,
                                                                                   vtyPORCCUPOCECO(vtycuDistCupo(c).cod_centrobenef).valor,
                                                                                   vaINDICIVA,
                                                                                   null,
                                                                                   null,
                                                                                   null,
                                                                                   nuBASEIMPT,
                                                                                   ldc_pkinterfazsurti.vaCod_centrocosto,
                                                                                   sbCodRecaOlim,
                                                                                   NULL,
                                                                                   vaNit,
                                                                                   'COMIRECA-'||ldc_pkinterfazsurti.nuSeqICLINUDO||'-'||vtycuAsiento_SAP(z).asiefeapl,
                                                                                   vtyPORCCUPOCECO(vtycuDistCupo(c).cod_centrobenef).cod_centrobenef,
                                                                                   NULL,
                                                                                   NULL,
                                                                                   vaNit,
                                                                                   NULL,
                                                                                   'SUPERTIENDAS OLIMPICA SA',
                                                                                   null,
                                                                                   null,
                                                                                   vaTIPORETC,
                                                                                   vaINDRETEC,
                                                                                   nuBASERETC,
                                                                                   I,
                                                                                   vtycuAsiento_SAP(z).asiefeapl,
                                                                                   vaCtaDivergente,
                                                                                   vtycuAsiento_SAP(z).asiecons);                                                                           
                    
                                      ldc_pkinterfazsurti.vaCod_centrocosto := null;

                                      IF (nuRet <> 0) THEN
                                         ldc_pkinterfazsurti.vaMensError := 'Error distribuyendo el costo';
                                         raise Error;
                                      END IF;                              
                                  END IF;
                              END LOOP;
                                  vtyPORCCUPOCECO.delete;
                           END IF;

                        END LOOP;
                     END IF;
                  END LOOP;
               END IF;
            END LOOP;
              
            --<<
            --Insercion de los datos de la tabla
            --ldc_incoliqu
            -->>
            nuRet     := ldc_pkinterfazsurti.fnuINSELDC_INCOLIQU;
            if (nuRet <> 0) then
              raise Error;
            END IF;
              
            --<<
            --Genera la informacion de los documentos para SAP
            -->>
            nuRet     := ldc_pkinterfazsurti.fnuGeneDocuSap(ldc_pkinterfazsurti.nuSeqICLINUDO);
            if (nuRet <> 0) then
              raise Error;
            end if;
              
            --<<
            --Envio de la informacion a traves del web service creado para este proceso
            -->>    
            IF (ldc_pkinterfazsurti.vaGENDOCU_ENVIA_SAP = 'S') THEN
               LDC_PKINTERCONTABLEMESA.proEnviaDocContable(ldc_pkinterfazsurti.nuSeqICLINUDO);
            END IF;
                
            --<<
            --Actualiza con el codigo de envio a sap todos los registros que se procesaron en la contabilizacion
            --para la comision
            -->>
           /* UPDATE ASIENTO_SAP
               SET DOCENVIO_SAP = ldc_pkinterfazsurti.nuSeqICLINUDO
             WHERE ASIECONS IN (SELECT A.ASIECONS
                                  FROM ASIENTO_SAP A, CAUXASIE_SAP B
                                 WHERE A.ASIEDIST = B.CXASDISA
                                   AND A.ASIETIMV = B.CXASTIMV
                                   AND A.ASIECONS = B.CXASCONS
                                   AND A.ASIETIMV = ldc_pkinterfazsurti.nuTIPOMOVCONSIGOLI
                                   AND TRUNC(A.ASIEFECH) BETWEEN TO_DATE(dtFechaIni,'DD/MM/YYYY') AND TO_DATE(dtFechaFin,'DD/MM/YYYY'));*/                        

             UPDATE asiento_sap
                SET docenvio_sap = ldc_pkinterfazsurti.nuSeqICLINUDO
              WHERE asietimv = ldc_pkinterfazsurti.nuTIPOMOVCONSIGOLI
                AND asiecons = vtycuAsiento_SAP(z).asiecons
                AND TRUNC(asiefech) BETWEEN TO_DATE(dtFechaIni,'DD/MM/YYYY') AND TO_DATE(dtFechaFin,'DD/MM/YYYY');                      
                
                dbms_output.put_line('ldc_pkinterfazsurti.nuSeqICLINUDO: ' ||ldc_pkinterfazsurti.nuSeqICLINUDO);
                dbms_output.put_line('ldc_pkinterfazsurti.nuTIPOMOVCONSIGOLI: ' || ldc_pkinterfazsurti.nuTIPOMOVCONSIGOLI);                     
                dbms_output.put_line('dtFechaIni: '|| dtFechaIni);
                dbms_output.put_line('dtFechaFin: '|| dtFechaFin);
                
                dbms_output.put_line(SQL%ROWCOUNT);
                
          END IF;
        
      END LOOP;
              
  END IF;

  vtycuAsiento_SAP.DELETE;    
  vtycuNitsComision.DELETE;
  vtycuLDC_CUENTACONTABLE.DELETE;
  vtycuCUCOTIMV_SAP.DELETE;
  vtycuAsientoComision.DELETE;
  vtyPORCCUPOCECO.DELETE;
  vtycuDistCupo.DELETE;
  vtyLDC_ENCAINTESAP.DELETE;
  vtyLDC_DETAINTESAP.DELETE;
  VTYLDC_INCOLIQU.DELETE;
  
  COMMIT;
  
  RETURN(0);
EXCEPTION
WHEN ERROR THEN
  ldc_pkinterfazsurti.vaMensError := ldc_pkinterfazsurti.vaMensError||'-'||'[fnuComiReca] - Error procesando la interfaz de control reintegro. '||sqlerrm||' '||DBMS_UTILITY.format_error_backtrace;
  pkregidepu.pRegiMensaje('Control',ldc_pkinterfazsurti.vaMensError,'CRREIN');
  vtycuAsiento_SAP.DELETE;
  vtycuNitsComision.DELETE;
  vtycuLDC_CUENTACONTABLE.DELETE;
  vtycuCUCOTIMV_SAP.DELETE;
  vtycuAsientoComision.DELETE;
  vtyPORCCUPOCECO.DELETE;
  vtycuDistCupo.DELETE;
  vtyLDC_ENCAINTESAP.delete;
  vtyLDC_DETAINTESAP.delete;
  VTYLDC_INCOLIQU.DELETE;
  return(-1);
WHEN OTHERS THEN
  ldc_pkinterfazsurti.vaMensError := ldc_pkinterfazsurti.vaMensError||'-'||'[fnuComiReca] - Error procesando la interfaz de control reintegro. '||sqlerrm||' '||DBMS_UTILITY.format_error_backtrace;
  pkregidepu.pRegiMensaje('Control',ldc_pkinterfazsurti.vaMensError,'CRREIN');
  vtycuAsiento_SAP.DELETE;
  vtycuNitsComision.DELETE;
  vtycuLDC_CUENTACONTABLE.DELETE;
  vtycuCUCOTIMV_SAP.DELETE;
  vtycuAsientoComision.DELETE;
  vtyPORCCUPOCECO.DELETE;
  vtycuDistCupo.DELETE;
  vtyLDC_ENCAINTESAP.delete;
  vtyLDC_DETAINTESAP.delete;
  VTYLDC_INCOLIQU.DELETE;
  return(-1);
END fnuComiReca;


--->>>>>>>>>>>>>>
FUNCTION fnuInsFactSD(dtFechaIni IN DATE,
                      dtFechaFin in date)
RETURN NUMBER
  /************************************************************************
  PROPIEDAD INTELECTUAL DE GASES DE OCCIDENTE S.A E.S.P
  FUNCION   : fnuInsFactSD
  AUTOR     : Hector Javier Cuervo Ramirez
  FECHA     : 25-03-2012
  DESCRIPCION  : funcion que se encarga de armar el resumen de la interfaz
                 de contabilizacion de las facturas delete modulo FACT en gasplus
                 
  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion

  ************************************************************************/
is

  --<<
  --Lista de asientos contables que se van a enviar a sap
  -->>
  CURSOR cuAsientos(dtFini IN VARCHAR2,
                    dtFFin IN varchar2)
  IS
  SELECT * FROM ASIENTO A
   WHERE TRUNC(A.ASIEFECH) BETWEEN TO_DATE(dtFini,'DD/MM/YYYY') AND TO_DATE(dtFFin,'DD/MM/YYYY')
     AND ASIECONS NOT IN (SELECT ASIECONS FROM ASIENTO_SAP B
                           WHERE TRUNC(B.ASIEFECH) BETWEEN TO_DATE(dtFini,'DD/MM/YYYY') 
                                                       AND TO_DATE(dtFFin,'DD/MM/YYYY'));
  
  TYPE tycuAsientos IS TABLE OF cuAsientos%ROWTYPE INDEX BY BINARY_INTEGER;
  vtycuAsientos tycuAsientos;
   
  --<<
  --Cursosr para obtener los detalles de los asientos
  -- jorgemg - Arquitecsoft 
  -- fecha: 21/09/2012
  -- se realiza modificacion por efectos de reprocesamiento
  -- de la interfaz
  -->>  
  cursor cuDetalle(dtFini IN VARCHAR2,
                   dtFFin IN varchar2)
  is   
  SELECT B.*
   FROM ASIENTO A, CAUXASIE B
  WHERE A.ASIEDIST = B.CXASDISA
    AND A.ASIETIMV = B.CXASTIMV
    AND A.ASIECONS = B.CXASCONS
    AND (A.ASIEDIST, A.ASIETIMV, A.ASIECONS) IN 
   (SELECT ASIEDIST, ASIETIMV, ASIECONS 
      FROM ASIENTO_SAP A
     WHERE TRUNC(A.ASIEFECH) BETWEEN TO_DATE(dtFini,'DD/MM/YYYY') 
                                 AND TO_DATE(dtFFin,'DD/MM/YYYY')
       AND a.docenvio_sap IS NULL);

  TYPE tycuDetalle IS TABLE OF cuDetalle%ROWTYPE INDEX BY BINARY_INTEGER;
  vtycuDetalle tycuDetalle;
  
BEGIN

  --<<
  --Parametros
  -->>
  provapatapa('CODINTINGRESOS', 'S', nuComodin, ldc_pkinterfazsurti.vaCODINTINGRESOS);
  
  --<<
  --Seleccion de los asientos a procesar
  -->>  
  open cuAsientos(to_char(dtFechaIni,'DD/MM/YYYY'), to_char(dtFechaFin,'DD/MM/YYYY'));
  fetch cuAsientos BULK COLLECT INTO vtycuAsientos;
  close cuAsientos; 
  
  pkregidepu.pRegiMensaje('vtycuAsientos.COUNT:',vtycuAsientos.COUNT,'CRREIN');
  
  IF (vtycuAsientos.COUNT > 0) THEN                                                                                
    
    FOR p IN  vtycuAsientos.FIRST..vtycuAsientos.LAST LOOP
       
         insert into ASIENTO_SAP(ASIEDIST,
                                 ASIETIMV,
                                 ASIECONS,
                                 ASIEFECH,
                                 ASIEFEAPL,
                                 ASIETIPO,
                                 ASIEDETA,
                                 ASIEVLOR,
                                 ASIEANO,
                                 ASIEMES,
                                 ASIEUSUA,
                                 ASIETERM,
                                 ASIEUNAD,
                                 ASIENIT,
                                 ASIEUBOOR,
                                 ASIEDEBI,
                                 ASIECRED,
                                 ASIEMACH,
                                 ASIEESTA,
                                 ASIEREVI,
                                 DOCENVIO_SAP)
                          VALUES(vtycuAsientos(P).ASIEDIST,
                                 vtycuAsientos(P).ASIETIMV,
                                 vtycuAsientos(P).ASIECONS,
                                 vtycuAsientos(P).ASIEFECH,
                                 vtycuAsientos(P).ASIEFEAPL,
                                 vtycuAsientos(P).ASIETIPO,
                                 vtycuAsientos(P).ASIEDETA,
                                 vtycuAsientos(P).ASIEVLOR,
                                 vtycuAsientos(P).ASIEANO,
                                 vtycuAsientos(P).ASIEMES,
                                 vtycuAsientos(P).ASIEUSUA,
                                 vtycuAsientos(P).ASIETERM,
                                 vtycuAsientos(P).ASIEUNAD,
                                 vtycuAsientos(P).ASIENIT,
                                 vtycuAsientos(P).ASIEUBOOR,
                                 vtycuAsientos(P).ASIEDEBI,
                                 vtycuAsientos(P).ASIECRED,
                                 vtycuAsientos(P).ASIEMACH,
                                 vtycuAsientos(P).ASIEESTA,
                                 vtycuAsientos(P).ASIEREVI,
                                 NULL);                         
  
    end loop;
  
  END IF;
  vtycuAsientos.DELETE;              
  
  --<<
  --Seleccion de los asientos a procesar
  -->>  
  open cuDetalle(to_char(dtFechaIni,'DD/MM/YYYY'), to_char(dtFechaFin,'DD/MM/YYYY'));
  fetch cuDetalle BULK COLLECT INTO vtycuDetalle;
  close cuDetalle; 
  
  IF (vtycuDetalle.COUNT > 0) THEN
                            
     FOR h IN vtycuDetalle.first..vtycuDetalle.last loop
         
     
        insert into CAUXASIE_SAP(CXASDISA,
                                 CXASTIMV,
                                 CXASCONS,
                                 CXASPATA,
                                 CXAS1DIG,
                                 CXAS2DIG,
                                 CXAS34DIG,
                                 CXAS56DIG,
                                 CXASAUXI,
                                 CXASVLOR,
                                 CXASNATU,
                                 CXASNIT,
                                 CXASAGEN,
                                 CXASUNAD,
                                 CXASAUGA,
                                 CXASACTI,
                                 CXASDIST,
                                 CXAS1DIGPV,
                                 CXAS2DIGPV,
                                 CXAS34DIGPV,
                                 CXAS56DIGPV,
                                 CXASAUXIPV,
                                 CXASESTR,
                                 CXASCATEG,
                                 CXASMAYO,
                                 CXASANO,
                                 CXASMES,
                                 CXASFEAP,
                                 CXASCTA)
                          values(vtycuDetalle(h).CXASDISA,
                                 vtycuDetalle(h).CXASTIMV,
                                 vtycuDetalle(h).CXASCONS,
                                 vtycuDetalle(h).CXASPATA,
                                 vtycuDetalle(h).CXAS1DIG,
                                 vtycuDetalle(h).CXAS2DIG,
                                 vtycuDetalle(h).CXAS34DIG,
                                 vtycuDetalle(h).CXAS56DIG,
                                 vtycuDetalle(h).CXASAUXI,
                                 vtycuDetalle(h).CXASVLOR,
                                 vtycuDetalle(h).CXASNATU,
                                 vtycuDetalle(h).CXASNIT,
                                 vtycuDetalle(h).CXASAGEN,
                                 vtycuDetalle(h).CXASUNAD,
                                 vtycuDetalle(h).CXASAUGA,
                                 vtycuDetalle(h).CXASACTI,
                                 vtycuDetalle(h).CXASDIST,
                                 vtycuDetalle(h).CXAS1DIGPV,
                                 vtycuDetalle(h).CXAS2DIGPV,
                                 vtycuDetalle(h).CXAS34DIGPV,
                                 vtycuDetalle(h).CXAS56DIGPV,
                                 vtycuDetalle(h).CXASAUXIPV,
                                 vtycuDetalle(h).CXASESTR,
                                 vtycuDetalle(h).CXASCATEG,
                                 vtycuDetalle(h).CXASMAYO,
                                 vtycuDetalle(h).CXASANO,
                                 vtycuDetalle(h).CXASMES,
                                 vtycuDetalle(h).CXASFEAP,
                                 vtycuDetalle(h).CXASCTA);              
  
     end loop;
     
  END IF; 
  vtycuDetalle.DELETE;   
  commit;
  RETURN(0);
EXCEPTION
WHEN ERROR THEN
  ldc_pkinterfazsurti.vaMensError := ldc_pkinterfazsurti.vaMensError||'-'||'[fnuContFactSD] - Error procesando la interfaz de facturas SD-GASP. '||sqlerrm;
  pkregidepu.pRegiMensaje('Factsd',ldc_pkinterfazsurti.vaMensError,'FACTSD');  
  rollback;
  vtycuAsientos.DELETE; 
  vtycuDetalle.DELETE; 
  return(-1);
WHEN OTHERS THEN
  ldc_pkinterfazsurti.vaMensError := ldc_pkinterfazsurti.vaMensError||'-'||'[fnuContFactSD] - Error procesando la de facturas SD-GASP. '||sqlerrm;
  pkregidepu.pRegiMensaje('Factsd',ldc_pkinterfazsurti.vaMensError,'FACTSD');
  rollback;
  vtycuAsientos.DELETE;
  vtycuDetalle.DELETE; 
  return(-1);
END fnuInsFactSD;



---->>>>>>><<<<<<<<<<<<<
FUNCTION fnuContFactSD(dtFechaIni IN DATE,
                       dtFechaFin in date)
RETURN NUMBER
  /************************************************************************
  PROPIEDAD INTELECTUAL DE GASES DE OCCIDENTE S.A E.S.P
  FUNCION   : fnuContFactSD
  AUTOR     : Hector Javier Cuervo Ramirez
  FECHA     : 25-03-2012
  DESCRIPCION  : funcion que se encarga de armar el resumen de la interfaz
                 de contabilizacion de las facturas delete modulo FACT en gasplus
                 
  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion

  ************************************************************************/
is

  --<<
  -- VARIABLES
  -->>
  nuMovFinaMulti    NUMBER; --movimiento financiero para la configuracion del costo
  nuMovFinCostMulti NUMBER; --Configuracion del costo y costo diferido de multifamiliares
  nuDepa            NUMBER; --Departamento
  nuLoca            NUMBER; --Localidad
  vaOrdeInterna     ldc_ordeinterna.cod_ordeinterna%TYPE; --Numero de la Orden Interna
  vaNomCuad         cuadcont.cuadnomb%TYPE; --Nombre de la cuadrilla
                          
  --<<
  --Lista de asientos contables que se van a enviar a sap
  -->>
  CURSOR cuAsientos(dtFini IN VARCHAR2,
                    dtFFin IN varchar2)
  IS
  SELECT A.ASIECONS
    FROM ASIENTO_SAP A, CAUXASIE_SAP B
   WHERE A.ASIEDIST = B.CXASDISA
     AND A.ASIETIMV = B.CXASTIMV
     AND A.ASIECONS = B.CXASCONS
     AND A.ASIETIMV IN (select TIMVCODI from tipmovim_sap
                         where timviden = 'FACT') 
     and A.DOCENVIO_SAP IS NULL
     AND TRUNC(A.ASIEFECH) BETWEEN to_date(dtFini,'DD/MM/YYYY') AND to_date(dtFFin,'DD/MM/YYYY')
  GROUP BY A.ASIECONS
  ORDER BY A.ASIECONS;

  TYPE tycuAsientos IS TABLE OF cuAsientos%ROWTYPE INDEX BY BINARY_INTEGER;
  vtycuAsientos tycuAsientos;
  
  --<<
  --Informacion de los asientos contable que se deben contabilizar del modulo de facturas
  -->>
  CURSOR cuAsientoFacturas(nuAsiento   in asiento_sap.ASIECONS%type)
  IS
  SELECT C.FAPACODI, A.ASIEFECH, A.ASIETIMV, A.ASIEUNAD, B.CXASDISA, B.CXASNIT,
         B.CXASAGEN, B.CXAS1DIG||B.CXAS2DIG||B.CXAS34DIG||B.CXAS56DIG CXASCTA, 
         B.CXASNATU, TRUNC(SUM(B.CXASVLOR)) VALOR
    FROM ASIENTO_SAP A, CAUXASIE_SAP B, FACTPAGO C
   WHERE A.ASIEDIST = B.CXASDISA
     AND A.ASIETIMV = B.CXASTIMV
     AND A.ASIECONS = B.CXASCONS 
     AND A.ASIEDIST = C.FAPADISA 
     AND A.ASIETIMV = C.FAPATIMA
     AND A.ASIECONS = C.FAPACASI
     and A.ASIECONS = nuAsiento
   GROUP BY C.FAPACODI, A.ASIEFECH, A.ASIETIMV, A.ASIEUNAD, B.CXASDISA, B.CXASAGEN, B.CXASNIT, B.CXASAGEN, 
            B.CXAS1DIG||B.CXAS2DIG||B.CXAS34DIG||B.CXAS56DIG, B.CXASNATU;  

  TYPE tycuAsientoFacturas IS TABLE OF cuAsientoFacturas%ROWTYPE INDEX BY BINARY_INTEGER;
  vtycuAsientoFacturas tycuAsientoFacturas;

  --<<
  --Informacion de los centros de beneficio
  -->>
  CURSOR cuUbicacion(vaUnid    asiento_sap.asieunad%type)
  IS
  SELECT COD_CENTROBENEF,UNADDEPA,UNADLOCA
    FROM UNIDADMI, LOCALIDA, LDC_CENTBENELOCA
   WHERE UNADDEPA = LOCADEPA
     AND UNADLOCA = LOCACODI
     AND COD_DEPARTAMENTO = LOCADEPA
     AND COD_LOCALIDAD    = LOCACODI
     AND UNADCODI = vaUnid;

  --<<
  --informacion para obtener la clave de contabilizacion
  -->>
  CURSOR cuCUCOTIMV_SAP(vaCuenta     CUCOTIMV_SAP.CCTMCUEN_SAP%type,
                        vaCCTMTIMV   CUCOTIMV_SAP.CCTMTIMV%type,
                        vaCCTMDECR   CUCOTIMV_SAP.CCTMDECR%type)
  IS
  SELECT CCTMCUEN_SAP, CCTMCLAV_SAP, CCTMINRE_SAP, CCTMTIRE_SAP, CTMCREPORCECO_SAP 
    FROM CUCOTIMV_SAP
   WHERE CCTMTIMV                 = vaCCTMTIMV
     AND CCTM1DIG||CCTM2DIG||CCTM34DIG||CCTM56DIG = vaCUENTA
     and CCTMDECR                 = vaCCTMDECR;


  --<<
  --cgonzalezv: informacion para obtener la configuracion requerida en 
  --multifamiliares por cada cuenta contable y signo DB, CR
  -->>
  CURSOR cuCUCOTIMVMULTIF_SAP(vaCuenta     CUCOTIMV_SAP.CCTMCUEN_SAP%type,
                              vaCCTMTIMV   CUCOTIMV_SAP.CCTMTIMV%type,
                              vaCCTMDECR   CUCOTIMV_SAP.CCTMDECR%type)
  IS
  SELECT CCTMCUEN_SAP, CCTMCLAV_SAP, CCTMINRE_SAP, CCTMTIRE_SAP, CTMCREPORCECO_SAP
    FROM CUCOTIMV_SAP
   WHERE CCTMTIMV                 IN (vaCCTMTIMV,nuMovFinCostMulti)
     AND CCTM1DIG||CCTM2DIG||CCTM34DIG||CCTM56DIG = vaCUENTA
     and CCTMDECR                 = vaCCTMDECR;


  TYPE tycuCUCOTIMV_SAP IS TABLE OF cuCUCOTIMV_SAP%ROWTYPE INDEX BY BINARY_INTEGER;
  vtycuCUCOTIMV_SAP tycuCUCOTIMV_SAP;

  --<<
  --Informacion complementaria de la cuenta contable
  -->>
  CURSOR cuLDC_CUENTACONTABLE(vaCOD_CUENTACONTABLE    LDC_CUENTACONTABLE.COD_CUENTACONTABLE%TYPE)
  IS
  SELECT * FROM LDC_CUENTACONTABLE
  WHERE COD_CUENTACONTABLE = vaCOD_CUENTACONTABLE;

  TYPE tycuLDC_CUENTACONTABLE IS TABLE OF cuLDC_CUENTACONTABLE%ROWTYPE INDEX BY BINARY_INTEGER;
  vtycuLDC_CUENTACONTABLE tycuLDC_CUENTACONTABLE;

  --<<
  --Cursor que obtiene el porcentaje de la tarifa del indicador
  -->>
  CURSOR cuLDC_INDICADOR(vaCOD_TIPORETENC   LDC_INDICADOR.COD_TIPORETENC%type,
                         VACOD_INDICADOR    LDC_INDICADOR.COD_INDICADOR%TYPE)
  IS
  SELECT * FROM LDC_INDICADOR
   WHERE COD_TIPORETENC = vaCOD_TIPORETENC
    and COD_INDICADOR   = vaCOD_INDICADOR;

  --<<
  -- Obtiene los datos del NIT (NIT,NOMBRE)
  -->
  CURSOR CuDatosNITSAP (vaNitCuad IN cuadcont.cuadnit%TYPE) IS
  SELECT bannnomb 
    FROM ldc_banconit
   WHERE bannnnit = vaNitCuad;

  VACULDC_INDICADOR  CULDC_INDICADOR%ROWTYPE;
  
  vaCod_centrobenef ldc_centrobenef.cod_centrobenef%type;
  nuRet             NUMBER;
  nuCont            NUMBER := 0;--variable para detallar por consignacion.
  vaCTADIVERGENTE   VARCHAR2(20);
  vaRet             VARCHAR2(10);
  VANITCTA          VARCHAR2(20);
  vaIndicador       LDC_INDICADOR.COD_INDICADOR%TYPE;
  vaTiporeten       LDC_INDICADOR.COD_TIPORETENC%TYPE;
  vaINDICIVA        ldc_incoliqu.INDICIVA%type;
  nuBASEIMPT        ldc_incoliqu.BASEIMPT%type;
  vaTIPORETC        ldc_incoliqu.TIPORETC%type;
  vaINDRETEC        ldc_incoliqu.INDRETEC%type;
  NUBASERETC        LDC_INCOLIQU.BASERETC%TYPE;
  VANIT             VARCHAR2(20);
  ErroIns           exception;
  cnTipoTrabMultif  CONSTANT NUMBER := 1167; --Tipo de trabajo utilizado para los multifamiliares


BEGIN

  --<<
  --Parametros
  -->>
  provapatapa('CODINTINGRESOS', 'S', nuComodin, ldc_pkinterfazsurti.vaCODINTINGRESOS);
  provapatapa('CODDOCINGRESOS', 'N', ldc_pkinterfazsurti.nuCODDOCINGRESOS, vaComodin);
  provapatapa('GRLEDGER', 'S', nuComodin, ldc_pkinterfazsurti.vaGRLEDGER);
  provapatapa('SOCIEDAD', 'S', nuComodin, ldc_pkinterfazsurti.vaSOCIEDAD);
  provapatapa('CURRENCY', 'S', nuComodin, ldc_pkinterfazsurti.vaCURRENCY);
  provapatapa('CEBE_GENERAL', 'S', nuComodin, ldc_pkinterfazsurti.vaCEBE_GENERAL);
  provapatapa('GENDOCU_ENVIA_SAP', 'S', nuComodin, ldc_pkinterfazsurti.vaGENDOCU_ENVIA_SAP);
  provapatapa('TIPOMOVCONSIG', 'N', ldc_pkinterfazsurti.nuTIPOMOVCONSIG, vaComodin);
  provapatapa('TIPOMOVCONSIG', 'N', ldc_pkinterfazsurti.nuTIPOMOVCONSIG, vaComodin);
  provapatapa('TERCEROGENEITI', 'S', nuComodin, ldc_pkinterfazsurti.vaNitGenerico);
  --<<
  -- Parametros para soportar el modulo de proyecto-Facturacion multifamiliares
  -->>
  provapatapa('MOV_FINAN_MULTIFAM', 'N',nuMovFinaMulti, vaComodin);
  provapatapa('MOV_FINAN_MULTIFAM_COSTO','N',nuMovFinCostMulti, vaComodin);
  
  
  --<<
  --Inserta los datos del asiento y cauzasie a las tablas en gasplus
  -->>
  nuRet := ldc_pkinterfazsurti.fnuInsFactSD(to_char(dtFechaIni,'DD/MM/YYYY'),
                                            to_char(dtFechaFin,'DD/MM/YYYY'));
  
  if (nuRet <> 0) then
      raise ErroIns;
  end if;   
                   
  --<<
  --Seteo el tipo de documento
  -->>
  ldc_pkinterfazsurti.vaCODINTINTERFAZ := ldc_pkinterfazsurti.vaCODINTINGRESOS;
  
  --<<
  --Seleccion de los asientos a procesar
  -->>  
  open cuAsientos(to_char(dtFechaIni,'DD/MM/YYYY'), to_char(dtFechaFin,'DD/MM/YYYY'));
  fetch cuAsientos BULK COLLECT INTO vtycuAsientos;
  close cuAsientos; 
  
  pkregidepu.pRegiMensaje('vtycuAsientos.COUNT:',vtycuAsientos.COUNT,'CRREIN');
  
  IF (vtycuAsientos.COUNT > 0) THEN
                                                                               
    
    FOR p IN  vtycuAsientos.FIRST..vtycuAsientos.LAST LOOP
      pkregidepu.pRegiMensaje('vtycuAsientos(p).ASIECONS',vtycuAsientos(p).ASIECONS,'CRREIN');
      --<<
      --Selecciono el consecutivo de la interfaz que se va a generar, se toma como
      --consecutivo el mismo codigo del asiento generado en gasplus
      -->>
      ldc_pkinterfazsurti.nuSeqICLINUDO := ldc_pkinterfazsurti.fnuSeq_ldc_incoliqu;
    
      --<<
      --Obtencion de los datos de las comisiones
      -->>
      open cuAsientoFacturas(vtycuAsientos(p).ASIECONS);
      fetch cuAsientoFacturas BULK COLLECT INTO vtycuAsientoFacturas;
      close cuAsientoFacturas;
      
      pkregidepu.pRegiMensaje('vtycuAsientoFacturas.COUNT:',vtycuAsientoFacturas.COUNT,'CRREIN');
      --<<
      --Valido que existan consignaciones para realizar los asientos contables
      -->>
      IF (vtycuAsientoFacturas.COUNT > 0) THEN
    
        
        --<<
        --Recorro el cursos para obtener la informacion a procesar
        -->>
        FOR i IN vtycuAsientoFacturas.FIRST..vtycuAsientoFacturas.LAST LOOP
    
           nuCont := nuCont + 1;
           
           --Setea el nombre del tercero como alerte para cuando no existe en 
           -- ldc_banconit
           vaNomCuad := 'NO EXISTE EN BANCONIT';

           --<<
           -- cgonzalezv ARQS
           -- Valida si le movimiento financiero es por multifamiliares
           -- para obtener los costos y costos diferidos del movif 1560,1567  (configuracion
           -- requerida por cuenta contable).
           --cgonzalez 21-jul-2012
           -- Seleccion datos cuadrilla, si es factura por multifamiliar se reporta
           -- el contratista, en caso contrario se reporta el NIT generico
           -->>
           IF nuMovFinaMulti = vtycuAsientoFacturas(i).ASIETIMV THEN
              
              open cuCUCOTIMVMULTIF_SAP(SUBSTR(vtycuAsientoFacturas(i).CXASCTA,0,6),
                                               vtycuAsientoFacturas(i).ASIETIMV,
                                               vtycuAsientoFacturas(i).CXASNATU);
             fetch cuCUCOTIMVMULTIF_SAP BULK COLLECT INTO VTYCUCUCOTIMV_SAP;
             close cuCUCOTIMVMULTIF_SAP;
             
             --Setea el NOmbre y NIT del Contratista
              OPEN CuDatosNITSAP(vtycuAsientoFacturas(i).CXASNIT);
             FETCH CuDatosNITSAP INTO vaNomCuad;
             CLOSE CuDatosNITSAP;
             --NIT
             ldc_pkinterfazsurti.vaNitGenerico := vtycuAsientoFacturas(i).CXASNIT;
             
             
           ELSE 
              --<<
              --Selecciono la configuracion del movimiento financiero que NO pertenece
              -- a multifamiliares
              -->>          
              open cucucotimv_sap(SUBSTR(vtycuAsientoFacturas(i).CXASCTA,0,6),
                               vtycuAsientoFacturas(i).ASIETIMV,
                               vtycuAsientoFacturas(i).CXASNATU);
             fetch cucucotimv_sap BULK COLLECT INTO VTYCUCUCOTIMV_SAP;
             close cucucotimv_sap;
            -- pkregidepu.pRegiMensaje('VTYCUCUCOTIMV_SAP.COUNT:',VTYCUCUCOTIMV_SAP.COUNT,'CRREIN');
            
             --Setea el NIT generico
             provapatapa('TERCEROGENEITI', 'S', nuComodin, ldc_pkinterfazsurti.vaNitGenerico);
             vaNomCuad := 'GENERICO GAS NATURAL';

           END IF;
                     
    
           IF (VTYCUCUCOTIMV_SAP.COUNT > 0) THEN
    
               FOR j IN VTYCUCUCOTIMV_SAP.first..VTYCUCUCOTIMV_SAP.last LOOP
    
                   --<<
                   --Determina el centro de beneficio
                   -->>
                   open cuUbicacion(vtycuAsientoFacturas(i).ASIEUNAD);
                   fetch cuUbicacion into vaCod_centrobenef,nuDepa,nuLoca;
                   close cuUbicacion;
 
                   --<<
                   -- Obtiene el centro de costo y la orden interna para el tipo trabajo multifamiliar
                   -->>
                   vaOrdeInterna := NULL;
                   ldc_pkinterfazsurti.vaCod_centrocosto := NULL;
                   IF vtycuCUCOTIMV_SAP(j).CTMCREPORCECO_SAP = 'S' THEN
                      
                      ldc_pkinterfazsurti.vaCod_centrocosto := ldc_pkinterfazcostos.ldc_fvagetCenCos(nuDepa,nuLoca,cnTipoTrabMultif);
                      vaOrdeInterna := ldc_pkinterfazcostos.ldc_fvagetOrdintEst(nuDepa,nuLoca,cnTipoTrabMultif);
                   END IF; 

   
                   --<<
                   --Determino si la clave contable es para manejo de cuenta divergente
                   -->>
                   vaRet := pkinterfazSAP.fnuCtaDiver(to_char(vtycuCUCOTIMV_SAP(j).CCTMCLAV_SAP));
    
                   --<<
                   --Es una cuenta divergente
                   -->>
                   IF (vaRet = 'S') THEN
    
                       vaNitCta        := ldc_pkinterfazsurti.vaNitGenerico;
                       vaNit           := ldc_pkinterfazsurti.vaNitGenerico;
                       vaCtaDivergente := VTYCUCUCOTIMV_SAP(J).CCTMCUEN_SAP;
    
                   ELSE
    
                       vaNitCta        := VTYCUCUCOTIMV_SAP(J).CCTMCUEN_SAP;
                       vaNit           := ldc_pkinterfazsurti.vaNitGenerico;
                       vaCtaDivergente := null;
    
                   END IF;
    
                   --<<
                   --Obtengo la informacion del tipo de cuenta contable, para determinar el manejo
                   --de las bases de los indicadores
                   -->>
                   open cuLDC_CUENTACONTABLE(VTYCUCUCOTIMV_SAP(J).CCTMCUEN_SAP);
                   fetch cuLDC_CUENTACONTABLE BULK COLLECT INTO vtycuLDC_CUENTACONTABLE;
                   close cuLDC_CUENTACONTABLE;
    
                   pkregidepu.pRegiMensaje('vtycuLDC_CUENTACONTABLE.COUNT:',vtycuLDC_CUENTACONTABLE.COUNT,'CRREIN');
                   IF (vtycuLDC_CUENTACONTABLE.COUNT > 0) THEN
    
                     FOR M IN vtycuLDC_CUENTACONTABLE.FIRST..vtycuLDC_CUENTACONTABLE.LAST LOOP
    
                       --<<
                       --Valido los asientos contables para el manejo de los indicadores
                       -->>
                       vaIndicador := vtycuCUCOTIMV_SAP(j).CCTMINRE_SAP;
                       vaTipoReten := vtycuCUCOTIMV_SAP(j).CCTMTIRE_SAP;
    
                       --<<
                       --Obtengo la informacion del porcentaje de cada indicador
                       -->>
                       OPEN cuLDC_INDICADOR(vaTipoReten, vaIndicador);
                       FETCH cuLDC_INDICADOR INTO vacuLDC_INDICADOR;
                       IF (cuLDC_INDICADOR%notfound) THEN
                           vacuLDC_INDICADOR.porcentaje := 100;
                       END IF;
                       CLOSE cuLDC_INDICADOR;
    
                       --<<
                       --Valido el tipo de las cuentas contables para saber como se maneja
                       --inidcador
                       -->>
                       IF (vtycuLDC_CUENTACONTABLE(M).TIPO_CUENTACONTABLE = 'B') THEN
    
                         --<<
                         --No lleva ningun tipo de indicadores
                         -->>
                         vaTIPORETC := null;
                         vaINDRETEC := null;
                         nuBASERETC := null;
                         vaINDICIVA := null;
                         nuBASEIMPT := null;
    
                       ELSIF (vtycuLDC_CUENTACONTABLE(M).TIPO_CUENTACONTABLE = 'I') THEN
    
                         --<<
                         --Significa que el valor es de IVA
                         -->>
                         vaINDICIVA := vaIndicador;
                         vaTIPORETC := null;
                         nuBASEIMPT := ROUND(vtycuAsientoFacturas(i).VALOR / (vacuLDC_INDICADOR.porcentaje/100));
                         vaINDRETEC := null;
                         nuBASERETC := null;
    
                       ELSIF (vtycuLDC_CUENTACONTABLE(M).TIPO_CUENTACONTABLE = 'R') THEN
    
                         --<<
                         --Ya son las retenciones que se deben aplicar
                         -->>
                         vaTIPORETC := vaTiporeten;
                         vaINDRETEC := vaIndicador;
                         nuBASERETC := ROUND(vtycuAsientoFacturas(i).VALOR / (vacuLDC_INDICADOR.porcentaje/100));
                         vaINDICIVA := null;
                         nuBASEIMPT := null; 
                       
                       ELSIF (vtycuLDC_CUENTACONTABLE(M).TIPO_CUENTACONTABLE = 'N') THEN
    
                         --<<
                         --Ya son las retenciones que se deben aplicar
                         -->>
                         vaTIPORETC := null;
                         vaINDRETEC := null;
                         nuBASERETC := null;
                         vaINDICIVA := vaIndicador;
                         nuBASEIMPT := null;                        
    
                       END IF;
    
                       
                       pkregidepu.pRegiMensaje('INSERTA:',vaNitCta,'CRREIN');
                       --<<
                       --Registra el asiento contable en LDC_INCOLIQU
                       -->>
                       --<<
                       nuRet := ldc_pkinterfazsurti.fnuLDC_INCOLIQU(   ldc_pkinterfazsurti.nuCODDOCINGRESOS,
                                                                       ldc_pkinterfazsurti.nuSeqICLINUDO,
                                                                       sysdate,
                                                                       user,
                                                                       'SERVER',
                                                                       vtycuAsientoFacturas(i).ASIEFECH,
                                                                       vaCod_centrobenef,
                                                                       -1,
                                                                       nuCont,
                                                                       vtycuCUCOTIMV_SAP(j).CCTMCLAV_SAP,
                                                                       vaNitCta,
                                                                       null,
                                                                       vtycuAsientoFacturas(i).VALOR,
                                                                       vtycuAsientoFacturas(i).VALOR,
                                                                       vaINDICIVA,
                                                                       null,
                                                                       null,
                                                                       null,
                                                                       nuBASEIMPT,
                                                                       ldc_pkinterfazsurti.vaCod_centrocosto,
                                                                       vaOrdeInterna,
                                                                       NULL,
                                                                       vaNit,
                                                                       vtycuAsientoFacturas(i).FAPACODI,
                                                                       vaCod_centrobenef,
                                                                       NULL,
                                                                       NULL,
                                                                       ldc_pkinterfazsurti.vaNitGenerico,
                                                                       NULL,
                                                                       vaNomCuad,
                                                                       null,
                                                                       null,
                                                                       vaTIPORETC,
                                                                       vaINDRETEC,
                                                                       nuBASERETC,
                                                                       I,
                                                                       null,
                                                                       vaCtaDivergente);
    
                       IF (nuRet <> 0) THEN
                           ldc_pkinterfazsurti.vaMensError := 'Error insertando los registros contables.';
                           raise Error;
                       END IF;
    
                    END LOOP;
                 END IF;
              END LOOP;
           END IF;
        END LOOP;
      
        --<<
        --Insercion de los datos de la tabla
        --ldc_incoliqu
        -->>
        nuRet     := ldc_pkinterfazsurti.fnuINSELDC_INCOLIQU;
        if (nuRet <> 0) then
          raise Error;
        END IF;
      
        --<<
        --Genera la informacion de los documentos para SAP
        -->>
        nuRet     := ldc_pkinterfazsurti.fnuGeneDocuSap(ldc_pkinterfazsurti.nuSeqICLINUDO);
        if (nuRet <> 0) then
          raise Error;
        end if;
      
        --<<
        --Envio de la informacion a traves del web service creado para este proceso
        -->>    
        IF (ldc_pkinterfazsurti.vaGENDOCU_ENVIA_SAP = 'A') THEN
           LDC_PKINTERCONTABLEMESA.proEnviaDocContable(ldc_pkinterfazsurti.nuSeqICLINUDO);
        END IF;
        
        --<<
        --Actualiza los asientos contables, con el codigo que se envio a sap
        -->>
        nuRet := ldc_pkinterfazsurti.fnuUpdAsiento(vtycuAsientos(p).ASIECONS,
                                                   ldc_pkinterfazsurti.nuSeqICLINUDO);

        if (nuRet <> 0) then
            ldc_pkinterfazsurti.vaMensError := 'Error actualizando los asientos contables con el codigo de envio a SAP';
            raise Error;
        end if;
                               
      END IF;
      vtycuLDC_CUENTACONTABLE.DELETE;
      vtycuCUCOTIMV_SAP.DELETE;
      vtycuAsientoFacturas.DELETE;
      vtyLDC_ENCAINTESAP.delete;
      vtyLDC_DETAINTESAP.delete;
      VTYLDC_INCOLIQU.DELETE;
  
    END LOOP;
  END IF;
  vtycuAsientos.DELETE;
  vtycuLDC_CUENTACONTABLE.DELETE;
  vtycuCUCOTIMV_SAP.DELETE;
  vtycuAsientoFacturas.DELETE;
  vtyLDC_ENCAINTESAP.delete;
  vtyLDC_DETAINTESAP.delete;
  VTYLDC_INCOLIQU.DELETE;
  
  RETURN(0);
EXCEPTION
WHEN ERROR THEN
  ldc_pkinterfazsurti.vaMensError := ldc_pkinterfazsurti.vaMensError||'-'||'[fnuContFactSD] - Error procesando la interfaz de facturas SD-GASP. '||sqlerrm;
  pkregidepu.pRegiMensaje('Factsd',ldc_pkinterfazsurti.vaMensError,'FACTSD');
  vtycuAsientos.DELETE;
  vtycuLDC_CUENTACONTABLE.DELETE;
  vtycuCUCOTIMV_SAP.DELETE;
  vtycuAsientoFacturas.DELETE;
  vtyLDC_ENCAINTESAP.delete;
  vtyLDC_DETAINTESAP.delete;
  VTYLDC_INCOLIQU.DELETE;
  return(-1);   
WHEN ErroIns THEN
  ldc_pkinterfazsurti.vaMensError := ldc_pkinterfazsurti.vaMensError||'-'||'[fnuContFactSD] - Error insertando datos de finplus a gasplus. '||sqlerrm;
  pkregidepu.pRegiMensaje('Factsd',ldc_pkinterfazsurti.vaMensError,'FACTSD');
  vtycuAsientos.DELETE;
  vtycuLDC_CUENTACONTABLE.DELETE;
  vtycuCUCOTIMV_SAP.DELETE;
  vtycuAsientoFacturas.DELETE;
  vtyLDC_ENCAINTESAP.delete;
  vtyLDC_DETAINTESAP.delete;
  VTYLDC_INCOLIQU.DELETE;
  return(-1);  
WHEN OTHERS THEN
  ldc_pkinterfazsurti.vaMensError := ldc_pkinterfazsurti.vaMensError||'-'||'[fnuContFactSD] - Error procesando la de facturas SD-GASP. '||sqlerrm;
  pkregidepu.pRegiMensaje('Factsd',ldc_pkinterfazsurti.vaMensError,'FACTSD');
  vtycuAsientos.DELETE;
  vtycuLDC_CUENTACONTABLE.DELETE;
  vtycuCUCOTIMV_SAP.DELETE;
  vtycuAsientoFacturas.DELETE;
  vtyLDC_ENCAINTESAP.delete;
  vtyLDC_DETAINTESAP.delete;
  VTYLDC_INCOLIQU.DELETE;
  return(-1);
END fnuContFactSD;
END ldc_pkinterfazsurti;
/
