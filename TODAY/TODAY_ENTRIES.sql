WITH user_activity AS (
    SELECT DISTINCT
        ud.user_id,
        LOWER(ud.platform_type) AS platform
    FROM user_device ud
    JOIN finny_user u ON ud.user_id = u.id
    WHERE TO_TIMESTAMP(ud.last_login_at) IS NOT NULL
      AND DATE(TO_TIMESTAMP(ud.last_login_at)) = CURRENT_DATE
      AND u.status = 'ACTIVE'  
      AND u.mobile_number NOT IN (
           'Id2zL44Xg7EzkXUgl09jjA==',
           'DuviEuzu6FIrlIOYO9sK/g==', 
           'zJCmL6/3v89YPNjGC4U/Ww==',
           'GmnOMpVSM7TEWQZg8t1YIA==',
           'wn7IakrMnyo+MSqtKCMp2Q==',
           'otyt6E2EBtwfLjVB3pMofw==',
           'MAjKu0PF3DQxdTkuDxnZ2w==',
           'xLHMOd4X9PugdYNMT6nDIw==',
           'QkOgudA8imv5rmjqnYUbYQ==',
		   'WUq3N7SlBVZUobIUQqRTdw==',
		   'jozHM+x+SuF4IHxc0y2F8Q==',
		   'jZbnm136HbQTKwyZcSNdrw==',
		   'wlG/wwiQZZEqsnloy0/htA==',
		   'b9xxlAneiUk62KHD2f8klg=='
      )
      AND DATE(TO_TIMESTAMP(u.created_at)) <> CURRENT_DATE
),
per_user AS (
    SELECT
        ua.user_id,
        MAX(CASE WHEN ua.platform = 'android' THEN 1 ELSE 0 END) AS has_android,
        MAX(CASE WHEN ua.platform = 'ios' THEN 1 ELSE 0 END) AS has_ios
    FROM user_activity ua
    GROUP BY ua.user_id
)
SELECT
    TO_CHAR(CURRENT_DATE, 'Mon DD') AS date,
    COUNT(*) AS "#",
    SUM(CASE WHEN has_android = 1 AND has_ios = 0 THEN 1 ELSE 0 END) AS "#android",
    SUM(CASE WHEN has_android = 0 AND has_ios = 1 THEN 1 ELSE 0 END) AS "#ios",
    SUM(CASE WHEN has_android = 1 AND has_ios = 1 THEN 1 ELSE 0 END) AS "android&ios"
FROM per_user;

