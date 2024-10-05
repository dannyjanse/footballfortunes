def d_datum(psy_connection):

    print('transform & load d_datum gestart')
    psy_cursor = psy_connection.cursor()
        
    psy_cursor.execute(
    """
    DELETE FROM dwa_d_datum;                     
    """)

    psy_cursor.execute(
    """
    INSERT INTO dwa_d_datum 
    WITH RECURSIVE dates(date) AS (
    SELECT DATE('2009-01-01') -- Start date
    UNION ALL
    SELECT DATE(date, '+1 day')
    FROM dates
    WHERE date < date('now', '+20 day') -- End date
    )
    SELECT 
    *
    ,CASE WHEN maand > 6 THEN (CAST(jaar AS integer))||'/'||(CAST(jaar AS integer) + 1)
        ELSE (CAST(jaar AS integer) - 1)||'/'||(CAST(jaar AS integer)) END AS seizoen
    ,CASE WHEN maand > 6 THEN 'voor' ELSE 'na' END AS winterstop
    FROM (
        SELECT 
        *
        ,strftime('%Y', datum) jaar
        ,strftime('%m', datum) maand
        FROM (
            SELECT
            date(date) datum
            FROM dates)
    );                    
    """)
    
    psy_connection.commit()  
                            
    print('transform & load d_datum gereed')
