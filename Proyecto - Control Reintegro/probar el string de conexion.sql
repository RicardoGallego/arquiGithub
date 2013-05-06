DECLARE
    req   utl_http.req;
    resp  utl_http.resp;
    sbSoapResponseSegmented  VARCHAR2(3000);
BEGIN
  
    UTL_HTTP.SET_WALLET('file:/oracle/product/11.1/dbs/wallet','surtigas2012');
    req := utl_http.begin_request('http://10.48.50.13:50000/XISOAPAdapter/MessageServlet'||chr(63)||'senderParty='||chr(63)||'senderService=STGGplus_D'||chr(63)||'receiverParty='||chr(63)||'receiverService='||chr(63)||'interface=FlujoCajaProcesamiento_Out'||chr(63)||'interfaceNamespace=urn:gaseras.com:Finanzas:Front');
    resp := utl_http.get_response(req);


  --dbms_output.put_line('Iniciando Lectura');
    BEGIN

        LOOP
            utl_http.read_line(resp, sbSoapResponseSegmented, TRUE);
            dbms_output.put_line(sbSoapResponseSegmented);
            --dbms_output.put_line(sbSoapResponseSegmented);
        END LOOP;

    EXCEPTION
        WHEN utl_http.end_of_body THEN
            /*
            * Termino la conexion http
            */
            --utl_http.end_response(http_resp);
            utl_http.end_response(resp);
    END;



EXCEPTION
    WHEN utl_http.end_of_body THEN
        utl_http.end_response(resp);
END;
