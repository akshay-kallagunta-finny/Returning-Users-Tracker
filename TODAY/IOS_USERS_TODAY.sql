WITH user_activity AS (
    SELECT DISTINCT
        ud.user_id,
        u.mobile_number,
        LOWER(ud.platform_type) AS platform,
        TO_TIMESTAMP(ud.last_login_at) AS login_time
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
		   'QkOgudA8imv5rmjqnYUbYQ=='
      )
      AND DATE(TO_TIMESTAMP(u.created_at)) <> CURRENT_DATE
),
per_user AS (
    SELECT
        ua.user_id,
        ua.mobile_number,
        MAX(ua.login_time) AS latest_login_time,
        MAX(CASE WHEN ua.platform = 'android' THEN 1 ELSE 0 END) AS has_android,
        MAX(CASE WHEN ua.platform = 'ios' THEN 1 ELSE 0 END) AS has_ios
    FROM user_activity ua
    GROUP BY ua.user_id, ua.mobile_number
)
SELECT
    user_id,
    mobile_number,
    latest_login_time
FROM per_user
WHERE has_android = 0 AND has_ios = 1
ORDER BY latest_login_time DESC;
