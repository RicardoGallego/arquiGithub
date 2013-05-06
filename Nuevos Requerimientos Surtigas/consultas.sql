 SELECT cucocodi, cuconuse, p.pefafepa
   FROM cuencobr c,perifact p
  WHERE  cuconuse          = 1048549
    AND cucoprog          = 'FGCC'
    AND c.cucopefa        = p.pefacodi
    AND c.cucocicl        = p.pefacicl
    AND c.cucoano         = p.pefaano
    AND c.cucomes         = p.pefames
    AND trunc(p.pefafepa) > '01/01/2012'
    ORDER BY p.pefafepa desc;
              
 
 SELECT * FROM suscripc;
 
 --<<
 -- Procedimiento para ralizar el DataCredito de forma manual 
 -->>

 SELECT a.*
    FROM (SELECT *
            FROM vadacre v
           WHERE v.vdtcnuse = 3025726
             AND v.vdtciden = 64551895
           ORDER BY v.vdtcfeco DESC) a
   WHERE ROWNUM < 2;   
   
   
   SELECT a.vdtciden, a.vdtcnuse, a.vdtcsusc,
          a.vdtcnom, a.vdtcusua, a.vdtcmaq,
          a.vdtcfeco, REPLACE(a.vdtdpapel, '/', 'N') vdtdpapel,
          a.vdtccpve, a.vdtcgene, a.vdtcfeex,
          a.vdtcciud, a.vdtcdepa, a.vdtcedad,
          a.vdtcesta 
     FROM (SELECT *
             FROM vadacre v
            WHERE v.vdtcnuse = 3025726
              AND v.vdtciden = 64551895
            ORDER BY v.vdtcfeco DESC) a
    WHERE ROWNUM < 2;
    
  SELECT sesususc
    FROM servsusc
   WHERE sesunuse = 3025726;
   
   
   SELECT paravanu FROM parametr
   WHERE paracodi = 'FNB_TIEMPO';
   
   SELECT paravast FROM parametr
   WHERE paracodi = 'FNB_DATACREDITO';
 
 
 SELECT (SYSDATE - (SELECT a.vdtcfeco
            FROM (SELECT *
                    FROM vadacre v
                   WHERE v.vdtcnuse = 3025726
                     AND v.vdtciden = 64551895
                   ORDER BY v.vdtcfeco DESC) a	
   WHERE ROWNUM < 2) ) FROM dual;  
   
   
 SELECT * FROM ciudad c
  WHERE c.ciudnomb = 'SINCELEJO';  
 
 SELECT * FROM departamentos d
  WHERE d.nombre = 'SUCRE';
  
--<<
--
-->>


SELECT /*+ rule*/ 
       UNIQUE(prfncuad) cuadrilla, cu.cuadnomb nombre
   FROM tivtafnb tv, prprofnb pp, cuadcont cu, contrato co
  WHERE pp.prfntivt = tv.tifncodi
    AND pp.prfncuad = cu.cuadcodi
    AND cu.cuadcodi = co.contcuad
    AND NVL(co.contvaco,0) > NVL(co.contvaej,0)
    AND tv.tifncodi = 7
    AND NVL(pp.prfnacti, 'S') = 'S'
    AND cu.cuadescu = 4
    AND co.contesco = 5;  
    
 
SELECT * FROM prprofnb;   

  
  
  SELECT * FROM tecnico;
  
  SELECT tecncodi, tecnnomb, c.cuadcodi
    FROM tecnico t, cuadcont c
   WHERE t.tecncuad = c.cuadcodi
     AND upper(t.tecnnomb) LIKE '%WEB%'
  

SELECT * FROM VADAINT
WHERE vdinuse = 3025726;  

SELECT * FROM Vadacre
WHERE vdtcnuse = 3025726;

SELECT * FROM novalida_datacredito
WHERE cpve = 10048350;



SELECT * FROM ventafnb;


SELECT vefncpve, sesususc, sesunuse, vefncopr, vefncove, 
         vefnvavt, vefnvain, vefnCLvt, vefndepa,
         vefnloca, vefncodi, vefnfepr, vefnnucu,
         vefntafi, vefnocin
    FROM ventafnb v, suscripc a, servsusc s
   WHERE sesususc = susccodi
     --AND sesunuse = 1046297
     AND vefnsega = 1048549
     --AND vefndepa = 70
     --AND vefnloca = 708
     --AND vefncodi = 2071387
     --AND vefncpve = 10048522
     
     --AND vefncodi = 10048522
     --AND vefncpve = 2071387
     
     
     
     SELECT /*+ rule*/ 
       UNIQUE(prfncuad) cuadrilla, cu.cuadnomb nombre
   FROM tivtafnb tv, prprofnb pp, cuadcont cu, contrato co
  WHERE pp.prfntivt = tv.tifncodi
    AND pp.prfncuad = cu.cuadcodi
    AND cu.cuadcodi = co.contcuad
    AND NVL(co.contvaco,0) > NVL(co.contvaej,0)
    AND tv.tifncodi = 3100
    AND NVL(pp.prfnacti, 'S') = 'S'
    AND cu.cuadescu = 4
    AND co.contesco = 5;
     
     AND vefncopr = 5300 ;
     
     
     
     
     
     
     
      select contdenu,contlonu,contnume
      from   contrato, cuadcont, titrcolo
      where  cuadcodi = nucuad
      and    cuadescu = 4
      and    cuadclcu = nuclase
      and    contcuad = nuCUAD
      and    contesco = 5
      and    nvl(CONTVACO,0)>nvl(CONTVAEJ,0)
      and    cuadcodi = contcuad
      and    ttcldnco = contdenu
      and    ttcllnco = contlonu
      and    ttclcont = contnume
      and    ttcldepa = nudepa
      and    ttclloca = nuloca
      and    ttcltitr = nutitr
      and    ttclacti = 'S'
      and    ttclcuad =cuadcodi
      order by 1;
      --PARA REVISION VALOR DE IVA
      CURSOR CUPRODUCTOSIVA IS
      SELECT *
      FROM VEDTFNB
      WHERE VEFNDEPA=NUVTADEPA
      AND   VEFNLOCA=NUVTALOCA
      AND   VEFNCODI=NUVTA;

