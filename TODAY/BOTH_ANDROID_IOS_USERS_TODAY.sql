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
user_platform_usage AS (
    SELECT
        user_id,
        MAX(CASE WHEN platform = 'android' THEN 1 ELSE 0 END) AS has_android,
        MAX(CASE WHEN platform = 'ios' THEN 1 ELSE 0 END) AS has_ios
    FROM user_activity
    GROUP BY user_id
),
latest_platform AS (
    SELECT 
        user_id,
        platform,
        login_time,
        mobile_number
    FROM (
        SELECT
            user_id,
            platform,
            login_time,
            mobile_number,
            ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY login_time DESC) AS rn
        FROM user_activity
    ) ranked
    WHERE rn = 1
),
final_users AS (
    SELECT
        up.user_id,
        lp.mobile_number,
        lp.login_time AS last_login_time,
        lp.platform AS latest_platform,
        CASE 
            WHEN up.has_android = 1 AND up.has_ios = 0 THEN 'android_only'
            WHEN up.has_android = 0 AND up.has_ios = 1 THEN 'ios_only'
            WHEN up.has_android = 1 AND up.has_ios = 1 THEN 'both_android_ios'
        END AS user_category
    FROM user_platform_usage up
    JOIN latest_platform lp ON lp.user_id = up.user_id
)
SELECT
    user_id,
    mobile_number,
    last_login_time,
    latest_platform
FROM final_users
WHERE user_category = 'both_android_ios'
ORDER BY last_login_time DESC;