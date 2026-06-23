-- =============================================
-- Restaurant — Footfall EDA
-- Database: Restaurant_Sales
-- =============================================

-- 1. Overall average walk-ins
SELECT 
    ROUND(AVG(walk_ins), 1) AS overall_avg_walk_ins
FROM fact_bookings;

-- 2. Average walk-ins by day of week
SELECT 
    d.day_name,
    d.day_of_week,
    ROUND(AVG(b.walk_ins), 1) AS avg_walk_ins,
    COUNT(*) AS days_recorded
FROM fact_bookings b
JOIN dim_date d ON b.date_key = d.date_key
GROUP BY d.day_of_week, d.day_name
ORDER BY d.day_of_week;

-- 3. Average walk-ins by month
SELECT 
    d.month_name,
    d.month_number,
    ROUND(AVG(b.walk_ins), 1) AS avg_walk_ins,
    ROUND(STDDEV(b.walk_ins), 2) AS std_dev,
    COUNT(*) AS days_recorded
FROM fact_bookings b
JOIN dim_date d ON b.date_key = d.date_key
GROUP BY d.month_number, d.month_name
ORDER BY d.month_number;

-- 4. Top 10 worst weather days (high rain, low temp) and walk-ins
SELECT 
    d.full_date,
    d.day_name,
    w.rain_in,
    w.max_temp_c,
    b.walk_ins
FROM fact_bookings b
JOIN dim_date d ON b.date_key = d.date_key
JOIN dim_weather w ON b.date_key = w.date_key
WHERE w.rain_in > 0
ORDER BY w.rain_in DESC, w.max_temp_c ASC
LIMIT 10;

-- 5. Top 10 best weather days (no rain, high temp) and walk-ins
SELECT 
    d.full_date,
    d.day_name,
    w.rain_in,
    w.max_temp_c,
    b.walk_ins
FROM fact_bookings b
JOIN dim_date d ON b.date_key = d.date_key
JOIN dim_weather w ON b.date_key = w.date_key
WHERE w.rain_in = 0
ORDER BY w.max_temp_c DESC
LIMIT 10;

-- 6. Average walk-ins: worst vs best weather days (key headline stat)
SELECT 
    'Worst 10 Weather Days' AS weather_group,
    ROUND(AVG(walk_ins), 1) AS avg_walk_ins
FROM (
    SELECT b.walk_ins, w.rain_in, w.max_temp_c
    FROM fact_bookings b
    JOIN dim_weather w ON b.date_key = w.date_key
    WHERE w.rain_in > 0
    ORDER BY w.rain_in DESC, w.max_temp_c ASC
    LIMIT 10
) worst

UNION ALL

SELECT 
    'Best 10 Weather Days' AS weather_group,
    ROUND(AVG(walk_ins), 1) AS avg_walk_ins
FROM (
    SELECT b.walk_ins, w.rain_in, w.max_temp_c
    FROM fact_bookings b
    JOIN dim_weather w ON b.date_key = w.date_key
    WHERE w.rain_in = 0
    ORDER BY w.max_temp_c DESC
    LIMIT 10
) best;

-- 7. Walk-ins by temperature band
SELECT 
    CASE 
        WHEN w.max_temp_c < 10 THEN 'Cold (<10°C)'
        WHEN w.max_temp_c BETWEEN 10 AND 18 THEN 'Mild (10–18°C)'
        WHEN w.max_temp_c > 18 THEN 'Warm (>18°C)'
    END AS temp_band,
    ROUND(AVG(b.walk_ins), 1) AS avg_walk_ins,
    COUNT(*) AS days
FROM fact_bookings b
JOIN dim_weather w ON b.date_key = w.date_key
GROUP BY temp_band
ORDER BY MIN(w.max_temp_c);

-- 8. Walk-ins by rain band
SELECT 
    CASE 
        WHEN w.rain_in = 0 THEN 'Dry'
        WHEN w.rain_in < 0.3 THEN 'Light Rain'
        WHEN w.rain_in >= 0.3 THEN 'Heavy Rain'
    END AS rain_band,
    ROUND(AVG(b.walk_ins), 1) AS avg_walk_ins,
    COUNT(*) AS days
FROM fact_bookings b
JOIN dim_weather w ON b.date_key = w.date_key
GROUP BY rain_band
ORDER BY MIN(w.rain_in);

-- 9. Payday Friday uplift
SELECT 
    d.is_payday,
    ROUND(AVG(b.walk_ins), 1) AS avg_walk_ins,
    COUNT(*) AS days
FROM fact_bookings b
JOIN dim_date d ON b.date_key = d.date_key
WHERE d.day_name = 'Friday'
GROUP BY d.is_payday;

-- 10. September vs overall — standard deviation context
SELECT 
    d.month_name,
    ROUND(AVG(b.walk_ins), 1) AS avg_walk_ins,
    ROUND(STDDEV(b.walk_ins), 2) AS std_dev
FROM fact_bookings b
JOIN dim_date d ON b.date_key = d.date_key
WHERE d.month_number = 9
GROUP BY d.month_name

UNION ALL

SELECT 
    'All Months' AS month_name,
    ROUND(AVG(walk_ins), 1) AS avg_walk_ins,
    ROUND(STDDEV(walk_ins), 2) AS std_dev
FROM fact_bookings;

-- 11. Calendar events impact on walk-ins
SELECT 
    ce.event_name,
    ce.event_type,
    ROUND(AVG(b.walk_ins), 1) AS avg_walk_ins_during_event,
    COUNT(DISTINCT d.date_key) AS event_days
FROM fact_bookings b
JOIN dim_date d ON b.date_key = d.date_key
JOIN dim_calendar_event ce 
    ON d.date_key BETWEEN ce.start_date_key AND ce.end_date_key
GROUP BY ce.event_name, ce.event_type
ORDER BY avg_walk_ins_during_event DESC;


