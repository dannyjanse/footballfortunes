-- dwa.f_vorm source

CREATE OR REPLACE VIEW dwa.f_vorm
AS WITH wedstrijden AS (
         SELECT dd.seizoen,
            dw.hometeam,
            dw.awayteam,
            fr.s_wedstrijd,
            fr.date,
            fr.fthg,
            fr.ftag,
            fr.hsh,
            fr.ash
           FROM dwa.f_resultaten fr
             LEFT JOIN dwa.d_wedstrijden dw ON fr.s_wedstrijd = dw.s_wedstrijd
             LEFT JOIN dwa.d_datum dd ON fr.date = dd.datum
        )
 SELECT row_number() OVER (PARTITION BY gr.team, gr.seizoen ORDER BY gr.date DESC) AS nr,
    gr.team,
    gr.grw,
    gr.srw,
    gr.seizoen,
    gr.hometeam,
    gr.awayteam,
    gr.s_wedstrijd,
    gr.date,
    gr.fthg,
    gr.ftag,
    gr.hsh,
    gr.ash,
    lag(gr.grw, 0) OVER (PARTITION BY gr.team, gr.seizoen ORDER BY gr.date) + lag(gr.grw, 1) OVER (PARTITION BY gr.team, gr.seizoen ORDER BY gr.date) + lag(gr.grw, 2) OVER (PARTITION BY gr.team, gr.seizoen ORDER BY gr.date) + lag(gr.grw, 3) OVER (PARTITION BY gr.team, gr.seizoen ORDER BY gr.date) AS gr,
    lag(gr.srw, 0) OVER (PARTITION BY gr.team, gr.seizoen ORDER BY gr.date) + lag(gr.srw, 1) OVER (PARTITION BY gr.team, gr.seizoen ORDER BY gr.date) + lag(gr.srw, 2) OVER (PARTITION BY gr.team, gr.seizoen ORDER BY gr.date) + lag(gr.srw, 3) OVER (PARTITION BY gr.team, gr.seizoen ORDER BY gr.date) AS sr
   FROM ( SELECT wedstrijden.hometeam AS team,
            wedstrijden.fthg - wedstrijden.ftag AS grw,
            wedstrijden.hsh - wedstrijden.ash AS srw,
            wedstrijden.seizoen,
            wedstrijden.hometeam,
            wedstrijden.awayteam,
            wedstrijden.s_wedstrijd,
            wedstrijden.date,
            wedstrijden.fthg,
            wedstrijden.ftag,
            wedstrijden.hsh,
            wedstrijden.ash
           FROM wedstrijden
        UNION
         SELECT wedstrijden.awayteam AS team,
            '-1'::integer::numeric * (wedstrijden.fthg - wedstrijden.ftag) AS grw,
            '-1'::integer::numeric * (wedstrijden.hsh - wedstrijden.ash) AS srw,
            wedstrijden.seizoen,
            wedstrijden.hometeam,
            wedstrijden.awayteam,
            wedstrijden.s_wedstrijd,
            wedstrijden.date,
            wedstrijden.fthg,
            wedstrijden.ftag,
            wedstrijden.hsh,
            wedstrijden.ash
           FROM wedstrijden
  ORDER BY 1, 8) gr;