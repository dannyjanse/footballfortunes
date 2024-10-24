WITH aantal AS (
select
seizoen, count(rea_odd) aantal_bets
FROM KUBUS_analysebestand
GROUP BY 1
),
resultaat AS (
SELECT 
seizoen, sum(rea_odd) rea_odd
FROM (SELECT * FROM KUBUS_analysebestand WHERE ftr = 'H')
GROUP BY 1
)
SELECT aantal.seizoen, aantal_bets, rea_odd, rea_odd/aantal_bets rendement
FROM aantal
LEFT JOIN resultaat
 ON aantal.seizoen = resultaat.seizoen
WHERE aantal_bets > 0
UNION 
SELECT 
'totaal'
,sum(aantal_bets) aantal_bets, sum(rea_odd) rea_odd, sum(rea_odd)/sum(aantal_bets) rendement
FROM aantal
LEFT JOIN resultaat
 ON aantal.seizoen = resultaat.seizoen
ORDER BY aantal.seizoen

