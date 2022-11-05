-- ПОЧАТОК Визначити скільки контрактів підписав робітник від компанії за певний проміжок часу
DELIMITER //
CREATE PROCEDURE signed_contracts_in_range (IN name_ VARCHAR(45), IN surname VARCHAR(45), IN date1 DATE, IN date2 DATE, OUT employee_name VARCHAR(91), OUT amount INT)
	BEGIN
		DECLARE error_date VARCHAR(40);
		DECLARE error_exist VARCHAR(40);
		SET error_date = 'Некоректно задані дати';
		SET error_exist = 'Не існує такого робітника в базі';
        
        CASE
			WHEN (SELECT COUNT(*) FROM employee WHERE first_name = name_ AND last_name = surname) = 0 THEN SELECT error_exist;
            WHEN date1 > date2 THEN SELECT error_date;
            ELSE
				BEGIN
                SET employee_name = CONCAT(name_, ' ', surname);
				SET amount = (SELECT COUNT(*)
					FROM employee e INNER JOIN contract c
					ON e.first_name = name_ AND e.last_name = surname
					AND e.employee_id = c.employee_id
					WHERE c.signed_date BETWEEN date1 AND date2);
				END;
        END CASE;
	END// 
DELIMITER ;
    
    
SELECT * FROM contract
WHERE employee_id = 29;
SELECT * FROM employee
WHERE employee_id >= 20;

CALL signed_contracts_in_range('Olesya', 'Kravets', '2000-01-01', '2032-01-01', @employee_name, @amount);
SELECT @employee_name, @amount;
CALL signed_contracts_in_range('Vita', 'Tretyak', '2022-05-01', '2022-10-11', @employee_name, @amount);
SELECT @employee_name, @amount;
CALL signed_contracts_in_range('Vladyslava', 'Savchenko', '2000-01-01', '2022-01-01', @employee_name, @amount);
SELECT @employee_name, @amount;
CALL signed_contracts_in_range('Vladyslavaaaa', 'Savchenkoooo', '2000-01-01', '2022-01-01', @employee_name, @amount);
CALL signed_contracts_in_range('Vladyslava', 'Savchenko', '2033-01-01', '2022-01-01', @employee_name, @amount);

DROP PROCEDURE IF EXISTS signed_contracts_in_range;

-- КІНЕЦЬ Визначити скільки контрактів підписав робітник від компанії за певний проміжок часу

-- ПОЧАТОК Додати рядок в таблицю client_contract, або вивести помилку якщо роль клієнта не є допустимою в типі заданого контракту
DELIMITER //
CREATE PROCEDURE insert_client_contract (IN client_id_in INT, IN contract_id_in INT, IN client_role_in ENUM('tenant', 'landlord', 'buyer', 'seller'))
	BEGIN
		DECLARE mismatch_error CHAR(1);
        DECLARE contract_type_in VARCHAR(40);
		SELECT contract_type INTO contract_type_in FROM contract WHERE contract.contract_id = contract_id_in;
        CASE 
			WHEN (client_role_in = 'tenant' AND contract_type_in <> 'renting out(to a customer)' AND contract_type_in <> 'mediation (renting out/leasing)') THEN SET mismatch_error = '1';
			WHEN (client_role_in = 'landlord' AND contract_type_in <> 'mediation (renting out/leasing)') THEN SET mismatch_error = '1';
			WHEN (client_role_in = 'buyer' AND contract_type_in <> 'selling (to a customer)' AND contract_type_in <> 'mediation (buying/selling)') THEN SET mismatch_error = '1';
			WHEN (client_role_in = 'seller' AND contract_type_in <> 'buying (to a customer)' AND contract_type_in <> 'mediation (buying/selling)') THEN SET mismatch_error = '1';
            ELSE SET mismatch_error = '0';
        END CASE;
        IF(error = '1') THEN SELECT CONCAT(client_role_in, ' cannot be in ', contract_type_in, ' type of contract') AS mismatch_error;
        ELSE 
			BEGIN
				INSERT INTO client_contract SET client_id = client_id_in, contract_id = contract_id_in, client_role = client_role_in;
                SELECT 'done';
            END;
        END IF;
        
	END// 
    DELIMITER;
    
INSERT INTO contract SET employee_id = 24, contract_type = 'mediation (renting out/leasing)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'Once a month'), number_of_invoices = 12, payment_amount = 1500.00, fee_percentage = 3.50, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-05-01', end_date = '2023-05-01', signed_date = '2022-05-02';
SELECT COUNT(*) FROM contract;

CALL insert_client_contract(1, 33, 'seller');
CALL insert_client_contract(1, 33, 'tenant');
DELETE FROM client_contract WHERE client_id = 1 AND contract_id = 33;

SELECT * FROM client_contract;

DROP PROCEDURE IF EXISTS insert_client_contract;


SELECT contract_type FROM contract WHERE contract.contract_id = 33;
-- КІНЕЦЬ Додати рядок в таблицю client_contract, або вивести помилку якщо роль клієнта не є допустимою в типі заданого контракту

-- ПОЧАТОК Валідація пошти, у випадку недопустимої пошти вивести помилку
DELIMITER //
CREATE FUNCTION validate_email (email VARCHAR(323)) RETURNS VARCHAR(323)
DETERMINISTIC
BEGIN 
	IF (email NOT REGEXP '^[a-zA-Z0-9][a-zA-Z0-9._-]*[a-zA-Z0-9._-]@[a-zA-Z0-9][a-zA-Z0-9._-]*[a-zA-Z0-9]\\.[a-zA-Z]{2,63}$') THEN
		RETURN 'invalid email';
	ELSE RETURN LOWER(email);
	END IF;
END//

DELIMITER ;
CREATE TEMPORARY TABLE `mail`(
	mail VARCHAR(30)
);

INSERT INTO `mail` SET mail = 'example';
INSERT INTO `mail` SET mail = 'example@';
INSERT INTO `mail` SET mail = 'example@gmail.com';

DROP TABLE `mail`;
DROP FUNCTION IF EXISTS validate_email;

SELECT validate_email(mail) FROM mail;
-- КІНЕЦЬ Валідація пошти, у випадку недопустимої пошти вивести помилку