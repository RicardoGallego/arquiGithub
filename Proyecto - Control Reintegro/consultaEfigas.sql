      SELECT c.sesususc SUSCRIPTOR, c.sesuserv SERVICIO, SUM(sesusape) SLD_PENDIENTE, SUM(difesape) SLD_DIFERIDO, SUM(sesusape) + SUM(difesape) TOTAL_DEUDA
        FROM (SELECT sesususc, sesuserv, SUM(sesusape) sesusape, 0 difesape
                FROM servsusc 
               WHERE sesususc = &nuSuscri
               GROUP BY sesususc, sesuserv
              UNION ALL
              SELECT &nuSuscri sesususc, servcodi sesuserv, 0 sesusape, 0 difesape
                FROM servicio
               WHERE servcodi > -1
              UNION ALL
              SELECT difesusc sesususc, difeserv sesuserv, 0 sesusape, SUM(difesape) difesape
                FROM diferido
               WHERE difesusc = &nuSuscri
                 AND difesape > 0
               GROUP BY difesusc, difeserv) c
       GROUP BY c.sesususc, c.sesuserv
       ORDER BY c.sesuserv ASC;
