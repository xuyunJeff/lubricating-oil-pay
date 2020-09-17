SELECT
	count(1) total_pay_count,
	SUM(price) total_pay_sum,
	business_id,
	business_name,
	org_id,
	org_name,
	DATE_FORMAT(last_update, '%Y-%m-%d') result_date,
 now() last_update
FROM
	bill_out
WHERE
	bill_status = 2
GROUP BY
	business_id,
DATE_FORMAT(last_update, '%Y-%m-%d');