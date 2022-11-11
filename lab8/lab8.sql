/* 
Процедура. Отримує id працівника, та тільки необхідні (та кількості кімнат) параметри для нерухомості
Робота: додає нерухомість в базу і назначає заданого робітника відповідальним за цю нерухомість(добавляє дані в табличку in_charge)
Виводить щось одне:
1. Помилка при невірних вхідних даних.
2. Помилка, якщо кількість спальней та ванних кімнат більша ніж загальна кількість кімнат
3. Помилка, якщо працівник не є рієлтором
4. Done якщо все добре

Алгоритм:
1)Перевірити чи існує працівник з заданою айді
2)Перевірити чи існує заданий тип нерухомості і чи нерухомості такого типу мають кімнати
3)Перевірити чи існує задане місто
4)Створити savepoint creating_estate
5)Додати нерухомість в базу
6)Створити savepoint making_given_employee_in_charge
7)Додати зв'язок між заданим робітником і тільки що добавленою в базу нерухомістю
8)Якщо задана загальна кількість кімнат менша за суму кількості спальней і ванних кімнат - відмінити роботу всіх пунктів між 5 і попереднім включно, закінчити роботу процедури і вивести помилку 2.
9)Якщо заданий працівник не є рієлтором - відмінити роботу всіх пунктів між 6 і попереднім включно, вивести помилку 3.
10) Якщо пункти 8,9 не відбулися - закомітити зміни
 */
DELIMITER //
CREATE PROCEDURE usp_test_transaction(IN default_employee_id INT, 
									  IN g_estate_name VARCHAR(128), 
									  IN g_estate_type_id SMALLINT, 
                                      IN g_city_id INT,
                                      IN g_street VARCHAR(45),
                                      IN g_floor_area DECIMAL(10,2),
                                      IN g_total_number_of_rooms INT,
                                      IN g_number_of_bedrooms INT,
                                      IN g_number_of_bathrooms INT,
									  IN g_estate_description TEXT)
BEGIN
    CASE
		WHEN (SELECT COUNT(*) FROM employee WHERE employee_id = default_employee_id) = 0 THEN  SELECT CONCAT('employee with id ', default_employee_id, ' does not exist') AS error_missing_employee;
		WHEN (SELECT COUNT(*) FROM estate_type WHERE estate_type_id = g_estate_type_id) = 0 THEN  SELECT CONCAT('estate type with id ', g_estate_type_id, ' does not exist') AS error_not_existing_estate_type;
		WHEN (g_estate_type_id = 3 OR g_estate_type_id = 4) THEN  SELECT 'given estate type cant have rooms' AS error_not_existing_estate_type;
		WHEN (SELECT COUNT(*) FROM city WHERE city_id = g_city_id) = 0 THEN  SELECT CONCAT('city with id ', g_city_id, ' does not exist') AS error_not_existing_city;
        ELSE SELECT "Done" AS status;
    END CASE;
    
	BEGIN
	START TRANSACTION;

	SAVEPOINT creating_estate;
	INSERT INTO estate_agency.estate SET estate_name = g_estate_name, 
	estate_type_id = g_estate_type_id, city_id = g_city_id, street = g_street, 
	floor_area = g_floor_area, total_number_of_rooms = g_total_number_of_rooms,
	number_of_bedrooms = g_number_of_bedrooms, number_of_bathrooms = g_number_of_bathrooms, estate_description = g_estate_description;

		
	SAVEPOINT making_given_employee_in_charge;
	INSERT INTO in_charge SET estate_id = (SELECT estate_id FROM estate ORDER BY estate_id DESC LIMIT 1), 
								employee_id = default_employee_id, date_from = CURRENT_DATE();

	IF ( (SELECT COUNT(*) FROM estate WHERE estate.estate_id = (SELECT estate_id FROM estate ORDER BY estate_id DESC LIMIT 1) 
	AND number_of_bedrooms + number_of_bathrooms > total_number_of_rooms) = 1) THEN 
		BEGIN
		SELECT "Error! Wrong room numbers provided " AS error_wrong_room_numbers;
		ROLLBACK TO creating_estate;
		END;
	END IF;
	
	IF ( (SELECT employee_role FROM employee WHERE employee_id = default_employee_id) <> 'Realtor' ) THEN 
		BEGIN
		SELECT CONCAT('employee with ', default_employee_id, ' does not have required role - Realtor, but estate was added') AS error_mismatch_employee_role;
		ROLLBACK TO making_given_employee_in_charge;
		END;
	END IF;
	COMMIT;
	END;
	
	
END//
DELIMITER ;



SELECT estate_id, estate_name FROM estate;

SELECT * FROM employee;

SELECT * FROM in_charge;
SELECT * FROM estate;

DELETE FROM in_charge WHERE estate_id >= 68;
DELETE FROM estate WHERE estate_id >= 68;

CALL usp_test_transaction(30, 'Best flat ever2', 1, 1, 'Victory street, 1', 100, 4, 2, 2, "Best flat ever");
DROP PROCEDURE usp_test_transaction;


-- Тестова транзакція яка показує розуміння START TRANSACTION COMMIT AND CHAIN ROLLBACK
START TRANSACTION;
UPDATE city SET city_name = 'Lutsk1' WHERE city_id = 25;
SELECT * FROM city WHERE city_id = 25;
COMMIT
AND CHAIN;
INSERT INTO city SET city_name = 'Lutsk2', country_id = 1;
SELECT * FROM city;
ROLLBACK;

SELECT * FROM city;

DELETE FROM city WHERE city_id >= 26;