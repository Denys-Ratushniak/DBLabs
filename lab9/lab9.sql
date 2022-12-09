-- Валідація пошти і номеру телефону при створенні клієнта.
DELIMITER //
CREATE FUNCTION validate_phone (phone VARCHAR(32)) RETURNS VARCHAR(32)
DETERMINISTIC
BEGIN 
	IF (phone NOT REGEXP '^[+]{1,1}[0-9]{5,29}$') THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid mobile phone';
		RETURN 'invalid phone';
	ELSE RETURN phone;
	END IF;
END//
DELIMITER ;

DROP FUNCTION validate_phone;

DROP TRIGGER client_insert;

CREATE
  TRIGGER client_insert BEFORE INSERT
  ON estate_agency.client FOR EACH ROW
  SET NEW.mail = validate_email(NEW.mail), NEW.mobile_phone = validate_phone(NEW.mobile_phone);


START TRANSACTION;
INSERT INTO client SET client_name = 'beb', mobile_phone = '+380', mail = 'beb@gmail.com';
INSERT INTO client SET client_name = 'beb', mobile_phone = '+380961526736', mail = 'beb@gmail.';
INSERT INTO client SET client_name = 'beb', mobile_phone = '380961526736', mail = 'beb';
INSERT INTO client SET client_name = 'beb', mobile_phone = '+380961526736', mail = 'beb@gmail.com';
SELECT client_id, client_name, mobile_phone, mail FROM client;
ROLLBACK;

DELETE FROM client WHERE client_id = 22;

-- При видаленні певної частоти оплати, всі контракти, які її мали, переходять на якусь дефолтну частоту, наприклад разовий платіж

DROP TRIGGER payment_frequency_delete;

CREATE
  TRIGGER payment_frequency_delete BEFORE DELETE
  on payment_frequency FOR EACH ROW
  UPDATE contract SET payment_frequency_id = 4 WHERE payment_frequency_id = OLD.payment_frequency_id;

START TRANSACTION;
SET FOREIGN_KEY_CHECKS=0;
INSERT INTO payment_frequency SET payment_frequency_name = "3 times per month";
INSERT INTO contract SET employee_id = 20, contract_type = 'mediation (buying/selling)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = '3 times per month'), number_of_invoices = 5, payment_amount = 30000.00, fee_percentage = 5.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-01-01', signed_date = '2022-01-01';
SELECT * FROM payment_frequency;
SELECT contract_id, employee_id, contract_type, payment_frequency_id FROM contract;
DELETE FROM payment_frequency WHERE payment_frequency_name = "3 times per month";
-- DELETE FROM payment_frequency WHERE payment_frequency_id >= 5;
SELECT * FROM payment_frequency;
SELECT contract_id, employee_id, contract_type, payment_frequency_id FROM contract;
SET FOREIGN_KEY_CHECKS=1;
ROLLBACK;

-- При видаленні робітника, усі дати date_to, до яких робітник мав відповідати за нерухомість, змінюються на поточну дату 
SELECT * FROM in_charge;


DROP TRIGGER update_employee;
CREATE 
  TRIGGER update_employee AFTER UPDATE
  on employee FOR EACH ROW
  UPDATE in_charge SET date_to = CURDATE()
  WHERE in_charge.employee_id = NEW.employee_id
  AND NEW.employee_live_status = 'deleted';
  
START TRANSACTION;
SELECT employee_id, first_name, last_name, employee_live_status FROM employee;
SELECT * FROM in_charge;
UPDATE employee SET employee_live_status = 'deleted' WHERE employee_id = 28;
SELECT employee_id, first_name, last_name, employee_live_status FROM employee;
SELECT * FROM in_charge;
ROLLBACK;







