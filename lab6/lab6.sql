-- 1 Вивести всіх клієнтів, номери телефонів яких починаються на +38096 або +38097 у алфавітному порядку
SELECT client_id 
, client_name
, mobile_phone
FROM client
WHERE mobile_phone LIKE '+38097%' 
OR mobile_phone LIKE '+38096%' 
ORDER BY client_name ASC;
SELECT * FROM client;

-- 2 Визначити 7 накладних, які були створенні найпізніше
SELECT * FROM contract_invoice ORDER BY date_created DESC LIMIT 7;
SELECT * FROM contract_invoice;

-- 3 Визначити всю нерухомість(за яку відповідає працівник, і ця нерухомість знаходиться під контрактом) 
SELECT estate.estate_id, in_charge.employee_id, under_contract.contract_id
FROM (in_charge INNER JOIN estate) INNER JOIN under_contract
ON estate.estate_id = under_contract.estate_id
AND in_charge.estate_id = estate.estate_id
GROUP BY estate.estate_id;
SELECT * FROM estate;

-- 4 Визначити для кожного типу контракту кількість контрактів, які розпочали(розпочинали) діяти за останній місяць
SELECT contract_type
, COUNT(*)
FROM contract
WHERE DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH) <= start_date
GROUP BY contract_type;

SELECT * FROM contract
ORDER BY start_date ASC;
-- check

-- 5 Визначити скільки платежів було проведено за кожен місяць кожного року
-- Визначити сумарно кількість платежів за кожен рік, та загальну кількість усіх платежів
SELECT YEAR(date_paid) AS year, MONTHNAME(date_paid) AS month,
COUNT(contract_id) AS invoice
FROM contract_invoice 
GROUP BY year, month WITH ROLLUP;

-- 6 Визначити середній рейтинг працівників, які відповідають за нерухомість
-- Згрупувати по віку, вивести в порядку зростання віку
SELECT employee_age
,AVG(rating)
FROM employee INNER JOIN in_charge 
ON employee.employee_id = in_charge.employee_id
GROUP BY employee_age
ORDER BY employee_age ASC;

-- 7 Визначити користувача який заплатив найбільше коштів кожного місяця кожного року
-- Вивести в порядку зростання року, місяця, заплачених коштів
SELECT year, month, month_num, money_spent, bestcustomer
FROM(
	SELECT YEAR(ci.date_paid) AS year
    , monthname(ci.date_paid) AS month
    , c.client_name AS bestcustomer,
	month(ci.date_paid) AS month_num 
    , (SUM(ci.invoice_amount)) AS money_spent
	FROM client c INNER JOIN contract_invoice ci
	ON c.client_name = ci.issued_to
	GROUP BY year, month, bestcustomer
	ORDER BY year, month_num, money_spent DESC ) 
x GROUP BY year, month;


-- 8 Визначити усіх клієнтів, та за наявності номер контракту у якому вони брали участь
SELECT c.client_id
, c.client_name
, cc.contract_id
FROM client c LEFT JOIN client_contract cc
ON c.client_id = cc.client_id;

-- 9 Визначити для кожного типу нерухомості середнє значення вартості 1 квадратного метру

SELECT estate_type_id
, CONCAT('$', FORMAT(AVG(((payment_amount + fee_amount) * number_of_invoices) / estate.floor_area), 2)) as average_money_per_square_meter
FROM (estate INNER JOIN under_contract) INNER JOIN contract
ON estate.estate_id = under_contract.estate_id
AND under_contract.contract_id = contract.contract_id
GROUP BY estate.estate_type_id;