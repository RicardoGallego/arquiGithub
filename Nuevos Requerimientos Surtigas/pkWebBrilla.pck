CREATE OR REPLACE PACKAGE pkWebBrilla IS
  /************************************************************************
     Propiedad intelectual PROYECTO SURTIGAS S.A.

     PAQUETE   : pkWebBrilla
     AUTOR     : Jose Ricardo Gallego
     EMPRESA   : ArquitecSoft S.A.S
     FECHA     : 11-14-2012
     DESCRIPCION  : Paquete que maneja la logica de la parte web de brilla
                    para surtigas.

    Historia de Modificaciones
    Autor    Fecha       Descripcion

  ************************************************************************/

  --<<
  -- Funcion que Retorna el codigo de la solicitud de la venta 
  -->>
  FUNCTION fnuSoliciVenta RETURN NUMBER;  
  
  --<<
  -- Funcion para validar si el suscriptor existe y si esta habilitado para
  -- relizar un credito en brilla
  -->>

  FUNCTION fnuSuscriptorActivo(nusesunuse IN negoserv.nesenuse%TYPE)
  RETURN NUMBER;

  --<<
  -- Procedimiento para desplegar la informacion que debe de entregarse a los 
  -- suscriptores de brilla
  -->>
    
  PROCEDURE prcInfoBrilla(nusesunuse IN negoserv.nesenuse%TYPE, 
                          prfCursor OUT Sys_Refcursor);
  
  --<<
  -- Jorgemg - ArquitecSoft
  -- Fecha: 25/11/2012
  -- Procedimiento para dejar registro de la consulta de datacredito
  -- en la tabla vadacre
  -->>                             
  PROCEDURE prInsVadacre(sbCedula        IN vadacre.vdtciden%TYPE,
                         nuServsue       IN vadacre.vdtcnuse%TYPE,
                         nuSusccod       IN vadacre.vdtcsusc%TYPE,
                         sbNombre        IN vadacre.vdtcnom%TYPE, 
                         sbPrimerAL      IN vadacre.vdtdpapel%TYPE,
                         nuSolVenta      IN vadacre.vdtccpve%TYPE,
                         sbFechExpe      IN vadacre.vdtcfeex%TYPE,
                         sbFechCont      IN vadacre.vdtcfeco%TYPE,
                         sbNomCiuda      IN vadacre.vdtcciud%TYPE,
                         sbDepartam      IN vadacre.vdtcdepa%TYPE,
                         sbEdad          IN vadacre.vdtcedad%TYPE,
                         sbGenero        IN vadacre.vdtcgene%TYPE,
                         sbEstado        IN vadacre.vdtcesta%TYPE);                          
                          
  --<<
  -- Jorgemg - ArquitecSoft
  -- Fecha: 20/11/2012
  -- Procedimiento para el manejo de la logica del registro de la venta Web 
  -->>                          
  PROCEDURE prcInfoDeudor(nuSesunuse IN servsusc.sesunuse%TYPE,
                          nuFacturaA IN cuencobr.cucocodi%TYPE,
                          nuFacturaB IN cuencobr.cucocodi%TYPE,
                          dtFechLimA IN VARCHAR2,
                          dtFechLimB IN VARCHAR2,
                          --cuRefInFoC OUT Sys_Refcursor,
                          cuRefDeudo OUT Sys_Refcursor,
                          sbOutError OUT VARCHAR2);

  --<<
  -- Jorgemg - ArquitecSoft
  -- Fecha: 25/11/2012
  -- Informacion del codeudor
  -->>                                
  PROCEDURE prcInfoCoDeudor(nuSesunuse   IN servsusc.sesunuse%TYPE,
                            cuRefCoDeudo OUT Sys_Refcursor,
                            sbOutError   OUT VARCHAR2);                          
  
  --<<
  -- jrGallego - ArquitecSoft
  -- Fecha: 21/11/2012
  -- Funcion que calcula si un suscritor no tiene el maximo de edad 
  -- definido por brilla para un credito 
  -->>                            
  FUNCTION fnuEdadMaximaDeudor(fechaNaciemto IN VARCHAR2)
  RETURN NUMBER;
  
  --<<
  -- jrGallego - ArquitecSoft
  -- Fecha: 21/11/2012
  -- Funcion que calcula si un suscritor no tiene el maximo de edad 
  -- definido por brilla para un credito 
  -->>                            
  FUNCTION fnuEdadMaximaCoDeudor(fechaNaciemto VARCHAR2)
  RETURN NUMBER;  
  
  --<<
  -- Jorgemg - ArquitecSoft
  -- Fecha: 25/11/2012
  -- Funcion para obtener el listado de los productos a financiar
  -->>   
  FUNCTION fcuRefClaseVenta RETURN SYS_REFCURSOR;
  
  --<<
  -- Jorgemg - ArquitecSoft
  -- Fecha: 20/11/2012
  -- Funcion para obtener el listado de productos por la clase de venta y proveedor
  -->>   
  FUNCTION fcuRefVentProveedores(nuCuadrilla cuadcont.cuadcodi%TYPE,
                                 nuClaseVent tivtafnb.tifncodi%TYPE) 
  RETURN SYS_REFCURSOR;  
  
  --<<
  -- Jorgemg - ArquitecSoft
  -- Fecha: 22/11/2012
  -- Funcion obtener el listado de proveedores aptos para la venta de credito Web
  -->>   
  FUNCTION fcuRefProveedores(nuTipoVenta tivtafnb.tifncodi%TYPE)
  RETURN SYS_REFCURSOR;   

  --<<
  -- Jorgemg - ArquitecSoft
  -- Fecha: 22/11/2012
  -- Funcion para la lista de agrupaciones de productos de ventas fnb
  -->>   
  FUNCTION fcuRefAgrupaFNB RETURN SYS_REFCURSOR;   
  
  --<<
  -- Jorgemg - ArquitecSoft
  -- fecha: 22/11/2012
  -- Procedimiento para validar si el usuario requiere validar estado en datacredito
  -->>
  PROCEDURE proDataCredito(nuSesunuse IN servsusc.sesunuse%TYPE,
                           nuSoliVent IN ventafnb.vefncpve%TYPE,
                           sbCedula   IN suscripc.suscnice%TYPE,
                           nuCuadCont IN cuadcont.cuadcodi%TYPE,
                           nuTecncodi IN tecnico.tecncodi%TYPE,
                           nuSucursal IN sucursal.codsucu%TYPE,
                           sbApellido IN VARCHAR2,
                           cuRefVaDat OUT SYS_REFCURSOR,
                           sbErrorIn  OUT VARCHAR2);
                           
  
  --<<
  -- Metodo para saber si el proveedor elegido tiene un extracupo
  -->>
  PROCEDURE proExtraCupo(nuCuadCont IN  cuadcont.cuadcodi%TYPE,
                         nuNeseSuca IN  negoserv.nesesuca%TYPE,
                         nuNeseCuut IN  negoserv.nesecuut%TYPE,
                         nuValPromo OUT promcupo.promvalo%TYPE, 
                         sbOutError OUT VARCHAR2);           
                         
  --<<
  -- Funcion para obtener la tasa de financiacion actual
  -->> 
  FUNCTION fnuTasaDispFNB RETURN NUMBER; 
  
  --<<
  -- Funcion para validar la cuota maxima permitida por estrato
  -->>
  FUNCTION fnuCuotaMaxEstrato(nuCatecodi IN cumesfnb.cufncate%TYPE,
                              nuSubCateg IN cumesfnb.cufnsuca%TYPE)
  RETURN NUMBER;  
  
  --<<
  -- Funcion para actualizar los cupos del usuario
  -->>
  FUNCTION fnuActuCupos(nuSesunuse IN negoserv.nesenuse%TYPE,
                        nuValTotVe IN negoserv.nesecuut%TYPE,
                        nuNeseVain IN negoserv.nesevain%TYPE)
  RETURN NUMBER;  
  
  --<<
  -- Funcion para validar facturas con saldo
  -->>
  FUNCTION fnuCuentaConSaldo(nuSesunuse IN negoserv.nesenuse%TYPE)
  RETURN NUMBER;
  
  --<<
  -- Funcion para si el codeudor tiene deuda diferida pendiente
  -->>
  FUNCTION fnuValDifCodeudor(nuCedula IN suscripc.suscnice%TYPE)
  RETURN NUMBER;  
  
  --<<
  -- Funcion para Obtener las sucursales habiles para el proceso web
  -->>
  FUNCTION fnuSucursalWEB(nuCuadCont IN cuadcont.cuadcodi%TYPE) 
  RETURN SYS_REFCURSOR;
  
  --<<
  -- Funcion para Obtener los tecnicos habiles para el proceso web
  -->>
  FUNCTION fnuTecnicosWEB(nuCuadCont IN cuadcont.cuadcodi%TYPE) 
  RETURN SYS_REFCURSOR;  
  
  --<<
  -- Funcion de inicializacion de acuerdo a su ultima compra de brilla
  -->>
  FUNCTION fnuIniData(nuSesunuse  IN negoserv.nesenuse%TYPE)
  RETURN SYS_REFCURSOR;
  
  
  --<<
  -- Procedimiento que se encarga de hacer persistente la data de la venta
  -->>                                   
  PROCEDURE proGuardarVentaFNB(nuvefndepa  IN  ventafnb.vefndepa%type,--codigo departamento de donde se registra la venta                                                                            
                             nuvefnloca  IN  ventafnb.vefnloca%type,--codigo localidad de donde se registra la venta
                             --dtvefnfere  IN  ventafnb.vefnfere%type DEFAULT SYSDATE,--fecha de registro de la venta en el sistema
                             --dtvefnfrvt  IN  ventafnb.vefnfrvt%TYPE DEFAULT SYSDATE,--fecha real reportada por el vendedor en la que se hace la venta
                             nuvefnsega  IN  ventafnb.vefnsega%TYPE,--codigo servicio de gas del usuario que compra
                             nuvefnsefn  IN  ventafnb.vefnsefn%type,--codigo servicio fnb asignado 
                             nuvefnvavt  IN  ventafnb.vefnvavt%type,--valor total de la venta
                             --nuvefntafi  IN  ventafnb.vefntafi%type,--tasa de financiacion de la venta
                             nuvefncpve  IN  ventafnb.vefncpve%type,--comprobande de venta o solicitud de credito de la venta
                             nuvefncopr  IN  ventafnb.vefncopr%type,--codigo contratista provedor donde se hace la venta
                             nuvefncove  IN  ventafnb.vefncove%type,--codigo contratista vendedor que hace la venta
                             nuvefnnucu  IN  ventafnb.vefnnucu%type,--numero de cuotas en la que se financiara el monto de la venta
                             sbvefndirr  IN  ventafnb.vefndirr%type,--direccion de la residencia del cliente
                             sbvefndiro  IN  ventafnb.vefndiro%type,--direccion de la oficina del cliente
                             sbvefntelr  IN  ventafnb.vefntelr%type,--telefono de la residencia del cliente
                             sbvefntelo  IN  ventafnb.vefntelo%type,--telefono de la oficina del cliente
                             sbvefnnice  IN  ventafnb.vefnnice%type,--
                             sbvefntecn  IN  ventafnb.vefntecn%type,--tecnico que hace la venta
                             --nuvefnvain  IN  ventafnb.vefnvain%type,--cuota inicial de venta o excedente pagado en surtigas
                             nuvefnclvt  IN  ventafnb.vefnclvt%type,--clase de venta, 1 vendedor externo, 2 punto venta 
                             sbvefnnomd  IN  ventafnb.vefnnomd%type,--nombre deudor
                             sbvefntido  IN  ventafnb.vefntido%type,--tipo de documento cc(cedula de ciudadania), ce(cedula extranjeria) nit(numero de identificacion tributaria)
                             sbvefnlued  IN  ventafnb.vefnlued%type,--lugar expedicion documento
                             dtvefnfeed  IN  VARCHAR2,--ventafnb.vefnfeed%type,--FECHA expedicion documento--
                             sbvefnsexo  IN  ventafnb.vefnsexo%type,--sexo m(asculino) f(emenino)
                             sbvefnesci  IN  ventafnb.vefnesci%type,--estado civil s(oltero), c(asado), u(nion libre), d(ivorciado o separado), v(iudo), r(eligioso)
                             dtvefnfena  IN  VARCHAR2,--ventafnb.vefnfena%type,--fecha de nacimiento--
                             SBVEFNNIES  IN  ventafnb.vefnnies%type,--niveles de estudio p(rimaria),b(achillerato),t(ecnologo) r(profesional)
                             sbvefndeba  IN  ventafnb.vefndeba%type,--descripcion del barrio
                             sbvefndeci  IN  ventafnb.vefndeci%type,--descripcion de la ciudad
                             sbvefndede  IN  ventafnb.vefndede%type,--descripcion del departamento
                             sbvefntivi  IN  ventafnb.vefntivi%type,--tipo de vivienda f(amiliar), p(ropia), a(rrendada)
                             sbvefnestd  IN  ventafnb.vefnestd%type,--descripcion del estrato
                             sbvefnanvi  IN  ventafnb.vefnanvi%type,--antiguedad de la vivienda
                             sbvefntifa  IN  ventafnb.vefntifa%type,--titular de la factura s(i) o n(o)
                             sbvefnreti  IN  ventafnb.vefnreti%type,--relacion con el titular c(onyuge), h(ijo),p(adre o madre),f(amiliar),a(rrendatario),m(amigo),o(tro)
                             nuvefnnpec  IN  ventafnb.vefnnpec%type,--nro de personas a cargo
                             sbvefnocu   IN  ventafnb.vefnocu%type,--ocupacion e(mpleado), i(ndpendiente), j(ubilado), a(ma de casa) n(estudiante) s(in)
                             sbvefnnemt  IN  ventafnb.vefnnemt%type,--nombre de la empresa donde trabaja
                             sbvefntel2  IN  ventafnb.vefntel2%type,--telefono
                             sbvefntece  IN  ventafnb.vefntece%type,--telefono celular
                             sbvefntico  IN  ventafnb.vefntico%type,--tipo de contrato f(ijo) i(ndefinido) t(emporal) o(tro)
                             sbvefnanla  IN  ventafnb.vefnanla%type,--antiguedad laboral
                             nuvefninme  IN  ventafnb.vefninme%type,--ingresos mensuales
                             nuvefngame  IN  ventafnb.vefngame%type,--gastos mensuales
                             sbvefnrefa  IN  ventafnb.vefnrefa%type,--referencia familiar
                             sbvefntfrf  IN  ventafnb.vefntfrf%type,--telefono fijo referencia familiar
                             sbvefntcrf  IN  ventafnb.vefntcrf%type,--telefono celular referencia familiar
                             sbvefnreco  IN  ventafnb.vefnreco%type,--referencia comercial
                             sbvefntffc  IN  ventafnb.vefntffc%type,--telefono fijo referencia comercial
                             sbvefntcrc  IN  ventafnb.vefntcrc%type,--telefono celular referencia comercial
                             SBVEFNNOMC  IN  ventafnb.vefnnomc%type,--nombre codeudor
                             sbvefntidc  IN  ventafnb.vefntidc%type,--tipo de documento codeudor cc(cedula de ciudadania), ce(cedula extranjeria) nit(numero de identificacion tributaria)
                             sbvefnnicc  IN  ventafnb.vefnnicc%type,--numero identificacion codeudor
                             sbvefnluec  IN  ventafnb.vefnluec%type,--lugar expedicion documento codeudor
                             dtvefnfeec  IN  VARCHAR2,--ventafnb.vefnfeec%type,--fecha expedicion documento codeudor--
                             sbvefnsexc  IN  ventafnb.vefnsexc%type,--sexo m(asculino) f(emenino) codeudor, na(no-aplica)
                             sbvefnescc  IN  ventafnb.vefnescc%type,--estado civil s(oltero), c(asado), u(nion libre), d(ivorciado o separado), v(iudo), r(eligioso) codeudor, na(no-aplica)
                             dtvefnfenc  IN  VARCHAR2,--ventafnb.vefnfenc%type,--fecha de nacimiento codeudor--
                             sbvefnniec  IN  ventafnb.vefnniec%type,--niveles de estudio p(rimaria),b(achillerato),t(ecnologo) r(profesional) codeudor, na(no-aplica)
                             sbvefndico  IN  ventafnb.vefndico%type,--direccion de codeudor
                             sbvefndebc  IN  ventafnb.vefndebc%type,--descripcion del barrio codeudor
                             sbvefndecc  IN  ventafnb.vefndecc%type,--descripcion de la ciudad codeudor
                             sbvefndedc  IN  ventafnb.vefndedc%type,--descripcion del departamento codeudor
                             sbvefnteco  IN  ventafnb.vefnteco%type,--telefono codeudor
                             sbvefntivc  IN  ventafnb.vefntivc%type,--tipo de vivienda f(amiliar), p(ropia), a(rrendada) codeudor, na(no-aplica)
                             sbvefnestc  IN  ventafnb.vefnestc%type,--descripcion del estrato codeudor
                             sbvefnanvc  IN  ventafnb.vefnanvc%type,--antiguedad de la vivienda codeudor
                             sbvefntifc  IN  ventafnb.vefntifc%type,--titular de la factura s(i) o n(o) codeudor, na(no-aplica)
                             sbvefnretc  IN  ventafnb.vefnretc%type,--relacion con el titular c(onyuge), h(ijo),p(adre o madre),f(amiliar),a(rrendatario),m(amigo),o(tro) codeudor, na(no-aplica)
                             nuvefnnpcc  IN  ventafnb.vefnnpcc%type,--nro de personas a cargo codeudor
                             sbvefnocuc  IN  ventafnb.vefnocuc%type,--ocupacion e(mpleado), i(ndpendiente), j(ubilado), a(ma de casa) n(estudiante) s(in) codeudor, na(no-aplica)
                             sbvefnnemc  IN  ventafnb.vefnnemc%type,--nombre de la empresa donde trabaja codeudor
                             sbvefntfcc  IN  ventafnb.vefntfcc%type,--
                             sbvefnrecc  IN  ventafnb.vefnrecc%type,--
                             sbvefncerc  IN  ventafnb.vefncerc%type,--
                             sbvefntfrc  IN  ventafnb.vefntfrc%type,--
                             sbvefnrefc  IN  ventafnb.vefnrefc%type,--
                             nuvefngamc  IN  ventafnb.vefngamc%type,--
                             nuvefninmc  IN  ventafnb.vefninmc%type,--
                             sbvefnacic  IN  ventafnb.vefnacic%type,--
                             sbvefnanlc  IN  ventafnb.vefnanlc%type,--
                             sbvefnticc  IN  ventafnb.vefnticc%type,--
                             sbvefntecc  IN  ventafnb.vefntecc%type,--
                             sbvefntee2  IN  ventafnb.vefntee2%type,--
                             sbvefnteec  IN  ventafnb.vefnteec%type,--
                             sbvefndiec  IN  ventafnb.vefndiec%type,--
                             sbvefnocin  IN  ventafnb.vefnocin%type,--
                             --sbvefnuser  IN  ventafnb.vefnuser%type,--usuario
                             --sbvefnterm  IN  ventafnb.vefnterm%TYPE,--terminal
                             nuvefnsucu  IN  ventafnb.vefnsucu%type,--sucursal
                             sbvefncode  IN  ventafnb.vefncode%type,--necesita codeudor
                             nuvefnvaiv  IN  ventafnb.vefnvaiv%type,--
                             sbvefnbin   IN  ventafnb.vefnbin%type,--
                             --nuvefngvli  IN  ventafnb.vefngvli%type,--secuencia de actas para gvli
                             nuvefncupo  IN  ventafnb.vefncupo%type,--
                             sbvefnmail  IN  ventafnb.vefnmail%type,--
                             --sbvefnticp  IN  ventafnb.vefnticp%type,--tipo de cpve (m)anual,(a)utomatico
                             nuvefnsgac  IN  ventafnb.vefnsgac%type,--servicio de gas del codeudor
                             --nuvefndoan  IN  ventafnb.vefndoan%type,--codigo departamento orden de anulacion
                             --nuvefnloan  IN  ventafnb.vefnloan%type,--codigo localidad orden de anulacion
                             --nuvefnotan  IN  ventafnb.vefnotan%TYPE,--codigo orden de anulacion
                             nuFacturaA  IN  cuencobr.cucocodi%TYPE,
                             nuFacturaB  IN  cuencobr.cucocodi%TYPE,
                             dtFechLimA  IN  VARCHAR2,
                             dtFechLimB  IN  VARCHAR2,
                             sbvefnacin  IN  ventafnb.vefnacin%type,--actividad para independiente                             
                             nuvefnvcpr  IN  ventafnb.vefnvcpr%type, --VALOR COMISION CONTRATISTA PROVEEDOR
                             nuvefnvadc  IN  ventafnb.vefnvadc%type, -- VALOR DESCUENTO
                             nuvefnvcve  IN  ventafnb.vefnvcve%type, -- VALOR COMISION CONTRATISTA VENDEDOR
                             nuvefncodi  OUT ventafnb.vefncodi%type,
                             sbMesaVent  OUT VARCHAR2);--codigo interno consecutivo de la venta
                             
  --<<
  -- Procediento para simular el pago de la deuda de la financiacion
  -->>
  PROCEDURE proCalSimulador(nuValFin   IN  cuadcont.cuadcodi%TYPE,
                            nuTotCuo   IN  negoserv.nesesuca%TYPE,                           
                            nuCuotas   IN  NUMBER,
                            nuVlrCuo   OUT NUMBER,
                            nuVlrSeg   OUT NUMBER,
                            sbOutErr   OUT VARCHAR2);                  
                            
  --<<
  -- Procediento Para retornar la version de formato y vigencia del CPVE
  -->>
  PROCEDURE proVersFechCPVE(nuVersion   OUT NUMBER,
                            sbFecVige   OUT VARCHAR2,
                            nuVerAuto   OUT NUMBER);   
                            
  --<<
  -- Funcion que se encarga de retornar los datos de la venta
  --<<
  FUNCTION fcuRefVentaFNB(nuvefnsega ventafnb.vefnsega%TYPE,
                          nuvefncpve ventafnb.vefncpve%TYPE,
                          nuvefncopr ventafnb.vefncopr%TYPE) 
  RETURN SYS_REFCURSOR;
  
  --<<
  -- Funcion que se encarga de llamar al proceso de legalizacion de la venta
  -->>
  FUNCTION fnuLegaVentaFNB(nuvefnsega ventafnb.vefnsega%TYPE,
                           nuvefndepa ventafnb.vefndepa%TYPE,
                           nuvefnloca ventafnb.vefnloca%TYPE,
                           nuvefncodi ventafnb.vefncodi%TYPE,
                           nuvefncpve ventafnb.vefncpve%TYPE,
                           nuvefncopr ventafnb.vefncopr%TYPE)
  RETURN VARCHAR2;        
  
  --<<
  -- Funcion para retornar el listado de ventas pendientes por legalizar
  -->>                                                   
  FUNCTION fcuRefVentaProveedores(nuvefncopr ventafnb.vefncopr%TYPE)
  RETURN SYS_REFCURSOR;

  --<<
  -- Funcion para retornar la informacion de las facturas utilizadas en la venta
  -->>                                                   
  FUNCTION fcuRefFacturas(nuvefnsega ventafnb.vefnsega%TYPE,
                          nuvefncpve ventafnb.vefncopr%TYPE)
  RETURN SYS_REFCURSOR; 
  
  --<<
  -- Funcion para retornar la descripcion del barrio
  -->>
  FUNCTION fsbDescBarrio(barrio barrio.barrcodi%TYPE,
                         depart barrio.barrdepa%TYPE,
                         locali barrio.barrloca%TYPE)
  RETURN VARCHAR2;                      
  
  --<<
  -- Funcion para retornar la descripcion del departamento
  -->>  
  FUNCTION fsbDescDeparta(depart departam.depacodi%TYPE)
  RETURN VARCHAR2;
    
  --<<
  -- Funcion para retornar la descripcion de la localidad
  -->>  
  FUNCTION fsbDescLocali(depart localida.locadepa%TYPE,
                         locali localida.locacodi%TYPE)
  RETURN VARCHAR2;      
  
  --<<
  -- Funcion para Anular una Venta 
  -- nuSesunuse => numero del servicio suscrito (Suscriptor)
  -- nuMotivo   => PQR necesaria para la cancelacion del servicio (761) 
  -- nuvefncodi => Codigo interno consecutivo de la venta
  -- sbObservac => Observacion 
  -->> 
  
  FUNCTION fsbAnulaVentasWeb (nuSesunuse   servsusc.sesunuse%TYPE,
                              nuMotivo     motipere.mopecodi%TYPE,
                              nuvefncodi   ventafnb.vefncodi%type,
                              sbObservac   ordetrab.ortrobse%TYPE)
  RETURN VARCHAR2;
                                  
END pkWebBrilla;
/
CREATE OR REPLACE PACKAGE BODY pkWebBrilla IS
/********************************************************************************
   PROPIEDAD INTELECTUAL DE SURTIGAS
   FUNCION   : pkWebBrilla
   AUTOR     : Jose Ricardo Gallego
   Empresa   : ArquitecSoft S.A.S
   FECHA     : 11-14-2012
   DESCRIPCION  : Paquete que maneja la logica de la parte web de brilla
                  en surtigas.

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion

**********************************************************************************/

FUNCTION fnuSoliciVenta
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fnuSoliciVenta
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 24-11-2012
  DESCRIPCION  : Funcion que Retorna el codigo de la solicitud de la venta 

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN NUMBER IS

  --<<
  -- Parametros
  -->>
  nuSoliVent   ventafnb.vefncpve%TYPE; 
  sbError      VARCHAR2(2000);   
  
    
BEGIN
  
  SELECT SEQ_aucpve.NEXTVAL+POWER(10,7) INTO nuSoliVent FROM DUAL;

  RETURN(nuSoliVent);

EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.FNUSUSCRIPTORACTIVO] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(-1);

END fnuSoliciVenta;

FUNCTION fnuSuscriptorActivo(nusesunuse IN negoserv.nesenuse%TYPE)
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fnuSuscriptorActivo
  AUTOR        : Jose Ricardo Gallego
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 11-14-2012
  DESCRIPCION  : Funcion para validar si el suscriptor existe y si esta habilitado para
                 relizar un credito en brilla

  Parametros de Entrada
             - SUSCRIPTOR

  Parametros de Salida
             - (-1) Si el suscriptos No Existe o esta inactivo para un credito
             -  (0) Si el suscriptos Existe
             - ERROR|descripcion|||

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN NUMBER IS
  --<<
  -- Parametros
  -->>
  nuError NUMBER := -1;
  sbError VARCHAR2(2000) := NULL;

  --<<
  -- Cursor para validar si el suscriptor existe
  -->>          
  CURSOR cuNegoServ 
      IS
  SELECT * 
    FROM negoserv s
   WHERE s.nesenuse = nusesunuse
     AND UPPER(s.neseacti) = 'S';

BEGIN

  FOR rgNegoServ IN cuNegoServ LOOP
      
    --<<
    -- Se garantiza que el cupo disponible sea mayor al cupo utilizado
    -->>
    IF (rgNegoServ.nesecupo <= rgNegoServ.Nesecuut) THEN
      
       nuError := -1;
      
    ELSE
        
       nuError := 0;
      
    END IF;
      
  END LOOP;

  RETURN(nuError);

EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.FNUSUSCRIPTORACTIVO] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(-1);

END fnuSuscriptorActivo;

PROCEDURE prInsVadacre(sbCedula        IN vadacre.vdtciden%TYPE,
                       nuServsue       IN vadacre.vdtcnuse%TYPE,
                       nuSusccod       IN vadacre.vdtcsusc%TYPE,
                       sbNombre        IN vadacre.vdtcnom%TYPE, 
                       sbPrimerAL      IN vadacre.vdtdpapel%TYPE,
                       nuSolVenta      IN vadacre.vdtccpve%TYPE,
                       sbFechExpe      IN vadacre.vdtcfeex%TYPE,
                       sbFechCont      IN vadacre.vdtcfeco%TYPE,
                       sbNomCiuda      IN vadacre.vdtcciud%TYPE,
                       sbDepartam      IN vadacre.vdtcdepa%TYPE,
                       sbEdad          IN vadacre.vdtcedad%TYPE,
                       sbGenero        IN vadacre.vdtcgene%TYPE,
                       sbEstado        IN vadacre.vdtcesta%TYPE) 
/*****************************************************************************
PROPIEDAD INTELECTUAL DE SURTIGAS
FUNCION      : prInsVadacre
AUTOR        : Jose Ricardo Gallego
EMPRESA      : ArquitecSoft S.A.S
FECHA        : 25-11-2012
DESCRIPCION  : procedimiento para llevar el log del datacredito
                   
Parametros de Entrada

Parametros de Salida

Historia de Modificaciones
Autor    Fecha       Descripcion
*****************************************************************************/
IS
  usuario VARCHAR2(20);
  maquina VARCHAR2(30);
  fecons  DATE;
  sbError VARCHAR2(2000);
  
  
BEGIN
  
  --<<
  -- Se obtienen los datos del usuario, maquina y tambien formatea la fecha de expedicion
  -->>
  SELECT USER,
         userenv('TERMINAL'),to_date(to_char(sbFechCont, 'DD/MM/YY HH24:MI:SS'),'DD/MM/YY HH24:MI:SS')
    INTO usuario, maquina, fecons
    FROM dual;
    
  BEGIN
    
    --<<
    -- inserta el dato de la solicitud el datacredito
    -->>
    INSERT INTO vadacre
                        (vdtciden, vdtcnuse, vdtcsusc,
                         vdtcnom,  vdtcusua, vdtcmaq,
                         vdtcfeco, vdtdpapel, vdtccpve,
                         vdtcgene, vdtcfeex, vdtcciud,
                         vdtcdepa, vdtcedad, vdtcesta)
                   VALUES
                        (sbCedula,   nuServsue,  nuSusccod,
                         sbNombre,   usuario,    maquina,
                         fecons,     sbPrimerAL, nuSolVenta,
                         sbGenero,   sbFechExpe, sbNomCiuda,
                         sbDepartam, sbEdad,     sbEstado);
     EXCEPTION
       WHEN OTHERS THEN
         sbError := 'Error Insertando el log del datacredito';
         pkregidepu.pRegiMensaje('EXCEPTION Error',sbError, 'PKWEB-BRILLA');
  END;
   
 EXCEPTION
     WHEN OTHERS THEN
       ROLLBACK;
       sbError :=  '[PKWEBSURTIGAS.PRINSVADACRE] - '||SQLERRM||' '||DBMS_UTILITY.format_error_backtrace;
       pkregidepu.pRegiMensaje('EXCEPTION Error',sbError, 'PKWEB-BRILLA');             
  
END prInsVadacre;


PROCEDURE prcInfoBrilla(nusesunuse IN negoserv.nesenuse%TYPE, 
                        prfCursor OUT Sys_Refcursor)
/*****************************************************************************
PROPIEDAD INTELECTUAL DE SURTIGAS
FUNCION      : prcInfoBrilla
AUTOR        : Jose Ricardo Gallego
EMPRESA      : ArquitecSoft S.A.S
FECHA        : 11-14-2012
DESCRIPCION  : procedimiento para desplegar la informacion de de brilla
                   
Parametros de Entrada
           - SUSCRIPTOR

Parametros de Salida
           - Cursor con la informacion de brilla
           - Cursor Vacio 
           - ERROR|descripcion|||

Historia de Modificaciones
Autor    Fecha       Descripcion
*****************************************************************************/
   
 IS
     --<<
     -- Parametros
     -->>
     sbError             VARCHAR2(2000) := NULL;
     voCursor            Sys_Refcursor:=null;
 BEGIN
     
  --<<
  -- Abrir el cursor sobre el cual se guardara la informacion que se 
  -- obtenga del select
  -->>
  OPEN voCursor FOR  
    SELECT n.nesenuse, n.nesenomb, n.nesedire, n.nesedepa,
           d.depadesc, n.neseloca, l.locanomb, n.nesebarr,
           b.barrdesc, n.nesecate, c.catedesc, n.neserutl,
           n.nesesuca, s.sucadesc, n.nesetele, n.nesedepr,
           n.neselopr, n.nesezcpr, n.nesescpr, n.nesemcpr,
           n.nesenupr, n.nesenmpr, n.nesecpre, n.nesecupo,
           n.nesecuut, n.nesevain, n.nesenufr, n.neseacti,
           n.neseflac
      FROM negoserv n, departam d, localida l, barrio b, categori c, subcateg s
     WHERE n.nesedepa = d.depacodi
       AND n.neseloca = l.locacodi
       AND n.nesebarr = b.barrcodi
       AND n.nesedepa = b.barrdepa
       AND n.neseloca = b.barrloca
       AND d.depacodi = l.locadepa
       AND n.nesecate = c.catecodi
       AND n.nesesuca = s.sucacate
       AND c.catecodi = s.sucacodi
       AND n.nesenuse = nusesunuse;
       
 prfCursor:=voCursor;
       
 EXCEPTION
     WHEN OTHERS THEN
       sbError :=  '[PKWEBSURTIGAS.PRCINFOBRILLA] - '||SQLERRM||' '||DBMS_UTILITY.format_error_backtrace;
       pkregidepu.pRegiMensaje('EXCEPTION Error',sbError, 'PKWEB-BRILLA');
                                                  
END prcInfoBrilla; 
 
PROCEDURE prcInfoDeudor(nuSesunuse IN servsusc.sesunuse%TYPE,
                        nuFacturaA IN cuencobr.cucocodi%TYPE,
                        nuFacturaB IN cuencobr.cucocodi%TYPE,
                        dtFechLimA IN VARCHAR2,
                        dtFechLimB IN VARCHAR2,
                        cuRefDeudo OUT Sys_Refcursor,
                        sbOutError OUT VARCHAR2)
/****************************************************************************************
PROPIEDAD INTELECTUAL DE SURTIGAS
FUNCION      : prinfoDeudor
AUTOR        : Jorge Mario Galindo
EMPRESA      : ArquitecSoft S.A.S
FECHA        : 15-11-2012
DESCRIPCION  : Funcion para validar si el suscriptor existe y si esta habilitado para
               relizar un credito en brilla

Parametros de Entrada
           - nuSesunuse: Servicio Suscrito
           - nuFacturaA: Codigo Factura 1
           - nuFacturaB: Codigo Factura 2
           - dtFechLimA: Fecha Limite de Pago de la Fact 1
           - dtFechLimB: Fecha Limite de Pago de la Fact 2

Parametros de Salida
           - (-1) Si el suscriptos No Existe o esta inactivo para un credito
           - (0) Si el suscriptos Existe
           - ERROR|descripcion|||

Historia de Modificaciones
Autor    Fecha       Descripcion
*****************************************************************************************/
IS
  --<<
  -- Parametros
  -->>
  nuConta            NUMBER := 0;
  sbOkA              VARCHAR2(1) := NULL;
  sbOkB              VARCHAR2(1) := NULL;
  sbError            VARCHAR2(2000) := NULL;
  nuCuencobr         cuencobr.cucocodi%TYPE;
  
  
  nuNumMaxFact      NUMBER(2); 
  vaComodin         VARCHAR2(20);
  
  --<<
  -- Cursor para obtener la maxima cuenta de cobro generada por el proceso de FGCC
  -->>
  CURSOR cuMaxCuencobr(nuNumMaxFact NUMBER)
      IS 
  SELECT *
    FROM   
        (SELECT cucocodi
           FROM cuencobr c
          WHERE c.cuconuse = nuSesunuse
            AND c.cucoprog = 'FGCC'
          ORDER BY cucofege DESC) 
   WHERE ROWNUM < nuNumMaxFact;

 TYPE tycuMaxCuencobr IS TABLE OF cuMaxCuencobr%ROWTYPE INDEX BY BINARY_INTEGER;
 vtycuMaxCuencobr        tycuMaxCuencobr;
 vtycuMaxCuencobrOrde    tycuMaxCuencobr;
   
     
  CURSOR cuFactPermitida
      IS
  SELECT COUNT(1) contador
    FROM cuencobr c
   WHERE c.cuconuse = nuSesunuse
     AND c.cucocodi = nuFacturaB
     AND c.cucofege >= ADD_MONTHS(SYSDATE,-6)
     AND c.cucoprog = 'FGCC';
     
BEGIN
  
  --<<
  -- Funcion que se encarga de traer el numero maximo de facturas a
  -- revisar 
  -->>
  provapatapa('NUM_MAX_FACT', 'N', nuNumMaxFact, vaComodin);     

   
 --<<
 -- Inicializacion
 -->>
 sbOutError := 'EXITO'; 
 
 --<<
 -- Se obtiene la maxima cuenta de cobro generada
 -->>
/* OPEN cuMaxCuencobr;
 FETCH cuMaxCuencobr INTO nuCuencobr;
 CLOSE cuMaxCuencobr;*/
 
  OPEN cuMaxCuencobr(nuNumMaxFact);
  FETCH cuMaxCuencobr BULK COLLECT INTO vtycuMaxCuencobr;
  CLOSE cuMaxCuencobr;

  FOR j IN vtycuMaxCuencobr.first .. vtycuMaxCuencobr.last LOOP

      vtycuMaxCuencobrOrde(vtycuMaxCuencobr(j).cucocodi) := vtycuMaxCuencobr(j);

  END LOOP;
 
 --<<
 -- Comparacion de la maxima cuenta de cobro con la factura 1 como parametro de entrada
 -->>
 IF (vtycuMaxCuencobrOrde(nuFacturaA).cucocodi = nuFacturaA) THEN
   
     --<<
     -- Se valia la existencia y la fecha limite de pago de la factura 1
     -->>
     sbOkA := finvalidafac(nuse1 => nuSesunuse,
                           factu => nuFacturaA,
                           fmp   => to_date(dtFechLimA,'DD/MM/YYYY'));
                           
                           
                           
     --<<
     -- Se valida la vigencia permitida para la segunda cuenta de cobro
     -->>
     OPEN cuFactPermitida;
     FETCH cuFactPermitida INTO nuconta;
     CLOSE cuFactPermitida;
     
     IF ( nuconta > 0 ) THEN
       
         --<<
         -- Se valia la existencia y la fecha limite de pago de la factura 2
         -- teniendo en cuenta que esta factura debe estar dentro de los ultimos
         -- se meses facturados
         -->>
         sbOkB := finvalidafac(nuse1 => nuSesunuse,
                               factu => nuFacturaB,
                               fmp   => to_date(dtFechLimB,'DD/MM/YYYY'));     
     
     END IF;                      
       
 END IF;
                          
 --<<
 -- Se valida si es apto para el registro de la financiacion
 -->>
 IF (sbOkA <> 'N' AND sbOkB <> 'N') THEN
           
     --<<
     -- Se setea la informacion basica del deudor
     -->>   
     OPEN cuRefDeudo FOR
     SELECT nesenomb, suscnice, nesedire, nesetele,
            nesedepa||'-'||depadesc nesedepa, 
            neseloca||'-'||locanomb neseloca, nesebarr||'-'||b.barrdesc nesebarr, nesecate,
            nesesuca, nesecupo, nesevain, neseflac,
            nesecuut, 'P' tipoVivienda, 'C' estadoCivil,
            'M' sexo, 'B' nivelEstudio, 'S' titular,
            'O' relacionTitular, 'E' ocupacion, 
            'F' tipoContrato, 'A' tipoCPVE, 
            'CC' tipoDocumento    
       FROM negoserv, suscripc, servsusc, departam d, localida l, barrio b
      WHERE nesenuse = sesunuse
        AND susccodi = sesususc
        AND nesedepa = d.depacodi
        AND neseloca = l.locacodi
        AND l.locadepa = d.depacodi
        AND suscbarr = b.barrcodi
        AND d.depacodi = b.barrdepa
        AND l.locacodi = b.barrloca
        AND nesenuse = nuSesunuse   
        AND neseacti = 'S'; 
        
 ELSE
    --<<
    -- Se setea el mensaje de error
    -->>
    sbOutError := 'Revise la Información de sus Facturas';
 END IF;                          
EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.PRCINFODEUDOR] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');

END prcInfoDeudor;                     

PROCEDURE prcInfoCoDeudor(nuSesunuse   IN servsusc.sesunuse%TYPE,
                          cuRefCoDeudo OUT Sys_Refcursor,
                          sbOutError   OUT VARCHAR2)
/****************************************************************************************
PROPIEDAD INTELECTUAL DE SURTIGAS
FUNCION      : prcInfoCoDeudor
AUTOR        : Jorge Mario Galindo
EMPRESA      : ArquitecSoft S.A.S
FECHA        : 25-11-2012
DESCRIPCION  : Funcion para validar si el Codeudor existe y si esta habilitado para
               servir de Codeudor

Parametros de Entrada
           - nuSesunuse: Servicio Suscrito

Parametros de Salida

Historia de Modificaciones
Autor    Fecha       Descripcion
*****************************************************************************************/
IS
  --<<
  -- Parametros
  -->>
  sbError    VARCHAR2(2000) := NULL;
  nuError    NUMBER := -1;
     
BEGIN
  
 sbOutError := NULL;
   
 --<<
 -- Se valida si es un usuario con neseacti activo
 -->>
 nuError := fnuSuscriptorActivo(nuSesunuse);
 
 IF nuError > -1 THEN
   
    --<<
    -- Inicializacion
    -->>
    sbOutError := 'EXITO'; 
   
    --<<
    -- Se setea la informacion basica del deudor
    -->>   
    OPEN cuRefCoDeudo FOR
   SELECT nesenomb, suscnice, nesedire, nesetele,
          nesedepa||'-'||depadesc nesedepa, 
          neseloca||'-'||locanomb neseloca, nesebarr||'-'||b.barrdesc nesebarr, nesecate,
          nesesuca, nesecupo, nesevain, neseflac,
          nesecuut, 'P' tipoVivienda, 'C' estadoCivil,
          'M' sexo, 'B' nivelEstudio, 'S' titular,
          'O' relacionTitular, 'E' ocupacion, 
          'F' tipoContrato, 'A' tipoCPVE, 
          'CC' tipoDocumento    
     FROM negoserv, suscripc, servsusc, departam d, localida l, barrio b
    WHERE nesenuse = sesunuse
      AND susccodi = sesususc
      AND nesedepa = d.depacodi
      AND neseloca = l.locacodi
      AND l.locadepa = d.depacodi
      AND suscbarr = b.barrcodi
      AND d.depacodi = b.barrdepa
      AND l.locacodi = b.barrloca
      AND nesenuse = nuSesunuse   
      AND neseacti = 'S'; 
   
 ELSE
     sbOutError := 'El coedudor no esta activo en el Sistema.'; 
 END IF;
        
EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.PRCINFOCODEUDOR] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');

END prcInfoCoDeudor;  

FUNCTION fnuEdadMaximaDeudor(fechaNaciemto VARCHAR2)
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fnuEdadMaximaDeudor
  AUTOR        : Jose Ricardo Gallego
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 11-21-2012
  DESCRIPCION  : Funcion para validar si el suscriptor tiene la edad adecuada
                 para acceder a un credito de brilla

  Parametros de Entrada
             - FECHA NACIMIENTO DEL SUSCRIPTOR

  Parametros de Salida
             - (-1) Si al suscriptor no se le puede hacer el credito por la edad
             -  (0) Si el suscriptor tiene una edad adecuada para solicitar un credito
             - ERROR|descripcion|||

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN NUMBER IS
  --<<
  -- Parametros
  -->>
  nuError NUMBER := -1;
  sbError                 VARCHAR2(2000) := NULL;
  
  nuDiferenciaMesis       NUMBER:=0;               
  nuNumMaxMeses           NUMBER;
  vaComodin               VARCHAR2(20);
BEGIN
  

  --<<
  -- Funcion con la cual se obtiene cantidad maxima de meses que debe tener un 
  -- suscriptor para poder acceder a un prestamo
  -->>
  provapatapa('MESES_MAXIMO_PARA_CREDITO', 'N', nuNumMaxMeses, vaComodin);
  
  --<<
  -- Select en el cual se castea la fecha del sistema y la fecha ingresada por 
  -- el usuario y se obtine la cantidad de meses entre estas dos fechas, guardandolas
  -- en la variable nuDiferenciaMesis
  -->>
  SELECT trunc(months_between(to_date(to_char(SYSDATE, 'DD/MM/YYYY'),'DD/MM/YYYY'), 
                              to_date(fechaNaciemto,'DD/MM/YYYY'))) 
  INTO  nuDiferenciaMesis
  FROM dual; 
  
  --<<
  -- Comparacion en la cual se verifica si el usuario tiene una fecha indicado
  -- para solicitar un prestamo
  -->>
  IF nuNumMaxMeses > nuDiferenciaMesis THEN 
    return 0;
  END IF;
    

  RETURN(nuError);

EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.FNUEDADMAXIMADEUDOR] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(-1);

END fnuEdadMaximaDeudor;

FUNCTION fnuEdadMaximaCoDeudor(fechaNaciemto VARCHAR2)
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fnuEdadMaximaCoDeudor
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 25-12-2012
  DESCRIPCION  : Funcion para validar si el codeudor tiene el limite de edad
                 permitido

  Parametros de Entrada
             - FECHA NACIMIENTO DEL SUSCRIPTOR

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN NUMBER IS
  --<<
  -- Parametros
  -->>
  nuError NUMBER := -1;
  sbError                 VARCHAR2(2000) := NULL;
  
  nuDiferenciaMesis       NUMBER:=0;               
  nuNumMaxMeses           NUMBER;
  vaComodin               VARCHAR2(20);
BEGIN
  

  --<<
  -- Funcion con la cual se obtiene cantidad maxima de meses que debe tener un 
  -- suscriptor para poder acceder a un prestamo
  -->>
  provapatapa('MESES_CODEUDOR', 'N', nuNumMaxMeses, vaComodin);
  
  --<<
  -- Select en el cual se castea la fecha del sistema y la fecha ingresada por 
  -- el usuario y se obtine la cantidad de meses entre estas dos fechas, guardandolas
  -- en la variable nuDiferenciaMesis
  -->>
  SELECT trunc(months_between(to_date(to_char(SYSDATE, 'DD/MM/YYYY'),'DD/MM/YYYY'), 
                              to_date(fechaNaciemto,'DD/MM/YYYY'))) 
  INTO  nuDiferenciaMesis
  FROM dual;
  
  --<<
  -- Comparacion en la cual se verifica si el usuario tiene una fecha indicado
  -- para solicitar un prestamo
  -->>
  IF nuNumMaxMeses > nuDiferenciaMesis THEN 
    RETURN 0;
  END IF;  

  RETURN(nuError);

EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.FNUEDADMAXIMACODEUDOR] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(-1);

END fnuEdadMaximaCoDeudor;

FUNCTION fcuRefClaseVenta
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fcuRefClaseVenta
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 21-11-2012
  DESCRIPCION  : Funcion para optener la clase de venta a financiar

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN SYS_REFCURSOR IS
  --<<
  -- Parametros
  -->>
  cuRefClaseVenta SYS_REFCURSOR;
  sbError         VARCHAR2(2000) := NULL;
    
BEGIN

  --<<
  -- Se obtiene la clase de venta para la financiacion de brilla
  -->>
  OPEN cuRefClaseVenta FOR
  SELECT * FROM tivtafnb t 
   WHERE upper(t.tifndesc) LIKE '%ONLINE%'
   ORDER BY 1 ASC;  

  RETURN(cuRefClaseVenta);

EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.FCUREFCLASEVENTA] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(cuRefClaseVenta);

END fcuRefClaseVenta;

FUNCTION fcuRefVentProveedores(nuCuadrilla cuadcont.cuadcodi%TYPE,
                               nuClaseVent tivtafnb.tifncodi%TYPE)
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fcuRefVentProveedores
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 21-11-2012
  DESCRIPCION  : Funcion para obtener el listado de productos por la clase de 
                 venta y proveedor

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN SYS_REFCURSOR IS
  --<<
  -- Parametros
  -->>
  cuRefVentProveedores SYS_REFCURSOR;
  sbError              VARCHAR2(2000) := NULL;
    
BEGIN

  --<<
  -- Se obtiene la clase de venta para la financiacion de brilla
  -->>
  OPEN cuRefVentProveedores FOR
  SELECT a.PRFNCOPR, PRFNDESC, PRFNCODI, prfnvalo
    FROM prprofnb a, produfnb b
   WHERE prfncuad = nuCuadrilla
     AND prfncodi = prfnprod
     AND nvl(PRFNACTI, 'S') = 'S'
     AND a.prfntivt = nuClaseVent
   ORDER BY 1;  

  RETURN(cuRefVentProveedores);

EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.FCUREFVENTPROVEEDORES] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(cuRefVentProveedores);

END fcuRefVentProveedores;

FUNCTION fcuRefProveedores(nuTipoVenta tivtafnb.tifncodi%TYPE)
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fcuRefProveedores
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 22-11-2012
  DESCRIPCION  : Funcion para la lista de proveedores aptos para las ventas

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN SYS_REFCURSOR IS
  --<<
  -- Parametros
  -->>
  cuRefProveedores SYS_REFCURSOR;
  sbError          VARCHAR2(2000) := NULL;
    
BEGIN

  --<<
  -- Se obtiene la clase de venta para la financiacion de brilla
  -->>
  OPEN cuRefProveedores FOR
  SELECT /*+ rule*/ 
       UNIQUE(prfncuad) cuadrilla, cu.cuadnomb nombre
   FROM tivtafnb tv, prprofnb pp, cuadcont cu, contrato co
  WHERE pp.prfntivt = tv.tifncodi
    AND pp.prfncuad = cu.cuadcodi
    AND cu.cuadcodi = co.contcuad
    AND NVL(co.contvaco,0) > NVL(co.contvaej,0)
    AND tv.tifncodi = nuTipoVenta
    AND NVL(pp.prfnacti, 'S') = 'S'
    AND cu.cuadescu = 4
    AND co.contesco = 5;  

  RETURN(cuRefProveedores);

EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.FCUREFPROVEEDORES] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(cuRefProveedores);

END fcuRefProveedores;

FUNCTION fcuRefAgrupaFNB
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fcuRefAgrupaFNB
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 22-11-2012
  DESCRIPCION  : Funcion para la lista de agrupaciones de productos 
                 de ventas fnb.

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN SYS_REFCURSOR IS
  --<<
  -- Parametros
  -->>
  cuRefAgrupaFNB SYS_REFCURSOR;
  sbError        VARCHAR2(2000) := NULL;
    
BEGIN

  --<<
  -- Se obtiene la clase de venta para la financiacion de brilla
  -->>
  OPEN cuRefAgrupaFNB FOR
  SELECT a.agfncodi, 
         a.agfndesc, 
         a.agfnconc
    FROM agrupfnb a
   WHERE a.agfncodi > -1
   ORDER BY 1 ASC;  

  RETURN(cuRefAgrupaFNB);

EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.FCUREFAGRUPAFNB] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(cuRefAgrupaFNB);

END fcuRefAgrupaFNB;
                              
PROCEDURE proDataCredito(nuSesunuse IN servsusc.sesunuse%TYPE,
                         nuSoliVent IN ventafnb.vefncpve%TYPE,
                         sbCedula   IN suscripc.suscnice%TYPE,
                         nuCuadCont IN cuadcont.cuadcodi%TYPE,
                         nuTecncodi IN tecnico.tecncodi%TYPE,
                         nuSucursal IN sucursal.codsucu%TYPE,
                         sbApellido IN VARCHAR2,
                         cuRefVaDat OUT SYS_REFCURSOR,
                         sbErrorIn  OUT VARCHAR2)
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  PROCEDURE    : proDataCredito
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 22-11-2012
  DESCRIPCION  : Funcion para validar si el usuario requiere validar estado 
                 en datacredito

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/
  IS
  --<<
  -- Parametros
  -->>
  --nuComodin    NUMBER := 0;
  nuError      NUMBER := 0;
  nuTiempo     NUMBER := 0;
  nuComodin    NUMBER := 0;
  nuSession    NUMBER := 0;
  nuExiste     NUMBER := -1;
  nuContado    NUMBER := 0;
  sbEstado     VARCHAR2(1):= NULL;
  nuFechExp    VARCHAR2(2000) := NULL; 
  nuEdad       VARCHAR2(2000) := NULL;   
  sbError      VARCHAR2(2000) := NULL;
  sbMensa      VARCHAR2(2000) := NULL;
  sbComodin    VARCHAR2(2000) := NULL;
  sbNombre     VARCHAR2(2000) := NULL;
  sbPrimerA    VARCHAR2(2000) := NULL;
  sbSegundA    VARCHAR2(2000) := NULL;
  sbGenero     VARCHAR2(2000) := NULL;
  sbEstadoI    VARCHAR2(2000) := NULL;
  sbCuidad     VARCHAR2(2000) := NULL;
  sbDeparta    VARCHAR2(2000) := NULL;   
  dtFechExp    DATE;
  nuSusccodi   suscripc.susccodi%TYPE;
  
   --<<
   -- Data de DataCredito
   -->> 
   CURSOR cuDataCredito
       IS
   SELECT a.*
     FROM (SELECT *
             FROM vadacre v
            WHERE v.vdtcnuse = nuSesunuse
              AND v.vdtciden = sbCedula
            ORDER BY v.vdtcfeco DESC) a
    WHERE ROWNUM < 2;   
   
   --<<
   -- Cursor para obtener la informacion del ultimo data credito realizado
   -->> 
   CURSOR cuRePlicaDataCredito
       IS
   SELECT a.vdtciden, a.vdtcnuse, a.vdtcsusc,
          a.vdtcnom, a.vdtcusua, a.vdtcmaq,
          a.vdtcfeco, REPLACE(a.vdtdpapel, '/', 'N') vdtdpapel,
          a.vdtccpve, a.vdtcgene, a.vdtcfeex,
          a.vdtcciud, a.vdtcdepa, a.vdtcedad,
          a.vdtcesta 
     FROM (SELECT *
             FROM vadacre v
            WHERE v.vdtcnuse = nuSesunuse
              AND v.vdtciden = sbCedula
            ORDER BY v.vdtcfeco DESC) a
    WHERE ROWNUM < 2;
     
    --<<
    -- Cursor para obtener el codigo de la suscripcion asociada al servio suscrito
    -->>   
    CURSOR cuServSusc
        IS
    SELECT sesususc
      FROM servsusc
     WHERE sesunuse = nuSesunuse;
   
BEGIN
  
  --<<
  -- Incializacion del proceso
  -->>
  sbErrorIn := 'INICIO';
  
  --<<
  -- Parametros del Sistema
  -->>
  provapatapa('FNB_TIEMPO', 'N', nuTiempo, sbComodin);
  
  --<<
  -- Codigo del Suscriptor
  -->>
  OPEN cuServSusc;
  FETCH cuServSusc INTO nuSusccodi;
  CLOSE cuServSusc;   
  
  --<<
  -- Verifica el Estado de Data Credito
  -->>
  provapatapa('FNB_DATACREDITO','S',nuComodin, sbEstado);
  
  IF ( NVL(UPPER(sbEstado),'S') = 'S' ) THEN
     
       --<<
       -- Se valida la existencia de consultas anteriores
       -->>     
       FOR rgcuDataCredito IN cuDataCredito LOOP
         
           nuExiste := 1;
           
           nuError := round(SYSDATE - rgcuDataCredito.Vdtcfeco);  
  
           --<<
           -- Se validan la cantida de dias pasados con respecto
           -- a la ultima solicitud de credito.
           -->>
           IF (nuError > nuTiempo) THEN
               nuContado := 1;               
           END IF; 
       
       END LOOP;
  
        --<<
        -- Si la ultima consulta realizada es menor inferior o nunca se ha realizado
        -- consulta a DataCredito debe viajar.
        -->>
        IF ( nuExiste = -1 OR nuContado > 0 ) THEN 
            
            --<<  
            -- Viaja a realizar la consulta de DataCredito
            -->>
            datacredito(cedula            => sbCedula,
                        papellido         => sbApellido,
                        mens              => sbMensa,
                        nunombres         => sbNombre,
                        nuprimerapellido  => sbPrimerA,
                        nusegundoapellido => sbSegundA,
                        nugenero          => sbGenero,
                        nuestadoiden      => sbEstadoI,
                        nufechaexp        => nuFechExp,
                        nuciudad          => sbCuidad,
                        nudepartam        => sbDeparta,
                        nuedad            => nuEdad,
                        nuok              => nuError);
                   
             pinsvadaint(nice => sbCedula,
                         nuse => nuSesunuse,
                         papel => sbApellido,
                         respuesta => nuError);
                                     
             --<<
             -- obtiene la fechade expedicion de la C.C
             -->>
             BEGIN
                proFechaExp(fex   => nuFechExp,
                            fecha => dtFechExp);
             END;         
                                      
             --<<
             -- Valida la respuesta
             -->>            
             IF (nuError = 0) THEN
                   
                 --<<
                 -- Concatena el nombre completo con apellidos
                 -->>
                 BEGIN
                  SELECT SUBSTR(sbNombre || ' ' || sbPrimerA || ' ' ||sbSegundA, 1, 40) INTO sbNombre
                    FROM DUAL;
                 END;   
                                
                 --<<
                 -- Se valida el genero
                 -->>
                 IF ( to_number(sbGenero) BETWEEN 1 AND 3) THEN            
                      sbGenero := 'MUJER';       
                 ELSIF TO_NUMBER(sbGenero) = 4 THEN                  
                       sbGenero := 'HOMBRE';             
                 ELSE              
                       sbGenero := 'NO DEFINIDO';         
                 END IF; 
                     
                 --<<
                 -- Se valida el estado
                 -->>
                 IF to_number(sbEstadoI) = 0 THEN    
                    sbEstadoI := 'VIGENTE';
                 ELSIF to_number(sbEstadoI) = 12 THEN           
                       sbEstadoI := 'SUSPENDIDA';           
                 ELSIF to_number(sbEstadoI) = 21 THEN           
                       sbEstadoI := 'FALLECIDO';           
                 ELSIF to_number(sbEstadoI) = 29 THEN           
                       sbEstadoI := 'CANCELADA';           
                 ELSIF to_number(sbEstadoI) < 30 AND to_number(sbEstadoI) NOT IN (0, 12, 21, 29) THEN           
                       sbEstadoI := 'CANCELADA';           
                 ELSIF to_number(sbEstadoI) >= 30 AND to_number(sbEstadoI) < 60 THEN           
                       sbEstadoI := 'NO EXPEDIDA';           
                 ELSIF to_number(sbEstadoI) >= 60 AND to_number(sbEstadoI) < 99 THEN           
                       sbEstadoI := 'INDEFINIDO';           
                 ELSIF to_number(sbEstadoI) = 99 THEN           
                       sbEstadoI := 'EN TRAMITE';           
                 END IF;             
                     
                 --<<
                 -- Inserta la Validacion del Data Credito
                 -->>
                 pInsVadaCre(nice       => sbCedula,
                             nuse       => nuSesunuse,
                             susc       => nuSusccodi,
                             nom        => sbNombre,
                             papel      => sbPrimerA,
                             cpve       => nuSoliVent,
                             nufechaexp => dtFechExp,
                             nuciudad   => sbCuidad,
                             nudepartam => sbDeparta,
                             nuedad     => nuEdad,
                             genero     => sbGenero,
                             estado     => sbEstadoI);    
 
                  insertanodatacredito(nucpv => nuSoliVent,
                                       sbcadena => 'Forma - Flag Estado: RVFN - '||nvl(upper(sbEstado),'S')||
                                                   ' Usuario: '||USER||
                                                   ' Terminal: '||substr(FSBMACHINE(USERENV('SESSIONID')), 1, 10)||
                                                   ' Sesion: ' ||nuSession||
                                                   ' Informacion Servicio: '||nuSusccodi||' - '||to_char(nuSesunuse)||
                                                    ' Datos Venta : '||to_date(SYSDATE,'DD/MM/YYYY')||' - '||nuCuadCont||' - '||nuSoliVent||' - '||nuSucursal||' - '||nuTecncodi);                                 
                             
                   
             ELSIF (nuError = 3) THEN 
                 
                    sbErrorIn := 'Cedula No Registrada en Data Credito';
                        
                    pinsvadacre(nice       => sbCedula,
                                nuse       => nuSesunuse,
                                susc       => nuSusccodi,
                                nom        => sbNombre,
                                papel      => sbPrimerA,
                                cpve       => nuSoliVent,
                                nufechaexp => 'NO DATACREDITO',
                                nuciudad   => 'NO DATACREDITO',
                                nudepartam => 'NO DATACREDITO',
                                nuedad     => 'NO DATACREDITO',
                                genero     => 'NO DATACREDITO',
                                estado     => 'NO DATACREDITO');
                                
                    insertanodatacredito(nucpv => nuSoliVent,
                                         sbcadena => 'Forma - Flag Estado: RVFN - '||nvl(upper(sbEstado),'S')||
                                                     ' Usuario: '||USER||
                                                     ' Terminal: '||substr(FSBMACHINE(USERENV('SESSIONID')), 1, 10)||
                                                     ' Sesion: ' ||nuSession||
                                                     ' Informacion Servicio: '||nuSusccodi||' - '||to_char(nuSesunuse)||
                                                     ' Datos Venta : '||to_date(SYSDATE,'DD/MM/YYYY')||' - '||nuCuadCont||' - '||nuSoliVent||' - '||nuSucursal||' - '||nuTecncodi);                                 
                 
             ELSIF (nuError <> 0 AND nuError <> 3) THEN  
                 
                    sbErrorIn := '¡FALLO!... ' || sbMensa||' le quedan '||'##########'||' intentos. Si alcanza el tope sera anulado el cpv';                        
                                    
             ELSIF (sbPrimerA <> sbApellido) and nuError <> 0 THEN
                 
                    sbErrorIn := '¡FALLO! Cedula no corresponde al primer apellido le quedan '||'##########'||' intentos. Si alcanza el tope sera anulado el cpv';
                 
             ELSE       
                        
                    sbErrorIn := 'Supero el numero de intentos para la consulta a Datacredito, el CPVE fue anulado';
                    --<<
                    -- Anula el CPVE
                    -->>
                    anulacpve(CPVe => nuSoliVent,
                              CUAD => nuCuadCont,
                              SUCU => nuSucursal,
                              nok  => nuError);
             END IF;
             
        ELSE
        
             FOR rgcuRePlicaDataCredito IN cuRePlicaDataCredito LOOP
               
                  --<<
                  -- Inserta el Registro en Vadacred
                  -->>
                  prInsVadacre(sbCedula   => rgcuRePlicaDataCredito.vdtciden,      
                               nuServsue  => nuSesunuse,    
                               nuSusccod  => nuSusccodi,    
                               sbNombre   => rgcuRePlicaDataCredito.vdtcnom,      
                               sbPrimerAL => rgcuRePlicaDataCredito.vdtdpapel,    
                               nuSolVenta => nuSoliVent,    
                               sbFechExpe => rgcuRePlicaDataCredito.vdtcfeex, 
                               sbFechCont => rgcuRePlicaDataCredito.vdtcfeco,    
                               sbNomCiuda => rgcuRePlicaDataCredito.vdtcciud,      
                               sbDepartam => rgcuRePlicaDataCredito.vdtcdepa,     
                               sbEdad     => rgcuRePlicaDataCredito.vdtcedad,
                               sbGenero   => rgcuRePlicaDataCredito.vdtcgene,
                               sbEstado   => rgcuRePlicaDataCredito.vdtcesta);
                                                          
                        --<<
                        -- Obtengo la session
                        -->>                 
                        BEGIN
                          SELECT userenv('sessionid')
                            INTO nuSession
                            FROM dual;
                        END;
                                   
                        
                        insertanodatacredito(nucpv => nuSoliVent,
                                             sbcadena => 'Forma - Flag Estado: RVFN - '||nvl(upper(sbEstado),'S')||
                                                         ' Usuario: '||USER||
                                                         ' Terminal: '||substr(FSBMACHINE(USERENV('SESSIONID')), 1, 10)||
                                                         ' Sesion: ' ||nuSession||
                                                         ' Informacion Servicio: '||nuSusccodi||' - '||to_char(nuSesunuse)||
                                                         ' Datos Venta : '||to_date(SYSDATE,'DD/MM/YYYY')||' - '||nuCuadCont||' - '||nuSoliVent||' - '||nuSucursal||' - '||nuTecncodi);  
            
                          
             END LOOP;                      
                                                                                                                                                                             
        END IF;               
        
        --<<
        -- Se obtiene la clase de venta para la financiacion de brilla
        -->>
        OPEN cuRefVaDat FOR
        SELECT vdtciden, vdtcnuse,  vdtcsusc, 
               vdtcnom,  vdtcusua,  vdtcmaq, 
               vdtcfeco, vdtdpapel, vdtccpve, 
               vdtcgene, vdtcfeex,  vdtcciud, 
               vdtcdepa, vdtcedad,  vdtcesta, sbErrorIn Mensaje
         FROM vadaCre v
        WHERE v.vdtciden = sbCedula
          AND v.vdtcnuse = nuSesunuse
        ORDER BY v.vdtcfeco DESC;          
        
   ELSE
     
        sbErrorIn := 'No esta habilitada la validación de Data Crédito, por favor proceda';
  
   END IF;             

EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.PRODATACREDITO] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');

END proDataCredito;   

PROCEDURE proExtraCupo(nuCuadCont IN  cuadcont.cuadcodi%TYPE,
                       nuNesesuca IN  negoserv.nesesuca%TYPE,
                       nuNeseCuut IN  negoserv.nesecuut%TYPE,
                       nuValPromo OUT promcupo.promvalo%TYPE, 
                       sbOutError OUT VARCHAR2)
/****************************************************************************************
PROPIEDAD INTELECTUAL DE SURTIGAS
PROCEDURE    : proExtraCupo
AUTOR        : Jorge Mario Galindo
EMPRESA      : ArquitecSoft S.A.S
FECHA        : 25-11-2012
DESCRIPCION  : Procedimiento para identificar si el proveedor otorga extra cupos

Parametros de Entrada
           - nuSesunuse: Servicio Suscrito

Parametros de Salida

Historia de Modificaciones
Autor    Fecha       Descripcion
*****************************************************************************************/
IS
  --<<
  -- Parametros
  -->>
  sbError    VARCHAR2(2000) := NULL;
  
  --<<
  -- Cursor para determinar si hay promocion FNB disponible
  -->>
  CURSOR cuPromoFNB
      IS
  SELECT pf.promdesc, pc.promvalo 
    FROM promprov pp, promcupo pc, promofnb pf 
   WHERE pp.promcodi = pf.promcodi
     and pp.promcodi = pc.promcodi
     AND pf.promfini <= to_date(trunc(SYSDATE)||' 00:00:00','DD/MM/YY HH24:MI:SS')
     AND pf.promffin >= to_date(trunc(SYSDATE)||' 23:59:59','DD/MM/YY HH24:MI:SS')
     AND pp.promcuad = nuCuadCont
     AND pc.promestr = nuNesesuca;      
          
BEGIN
   
 --<<
 -- Inicializacion
 -->>
 sbOutError := 'SIN PROMOCIÓN'; 
 
 --<<
 -- Promociones por proveedor
 -->>
 FOR rgcuPromoFNB IN cuPromoFNB LOOP
   
     nuValPromo := rgcuPromoFNB.promvalo;
     sbOutError := rgcuPromoFNB.promdesc;
 
     --<<
     -- Valor total a utilizar por el usuario con la promocion valida.
     -->>
     nuValPromo := nuValPromo - nuNeseCuut;
     
 END LOOP;
                              
EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.PROEXTRACUPO] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');

END proExtraCupo;  

FUNCTION fnuTasaDispFNB
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fcuRefAgrupaFNB
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 22-11-2012
  DESCRIPCION  : Funcion para la lista de agrupaciones de productos 
                 de ventas fnb.

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN NUMBER IS
  --<<
  -- Parametros
  -->>
  sbError        VARCHAR2(2000) := NULL;
  nuError        NUMBER := -1;
  
  --<<
  -- Cursor para obtener la tasa de financiacion actual de Brilla
  -->>
  CURSOR cuTasaDisponible
      IS
  SELECT hipdporm
    FROM hiinprdi
   WHERE HIPDFECH = (SELECT MAX(HIPDFECH) FROM hiinprdi);
    
BEGIN

  --<<
  -- Obtengo el valor de la tasa disponible
  -->>
  FOR rgCuTasaDisponible IN cuTasaDisponible LOOP
  
      nuError := rgCuTasaDisponible.Hipdporm;
    
  END LOOP;
  
  RETURN(nuError);

EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.FNUTASADISPFNB] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(-1);

END fnuTasaDispFNB;

FUNCTION fnuCuotaMaxEstrato(nuCatecodi IN cumesfnb.cufncate%TYPE,
                            nuSubCateg IN cumesfnb.cufnsuca%TYPE)
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fnuCuotaMaxEstrato
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 26-11-2012
  DESCRIPCION  : Funcion para calcular la cuota maxima permitida por estrato

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN NUMBER IS
  --<<
  -- Parametros
  -->>
  sbError        VARCHAR2(2000) := NULL;
  nuError        NUMBER := -1;
  
  --<<
  -- Cursor para obtener la tasa de financiacion actual de Brilla
  -->>
  CURSOR cuCuoMaxXEstrato
      IS
  SELECT cufncate, cufnsuca, cufnvacu, cufnlncr
    FROM cumesfnb c
   WHERE c.cufncate = nuCatecodi
     AND c.cufnsuca = nuSubCateg;
     
BEGIN

  --<<
  -- Obtengo el valor de la tasa disponible
  -->>
  FOR rgcuCuoMaxXEstrato IN cuCuoMaxXEstrato LOOP
  
      nuError := rgcuCuoMaxXEstrato.cufnvacu;
    
  END LOOP;
  
  RETURN(nuError);

EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.FNUCUOTAMAXESTRATO] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(-1);

END fnuCuotaMaxEstrato;

FUNCTION fnuActuCupos(nuSesunuse IN negoserv.nesenuse%TYPE,
                      nuValTotVe IN negoserv.nesecuut%TYPE,
                      nuNeseVain IN negoserv.nesevain%TYPE)
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fnuActuCupos
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 26-11-2012
  DESCRIPCION  : Funcion para actualizar los cupos del usuario que realiza la 
                 venta.

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN NUMBER IS
  --<<
  -- Parametros
  -->>
  sbError        VARCHAR2(2000) := NULL;
  nuError        NUMBER := -1;
    
BEGIN
  
  pkregidepu.pRegiMensaje('nuSesunuse', nuSesunuse, 'BRILLA-1');
  pkregidepu.pRegiMensaje('nuValTotVe', nuValTotVe, 'BRILLA-1');
  pkregidepu.pRegiMensaje('nuNeseVain', nuNeseVain, 'BRILLA-1');
  --<<
  -- Obtengo el valor de la tasa disponible
  -->>
  UPDATE negoserv
     SET nesecuut=nvl(nesecuut,0)+(nvl(nuValTotVe,0)-nvl(nuNeseVain,0)),
         nesevain=nvl(nesevain,0)-nvl(nuNeseVain,0)
   WHERE nesenuse = nuSesunuse;
   
   nuError := SQL%ROWCOUNT;
   
   IF nuError > 0 THEN      
      RETURN(0);   
   ELSE  
      RETURN(-1);   
   END IF;
 
EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.FNUACTUCUPOS] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(-1);

END fnuActuCupos;

FUNCTION fnuCuentaConSaldo(nuSesunuse IN negoserv.nesenuse%TYPE)
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fnuCuentaConSaldo
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 26-11-2012
  DESCRIPCION  : Funcion que permite identificar si el usuario tiene una cuenta
                 pendiente por pagar. De ser asi perdera la opcion de venta web

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN NUMBER IS
  --<<
  -- Parametros
  -->>
  sbError        VARCHAR2(2000) := NULL;
  nuCuentas      NUMBER :=0;
  
  --<<
  -- Cursor para identificar si hay cuentas con saldo
  -->>
  CURSOR cuCuencobr
      IS
  SELECT COUNT(1) contador
    FROM cuencobr c
   WHERE cuconuse = nuSesunuse
     AND cucocodi > 0
     AND cucosacu > 0
     AND cucoprog = 'FGCC';
    
BEGIN

  --<<
  -- Obtengo el la cantidad con cuentas con saldo
  -->>
  OPEN cuCuencobr;
  FETCH cuCuencobr INTO nuCuentas;
  close cuCuencobr;
  
  IF nuCuentas > 0 THEN
    
     RETURN(-1);
  
  END IF;
  
  RETURN(0);
  
EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.FNUCUENTACONSALDO] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(-1);

END fnuCuentaConSaldo;

FUNCTION fnuValDifCodeudor(nuCedula IN suscripc.suscnice%TYPE)
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fnuCuentaConSaldo
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 26-11-2012
  DESCRIPCION  : Funcion que permite identificar si el usuario tiene una cuenta
                 pendiente por pagar. De ser asi perdera la opcion de venta web

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN NUMBER IS
  --<<
  -- Parametros
  -->>
  sbError        VARCHAR2(2000) := NULL;
  nuVlrTo        NUMBER :=0;
  
  --<<
  -- Cursor para identificar si hay cuentas con saldo
  -->>
  CURSOR cuValCodeudor
      IS
  SELECT SUM(nvl(difesape,0)) difesape
    FROM ventafnb v, diferido d 
   WHERE v.vefndife = d.difecodi
     AND v.vefnnicc = nuCedula;
    
BEGIN

  --<<
  -- Obtengo el la cantidad con cuentas con saldo
  -->>
  OPEN cuValCodeudor;
  FETCH cuValCodeudor INTO nuVlrTo;
  close cuValCodeudor;
  
  IF nuVlrTo > 0 THEN
    
     RETURN(-1);
  
  END IF;
  
  RETURN(0);
  
EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.FNUVALDIFCODEUDOR] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(-1);

END fnuValDifCodeudor;

FUNCTION fnuSucursalWEB(nuCuadCont IN cuadcont.cuadcodi%TYPE)
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fnuSucursalWEB
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 26-11-2012
  DESCRIPCION  : Funcion para Obtener las sucursales habiles
                 para el proceso web

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN SYS_REFCURSOR IS
  --<<
  -- Parametros
  -->>
  cuRefSucursales SYS_REFCURSOR;
  sbError         VARCHAR2(2000) := NULL;
    
BEGIN

  --<<
  -- Se obtiene la clase de venta para la financiacion de brilla
  -->>
  OPEN cuRefSucursales FOR
  SELECT s.codsucu, s.descsucu 
    FROM confisupr c, sucursal s 
   WHERE c.cfcsu = s.codsucu
     AND upper(s.descsucu) LIKE '%WEB%'
     AND c.cfcpr = nuCuadCont
   ORDER BY s.codsucu ASC;  

  RETURN(cuRefSucursales);

EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.FNUSUCURSALWEB] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(cuRefSucursales);

END fnuSucursalWEB;

FUNCTION fnuTecnicosWEB(nuCuadCont IN cuadcont.cuadcodi%TYPE)
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fnuSucursalWEB
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 26-11-2012
  DESCRIPCION  : Funcion para Obtener las sucursales habiles
                 para el proceso web

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN SYS_REFCURSOR IS
  --<<
  -- Parametros
  -->>
  cuRefTecnicos SYS_REFCURSOR;
  sbError       VARCHAR2(2000) := NULL;
    
BEGIN

  --<<
  -- Se obtiene la clase de venta para la financiacion de brilla
  -->>
  OPEN cuRefTecnicos FOR
  SELECT tecncodi, tecnnomb 
    FROM tecnico t, cuadcont c
   WHERE t.tecncuad = c.cuadcodi
     AND upper(t.tecnnomb) LIKE '%WEB%'
     AND t.tecncuad = nuCuadCont;

  RETURN(cuRefTecnicos);

EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.FNUTECNICOSWEB] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(cuRefTecnicos);

END fnuTecnicosWEB;

FUNCTION fnuIniData(nuSesunuse IN negoserv.nesenuse%TYPE)
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fnuSucursalWEB
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 26-11-2012
  DESCRIPCION  : Funcion para Obtener las sucursales habiles
                 para el proceso web

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN SYS_REFCURSOR IS
  --<<
  -- Parametros
  -->>
  cuRefDataInic SYS_REFCURSOR;
  sbError       VARCHAR2(2000) := NULL;
  nuMeses       NUMBER := 0;
  sbComodin     VARCHAR2(2000);
    
BEGIN
  
  --<<
  -- Se obtiene el parametro de consulta de inicializacion
  -->>
  PROVAPATAPA('FNB_TIEMPO_MES_CONSULTA','N',nuMeses,sbComodin);
  
  OPEN cuRefDataInic FOR
  SELECT vefnnomd,vefntido,vefnnice,vefnlued,
         vefnfeed,vefnsexo,vefnesci,vefnfena,
         vefnnies,vefndirr,vefndeba,vefndeci,
         vefndede,vefntelr,vefntivi,vefnestd,
         vefnanvi,vefntifa,vefnreti,vefnnpec,
         vefnocu, vefnnemt,vefndiro,vefntelo,
         vefntel2,vefntece,vefntico,vefnanla,
         vefnacin,vefninme,vefngame,vefnrefa,
         vefntfrf,vefntcrf,vefnreco,vefntffc,
         vefntcrc,vefnclvt,vefndepa,vefnloca
    FROM ventafnb v
   WHERE v.vefnsega = nuSesunuse
     AND months_between(SYSDATE,v.vefnfere) <= 12
     AND rownum = 1
   ORDER BY vefnfere DESC;

  RETURN(cuRefDataInic);

EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.FNUINIDATA] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(cuRefDataInic);

END fnuIniData;

PROCEDURE proGuardarVentaFNB(nuvefndepa  IN  ventafnb.vefndepa%type,--codigo departamento de donde se registra la venta                                                                            
                             nuvefnloca  IN  ventafnb.vefnloca%type,--codigo localidad de donde se registra la venta
                             --dtvefnfere  IN  ventafnb.vefnfere%type DEFAULT SYSDATE,--fecha de registro de la venta en el sistema
                             --dtvefnfrvt  IN  ventafnb.vefnfrvt%TYPE DEFAULT SYSDATE,--fecha real reportada por el vendedor en la que se hace la venta
                             nuvefnsega  IN  ventafnb.vefnsega%TYPE,--codigo servicio de gas del usuario que compra
                             nuvefnsefn  IN  ventafnb.vefnsefn%type,--codigo servicio fnb asignado 
                             nuvefnvavt  IN  ventafnb.vefnvavt%type,--valor total de la venta
                             --nuvefntafi  IN  ventafnb.vefntafi%type,--tasa de financiacion de la venta
                             nuvefncpve  IN  ventafnb.vefncpve%type,--comprobande de venta o solicitud de credito de la venta
                             nuvefncopr  IN  ventafnb.vefncopr%type,--codigo contratista provedor donde se hace la venta
                             nuvefncove  IN  ventafnb.vefncove%type,--codigo contratista vendedor que hace la venta
                             nuvefnnucu  IN  ventafnb.vefnnucu%type,--numero de cuotas en la que se financiara el monto de la venta
                             sbvefndirr  IN  ventafnb.vefndirr%type,--direccion de la residencia del cliente
                             sbvefndiro  IN  ventafnb.vefndiro%type,--direccion de la oficina del cliente
                             sbvefntelr  IN  ventafnb.vefntelr%type,--telefono de la residencia del cliente
                             sbvefntelo  IN  ventafnb.vefntelo%type,--telefono de la oficina del cliente
                             sbvefnnice  IN  ventafnb.vefnnice%type,--
                             sbvefntecn  IN  ventafnb.vefntecn%type,--tecnico que hace la venta
                             --nuvefnvain  IN  ventafnb.vefnvain%type,--cuota inicial de venta o excedente pagado en surtigas
                             nuvefnclvt  IN  ventafnb.vefnclvt%type,--clase de venta, 1 vendedor externo, 2 punto venta 
                             sbvefnnomd  IN  ventafnb.vefnnomd%type,--nombre deudor
                             sbvefntido  IN  ventafnb.vefntido%type,--tipo de documento cc(cedula de ciudadania), ce(cedula extranjeria) nit(numero de identificacion tributaria)
                             sbvefnlued  IN  ventafnb.vefnlued%type,--lugar expedicion documento
                             dtvefnfeed  IN  VARCHAR2,--ventafnb.vefnfeed%type,--FECHA expedicion documento--
                             sbvefnsexo  IN  ventafnb.vefnsexo%type,--sexo m(asculino) f(emenino)
                             sbvefnesci  IN  ventafnb.vefnesci%type,--estado civil s(oltero), c(asado), u(nion libre), d(ivorciado o separado), v(iudo), r(eligioso)
                             dtvefnfena  IN  VARCHAR2,--ventafnb.vefnfena%type,--fecha de nacimiento--
                             SBVEFNNIES  IN  ventafnb.vefnnies%type,--niveles de estudio p(rimaria),b(achillerato),t(ecnologo) r(profesional)
                             sbvefndeba  IN  ventafnb.vefndeba%type,--descripcion del barrio
                             sbvefndeci  IN  ventafnb.vefndeci%type,--descripcion de la ciudad
                             sbvefndede  IN  ventafnb.vefndede%type,--descripcion del departamento
                             sbvefntivi  IN  ventafnb.vefntivi%type,--tipo de vivienda f(amiliar), p(ropia), a(rrendada)
                             sbvefnestd  IN  ventafnb.vefnestd%type,--descripcion del estrato
                             sbvefnanvi  IN  ventafnb.vefnanvi%type,--antiguedad de la vivienda
                             sbvefntifa  IN  ventafnb.vefntifa%type,--titular de la factura s(i) o n(o)
                             sbvefnreti  IN  ventafnb.vefnreti%type,--relacion con el titular c(onyuge), h(ijo),p(adre o madre),f(amiliar),a(rrendatario),m(amigo),o(tro)
                             nuvefnnpec  IN  ventafnb.vefnnpec%type,--nro de personas a cargo
                             sbvefnocu   IN  ventafnb.vefnocu%type,--ocupacion e(mpleado), i(ndpendiente), j(ubilado), a(ma de casa) n(estudiante) s(in)
                             sbvefnnemt  IN  ventafnb.vefnnemt%type,--nombre de la empresa donde trabaja
                             sbvefntel2  IN  ventafnb.vefntel2%type,--telefono
                             sbvefntece  IN  ventafnb.vefntece%type,--telefono celular
                             sbvefntico  IN  ventafnb.vefntico%type,--tipo de contrato f(ijo) i(ndefinido) t(emporal) o(tro)
                             sbvefnanla  IN  ventafnb.vefnanla%type,--antiguedad laboral
                             nuvefninme  IN  ventafnb.vefninme%type,--ingresos mensuales
                             nuvefngame  IN  ventafnb.vefngame%type,--gastos mensuales
                             sbvefnrefa  IN  ventafnb.vefnrefa%type,--referencia familiar
                             sbvefntfrf  IN  ventafnb.vefntfrf%type,--telefono fijo referencia familiar
                             sbvefntcrf  IN  ventafnb.vefntcrf%type,--telefono celular referencia familiar
                             sbvefnreco  IN  ventafnb.vefnreco%type,--referencia comercial
                             sbvefntffc  IN  ventafnb.vefntffc%type,--telefono fijo referencia comercial
                             sbvefntcrc  IN  ventafnb.vefntcrc%type,--telefono celular referencia comercial
                             SBVEFNNOMC  IN  ventafnb.vefnnomc%type,--nombre codeudor
                             sbvefntidc  IN  ventafnb.vefntidc%type,--tipo de documento codeudor cc(cedula de ciudadania), ce(cedula extranjeria) nit(numero de identificacion tributaria)
                             sbvefnnicc  IN  ventafnb.vefnnicc%type,--numero identificacion codeudor
                             sbvefnluec  IN  ventafnb.vefnluec%type,--lugar expedicion documento codeudor
                             dtvefnfeec  IN  VARCHAR2,--ventafnb.vefnfeec%type,--fecha expedicion documento codeudor--
                             sbvefnsexc  IN  ventafnb.vefnsexc%type,--sexo m(asculino) f(emenino) codeudor, na(no-aplica)
                             sbvefnescc  IN  ventafnb.vefnescc%type,--estado civil s(oltero), c(asado), u(nion libre), d(ivorciado o separado), v(iudo), r(eligioso) codeudor, na(no-aplica)
                             dtvefnfenc  IN  VARCHAR2,--ventafnb.vefnfenc%type,--fecha de nacimiento codeudor--
                             sbvefnniec  IN  ventafnb.vefnniec%type,--niveles de estudio p(rimaria),b(achillerato),t(ecnologo) r(profesional) codeudor, na(no-aplica)
                             sbvefndico  IN  ventafnb.vefndico%type,--direccion de codeudor
                             sbvefndebc  IN  ventafnb.vefndebc%type,--descripcion del barrio codeudor
                             sbvefndecc  IN  ventafnb.vefndecc%type,--descripcion de la ciudad codeudor
                             sbvefndedc  IN  ventafnb.vefndedc%type,--descripcion del departamento codeudor
                             sbvefnteco  IN  ventafnb.vefnteco%type,--telefono codeudor
                             sbvefntivc  IN  ventafnb.vefntivc%type,--tipo de vivienda f(amiliar), p(ropia), a(rrendada) codeudor, na(no-aplica)
                             sbvefnestc  IN  ventafnb.vefnestc%type,--descripcion del estrato codeudor
                             sbvefnanvc  IN  ventafnb.vefnanvc%type,--antiguedad de la vivienda codeudor
                             sbvefntifc  IN  ventafnb.vefntifc%type,--titular de la factura s(i) o n(o) codeudor, na(no-aplica)
                             sbvefnretc  IN  ventafnb.vefnretc%type,--relacion con el titular c(onyuge), h(ijo),p(adre o madre),f(amiliar),a(rrendatario),m(amigo),o(tro) codeudor, na(no-aplica)
                             nuvefnnpcc  IN  ventafnb.vefnnpcc%type,--nro de personas a cargo codeudor
                             sbvefnocuc  IN  ventafnb.vefnocuc%type,--ocupacion e(mpleado), i(ndpendiente), j(ubilado), a(ma de casa) n(estudiante) s(in) codeudor, na(no-aplica)
                             sbvefnnemc  IN  ventafnb.vefnnemc%type,--nombre de la empresa donde trabaja codeudor
                             sbvefntfcc  IN  ventafnb.vefntfcc%type,--
                             sbvefnrecc  IN  ventafnb.vefnrecc%type,--
                             sbvefncerc  IN  ventafnb.vefncerc%type,--
                             sbvefntfrc  IN  ventafnb.vefntfrc%type,--
                             sbvefnrefc  IN  ventafnb.vefnrefc%type,--
                             nuvefngamc  IN  ventafnb.vefngamc%type,--
                             nuvefninmc  IN  ventafnb.vefninmc%type,--
                             sbvefnacic  IN  ventafnb.vefnacic%type,--
                             sbvefnanlc  IN  ventafnb.vefnanlc%type,--
                             sbvefnticc  IN  ventafnb.vefnticc%type,--
                             sbvefntecc  IN  ventafnb.vefntecc%type,--
                             sbvefntee2  IN  ventafnb.vefntee2%type,--
                             sbvefnteec  IN  ventafnb.vefnteec%type,--
                             sbvefndiec  IN  ventafnb.vefndiec%type,--
                             sbvefnocin  IN  ventafnb.vefnocin%type,--
                             --sbvefnuser  IN  ventafnb.vefnuser%type,--usuario
                             --sbvefnterm  IN  ventafnb.vefnterm%TYPE,--terminal
                             nuvefnsucu  IN  ventafnb.vefnsucu%type,--sucursal
                             sbvefncode  IN  ventafnb.vefncode%type,--necesita codeudor
                             nuvefnvaiv  IN  ventafnb.vefnvaiv%type,--
                             sbvefnbin   IN  ventafnb.vefnbin%type,--
                             --nuvefngvli  IN  ventafnb.vefngvli%type,--secuencia de actas para gvli
                             nuvefncupo  IN  ventafnb.vefncupo%type,--
                             sbvefnmail  IN  ventafnb.vefnmail%type,--
                             --sbvefnticp  IN  ventafnb.vefnticp%type,--tipo de cpve (m)anual,(a)utomatico
                             nuvefnsgac  IN  ventafnb.vefnsgac%type,--servicio de gas del codeudor
                             --nuvefndoan  IN  ventafnb.vefndoan%type,--codigo departamento orden de anulacion
                             --nuvefnloan  IN  ventafnb.vefnloan%type,--codigo localidad orden de anulacion
                             --nuvefnotan  IN  ventafnb.vefnotan%TYPE,--codigo orden de anulacion
                             nuFacturaA  IN  cuencobr.cucocodi%TYPE,
                             nuFacturaB  IN  cuencobr.cucocodi%TYPE,
                             dtFechLimA  IN  VARCHAR2,
                             dtFechLimB  IN  VARCHAR2,
                             sbvefnacin  IN  ventafnb.vefnacin%type,--actividad para independiente                             
                             nuvefnvcpr  IN  ventafnb.vefnvcpr%type, --VALOR COMISION CONTRATISTA PROVEEDOR
                             nuvefnvadc  IN  ventafnb.vefnvadc%type, -- VALOR DESCUENTO
                             nuvefnvcve  IN  ventafnb.vefnvcve%type, -- VALOR COMISION CONTRATISTA VENDEDOR
                             nuvefncodi  OUT ventafnb.vefncodi%type,
                             sbMesaVent  OUT VARCHAR2)--codigo interno consecutivo de la venta
                             
/****************************************************************************************
PROPIEDAD INTELECTUAL DE SURTIGAS
PROCEDURE    : proGuardarVentaFNB
AUTOR        : Jorge Mario Galindo
EMPRESA      : ArquitecSoft S.A.S
FECHA        : 25-11-2012
DESCRIPCION  : Procedimiento que se encarga de hacer persistente la data de la venta

Parametros de Entrada
           - nuSesunuse: Servicio Suscrito

Parametros de Salida

Historia de Modificaciones
Autor    Fecha       Descripcion
*****************************************************************************************/
IS
  --<<
  -- Parametros
  -->>
  nuError     NUMBER := 0;
  sbError     VARCHAR2(2000) := NULL;
  nuCodiFunc  funciona.funccodi%TYPE;
  expInsrVTA  EXCEPTION;
  expActuCup  EXCEPTION;
  expOrdetra  EXCEPTION;
  expCtaSald  EXCEPTION;
  expProVali  EXCEPTION;
  nuPorcIva   vedtfnb.vefnpoiv%TYPE;
  nuVaIva     vedtfnb.vefnpoiv%TYPE;
  nuprfnporc  prprofnb.prfnporc%TYPE;
  
  --<<
  -- Cursor para obtener las ordenes de visita FNB
  -->>
  CURSOR cuOrdVisita
      IS
  SELECT *
    FROM ordetrab
   WHERE ortrnuse = nuvefnsega
     AND ortrtitr = 1175
     AND ortresot = 2
     AND ortrcuad = nuvefncove;
     
  --<<
  -- Cursor para obtener las ordenes e visita FNB Referida
  -->>
  CURSOR cuOrdVisitaR IS
   SELECT *
     FROM ordetrab
    WHERE ortrnuse = nuvefnsega
      AND ortrtitr IN (1890,1891)
      AND ortresot in (1,2);
      
  --<<
  -- Cursor para obtener datos solicitados del producto
  -->>    
  CURSOR cuProductoFNB
      IS
  SELECT nvl(a.prfnpoiv,0) prfnpoiv, nvl(a.prfnvaiv,0) prfnvaiv, nvl(prfnporc,0) prfnporc  
    FROM prprofnb a, produfnb b
   WHERE prfncodi = prfnprod
     AND nvl(PRFNACTI, 'S') = 'S'
     AND prfntivt = nuvefnclvt
     AND prfncuad = nuvefncopr
     AND b.prfncodi = nuvefnvcve
   ORDER BY 1;   
           
BEGIN
  
 pkregidepu.pRegiMensaje('INICIO', SYSDATE, 'PKWEB-BRILLA'); 
  
 --<<
 -- Se vuelven persistentes 
 -->>
 proactuvalifact (nuvefnsega,
                  nuvefncpve,
                  nuFacturaA,
                  to_date(dtFechLimA, 'DD/MM/YYYY'),
                  nuFacturaB,
                  to_date(dtFechLimB, 'DD/MM/YYYY'));                   
  
 --<<
 -- Se obtiene el codigo del funcionario
 -->>
 nuCodiFunc := pkFuncionaMgr.fnuGetUserCode(USER);
 
 --<<
 -- Validar la cantidad maxima de cuotas permitidas Proverideuda(sbmens);
 -->> 
   
 sbError := 'Se procedera a resgitrar al venta';
   
 --<<
 -- Se Actualizan los cupos.
 -->>
 nuError := fnuActuCupos(nuSesunuse => nuvefnsega,
                         nuValTotVe => nuvefnvavt,
                         nuNeseVain => 0);                         
                         
 --<<
 -- Erro en la actualizacion de cupos
 -->>
 IF nuError = -1 THEN
    sbError := 'No se pudieron actualizar los cupos del usuario: '||nuvefnsega;
    RAISE expActuCup;
 END IF;        
   
 --<< 
 -- actualiza los datos del CPV
 -->>
 --proActuCPVE;
 
 --<<
 -- Se valida que el usuario no tenga un motivo de VISITA FNB pendiente por legalizar
 -->>
 FOR rgcuOrdVisita IN cuOrdVisita LOOP
 
     --<<
     -- Actualiza el estado de la O.T
     -->>
     PROCAESORTR(rgcuOrdVisita.ortrdenu,rgcuOrdVisita.ortrlonu,rgcuOrdVisita.ortrnume,3,nuCodiFunc,99,'Se legaliza por rvfn.');
     
      	   --<<
           -- Se actualiza la fecha de ejecucion 
           -->>
           BEGIN             
             UPDATE ordetrab
                SET ortrfeej = SYSDATE,
                    ortrfele = SYSDATE,
                    ortrtrre = 1175,
                    ortrcatr = 996
              WHERE ortrdenu = rgcuOrdVisita.ortrdenu
                AND ortrlonu = rgcuOrdVisita.ortrlonu
                AND ortrnume = rgcuOrdVisita.ortrnume;
             EXCEPTION
               WHEN OTHERS THEN
                 sbError := 'No se pudo actualizar la orden: '||rgcuOrdVisita.ortrdenu||'-'||rgcuOrdVisita.ortrlonu||'-'||rgcuOrdVisita.ortrnume;                 
                 RAISE expOrdetra;   
           END;
       
     --<<
     -- Actualiza el estado de la Atencion
     -->>
     PROCAESPERE(rgcuOrdVisita.ortrdnpe,rgcuOrdVisita.ortrlnpe,rgcuOrdVisita.ortrpere,4,'Se legaliza por rvfn.');
     
     --<<
     -- Actualiza el estado de la O.T
     -->>
     PROCAESORTR(rgcuOrdVisita.ortrdenu,rgcuOrdVisita.ortrlonu,rgcuOrdVisita.ortrnume,10,nuCodiFunc,99,'Se legaliza por rvfn.');

     
         --<<
         -- Se actualiza la fecha de ejecucion 
         -->>
         BEGIN             
           UPDATE ordetrab
              SET ortrfeej = SYSDATE,
                  ortrfele = SYSDATE,
                  ortrtrre = 1890,
                  ortrcatr = 996
            WHERE ortrdenu = rgcuOrdVisita.ortrdenu
              AND ortrlonu = rgcuOrdVisita.ortrlonu
              AND ortrnume = rgcuOrdVisita.ortrnume;
           EXCEPTION
             WHEN OTHERS THEN
                 sbError := 'No se pudo actualizar la orden: '||rgcuOrdVisita.ortrdenu||'-'||rgcuOrdVisita.ortrlonu||'-'||rgcuOrdVisita.ortrnume;               
                 RAISE expOrdetra;
         END;     
       
      PROCAESPERE(rgcuOrdVisita.ortrdnpe,rgcuOrdVisita.ortrlnpe,rgcuOrdVisita.ortrpere,4,'Se legaliza por rvfn.');
 
 END LOOP; 
 
 --<<
 -- Se valida que el usuario no tenga un motivo de VISITA FNB REFERIDA pendiente por legalizar
 -->>
 FOR rgcuOrdVisitaR IN cuOrdVisitaR LOOP
 
     --<<
     -- Actualiza el estado de la O.T
     -->>
     PROCAESORTR(rgcuOrdVisitaR.ortrdenu,rgcuOrdVisitaR.ortrlonu,rgcuOrdVisitaR.ortrnume,3,nuCodiFunc,99,'Se legaliza por rvfn.');
     
      	   --<<
           -- Se actualiza la fecha de ejecucion 
           -->>
           BEGIN             
             UPDATE ordetrab
                SET ortrfeej = SYSDATE,
                    ortrfele = SYSDATE,
                    ortrtrre = 1890,
                    ortrcatr = 996
              WHERE ortrdenu = rgcuOrdVisitaR.ortrdenu
                AND ortrlonu = rgcuOrdVisitaR.ortrlonu
                AND ortrnume = rgcuOrdVisitaR.ortrnume;
             EXCEPTION
               WHEN OTHERS THEN
                 sbError := 'No se pudo actualizar la orden: '||rgcuOrdVisitaR.ortrdenu||'-'||rgcuOrdVisitaR.ortrlonu||'-'||rgcuOrdVisitaR.ortrnume;                 
                 RAISE expOrdetra;   
           END;
       
     --<<
     -- Actualiza el estado de la Atencion
     -->>
     PROCAESPERE(rgcuOrdVisitaR.ortrdnpe,rgcuOrdVisitaR.ortrlnpe,rgcuOrdVisitaR.ortrpere,4,'Se legaliza por rvfn.');
     
     --<<
     -- Actualiza el estado de la O.T
     -->>
     PROCAESORTR(rgcuOrdVisitaR.ortrdenu,rgcuOrdVisitaR.ortrlonu,rgcuOrdVisitaR.ortrnume,10,nuCodiFunc,99,'Se legaliza por rvfn.');

     
         --<<
         -- Se actualiza la fecha de ejecucion 
         -->>
         BEGIN             
           UPDATE ordetrab
              SET ortrfeej = SYSDATE,
                  ortrfele = SYSDATE,
                  ortrtrre = 1890,
                  ortrcatr = 996
            WHERE ortrdenu = rgcuOrdVisitaR.ortrdenu
              AND ortrlonu = rgcuOrdVisitaR.ortrlonu
              AND ortrnume = rgcuOrdVisitaR.ortrnume;
           EXCEPTION
             WHEN OTHERS THEN
                 sbError := 'No se pudo actualizar la orden: '||rgcuOrdVisitaR.ortrdenu||'-'||rgcuOrdVisitaR.ortrlonu||'-'||rgcuOrdVisitaR.ortrnume;               
                 RAISE expOrdetra;
         END;     
       
      PROCAESPERE(rgcuOrdVisitaR.ortrdnpe,rgcuOrdVisitaR.ortrlnpe,rgcuOrdVisitaR.ortrpere,4,'Se legaliza por rvfn.');
 
 END LOOP;
 
 --<<
 -- Se inserta la venta
 -->> 
 BEGIN
      
   --<<
   -- Obtiene el codigo de la venta
   -->>
   proAsigNroVentaFNB(codi => nuvefncodi);
   
   --<<
   -- Se obtienen los datos del producto
   -->>
   OPEN cuProductoFNB;
   FETCH cuProductoFNB INTO nuPorcIva,nuVaIva,nuprfnporc;
   CLOSE cuProductoFNB;  
  
   --<<
   -- Se registra la venta en estado Generado
   -->>
   INSERT INTO ventafnb (vefndepa, vefnloca, vefncodi, vefnfere, vefnfrvt, vefnsega,
                         vefnsefn, vefnvavt, vefntafi, vefncpve, vefncopr, vefncove,
                         vefnvcpr, vefnvadc, vefnvcve, vefnnucu, vefndife, vefndepe,
                         vefnlope, vefnpere, vefnobse, vefnfepr, vefnfevp, vefndirr,
                         vefndiro, vefntelr, vefntelo, vefnnice, vefntecn, vefnvain,
                         vefnesve, vefnclvt, vefndove, vefnlove, vefnorve, vefnnomd,
                         vefntido, vefnlued, vefnfeed, vefnsexo, vefnesci, vefnfena,
                         vefnnies, vefndeba, vefndeci, vefndede, vefntivi, vefnestd,
                         vefnanvi, vefntifa, vefnreti, vefnnpec, vefnocu, vefnnemt,
                         vefntel2, vefntece, vefntico, vefnanla, vefnacin, vefninme,
                         vefngame, vefnrefa, vefntfrf, vefntcrf, vefnreco, vefntffc,
                         vefntcrc, vefnnomc, vefntidc, vefnnicc, vefnluec, vefnfeec,
                         vefnsexc, vefnescc, vefnfenc, vefnniec, vefndico, vefndebc,
                         vefndecc, vefndedc, vefnteco, vefntivc, vefnestc, vefnanvc,
                         vefntifc, vefnretc, vefnnpcc, vefnocuc, vefnnemc, vefntfcc,
                         vefnrecc, vefncerc, vefntfrc, vefnrefc, vefngamc, vefninmc,
                         vefnacic, vefnanlc, vefnticc, vefntecc, vefntee2, vefnteec,
                         vefndiec, vefnocin, vefnuser, vefnterm, vefnsucu, vefncode,
                         vefnvaiv, vefnbin, vefngvli,  vefncupo, vefnmail, vefnticp,
                         vefnsgac, vefndoan, vefnloan, vefnotan)
                  VALUES      
                         (nuvefndepa, nuvefnloca, nuvefncodi, SYSDATE, SYSDATE, nuvefnsega,
                          NULL, nuvefnvavt, fnuTasaDispFNB(), nuvefncpve, nuvefncopr, nuvefncove, 
                          NULL, NULL, NULL, nuvefnnucu, NULL, NULL,
                          NULL, NULL, 'NA', NULL, NULL, sbvefndirr,
                          sbvefndiro, sbvefntelr, sbvefntelo, sbvefnnice, sbvefntecn, 0,
                          'G', nuvefnclvt, NULL, NULL, NULL, sbvefnnomd,
                          sbvefntido, sbvefnlued, to_date(dtvefnfeed, 'DD/MM/YYYY'), sbvefnsexo, sbvefnesci, to_date(dtvefnfena, 'DD/MM/YYYY'), 
                          sbvefnnies, sbvefndeba, sbvefndeci, sbvefndede, sbvefntivi, sbvefnestd,
                          sbvefnanvi, sbvefntifa, sbvefnreti, nuvefnnpec, sbvefnocu , sbvefnnemt,
                          sbvefntel2, sbvefntece, sbvefntico, sbvefnanla, sbvefnacin, nuvefninme,
                          nuvefngame, sbvefnrefa, sbvefntfrf, sbvefntcrf, sbvefnreco, sbvefntffc,
                          sbvefntcrc, sbvefnnomc, sbvefntidc, sbvefnnicc, sbvefnluec, to_date(dtvefnfeec, 'DD/MM/YYYY'),
                          sbvefnsexc, sbvefnescc, to_date(dtvefnfenc, 'DD/MM/YYYY'), sbvefnniec, sbvefndico, sbvefndebc,
                          sbvefndecc, sbvefndedc, sbvefnteco, sbvefntivc, sbvefnestc, sbvefnanvc,
                          sbvefntifc, sbvefnretc, nuvefnnpcc, sbvefnocuc, sbvefnnemc, sbvefntfcc,
                          sbvefnrecc, sbvefncerc, sbvefntfrc, sbvefnrefc, nuvefngamc, nuvefninmc,
                          sbvefnacic, sbvefnanlc, sbvefnticc, sbvefntecc, sbvefntee2, sbvefnteec,
                          sbvefndiec, sbvefnocin, USER, FSBMACHINE(USERENV('SESSIONID')), nuvefnsucu, sbvefncode,
                          0, NULL , NULL, nuvefncupo, sbvefnmail, 'A',
                          nuvefnsgac, -1, -1, -1);
                          
   --<<
   -- Se Registra el producto tener cuidado con el campo nuvefnvcve ya que va a ser utilizado
   -- para obtener el codigo del producto 
   -->>
   INSERT INTO vedtfnb
     (vefndepa,
      vefnloca,
      vefncodi,
      vefncopr,
      vefndesc,
      vefncant,
      vefnvaun,
      vefnvaiv,
      vefnpoiv)
   VALUES
     (nuvefndepa,
      nuvefnloca,
      nuvefncodi,
      nuvefnvcve,
      nuprfnporc,
      1,
      nuvefnvavt,
      nuVaIva,
      nuPorcIva);
                        
   --<<
   -- Se registra el estado inicial de la venta
   -->>                     
   INSERT INTO CAESVEFN
     (CEVFDEPA,
      CEVFLOCA,
      CEVFCODI,
      CEVFESAN,
      CEVFESAC,
      CEVFFECR,
      CEVFUSER,
      CEVFTERM)
   VALUES
     (nuvefndepa,
      nuvefnloca,
      nuvefncodi,
      NULL,
      'G',
      SYSDATE,
      USER,
      FSBMACHINE(USERENV('SESSIONID')));                          
                          
 pkregidepu.pRegiMensaje('Inserto la venta', SQL%ROWCOUNT, 'PKWEB-BRILLA');                          
                          
 EXCEPTION
   WHEN OTHERS THEN
     sbError := '[PKIVRSURTIGAS.PROGUARDARVENTAFNB] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
     nuError := -1;                         
 END;         
 
 IF nuError = -1 THEN
   
    RAISE expInsrVTA;
 ELSE
   
   --<<
   -- Se validan los datos de la Venta
   -->>
   proValidaVentaFNB(nuVefnDepa => nuvefndepa,
                     nuVefnLoca => nuvefnloca,
                     nuVefnCodi => nuvefncodi,
                     sbTipo => 'P',
                     nuOk => nuError,
                     sbMensaje => sbError);   
                     
   IF nuError = -1 THEN
      ROLLBACK;
      sbError := 'ERROR: '||sbError;
      pkregidepu.pRegiMensaje('sbError', sbError, 'PKWEB-BRILLA'); 
      RAISE expProVali;
     
   ELSE
     --<<
     -- Guarda Cambios
     -->>
     COMMIT;
     sbMesaVent := 'Registro de Venta Exitosa!!!';     
     
   END IF;       
    
 END IF;  
      
EXCEPTION
  WHEN expInsrVTA THEN
    ROLLBACK;
    nuError := -1;
    nuvefncodi := -1;
    sbMesaVent := nuError||' ERROR: '||sbError;
    pkregidepu.pRegiMensaje('EXCEPTION Error Insertando la Venta', sbError, 'PKWEB-BRILLA');
  WHEN expActuCup THEN
    ROLLBACK;
    nuError := -2;
    nuvefncodi := -1;
    sbMesaVent := nuError||' ERROR: '||sbError;
    pkregidepu.pRegiMensaje('EXCEPTION Error Actualizando Cupos', sbError, 'PKWEB-BRILLA'); 
  WHEN expOrdetra THEN
    ROLLBACK;
    sbMesaVent := -3;
    nuvefncodi := -1;
    sbError := nuError||' ERROR: '||sbError;
    pkregidepu.pRegiMensaje('EXCEPTION Error Actualizando Cupos', sbError, 'PKWEB-BRILLA'); 
  WHEN expCtaSald THEN
    ROLLBACK;
    nuError := -4;
    nuvefncodi := -1;
    sbMesaVent := nuError||' ERROR: '||sbError;
    pkregidepu.pRegiMensaje('EXCEPTION Error Actualizando Cupos', sbError, 'PKWEB-BRILLA');       
  WHEN OTHERS THEN
    ROLLBACK;
    nuError := -5;
    nuvefncodi := -1;
    sbMesaVent := nuError||' [PKIVRSURTIGAS.PROGUARDARVENTAFNB] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbMesaVent, 'PKWEB-BRILLA');

END proGuardarVentaFNB; 

PROCEDURE proCalSimulador(nuValFin   IN  cuadcont.cuadcodi%TYPE,
                          nuTotCuo   IN  negoserv.nesesuca%TYPE,                           
                          nuCuotas   IN  NUMBER,
                          nuVlrCuo   OUT NUMBER,
                          nuVlrSeg   OUT NUMBER,
                          sbOutErr   OUT VARCHAR2)
/****************************************************************************************
PROPIEDAD INTELECTUAL DE SURTIGAS
PROCEDURE    : proCalSimulador
AUTOR        : Jorge Mario Galindo
EMPRESA      : ArquitecSoft S.A.S
FECHA        : 09-12-2012
DESCRIPCION  : Procediento para simular el pago de la deuda de la financiacion

Parametros de Entrada
           - nuValFin: Valor de la Financiacion
           - nuCuotas: Cantidad de Cuotas para realizar la financiacion

Parametros de Salida
           - sbOutErr: Control de Mensajes           

Historia de Modificaciones
Autor    Fecha       Descripcion
*****************************************************************************************/
IS
  --<<
  -- Parametros
  -->>
  nuTasaDis       NUMBER := 0;
  nuCuotasP       NUMBER := 0;
  nuTasaSeg       NUMBER := 0;
  nuValCuot       NUMBER := 0;
  nuVlrCuoSinTasa NUMBER := 0;
  sbComodin       VARCHAR2(2000) := NULL;
  
         
BEGIN
   
  --<<
  -- Se evalua que la cantidad de cuotas a financiar no sean mayores
  -- al parametro maximo de cuotas de FNB o menor o igual a cero
  -->>
  PROVAPATAPA('NUMERO_CUOTA_FNB_SURTI','N',nuCuotasP,sbComodin);  
  
  --<<
  -- Se evalua el resultado
  -->>
  IF (nuCuotasP < nuTotCuo) THEN
    
     --<<
     -- Seteo el mensaje de error
     -->>   
     sbOutErr := 'El numero de cuotas no puede ser Superior a '||nuCuotasP||', por favor verifique!';
     nuVlrSeg := -1;
     nuVlrCuo := -1;     
  
  ELSIF (nuTotCuo <= 0 OR nuTotCuo is NULL) THEN
  
     --<<
     -- Seteo el mensaje de error
     -->>   
     sbOutErr := 'Digite un numero de cuotas valido, por favor verifique!';  
     nuVlrSeg := -1;
     nuVlrCuo := -1;     
  
  ELSIF (nuTotCuo < nuCuotas) THEN
  
     --<<
     -- Seteo el mensaje de error
     -->>   
     sbOutErr := 'El numero de Cuota a Calcular es mayor al numero de cuotas totales, por favor revise su informacion!!!';   
     nuVlrSeg := -1;
     nuVlrCuo := -1;
     
  ELSE
         
     --<<
     -- Valor a cobrar del seguro
     -->>
     PROVAPATAPA('PORCENTAJE_SEGU_FNB_CLIENTE','N',nuTasaSeg,sbComodin);
    
     --<<
     -- Obtengo la tasa actual de financiacion
     -->>
     nuTasaDis := fnuTasaDispFNB();
    
     --<<
     -- Valor Cuota
     -->>
     nuVlrCuo := round(CALCUOTADIF(NVL(nuValFin,0),0,nuTotCuo,nuTasaDis,2),0);
     
     --<<
     -- Valor Seguro
     -->>
     nuVlrCuoSinTasa := round(CALCUOTADIF(NVL(nuValFin,0),0,nuTotCuo,0,2),0);
     
     nuVlrSeg := round((NVL(nuValFin,0)-(nuVlrCuoSinTasa*(nuCuotas-1)))*nuTasaSeg,0);
     
     sbOutErr := 'EXITO!!';
    
  END IF;
                              
EXCEPTION
  WHEN OTHERS THEN
    sbOutErr := '[PKIVRSURTIGAS.PROCALSIMULADOR] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbOutErr, 'PKWEB-BRILLA');

END proCalSimulador;

PROCEDURE proVersFechCPVE(nuVersion   OUT NUMBER,
                          sbFecVige   OUT VARCHAR2,
                          nuVerAuto   OUT NUMBER)
/****************************************************************************************
PROPIEDAD INTELECTUAL DE SURTIGAS
PROCEDURE    : proCalSimulador
AUTOR        : Jorge Mario Galindo
EMPRESA      : ArquitecSoft S.A.S
FECHA        : 09-12-2012
DESCRIPCION  : Procediento Para retornar la version de formato y vigencia del CPVE

Parametros de Entrada

Parametros de Salida
           - nuVersion: Version del CPVE   
           - sbFecVige: fecha de vigencia de pagare
           
Historia de Modificaciones
Autor    Fecha       Descripcion
*****************************************************************************************/
IS
  --<<
  -- Parametros
  -->>
  sbOutErr        VARCHAR2(2000) := NULL;
  sbComodin       VARCHAR2(2000) := NULL;
  nuComodin       NUMBER := 0;
  
         
BEGIN
   
  --<<
  -- Version y Fecha de Vigencia del CPVE
  -->>
  PROVAPATAPA('FNB_VERSION_CPVE_AU','N',nuVersion,sbComodin);
  PROVAPATAPA('FNB_FECHA_VIG_FORM_CPVE_AUTO','S',nuComodin,sbFecVige);
  PROVAPATAPA('FNB_VERSION_AUTO_CREDITICIA','N',nuVerAuto,sbComodin);
  
                              
EXCEPTION
  WHEN OTHERS THEN
    sbOutErr := '[PKIVRSURTIGAS.PROCALSIMULADOR] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbOutErr, 'PKWEB-BRILLA');

END proVersFechCPVE;
                
FUNCTION fcuRefVentaFNB(nuvefnsega ventafnb.vefnsega%TYPE,
                        nuvefncpve ventafnb.vefncpve%TYPE,
                        nuvefncopr ventafnb.vefncopr%TYPE)
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fcuRefVentaFNB
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 02-01-2013
  DESCRIPCION  : Funcion para retornar la informacion de la venta realizada

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN SYS_REFCURSOR IS
  --<<
  -- Parametros
  -->>
  cuRefVentaFNB   SYS_REFCURSOR;
  sbError         VARCHAR2(2000) := NULL;
    
BEGIN

  --<<
  -- Se obtiene la clase de venta para la financiacion de brilla
  -->>
  OPEN cuRefVentaFNB FOR
  SELECT vefndepa||'-'||fsbDescDeparta(vefndepa) vefndepa,
         vefnloca||'-'||fsbDescLocali(vefndepa,vefnloca) vefnloca,
         vefncodi,
         vefnfere,
         vefnfrvt,
         vefnsega,
         vefnsefn,
         vefnvavt,
         vefntafi,
         vefncpve,
         vefncopr,
         vefncove,
         vefnvcpr,
         vefnvadc,
         vefnvcve,
         vefnnucu,
         vefndife,
         vefndepe,
         vefnlope,
         vefnpere,
         vefnobse,
         vefnfepr,
         vefnfevp,
         vefndirr,
         vefndiro,
         vefntelr,
         vefntelo,
         vefnnice,
         vefntecn,
         vefnvain,
         vefnesve,
         vefnclvt,
         vefndove,
         vefnlove,
         vefnorve,
         vefnnomd,
         vefntido,
         vefnlued,
         vefnfeed,
         vefnsexo,
         vefnesci,
         vefnfena,
         vefnnies,
         vefndeba,--||'-'||fsbDescBarrio(vefndeba,vefndepa,vefnloca) vefndeba,
         vefndeci,
         vefndede,
         vefntivi,
         vefnestd,
         vefnanvi,
         vefntifa,
         vefnreti,
         vefnnpec,
         vefnocu,
         vefnnemt,
         vefntel2,
         vefntece,
         vefntico,
         vefnanla,
         vefnacin,
         vefninme,
         vefngame,
         vefnrefa,
         vefntfrf,
         vefntcrf,
         vefnreco,
         vefntffc,
         vefntcrc,
         vefnnomc,
         vefntidc,
         vefnnicc,
         vefnluec,
         vefnfeec,
         vefnsexc,
         vefnescc,
         vefnfenc,
         vefnniec,
         vefndico,
         vefndebc,
         vefndecc,
         vefndedc,
         vefnteco,
         vefntivc,
         vefnestc,
         vefnanvc,
         vefntifc,
         vefnretc,
         vefnnpcc,
         vefnocuc,
         vefnnemc,
         vefntfcc,
         vefnrecc,
         vefncerc,
         vefntfrc,
         vefnrefc,
         vefngamc,
         vefninmc,
         vefnacic,
         vefnanlc,
         vefnticc,
         vefntecc,
         vefntee2,
         vefnteec,
         vefndiec,
         vefnocin,
         vefnuser,
         vefnterm,
         vefnsucu,
         vefncode,
         vefnvaiv,
         vefnbin,
         vefngvli,
         vefncupo,
         vefnmail,
         vefnticp,
         vefnsgac,
         vefndoan,
         vefnloan,
         vefnotan,
         vefnroov
    FROM ventafnb v
   WHERE v.vefnsega = nuvefnsega
     AND v.vefncpve = nuvefncpve
     AND v.vefncopr = nuvefncopr     
     AND v.vefnclvt = 7;

  RETURN(cuRefVentaFNB);

EXCEPTION
  WHEN OTHERS THEN     
    sbError := '[PKIVRSURTIGAS.FCUREFVENTAFNB] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(cuRefVentaFNB);

END fcuRefVentaFNB;

FUNCTION fcuRefVentaProveedores(nuvefncopr ventafnb.vefncopr%TYPE)
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fcuRefVentaProveedores
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 02-01-2013
  DESCRIPCION  : Funcion para retornar la informacion de la venta realizada

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN SYS_REFCURSOR IS
  --<<
  -- Parametros
  -->>
  cuRefVentaProv   SYS_REFCURSOR;
  sbError         VARCHAR2(2000) := NULL;
    
BEGIN

  --<<
  -- Se obtiene la clase de venta para la financiacion de brilla
  -->>
  OPEN cuRefVentaProv FOR
  SELECT vefndepa||'-'||fsbDescDeparta(vefndepa) vefndepa,
         vefnloca||'-'||fsbDescLocali(vefndepa,vefnloca) vefnloca,
         vefncodi,
         vefnfere,
         vefnfrvt,
         vefnsega,
         vefnsefn,
         vefnvavt,
         vefntafi,
         vefncpve,
         vefncopr,
         vefncove,
         vefnvcpr,
         vefnvadc,
         vefnvcve,
         vefnnucu,
         vefndife,
         vefndepe,
         vefnlope,
         vefnpere,
         vefnobse,
         vefnfepr,
         vefnfevp,
         vefndirr,
         vefndiro,
         vefntelr,
         vefntelo,
         vefnnice,
         vefntecn,
         vefnvain,
         vefnesve,
         vefnclvt,
         vefndove,
         vefnlove,
         vefnorve,
         vefnnomd,
         vefntido,
         vefnlued,
         vefnfeed,
         vefnsexo,
         vefnesci,
         vefnfena,
         vefnnies,
         vefndeba,--||'-'||fsbDescBarrio(vefndeba,vefndepa,vefnloca) vefndeba,
         vefndeci,
         vefndede,
         vefntivi,
         vefnestd,
         vefnanvi,
         vefntifa,
         vefnreti,
         vefnnpec,
         vefnocu,
         vefnnemt,
         vefntel2,
         vefntece,
         vefntico,
         vefnanla,
         vefnacin,
         vefninme,
         vefngame,
         vefnrefa,
         vefntfrf,
         vefntcrf,
         vefnreco,
         vefntffc,
         vefntcrc,
         vefnnomc,
         vefntidc,
         vefnnicc,
         vefnluec,
         vefnfeec,
         vefnsexc,
         vefnescc,
         vefnfenc,
         vefnniec,
         vefndico,
         vefndebc,
         vefndecc,
         vefndedc,
         vefnteco,
         vefntivc,
         vefnestc,
         vefnanvc,
         vefntifc,
         vefnretc,
         vefnnpcc,
         vefnocuc,
         vefnnemc,
         vefntfcc,
         vefnrecc,
         vefncerc,
         vefntfrc,
         vefnrefc,
         vefngamc,
         vefninmc,
         vefnacic,
         vefnanlc,
         vefnticc,
         vefntecc,
         vefntee2,
         vefnteec,
         vefndiec,
         vefnocin,
         vefnuser,
         vefnterm,
         vefnsucu,
         vefncode,
         vefnvaiv,
         vefnbin,
         vefngvli,
         vefncupo,
         vefnmail,
         vefnticp,
         vefnsgac,
         vefndoan,
         vefnloan,
         vefnotan,
         vefnroov 
    FROM ventafnb v 
   WHERE v.vefncopr = nuvefncopr
     AND v.vefnesve = 'G'
     AND v.vefnclvt = 7
   ORDER BY v.vefnfere ASC;  

  RETURN(cuRefVentaProv);

EXCEPTION
  WHEN OTHERS THEN     
    sbError := '[PKIVRSURTIGAS.FCUREFVENTAPROVEEDORES] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(cuRefVentaProv);

END fcuRefVentaProveedores;

FUNCTION fcuRefFacturas(nuvefnsega ventafnb.vefnsega%TYPE,
                        nuvefncpve ventafnb.vefncopr%TYPE)
/*********************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fcuRefFacturas
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 04-01-2013
  DESCRIPCION  : Funcion para retornar la informacion de las facturas utilizadas
                 en la venta

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  ********************************************************************************/

 RETURN SYS_REFCURSOR IS
  --<<
  -- Parametros
  -->>
  cuRefFacturas   SYS_REFCURSOR;
  sbError         VARCHAR2(2000) := NULL;
    
BEGIN

  --<<
  -- Se obtiene la clase de venta para la financiacion de brilla
  -->>
  OPEN cuRefFacturas FOR
  SELECT vafanuse, vafacpve,  vafafactu1, 
         to_date(vafafech1,'DD/MM/YYYY') vafafech1, 
         vafafactu2, to_date(vafafech2,'DD/MM/YYYY') vafafech2,
         to_date(vafafecha,'DD/MM/YYYY') vafafecha
    FROM valifact v 
   WHERE v.vafanuse = nuvefnsega
     AND v.vafacpve = nuvefncpve;  

  RETURN(cuRefFacturas);

EXCEPTION
  WHEN OTHERS THEN     
    sbError := '[PKIVRSURTIGAS.FCUREFFACTURAS] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(cuRefFacturas);

END fcuRefFacturas;

FUNCTION fnuLegaVentaFNB(nuvefnsega ventafnb.vefnsega%TYPE,
                         nuvefndepa ventafnb.vefndepa%TYPE,
                         nuvefnloca ventafnb.vefnloca%TYPE,
                         nuvefncodi ventafnb.vefncodi%TYPE,
                         nuvefncpve ventafnb.vefncpve%TYPE,
                         nuvefncopr ventafnb.vefncopr%TYPE)
                         
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fnuLegaVentaFNB
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 02-01-2013
  DESCRIPCION  : Funcion que se encarga de legalizar la venta

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN VARCHAR2 IS
  --<<
  -- Parametros
  -->>
  sbError         VARCHAR2(2000) := NULL;
  nuOk            NUMBER := 0;
   
  -->>
  -- Cursores
  --<<
  CURSOR cuLegaVent 
      IS
  SELECT sesususc, sesunuse, vefncopr, vefncove, 
         vefnvavt, vefnvain, vefnCLvt, vefndepa,
         vefnloca, vefncodi, vefnfepr, vefnnucu,
         vefntafi, vefnocin
    FROM ventafnb v, suscripc a, servsusc s
   WHERE sesususc = susccodi
     AND sesunuse = nuvefnsega
     AND vefnsega = nuvefnsega 
     AND vefndepa = nuvefndepa
     AND vefnloca = nuvefnloca
     AND vefncodi = nuvefncodi
     AND vefncpve = nuvefncpve
     AND vefncopr = nuvefncopr;
    
BEGIN

 --<<
 -- Recorro los codigos CPVE aprobados
 -->>
 FOR rgcuLegaVent in cuLegaVent LOOP

    --<<
    -- Se invoca el metodo para legalizar la venta
    -->>
    prolegaventafnb(nususc     => rgcuLegaVent.sesususc,
                    nusegas    => rgcuLegaVent.sesunuse,
                    nucuadprov => rgcuLegaVent.vefncopr,
                    nucuadvent => rgcuLegaVent.vefncove,
                    nuvalvta   => rgcuLegaVent.vefnvavt,
                    nuvalvain  => rgcuLegaVent.vefnvain,
                    nutivta    => rgcuLegaVent.vefnCLvt,
                    nuvtadepa  => rgcuLegaVent.vefndepa,
                    nuvtaloca  => rgcuLegaVent.vefnloca,
                    nuvta      => rgcuLegaVent.vefncodi,
                    dtfeej     => SYSDATE,
                    nucu       => rgcuLegaVent.vefnnucu,
                    tafi       => rgcuLegaVent.vefntafi,
                    ocin       => rgcuLegaVent.vefnocin,
                    sbmens     => sbError);                                   
                    
  END LOOP;
  
  nuOk := 0;
  
  IF sbError = '0|' THEN
  
     BEGIN
       UPDATE ventafnb v
          SET v.vefnfepr = SYSDATE
        WHERE v.vefncpve = nuvefncpve;
     EXCEPTION
       WHEN OTHERS THEN
         nuOk := -1;
         sbError := '[PKIVRSURTIGAS.FNULEGAVENTAFNB] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
         pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');         
     END;
     
     IF (nuOk = 0) THEN       
          COMMIT;    
     ELSE       
          ROLLBACK;
     END IF;
    
  END IF;
  
  RETURN(sbError);

EXCEPTION
  WHEN OTHERS THEN     
    sbError := '[PKIVRSURTIGAS.FNULEGAVENTAFNB] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN('-1| Error: '||sbError);

END fnuLegaVentaFNB;

FUNCTION fsbDescBarrio(barrio barrio.barrcodi%TYPE,
                       depart barrio.barrdepa%TYPE,
                       locali barrio.barrloca%TYPE)
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fsbDescBarrio
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 24-11-2012
  DESCRIPCION  : 

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN VARCHAR2 IS

  --<<
  -- Parametros
  -->>
  sbError      VARCHAR2(2000) := 'N/A'; 
  
  --<<
  -- Cursor 
  -->>    
  CURSOR cuBarrDesc
      IS
   SELECT barrdesc from barrio
    WHERE barrdepa = depart 
      AND barrloca = locali
      AND barrcodi = barrio;
      
BEGIN
  
  FOR rgcuBarrDesc IN cuBarrDesc loop

    RETURN(rgcuBarrDesc.barrdesc);
  
  END LOOP;
  
  RETURN(sbError);

EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.FSBDESCBARRIO] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(sbError);

END fsbDescBarrio;

FUNCTION fsbDescDeparta(depart departam.depacodi%TYPE)
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fsbDescDeparta
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 24-11-2012
  DESCRIPCION  : 

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN VARCHAR2 IS

  --<<
  -- Parametros
  -->>
  sbError      VARCHAR2(2000) := 'N/A';  
  
  --<<
  -- cursor para Obtener la descripcion del Departamento
  -->>
  CURSOR cuDescDepartam
      IS
  SELECT depadesc from departam
   WHERE depacodi = depart;
  
  
    
BEGIN
  
  FOR rgcuDescDepartam IN cuDescDepartam loop

    RETURN(rgcuDescDepartam.depadesc);
  
  END LOOP;
  
  RETURN(sbError);

EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.FSBDESCDEPARTA] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(sbError);

END fsbDescDeparta;

FUNCTION fsbDescLocali(depart localida.locadepa%TYPE,
                       locali localida.locacodi%TYPE)
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fsbDescLocali
  AUTOR        : Jorge Mario Galindo
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 24-11-2012
  DESCRIPCION  : 

  Parametros de Entrada

  Parametros de Salida

  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN VARCHAR2 IS

  --<<
  -- Parametros
  -->>
  sbError      VARCHAR2(2000) := 'N/A'; 
  
  --<<
  -- Cursor para Obtener la descripcion de la localidad
  -->>
  CURSOR cuDescLoca
      IS
  SELECT locanomb FROM localida
   WHERE locacodi = locali
     AND locadepa = depart;
  
    
BEGIN
  FOR rgcuDescLoca IN cuDescLoca LOOP

    RETURN(rgcuDescLoca.locanomb);
  
  END LOOP;
  
  RETURN(sbError);

EXCEPTION
  WHEN OTHERS THEN
    sbError := '[PKIVRSURTIGAS.FSBDESCLOCALI] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
    pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
    RETURN(sbError);

END fsbDescLocali;

FUNCTION fsbAnulaVentasWeb (nuSesunuse   servsusc.sesunuse%TYPE,
                            nuMotivo     motipere.mopecodi%TYPE,
                            nuvefncodi   ventafnb.vefncodi%type,
                            sbObservac   ordetrab.ortrobse%TYPE)
/*****************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS
  FUNCION      : fsbAnulaVentasWeb
  AUTOR        : Jose Ricardo Gallego 
  EMPRESA      : ArquitecSoft S.A.S
  FECHA        : 22-01-2013
  DESCRIPCION  : 

  Parametros de Entrada
      nuSesunuse : numero del servicio suscrito (Suscriptor)
      nuMotivo   : PQR necesaria para la cancelacion del servicio (761) 
      nuvefncodi : Codigo interno consecutivo de la venta
      sbObservac : Observacion 
  
  Parametros de Salida
      sbError    : Mensaje que informa si el proceso fue exito o no 
      
  Historia de Modificaciones
  Autor    Fecha       Descripcion
  *****************************************************************************/

 RETURN VARCHAR2 IS

    --<<
    -- Parametros
    -->>
    nuOk         NUMBER;
    sbError      VARCHAR2(800) := sbObservac; 
    nuortr       NUMBER(4);
    nuCodiFunc   NUMBER;
    
    nuCausa      ordetrab.ortrcatr%TYPE; 
    vaComodin    VARCHAR2(20);
    
    --<<
    -- Cursor para obtener los valores de la orden 
    -->>          
    CURSOR cuOrdeTrab(dnpe ordetrab.ortrdnpe%TYPE, 
                      lnpe ordetrab.ortrlnpe%TYPE, 
                      pere ordetrab.ortrpere%TYPE) 
        IS
    SELECT o.ortrdepa, o.ortrloca,  o.ortrnume
      FROM ordetrab o
     WHERE o.ortrdnpe = dnpe
       AND o.ortrlnpe = lnpe
       AND o.ortrpere = pere;
    
BEGIN
  
  --<<
  -- Funcion que se encarga de traer el motivo 
  -->>
  provapatapa('COD_CUA_ANU_VEN', 'N', nuCausa, vaComodin);     

  --<<
  -- Se llama al metodo fnuinspere para setear algunas variables globales con la PQR 761
  -->>
  nuOk := pkwebsurtigas.fnuinspere( nuSesunuse => nusesunuse, 
                                    nuMotivo => numotivo,  
                                    sbObservac => sbError);
                                    
      --<< pkmotivos
      -- Si se puedieron setear bien las variables globalas
      -- Se asiganan los valores que necesito a algunas variables globales
      -- La funcion proatanulfnbnewmodelsl es la que se encarga de anular la venta
      -->>                            
     IF nuOk = 0 THEN
        pkmotivos.cupon_pago_cruzado := nuvefncodi;
        pkmotivos.nucaufnb           := nuCausa;

        proatanulfnbnewmodelsl(isbValor => null, 
                               sbmensaje => sbError);
        
        --<<
        -- Validar que hizo la funcion proatanulfnbnewmodelsl en caso de exito hacer un commit
        -- y en casa de fracazo hacer un rollback
        -->>
         IF sbError = '0|' THEN
            
            BEGIN  
              
              --<<
              -- Actualizar el estado de la orden de trabajo y le fecha de legalizacion
              -- de la tabla de ordenes de trabajo
              -->> 
                                             
              UPDATE ordetrab 
                 SET ortresot = 3, 
                     ortrfele = SYSDATE
               WHERE ortrdnpe = pkmotivos.nuPereDepa
                 AND ortrlnpe = pkmotivos.nuPereLoca
                 AND ortrpere = pkmotivos.nuPereCodi;
                 
              --<<
              -- Actualizar algunos campos 
              -- de la tabla de quejas solicitudes y reclamos
              -->>
               UPDATE perequej 
                 SET pereespe = 4,
                     perefeat = SYSDATE,
                    -- perefuen = ,
                    -- perevaan = -1,
                     perecuve = -1,
                     perevaan = 0,
                     peresaan = 0,
                     perednco = -1,
                     perelnco = -1,
                     perecoti = -1,
                    -- perecpve = -1,
                     peretecn = -1
               WHERE PereDepa = pkmotivos.nuPereDepa
                 AND PereLoca = pkmotivos.nuPereLoca
                 AND PereCodi = pkmotivos.nuPereCodi; 
              
              --<<
              -- Realiza el cambio de Estado para la perequeja
              -->>
              proCaesPere(nuDepa      => pkmotivos.nuPereDepa,
                          nuLoca      => pkmotivos.nuPereLoca,
                          nuPere      => pkmotivos.nuPereCodi,
                          nuNuevEsta  => 4,
                          sbObse      => 'CAMBIO DE ESTADO ANULACION BRILLAWEB');  
              
              --<<
              -- Se obtiene el codigo del funcionario
              -->>
               nuCodiFunc := pkFuncionaMgr.fnuGetUserCode(USER);
               
              --<<
              -- Sacar los datos de la orden de trabajo
              -->>
              FOR rgOrdeTrab IN cuOrdeTrab(pkmotivos.nuPereDepa, pkmotivos.nuPereLoca, pkmotivos.nuPereCodi) LOOP
                  
                  procaesortr(nudepa     => rgOrdeTrab.Ortrdepa,
                              nuloca     => rgOrdeTrab.Ortrloca,
                              nuortr     => rgOrdeTrab.Ortrnume,
                              nunuevesta => 3,
                              nufunc     => nuCodiFunc,
                              nucauscamb => -1,
                              sbobse     => 'CAMBIO DE ESTADO ANULACION BRILLAWEB');
              END LOOP;                                    
              
            EXCEPTION
                 WHEN OTHERS THEN
                   nuOk := -1;
                   ROLLBACK;
                   sbError := '[PKIVRSURTIGAS.FSBANULAVENTASWEB] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
                   pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');         
               END;                           
            
        ELSE
            ROLLBACK;
        END IF;    
        
        COMMIT;                           
        
        RETURN(sbError);
        
     ELSE
         ROLLBACK;
         RETURN ('No se puedo realizar la anulación');
     END IF; 


EXCEPTION
    WHEN OTHERS THEN
        sbError := '[PKIVRSURTIGAS.FSBANULAVENTASWEB] - ' || SQLERRM || ' ' || DBMS_UTILITY.format_error_backtrace;
        pkregidepu.pRegiMensaje('EXCEPTION Error', sbError, 'PKWEB-BRILLA');
        ROLLBACK;
        RETURN(sbError);

END fsbAnulaVentasWeb;












      
END pkWebBrilla;
/
