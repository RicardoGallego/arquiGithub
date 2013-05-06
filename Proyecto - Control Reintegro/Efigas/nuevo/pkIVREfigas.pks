create or replace package gas.pkIVREfigas is

/************************************************************************
   Propiedad intelectual EFIGASS.A. E.S.P.

   PAQUETE      : pkIVREfigas 
   AUTOR        : José Ricardo Gallego 
   EMPRESA      : ArquitecSoft S.A.S
   FECHA        : 28-01-2013
   DESCRIPCION  : Paquete que maneja la logica del proceso de IVR.

  Historia de Modificaciones
  Autor    Fecha       Descripcion

************************************************************************/

  --<<
  -- Parametros Globales
  -->>
  nuCodPer    perequej.perecodi%TYPE := 0; 
  nuOrtrNu    ordetrab.ortrnume%TYPE := 0;
  nuFuncio    funciona.funccodi%TYPE := 0; 
  
  --<<
  -- Record Grups
  -->>
  rcOrdetrab ordetrab%ROWTYPE;         
        
  --<<
  -- Definicion de cada uno de los campos de la tabla PL de motivos 
  -- de atencion
  -->>                    
  TYPE tyMotivo IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
  vtyMotivo tyMotivo;
  
  TYPE tyMotivo_Desc IS TABLE OF VARCHAR2(80) INDEX BY BINARY_INTEGER;
  vtyMotivo_Desc tyMotivo_Desc; 
  

  --<<
  -- Funcion para validar si el suscriptor existe
  -->>
  FUNCTION fsbExisteSuscriptor(nuSuscri IN suscripc.susccodi%TYPE) RETURN NUMBER;


  --<<
  -- Funcion para validar el cupo de brilla de un suscriptor
  -->>
  FUNCTION fsbCupoDisponible(nuSuscri IN servsusc.sesunuse%TYPE) RETURN VARCHAR2;

  --<<
  -- Procedimiento para validar el saldo de un suscriptor
  -->>
  PROCEDURE prcSaldoMedidor (nuSuscri  IN servsusc.sesunuse%TYPE, 
                             nuSaldo   OUT suscripc.suscsape%TYPE, 
                             nuMedidor OUT servsusc.sesuleac%TYPE);

  --<<
  -- Procedimiento para obtener la informacion de la Revision Segura
  -->>
  FUNCTION fsbInfoSegura(nuSuscri IN servsusc.sesunuse%TYPE) RETURN VARCHAR2;

   --<<
   -- Funcion para obtentener la PQR de la actualizacion el Extracto
   -->>                       
   FUNCTION fsbUpdateEstracto(nuSuscri     servsusc.sesunuse%TYPE) RETURN VARCHAR2;     
   
   --<<
   -- Funcion para obtentener la PQR de la actualizacion de la Identificacion
   -->>
   FUNCTION fsbUpdateIdentificacion(nuSuscri     servsusc.sesunuse%TYPE) RETURN VARCHAR2;                  
   
   --<<
   -- Funcion para obtentener la PQR de la actualizacion de la Direccion
   -->>
   FUNCTION fsbUpdateDireccion(nuSuscri  servsusc.sesunuse%TYPE)RETURN VARCHAR2;
   
   
   --<<
   -- Funcion para obtentener la informacion de la factura, fecha ultimo pago, valor cancelado
   -- valor total a pagar, fecha limite de pago
   -->>
   FUNCTION fsbInfoFactura(nuSuscri IN servsusc.sesunuse%TYPE) RETURN VARCHAR2;
   
   --<<
   -- Funcion para Crear una Pqr y Sus ordenes asociadas
   -->>
    FUNCTION fsbCreaATOT(nuSuscrip  IN suscripc.susccodi%TYPE,
                         nuMotivos  IN motipere.mopecodi%TYPE,
                         sbCausal   IN causpere.capecodi%TYPE,
                         sbObserv   IN ordetrab.ortrobse%TYPE,
                         sbDetall   IN ordetrab.ortrobse%TYPE DEFAULT NULL)
    RETURN NUMBER;
    
    PROCEDURE  prcFSBSaldoXServicio(nuSuscri  IN  servsusc.sesususc%TYPE,
                                    nuServic  IN  servsusc.sesuserv%TYPE DEFAULT -1, 
                                    fbsCursor OUT Sys_Refcursor);
    
   
end pkIVREfigas;
/
create or replace package body gas.pkIVREfigas is
/********************************************************************************
   PROPIEDAD INTELECTUAL DE EFIGAS
   FUNCION   : pkIVREfigas
   AUTOR     : José Ricardo Gallego
   Empresa   : ArquitecSoft S.A.S
   FECHA     : 28-01-2013
   DESCRIPCION  : Paquete que maneja la logica del proceso de IVR.

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion

********************************************************************************/
  --<<
  -- Cursor para determinar los datos basicos del suscriptor
  -->>
  CURSOR cuDataSusc(nuSusccodi suscripc.susccodi%TYPE)
      IS
  SELECT suscdepa, suscloca, susccodi, sesuserv, sesunuse  
   FROM suscripc, servsusc
   WHERE sesususc = susccodi
     AND sesususc = nuSusccodi
     AND sesuserv = 1;   
     
  --<<
  -- Excepciones controladas
  -->>     
  expCreaAten   EXCEPTION;  

FUNCTION fsbExisteSuscriptor(nuSuscri IN suscripc.susccodi%TYPE)
  /*****************************************************************************
  PROPIEDAD INTELECTUAL DE EFIGAS
  FUNCION      : fsbExisteSuscriptor
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 28-01-2013
  DESCRIPCION  : Funcion que se encarga de validar si el suscriptor existe

  Parametros de Entrada
             - SUSCRIPTOR

  Parametros de Salida
               1 [EXISTE SUSCRIPTOR]
               0 [NO EXISTE SUSCRIPTOR]

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/
  RETURN NUMBER IS

    --<<
    -- Parametros
    -->>
    nuError NUMBER := 0;
    sbError VARCHAR2(2000) := NULL;

    --<<
    -- Cursor para validar si el suscriptor existe
    -->>
    CURSOR cuSuscripc
        IS
    SELECT *
      FROM suscripc s
     WHERE s.susccodi = nuSuscri;

  BEGIN
       
    FOR rgcuServSusc IN cuSuscripc LOOP

        nuError := 1;

    END LOOP;

    RETURN(nuError);

  EXCEPTION
    
    WHEN OTHERS THEN
       sbError :=  '[pkIVREfigas.FSBEXISTESUSCRIPTOR] - '||SQLERRM||' '||DBMS_UTILITY.format_error_backtrace;
       pkregidepu.pRegiMensaje('EXCEPTION Error',sbError, 'PKIVR');
       RETURN(-1);
  END fsbExisteSuscriptor; 
  
  FUNCTION fsbCupoDisponible(nuSuscri IN servsusc.sesunuse%TYPE)
  /*****************************************************************************
  PROPIEDAD INTELECTUAL DE EFIGAS
  FUNCION      : fsbCupoDisponible
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 28-01-2013
  DESCRIPCION  : Se encarga de validar el cupo brilla

  Parametros de Entrada
             - SUSCRIPTOR

  Parametros de Salida
             -  Cupo disponible por un suscritor


  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/
  RETURN VARCHAR2 IS

    --<<
    -- Parametros
    -->>
    sbError    VARCHAR2(2000) := 'ERROR'||'|'||'NO SEPUDO REALIZAR LA CONSULTA'||'|';  
    nuOk       NUMBER := 0;
    
    --<<
    -- Cursor para obtener los datos del cupo de suscriptor
    -->>
    CURSOR cuSuscBrilla 
        IS
    SELECT suscsfnb              cupo_brilla,
           susccfnb              saldo_cupo_brilla,
           (suscsfnb - susccfnb) cupo_utilizado_brilla
      FROM suscripc
     WHERE susccodi = nuSuscri;  
      
  BEGIN
    
  --<<
  -- Se obtiene el cupo disponible
  -->>
  FOR rgCuSuscBrilla IN cuSuscBrilla LOOP
    
      sbError := rgCuSuscBrilla.cupo_brilla||'|'||rgCuSuscBrilla.saldo_cupo_brilla||'|'||rgCuSuscBrilla.cupo_utilizado_brilla;
    
      --<<
      -- Creacion del Motivo asociado al proceso del IVR
      -->>
      nuOk := fsbCreaATOT(nuSuscrip => nuSuscri,
                          nuMotivos => 1000,
                          sbCausal  => '38',
                          sbObserv  => 'IVR CONSULTAR INFORMACION SOBRE  SU CUPO BRILLA',
                          sbDetall  => 'IVR CONSULTAR INFORMACION SOBRE  SU CUPO BRILLA');
                            
      --<<
      -- Control de error
      -->>                    
      IF nuOk = -1 THEN
        
         ROLLBACK;
         sbError := 'ERROR'||'|'||'NO SE PUDO GENERAR EL PQR'||'||';
         RAISE expCreaAten;
        
      END IF;
  
  END LOOP;
  
  COMMIT;
  
  --<<
  -- Retorna el mensaje de brilla solicitado
  -->>    
  RETURN(sbError);  

  EXCEPTION
    WHEN expCreaAten THEN
       ROLLBACK;
       RETURN(sbError);      
    WHEN OTHERS THEN
       ROLLBACK;
       sbError :=  '[pkIVREfigas.FSBCUPODISPONIBLE] - '||SQLERRM||' '||DBMS_UTILITY.format_error_backtrace;
       pkregidepu.pRegiMensaje('EXCEPTION Error',sbError, 'PKIVR');
       sbError := 'ERROR'||'|'||sbError||'|';
       RETURN(sbError);

  END fsbCupoDisponible;
  
  PROCEDURE prcSaldoMedidor(nuSuscri  IN servsusc.sesunuse%TYPE, 
                            nuSaldo   OUT suscripc.suscsape%TYPE, 
                            nuMedidor OUT servsusc.sesuleac%TYPE)
  /*****************************************************************************
  PROPIEDAD INTELECTUAL DE EFIGAS
  FUNCION      : prcSaldoMedidor
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 28-01-2013
  DESCRIPCION  : Procedimiento que se encarga de obtener el saldo y la lectura del medidor de un suscriptor

  Parametros de Entrada
             - SUSCRIPTOR

  Parametros de Salida
             -
             -

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/
  IS

   --<<
   -- Cursor par obtener el saldo total de la deuda
   -- y la ultima lectura tomada
   -->>
   CURSOR cuSaldoTotal
       IS
   SELECT suscsape, (sesuleac - sesulean) sesuleac
     FROM suscripc, servsusc
    WHERE susccodi = sesususc
      AND susccodi =  nuSuscri
      AND sesuserv = 1;   
      
   --<<
   -- Parametros
   -->>         
   sbError VARCHAR2(2000) := NULL; 
   nuOk    NUMBER := 0;

  BEGIN
    
    nuSaldo := -1;
    nuMedidor := -1;
    
    --<<
    -- Se obtiene Saldo pendiente del usuario y la ultima lectura tomada
    -->>
    FOR rgCuSaldoTotal IN cuSaldoTotal LOOP
      
        nuSaldo   := rgCuSaldoTotal.Suscsape;
        nuMedidor := rgCuSaldoTotal.sesuleac;
        
        --<<
        -- Creacion del Motivo asociado al proceso del IVR
        -->>
        nuOk := fsbCreaATOT(nuSuscrip => nuSuscri,
                            nuMotivos => 1000,
                            sbCausal  => '42',
                            sbObserv  => 'IVR CONOCER EL SALDO TOTAL DE SU DEUDA CON EFIGAS Y ULTIMA LECTURA DEL MEDIDOR',
                            sbDetall  => 'IVR CONOCER EL SALDO TOTAL DE SU DEUDA CON EFIGAS Y ULTIMA LECTURA DEL MEDIDOR');
                                
        --<<
        -- Control de error
        -->>                    
        IF nuOk = -1 THEN
            
           sbError := 'ERROR'||'|'||'NO SE PUDO GENERAR EL PQR'||'||';
           RAISE expCreaAten;
            
        END IF;        
        
    END LOOP;
    
    COMMIT;

  EXCEPTION
    WHEN expCreaAten THEN
       ROLLBACK;
       nuSaldo   := -1;
       nuMedidor := -1;  
       sbError := sbError||' [pkIVREfigas.FBSALDO] - '||SQLERRM||' '||DBMS_UTILITY.format_error_backtrace;
       pkregidepu.pRegiMensaje('EXCEPTION Error',sbError, 'PKIVR');        
    WHEN OTHERS THEN
       ROLLBACK;
       sbError := ' [pkIVREfigas.FBSALDO] - '||SQLERRM||' '||DBMS_UTILITY.format_error_backtrace;
       pkregidepu.pRegiMensaje('EXCEPTION Error',sbError, 'PKIVR');
  END prcSaldoMedidor;
  
  FUNCTION fsbUpdateEstracto(nuSuscri     servsusc.sesunuse%TYPE)
  /*****************************************************************************
  PROPIEDAD INTELECTUAL DE EFIGAS
  FUNCION      : fsbUpdateEstracto
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 28-01-2013
  DESCRIPCION  : Se encarga de validar el cupo brilla

  Parametros de Entrada
             - SUSCRIPTOR

  Parametros de Salida
             -  Cupo disponible por un suscritor


  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/
  RETURN VARCHAR2 IS

    --<<
    -- Parametros
    -->>
    nuOk         NUMBER := -1;    
    nuError      NUMBER := -1;
    nuMotivo     motipere.mopecodi%TYPE;
    sbCausa      ordetrab.ortrcatr%TYPE; 
    vaComodin    VARCHAR2(2000); 
    nuComodin    NUMBER := 0;
    sbError      VARCHAR2(2000);
    
    --<<
    -- Cursor de Datos Generales del Suscriptor
    -->>
    CURSOR cuSuscripc
        IS
    SELECT * FROM suscripc, servsusc 
     WHERE sesususc = susccodi
       AND sesususc = nuSuscri
       AND sesuserv = 1;
       
  BEGIN
    
     --<<
     -- Funcion que se encarga de traer el motivo 
     -->>
     provapatapa('COD_IVR_MOT_EST', 'N', nuMotivo, vaComodin);
      
     --<<
     -- Funcion que se encarga de traer el causa 
     -->>
     provapatapa('COD_IVR_CAU_EST', 'S',  nuComodin, sbCausa);
     
     
     FOR rgcuSuscripc IN cuSuscripc LOOP
       
         --<<
         -- Creacion del Motivo asociado al proceso del IVR
         -->>
         nuOk := fsbCreaATOT(nuSuscrip => nuSuscri,
                             nuMotivos => nuMotivo,
                             sbCausal  => sbCausa,
                             sbObserv  => 'IVR REQUISITOS PARA CAMBIO DE  ESTRATO',
                             sbDetall  => 'IVR REQUISITOS PARA CAMBIO DE  ESTRATO');
                                
         --<<
         -- Control de error
         -->>                    
         IF nuOk = -1 THEN
            sbError := 'ERROR'||'|'||'NO SE PUDO GENERAR EL PQR'||'||';
            RAISE expCreaAten;
            
         END IF;                                                                      

         nuError := 0;
     
     END LOOP;
     
     COMMIT;
             
     RETURN(nuError);

  EXCEPTION
    WHEN expCreaAten THEN
       ROLLBACK;
       sbError := sbError||' [pkIVREfigas.FBSALDO] - '||SQLERRM||' '||DBMS_UTILITY.format_error_backtrace;
       pkregidepu.pRegiMensaje('EXCEPTION Error',sbError, 'PKIVR');        
    WHEN OTHERS THEN
       ROLLBACK;
       sbError :=  '[pkWebSurtigas.fnuInsPere] - '||SQLERRM||' '||DBMS_UTILITY.format_error_backtrace;
       pkregidepu.pRegiMensaje('EXCEPTION Error',sbError, 'PKIVR');
       RETURN(nuError);

  END fsbUpdateEstracto; 
  
  FUNCTION fsbUpdateIdentificacion(nuSuscri     servsusc.sesunuse%TYPE)
  /*****************************************************************************
  PROPIEDAD INTELECTUAL DE EFIGAS
  FUNCION      : fsbCupoDisponible
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 28-01-2013
  DESCRIPCION  : Se encarga de validar el cupo brilla

  Parametros de Entrada
             - SUSCRIPTOR

  Parametros de Salida
             -  Cupo disponible por un suscritor


  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/
  RETURN VARCHAR2 IS
  
    --<<
    -- Parametros
    -->>
    nuOk         NUMBER := -1;    
    nuError      NUMBER := -1;
    nuMotivo     motipere.mopecodi%TYPE;
    sbCausa      ordetrab.ortrcatr%TYPE; 
    vaComodin    VARCHAR2(2000); 
    nuComodin    NUMBER := 0;
    sbError      VARCHAR2(2000);
   
    --<<
    -- Cursor de Datos Generales del Suscriptor
    -->>
    CURSOR cuSuscripc
        IS
    SELECT * FROM suscripc, servsusc 
     WHERE sesususc = susccodi
       AND sesususc = nuSuscri
       AND sesuserv = 1;
       
    --<<
    -- Cursor para obtener los datos de la dependencia
    -->> 
    CURSOR cuFuncDepe(nuFunc   funciona.funccodi%TYPE)
        IS
    SELECT funcdepe
      FROM funciona f
     WHERE f.funccodi = nuFunc; 
    
  BEGIN
       
     --<<
     -- Funcion que se encarga de traer el motivo 
     -->>
     provapatapa('COD_IVR_MOT_ID', 'N', nuMotivo, vaComodin);
      
     --<<
     -- Funcion que se encarga de traer el causa 
     -->>
     provapatapa('COD_IVR_CAU_ID', 'S', nuComodin, sbCausa);
          
     FOR rgcuSuscripc IN cuSuscripc LOOP
       
         --<<
         -- Creacion del Motivo asociado al proceso del IVR
         -->>
         nuOk := fsbCreaATOT(nuSuscrip => nuSuscri,
                             nuMotivos => nuMotivo,
                             sbCausal  => sbCausa,
                             sbObserv  => 'IVR REQUISITOS PARA CAMBIO DE  IDENTIFICACION DE CLIENTE',
                             sbDetall  => 'IVR REQUISITOS PARA CAMBIO DE  IDENTIFICACION DE CLIENTE');
                                
         --<<
         -- Control de error
         -->>                    
         IF nuOk = -1 THEN
            sbError := 'ERROR'||'|'||'NO SE PUDO GENERAR EL PQR'||'||';
            RAISE expCreaAten;
            
         END IF;                                                                      

         nuError := 0;
     
     END LOOP;
     
     COMMIT;
             
     RETURN(nuError);

  EXCEPTION
    WHEN expCreaAten THEN
       ROLLBACK;
       sbError := sbError||' [pkIVREfigas.FBSALDO] - '||SQLERRM||' '||DBMS_UTILITY.format_error_backtrace;
       pkregidepu.pRegiMensaje('EXCEPTION Error',sbError, 'PKIVR');  
    WHEN OTHERS THEN
       rollback;
       sbError :=  '[pkWebSurtigas.fnuInsPere] - '||SQLERRM||' '||DBMS_UTILITY.format_error_backtrace;
       pkregidepu.pRegiMensaje('EXCEPTION Error',sbError, 'PKIVR');
       RETURN(nuError);

  END fsbUpdateIdentificacion;
  
  FUNCTION fsbUpdateDireccion(nuSuscri     servsusc.sesunuse%TYPE)
  /*****************************************************************************
  PROPIEDAD INTELECTUAL DE EFIGAS
  FUNCION      : fsbCupoDisponible
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 28-01-2013
  DESCRIPCION  : Se encarga de validar el cupo brilla

  Parametros de Entrada
             - SUSCRIPTOR

  Parametros de Salida
             -  Cupo disponible por un suscritor


  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/
  RETURN VARCHAR2 IS

    --<<
    -- Parametros
    -->>
    nuOk         NUMBER := -1;    
    nuError      NUMBER := -1;
    nuMotivo     motipere.mopecodi%TYPE;
    sbCausa      ordetrab.ortrcatr%TYPE; 
    vaComodin    VARCHAR2(2000); 
    nuComodin    NUMBER := 0;
    sbError      VARCHAR2(2000);
                
    --<<
    -- Cursor de Datos Generales del Suscriptor
    -->>
    CURSOR cuSuscripc
        IS
    SELECT * FROM suscripc, servsusc 
     WHERE sesususc = susccodi
       AND sesususc = nuSuscri
       AND sesuserv = 1;
           
  BEGIN
    
     
     --<<
     -- Funcion que se encarga de traer el motivo 
     -->>
     provapatapa('COD_IVR_MOT_DIR', 'N', nuMotivo, vaComodin);
      
     --<<
     -- Funcion que se encarga de traer el causa 
     -->>
     provapatapa('COD_IVR_CAU_DIR', 'S', nuComodin, sbCausa);
     
     FOR rgcuSuscripc IN cuSuscripc LOOP
       
         --<<
         -- Creacion del Motivo asociado al proceso del IVR
         -->>
         nuOk := fsbCreaATOT(nuSuscrip => nuSuscri,
                             nuMotivos => nuMotivo,
                             sbCausal  => sbCausa,
                             sbObserv  => 'IVR REQUISITOS PARA CORRECION DE DIRECCION',
                             sbDetall  => 'IVR REQUISITOS PARA CORRECION DE DIRECCION');
                                
         --<<
         -- Control de error
         -->>                    
         IF nuOk = -1 THEN
            sbError := 'ERROR'||'|'||'NO SE PUDO GENERAR EL PQR'||'||';
            RAISE expCreaAten;
            
         END IF;                                                                      

         nuError := 0;
     
     END LOOP;
     
     COMMIT;
             
     RETURN(nuError);

  EXCEPTION
    WHEN expCreaAten THEN
       ROLLBACK;
       sbError := sbError||' [pkIVREfigas.FBSALDO] - '||SQLERRM||' '||DBMS_UTILITY.format_error_backtrace;
       pkregidepu.pRegiMensaje('EXCEPTION Error',sbError, 'PKIVR');  
    WHEN OTHERS THEN
       rollback;
       sbError :=  '[pkWebSurtigas.fnuInsPere] - '||SQLERRM||' '||DBMS_UTILITY.format_error_backtrace;
       pkregidepu.pRegiMensaje('EXCEPTION Error',sbError, 'PKIVR');
       RETURN(-5);  

  END fsbUpdateDireccion;
    
  FUNCTION fsbInfoSegura(nuSuscri IN servsusc.sesunuse%TYPE)
  /*****************************************************************************
  PROPIEDAD INTELECTUAL DE EFIGAS
  FUNCION      : prcSaldoMedidor
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 28-01-2013
  DESCRIPCION  : Procedimiento que se encarga de obtener el saldo y la lectura del medidor de un suscriptor

  Parametros de Entrada
             - SUSCRIPTOR

  Parametros de Salida
             -
             -

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/
  RETURN VARCHAR2 IS

    --<<
    -- cursor para determinar datos de la revisión segura
    -->>
    CURSOR cuRevSegura(nuItem prunittl.puititem%TYPE,
                       nuTipl prunittl.puittilp%TYPE) 
        IS
    SELECT S.*
      FROM (SELECT *
              FROM prunittl p
             WHERE p.puititem = nuItem
               AND p.puittilp = nuTipl
             ORDER BY p.puitffvi DESC) S
     WHERE ROWNUM = 1;
     
    --<<
    -- Cursor para determinar los datos del suscriptor
    -->> 
    CURSOR cuSuscripc
        IS
    SELECT s.susccate, l.locatilp 
      FROM suscripc s, localida l
     WHERE s.suscdepa = l.locadepa
       AND s.suscloca = l.locacodi
       AND s.susccodi = nuSuscri;
    
    
    --<<
    -- Parametros
    -->>
    sbError       VARCHAR2(2000) := 'ERROR'||'|'||'NO SE PUDO VALIDAR LA INFORMACION DE LA REVISION SEGURA '||'|';
    nuValor       NUMBER := 0;
    nuOk          NUMBER := 0;
    
    
  BEGIN
     
    --<<
    -- Inicializacion
    -->>
    nuValor := 0;
    
    --<<
    -- Obtengo los datos del suscriptor
    -->>
    FOR rgCuSuscripc IN cuSuscripc LOOP
      
        IF (rgCuSuscripc.susccate = 1) THEN
          
            --<<
            -- Se obtiene el valor del costo de la revision segura
            -->>
            FOR rgCuRevSegura IN cuRevSegura(323, rgCuSuscripc.Locatilp) LOOP
            
                nuValor := rgCuRevSegura.Puitcost;
            
            END LOOP;
        
        ELSIF (rgCuSuscripc.susccate = 2) THEN   

            --<<
            -- Se obtiene el valor del costo de la revision segura
            -->>
            FOR rgCuRevSegura IN cuRevSegura(383, rgCuSuscripc.Locatilp) LOOP
            
                nuValor := rgCuRevSegura.Puitcost;
            
            END LOOP;  
            
        ELSE
                             
            RETURN(sbError);
        
        END IF;
        
        --<<
        -- Creacion del Motivo asociado al proceso del IVR
        -->>
        nuOk := fsbCreaATOT(nuSuscrip => nuSuscri,
                            nuMotivos => 1000,
                            sbCausal  => '47',
                            sbObserv  => 'IVR PARA CONOCER EL VALOR, TIEMPO DE FINANCION Y FECHA APROXIMADA DE LA REVISION SEGURA',
                            sbDetall  => 'IVR PARA CONOCER EL VALOR, TIEMPO DE FINANCION Y FECHA APROXIMADA DE LA REVISION SEGURA');
                                
        --<<
        -- Control de error
        -->>                    
        IF nuOk = -1 THEN
            
           sbError := 'ERROR'||'|'||'NO SE PUDO GENERAR EL PQR'||'||';
           RAISE expCreaAten;
            
        END IF; 
        
        sbError := nuValor||'|'||12||'|'||to_char(TO_DATE(SYSDATE),'DD/MM/YYYY');       
    
    END LOOP;
    
    COMMIT;
     
    RETURN(sbError);
    
    EXCEPTION
    WHEN expCreaAten THEN
       ROLLBACK;
       RETURN(sbError);  
    WHEN OTHERS THEN
       sbError := ' [pkIVREfigas.FBSALDO] - '||SQLERRM||' '||DBMS_UTILITY.format_error_backtrace;
       pkregidepu.pRegiMensaje('EXCEPTION Error',sbError, 'PKIVR');
       sbError := 'ERROR'||'|'||sbError||'||';
       RETURN(sbError);

  END fsbInfoSegura;

  FUNCTION fsbInfoFactura(nuSuscri IN servsusc.sesunuse%TYPE)
  /*****************************************************************************
  PROPIEDAD INTELECTUAL DE EFIGAS
  FUNCION      : fsbInfoFacturaActual
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 10-12-2012
  DESCRIPCION  : Funcion que se encarga de validar el detalle de la factura del
                 suscriptor.

  Parametros de Entrada
             - SUSCRIPTOR

  Parametros de Salida
             -
             -

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/
  RETURN VARCHAR2 IS

    --<<
    -- Parametros
    -->>
    nuCuponCod    pagos.pagocupo%TYPE := 0;
    sbPagoFepa    pagos.pagofepa%TYPE := NULL;
    nuPagoVapa    pagos.pagovapa%TYPE := 0;
    nuSuscSape    suscripc.suscsape%TYPE := 0;
    nuSusccodi    suscripc.susccodi%TYPE := 0;
    sbFechLimi    VARCHAR2(2000) := 'ERROR';
    nuContador    NUMBER := 0;
    nuControl     NUMBER := -1;
    nuOk          NUMBER := 0;    
    sbError       VARCHAR2(2000) := 'ERROR'||'|'||'NO SE PUDO VALIDAR LA INFORMACION DE LA FACTURA'||'||';
    
    --<<
    -- Cursor para Determinar datos del ultimo pago efectuado por el usuario
    -->>
    CURSOR cuPagos
        IS
/*    SELECT *
      FROM (SELECT susccicl, pagocupo, pagofepa, suscsape, SUM(pagovapa) pagovapa
              FROM pagos p, cucocupo c, cuencobr a, servsusc s, suscripc b
             WHERE p.pagocupo = c.cccucupo
               AND a.cucocodi = c.cccucuco
               AND a.cuconuse = s.sesunuse
               AND b.susccodi = s.sesususc
               AND b.susccodi = nuSuscri
             GROUP BY susccicl, pagocupo, pagofepa, suscsape
             ORDER BY pagofepa DESC) a
      WHERE ROWNUM < 2; */   
      SELECT *
        FROM (SELECT cargcicl susccicl, pagocupo, pagofepa, suscsape, sum(cargvalo) pagovapa
                FROM pagos p, cargos c, suscripc s
               WHERE c.cargcodo = p.pagocupo
                 AND c.cargsusc = s.susccodi
                 AND c.cargsign IN ('PA','SA')
                 AND c.cargsusc = nuSuscri
               GROUP BY cargcicl, pagocupo, pagofepa, suscsape
               ORDER BY pagofepa DESC) c
       WHERE ROWNUM < 2;      
      
      
    --<<
    -- Cursor para determinar el mensaje comodin
    -->>  
    CURSOR cuCuentas
        IS
    SELECT cucosusc, nvl(COUNT(1),0) contador
      FROM cuencobr, servsusc   
     WHERE cuconuse = sesunuse
       AND sesuserv = 1
       AND cucosusc = nuSuscri
       AND cucosacu > 0
     GROUP BY cucosusc;
     
    --<<
    -- Cursor para validar la fecha limite de PAgo
    -->>
    CURSOR cuPerifact(nuCicli perifact.pefacicl%TYPE)
        IS
    SELECT pefafepa
      FROM (SELECT pefafepa
              FROM perifact
             WHERE pefacicl = nuCicli
               AND pefaactu NOT IN ('S', 's')
               AND pefafgcc IN ('S', 's')
             ORDER BY pefaano DESC, pefames DESC)
     WHERE rownum = 1;     
     
    --<<
    -- Cursor para determinar datos basicos del suscriptor
    -->>
    CURSOR cuSuscripc
        IS
    SELECT s.susccicl
      FROM suscripc s
     WHERE s.susccodi = nuSuscri; 
          
  BEGIN
    
    --<<
    -- Se obtiene los datos del ultimo pago realizado
    -->>
    FOR rgCuPagos IN cuPagos LOOP
      
        --<<
        -- control
        -->>
        nuControl := 0;
      
        --<<
        -- Fecha de Pago
        -->>
        sbPagoFepa := rgCuPagos.pagofepa;
        
        --<<
        -- Valor del Pago
        -->>
        nuPagoVapa := rgCuPagos.Pagovapa;
        
        --<<
        -- Saldo pendiente del usuario
        -->>
        nuSuscSape := rgCuPagos.Suscsape;
        
        --<<
        -- Cupon de Pago
        -->>
        nuCuponCod := rgCuPagos.Pagocupo;
        
    END LOOP;
    
    --<<
    -- Se evalua el control
    -->>
    IF nuControl = 0 THEN
      
        --<<
        -- Creacion del Motivo asociado al proceso del IVR
        -->>
        nuOk := fsbCreaATOT(nuSuscrip => nuSuscri,
                            nuMotivos => 1000,
                            sbCausal  => 41,
                            sbObserv  => 'IVR VALOR DE LA ÚLTIMA FACTURA Y FECHA DE PAGO.',
                            sbDetall  => 'IVR VALOR DE LA ÚLTIMA FACTURA Y FECHA DE PAGO.');
                            
        --<<
        -- Control de error
        -->>                    
        IF nuOk = -1 THEN
        
           sbError := 'ERROR'||'|'||'NO SE PUDO GENERAR EL PQR'||'||';
           RAISE expCreaAten;
        
        END IF;                    
                           
        --<<
        -- Obtengo el ciclo de asociado al suscriptor
        -->>
        FOR rgCuSuscripc IN cuSuscripc LOOP

            --<<
            -- Obtengo la fecha limite de pago
            -->>    
            FOR rgCuPerifact IN cuPerifact(rgCuSuscripc.Susccicl) LOOP
                                 
                sbFechLimi := to_char(to_date(rgCuPerifact.Pefafepa),'DD/MM/YYYY');
                  
            END LOOP;
                          
        END LOOP;                 
          
        OPEN cuCuentas;
        FETCH cuCuentas INTO nuSusccodi, nuContador;
        CLOSE cuCuentas;
          
        IF ((nuContador = 0) OR (nuContador = 1 AND TO_DATE(sbFechLimi,'DD/MM/YYYY') > SYSDATE) ) THEN
            
            sbError := to_char(to_date(sbPagoFepa), 'DD/MM/YYYY')||'|'||nuPagoVapa||'|'||nuSuscSape||'|'||sbFechLimi||'|'||nuCuponCod;
             
        ELSIF ((nuContador = 1 AND TO_DATE(sbFechLimi,'DD/MM/YYYY') < SYSDATE) OR nuContador > 1 ) THEN
          
               sbError := to_char(to_date(sbPagoFepa), 'DD/MM/YYYY')||'|'||nuPagoVapa||'|'||nuSuscSape||'|'||'SU FECHA DE PAGO ES INMEDIATA'||'|'||nuCuponCod;        
          
        END IF;           
            
    END IF;

    --<<
    -- Incializacion - finCreaAtencion
    -->>
    COMMIT;

    RETURN(sbError);

  EXCEPTION
    WHEN expCreaAten THEN
       ROLLBACK;
       RETURN(sbError);  
    WHEN OTHERS THEN
       ROLLBACK;
       sbError := ' [pkIVREfigas.FSBINFOFACTURAACTUAL] - '||SQLERRM||' '||DBMS_UTILITY.format_error_backtrace;
       pkregidepu.pRegiMensaje('EXCEPTION Error',sbError, 'PKIVR');
       sbError := 'ERROR'||'|'||sbError||'||';
       RETURN(sbError);

  END fsbInfoFactura;
     
  FUNCTION fsbCreaATOT(nuSuscrip  IN suscripc.susccodi%TYPE,           
                       nuMotivos  IN motipere.mopecodi%TYPE,
                       sbCausal   IN causpere.capecodi%TYPE,
                       sbObserv   IN ordetrab.ortrobse%TYPE,
                       sbDetall   IN ordetrab.ortrobse%TYPE DEFAULT NULL)
  /*****************************************************************************
  PROPIEDAD INTELECTUAL DE EFIGAS
  FUNCION      : fsbCreaATOT
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 10-12-2012
  DESCRIPCION  : Funcion que se encarga de crear las AT y OT asociadas al IVR

  Parametros de Entrada
             - SUSCRIPTOR

  Parametros de Salida
               0 [EXISTE SUSCRIPTOR]
             - 1 [NO EXISTE SUSCRIPTOR]

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/
  RETURN NUMBER IS

    --<<
    -- Parametros
    -->>
    nuError NUMBER := 0;
    sbError VARCHAR2(2000) := NULL;
    expOtAt EXCEPTION;
    --contador NUMBER := 0;
    
    --<<
    -- Cursor para inicializa la data del paquete pkvaliortr
    -->>
    CURSOR cuPkValiOrtr 
        IS
    SELECT o.* FROM ordetrab o, perequej p
     WHERE o.ortrdnpe = p.peredepa
       AND o.ortrlnpe = p.pereloca
       and o.ortrpere = p.perecodi
       AND p.peresusc = nuSuscrip
       and p.peremope = nuMotivos
       and p.pereespe = 'RE'
       AND rownum < 2
     ORDER BY p.perefecr DESC;

  BEGIN
       
  --<<
  -- Obtiene datos basicos del suscriptor para registrar la pqr
  -->>
  FOR rgcuDataSusc IN cuDataSusc(nuSuscrip) LOOP

      --<<
      -- Creacion de la solicitud de llamada por medio del IVR
      -->>  
      nuError := finCreaAtencion(nuDepaCodi => rgcuDataSusc.Suscdepa,
                                 nuLocaCodi => rgcuDataSusc.Suscloca,
                                 nuSuscCodi => rgcuDataSusc.Susccodi,
                                 nuServCodi => rgcuDataSusc.Sesuserv,
                                 nuNumeServ => rgcuDataSusc.Sesunuse,
                                 sbCodiMoti => nuMotivos,
                                 nuCodiFunc => PkFuncionaMgr.fnuGetUserCode(USER),
                                 sbMensaje  => sbError); 
                                    
      --<<
      -- Control del Retorno            
      -->>                  
      IF nuError = -1 THEN
              
         RETURN(-1);
         
      ELSE
        
         --<<
         -- Obtengo los datos globales del pkValiOrtr
         -->>
         OPEN cuPkValiOrtr;
         FETCH cuPkValiOrtr INTO pkValiOrtr.GrgOrdeTrab;
         CLOSE cuPkValiOrtr;
        
         BEGIN
             --<<
             -- Actualiza el Estado de la AT
             -->> 
             procaespere(nuDepa => Pkvaliortr.GrgOrdeTrab.Ortrdnpe,
                         nuLoca => Pkvaliortr.GrgOrdeTrab.Ortrlnpe,
                         nuPere => Pkvaliortr.GrgOrdeTrab.Ortrpere,
                         nuNuevEsta => 'SO' ,
                         sbObse => 'CONSULTA IVR');
             --<<
             -- Actualiza el Estado de la OT
             -->>                   
             procaesortr(nuDepa => Pkvaliortr.GrgOrdeTrab.ortrdenu,
                         nuLoca => Pkvaliortr.GrgOrdeTrab.ortrlonu,
                         nuOrtr => Pkvaliortr.GrgOrdeTrab.ortrnume,
                         nuNuevEsta => 3,
                         nuFunc => PkFuncionaMgr.fnuGetUserCode(USER),
                         nuCausCamb => sbCausal,
                         sbObse => 'CONSULTA IVR');
                         
            --<<
            -- Actualizacion atencion
            -->>
            UPDATE perequej p
               SET p.perefeat = SYSDATE,
                   p.peremere = 'IV',
                   p.pereobse = sbDetall
             WHERE p.peredepa = Pkvaliortr.GrgOrdeTrab.Ortrdnpe
               AND p.pereloca = Pkvaliortr.GrgOrdeTrab.Ortrlnpe 
               AND p.perecodi = Pkvaliortr.GrgOrdeTrab.Ortrpere;    
            
            --<<
            -- Actualizacion orden de trabajo
            -->>   
            UPDATE ordetrab o
               SET o.ortrfele = SYSDATE,   
                   o.ortrobse = sbObserv,
                   o.ortrcatr = sbCausal
             WHERE o.ortrdenu = Pkvaliortr.GrgOrdeTrab.ortrdenu
               AND o.ortrlonu = Pkvaliortr.GrgOrdeTrab.ortrlonu
               AND o.ortrnume = Pkvaliortr.GrgOrdeTrab.ortrnume;  
               
           --<<
           -- Se insertan los datos Adicionales
           -->>                             
           nuError := pkregipere.fininvacasoli(nucoddep => Pkvaliortr.GrgOrdeTrab.Ortrdnpe,
                                               nucodloc => Pkvaliortr.GrgOrdeTrab.Ortrlnpe,
                                               nucodper => Pkvaliortr.GrgOrdeTrab.Ortrpere,
                                               nucodser => Pkvaliortr.GrgOrdeTrab.Ortrserv,
                                               sbcodgru => 'INFO',
                                               sbcoddat => 'CODIGO',
                                               nuconsec => 1,
                                               sbvaldat => sbCausal);
               
           EXCEPTION
             WHEN OTHERS THEN
               ROLLBACK;
               RAISE expOtAt;                                 
           END;      
            
      END IF;  
                    
  END LOOP;  
 
  RETURN(nuError);

  EXCEPTION
    WHEN expOtAt THEN
       sbError :=  '[pkIVREfigas.FSBCREAATOT] - '||SQLERRM||' '||DBMS_UTILITY.format_error_backtrace;
       pkregidepu.pRegiMensaje('EXCEPTION Error',sbError, 'PKIVR');
       RETURN(-1);
    WHEN OTHERS THEN
       sbError :=  '[pkIVREfigas.FSBCREAATOT] - '||SQLERRM||' '||DBMS_UTILITY.format_error_backtrace;
       pkregidepu.pRegiMensaje('EXCEPTION Error',sbError, 'PKIVR');
       RETURN(-1);
  END fsbCreaATOT;  

  
  
  PROCEDURE  prcFSBSaldoXServicio(nuSuscri  IN  servsusc.sesususc%TYPE,
                                  nuServic  IN  servsusc.sesuserv%TYPE DEFAULT -1,                
                                  fbsCursor OUT Sys_Refcursor) IS
  /*****************************************************************************
  PROPIEDAD INTELECTUAL DE EFIGAS
  FUNCION      : prcFSBSaldoXServicio
  AUTOR        : Jose Ricardo Gallego 
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 10-03-2012
  DESCRIPCION  : Funcion que se encarga de obtener los saldos por servicio de un 
                 suscriptor

  Parametros de Entrada
             - SUSCRIPTOR

  Parametros de Salida
               0 [EXISTE SUSCRIPTOR]
             - 1 [NO EXISTE SUSCRIPTOR]

  Historia de Modificaciones
  Autor       Fecha       Descripcion
  JRGallego   22/04/2013  Validar que se envie el saldo de un servicio que se solicita         
  *****************************************************************************/                               
    --<< 
    -- Parametros
    -->>
    sbError                VARCHAR2(2000) := NULL;
    voCursor               Sys_Refcursor:=NULL;
      
  BEGIN

    --<<
    -- 
    -->>
    OPEN voCursor FOR
      SELECT C.SESUSUSC,
       C.SESUSERV,
       SUM(SESUSAPE) SESUSAPE,
       SUM(DIFESAPE) DIFESAPE,
       SUM(SESUSAPE) + SUM(DIFESAPE) TOTAL_DEUDA
  FROM (SELECT SESUSUSC, SESUSERV, SUM(SESUSAPE) SESUSAPE, 0 DIFESAPE
          FROM SERVSUSC
         WHERE SESUSUSC = NUSUSCRI
         GROUP BY SESUSUSC, SESUSERV
        UNION ALL
        SELECT NUSUSCRI SESUSUSC, SERVCODI SESUSERV, 0 SESUSAPE, 0 DIFESAPE
          FROM SERVICIO
         WHERE SERVCODI > -1
        UNION ALL
        SELECT DIFESUSC SESUSUSC,
               DIFESERV SESUSERV,
               0 SESUSAPE,
               SUM(DIFESAPE) DIFESAPE
          FROM DIFERIDO
         WHERE DIFESUSC = NUSUSCRI
           AND DIFESAPE > 0
         GROUP BY DIFESUSC, DIFESERV) C
 WHERE SESUSERV = decode(nuServic, -1, SESUSERV, nuServic)
 --WHERE SESUSERV = nuServic
 GROUP BY C.SESUSUSC, C.SESUSERV
 ORDER BY C.SESUSERV ASC;
       
  fbsCursor := voCursor;    

  EXCEPTION
    WHEN OTHERS THEN
      sbError := '[PKIVRSURTIGAS.PRCFSBSALDOXSERVICIO] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
      pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
      
  END prcFSBSaldoXServicio;
  

end pkIVREfigas;
/
