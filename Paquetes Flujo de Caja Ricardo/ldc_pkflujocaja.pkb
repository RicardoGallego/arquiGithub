CREATE OR REPLACE PACKAGE BODY LDC_PKFLUJOCAJA AS

/*
 * PROPIEDAD INTELECTUAL DE SURTIGAS S.A. E.S.P
 *
 * Script  : proEnvFlujoCaja
 * Autor   : Arquitecsoft Hector Javier Cuervo
 * Fecha   : 19/04/2012
 * Descripcion : Crea el paquete SOAP de acuerdo a los parametros configurados
 *
 * Parametros
 *
 * Historia de Modificaciones
 * Autor              Fecha         Descripcion

**/

PROCEDURE proEnvFlujoCaja (nuAno   in   LDC_FLUJOCAJA.ANO%TYPE,
                           nuMes   in   LDC_FLUJOCAJA.MES%TYPE) AS

/*
 * Este cursor permite extraer la informaci¿n delete flujo de caja
 * que corresponda, y a partir de esta informacion se genere el xml para enviar
 <urn:FlujoCajaRequest>
         <Conceptos>
            <cdConcep>1</cdConcep>
            <ejercicio>1</ejercicio>
            <mesCont>1</mesCont>
            <tipoFlu>1</tipoFlu>
            <moneda>?</moneda>
            <importe>1000</importe>
            <fecha>10102012</fecha>
         </Conceptos>
</urn:FlujoCajaRequest>

  Tipo de flujo
  1 -  Plan
  0 - Real
 */
  CURSOR cuDiasFlujoCaja
  IS
  SELECT ano, mes, fecha_doc FROM LDC_FLUJOCAJA
   WHERE ANO = nuAno
     AND MES = nuMes
     AND valor > 0
   GROUP BY ano, mes, fecha_doc;


  CURSOR cuDatosFlujoCaja(inuAno      ldc_flujocaja.ano%type,
                          inuMes      ldc_flujocaja.mes%type,
                          idtFecha    ldc_flujocaja.fecha_doc%type)
  IS
  SELECT  XMLElement("urn:FlujoCajaRequest",
                                 XMLAGG(XMLElement("Conceptos",
                                                        decode(CDCONCEP,null,null,XMLElement("cdConcep",CDCONCEP)),
                                                        decode(ANO,NULL,NULL,XMLElement("ejercicio",ANO)),
                                                        decode(MES,null,null,XMLElement("mesCont",MES)),
                                                        decode(TIPOFLU,null,null,XMLElement("tipoFlu",TIPOFLU)),
                                                        decode(MONEDA,null,null,XMLElement("moneda",MONEDA)),
                                                        DECODE(VALOR,NULL,NULL,XMLELEMENT("importe",to_char(VALOR,'999999999999999.99'))),
                                                        decode(FECHA_DOC,null,null,XMLElement("fecha",to_char(FECHA_DOC,'YYYY-MM-DD'))))))
  FROM LDC_FLUJOCAJA
  WHERE ANO = inuAno
    and MES = inuMes
    and fecha_doc = idtFecha
    and valor > 0;

  vaDatos             XMLType;
  sbPayload           CLOB;
  sbResponse          CLOB;
  nuReportSoapError   NUMBER;
  nuReportHttpError   NUMBER;
  codMensaje          NUMBER;
  --l_payload_namespace varchar2(32766);
  sbNameSpace         ldc_carasewe.casevalo%type;
  sbTarget            ldc_carasewe.casevalo%type;
  sbTargetFull        ldc_carasewe.casevalo%type;
  sbProtocolo         ldc_carasewe.casevalo%type;
  sbHost              ldc_carasewe.casevalo%type;
  sbWSURL             ldc_carasewe.casevalo%type;
  sbSoapAction        ldc_carasewe.casevalo%type;
  sbPuerto            ldc_carasewe.casevalo%type;
  sbMens              varchar2(500);
  nuEstado            NUMBER;


BEGIN


   for h in cuDiasFlujoCaja loop
   
        vaDatos := null;
        
        /*
         * Obtengo el mensaje xml a enviar
         */
        open cuDatosFlujoCaja(h.ano, h.mes, h.fecha_doc);
         fetch cuDatosFlujoCaja into vaDatos;
        close cuDatosFlujoCaja;

        sbPayload:=vaDatos.getClobVal();

        --<<
        --obtencion de parametros
        -->>
        ldc_pkWebServUtils.proCaraServWeb('WS_FLUJOCAJA','NAMESPACE',sbNameSpace,sbMens);
        ldc_pkWebServUtils.proCaraServWeb('WS_FLUJOCAJA','PROTOCOLO',sbProtocolo,sbMens);
        ldc_pkWebServUtils.proCaraServWeb('WS_FLUJOCAJA','WSURL',sbWSURL,sbMens);
        ldc_pkWebServUtils.proCaraServWeb('WS_FLUJOCAJA','HOST',sbHost,sbMens);
        ldc_pkWebServUtils.proCaraServWeb('WS_FLUJOCAJA','SOAPACTION',sbSoapAction,sbMens);
        ldc_pkWebServUtils.proCaraServWeb('WS_FLUJOCAJA','PUERTO',sbPuerto,sbMens);

        sbTargetFull        := lower(sbProtocolo)||'://'||sbHost||':'||sbPuerto||'/'||sbWSURL;
        ldc_pksoapapi.proSetProtocol(lower(sbProtocolo));

        SELECT LDC_SEQMESAWS.NEXTVAL INTO CODMENSAJE FROM DUAL;

        LDC_PKMESAWS.PROCREATEINITMESSAGE(CODMENSAJE,'WS_FLUJOCAJA',-1);

        SBRESPONSE := LDC_PKSOAPAPI.FSBSOAPSEGMENTEDCALL(SBPAYLOAD, SBTARGETFULL, SBSOAPACTION,SBNAMESPACE);

        DBMS_OUTPUT.PUT_LINe('SBTARGETFULL:'||SBTARGETFULL);

        LDC_PKMESAWS.proUpdateFullMessageError(codMensaje,
                                                 ldc_pksoapapi.sbSoapRequest,
                                                 'WS_FLUJOCAJA',
                                                 ldc_pksoapapi.sbErrorHttp,
                                                 sbPayload,
                                                 sbResponse,
                                                 ldc_pksoapapi.sbTraceError,
                                                 ldc_pksoapapi.boolHttpError,
                                                 ldc_pksoapapi.boolSoapError,
                                                 SYSDATE
                                                 );
        /*
        * Actualizo el mensaje para indicar el origen de los datos
        *
        */

        --UPDATE LDC_MESAENVWS SET MESAEXTID=iNuDocumento WHERE MESACODI=codMensaje;
        COMMIT;

    end loop;
EXCEPTION
WHEN OTHERS THEN
  ldc_pkWebServUtils.Procrearerrorlogint('Flujo de Caja', 1, 'Error procesando interfaz: '|| Sqlerrm || Dbms_Utility.Format_Error_Backtrace, null, null);
END proEnvFlujoCaja;
END LDC_PKFLUJOCAJA;
/
