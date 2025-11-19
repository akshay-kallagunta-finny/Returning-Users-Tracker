WITH user_latest_login AS (
    SELECT 
        LOWER(ud.platform_type) AS platform,
        ud.user_id,
        DATE(MAX(TO_TIMESTAMP(ud.last_login_at))) AS login_date
    FROM user_device ud
    JOIN finny_user u 
        ON ud.user_id = u.id
    WHERE TO_TIMESTAMP(ud.last_login_at) IS NOT NULL
      AND u.status = 'ACTIVE'
      AND DATE(TO_TIMESTAMP(u.created_at)) <> DATE(TO_TIMESTAMP(ud.last_login_at))
      AND u.mobile_number NOT IN (
           'Id2zL44Xg7EzkXUgl09jjA==','DuviEuzu6FIrlIOYO9sK/g==',
           'zJCmL6/3v89YPNjGC4U/Ww==','GmnOMpVSM7TEWQZg8t1YIA==',
           'wn7IakrMnyo+MSqtKCMp2Q==','otyt6E2EBtwfLjVB3pMofw==',
           'MAjKu0PF3DQxdTkuDxnZ2w==','xLHMOd4X9PugdYNMT6nDIw==',
           'QkOgudA8imv5rmjqnYUbYQ==','WUq3N7SlBVZUobIUQqRTdw==',
           'jozHM+x+SuF4IHxc0y2F8Q==','jZbnm136HbQTKwyZcSNdrw==',
           'wlG/wwiQZZEqsnloy0/htA==','b9xxlAneiUk62KHD2f8klg=='
      )
    GROUP BY ud.user_id, LOWER(ud.platform_type)
)
SELECT 
    'Date' AS metric,
    TO_CHAR(CURRENT_DATE, 'Mon DD') AS "today",
    TO_CHAR(CURRENT_DATE - INTERVAL '1 day', 'Mon DD') AS "today-1",
    TO_CHAR(CURRENT_DATE - INTERVAL '2 day', 'Mon DD') AS "today-2",
    TO_CHAR(CURRENT_DATE - INTERVAL '6 day', 'Mon DD') || '–' || 
      TO_CHAR(CURRENT_DATE - INTERVAL '1 day', 'Mon DD') AS "last 7 days",
    TO_CHAR(CURRENT_DATE - INTERVAL '30 day', 'Mon DD') || '–' || 
      TO_CHAR(CURRENT_DATE - INTERVAL '1 day', 'Mon DD') AS "last 30 days",
    TO_CHAR(DATE '2025-08-16', 'Mon DD') || '–' || TO_CHAR(CURRENT_DATE, 'Mon DD') AS "total entries"

UNION ALL

-- Android Users
SELECT 
    'Android' AS metric,
    COUNT(DISTINCT CASE WHEN platform = 'android' AND login_date = CURRENT_DATE THEN user_id END)::text AS "today",
    COUNT(DISTINCT CASE WHEN platform = 'android' AND login_date = CURRENT_DATE - INTERVAL '1 day' THEN user_id END)::text AS "yesterday",
    COUNT(DISTINCT CASE WHEN platform = 'android' AND login_date = CURRENT_DATE - INTERVAL '2 day' THEN user_id END)::text AS "day_before_yesterday",
    COUNT(DISTINCT CASE WHEN platform = 'android' AND login_date BETWEEN CURRENT_DATE - INTERVAL '6 day' 
                                            AND CURRENT_DATE - INTERVAL '1 day' THEN user_id END)::text AS "last_7_days",
    COUNT(DISTINCT CASE WHEN platform = 'android' AND login_date BETWEEN CURRENT_DATE - INTERVAL '30 day' 
                                            AND CURRENT_DATE - INTERVAL '1 day' THEN user_id END)::text AS "last_30_days",
    COUNT(DISTINCT CASE WHEN platform = 'android' AND login_date >= DATE '2025-08-16' 
                                            AND login_date <= CURRENT_DATE THEN user_id END)::text AS "since_aug16"
FROM user_latest_login

UNION ALL

-- iOS Users
SELECT 
    'iOS' AS metric,
    COUNT(DISTINCT CASE WHEN platform = 'ios' AND login_date = CURRENT_DATE THEN user_id END)::text AS "today",
    COUNT(DISTINCT CASE WHEN platform = 'ios' AND login_date = CURRENT_DATE - INTERVAL '1 day' THEN user_id END)::text AS "yesterday",
    COUNT(DISTINCT CASE WHEN platform = 'ios' AND login_date = CURRENT_DATE - INTERVAL '2 day' THEN user_id END)::text AS "day_before_yesterday",
    COUNT(DISTINCT CASE WHEN platform = 'ios' AND login_date BETWEEN CURRENT_DATE - INTERVAL '6 day' 
                                           AND CURRENT_DATE - INTERVAL '1 day' THEN user_id END)::text AS "last_7_days",
    COUNT(DISTINCT CASE WHEN platform = 'ios' AND login_date BETWEEN CURRENT_DATE - INTERVAL '30 day' 
                                           AND CURRENT_DATE - INTERVAL '1 day' THEN user_id END)::text AS "last_30_days",
    COUNT(DISTINCT CASE WHEN platform = 'ios' AND login_date >= DATE '2025-08-16' 
                                           AND login_date <= CURRENT_DATE THEN user_id END)::text AS "since_aug16"
FROM user_latest_login;
