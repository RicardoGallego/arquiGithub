   SELECT * FROM ldc_regidepu
   WHERE terminal = 'PKWEB-BRILLA'
   ORDER BY fecha DESC;
   
   SELECT * FROM provedor
   WHERE 5300;
   
   
   
   
   
   
   select contdenu,contlonu,contnume
      from   contrato, cuadcont, titrcolo
      where  cuadcodi = 5300
      and    cuadescu = 4
      and    cuadclcu = 2
      and    contcuad = 5300
      and    contesco = 5
      and    nvl(CONTVACO,0)>nvl(CONTVAEJ,0)
      and    cuadcodi = contcuad
      and    ttcldnco = 70
      and    ttcllnco = 708
      --and    ttclcont = contnume
      and    ttcldepa = 70
      and    ttclloca = 708
     -- and    ttcltitr = nutitr
      and    ttclacti = 'S'
     /* and    ttclcuad =cuadcodi*/
      order by 1;
