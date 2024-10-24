delete from dwa_d_datum;

WITH RECURSIVE dates(date) AS (
    SELECT DATE('2000-01-01') -- Start date
    UNION ALL
    SELECT DATE(date, '+1 day')
    FROM dates
    WHERE date < date('now', '+20 day') -- End date
    ) 
    insert into dwa_d_datum
    select
    *
    ,CASE WHEN maand > 6 THEN (CAST(jaar AS integer))||'/'||(CAST(jaar AS integer) + 1)
        ELSE (CAST(jaar AS integer) - 1)||'/'||(CAST(jaar AS integer)) END AS seizoen
    ,CASE WHEN maand > 6 THEN 'voor' ELSE 'na' END AS winterstop
    from (
    select 
    date(date) datum
    ,cast(strftime('%Y', date) as integer) jaar
    ,cast(strftime('%m', date) as integer) maand
    from dates
    );