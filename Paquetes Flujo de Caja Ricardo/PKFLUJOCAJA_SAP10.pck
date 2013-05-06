CREATE OR REPLACE PACKAGE PKFLUJOCAJA_SAP10 IS

dtfeinis1m1     DATE;
dtfefis1m1      DATE;
dtfeinis2m1     DATE;
dtfefis2m1      DATE;
dtfeinis3m1     DATE;     
dtfefis3m1      DATE;
dtfeinis4m1     DATE;
dtfefis4m1      DATE;
nuanorfc        NUMBER(4) DEFAULT 2007;
numesrfc        NUMBER(2) DEFAULT 1;
sbprog          VARCHAR2(10);
nufunc          funciona.funccodi%TYPE DEFAULT -1;
nugrupo         NUMBER;

PROCEDURE provalidaanomes;
FUNCTION fsbmesletras(numes NUMBER) RETURN VARCHAR2;
PROCEDURE procrearegfactconc(nudepa NUMBER,nuloca NUMBER,nuanoe NUMBER,numese NUMBER,nuano NUMBER,numes NUMBER,nuconc NUMBER,nuValor NUMBER,nugrupo NUMBER);
PROCEDURE ProProyIngFactFlujoCaja;
PROCEDURE proypagosflucaja;
PROCEDURE ProProyRecaFlujoCaja;
PROCEDURE proconsvalrealingcarg;
PROCEDURE procarginreal(nuanoe NUMBER,numese NUMBER);
PROCEDURE proconsvalrealingtipmov;
PROCEDURE procarginrealtipmov(nuanoe NUMBER,numese NUMBER);
PROCEDURE progeningreflcj;
PROCEDURE progeneegresoflcj;
PROCEDURE proprocesar1;
PROCEDURE proprocesar2;
PROCEDURE proprocesar3;
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

PROCEDURE procrearegfactconc(nudepa NUMBER,nuloca NUMBER,nuanoe NUMBER,numese NUMBER,nuano NUMBER,numes NUMBER,nuconc NUMBER,nuValor NUMBER,nugrupo NUMBER, nuDia NUMBER) IS
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
                       facodepa,facoloca,facoanoe,facomese,facoano,facomes,facoconc,facovlor,facogrup,facofunc, dia
                      )
               VALUES(
                       nudepa,nuloca,nuanoe,numese,nuano,numes,nuconc,nuValor,nugrupo,nufunc, nuDia
                      );
END procrearegfactconc;

--<<
-- Proyecto 1
-->>

PROCEDURE ProProyIngFactFlujoCaja is
/***********************************************************************************************
 Nombre : ProProyIngFactFlujoCaja
 Desc   : obtiene el valor facturado por concepto y por periodo
 Autor  : Claudia Vellojin
 Fecha  : Mayo del 2007
 
 Historia de Modificaciones
 Autor  :  JRG  
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

--<<
-- Se trae un parametro mas del select
-- de la tabla cobro (yo que dato deberia de tomar el cargfecr(fecha creacion) 
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
       GROUP BY locadist,locaagen,cargconc,cargcate, to_char(cargfecr, 'DD/MM/YYYY');

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
      GROUP BY locadist,locaagen,cargconc,cargcate, to_char(cargfecr, 'DD/MM/YYYY');

BEGIN
  meseval:= numesrfc;
  anoeval:= nuanorfc;

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
  dtfechinic := TO_DATE('01/'||fsbmesletras(mes)||'/'||ano,'DD/MON/YYYY');

  -- Generamos fecha final mes 1
  SELECT last_day(dtfechinic) INTO dtfechfini FROM dual;

  -- Generamos fecha inicial mes 2
  dtfechinic2 := TO_DATE('01/'||fsbmesletras(mes2)||'/'||ano2,'DD/MON/YYYY');

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
      
     procrearegfactconc(i.cargdepa,i.cargloca,anoeval,meseval,ano,mes,i.cargconc,i.suma,nugrupo, i.dia);
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
       procrearegfactconc(i.cargdepa,i.cargloca,anoeval,meseval,ano,mes,i.cargconc,i.suma,nugrupo, i.dia);
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
       procrearegfactconc(i.cargdepa,i.cargloca,anoeval,meseval,ano2,mes2,i.cargconc,i.suma,nugrupo,i.dia);
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
       procrearegfactconc(i.cargdepa,i.cargloca,anoeval,meseval,ano2,mes2,i.cargconc,i.suma,nugrupo, i.dia);
    END IF;
  END LOOP;
  --<<
  -- Debo Ingresar el campo de dia en esta tabla
  -->>
  INSERT INTO peevflcj_sap VALUES(anoeval,meseval,'F',nufunc);

EXCEPTION
 WHEN OTHERS THEN
  RAISE_APPLICATION_ERROR(-20005,'Error en pkflujocaja_sap.ProProyIngFactFlujoCaja. '||SQLERRM);
END ProProyIngFactFlujoCaja;


--<<
-- Proceso 2
-->>

PROCEDURE proypagosflucaja IS
/***********************************************************************************************
   Nombre : proypagosflucaja
   Desc   : obtiene el valor recaudado por cuenta de cobro por periodo de la tabla cargos
   Autor  : Claudia Vellojin
   Fecha  : Mayo del 2007
 Historia de Modificaciones
 Autor  :  JRG  
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

CURSOR cuco(nuanocu NUMBER,numescu NUMBER) IS
  
  --<<
  -- Se adiciona un compo mas para extraer de la consulta
  -- este campo es el dia cucofege (cuenta de cobro fecha generada)
  -->>
  
  SELECT cucoano,cucomes,cucocodi,cucovato,cucovaab,
         to_char(cucofege, 'DD/MM/YYYY') dia
    FROM cuencobr,servsusc
   WHERE cucoprog = 'FGCC'
     AND cucoano  = nuanocu
     AND cucomes  = numescu
     AND sesunuse = cuconuse
     AND sesuserv = 1
     AND cucovato > 0;
    
   --<<
   -- Se adiciona un campo mas para extraer de la consulta
   -- este campo es cargfecr (fecha creacion) 
   -->> 
CURSOR carg(cuco NUMBER) IS
   SELECT nvl(cargvalo,0) CARGVALO,cargano,cargmes, 
          to_char(cargfecr, 'DD/MM/YYYY') dia
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
  
  --<< 
  -- ¿no deberia calcular el factura por dia?
  -- En caso afirmativo realizar un for desde el primer dia del mes
  -- hasta el ultimo dia del mes
  -->> 
  
    FOR c1 IN cuco(nuano1,meseval) LOOP
     sumvafa := nvl(sumvafa,0) + nvl(c1.cucovato,0);

  --<<
  -- Calculamos lo recaudado 1 y 2 meses despues
  -- ¿Debo calcular lo recuadado de los siguientes
  --- dos meses por dias ?
  -->>
  
    FOR a1 IN carg(c1.cucocodi) LOOP
       n:=(a1.cargano*12+a1.cargmes-1)-(c1.cucoano*12+c1.cucomes);
       IF n=0 THEN
          sumrec1 := nvl(sumrec1,0) + nvl(a1.cargvalo,0);
       ELSE
         sumrec2 := nvl(sumrec2,0) + nvl(a1.cargvalo,0);
       END IF;
    END LOOP;
    
    INSERT INTO compreca_sap(
               coreanoe,coremese,coreano,coremes,coremes1,
               coreano1,coremes2,coreano2,corefact,corereca,
               corerec2,corefunc
               )
         VALUES(
               anoeval,meseval,nuano1,meseval,mes1,
               ano1,mes2,ano2,sumvafa,sumrec1,sumrec2,nufunc
              );
    
   END LOOP;
        
        /*INSERT INTO compreca_sap(
                    coreanoe,coremese,coreano,coremes,coremes1,
                    coreano1,coremes2,coreano2,corefact,corereca,
                    corerec2,corefunc
                    )
              VALUES(
                    anoeval,meseval,nuano1,meseval,mes1,
                    ano1,mes2,ano2,sumvafa,sumrec1,sumrec2,nufunc
                   );*/
                            
                            --<<
        -- compreca_sap (Comportamiento Recaudo Vs Facaturacion)
        -- en esta tabla se deberia adicionar un campos
        -- caredia (dia facturado mes)
        -- Esto deberia de ir en un ciclo para poder calcular el valor por dias
        -- ¿No se como eso pueda afectar la logica?  
        -->>

    --<<
    -- ¿A esta tabla no se le deberia de adiocionar el campo dia?
    -- pefcdia (dia evaluado)
    -- No Creo, pero preguntar
    -- dia
    -->>  
    
  
  SELECT last_day(dtFechInic1) INTO periodo1fini FROM dual;
  dtFechF1 := to_date(periodo1fini,'DD/MM/YYYY');
    FOR                       
    INSERT INTO peevflcj_sap VALUES(anoeval,meseval,'P',nufunc);

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
   Fecha  : Febrero 26 2012
   Desc   : Se averiguar recaudo por dia y no por semana en mes1
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
sem1inicmes1   DATE;
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
porcsem4mes1   recaproy_sap.reprs4m1%type;

BEGIN
  anoeval   := nuanorfc;
  meseval   := numesrfc;

  DELETE recaproy_sap WHERE repranoe = anoeval ANd reprmese = meseval AND reprfunc = nufunc;
  DELETE peevflcj_sap WHERE pefcanoe = anoeval AND pefcmese = meseval AND pefctire = 'R' AND func = nufunc;

  mes1      := numesrfc;
  ano1      := nuanorfc - 1;

  mes1letras := fsbmesletras(mes1);
  dtFechInic1 := to_date('01/'||mes1letras||'/'||to_char(ano1),'DD/MON/YYYY');

  SELECT last_day(dtFechInic1) INTO periodo1fini FROM dual;
  dtFechF1 := to_date(periodo1fini,'DD/MM/YYYY');

   SELECT nvl(sum(nvl(MVCBVLOR,0)),0) INTO recames1
     FROM movicuba_sap
    WHERE mvcbtimv in (313,334,1069,994)
      AND mvcbfeapl >= dtFechInic1
      AND mvcbfeapl <= dtFechF1;

   IF recames1 = 0 THEN
      recames1 := 1;
   END IF;

  --averiguar recaudo por semana en mes1
  
  --<<
  -- solo necesitaria los datos de sem1inicmes1 y el de dtFechF1 y hacer un 
  -- ciclo sacar cada dia
  -->>
  
    sem1inicmes1 := to_date('01/'||mes1letras||'/'||ano1,'DD/MON/YYYY');
    sem1finmes1 := to_date('07/'||mes1letras||'/'||ano1,'DD/MON/YYYY');

    sem2inicmes1 := to_date('08/'||mes1letras||'/'||ano1,'DD/MON/YYYY');
    sem2finmes1 := to_date('14/'||mes1letras||'/'||ano1,'DD/MON/YYYY');

    sem3inicmes1 := to_date('15/'||mes1letras||'/'||ano1,'DD/MON/YYYY');
    sem3finmes1 := to_date('21/'||mes1letras||'/'||ano1,'DD/MON/YYYY');

    sem4inicmes1 := to_date('22/'||mes1letras||'/'||ano1,'DD/MON/YYYY');
    sem4finmes1 := to_date(dtFechF1,'DD/MM/YYYY');

    SELECT nvl(sum(nvl(MVCBVLOR,0)),0) INTO recames1sem1
      FROM movicuba_sap
     WHERE mvcbtimv IN (313,334,1069,994)
       AND mvcbfeapl >= sem1inicmes1
       AND mvcbfeapl <= sem1finmes1;

    SELECT nvl(sum(nvl(MVCBVLOR,0)),0) INTO recames1sem2
      FROM movicuba_sap
     WHERE mvcbtimv in (313,334,1069,994)
       AND mvcbfeapl >=sem2inicmes1
       AND mvcbfeapl <=sem2finmes1;

    SELECT nvl(sum(nvl(MVCBVLOR,0)),0) INTO recames1sem3
      FROM movicuba_sap
     WHERE mvcbtimv in (313,334,1069,994)
       AND mvcbfeapl >=sem3inicmes1
       AND mvcbfeapl <=sem3finmes1;

     SELECT nvl(sum(nvl(MVCBVLOR,0)),0) INTO recames1sem4
      FROM movicuba_sap
     WHERE mvcbtimv in (313,334,1069,994)
       AND mvcbfeapl >=sem4inicmes1
       AND mvcbfeapl <=sem4finmes1;

      porcsem1mes1:=round( (recames1sem1/recames1)*100,0);
      porcsem2mes1:=round( (recames1sem2/recames1)*100,0);
      porcsem3mes1:=round( (recames1sem3/recames1)*100,0);
      porcsem4mes1:=round( (recames1sem4/recames1)*100,0);

      
      
      --<<
      -- La tabla recaproy_sap se deberia modificar agregandole el campo de dia
      -- y se ingresa un registro por casa dia del mes 
      -- Se deben eliminar los siguientes datos
      -- reprs1s1 (semana 1 mes 1)
      -- reprs2m1 (semana 2 mes 1)
      -- reprs3m1 (semana 3 mes 1)
      -- reprs4m1 (semana 4 mes 1)
      -- para obtiene el valor recaudado por cuenta de cobro por SEMANA solo necesito
      -- el mes evaluado no los dias, mirar esa parte tal vez esto me ayude a tener 
      -- una mejor persepcion del problema en cuestion
      -->>
       INSERT INTO recaproy_sap(
                            repranoe,reprmese,reprmes,reprano,
                            reprs1m1,reprs2m1,reprs3m1,reprs4m1,reprfunc
                           )
                     VALUES(
                            anoeval,meseval,mes1,ano1,
                            porcsem1mes1,porcsem2mes1,porcsem3mes1,porcsem4mes1,nufunc
                           );

    INSERT INTO peevflcj_sap VALUES(anoeval,meseval,'R',nufunc);

EXCEPTION
WHEN OTHERS THEN
 RAISE_APPLICATION_ERROR(-20007,'Error en pkflujocaja_sap.ProProyRecaFlujoCaja. '||SQLERRM);
END ProProyRecaFlujoCaja;

--<<
-- Proceso 3
-->>

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
    -- Se agrego un campo mas para el agrupamiento 
    -- /* + rule */ tal vez sea importante pensar en como hacerle afinamiento a la consulta
    -- ya que se esta demorando mucho
    -->>
  CURSOR cuCargreal(dtfechainiP DATE,dtfechafinP DATE) IS
   SELECT locadist depa,locaagen loca,depaconc concepto,nvl(sum(depavalo),0) valor,depacate cate,
          to_char(depafech, 'DD')  dia
     FROM detapago,localida
    WHERE depafecr BETWEEN /*'01/01/07' AND '31/01/07' */ dtfechainip AND dtfechafinp
      AND depacuco <> -1
      AND depadepa = locadepa
      AND depaloca = locacodi
   GROUP BY locadist,locaagen,depaconc,depacate, to_char(depafech, 'DD')
   ORDER BY dia;

   /*
   SELECT locadist depa,locaagen loca,tfconflcj grupo,depaconc concepto,nvl(sum(depavalo),0) valor
     FROM detapago,localida,tiflconc_sap
    WHERE depafecr BETWEEN dtfechainip AND dtfechafinp
      AND depacuco <> -1
      AND detadepa = locadepa
      AND detaloca = locacodi
      AND depaconc = tfconcpto
   GROUP BY depadepa,depaloca,tfconflcj,depaconc;
   */

 dtfechaini DATE;
 dtfechafin DATE;
 numes NUMBER;
BEGIN
   DELETE inreflcj_sap WHERE ano = nuanorfc AND mes = numesrfc AND func = nufunc;
   -- Obtenemos el valor de los cargos
   dtfechaini := to_date('01/'||fsbmesletras(numesrfc)||'/'||nuanorfc,'DD/MON/YYYY');
   SELECT last_day(dtfechaini) INTO dtfechafin
     FROM dual;
   
   --<<
   -- JRG Se modificaron los formatos de fecha de (MM/DD/YYYY) a (MM/DD/YY)
   -- para la busqueda en el cursor
   -->>
     
   dtfechaini := to_date(dtfechaini,'DD/MM/YY');  
   dtfechafin := to_date(dtfechafin,'DD/MM/YY');
   
   
   --<<
   -- Deberia hacer un look desde la fecha inicial hasta la 
   -- fecha final del mes asi calcula el valor real del recaudo 
   -- por grupo cargos en el dia, y no en el mes
   -- 
   -->>
   
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
       -- Se adiciona el campo dia para ingresarlo en la tabla inreflcj_sap (ingresos reales
       -- flujo de caja cargos) 
       -->>
       INSERT INTO inreflcj_sap(depa,loca,ano,mes,grupo,concep,valor,func)
              VALUES(i.depa,i.loca,nuanorfc,numesrfc,nugrupo,i.concepto,i.valor,nufunc);
     END IF;
    END LOOP;
END proconsvalrealingcarg;


PROCEDURE procarginreal(nuanoe NUMBER,numese NUMBER) IS
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

    -- Consultamos el valor de los cargos
    --<<
    -- La tabla inreflcj_sap debe tener un campo mas que sea el dia y esto se hacen en el 
    -- proceso 3 (proconsvalrealingtipmov)
    -->>
  CURSOR cuCargreal IS
    SELECT depa,loca,ano,mes,grupo,concep,nvl(SUM(valor),0) valor
      FROM inreflcj_sap WHERE ano = nuanoe AND mes = numese AND func = nufunc 
     group by depa,loca,ano,mes,grupo,concep;
 --  UNION ALL
 --   SELECT depa,loca,ano,mes,grupo,concep,nvl(SUM(valor),0) valor FROM inreflcj_sap@LIN_SUCRE WHERE ano = nuanoe AND mes = numese AND func = nufunc group by depa,loca,ano,mes,grupo,concep
 --  UNION ALL
 --   SELECT depa,loca,ano,mes,grupo,concep,nvl(SUM(valor),0) valor FROM inreflcj_sap@LIN_CORDOBA WHERE ano = nuanoe AND mes = numese AND func = nufunc group by depa,loca,ano,mes,grupo,concep;

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
      AND trfcfunc = nufunc;
    IF sql%notfound THEN
     --<<
     -- debe ingresar el campo dia a la tabla tereflcj_sap
     -->> 
     INSERT INTO tereflcj_sap(trfcdepa,trfcloca,trfcanoe,trfcmese,trfcgrup,trfcconc,trfcfltr,trfcrvca,trfctipo,trfcfunc)
                  VALUES(i.depa,i.loca,i.ano,i.mes,i.grupo,i.concep,'I',i.valor,'C',nufunc);
    END IF;
  END LOOP;
END procarginreal;

--<<
-- 
-->>

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
  Autor   Fecha         Descripcion
 *************************************************************************/
  nuvalor  NUMBER(13,2);

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
          to_char(mvcbfech, 'DD') dia
     FROM movicuba_sap,flcjtipmov_sap,tipmovflcja_sap
    WHERE mvcbfeapl BETWEEN dtfechainip AND dtfechafinp
      AND mvcbesta IN(1,2,6)
      AND mvcbtimv = fctmcdtm
      AND fctmcdgo = tmfccdgo
      AND tmfcineg = 'I'
 GROUP BY mvcbdage,mvcbagen,fctmcdgo,mvcbtimv,fctmineg,mvcbdist,mvcbcons,mvcbdisa,mvcbtmad,mvcbcasi
          to_char(mvcbfech, 'DD');

   /*SELECT mvcbesta esta,mvcbfeapl fecha,locadepa depa,locacodi loca,fctmcdgo grupo,mvcbtimv tipo_movim,FCTMINEG ineg,MVCBDIST,MVCBCONS,MVCBDISA,MVCBTMAD,MVCBCASI,nvl(SUM(mvcbvlor),0) nuvalor
     FROM movicuba_sap,localida,flcjtipmov_sap,tipmovflcja_sap
    WHERE mvcbfeapl BETWEEN dtfechainip AND dtfechafinp
      AND mvcbdage = locadist
      AND mvcbagen = locaagen
      AND mvcbtimv = fctmcdtm
      AND tmfccdgo = fctmcdgo
      AND tmfcineg = 'I'
   GROUP BY mvcbesta,mvcbfeapl,locadepa,locacodi,FCTMCDGO,mvcbtimv,FCTMINEG,MVCBDIST,MVCBCONS,MVCBDISA,MVCBTMAD,MVCBCASI;*/

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
   dtfechaini := to_date('01/'||fsbmesletras(numesrfc)||'/'||nuanorfc,'DD/MON/YYYY');
   SELECT last_day(dtfechaini) INTO dtfechafin
     FROM dual;
   dtfechafin  := to_date(dtfechafin,'DD/MM/YYYY');

 FOR i IN cuTipMovReal(dtfechaini,dtfechafin) LOOP
   --<<
   -- En la tabla ctabflcj_sap se ingresara el campo dia
   -->>
   INSERT INTO ctabflcj_sap(DEPA,LOCA,ano,mes,GRUPO,TIPMOV,DISTC,CONSC,DISA,TMAD,CASI,VALOR,tipo,func)
          VALUES(i.depa,i.loca,nuanorfc,numesrfc,i.grupo,i.tipo_movim,i.MVCBDIST,i.MVCBCONS,i.MVCBDISA,i.MVCBTMAD,i.MVCBCASI,i.nuvalor,i.ineg,nufunc);
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


--<<
--
-->>

PROCEDURE procarginrealtipmov(nuanoe NUMBER,numese NUMBER) IS
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
  Autor   Fecha         Descripcion
 *************************************************************************/

    -- Consultamos el valor de los tipos de movimientos
    --<<
    -- 
    -->>
  CURSOR cuCargreal IS
    SELECT depa,loca,ano,mes,grupo,tipmov,tipo,nvl(sum(valor),0) nuvalor
      FROM ctabflcj_sap
     WHERE ano = nuanoe
       AND mes = numese
       AND func = nufunc
    GROUP BY depa,loca,ano,mes,grupo,tipmov,tipo;

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
      AND trfcfunc = nufunc;
    IF sql%notfound THEN
     INSERT INTO tereflcj_sap(trfcdepa,trfcloca,trfcanoe,trfcmese,trfcgrup,trfcconc,trfcfltr,trfcrvtm,trfctipo,trfcfunc)
                  VALUES(i.depa,i.loca,i.ano,i.mes,i.grupo,i.tipmov,'I',i.nuvalor,i.tipo,nufunc);
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

-- Consultamos lOS grupos

 CURSOR cuGrupo(ano NUMBER,mes NUMBER) IS
  SELECT facogrup grupo,facoconc concepto
    FROM factconc_sap
   WHERE facoanoe  = ano
     AND facomese  = mes
     AND facofunc  = nufunc
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
 BEGIN
   nuanoeval := nuanorfc;
   numeseval := numesrfc;

 -- Se borran los registros para el a?o y mes a evaluar
    DELETE tereflcj_sap WHERE trfcanoe = nuanoeval AND trfcmese = numeseval AND trfcfunc = nufunc;

 -- Consulta a?o y mes anterior al evaluado
   BEGIN
    SELECT coreano,coremes INTO nuanoant,numesant
      FROM compreca_sap
     WHERE coreanoe = nuanoeval
       AND coremese = numeseval
       AND corefunc = nufunc;
   EXCEPTION
    WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20010,'Error al consultar el a?o y mes anterior al evaluado en pkflujocaja_sap.progeningreflcj. '||SQLERRM);
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

 -- Consultamos el porcentaje de recaudo por semana
 BEGIN
    SELECT NVL(reprs1m1,0)/100,NVL(reprs2m1,0)/100,NVL(reprs3m1,0)/100,NVL(reprs4m1,0)/100 INTO porcs1m1,porcs2m1,porcs3m1,porcs4m1
      FROM recaproy_sap
     WHERE repranoe = nuanoeval
       AND reprmese = numeseval
       AND reprfunc = nufunc;
   EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20013,'Error al consultar el porcentaje de recaudo por semana del primer mes en pkflujocaja_sap.progeningreflcj. '||SQLERRM);
   END;

 -- Generamos los ingresos
  FOR i IN cuGrupo(nuanoeval,numeseval) LOOP
   FOR j IN (SELECT locadist locadepa,locaagen locacodi FROM localida group by locadist,locaagen ORDER BY locadepa,locacodi) LOOP

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

 -- Generamos los ingresos proyectados por semana

    nugrupo := i.grupo;

   -- Calculamos valor proyectado semana 1

    s1m1r   := TRUNC((nuvalfact * nuPorcrecames1 * porcs1m1) + (nuvalfact2 * nuPorcrecames2 * porcs1m1),2);

   -- Calculamos valor proyectado semana 2

    s2m1r   := TRUNC((nuvalfact * nuPorcrecames1 * porcs2m1) + (nuvalfact2 * nuPorcrecames2 * porcs2m1),2);

   -- Calculamos valor proyectado semana 3

    s3m1r   := TRUNC((nuvalfact * nuPorcrecames1 * porcs3m1) + (nuvalfact2 * nuPorcrecames2 * porcs3m1),2);

   -- Calculamos valor proyectado semana 4

    s4m1r   := TRUNC((nuvalfact * nuPorcrecames1 * porcs4m1) + (nuvalfact2 * nuPorcrecames2 * porcs4m1),2);

  -- Se graban los datos en la tabla

   BEGIN

    IF (s1m1r IS NOT NULL AND s1m1r <> 0) OR (s2m1r IS NOT NULL AND s2m1r <> 0) OR (s3m1r IS NOT NULL AND s3m1r <> 0) OR (s4m1r IS NOT NULL AND s4m1r <> 0) THEN

     INSERT INTO tereflcj_sap(
                         trfcgrup,trfcanoe,trfcmese,trfcps1m,trfcps2m,
                         trfcps3m,trfcps4m,trfcdepa,trfcloca,trfcconc,
                         trfcfltr,trfctipo,trfcfunc
                         )
                  values (
                          nugrupo,nuanoeval,numeseval,nvl(s1m1r,0),nvl(s2m1r,0),
                          nvl(s3m1r,0),nvl(s4m1r,0),j.locadepa,j.locacodi,i.concepto,
                          'I','C',nufunc
                         );
   END IF;
   EXCEPTION
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20014,'1Error al insertar en tereflcj_sap desde pkflujocaja_sap.progeningreflcj. Agencia : '||j.locadepa||'-'||j.locacodi||' grupo '||nugrupo||' concepto '||i.concepto||' '||SQLERRM);
   END;
   END LOOP;
  END LOOP;

  -- Se registran los ingresos reales

  procarginreal(nuanoeval,numeseval);
  procarginrealtipmov(nuanoeval,numeseval);

  DELETE valogrup_sap WHERE VAGRanoe = nuanoeval AND VAGRmese =  numeseval;

  FOR i IN (SELECT trfcdepa depa,trfcloca loca,trfcgrup grup,SUM(trfcps1m)+SUM(trfcps2m)+SUM(trfcps3m)+SUM(trfcps4m) suma,SUM(trfcrvca) care,SUM(trfcrvtm) tm FROM tereflcj_sap WHERE trfcanoe = nuanoeval AND trfcmese = numeseval AND trfcfltr = 'I' AND trfctipo IN('C','I') AND trfcfunc = nufunc GROUP BY trfcdepa,trfcloca,trfcgrup) LOOP
   BEGIN
    SELECT NVL(SUM(trfcrvtm),0) INTO nuvalora
      FROM tereflcj_sap
     WHERE trfcdepa = i.depa
       AND trfcloca = i.loca
       AND trfcanoe = nuanoeval
       AND trfcmese = numeseval
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

    UPDATE valogrup_sap
       SET VAGRVALO = nvl(VAGRVALO,0) + abs(nuvalora)
     WHERE VAGRanoe = nuanoeval
       AND VAGRmese = numeseval
       AND VAGRGRUP = i.grup
       AND vagrfunc = nufunc;
    IF SQL%NOTFOUND THEN
       INSERT INTO valogrup_sap(VAGRanoe,VAGRmese,VAGRGRUP,VAGRVALO,vagrfunc) VALUES(nuanoeval,numeseval,i.grup,abs(nuvalora),nufunc);
    END IF;

    INSERT INTO tereflcj_sap(
                         trfcgrup,trfcanoe,trfcmese,trfcps4m,
                         trfcfltr,trfcdepa,trfcloca,trfcconc,trfcrvca,trfcrvtm,trfctipo,trfcfunc
                         )
                  values (
                          i.grup,nuanoeval,numeseval,nvl(i.suma,0),
                          'A',i.depa,i.loca,-1,nvl(i.care,0),nvl(i.tm,0)-abs(nuvalora),'-',nufunc
                         );
  END LOOP;
  FOR i IN (SELECT trfcgrup grup,SUM(trfcps1m) sem1,SUM(trfcps2m) sem2,SUM(trfcps3m) sem3,SUM(trfcps4m) sem4,SUM(trfcrvca) val_ca,SUM(trfcrvtm) tm FROM tereflcj_sap WHERE trfcanoe = nuanoeval AND trfcmese = numeseval AND trfcfltr = 'I' AND trfctipo IN ('C','I') AND trfcfunc = nufunc GROUP BY trfcgrup) LOOP
   BEGIN
    /*SELECT NVL(SUM(trfcrvtm),0) INTO nuvalora
      FROM tereflcj_sap
     WHERE trfcanoe = nuanoeval
       AND trfcmese = numeseval
       AND trfcgrup = i.grup
       AND trfcfltr = 'I'
       AND trfctipo = 'E'
       AND trfcfunc = nufunc;
    SELECT NVL(SUM(trfcrvtm),0) INTO nuvalora
      FROM tereflcj_sap
     WHERE trfcanoe = nuanoeval
       AND trfcmese = numeseval
       AND trfcgrup = i.grup
       AND trfcfltr = 'A'
       AND trfctipo = '-'
       AND trfcfunc = nufunc;*/
     SELECT NVL(vagrvalo,0) INTO nuvalora
       FROM valogrup_sap
      WHERE vagranoe = nuanoeval
        AND vagrmese = numeseval
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
                         trfcgrup,trfcanoe,trfcmese,trfcps1m,trfcps2m,trfcps3m,trfcps4m,
                         trfcfltr,trfcdepa,trfcloca,trfcconc,trfcrvca,trfcrvtm,trfctipo,trfcfunc
                         )
                  values (
                          i.grup,nuanoeval,numeseval,nvl(i.sem1,0),nvl(i.sem2,0),nvl(i.sem3,0),nvl(i.sem4,0),
                          'B',-1,-1,-1,nvl(i.val_ca,0),nvl(i.tm,0)-nuvalora,'-',nufunc
                         );
  END LOOP;
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
  select distinct mvfctmpr timo,fctmcdgo grupo,fctmineg ineg,mvfcdist distc,mvfccodi codic, mvfcfeea fecha, NVL(SUM(DECODE(TIMVFCEG,'S',mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0),'s',mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0),'n',(-1)*(mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0)),'N',(-1)*(mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0)))),0) VALOR
  from moviflcj_sap, factcote, nitero, tipmovim,flcjtipmov_sap,tipmovflcja_sap
  where mvfcesta in (1,2,3,8,9,10) and
        mvfcfcso = factcodi and
        mvfcdfas = factdist and
        mvfctmpr = timvcodi and
        nitecodi = factnit  and
        mvfcnit  = nitecodi and
        MVFCFEEA <= fefi    and
        mvfctmpr = fctmcdtm and
        FCTMCDGO = TMFCCDGO and
        TMFCineg = 'E'
   group by mvfctmpr, fctmcdgo,fctmineg,mvfcdist,mvfccodi,mvfcfeea
 union
   select distinct mvfctmpr timo,fctmcdgo grupo,fctmineg ineg,mvfcdist distc,mvfccodi codic,mvfcfeea fecha,NVL(SUM(DECODE(TIMVFCEG,'S',mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0),'s',mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0),'n',(-1)*(mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0)),'N',(-1)*(mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0)))),0) VALOR
     from moviflcj_sap,regppaga, nitero, tipmovim,flcjtipmov_sap,tipmovflcja_sap
   where mvfcesta in (1,2,3,8,9,10) and
         mvfcREPP = reppcodi and
         mvfcdrep = reppdist and
         MVFCTMPR = TIMVCODI and
         nitecodi = reppnit  and
         mvfcnit =nitecodi   AND
         MVFCFEEA <= fefi  and
         mvfctmpr = fctmcdtm and
         FCTMCDGO = TMFCCDGO and
                TMFCineg = 'E'
    GROUP BY mvfctmpr,fctmcdgo,fctmineg,mvfcdist,mvfccodi,mvfcfeea
  union
       select distinct mvfctmpr timo,fctmcdgo grupo,fctmineg ineg,mvfcdist distc,mvfccodi codic,mvfcfeea fecha,NVL(SUM(DECODE(TIMVFCEG,'S',mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0),'s',mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0),'n',(-1)*(mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0)),'N',(-1)*(mvfcvnet - nvl(mvfcvapl,0) - NVL(MVFCVAPP,0)))),0) VALOR
              from moviflcj_sap,nitero, tipmovim,flcjtipmov_sap,tipmovflcja_sap
              where mvfcesta in (1,2,3,8,9,10) and
                    mvfcREPP is null and
                    mvfcdrep is null and
                    mvfcfcso is null and
                    mvfcdfas is null and
                    MVFCTMPR = TIMVCODI  and
                  mvfcnit=nitecodi AND
               MVFCFEEA <= fefi and
         mvfctmpr = fctmcdtm and
         FCTMCDGO = TMFCCDGO and
         TMFCineg = 'E'
         GROUP BY mvfctmpr,fctmcdgo,fctmineg,mvfcdist,mvfccodi, mvfcfeea;



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

CURSOR cuegrereales(dtfeini DATE,dtfecfin DATE) IS
  SELECT  mvcbdist dist,mvcbcons cons,nvl(sum(MFMBVLOR),0) valor,FCTMCDGO grupo,mvcbtimv TIMO,fctmineg ineg,mvcbfeapl fecha,mvcbdisa disa,mvcbtmad tmad,mvcbcasi casi
    FROM  movicuba_sap,mvfcmvcb,moviflcj_sap,flcjtipmov_sap,tipmovflcja_sap
   WHERE  mvcbfeapl BETWEEN dtfeini AND dtfecfin
     AND  mvcbesta IN(1,2,3,6)
     AND  mvcbdist  = mfmbmvcbd
     AND  mvcbcons  = mfmbmvcbn
     AND  mfmbmvfcd = mvfcdist
     AND  mfmbmvfcn = mvfccodi
     AND  mvfctmpr  = fctmcdtm
     AND  fctmcdgo  = tmfccdgo
     AND  tmfcineg  = 'E'
   group by mvcbdist,mvcbcons,mvcbtimv,FCTMCDGO,fctmineg,mvcbfeapl,mvcbdisa,mvcbtmad,mvcbcasi
   ORDER BY mvcbdist,mvcbcons;

BEGIN
nuanoeval := nuanorfc;
numeseval := numesrfc;

-- Se borran los datos del a?o y mes a evaluar

 DELETE egreflcj WHERE ano = nuanoeval AND mes = numeseval AND func = nufunc;

 -- Se generan las fechas para las semanas

  -- Generamos fecha inicial mes
  dtfechinic  := TO_DATE('01/'||fsbmesletras(numeseval)||'/'||nuanoeval,'DD/MON/YYYY');
  dtfechfins1 := TO_DATE('07/'||fsbmesletras(numeseval)||'/'||nuanoeval,'DD/MON/YYYY');

  dtfechinic2 := TO_DATE('08/'||fsbmesletras(numeseval)||'/'||nuanoeval,'DD/MON/YYYY');
  dtfechfins2 := TO_DATE('14/'||fsbmesletras(numeseval)||'/'||nuanoeval,'DD/MON/YYYY');

  dtfechinic3 := TO_DATE('15/'||fsbmesletras(numeseval)||'/'||nuanoeval,'DD/MON/YYYY');
  dtfechfins3 := TO_DATE('21/'||fsbmesletras(numeseval)||'/'||nuanoeval,'DD/MON/YYYY');

  dtfechinic4 := TO_DATE('22/'||fsbmesletras(numeseval)||'/'||nuanoeval,'DD/MON/YYYY');
  -- Generamos fecha final mes
  SELECT last_day(dtfechinic4) INTO dtfechfins4 FROM dual;

 -- Se genera los egresos proyectados

 FOR i IN cudatos(dtfechfins4) LOOP
   IF i.fecha <= dtfechfins1 THEN
      INSERT INTO egreflcj(grupo,tipmov,ano,mes,distc,codic,sem1,sem2,sem3,sem4,flag,VARE,distb,consb,tipo,func)
             values(i.grupo,i.timo,nuanoeval,numeseval,i.distc,i.codic,i.valor,0,0,0,'E',0,-1,-1,i.ineg,nufunc);

     BEGIN
       INSERT INTO VCMVFLCJ(distc,codic) 
              VALUES(i.distc,i.codic);
     EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
       RAISE_APPLICATION_ERROR(-20017,'Registro Duplicado : Grupo : '||i.grupo||' Tipo_MOv : '||i.timo||' Mov_flcj : '||i.distc||'-'||i.codic);
      null;
     END;

    ELSIF i.fecha <= dtfechfins2 THEN

      INSERT INTO egreflcj(grupo,tipmov,ano,mes,distc,codic,sem2,sem1,sem4,sem3,flag,VARE,distb,consb,tipo,func)
                values(i.grupo,i.timo,nuanoeval,numeseval,i.distc,i.codic,i.valor,0,0,0,'E',0,-1,-1,i.ineg,nufunc);
     BEGIN
       INSERT INTO VCMVFLCJ(distc,codic) VALUES(i.distc,i.codic);
     EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
       RAISE_APPLICATION_ERROR(-20018,'Registro Duplicado : Grupo : '||i.grupo||' Tipo_MOv : '||i.timo||' Mov_flcj : '||i.distc||'-'||i.codic);
      null;
     END;

    ELSIF i.fecha <= dtfechfins3 THEN

      INSERT INTO egreflcj(grupo,tipmov,ano,mes,distc,codic,sem3,SEM1,SEM2,SEM4,flag,VARE,distb,consb,tipo,func)
             values(i.grupo,i.timo,nuanoeval,numeseval,i.distc,i.codic,i.valor,0,0,0,'E',0,-1,-1,i.ineg,nufunc);
      BEGIN
       INSERT INTO VCMVFLCJ(distc,codic) VALUES(i.distc,i.codic);
     EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
       RAISE_APPLICATION_ERROR(-20019,'Registro Duplicado : Grupo : '||i.grupo||' Tipo_MOv : '||i.timo||' Mov_flcj : '||i.distc||'-'||i.codic);
       null;
     END;
    ELSE

      INSERT INTO egreflcj(grupo,tipmov,ano,mes,distc,codic,sem4,sem1,sem2,sem3,flag,VARE,distb,consb,tipo,func)
                values(i.grupo,i.timo,nuanoeval,numeseval,i.distc,i.codic,i.valor,0,0,0,'E',0,-1,-1,i.ineg,nufunc);
      BEGIN
       INSERT INTO VCMVFLCJ(distc,codic) VALUES(i.distc,i.codic);
     EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
       RAISE_APPLICATION_ERROR(-20020,'Registro Duplicado : Grupo : '||i.grupo||' Tipo_MOv : '||i.timo||' Mov_flcj : '||i.distc||'-'||i.codic);
       null;
     END;
    END IF;
 END LOOP;
 
 FOR i IN (SELECT grupo,NVL(SUM(sem1),0) sem1,NVL(SUM(sem2),0) sem2,NVL(SUM(sem3),0) sem3,NVL(SUM(sem4),0) sem4 
             FROM egreflcj 
            WHERE ano = nuanoeval AND mes = numeseval AND tipo = 'E' AND func = nufunc 
            GROUP BY grupo) LOOP
   BEGIN
    SELECT NVL(SUM(sem1),0),NVL(SUM(sem2),0),NVL(SUM(sem3),0),NVL(SUM(sem4),0) 
      INTO nusem1,nusem2,nusem3,nusem4
      FROM egreflcj
     WHERE ano   = nuanoeval
       AND mes   = numeseval
       AND grupo = i.grupo
       AND tipo  = 'I'
       AND func  = nufunc;
    EXCEPTION
     WHEN no_data_found THEN
      nusem1 := 0;
      nusem2 := 0;
      nusem3 := 0;
      nusem4 := 0;
    END;
     INSERT INTO egreflcj(grupo,tipmov,ano,mes,distc,codic,sem4,sem1,sem2,sem3,flag,VARE,distb,consb,TIPO,func)
            values(i.grupo,-1,nuanoeval,numeseval,-1,-1,i.sem4-nusem4,i.sem1-nusem1,i.sem2-nusem2,i.sem3-nusem3,'A',0,-1,-1,'-',nufunc);
 END LOOP;
 
 FOR i IN cuegrereales(dtfechinic,dtfechfins4) LOOP
     INSERT INTO egreflcj(distb,consb,grupo,tipmov,ano,mes,distc,codic,sem4,sem1,sem2,sem3,flag,vare,disa,tmad,casi,TIPO,func)
                values(i.dist,i.cons,i.grupo,i.timo,nuanoeval,numeseval,-1,-1,0,0,0,0,'E',nvl(i.valor,0),i.disa,i.tmad,i.casi,i.ineg,nufunc);
    BEGIN
       INSERT INTO VCCBFLCJ(distb,codib) 
              VALUES(i.dist,i.cons);
     EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
       --RAISE_APPLICATION_ERROR(-20022,'Registro Duplicado : Grupo : '||i.grupo||' Tipo_MOv : '||i.timo||' Cta_Banc : '||i.distb||'-'||i.codib);
      null;
     END;
 END LOOP;
 
 FOR i IN (SELECT grupo,NVL(SUM(vare),0) vare 
             FROM egreflcj 
            WHERE ano = nuanoeval AND mes = numeseval AND tipo = 'E' AND func = nufunc 
            GROUP BY grupo) LOOP
  BEGIN
   SELECT NVL(SUM(vare),0) INTO nuvare
     FROM egreflcj
    WHERE ano = nuanoeval
      AND mes = numeseval
      AND grupo = i.grupo
      AND tipo = 'I'
      AND func = nufunc;
  EXCEPTION
   WHEN no_data_found THEN
    nuvare := 0;
   END;

     UPDATE egreflcj
        SET vare = (nvl(vare,0) + nvl(i.vare,0)) - nuvare
      WHERE ano = nuanoeval
        AND mes = numeseval
        AND grupo = i.grupo
        AND flag = 'A'
        AND func = nufunc;
     IF SQL%NOTFOUND THEN
       INSERT INTO egreflcj(grupo,tipmov,ano,mes,distc,codic,sem4,sem1,sem2,sem3,flag,vare,tipo,func)
                values(i.grupo,-1,nuanoeval,numeseval,-1,-1,0,0,0,0,'A',nvl(i.vare,0)-nuvare,'-',nufunc);
     END IF;
 END LOOP;
   DELETE VCMVFLCJ;
   DELETE VCCBFLCJ;
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

END PKFLUJOCAJA_SAP10;
/
