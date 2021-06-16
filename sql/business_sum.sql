SELECT
    count(1) total_pay_count,
    SUM(price) total_pay_sum,
    business_id,
    business_name,
    org_id,
    org_name,
    DATE_FORMAT(DATE_ADD(last_update,INTERVAL 8 HOUR), '%Y-%m-%d') result_date
FROM
    bill_out
WHERE
        bill_status = 2
GROUP BY
    business_id,
    DATE_FORMAT(DATE_ADD(last_update,INTERVAL 8 HOUR), '%Y-%m-%d')
ORDER BY result_date desc;


SELECT
    count(1) total_pay_count,
    SUM(price) total_pay_sum,
    merchant_id,
    merchant_name,
    org_id,
    org_name,
    DATE_FORMAT(DATE_ADD(last_update,INTERVAL 8 HOUR), '%Y-%m-%d') result_date
FROM
    bill_out
WHERE
    bill_status = 2
GROUP BY
    merchant_id,
    DATE_FORMAT(DATE_ADD(last_update,INTERVAL 8 HOUR), '%Y-%m-%d')
ORDER BY result_date desc;