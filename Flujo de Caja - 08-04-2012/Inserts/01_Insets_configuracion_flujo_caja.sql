Insert into LDC_DEFISEWE (DESECODI,DESEDESC) values ('WS_FLUJOCAJA','Configuración cliente flujo caja');

insert into LDC_CARASEWE (CASECODI, CASEDESC, CASEVALO, CASEDESE)
values ('WSURL', 'URL', 'XISOAPAdapter/MessageServlet?senderParty=&senderService=STGGplus_Q&receiverParty=&receiverService=&interface=FlujoCajaProcesamiento_Out&interfaceNamespace=urn:gaseras.com:Finanzas:Front', 'WS_FLUJOCAJA');

insert into LDC_CARASEWE (CASECODI, CASEDESC, CASEVALO, CASEDESE)
values ('SOAPACTION', 'SOAP ACTION', 'http://sap.com/xi/WebService/soap1.1', 'WS_FLUJOCAJA');

insert into LDC_CARASEWE (CASECODI, CASEDESC, CASEVALO, CASEDESE)
values ('NAMESPACE', 'NAMESPACE', 'urn="urn:gaseras.com:Finanzas:ECC"', 'WS_FLUJOCAJA');

insert into LDC_CARASEWE (CASECODI, CASEDESC, CASEVALO, CASEDESE)
values ('PROTOCOLO', 'HTTP', 'HTTPS', 'WS_FLUJOCAJA');

insert into LDC_CARASEWE (CASECODI, CASEDESC, CASEVALO, CASEDESE)
values ('PUERTO', 'PUERTO INTERFAZ CONTABLE', '443', 'WS_FLUJOCAJA');

insert into LDC_CARASEWE (CASECODI, CASEDESC, CASEVALO, CASEDESE)
values ('HOST', 'ENDPOINT', '10.48.50.13', 'WS_FLUJOCAJA');

