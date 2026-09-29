-- 1. ARCHITECTING USER BEHAVIOR LAYER SCHEMA
CREATE TABLE IF NOT EXISTS public.user_behavior_logs (
    log_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    session_id VARCHAR(50) NOT NULL,
    page_viewed VARCHAR(50) NOT NULL CHECK (page_viewed IN ('Homepage', 'Product Page', 'Cart Page', 'Checkout Page')),
    time_spent_seconds INT NOT NULL CHECK (time_spent_seconds >= 0),
    interaction_date DATE NOT NULL DEFAULT CURRENT_DATE
);

-- 2. CLEARING PREVIOUS LOG ENTRIES TO PREVENT COLLISION
TRUNCATE TABLE public.user_behavior_logs;

-- 3. INJECTING REAL-WORLD TRANSACTIONS
INSERT INTO public.user_behavior_logs (user_id, session_id, page_viewed, time_spent_seconds, interaction_date) VALUES
(1, 'SESS-101', 'Homepage', 45, '2026-09-20'),
(1, 'SESS-101', 'Product Page', 180, '2026-09-20'),
(1, 'SESS-101', 'Cart Page', 60, '2026-09-20'),
(1, 'SESS-101', 'Checkout Page', 120, '2026-09-20'),
(2, 'SESS-102', 'Homepage', 30, '2026-09-21'),
(2, 'SESS-102', 'Product Page', 240, '2026-09-21'),
(2, 'SESS-102', 'Cart Page', 95, '2026-09-21'), 
(3, 'SESS-103', 'Homepage', 15, '2026-09-22'),
(3, 'SESS-103', 'Product Page', 40, '2026-09-22'),
(4, 'SESS-104', 'Homepage', 20, '2026-09-22'),
(4, 'SESS-104', 'Product Page', 110, '2026-09-22'),
(4, 'SESS-104', 'Checkout Page', 90, '2026-09-22');

-- 4. MASTERing POWER BI DATA AGGREGATION MODEL ENGINE QUERY
SELECT 
    user_id,
    session_id,
    interaction_date,
    SUM(time_spent_seconds) AS total_session_time_seconds,
    MAX(CASE WHEN page_viewed = 'Homepage' THEN 1 ELSE 0 END) AS visited_homepage,
    MAX(CASE WHEN page_viewed = 'Product Page' THEN 1 ELSE 0 END) AS visited_product_page,
    MAX(CASE WHEN page_viewed = 'Cart Page' THEN 1 ELSE 0 END) AS visited_cart_page,
    MAX(CASE WHEN page_viewed = 'Checkout Page' THEN 1 ELSE 0 END) AS visited_checkout_page,
    CASE 
        WHEN MAX(CASE WHEN page_viewed = 'Checkout Page' THEN 1 ELSE 0 END) = 1 THEN 'VIP Converter'
        WHEN MAX(CASE WHEN page_viewed = 'Cart Page' THEN 1 ELSE 0 END) = 1 AND MAX(CASE WHEN page_viewed = 'Checkout Page' THEN 1 ELSE 0 END) = 0 THEN 'Cart Abandoner (High Risk)'
        ELSE 'Window Shopper (Low Intent)'
    END AS customer_behavior_segment
FROM public.user_behavior_logs
GROUP BY user_id, session_id, interaction_date;
