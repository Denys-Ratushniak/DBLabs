SELECT * FROM in_charge;

DELIMITER //
CREATE FUNCTION test() RETURNS BOOLEAN
DETERMINISTIC
BEGIN 
	DECLARE ANS BOOL;
	SELECT EXISTS (SELECT contract.contract_id, client_contract.client_role
	FROM country 
	INNER JOIN city ON (country.country_id = city.country_id)
	INNER JOIN estate ON (city.city_id = estate.city_id)
	INNER JOIN under_contract ON (estate.estate_id = under_contract.estate_id)
	INNER JOIN contract ON (under_contract.contract_id = contract.contract_id)
	INNER JOIN client_contract ON (contract.contract_id = client_contract.contract_id)
	INNER JOIN client ON (client_contract.client_id = client.client_id)
	WHERE client.client_name = 'Denys Ratushniak'
	AND country.country_name = 'USA') INTO ANS;
    RETURN ANS;
END//
DELIMITER ;

DROP FUNCTION test;



CREATE INDEX client_client_name1_idx ON client (client_name);
ALTER TABLE client DROP INDEX client_client_name1_idx;

CREATE INDEX country_country_name1_idx ON country (country_name);
ALTER TABLE country DROP INDEX country_country_name1_idx;

SELECT contract.contract_id, client_contract.client_role
FROM country 
INNER JOIN city ON (country.country_id = city.country_id)
INNER JOIN estate ON (city.city_id = estate.city_id)
INNER JOIN under_contract ON (estate.estate_id = under_contract.estate_id)
INNER JOIN contract ON (under_contract.contract_id = contract.contract_id)
INNER JOIN client_contract ON (contract.contract_id = client_contract.contract_id)
INNER JOIN client ON (client_contract.client_id = client.client_id)
WHERE client.client_name = 'Denys Ratushniak'
AND country.country_name = 'USA';

SELECT benchmark(10000, test());

SELECT * FROM country;