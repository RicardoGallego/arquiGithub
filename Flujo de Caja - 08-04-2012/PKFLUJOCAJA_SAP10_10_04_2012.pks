CREATE OR REPLACE PACKAGE PKFLUJOCAJA_SAP10 IS

dtfeinis1m1     DATE;
dtfefis1m1      DATE;
dtfeinis2m1     DATE;
dtfefis2m1      DATE;
dtfeinis3m1     DATE;     
dtfefis3m1      DATE;
dtfeinis4m1     DATE;
dtfefis4m1      DATE;
nuanorfc        NUMBER(4) DEFAULT 2011;
numesrfc        NUMBER(2) DEFAULT 11;
sbprog          VARCHAR2(10);
nufunc          funciona.funccodi%TYPE DEFAULT -1;
nugrupo         NUMBER;

PROCEDURE provalidaanomes;
FUNCTION fsbmesletras(numes NUMBER) RETURN VARCHAR2;
PROCEDURE procrearegfactconc(nudepa NUMBER,nuloca NUMBER,nuanoe NUMBER,numese NUMBER,nuano NUMBER,
                             numes NUMBER,nuconc NUMBER,nuValor NUMBER,nugrupo NUMBER, dtDia DATE);
PROCEDURE ProProyIngFactFlujoCaja;
PROCEDURE proypagosflucaja;
PROCEDURE ProProyRecaFlujoCaja;
PROCEDURE proconsvalrealingcarg;
PROCEDURE procarginreal(nuanoe NUMBER,numese NUMBER, dtdiae DATE);
PROCEDURE proconsvalrealingtipmov;
PROCEDURE procarginrealtipmov(nuanoe NUMBER,numese NUMBER, dtdiafech DATE);
PROCEDURE progeningreflcj;
PROCEDURE progeneegresoflcj;
PROCEDURE proprocesar1;
PROCEDURE proprocesar2;
PROCEDURE proprocesar3;

PROCEDURE proInicial(nuanoe NUMBER,numese NUMBER);
PROCEDURE proReportes;
PROCEDURE prcGeInComp(nuanoe NUMBER,numese NUMBER, nuOperacion NUMBER);

PROCEDURE prcPruebaReporte(nuanoe NUMBER,numese NUMBER);

END PKFLUJOCAJA_SAP10;
/
CREATE OR REPLACE PACKAGE BODY PKFLUJOCAJA_SAP10 IS

PROCEDURE provalidaanomes IS
/***********************************************************************************************
 Nombre : provalidaanomes
 Desc   : Valida que el a?o y mes sean correctos
 Autor  : John Jimenez
 Fecha  : Junio 1 2007
***********************************************************************************************/
BEGIN
 IF nuanorfc IS NULL OR numesrfc IS NULL THEN
    RAISE_APPLICATION_ERROR(-20000,'Los valores de a?o y mes son nulos.');
 ELSE
  DBMS_OUTPUT.PUT_LINE('A?o y mes validado correctamente.');
 END IF;
END provalidaanomes;

FUNCTION fsbmesletras(numes NUMBER) RETURN VARCHAR2 IS
/***********************************************************************************************
 Nombre : fsbmesletras
 Desc   : Retorna mes en letras
 Autor  : John Jimenez
 Fecha  : Junio 1 2007
***********************************************************************************************/
mesle VARCHAR2(3);
BEGIN
 

 IF numes = 1 THEN
    mesle := 'ENE';
 ELSIF numes = 2 THEN
    mesle := 'FEB';
 ELSIF numes = 3 THEN
    mesle := 'MAR';
 ELSIF numes = 4 THEN
    mesle := 'ABR';
 ELSIF numes = 5 THEN
    mesle := 'MAY';
 ELSIF numes = 6 THEN
    mesle := 'JUN';
 ELSIF numes = 7 THEN
    mesle := 'JUL';
 ELSIF numes = 8 THEN
    mesle := 'AGO';
 ELSIF numes = 9 THEN
    mesle := 'SEP';
 ELSIF numes = 10 THEN
    mesle := 'OCT';
 ELSIF numes = 11 THEN
    mesle := 'NOV';
 ELSE
    mesle := 'DIC';
 END IF; 
  RETURN mesle;
/* IF numes = 1 THEN
    mesle := 'JAN';
 ELSIF numes = 2 THEN
    mesle := 'FEB';
 ELSIF numes = 3 THEN
    mesle := 'MAR';
 ELSIF numes = 4 THEN
    mesle := 'APR';
 ELSIF numes = 5 THEN
    mesle := 'MAY';
 ELSIF numes = 6 THEN
    mesle := 'JUN';
 ELSIF numes = 7 THEN
    mesle := 'JUL';
 ELSIF numes = 8 THEN
    mesle := 'AUG';
 ELSIF numes = 9 THEN
    mesle := 'SEP';
 ELSIF numes = 10 THEN
    mesle := 'OCT';
 ELSIF numes = 11 THEN
    mesle := 'NOV';
 ELSE
    mesle := 'DEC';
 END IF;*/

END fsbmesletras;

PROCEDURE procrearegfactconc(nudepa NUMBER,nuloca NUMBER,nuanoe NUMBER,numese NUMBER,
                             nuano NUMBER,numes NUMBER,nuconc NUMBER,nuValor NUMBER,
                             nugrupo NUMBER, dtDia DATE) IS
/***********************************************************************************************
 Nombre : procrearegfactconc
 Desc   : Crea registro en factconc_sap
 Autor  : John Jimenez
 Fecha  : Junio 1 2007
 
 Historia de Modificaciones
 Autor  :  JRG
 Fecha  : febrero 26 2012
 Desc   : Se adiona un parametro mas donde se guarda la informacion del dia
***********************************************************************************************/
BEGIN
  INSERT INTO factconc_sap(
                       facodepa,facoloca,facoanoe,facomese,facoano,facomes,facoconc,facovlor,facogrup,facofunc, facodia
                      )
               VALUES(
                       nudepa,nuloca,nuanoe,numese,nuano,numes,nuconc,nuValor,nugrupo,nufunc,dtDia
                      );
END procrearegfactconc;


PROCEDURE ProProyIngFactFlujoCaja is
/***********************************************************************************************
 Nombre : ProProyIngFactFlujoCaja
 Desc   : obtiene el valor facturado por concepto y por periodo
 Autor  : Claudia Vellojin
 Fecha  : Mayo del 2007
 
 istoria de Modificaciones
 Autor  : JRG  
 Fecha  : febrero 26 2012
 Desc   : Se adiona un parametro mas de agrupamiento en las consultas y en las tablas
          donde se guarda la informacion del dia
***********************************************************************************************/
    mes          NUMBER;
    meseval      NUMBER;
    ano          NUMBER;
    anoeval      NUMBER;
    mes2         NUMBER;
    ano2         NUMBER;
    mesing       VARCHAR2(3);
    mesing2      VARCHAR2(3);
    dtfechinic   DATE;
    dtfechfini   DATE;
    dtfechinic2  DATE;
    dtfechfini2  DATE;
    dtfechdia    DATE;

--<<
-- se adiciono  to_char(cargfecr, 'DD/MM/YYYY') de mas para en el select y tambien se 
-- deja como criterio de agrupacion 
-->>
CURSOR cuCargos(dtFechI DATE,dtFechF DATE) IS
    SELECT /*+ index (cargos idxcargos11)*/ locadist cargdepa,locaagen cargloca,cargconc,
          SUM(decode(cargsign,'DB',nvl(cargvalo,0),nvl(-cargvalo,0))) SUMA, cargcate cate,
          to_char(cargfecr, 'DD/MM/YYYY')  dia
      FROM cargos,localida
     WHERE cargfecr >= dtFechI
       AND cargfecr <= dtFechF
       AND cargsign in ('DB','CR')
       AND cargserv = 1
       AND cargflfa = 'S'
       AND cargprog in ('OLEG','OMOD')
       AND cargdepa = locadepa
       AND cargloca = locacodi
      GROUP BY locadist,locaagen,cargconc,cargcate, to_char(cargfecr, 'DD/MM/YYYY')
    UNION ALL
    SELECT /*+ index (cargos idxcargos11)*/  locadist cargdepa,locaagen cargloca,cargconc,
           sum(decode(cargsign,'DB',nvl(cargvalo,0),nvl(-cargvalo,0))) SUMA,cargcate cate,
           to_char(cargfecr, 'DD/MM/YYYY')  dia 
      FROM cargos, cuencobr,localida
     WHERE cargfecr >= dtFechI
       AND cargfecr <= dtFechF
       AND cargsign IN ('DB','CR')
       AND cargserv = 1
       AND cargcuco <> -1
       AND cargflfa = 'S'
       AND cargdoso NOT LIKE 'ID%'
       AND cargdoso NOT LIKE 'SU%'
       AND cargprog = 'FGCA'
       AND cargcuco = cucocodi
       AND cargdepa = locadepa
       AND cargloca = locacodi
       AND cucofege >= dtFechI
       AND cucofege <= dtFechF
       --AND ROWNUM <= 5 
       GROUP BY locadist,locaagen,cargconc,cargcate, to_char(cargfecr, 'DD/MM/YYYY');

--<<
-- se adiciono to_char(cargfecr, 'DD/MM/YYYY') mas para en el select y tambien 
-- se deja como criterio de agrupacion 
-->>
CURSOR CUCARGOSINT(dtFechI DATE,dtFechF DATE) IS
   SELECT /*+ index (cargos idxcargos11)*/  locadist cargdepa,locaagen cargloca,cargconc,
          sum(decode(cargsign, 'DB', cargvalo, 'CR', -cargvalo, 0)) SUMA,cargcate cate,
          to_char(cargfecr, 'DD/MM/YYYY')  dia 
     FROM cargos, cuencobr,localida
    WHERE cargfecr >= dtFechI
      AND cargfecr <= dtFechF
      AND cargsign IN ('DB','CR')
      AND cargserv IN  (1,10,14)
      AND cargcuco = cucocodi
      AND cargcuco <> -1
      AND cargflfa = 'S'
      AND cargdoso LIKE 'ID%'
      AND cargdepa = locadepa
      AND cargloca = locacodi
      AND cucofege >= dtFechI
      AND cucofege <= dtFechF
      --AND ROWNUM <= 5 
      GROUP BY locadist,locaagen,cargconc,cargcate, to_char(cargfecr, 'DD/MM/YYYY');

BEGIN
    meseval:= numesrfc;
    anoeval:= nuanorfc;

    meseval:= 12;
    anoeval:= 2012;

    DELETE factconc_sap WHERE facoanoe = anoeval AND facomese = meseval AND facofunc = nufunc;
    DELETE peevflcj_sap WHERE pefcanoe = anoeval AND pefcmese = meseval AND pefctire = 'F' AND func = nufunc;

    IF meseval=1 THEN
        ano:=anoeval-1;
        mes:=11;
        ano2:=anoeval-1;
        mes2 := 12;
    ELSIF meseval=2 THEN
        ano:=anoeval-1;
        mes:=12;
        ano2:=anoeval;
        mes2 := 1;
    ELSE
        ano:=anoeval;
        mes:=meseval-2;
        ano2:=anoeval;
        mes2:=meseval-1;
    END IF;

  -- Generamos fecha inicial mes 1
  dtfechinic := TO_DATE('01/'||pkflujocaja_sap10.fsbmesletras(mes)||'/'||ano,'DD/MON/YYYY');

  -- Generamos fecha final mes 1
  SELECT last_day(dtfechinic) INTO dtfechfini FROM dual;

  -- Generamos fecha inicial mes 2
  dtfechinic2 := TO_DATE('01/'||pkflujocaja_sap10.fsbmesletras(mes2)||'/'||ano2,'DD/MON/YYYY');

  -- Generamos fecha final mes 2
  SELECT last_day(dtfechinic2) INTO dtfechfini2 FROM dual;
  
  -- Generamos valor facturado mes1

    FOR i IN cucargos(dtfechinic,dtfechfini) LOOP
        nugrupo := -1;
        IF i.cargconc = 25 AND i.cate = 3 THEN
            nugrupo := 3;
        ELSE
           BEGIN
               SELECT TFCONFLCJ INTO nugrupo
                 FROM tiflconc_sap
                WHERE TFCONCPTO =  i.cargconc;
           EXCEPTION
               WHEN no_data_found THEN
                   nugrupo := -1;
               WHEN too_many_rows THEN
                   RAISE_APPLICATION_ERROR(-20001,'El concepto : '||i.cargconc||' esta asociado a mas de un grupo.'||sqlerrm);
           END;
        END IF;
        IF nugrupo <> -1 THEN
           pkflujocaja_sap10.procrearegfactconc(i.cargdepa,i.cargloca,anoeval,meseval,ano,mes,i.cargconc,i.suma,nugrupo, i.dia);
        END IF;
    END LOOP;

    FOR i IN cucargosint(dtfechinic,dtfechfini) LOOP
       nugrupo := -1;
       IF i.cargconc = 25 AND i.cate = 3 THEN
         nugrupo := 3;
       ELSE
           BEGIN
               SELECT TFCONFLCJ INTO nugrupo
                 FROM tiflconc_sap
                WHERE TFCONCPTO =  i.cargconc;
           EXCEPTION
               WHEN no_data_found THEN
                   nugrupo := -1;
               WHEN too_many_rows THEN
                   RAISE_APPLICATION_ERROR(-20002,'El concepto : '||i.cargconc||' esta asociado a mas de un grupo.'||sqlerrm);
           END;
        END IF;
        IF nugrupo <> -1 THEN
           pkflujocaja_sap10.procrearegfactconc(i.cargdepa,i.cargloca,anoeval,meseval,ano,mes,i.cargconc,i.suma,nugrupo, i.dia);
        END IF;
    END LOOP;

  -- Generamos valor facturado mes2

    FOR i IN cucargos(dtfechinic2,dtfechfini2) LOOP
       nugrupo := -1;
       IF i.cargconc = 25 AND i.cate = 3 THEN
          nugrupo := 3;
       ELSE
           BEGIN
            SELECT TFCONFLCJ INTO nugrupo
                FROM tiflconc_sap
               WHERE TFCONCPTO =  i.cargconc;
           EXCEPTION
               WHEN no_data_found THEN
                   nugrupo := -1;
               WHEN too_many_rows THEN
                   RAISE_APPLICATION_ERROR(-20003,'El concepto : '||i.cargconc||' esta asociado a mas de un grupo.'||sqlerrm);
           END;
        END IF;
        IF nugrupo <> -1 THEN
            pkflujocaja_sap10.procrearegfactconc(i.cargdepa,i.cargloca,anoeval,meseval,ano2,mes2,i.cargconc,i.suma,nugrupo,i.dia);
        END IF;
    END LOOP;

    FOR i IN cucargosint(dtfechinic2,dtfechfini2) LOOP
       nugrupo := -1;
       IF i.cargconc = 25 AND i.cate = 3 THEN
           nugrupo := 3;
        ELSE
            BEGIN
                SELECT TFCONFLCJ INTO nugrupo
                  FROM tiflconc_sap
                 WHERE TFCONCPTO =  i.cargconc;
             EXCEPTION
                  WHEN no_data_found THEN
                      nugrupo := -1;
                  WHEN too_many_rows THEN
                      RAISE_APPLICATION_ERROR(-20004,'El concepto : '||i.cargconc||' esta asociado a mas de un grupo.'||sqlerrm);
           END;
        END IF;
        IF nugrupo <> -1 THEN
            pkflujocaja_sap10.procrearegfactconc(i.cargdepa,i.cargloca,anoeval,meseval,ano2,mes2,i.cargconc,i.suma,nugrupo, i.dia);
        END IF;
    END LOOP;
  
    --<<
    -- Debo Ingresar el campo de dia en la tabla peevflcj_sap
    -- se realiza un ciclo para recorrer el mes por dias
    -->>
  
    dtfechdia := dtfechinic;
  
    FOR i IN 1..to_char(dtfechfini, 'DD') LOOP 
        SELECT dtfechinic + i INTO dtfechdia FROM dual;
        INSERT INTO peevflcj_sap VALUES(anoeval,meseval,'P',nufunc, dtfechdia);
    END LOOP;
  
     
EXCEPTION
    WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20005,'Error en pkflujocaja_sap.ProProyIngFactFlujoCaja. '||SQLERRM);

END ProProyIngFactFlujoCaja;



PROCEDURE proypagosflucaja IS
/***********************************************************************************************
   Nombre : proypagosflucaja
   Desc   : obtiene el valor recaudado por cuenta de cobro por periodo de la tabla cargos
   Autor  : Claudia Vellojin
   Fecha  : Mayo del 2007
   
   Historia de Modificaciones
   Autor  : JRG  
   Fecha  : febrero 26 2012
   Desc   : Se adiona un parametro mas de agrupamiento en las consultas y en las tablas
            donde se guarda la informacion del dia
***********************************************************************************************/
    meseval         NUMBER;
    anoeval         NUMBER;
    nuano1          NUMBER(4);
    ano1            NUMBER;
    ano2            NUMBER;
    mes1            NUMBER;
    mes2            NUMBER;
    sumvafa         compreca_sap.corefact%type DEFAULT 0;
    sumrec1         compreca_sap.corereca%type DEFAULT 0;
    sumrec2         compreca_sap.corerec2%type DEFAULT 0;
    n               NUMBER;

    dtfechinic      DATE;
    dtfechfini      DATE;
    dtfechdia       DATE;
    --<<
    -- Se adiciona un campo mas para extraer de la consulta
    -- este campo es el dia cucofege (cuenta de cobro fecha generada)
    -->>

    CURSOR cuco(nuanocu NUMBER,numescu NUMBER) IS
      SELECT cucoano,cucomes,cucocodi,cucovato,cucovaab
        FROM cuencobr,servsusc
       WHERE cucoprog = 'FGCC'
         AND cucoano  = nuanocu
         AND cucomes  = numescu
         AND sesunuse = cuconuse
         AND sesuserv = 1
         AND cucovato > 0;

    CURSOR carg(cuco NUMBER) IS
       SELECT nvl(cargvalo,0) CARGVALO,cargano,cargmes
         FROM cargos
        WHERE cargcuco = cuco
          AND cargsign IN ('PA','SA')
          AND cargprog = 'FPLP';

BEGIN
  
    meseval   := numesrfc;
    anoeval   := nuanorfc;

    DELETE compreca_sap WHERE coreanoe = anoeval AND coremese = meseval AND corefunc = nufunc;
    DELETE peevflcj_sap WHERE pefcanoe = anoeval AND pefcmese = meseval AND pefctire = 'P' AND func = nufunc;

    ano1      := anoeval - 1;
    nuano1    := anoeval - 1;

    IF meseval=12 THEN
       ano1:=ano1+1;
       mes1:=1;
       mes2:=2;
       ano2:=ano1;
    ELSIF meseval=11 THEN
  --    ano1:=anoeval;
       mes1:=12;
       ano2:=ano1+1;
       mes2:=1;
    ELSE
  --     ano1:=anoeval;
       mes1:=meseval+1;
       mes2:=meseval+2;
       ano2:=ano1;
    END IF;

    -- Calculamos el facturado del mes evaluado
    FOR c1 IN cuco(nuano1,meseval) LOOP
        sumvafa := nvl(sumvafa,0) + nvl(c1.cucovato,0);
        -- Calculamos lo recaudado 1 y 2 meses despues
        FOR a1 IN carg(c1.cucocodi) LOOP
            n:=(a1.cargano*12+a1.cargmes-1)-(c1.cucoano*12+c1.cucomes);
            IF n=0 THEN
                sumrec1 := nvl(sumrec1,0) + nvl(a1.cargvalo,0);
            ELSE
                sumrec2 := nvl(sumrec2,0) + nvl(a1.cargvalo,0);
            END IF;
         END LOOP;
     END LOOP;
     
     --<<
     -- Se genera la fecha inicial y final para que este proceso se muestre por dias y no por mes
     -->>
      dtfechinic := TO_DATE('01/'||pkflujocaja_sap10.fsbmesletras(meseval)||'/'||anoeval,'DD/MON/YYYY');
      SELECT last_day(dtfechinic) INTO dtfechfini FROM dual;
      dtfechdia := dtfechinic;
      
      FOR i IN 1..to_char(last_day(dtfechdia), 'DD') LOOP 
        
          INSERT INTO compreca_sap(
                                   coreanoe,coremese,coreano,coremes,coremes1,
                                   coreano1,coremes2,coreano2,corefact,corereca,
                                   corerec2,corefunc, corediae
                                   )
                             VALUES(
                                   anoeval,meseval,nuano1,meseval,mes1,ano1,mes2,
                                   ano2,sumvafa,sumrec1,sumrec2,nufunc,dtfechinic
                                  );

          INSERT INTO peevflcj_sap VALUES(anoeval,meseval,'P',nufunc, dtfechinic);
          
          SELECT dtfechinic + i INTO dtfechdia FROM dual;
     END LOOP;
    

   
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20006,'Error en pkflujocaja_sap.proypagosflucaja. '||SQLERRM);

END proypagosflucaja;

PROCEDURE ProProyRecaFlujoCaja is
/***********************************************************************************************
   Nombre : proypagosflucaja
   Desc   : obtiene el valor recaudado por cuenta de cobro por SEMANA
   Autor  : Claudia Vellojin
   Fecha  : Mayo del 2007
   
   Historia de Modificaciones
   Autor  : JRG  
   Fecha  : febrero 26 2012
   Desc   : Obtiene el valor recaudado por cuenta de cobro por DIA
***********************************************************************************************/
    meseval        NUMBER;
    anoeval        NUMBER;
    ano1           NUMBER;
    ano2           NUMBER;
    mes1           NUMBER;
    mes2           NUMBER;
    mes1letras     VARCHAR2(3);
    dtFechInic1    DATE;
    periodo1fini   VARCHAR2(20);
    dtFechF1       DATE;
    periodo2inici  VARCHAR2(20);
    dtFechInic2    DATE;
    periodo2fini   VARCHAR2(20);
    dtFechF2       DATE;
    recames1       movicuba_sap.MVCBVLOR%type;
    recames2       movicuba_sap.MVCBVLOR%type;
    /*sem1inicmes1   DATE;
    sem2inicmes1   DATE;
    sem3inicmes1   DATE;
    sem4inicmes1   DATE;
    sem1finmes1    DATE;
    sem2finmes1    DATE;
    sem3finmes1    DATE;
    sem4finmes1    DATE;
    recames1sem1   movicuba_sap.MVCBVLOR%type;
    recames1sem2   movicuba_sap.MVCBVLOR%type;
    recames1sem3   movicuba_sap.MVCBVLOR%type;
    recames1sem4   movicuba_sap.MVCBVLOR%type;
    porcsem1mes1   recaproy_sap.reprs1m1%type;
    porcsem2mes1   recaproy_sap.reprs2m1%type;
    porcsem3mes1   recaproy_sap.reprs3m1%type;
    porcsem4mes1   recaproy_sap.reprs4m1%type;*/

    --<<
    -- JRG variables agregadas
    -->>
    recames1dia   movicuba_sap.MVCBVLOR%type;
    porcdiames1   recaproy_sap.reprdiapm%type;
    diainicmes1   DATE;
    diafinmes1    DATE;
    dtdiafech     DATE;

BEGIN
    anoeval   := nuanorfc;
    meseval   := numesrfc;

    DELETE recaproy_sap WHERE repranoe = anoeval ANd reprmese = meseval AND reprfunc = nufunc;
    DELETE peevflcj_sap WHERE pefcanoe = anoeval AND pefcmese = meseval AND pefctire = 'R' AND func = nufunc;

    mes1      := numesrfc;
    ano1      := nuanorfc - 1;

    mes1letras := pkflujocaja_sap10.fsbmesletras(mes1);
    dtFechInic1 := to_date('01/'||mes1letras||'/'||to_char(ano1),'DD/MON/YYYY');
    dtFechInic1 := to_char(dtFechInic1, 'DD/MM/YYYY');

    SELECT last_day(dtFechInic1) INTO periodo1fini FROM dual;
    dtFechF1 := to_date(periodo1fini,'DD/MM/YYYY');

     
    SELECT nvl(sum(nvl(MVCBVLOR,0)),0) INTO recames1
      FROM movicuba_sap
     WHERE mvcbtimv in (313,334,1069,994)
       AND to_char(mvcbfeapl, 'DD/MM/YYYY') >= to_char(dtFechInic1, 'DD/MM/YYYY')
       AND to_char(mvcbfeapl, 'DD/MM/YYYY') <= to_char(dtFechF1, 'DD/MM/YYYY');

     IF recames1 = 0 THEN
         recames1 := 1;
     END IF;
     
    --averiguar recaudo por semana en mes1
    --<<
    -- averiguar el recaudo por dia en mes1
    -->>

     dtdiafech := dtFechInic1;
     
     FOR i IN 1..to_char(last_day(dtFechInic1), 'DD') LOOP 
         SELECT nvl(sum(nvl(MVCBVLOR,0)),0) INTO recames1dia
           FROM movicuba_sap
          WHERE mvcbtimv in (313,334,1069,994)
            AND to_char(mvcbfeapl, 'DD') = to_char(dtdiafech, 'DD');
          
          --<<
          -- Sacar el porcentaja de un dia,con respecto a todo el mes
          -->>
          
          --porcdiames1:=round( (recames1dia/recames1)*100,1);
          porcdiames1:=trunc( (recames1dia/recames1)*100,1);
          
          dbms_output.put_line(i || '. porcdiames1: ' || porcdiames1 || '   recames1dia: ' || recames1dia ||
                               '   recames1: ' || recames1);
    
        
          --<<
          -- modificar la tabla recaproy_sap
          -- agregar el campo reprdiae, reprdiapm
          -- eliminar el campo reprs1m1, reprs2m1, reprs3m1, reprs4m1
          -->>
          
          INSERT INTO recaproy_sap(
                             repranoe,reprmese,reprmes,reprano,reprfunc, reprdiapm, reprdiae
                            )
                      VALUES(
                             anoeval,meseval,mes1,ano1,nufunc,porcdiames1, dtdiafech
                            );
          
          INSERT INTO peevflcj_sap VALUES(anoeval,meseval,'R',nufunc, dtdiafech);
         
          SELECT dtFechInic1 + i INTO dtdiafech FROM dual;
      END LOOP;
        
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20007,'Error en pkflujocaja_sap.ProProyRecaFlujoCaja. '||SQLERRM);

END ProProyRecaFlujoCaja;



PROCEDURE proconsvalrealingcarg IS
/************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS . (C) 2007
  FUNCION        : proconsvalrealing
  AUTOR          : John Jairo Jimenez Marimon
  FECHA          : Mayo 26 del 2007
  DESCRIPCION    : Calcula el valor real del recaudo por grupo cargos

  Parametros de Entrada
   dtfechaini  DATE
   dtfechafin  DATE
   nugrupoconc NUMBER
  Parametros de Salida
  
  Historia de Modificaciones
   Autor  : JRG
   Fecha  : Febrero 26 2012
   Desc   : Se averiguar recaudo por dia y no por semana en mes1
*************************************************************************/
    nuvalor  NUMBER(13,2);

      -- Consultamos el valor de los cargos
      --<<
      -- Se agrego un campo para el criterio de seleccion y de agrupamiento 
      -- /* + rule */ tal vez sea importante pensar en como hacerle afinamiento a la consulta
      -- ya que se esta demorando mucho
      -->>
      
    CURSOR cuCargreal(dtfechainiP DATE,dtfechafinP DATE) IS
      SELECT locadist depa,locaagen loca,depaconc concepto,nvl(sum(depavalo),0) valor,depacate cate,
             to_char(depafecr, 'DD/MM/YYYY') dia
        FROM detapago,localida
       WHERE depafecr BETWEEN dtfechainip AND dtfechafinp
         AND depacuco <> -1
         AND depadepa = locadepa
         AND depaloca = locacodi
       GROUP BY locadist,locaagen,depaconc,depacate, to_char(depafecr, 'DD/MM/YYYY');

    dtfechaini DATE;
    dtfechafin DATE;
    numes NUMBER;
 
BEGIN
  
    DELETE inreflcj_sap WHERE ano = nuanorfc AND mes = numesrfc AND func = nufunc;
    -- Obtenemos el valor de los cargos
    dtfechaini := to_date('01/'||fsbmesletras(numesrfc)||'/'||nuanorfc,'DD/MON/YYYY');
    
    SELECT last_day(dtfechaini) INTO dtfechafin FROM dual;
    
    --<<
    -- JRG Se modificaron los formatos de fehca de (MM/DD/YYYY) a (MM/DD/YY)
    -- para la busqueda en el cursor
    -->>
      
    dtfechaini := to_date(dtfechaini,'DD/MM/YY');  
    dtfechafin := to_date(dtfechafin,'DD/MM/YY');
    
    FOR i IN cuCargreal(dtfechaini,dtfechafin) LOOP
        nugrupo := -1;
        IF i.concepto = 25 AND i.cate = 3 THEN
            nugrupo := 3;
        ELSE
            BEGIN
                SELECT TFCONFLCJ INTO nugrupo
                  FROM tiflconc_sap
                 WHERE TFCONCPTO =  i.concepto;
            EXCEPTION
                WHEN no_data_found THEN
                    nugrupo := -1;
                WHEN too_many_rows THEN
                    RAISE_APPLICATION_ERROR(-20008,'El concepto : '||i.concepto||' esta asociado a mas de un grupo.'||sqlerrm);
            END;
       END IF;
       IF nugrupo <> -1 THEN
           --<<
           -- Agrega el dia a la tabla inreflcj_sap
           -->>
           INSERT INTO inreflcj_sap(depa,loca,ano,mes,grupo,concep,valor,func, dia)
                  VALUES(i.depa,i.loca,nuanorfc,numesrfc,nugrupo,i.concepto,i.valor,nufunc,i.dia);
        END IF;
    END LOOP;
END proconsvalrealingcarg;



PROCEDURE procarginreal(nuanoe NUMBER,numese NUMBER, dtdiae DATE) IS
 /************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS . (C) 2007
  FUNCION        : procarginreal
  AUTOR          : John Jairo Jimenez Marimon
  FECHA          : Mayo 26 del 2007
  DESCRIPCION    : Llena la table tereflcj_sap con los ingresos reales

  Parametros de Entrada
   dtfechaini  DATE
   dtfechafin  DATE
   nugrupoconc NUMBER
  Parametros de Salida
  
  Historia de Modificaciones
  Autor   Fecha         Descripcion
 *************************************************************************/

    CURSOR cuCargreal IS
        SELECT depa,loca,ano,mes,grupo,concep,nvl(SUM(valor),0) valor, dia
          FROM inreflcj_sap
         WHERE ano = nuanoe
           AND mes = numese
           AND func = nufunc
           --<<
           --
           -->>
           AND to_char(dia, 'DD/MM/YYYY') = to_char(dtdiae, 'DD/MM/YYYY')
         GROUP BY depa,loca,ano,mes,grupo,concep, dia;
 
 BEGIN
   
    FOR i IN cuCargreal LOOP
        UPDATE tereflcj_sap
           SET trfcrvca = nvl(trfcrvca,0) + i.valor
         WHERE trfcdepa = i.depa
           AND trfcloca = i.loca
           AND trfcanoe = i.ano
           AND trfcmese = i.mes
           AND trfcgrup = i.grupo
           AND trfcconc = i.concep
           AND trfcfltr = 'I'
           AND trfctipo = 'C'
           --<<
           --
           -->>
           AND trfcdiae = i.dia;
           
        IF sql%notfound THEN
            INSERT INTO tereflcj_sap(trfcdepa,trfcloca,trfcanoe,trfcmese,trfcgrup,trfcconc,trfcfltr,trfcrvca,trfctipo,trfcfunc, trfcdiae)
                  VALUES(i.depa,i.loca,i.ano,i.mes,i.grupo,i.concep,'I',i.valor,'C',nufunc, i.dia);
     END IF;

    END LOOP;
    
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error: '||SQLERRM||'-'||DBMS_UTILITY.format_error_backtrace);   
 
END procarginreal;



PROCEDURE proconsvalrealingtipmov IS
 /************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS . (C) 2007
  FUNCION        : proconsvalrealing
  AUTOR          : John Jairo Jimenez Marimon
  FECHA          : Mayo 26 del 2007
  DESCRIPCION    : Calcula el valor real del recaudo por grupo tipos de movimientos

  Parametros de Entrada
   dtfechaini  DATE
   dtfechafin  DATE
   nugrupoconc NUMBER
  Parametros de Salida
  
  Historia de Modificaciones
   Autor  : JRG  
   Fecha  : febrero 26 2012
   Desc   : Calcula el valor real del recaudo por grupo tipos de movimientos
            y dias
 *************************************************************************/
    nuvalor  NUMBER(13,2);


      --<<
      --- Se adiciona un campo (dia) de mas para trae de la consulta
      -->>
    CURSOR cuTipMovReal(dtfechainiP DATE,dtfechafinP DATE) IS
        SELECT mvcbdage depa,
               mvcbagen loca,
               fctmcdgo grupo,
               mvcbtimv tipo_movim,
               fctmineg ineg,
               mvcbdist,
               mvcbcons,
               mvcbdisa,
               mvcbtmad,
               mvcbcasi,
               nvl(SUM(mvcbvlor),0) nuvalor, 
               to_char(mvcbfech, 'DD/MM/YYYY') dia
          FROM movicuba_sap,flcjtipmov_sap,tipmovflcja_sap /*movicuba,flcjtipmov,tipmovflcja*/
         WHERE mvcbfeapl BETWEEN dtfechainip AND dtfechafinp
           AND mvcbesta IN(1,2,6)
           AND mvcbtimv = fctmcdtm
           AND fctmcdgo = tmfccdgo
           AND tmfcineg = 'I'
      GROUP BY mvcbdage,mvcbagen,fctmcdgo,mvcbtimv,fctmineg,mvcbdist,mvcbcons,mvcbdisa,mvcbtmad,mvcbcasi,
              to_char(mvcbfech, 'DD/MM/YYYY');

    dtfechaini DATE;
    dtfechafin DATE;
    numes      NUMBER;
    a1         NUMBER;
    b          NUMBER;
    c1         NUMBER;
    d          NUMBER;
    e          NUMBER;
    f          NUMBER;
 
BEGIN


    DELETE ctabflcj_sap WHERE ano = nuanorfc AND mes = numesrfc AND func = nufunc;

    -- Obtenemos el valor de los cargos
    dtfechaini := to_char(to_date('01/'||PKFLUJOCAJA_SAP10.fsbmesletras(numesrfc)||'/'||nuanorfc,'DD/MM/YY'), 'DD/MM/YY');
    SELECT last_day(dtfechaini) INTO dtfechafin    FROM dual;
    
    dtfechafin  := to_char(to_date(dtfechafin,'DD/MM/YY'), 'DD/MM/YY');
   
    --<<
    -- agregar campo dia a la tabla ctabflcj_sap
    -->>
    FOR i IN cuTipMovReal(dtfechaini,dtfechafin) LOOP
        INSERT INTO ctabflcj_sap(DEPA,LOCA,ano,mes,GRUPO,TIPMOV,DISTC,CONSC,DISA,TMAD,CASI,VALOR,tipo,func, dia)
               VALUES(i.depa,i.loca,nuanorfc,numesrfc,i.grupo,i.tipo_movim,i.MVCBDIST,i.MVCBCONS,i.MVCBDISA,i.MVCBTMAD,i.MVCBCASI,i.nuvalor,i.ineg,nufunc, i.dia);
       
        a1 := i.depa;
        b := i.loca;
        c1 := i.grupo;
        d := i.tipo_movim;
        e := i.MVCBDIST;
        f := i.MVCBCONS;
    END LOOP;
     
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        NULL;
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20009,'Error al insertar en ctabflcj_sap. Dpto : '||a1||' Loc. : '||b||' Grupo : '||c1||'Tip. Mov : '||d||' Cta. banc : '||e||'-'||f||' '||SQLERRM);

END proconsvalrealingtipmov;


PROCEDURE procarginrealtipmov(nuanoe NUMBER,numese NUMBER, dtdiafech DATE) IS
 /************************************************************************
  PROPIEDAD INTELECTUAL DE SURTIGAS . (C) 2007
  FUNCION        : procarginrealtipmov
  AUTOR          : John Jairo Jimenez Marimon
  FECHA          : Mayo 26 del 2007
  DESCRIPCION    : Llena la table tereflcj_sap con los ingresos reales de cta bancarias

  Parametros de Entrada
   dtfechaini  DATE
   dtfechafin  DATE
   nugrupoconc NUMBER
  Parametros de Salida
  
  Historia de Modificaciones
   Autor  : JRG  
   Fecha  : febrero 26 2012
   Desc   : Llena la table tereflcj_sap con los ingresos reales de cta bancarias por dias
   
 *************************************************************************/

    -- Consultamos el valor de los tipos de movimientos
    
  --<<
  -- Adicionamos un campo mas al select y al order bye
  -->>  
  CURSOR cuCargreal IS
    SELECT depa,loca,ano,mes,grupo,tipmov,tipo,nvl(sum(valor),0) nuvalor, dia dia
      FROM ctabflcj_sap
     WHERE ano = nuanoe
       AND mes = numese
       AND to_char(dia, 'DD/MM/YYYY') = to_char(dtdiafech, 'DD/MM/YYYY')
       AND func = nufunc
  GROUP BY depa,loca,ano,mes,grupo,tipmov,tipo, dia;

 BEGIN
   FOR i IN cuCargreal LOOP
      UPDATE tereflcj_sap
      SET trfcrvtm = nvl(trfcrvtm,0) + i.nuvalor
    WHERE trfcdepa = i.depa
      AND trfcloca = i.loca
      AND trfcanoe = i.ano
      AND trfcmese = i.mes
      AND trfcgrup = i.grupo
      AND trfcconc = i.tipmov
      AND trfcfltr = 'I'
      AND trfctipo = i.tipo
      AND trfcfunc = nufunc
      --<<
      --
      -->>
      AND trfcdiae = i.dia
      ;
    IF sql%notfound THEN
     INSERT INTO tereflcj_sap(trfcdepa,trfcloca,trfcanoe,trfcmese,trfcgrup,trfcconc,trfcfltr,trfcrvtm,trfctipo,trfcfunc, trfcdiae)
                  VALUES(i.depa,i.loca,i.ano,i.mes,i.grupo,i.tipmov,'I',i.nuvalor,i.tipo,nufunc, i.dia);
    END IF;

  END LOOP;
END procarginrealtipmov;


PROCEDURE progeningreflcj IS
/************************************************************************
 PROPIEDAD INTELECTUAL DE SURTIGAS . (C) 2007
 PROCEDIMIENTO  : progeningreflcj
 AUTOR          : John Jairo Jimenez Marimon
 FECHA          : Mayo 26 del 2007
 DESCRIPCION    : Genera los ingresos para flujo de caja

Parametros de Entrada
Parametros de Salida
Historia de Modificaciones
Autor   Fecha         Descripcion
************************************************************************/
     nuanoeval        NUMBER(4);
     numeseval        NUMBER(2);
     facturado        compreca_sap.corefact%TYPE;
     facturado2       compreca_sap.corefact%TYPE;
     recaudado        compreca_sap.corereca%TYPE;
     recaudado2       compreca_sap.corereca%TYPE;
     nuanoant         NUMBER(4);
     numesant         NUMBER(2);
     nuPorcrecames1   NUMBER(13,2) DEFAULT 0;
     nuPorcrecames2   NUMBER(13,2) DEFAULT 0;
     porcs1m1         NUMBER(13,2) DEFAULT 0;
     porcs2m1         NUMBER(13,2) DEFAULT 0;
     porcs3m1         NUMBER(13,2) DEFAULT 0;
     porcs4m1         NUMBER(13,2) DEFAULT 0;
     nuano1           NUMBER(4);
     numes1           NUMBER(2);
     nuano2           NUMBER(4);
     numes2           NUMBER(2);
     nuvalfact        NUMBER(18,2);
     nuvalfact2       NUMBER(18,2);
     s1m1r            NUMBER(18,4) DEFAULT 0;
     s2m1r            NUMBER(18,4) DEFAULT 0;
     s3m1r            NUMBER(18,4) DEFAULT 0;
     s4m1r            NUMBER(18,4) DEFAULT 0;
     nugrupo          tiflconc_sap.tfconflcj%TYPE;
     valors1m1        NUMBER(18,2);
     valors2m1        NUMBER(18,2);
     valors3m1        NUMBER(18,2);
     valors4m1        NUMBER(18,2);
     nudepa           localida.locadepa%type;
     nuloca           localida.locacodi%type;
     nuconc           concepto.conccodi%type;
     nuvalora         NUMBER(18,2);


     CURSOR cuGrupo(ano NUMBER,mes NUMBER) IS
      SELECT facogrup grupo,facoconc concepto
        FROM factconc_sap
       WHERE facoanoe  = ano
         AND facomese  = mes
         AND facofunc  = nufunc
         --AND facodia   = dia
       GROUP BY facogrup,facoconc
       ORDER BY facogrup,facoconc;

    -- Consultamos lo facturado para el mes

     CURSOR cuFacturado(ano NUMBER,mes NUMBER,anoe NUMBER,mese NUMBER,nugrupo NUMBER,nudepa NUMBER,nuloca NUMBER,nuconcep NUMBER) IS
      SELECT facodepa depa,facoloca loca,facoconc concepto,NVL(SUM(facovlor),0) valor
        FROM factconc_sap
       WHERE facogrup = nugrupo
         AND facoconc = nuconcep
         AND facoano   = ano
         AND facomes   = mes
         AND facoanoe  = anoe
         AND facomese  = mese
         AND facodepa  = nudepa
         AND facoloca  = nuloca
         AND facofunc  = nufunc
    GROUP BY facodepa,facoloca,facoconc,facoano,facomes,facoanoe,facomese;
    --   UNION ALL
    --   SELECT facodepa depa,facoloca loca,facoconc concepto,NVL(SUM(facovlor),0) valor
    --    FROM factconc_sap@LIN_SUCRE
    --   WHERE facogrup  = nugrupo
    --     AND facoconc  = nuconcep
    --     AND facoano   = ano
    --     AND facomes   = mes
    --     AND facoanoe  = anoe
    --     AND facomese  = mese
    --     AND facodepa  = nudepa
    --     AND facoloca  = nuloca
    --     AND facofunc  = nufunc
    --  GROUP BY facodepa,facoloca,facoconc,facoano,facomes,facoanoe,facomese
    --   UNION ALL
    --   SELECT facodepa depa,facoloca loca,facoconc concepto,NVL(SUM(facovlor),0) valor
    --    FROM factconc_sap@LIN_CORDOBA
    --   WHERE facogrup = nugrupo
    --     AND facoconc = nuconcep
    --     AND facoano   = ano
    --     AND facomes   = mes
    --     AND facoanoe  = anoe
    --     AND facomese  = mese
    --     AND facodepa  = nudepa
    --    AND facoloca  = nuloca
    --     AND facofunc  = nufunc
    --  GROUP BY facodepa,facoloca,facoconc,facoano,facomes,facoanoe,facomese;
     -- ORDER BY depa,loca,concepto,facoano,facomes,tfconflcj;

    --  Consultamos lo recaudado del primer mes en el mes y a?o anterior al evaluado

      CURSOR curecaprimMes(anoante NUMBER,mesante NUMBER) IS
        SELECT SUM(x.fact),SUM(x.rec2),x.ano,x.mes
          FROM(SELECT nvl(corefact,0) fact,nvl(corerec2,0) rec2,coreano ano,coremes mes
                 FROM compreca_sap
                WHERE coreano2 = anoante
                  AND coremes2 = mesante
                  AND corefunc = nufunc
       /*       UNION ALL
               SELECT nvl(corefact,0) fact,nvl(corerec2,0) rec2,coreano ano,coremes mes
                 FROM compreca_sap@LIN_SUCRE
                WHERE coreano2 = anoante
                  AND coremes2 = mesante
                  AND corefunc = nufunc
              UNION ALL
               SELECT nvl(corefact,0) fact,nvl(corerec2,0) rec2,coreano ano,coremes mes
                 FROM compreca_sap@LIN_CORDOBA
                WHERE coreano2 = anoante
                  AND coremes2 = mesante
                  AND corefunc = nufunc  */
                  ) X
            GROUP BY x.ano,x.mes; 

     -- Consultamos lo recaudado del segundo mes en el mes y a?o anterior al evaluado

      CURSOR curecaSegMes(anoante NUMBER,mesante NUMBER) IS
        SELECT SUM(y.fact),SUM(y.rec),y.ano,y.mes
          FROM(SELECT nvl(corefact,0) fact,nvl(corereca,0) rec,coreano ano,coremes mes
                 FROM compreca_sap
                WHERE coreano1 = anoante
                  AND coremes1 = mesante
                  AND corefunc = nufunc
           /*    UNION ALL
               SELECT nvl(corefact,0) fact,nvl(corereca,0) rec,coreano ano,coremes mes
                 FROM compreca_sap@LIN_SUCRE
                WHERE coreano1 = anoante
                  AND coremes1 = mesante
                  AND corefunc = nufunc
                  AND corefunc = nufunc
               UNION ALL
               SELECT nvl(corefact,0) fact,nvl(corereca,0) rec,coreano ano,coremes mes
                 FROM compreca_sap@LIN_CORDOBA
                WHERE coreano1 = anoante
                  AND coremes1 = mesante
                  AND corefunc = nufunc */) y
            GROUP BY y.ano,y.mes;

    --dtdiaeval DATE;
    porcdiam1      NUMBER;
    --nuanoant       NUMBER(4);
    --numesant       NUMBER(2); 
    dtdiaant       DATE;
    dtdiaeval      DATE:='03/12/2012';
    diam1r         NUMBER(18,4) DEFAULT 0;
    
    dtfechinic     DATE;
    dtdiafech      DATE;
    
    nuCountTemp    NUMBER:=0;


 BEGIN
  
    nuanoeval := nuanorfc;
    numeseval := numesrfc;
    
    -- Generamos fecha inicial mes 1
    dtfechinic := TO_DATE('01/'||pkflujocaja_sap10.fsbmesletras(numeseval)||'/'||nuanoeval,'DD/MON/YYYY');

    -- Generamos fecha final mes 1
--    SELECT last_day(dtfechinic) INTO dtfechfini FROM dual;


    -- Se borran los registros para el a?o y mes a evaluar
    DELETE tereflcj_sap WHERE trfcanoe = nuanoeval AND trfcmese = numeseval AND trfcfunc = nufunc;

    -- Consulta ano y mes anterior al evaluado
    BEGIN
        SELECT coreano,coremes/*,corediae*/ INTO nuanoant,numesant/*,dtdiaant*/
          FROM compreca
         WHERE coreanoe = nuanoeval
           AND coremese = numeseval
           --AND corediae = dtfechinic
           AND corefunc = nufunc;
    EXCEPTION
        WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20010,'Error al consultar el ano y mes anterior al evaluado en pkflujocaja_sap.progeningreflcj. '||SQLERRM);
    END;

    -- Obtenemos lo recaudado del primer mes en el mes y a?o anterior al evaluado
    OPEN curecaprimMes(nuanoant,numesant);
    FETCH curecaprimMes INTO facturado2,recaudado2,nuano1,numes1;
        IF curecaprimMes%NOTFOUND THEN
            CLOSE curecaprimMes;
            RAISE_APPLICATION_ERROR(-20011,'Se requiere lo recaudado del primer mes para el periodo evaluado. '||to_char(nuanoeval)||' - '||to_char(numeseval)||' pkflujocaja_sap.progeningreflcj. '||SQLERRM);
        END IF;
    CLOSE curecaprimMes;

 -- Obtenemos lo recaudado del segundo mes en el mes y a?o anterior al evaluado
     OPEN curecaSegMes(nuanoant,numesant);
     FETCH curecaSegMes INTO facturado,recaudado,nuano2,numes2;
         IF curecaSegMes%NOTFOUND THEN
             CLOSE curecaprimMes;
             RAISE_APPLICATION_ERROR(-20012,'Se requiere lo recaudado del segundo mes para el periodo evaluado. '||to_char(nuanoeval)||' - '||to_char(numeseval)||' pkflujocaja_sap.progeningreflcj. '||SQLERRM);
         END IF;
     CLOSE curecaSegMes;

 -- Calculamos el porcentaje de recaudo del 1er mes
    IF facturado2 <> 0 THEN
        nuPorcrecames1  := (recaudado2/facturado2);
    ELSE
        nuPorcrecames1 := 0;
    END IF;

 -- Calculamos el porcentaje de recaudo del 2do mes
    IF facturado <> 0 THEN
        nuPorcrecames2  := (recaudado/facturado);
    ELSE
        nuPorcrecames2  := 0;
    END IF;

 -- Consultamos el porcentaje de recaudo por dia
/*    BEGIN
        SELECT NVL(reprdiapm,0)/100 INTO porcdiam1
          FROM recaproy_sap
         WHERE repranoe = nuanoeval
           AND reprmese = numeseval
           AND to_char(reprdiae, 'DD') = to_char(dtdiaeval, 'DD')
           AND reprfunc = nufunc;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20013,'Error al consultar el porcentaje de recaudo por semana del primer mes en pkflujocaja_sap.progeningreflcj. '||SQLERRM);
    END;*/

 -- Generamos los ingresos
    FOR i IN cuGrupo(nuanoeval,numeseval) LOOP
        FOR j IN (SELECT locadist locadepa,locaagen locacodi 
                    FROM localida 
                   GROUP BY locadist,locaagen 
                   ORDER BY locadepa,locacodi) LOOP
             
   -- Valor Facturado 1mes
            OPEN cuFacturado(nuano1+1,numes1,nuanoeval,numeseval,i.grupo,j.locadepa,j.locacodi,i.concepto);
            FETCH cuFacturado INTO nudepa,nuloca,nuconc,nuvalfact;
                IF cuFacturado%NOTFOUND THEN
                    nuvalfact := 0;
                END IF;
            CLOSE cuFacturado;

    -- Valor Facturado 2mes

            OPEN cuFacturado(nuano2+1,numes2,nuanoeval,numeseval,i.grupo,j.locadepa,j.locacodi,i.concepto);
            FETCH cuFacturado INTO nudepa,nuloca,nuconc,nuvalfact2;
                IF cuFacturado%NOTFOUND THEN
                   nuvalfact2 := 0;
                END IF;
             CLOSE cuFacturado;

       -- Generamos los ingresos proyectados por dia

             nugrupo := i.grupo;
             
             
             dtdiafech := dtfechinic;
             
             FOR contador IN 1..to_char(last_day(dtfechinic), 'DD') LOOP 
             
                 BEGIN
                      SELECT NVL(reprdiapm,0)/100 INTO porcdiam1
                        FROM recaproy_sap
                       WHERE repranoe = nuanoeval
                         AND reprmese = numeseval
                         AND to_char(reprdiae, 'DD') = to_char(dtdiafech, 'DD')
                         AND reprfunc = nufunc;
                  EXCEPTION
                      WHEN OTHERS THEN
                          RAISE_APPLICATION_ERROR(-20013,'Error al consultar el porcentaje de recaudo por semana del primer mes en pkflujocaja_sap.progeningreflcj. '||SQLERRM);
                  END;    
             -- Calculamos valor proyectado dia
    --
                 diam1r   := TRUNC((nuvalfact * nuPorcrecames1 * porcdiam1) + (nuvalfact2 * nuPorcrecames2 * porcdiam1),2);
                 

            -- Se graban los datos en la tabla
          
                 BEGIN
                     IF (diam1r IS NOT NULL AND diam1r <> 0)  THEN
                         
                         nuCountTemp := nuCountTemp + 1;
                         
/*                         IF nuCountTemp < 20 THEN
                             dbms_output.put_line('diam1r: ' || diam1r || ' = nuvalfact: ' || nuvalfact || 
                                                  '  nuPorcrecames1: ' || nuPorcrecames1 || '  porcdiam1: ' || 
                                                  porcdiam1 || '  nuvalfact2:  ' || nuvalfact2 || '  nuPorcrecames2: ' || nuPorcrecames2);
                         END IF;*/
                  
                     
                         INSERT INTO tereflcj_sap(
                                         trfcgrup,trfcanoe,trfcmese,trfcdepa,trfcloca,
                                         trfcconc,trfcfltr,trfctipo,trfcfunc, trfcdiae, 
                                         trfcdiapm
                                         )
                                  values (
                                          nugrupo,nuanoeval,numeseval,j.locadepa,j.locacodi,
                                          i.concepto,'I','C',nufunc, dtdiafech, nvl(diam1r,0)
                                         );
                     END IF;
                 EXCEPTION
                     WHEN OTHERS THEN
                         RAISE_APPLICATION_ERROR(-20014,'1Error al insertar en tereflcj_sap desde pkflujocaja_sap.progeningreflcj. Agencia : '||j.locadepa||'-'||j.locacodi||' grupo '||nugrupo||' concepto '||i.concepto||' '||SQLERRM);
                 END;
                 
                 SELECT dtfechinic + contador INTO dtdiafech FROM dual;
                 
             END LOOP;
--           
        END LOOP;
    END LOOP;

  -- Se registran los ingresos reales
--

    dtdiafech := dtfechinic;
    FOR contador IN 1..to_char(last_day(dtfechinic), 'DD') LOOP 
    
    --dbms_output.put_line(contador || '.');
    
        pkflujocaja_sap10.procarginreal(nuanoeval,numeseval,dtdiafech);
        pkflujocaja_sap10.procarginrealtipmov(nuanoeval,numeseval,dtdiafech);

        
        DELETE valogrup_sap  WHERE VAGRanoe = nuanoeval AND VAGRmese =  numeseval 
               AND to_char(VAGRdiae, 'DD/MM/YYYY') = to_char(dtdiafech, 'DD/MM/YYYY');

        FOR i IN (SELECT trfcdepa depa,trfcloca loca,trfcgrup grup,
                         SUM(trfcdiapm) suma,
                         SUM(trfcrvca) care,
                         SUM(trfcrvtm) tm, 
                         to_char(trfcdiae, 'DD/MM/YYYY') dia 
                    FROM tereflcj_sap 
                   WHERE trfcanoe = nuanoeval 
                     AND trfcmese = numeseval 
                    --<<
                    --
                    -->>
                     AND to_char(trfcdiae, 'DD/MM/YYYY') = to_char(dtdiafech, 'DD/MM/YYYY')
                     AND trfcfltr = 'I' 
                     AND trfctipo IN('C','I') 
                     AND trfcfunc = nufunc 
                   GROUP BY trfcdepa,trfcloca,trfcgrup, to_char(trfcdiae, 'DD/MM/YYYY')) LOOP
            BEGIN
                --SELECT NVL(SUM(trfcrvtm),0) INTO nuvalora
                SELECT NVL(SUM(trfcdiapm),0) INTO nuvalora
                  FROM tereflcj_sap
                 WHERE trfcdepa = i.depa
                   AND trfcloca = i.loca
                   AND trfcanoe = nuanoeval
                   AND trfcmese = numeseval
                   --<<
                   --
                   -->>
                   AND to_char(trfcdiae, 'DD/MM/YYYY') = to_char(dtdiafech, 'DD/MM/YYYY')
                   AND trfcgrup = i.grup
                   AND trfcfltr = 'I'
                   AND trfctipo = 'E'
                   AND trfcfunc = nufunc;
            EXCEPTION
                WHEN no_data_found THEN
                    nuvalora := 0;
                WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR(-20015,'1 SUM1'||SQLERRM);
            END;


            --<<
            -- Se agrego el campo vagrdiae a la tabla valogrup_sap
            -->>
            UPDATE valogrup_sap
               SET VAGRVALO = nvl(VAGRVALO,0) + abs(nuvalora)
             WHERE VAGRanoe = nuanoeval
               AND VAGRmese = numeseval
               --<<
               --
               -->>
               AND vagrdiae = dtdiafech
               AND VAGRGRUP = i.grup
               AND vagrfunc = nufunc;
               
               IF SQL%NOTFOUND THEN
                   dbms_output.put_line('1');
                   INSERT INTO valogrup_sap(VAGRanoe,VAGRmese,VAGRGRUP,VAGRVALO,vagrfunc, vagrdiae) 
                          VALUES(nuanoeval,numeseval,i.grup,abs(nuvalora),nufunc, dtdiafech);
               END IF;

               INSERT INTO tereflcj_sap(
                                 trfcgrup,trfcanoe,trfcmese,trfcfltr,
                                 trfcdepa,trfcloca,trfcconc,trfcrvca,
                                 trfcrvtm,trfctipo,trfcfunc,trfcdiae, 
                                 trfcdiapm
                                 )
                          values (
                                  i.grup,nuanoeval,numeseval,'A',i.depa,
                                  i.loca,-1,nvl(i.care,0),nvl(i.tm,0)-abs(nuvalora),
                                  '-',nufunc, dtdiafech,nvl(i.suma,0)
                                 );
        END LOOP;
        
      
      --<<
      -- Se agraga el campo trfcdiam1(dia proyectado) de la tabla tereflcj_sap 
      -- y se elimina los campo trfcs1m1, trfcs2m1, 
      -- trfcs3m1, trfcs4m1
      -->>
        FOR i IN (SELECT trfcgrup grup,SUM(trfcdiapm) diap, SUM(trfcrvca) val_ca, SUM(trfcrvtm) tm 
                    FROM tereflcj_sap 
                   WHERE trfcanoe = nuanoeval 
                     AND trfcmese = numeseval 
                   --<<
                   --
                   -->>
                    AND trfcdiae = dtdiafech
                    AND trfcfltr = 'I' 
                    AND trfctipo IN ('C','I') 
                    AND trfcfunc = nufunc 
                  GROUP BY trfcgrup) LOOP
            BEGIN
                SELECT NVL(vagrvalo,0) INTO nuvalora
                  FROM valogrup_sap
                 WHERE vagranoe = nuanoeval
                   AND vagrmese = numeseval
                   --<<
                   --
                   -->>
                   AND to_char(vagrdiae, 'DD/MM/YYYY') = to_char(dtdiafech, 'DD/MM/YYYY')
                   AND vagrgrup = i.grup
                   AND vagrfunc = nufunc;
            EXCEPTION
                WHEN no_data_found THEN
                    nuvalora := 0;
                WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR(-20016,'2 SUM1'||i.grup||' '||SQLERRM);
            END;
            
            IF nuvalora < 0 THEN
               nuvalora := nuvalora * -1;
            END IF;
            
            INSERT INTO tereflcj_sap(
                                 trfcgrup,trfcanoe,trfcmese,trfcfltr,trfcdepa,trfcloca,
                                 trfcconc,trfcrvca,trfcrvtm,trfctipo,trfcfunc, trfcdiae,
                                 trfcdiapm 
                                 )
                          values (
                                  i.grup,nuanoeval,numeseval,'B',-1,-1,-1,nvl(i.val_ca,0),
                                  nvl(i.tm,0)-nuvalora,'-',nufunc, dtdiafech, nvl(i.diap,0) 
                                 );
        
        END LOOP;
        
        SELECT dtfechinic + contador INTO dtdiafech FROM dual;

    END LOOP;                             
-- 
END progeningreflcj;


PROCEDURE progeneegresoflcj IS
/************************************************************************
 PROPIEDAD INTELECTUAL DE SURTIGAS . (C) 2007
 PROCEDIMIENTO  : progeneegresoflcj
 AUTOR          : John Jairo Jimenez Marimon
 FECHA          : Mayo 26 del 2007
 DESCRIPCION    : Genera los egresos para flujo de caja

Parametros de Entrada
Parametros de Salida
Historia de Modificaciones
Autor   Fecha         Descripcion
************************************************************************/
    pdiaspago          NUMBER;
    pdiasfact          NUMBER;
    nuGrupo            flcjtipmov_sap.fctmcdgo%TYPE;
    nuFlag             CHAR(1) DEFAULT '0';
    sbDummy            varchar2(100);
    nuanoeval          NUMBER(4);
    numeseval          NUMBER(2);
    nuconta            NUMBER;
    dtfechinic         DATE;
    dtfechinic2        DATE;
    dtfechinic3        DATE;
    dtfechinic4        DATE;
    dtfechfins1        DATE;
    dtfechfins2        DATE;
    dtfechfins3        DATE;
    dtfechfins4        DATE;
    nusem1             NUMBER(18,2);
    nusem2             NUMBER(18,2);
    nusem3             NUMBER(18,2);
    nusem4             NUMBER(18,2);
    nuvare             NUMBER(18,2);

    CURSOR cudatos(fefi date) IS
        select distinct mvfctmpr timo,fctmcdgo grupo,fctmineg ineg,mvfcdist distc,mvfccodi codic, 
               to_char(mvfcfecr, 'DD/MM/YYYY') fecha, NVL(SUM(DECODE(TIMVFCEG,'S',mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0),'s',mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0),
               'n',(-1)*(mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0)),'N',(-1)*(mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0)))),0) VALOR
          from /*moviflcj, factcote, nitero, tipmovim,flcjtipmov,tipmovflcja */moviflcj_sap, factcote, nitero, tipmovim,flcjtipmov_sap,tipmovflcja_sap
         where mvfcesta in (1,2,3,8,9,10) and
               mvfcfcso = factcodi and
               mvfcdfas = factdist and
               mvfctmpr = timvcodi and
               nitecodi = factnit  and
               mvfcnit  = nitecodi and
               to_char(MVFCFEEA, 'DD/MM/YYYY') = fefi    and
               mvfctmpr = fctmcdtm and
               FCTMCDGO = TMFCCDGO and
               TMFCineg = 'E'
         group by mvfctmpr, fctmcdgo,fctmineg,mvfcdist,mvfccodi,mvfcfecr
     union
         select distinct mvfctmpr timo,fctmcdgo grupo,fctmineg ineg,mvfcdist distc,mvfccodi codic,to_char(mvfcfecr, 'DD/MM/YYYY') fecha,
                NVL(SUM(DECODE(TIMVFCEG,'S',mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0),'s',mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0),
                'n',(-1)*(mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0)),'N',(-1)*(mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0)))),0) VALOR
           from /*moviflcj,regppaga, nitero, tipmovim,flcjtipmov,tipmovflcja*/moviflcj_sap,regppaga, nitero, tipmovim,flcjtipmov_sap,tipmovflcja_sap
          where mvfcesta in (1,2,3,8,9,10) and
                mvfcREPP = reppcodi and
                mvfcdrep = reppdist and
                MVFCTMPR = TIMVCODI and
                nitecodi = reppnit  and
                mvfcnit =nitecodi   AND
                to_char(MVFCFEEA, 'DD/MM/YYYY') = fefi  and
                mvfctmpr = fctmcdtm and
                FCTMCDGO = TMFCCDGO and
                      TMFCineg = 'E'
          GROUP BY mvfctmpr,fctmcdgo,fctmineg,mvfcdist,mvfccodi,mvfcfecr
      union
           select distinct mvfctmpr timo,fctmcdgo grupo,fctmineg ineg,mvfcdist distc,mvfccodi codic,to_char(mvfcfecr, 'DD/MM/YYYY') fecha,
                  NVL(SUM(DECODE(TIMVFCEG,'S',mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0),'s',mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0),
                  'n',(-1)*(mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0)),'N',(-1)*(mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0)))),0) VALOR
             from /*moviflcj,nitero, tipmovim,flcjtipmov,tipmovflcja*/moviflcj_sap,nitero, tipmovim,flcjtipmov_sap,tipmovflcja_sap
            where mvfcesta in (1,2,3,8,9,10) and
                  mvfcREPP is null and
                  mvfcdrep is null and
                  mvfcfcso is null and
                  mvfcdfas is null and
                  MVFCTMPR = TIMVCODI  and
                  mvfcnit=nitecodi AND
                  to_char(MVFCFEEA, 'DD/MM/YYYY') = fefi and
                  mvfctmpr = fctmcdtm and
                  FCTMCDGO = TMFCCDGO and
                  TMFCineg = 'E'
            GROUP BY mvfctmpr,fctmcdgo,fctmineg,mvfcdist,mvfccodi, mvfcfecr;



      /*SELECT fctmineg ineg,mvfcdist distc,mvfccodi codic,FCTMCDGO grupo,mvcbesta esta,mvcbtimv timo,mvcbdist dist,mvcbcons cons,mvcbfeapl fecha,mvcbvlor valor,mvcbdisa disa,mvcbtmad tmad,mvcbcasi casi
       FROM  movicuba_sap,mvfcmvcb,moviflcj_sap,flcjtipmov_sap,tipmovflcja_sap
      WHERE  mvcbfeapl BETWEEN dtfeini AND dtfecfin
        AND  mvcbesta IN(1,2,3,6)
        AND  mvcbdist  = mfmbmvcbd
        AND  mvcbcons  = mfmbmvcbn
        AND  mfmbmvfcd = mvfcdist
        AND  mfmbmvfcn = mvfccodi
        AND  mvfctmpr  = fctmcdtm
        AND  fctmcdgo  = tmfccdgo
        AND  tmfcineg  = 'E' ;*/

    --<<
    -- Se modifica el cursor para que ya no haga calculos en un rango de fechas, sino en una fecha determinada
    -->>
    --CURSOR cuegrereales(dtfeini DATE,dtfecfin DATE) IS
    CURSOR cuegrereales(dtdiafech DATE)  IS
        SELECT mvcbdist dist,mvcbcons cons,nvl(sum(MFMBVLOR),0) valor,FCTMCDGO grupo,
               mvcbtimv TIMO,fctmineg ineg,mvcbfeapl fecha,mvcbdisa disa,mvcbtmad tmad,
               mvcbcasi casi
          FROM movicuba,mvfcmvcb,moviflcj,flcjtipmov,tipmovflcja/*movicuba_sap,mvfcmvcb,moviflcj_sap,flcjtipmov_sap,tipmovflcja_sap*/
         WHERE mvcbfeapl = dtdiafech--BETWEEN dtfeini AND dtfecfin
         
           AND mvcbesta IN(1,2,3,6)
           AND mvcbdist  = mfmbmvcbd
           AND mvcbcons  = mfmbmvcbn
           AND mfmbmvfcd = mvfcdist
           AND mfmbmvfcn = mvfccodi
           AND mvfctmpr  = fctmcdtm
           AND fctmcdgo  = tmfccdgo
           AND tmfcineg  = 'E'
         group by mvcbdist,mvcbcons,mvcbtimv,FCTMCDGO,fctmineg,mvcbfeapl,mvcbdisa,mvcbtmad,mvcbcasi
         ORDER BY mvcbdist,mvcbcons;

    dtfechfina    DATE;
    dtdiafech     DATE;
    nudia1        NUMBER(18,2);
         
BEGIN
  
    nuanoeval := nuanorfc;
    numeseval := numesrfc;

    -- Se borran los datos del a?o y mes a evaluar

     DELETE egreflcj_sap WHERE ano = nuanoeval AND mes = numeseval AND func = nufunc;

     -- Se generan las fechas para las semanas

     -- Generamos fecha inicial mes
     dtfechinic  := TO_DATE('01/'||pkflujocaja_sap10.fsbmesletras(numeseval)||'/'||nuanoeval,'DD/MON/YYYY');
  
     -- Generamos fecha final mes
     SELECT last_day(dtfechinic) INTO dtfechfina FROM dual;

     -- Se genera los egresos proyectados
     --<<
     -- Se genera un loop para tomar cada dia del mes
     --<<

     dtdiafech := dtfechinic;

    FOR  i IN 1..to_char(dtfechfina, 'DD') LOOP
        FOR i IN cudatos(dtdiafech) LOOP
           --IF i.fecha <= dtfechfins1 THEN
        /*      INSERT INTO egreflcj_sap(grupo,tipmov,ano,mes,distc,codic,sem1,sem2,sem3,sem4,flag,VARE,distb,consb,tipo,func)
                     values(i.grupo,i.timo,nuanoeval,numeseval,i.distc,i.codic,i.valor,0,0,0,'E',0,-1,-1,i.ineg,nufunc);*/
              
            INSERT INTO egreflcj_sap(grupo,tipmov,ano,mes,distc,codic,flag,VARE,distb,consb,tipo,func, dia, diavalo)
                   values(i.grupo,i.timo,nuanoeval,numeseval,i.distc,i.codic,'E',0,-1,-1,i.ineg,nufunc, dtdiafech, i.valor);

            BEGIN
                INSERT INTO VCMVFLCJ_sap(distc,codic) 
                       VALUES(i.distc,i.codic);
             EXCEPTION
                 WHEN DUP_VAL_ON_INDEX THEN
                     RAISE_APPLICATION_ERROR(-20017,'Registro Duplicado : Grupo : '||i.grupo||' Tipo_MOv : '||i.timo||' Mov_flcj : '||i.distc||'-'||i.codic);
                     null;
             END;
        /*
            ELSIF i.fecha <= dtfechfins2 THEN

              INSERT INTO egreflcj_sap(grupo,tipmov,ano,mes,distc,codic,sem2,sem1,sem4,sem3,flag,VARE,distb,consb,tipo,func)
                        values(i.grupo,i.timo,nuanoeval,numeseval,i.distc,i.codic,i.valor,0,0,0,'E',0,-1,-1,i.ineg,nufunc);
             BEGIN
               INSERT INTO VCMVFLCJ_sap(distc,codic) VALUES(i.distc,i.codic);
             EXCEPTION
              WHEN DUP_VAL_ON_INDEX THEN
               RAISE_APPLICATION_ERROR(-20018,'Registro Duplicado : Grupo : '||i.grupo||' Tipo_MOv : '||i.timo||' Mov_flcj : '||i.distc||'-'||i.codic);
              null;
             END;

            ELSIF i.fecha <= dtfechfins3 THEN

              INSERT INTO egreflcj_sap(grupo,tipmov,ano,mes,distc,codic,sem3,SEM1,SEM2,SEM4,flag,VARE,distb,consb,tipo,func)
                     values(i.grupo,i.timo,nuanoeval,numeseval,i.distc,i.codic,i.valor,0,0,0,'E',0,-1,-1,i.ineg,nufunc);
              BEGIN
               INSERT INTO VCMVFLCJ_sap(distc,codic) VALUES(i.distc,i.codic);
             EXCEPTION
              WHEN DUP_VAL_ON_INDEX THEN
               RAISE_APPLICATION_ERROR(-20019,'Registro Duplicado : Grupo : '||i.grupo||' Tipo_MOv : '||i.timo||' Mov_flcj : '||i.distc||'-'||i.codic);
               null;
             END;
            ELSE

              INSERT INTO egreflcj_sap(grupo,tipmov,ano,mes,distc,codic,sem4,sem1,sem2,sem3,flag,VARE,distb,consb,tipo,func)
                        values(i.grupo,i.timo,nuanoeval,numeseval,i.distc,i.codic,i.valor,0,0,0,'E',0,-1,-1,i.ineg,nufunc);
              BEGIN
               INSERT INTO VCMVFLCJ_sap(distc,codic) VALUES(i.distc,i.codic);
             EXCEPTION
              WHEN DUP_VAL_ON_INDEX THEN
               RAISE_APPLICATION_ERROR(-20020,'Registro Duplicado : Grupo : '||i.grupo||' Tipo_MOv : '||i.timo||' Mov_flcj : '||i.distc||'-'||i.codic);
               null;
             END;
            END IF;
         */
        END LOOP;

     
       --<<
       --Deberia ser este select cuando se tengas datos
       -->>
     
        FOR i IN (SELECT grupo,NVL(SUM(diavalo),0) dia1 
                    FROM egreflcj_sap 
                   WHERE ano = nuanoeval AND mes = numeseval AND tipo = 'E' AND func = nufunc AND dia = dtdiafech
                   GROUP BY grupo) LOOP
     
    /* FOR i IN (SELECT grupo,NVL(SUM(sem1),0) sem1,NVL(SUM(sem2),0) sem2,NVL(SUM(sem3),0) sem3,NVL(SUM(sem4),0) sem4 
                 FROM egreflcj 
                WHERE ano = nuanoeval AND mes = numeseval AND tipo = 'E' AND func = nufunc 
                GROUP BY grupo) LOOP*/
            BEGIN
            --<<
            -- es un unico campo llamado diavalo
            -->> 
                SELECT NVL(SUM(diavalo),0)
                  INTO nudia1
                  FROM egreflcj_sap
                 WHERE ano   = nuanoeval
                   AND mes   = numeseval
                   -->>
                   --
                   --<<
                   AND dia   = dtdiafech
                   AND grupo = i.grupo
                   AND tipo  = 'I'
                   AND func  = nufunc;
            EXCEPTION
                WHEN no_data_found THEN
                    nudia1 := 0;
            END;
          
            INSERT INTO egreflcj_sap(grupo,tipmov,ano,mes,distc,codic, flag,VARE,distb,consb,TIPO,func, dia, diavalo)
                   values(i.grupo,-1,nuanoeval,numeseval,-1,-1, 
                           'A',0,-1,-1,'-',nufunc, dtdiafech, i.dia1-nudia1); -- tengo q tener aqui la fecha
        END LOOP;
     
     
     
     
     --FOR i IN cuegrereales(dtfechinic,dtfechfins4) LOOP
       
        FOR i IN cuegrereales(dtdiafech) LOOP
            INSERT INTO egreflcj_sap(distb,consb,grupo,tipmov,ano,mes,distc,codic,flag,vare,disa,tmad,casi,TIPO,func, dia,diavalo)
                   values(i.dist,i.cons,i.grupo,i.timo,nuanoeval,numeseval,-1,-1,'E',nvl(i.valor,0),i.disa,i.tmad,i.casi,i.ineg,
                          nufunc, dtdiafech, nvl(i.valor,0));
            BEGIN
                INSERT INTO VCCBFLCJ_sap(distb,codib) 
                       VALUES(i.dist,i.cons);
             EXCEPTION
                 WHEN DUP_VAL_ON_INDEX THEN
                     --RAISE_APPLICATION_ERROR(-20022,'Registro Duplicado : Grupo : '||i.grupo||' Tipo_MOv : '||i.timo||' Cta_Banc : '||i.distb||'-'||i.codib);
                     null;
             END;
        END LOOP;
     
     
        FOR i IN (SELECT grupo,NVL(SUM(vare),0) vare 
                   FROM egreflcj_sap 
                  WHERE ano = nuanoeval AND mes = numeseval AND tipo = 'E' AND func = nufunc AND dia = dtdiafech
                  GROUP BY grupo) LOOP
            BEGIN
                SELECT NVL(SUM(vare),0) INTO nuvare
                  FROM egreflcj_sap
                 WHERE ano = nuanoeval
                   AND mes = numeseval
                   AND grupo = i.grupo
                   AND tipo = 'I'
                   AND func = nufunc
                   --<<
                   --
                   -->>
                   AND dia = dtdiafech;
            EXCEPTION
                WHEN no_data_found THEN
                    nuvare := 0;
             END;

      -- Se realiza una copia de la tabla agreflcj con los datos q esta tiene
      -- Agregar los siguientes campos
      -- diafech Date fecha del egreso
      -- diavalo Number(18,2) valor por dia
      -- Eliminar los campos
      -- sem1
      -- sem2
      -- sem3
      -- sem4

            UPDATE egreflcj_sap
               SET vare = (nvl(vare,0) + nvl(i.vare,0)) - nuvare
             WHERE ano = nuanoeval
               AND mes = numeseval
               AND grupo = i.grupo
               AND flag = 'A'
               AND func = nufunc
               AND dia = dtdiafech;
            IF SQL%NOTFOUND THEN
              INSERT INTO egreflcj_sap(grupo,tipmov,ano,mes,distc,codic,flag,vare,tipo,func, dia, diavalo)
                          values(i.grupo,-1,nuanoeval,numeseval,-1,-1,'A',nvl(i.vare,0)-nuvare,'-',nufunc, dtdiafech,nvl(i.vare,0)-nuvare);
            END IF;
        END LOOP;
      
       SELECT dtfechinic+i INTO dtdiafech FROM dual;

    END LOOP; 
 
 
    DELETE VCMVFLCJ_sap;
    DELETE VCCBFLCJ_sap;
   
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20024,'Error en pkflujocaja_sap.progeneegresoflcj '||sqlerrm);

END progeneegresoflcj;


PROCEDURE proprocesar1 IS
    BEGIN
         pkflujocaja_sap10.ProProyIngFactFlujoCaja;
        -- pkflujocaja_sap.proypagosflucaja;
        -- pkflujocaja_sap.ProProyIngFactFlujoCaja@lin_cordoba;
END proprocesar1;

PROCEDURE proprocesar2 IS
    BEGIN
        pkflujocaja_sap10.proypagosflucaja;
        -- pkflujocaja_sap.proypagosflucaja@lin_sucre;
        -- pkflujocaja_sap.proypagosflucaja@lin_cordoba;
END proprocesar2;

PROCEDURE proprocesar3 IS
    BEGIN
        pkflujocaja_sap10.proconsvalrealingcarg;
        -- pkflujocaja_sap.proconsvalrealingcarg@lin_sucre;
        -- pkflujocaja_sap.proconsvalrealingcarg@lin_cordoba;
END proprocesar3;


PROCEDURE proInicial(nuanoe NUMBER,numese NUMBER) IS
/************************************************************************
 PROPIEDAD INTELECTUAL DE SURTIGAS . (C) 2007
 PROCEDIMIENTO  : progeneegresoflcj
 AUTOR          : Jose Ricardo Gallego
 FECHA          : Abril del 2013
 DESCRIPCION    : Inicializa las variables del mes y del año

Parametros de Entrada
          nuanoe : El año a evaluar 
          numese : El mes a evaluar
Parametros de Salida
Historia de Modificaciones
Autor   Fecha         Descripcion
************************************************************************/  

BEGIN
  
    pkflujocaja_sap10.numesrfc := numese;
    pkflujocaja_sap10.nuanorfc := nuanoe;    

END proInicial;
    

PROCEDURE proReportes IS
   
   meseval      NUMBER := 1;
   anoeval      NUMBER := 2012;
   
   numesp       NUMBER := 1;
   nuanop       NUMBER := 2012;
   
   --<<
    -- Select para el valor real
    -->>
    CURSOR cuValorReal IS
    SELECT trfcdepa, trfcloca, trfcgrup, trfcconc, 
           trfcfltr, trfctipo, trfcdiae, trfcrvtm, 
           trfcrvca 
      FROM tereflcj_sap
     WHERE trfcanoe = anoeval 
       AND trfcmese = meseval;
      
      
    --<<
    -- Select para el valor Proyectado
    -->>
    CURSOR cuValorProyectado IS
    SELECT t.trfcdepa, t.trfcloca, t.trfcgrup, t.trfcconc, 
           t.trfcfltr, t.trfctipo, t.trfcdiae, t.trfcdiapm 
      FROM TEREFLCJ_SAP t
     WHERE trfcanoe = nuanop 
       AND trfcmese = numesp;
  
   
BEGIN
  
    meseval := numesrfc;
    anoeval := nuanorfc;
    
    IF meseval = 12 THEN
        numesp := 1;
        numesp := anoeval + 1;
    ELSE
        numesp := meseval + 1;
        numesp := anoeval;
    END IF;
        
    
    FOR regValorReal IN cuValorReal LOOP
        dbms_output.put_line(regValorReal.Trfcdiae || '   ' || regValorReal.Trfcrvtm || '   '||  regValorReal.Trfcrvca);
    END LOOP;
  
    FOR regValorProyectado IN cuValorProyectado LOOP
        dbms_output.put_line(regValorProyectado.Trfcdiae || '  ' || regValorProyectado.Trfcdiapm  );
    END LOOP; 
     dbms_output.put_line('Ricardo');

END proReportes;

PROCEDURE prcGeInComp(nuanoe NUMBER,numese NUMBER, nuOperacion NUMBER) IS

BEGIN 
     -- Setear las variables año y mes
     pkflujocaja_sap10.proInicial(nuanoe, numese);
     
     
     IF nuOperacion < 1 THEN
         dbms_output.put_line ('Entro en el 1: ' || nuOperacion ); 
         --pkflujocaja_sap10.ProProyIngFactFlujoCaja;
         --COMMIT;
     END IF;
     
     IF nuOperacion < 2 THEN 
         dbms_output.put_line ('Entro en el 2: ' || nuOperacion ); 
         --pkflujocaja_sap10.proypagosflucaja;
         --COMMIT;
     END IF;
     
     IF nuOperacion < 3 THEN 
         dbms_output.put_line ('Entro en el 3: ' || nuOperacion ); 
         --pkflujocaja_sap10.ProProyRecaFlujoCaja;
         --COMMIT;
     END IF;
     
     IF nuOperacion < 4 THEN
         dbms_output.put_line ('Entro en el 4: ' || nuOperacion ); 
         --pkflujocaja_sap10.proconsvalrealingcarg;
         --COMMIT;
     END IF;
     
     IF nuOperacion < 5  THEN
         dbms_output.put_line ('Entro en el 5: ' || nuOperacion );  
         --pkflujocaja_sap10.proconsvalrealingtipmov;
         --COMMIT;
     END IF;
     

END prcGeInComp;


PROCEDURE prcPruebaReporte(nuanoe NUMBER,numese NUMBER) IS
BEGIN
    pkflujocaja_sap10.proInicial(nuanoe, numese);
    pkflujocaja_sap10.proReportes;
    
END prcPruebaReporte;


END PKFLUJOCAJA_SAP10;
/
