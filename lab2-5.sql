-- -----------------------------------------------------
-- Schema estate_agency
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `estate_agency` DEFAULT CHARACTER SET utf8mb4;
USE `estate_agency` ;

-- -----------------------------------------------------
-- Table `estate_agency`.`country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estate_agency`.`country` (
  `country_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `country_name` VARCHAR(45) NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`country_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

-- -----------------------------------------------------
-- Table `estate_agency`.`city`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estate_agency`.`city` (
  `city_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `city_name` VARCHAR(45) NOT NULL,
  `country_id` SMALLINT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`city_id`),
  INDEX `fk_city_country1_idx` (`country_id` ASC) VISIBLE,
  CONSTRAINT `fk_city_country1`
    FOREIGN KEY (`country_id`)
    REFERENCES `estate_agency`.`country` (`country_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `estate_agency`.`estate_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estate_agency`.`estate_type` (
  `estate_type_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `estate_type_name` VARCHAR(45) NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`estate_type_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

-- -----------------------------------------------------
-- Table `estate_agency`.`estate`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estate_agency`.`estate` (
  `estate_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `estate_name` VARCHAR(128) NOT NULL,
  `estate_type_id` SMALLINT UNSIGNED NOT NULL,
  `city_id` INT UNSIGNED NOT NULL,
  `street` VARCHAR(45) NOT NULL,
  `floor_area` DECIMAL(10,2) UNSIGNED NOT NULL,
  `total_number_of_rooms` INT UNSIGNED NULL,
  `number_of_floor` SMALLINT UNSIGNED NULL,
  `number_of_bedrooms` INT UNSIGNED NULL,
  `number_of_bathrooms` INT UNSIGNED NULL,
  `garage_presence` TINYINT NULL,
  `number_of_parking_spaces` SMALLINT UNSIGNED NULL,
  `pets_allowed` TINYINT NULL,
  `estate_description` TEXT NOT NULL,
  `estate_status` ENUM('free', 'leased/rented', 'sold/bought') NOT NULL DEFAULT 'free',
  `estate_live_status` ENUM('active', 'deleted') NOT NULL DEFAULT 'active',
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`estate_id`),
  INDEX `fk_estate_city1_idx` (`city_id` ASC) VISIBLE,
  INDEX `fk_estate_estate_type1_idx` (`estate_type_id` ASC) VISIBLE,
  CONSTRAINT `fk_estate_city1`
    FOREIGN KEY (`city_id`)
    REFERENCES `estate_agency`.`city` (`city_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_estate_estate_type1`
    FOREIGN KEY (`estate_type_id`)
    REFERENCES `estate_agency`.`estate_type` (`estate_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `estate_agency`.`employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estate_agency`.`employee` (
  `employee_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `employee_role` VARCHAR(45) NOT NULL,
  `rating` DECIMAL(3,2) NULL,
  `employee_age` SMALLINT UNSIGNED NULL,
  `mail` VARCHAR(323) NULL,
  `mobile_phone` VARCHAR(32) NOT NULL,
  `employee_live_status` ENUM('active', 'deleted') NOT NULL DEFAULT 'active',
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`employee_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `estate_agency`.`payment_frequency`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estate_agency`.`payment_frequency` (
  `payment_frequency_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `payment_frequency_name` VARCHAR(45) NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_frequency_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `estate_agency`.`contract`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estate_agency`.`contract` (
  `contract_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `employee_id` INT UNSIGNED NOT NULL,
  `contract_type` ENUM('mediation (buying/selling)', 'mediation (renting out/leasing)', 'buying (from a customer)', 'selling (to a customer)', 'renting out(to a customer)') NOT NULL DEFAULT 'mediation (buying/selling)',
  `contract_details` TEXT NOT NULL,
  `payment_frequency_id` SMALLINT UNSIGNED NOT NULL,
  `number_of_invoices` INT NOT NULL,
  `payment_amount` DECIMAL(10,2) NOT NULL,
  `fee_percentage` DECIMAL(5,2) NOT NULL,
  `fee_amount` DECIMAL(8,2) NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NULL,
  `signed_date` DATE NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`contract_id`),
  INDEX `fk_contract_employee1_idx` (`employee_id` ASC) VISIBLE,
  INDEX `fk_contract_payment_frequency1_idx` (`payment_frequency_id` ASC) VISIBLE,
  CONSTRAINT `fk_contract_employee1`
    FOREIGN KEY (`employee_id`)
    REFERENCES `estate_agency`.`employee` (`employee_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_contract_payment_frequency1`
    FOREIGN KEY (`payment_frequency_id`)
    REFERENCES `estate_agency`.`payment_frequency` (`payment_frequency_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `estate_agency`.`contract_invoice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estate_agency`.`contract_invoice` (
  `contract_invoice_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `contract_id` INT UNSIGNED NOT NULL,
  `issued_by` TEXT NOT NULL,
  `issued_to` TEXT NOT NULL,
  `invoice_details` TEXT NOT NULL,
  `invoice_amount` DECIMAL(10,2) NOT NULL,
  `date_created` DATE NOT NULL,
  `billing_date` DATE NOT NULL,
  `date_paid` DATE NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`contract_invoice_id`),
  CONSTRAINT `fk_contract_invoice_contract`
    FOREIGN KEY (`contract_id`)
    REFERENCES `estate_agency`.`contract` (`contract_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `estate_agency`.`client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estate_agency`.`client` (
  `client_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `client_name` VARCHAR(64) NOT NULL,
  `client_address` VARCHAR(128) NULL,
  `contact_person` VARCHAR(64) NULL,
  `client_age` SMALLINT UNSIGNED NULL,
  `mobile_phone` VARCHAR(32) NOT NULL,
  `mail` VARCHAR(323) NULL,
  `client_details` TEXT NULL,
  `client_live_status` ENUM('active', 'deleted') NOT NULL DEFAULT 'active',
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`client_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

-- -----------------------------------------------------
-- Table `estate_agency`.`in_charge`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estate_agency`.`in_charge` (
  `estate_id` INT UNSIGNED NOT NULL,
  `employee_id` INT UNSIGNED NOT NULL,
  `date_from` DATE NOT NULL,
  `date_to` DATE NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`estate_id`, `employee_id`),
  INDEX `fk_in_charge_estate1_idx` (`estate_id` ASC) INVISIBLE,
  INDEX `fk_in_charge_employee1_idx` (`employee_id` ASC) VISIBLE,
  CONSTRAINT `fk_in_charge_estate1`
    FOREIGN KEY (`estate_id`)
    REFERENCES `estate_agency`.`estate` (`estate_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_in_charge_employee1`
    FOREIGN KEY (`employee_id`)
    REFERENCES `estate_agency`.`employee` (`employee_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `estate_agency`.`under_contract`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estate_agency`.`under_contract` (
  `estate_id` INT UNSIGNED NOT NULL,
  `contract_id` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`estate_id`, `contract_id`),
  INDEX `fk_under_contract_contract1_idx` (`contract_id` ASC) VISIBLE,
  INDEX `fk_under_contract_estate1_idx` (`estate_id` ASC) INVISIBLE,
  CONSTRAINT `fk_under_contract_contract1`
    FOREIGN KEY (`contract_id`)
    REFERENCES `estate_agency`.`contract` (`contract_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_under_contract_estate1`
    FOREIGN KEY (`estate_id`)
    REFERENCES `estate_agency`.`estate` (`estate_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `estate_agency`.`client_contract`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estate_agency`.`client_contract` (
  `client_id` INT UNSIGNED NOT NULL,
  `contract_id` INT UNSIGNED NOT NULL,
  `client_role` ENUM('tenant', 'landlord', 'buyer', 'seller') NOT NULL DEFAULT 'tenant',
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`client_id`, `contract_id`),
  INDEX `fk_client_contract_contract1_idx` (`contract_id` ASC) INVISIBLE,
  INDEX `fk_client_contract_client1_idx` (`client_id` ASC) VISIBLE,
  CONSTRAINT `fk_client_contract_client1`
    FOREIGN KEY (`client_id`)
    REFERENCES `estate_agency`.`client` (`client_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_client_contract_contract1`
    FOREIGN KEY (`contract_id`)
    REFERENCES `estate_agency`.`contract` (`contract_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


INSERT INTO country (country_name) VALUES('Ukraine');
INSERT INTO country (country_name) VALUES('Poland');
INSERT INTO country (country_name) VALUES('USA');
INSERT INTO country (country_name) VALUES('USA');
INSERT INTO `country` (`country_name`) VALUES
('Afghanistan'),
('Aland Islands'),
('Albania'),
('Algeria'),
('American Samoa'),
('Andorra'),
('Angola'),
('Anguilla'),
('Antarctica'),
('Antigua and Barbuda'),
('Argentina'),
('Armenia'),
('Aruba'),
('Australia'),
('Austria'),
('Azerbaijan'),
('Bahamas'),
('Bahrain'),
('Bangladesh'),
('Barbados'),
('Belarus'),
('Belgium'),
('Belize'),
('Benin'),
('Bermuda'),
('Bhutan'),
('Bolivia'),
('Bonaire, Sint Eustatius and Saba'),
('Bosnia and Herzegovina'),
('Botswana'),
('Bouvet Island'),
('Brazil'),
('British Indian Ocean Territory'),
('Brunei Darussalam'),
('Bulgaria'),
('Burkina Faso'),
('Burundi'),
('Cambodia'),
('Cameroon'),
('Canada'),
('Cape Verde'),
('Cayman Islands'),
('Central African Republic'),
('Chad'),
('Chile'),
('China'),
('Christmas Island'),
('Cocos (Keeling) Islands'),
('Colombia'),
('Comoros'),
('Congo'),
('Congo, Democratic Republic of the Congo'),
('Cook Islands'),
('Costa Rica'),
('Cote D\'Ivoire'),
('Croatia'),
('Cuba'),
('Curacao'),
('Cyprus'),
('Czech Republic'),
('Denmark'),
('Djibouti'),
('Dominica'),
('Dominican Republic'),
('Ecuador'),
('Egypt'),
('El Salvador'),
('Equatorial Guinea'),
('Eritrea'),
('Estonia'),
('Ethiopia'),
('Falkland Islands (Malvinas)'),
('Faroe Islands'),
('Fiji'),
('Finland'),
('France'),
('French Guiana'),
('French Polynesia'),
('French Southern Territories'),
('Gabon'),
('Gambia'),
('Georgia'),
('Germany'),
('Ghana'),
('Gibraltar'),
('Greece'),
('Greenland'),
('Grenada'),
('Guadeloupe'),
('Guam'),
('Guatemala'),
('Guernsey'),
('Guinea'),
('Guinea-Bissau'),
('Guyana'),
('Haiti'),
('Heard Island and Mcdonald Islands'),
('Holy See (Vatican City State)'),
('Honduras'),
('Hong Kong'),
('Hungary'),
('Iceland'),
('India'),
('Indonesia'),
('Iran, Islamic Republic of'),
('Iraq'),
('Ireland'),
('Isle of Man'),
('Israel'),
('Italy'),
('Jamaica'),
('Japan'),
('Jersey'),
('Jordan'),
('Kazakhstan'),
('Kenya'),
('Kiribati'),
('Korea, Democratic People\'s Republic of'),
('Korea, Republic of'),
('Kosovo'),
('Kuwait'),
('Kyrgyzstan'),
('Lao People\'s Democratic Republic'),
('Latvia'),
('Lebanon'),
('Lesotho'),
('Liberia'),
('Libyan Arab Jamahiriya'),
('Liechtenstein'),
('Lithuania'),
('Luxembourg'),
('Macao'),
('Macedonia, the Former Yugoslav Republic of'),
('Madagascar'),
('Malawi'),
('Malaysia'),
('Maldives'),
('Mali'),
('Malta'),
('Marshall Islands'),
('Martinique'),
('Mauritania'),
('Mauritius'),
('Mayotte'),
('Mexico'),
('Micronesia, Federated States of'),
('Moldova, Republic of'),
('Monaco'),
('Mongolia'),
('Montenegro'),
('Montserrat'),
('Morocco'),
('Mozambique'),
('Myanmar'),
('Namibia'),
('Nauru'),
('Nepal'),
('Netherlands'),
('Netherlands Antilles'),
('New Caledonia'),
('New Zealand'),
('Nicaragua'),
('Niger'),
('Nigeria'),
('Niue'),
('Norfolk Island'),
('Northern Mariana Islands'),
('Norway'),
('Oman'),
('Pakistan'),
('Palau'),
('Palestinian Territory, Occupied'),
('Panama'),
('Papua New Guinea'),
('Paraguay'),
('Peru'),
('Philippines'),
('Pitcairn'),
('Portugal'),
('Puerto Rico'),
('Qatar'),
('Reunion'),
('Romania'),
('Russian Federation'),
('Rwanda'),
('Saint Barthelemy'),
('Saint Helena'),
('Saint Kitts and Nevis'),
('Saint Lucia'),
('Saint Martin'),
('Saint Pierre and Miquelon'),
('Saint Vincent and the Grenadines'),
('Samoa'),
('San Marino'),
('Sao Tome and Principe'),
('Saudi Arabia'),
('Senegal'),
('Serbia'),
('Serbia and Montenegro'),
('Seychelles'),
('Sierra Leone'),
('Singapore'),
('Sint Maarten'),
('Slovakia'),
('Slovenia'),
('Solomon Islands'),
('Somalia'),
('South Africa'),
('South Georgia and the South Sandwich Islands'),
('South Sudan'),
('Spain'),
('Sri Lanka'),
('Sudan'),
('Suriname'),
('Svalbard and Jan Mayen'),
('Swaziland'),
('Sweden'),
('Switzerland'),
('Syrian Arab Republic'),
('Taiwan, Province of China'),
('Tajikistan'),
('Tanzania, United Republic of'),
('Thailand'),
('Timor-Leste'),
('Togo'),
('Tokelau'),
('Tonga'),
('Trinidad and Tobago'),
('Tunisia'),
('Turkey'),
('Turkmenistan'),
('Turks and Caicos Islands'),
('Tuvalu'),
('Uganda'),
('United Arab Emirates'),
('United Kingdom'),
('United States Minor Outlying Islands'),
('Uruguay'),
('Uzbekistan'),
('Vanuatu'),
('Venezuela'),
('Viet Nam'),
('Virgin Islands, British'),
('Virgin Islands, U.s.'),
('Wallis and Futuna'),
('Western Sahara'),
('Yemen'),
('Zambia'),
('Zimbabwe');
-- SELECT * FROM country;


INSERT INTO city SET city_name = 'Kyiv', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Kharkiv', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Odesa', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Dnipro', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Donetsk', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Zaporizhzhia', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Lviv', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Kryvyi Rih', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Mykolaiv', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Sevastopol', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Mariupol', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Luhansk', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Vinnytsia', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Simferopol', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Chernihiv', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Khmelnytskyi', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Poltava', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Kherson', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Zhytomyr', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Sumy', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Rivne', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Ivano-Frankivsk', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Ternopil', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Kropyvnytskyi', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
INSERT INTO city SET city_name = 'Lutsk', country_id = (SELECT country_id FROM country WHERE country_name = 'Ukraine');
-- SELECT * FROM city;


INSERT INTO estate_type SET estate_type_name = 'Flat';
INSERT INTO estate_type SET estate_type_name = 'House';
INSERT INTO estate_type SET estate_type_name = 'Land';
INSERT INTO estate_type SET estate_type_name = 'Field';
INSERT INTO estate_type SET estate_type_name = 'Block of Flats';
-- SELECT * FROM estate_type;


INSERT INTO client SET client_name = 'Denys Ratushniak', client_address = 'Lviv, Stepan Bandera Street 31/3, ', client_age = 18, mobile_phone = '+380977777777', mail = 'denisr2007@gmail.com', client_details = 'Patient client';
INSERT INTO client SET client_name = 'Oksana Ratushniak', client_address = 'Lviv, Stepan Bandera Street 31/3', client_age = 49, mobile_phone = '+380976666666';
INSERT INTO client SET client_name = 'Sviatoslav Ratushniak', client_address = 'Lviv, Stepan Bandera Street 31/3', client_age = 51, mobile_phone = '+380976666666';
INSERT INTO client SET client_name = 'Vitalij Nahornyj', client_address = 'Lviv, Stepan Bandera Street 1', client_age = 25, mobile_phone = '+380976666666';
INSERT INTO client SET client_name = 'Bronislav Furman', client_address = 'Lviv, Stepan Bandera Street 2', client_age = 40, mobile_phone = '+380976666666';
INSERT INTO client SET client_name = 'Volodymyr Semenov', client_address = 'Lviv, Stepan Bandera Street 3', client_age = 32, mobile_phone = '+380966346261';
INSERT INTO client SET client_name = 'Halyna Melnyk', client_address = 'Lviv, Stepan Bandera Street 4', client_age = 22, mobile_phone = '+380968877456';
INSERT INTO client SET client_name = 'Anton Mykhajlyuk', client_address = 'Khmelnytskyi, Myru ave 1', client_age = 19, mobile_phone = '+380966778945';
INSERT INTO client SET client_name = 'Lyubov Kozak', client_address = 'Khmelnytskyi, Myru ave 2', client_age = 70, mobile_phone = '+380966666666';
INSERT INTO client SET client_name = 'Antonina Tsymbal', client_address = 'Khmelnytskyi, Myru ave 3', mobile_phone = '+380951666666';
INSERT INTO client SET client_name = 'Lyubov Kozak', client_address = 'Khmelnytskyi, Myru ave 4', mobile_phone = '+380952645666';
INSERT INTO client SET client_name = 'Polina Bilyj', client_address = 'Khmelnytskyi, Myru ave 5', mobile_phone = '+380953666666';
INSERT INTO client SET client_name = 'Marta Sakhno', client_address = 'Khmelnytskyi, Myru ave 6', mobile_phone = '+380954666666';
INSERT INTO client SET client_name = 'Liliya Chumachenko', client_address = 'Khmelnytskyi, Myru ave 7', mobile_phone = '+380966665666';
INSERT INTO client SET client_name = 'Roman Kovalchuk', client_age = 45, contact_person = 'Anna Kovalchuk', mobile_phone = '+380977666666';
INSERT INTO client SET client_name = 'Oksana Sydorchuk',  client_age = 64, contact_person = 'Anna Sydorchuk', mobile_phone = '+380968666666';
INSERT INTO client SET client_name = 'Yakiv Tytarenko',  client_age = 23, contact_person = 'Anna Tytarenko', mobile_phone = '+380963476888';
INSERT INTO client SET client_name = 'Vitalii Boruh',  client_age = 18, mobile_phone = '+380961538626';
INSERT INTO client SET client_name = 'Anna Boruh',  client_age = 43, mobile_phone = '+380978539673';
INSERT INTO client SET client_name = 'Vitalii Mill',  client_age = 18, mobile_phone = '+380975255975';
-- SELECT * FROM client;


INSERT INTO payment_frequency SET payment_frequency_name = 'Once a month';
INSERT INTO payment_frequency SET payment_frequency_name = 'Once a year';
INSERT INTO payment_frequency SET payment_frequency_name = 'Twice a year';
INSERT INTO payment_frequency SET payment_frequency_name = 'One time';
-- SELECT * FROM payment_frequency;


INSERT INTO employee SET first_name = 'Mykhajlo', last_name = 'Melnychenko', employee_role = 'Director', mobile_phone = '+380931212121', rating = 5.00, employee_age = 33, mail = 'MykhajloMelnychenko@gmail.com';
INSERT INTO employee SET first_name = 'Semen', last_name = 'Naumenko', employee_role = 'Realtor', mobile_phone = '+380931312121', rating = 4.90, employee_age = 23, mail = 'SemenNaumenko123@gmail.com';
INSERT INTO employee SET first_name = 'Serhij', last_name = 'Myronenko', employee_role = 'Head of Marketing', mobile_phone = '+380931412121', rating = 4.78, employee_age = 43, mail = 'SerhijMyronenko3@gmail.com';
INSERT INTO employee SET first_name = 'Mykola', last_name = 'Puhach', employee_role = 'Property Manager', mobile_phone = '+380931512121', rating = 4.32, employee_age = 26, mail = 'MykolaPuhach_5@gmail.com';
INSERT INTO employee SET first_name = 'Afanasij', last_name = 'Kutsenko', employee_role = 'Residential or Commercial Appraiser', mobile_phone = '+380931612121', rating = 4.56, employee_age = 34, mail = 'AfanasijKutsenkobeb@gmail.com';
INSERT INTO employee SET first_name = 'Ostap', last_name = 'Bodnar', employee_role = 'Mortgage Broker', mobile_phone = '+380971712121', rating = 4.21, employee_age = 24;
INSERT INTO employee SET first_name = 'Svitlana', last_name = 'Koval', employee_role = 'Real Estate Investor', mobile_phone = '+380931812121', rating = 4.77, employee_age = 45;
INSERT INTO employee SET first_name = 'Antonina', last_name = 'Lyashenko', employee_role = 'Realtor', mobile_phone = '+380971912121', rating = 4.89, employee_age = 34;
INSERT INTO employee SET first_name = 'Tamara', last_name = 'Lazarenko', employee_role = 'Property Manager', mobile_phone = '+380931012121', rating = 4.32, employee_age = 24;
INSERT INTO employee SET first_name = 'Orysya', last_name = 'Radchenko', employee_role = 'Real Estate Investor', mobile_phone = '+380972112121', rating = 4.11, employee_age = 23;
INSERT INTO employee SET first_name = 'Lyubov', last_name = 'Orel', employee_role = 'Foreclosure Specialist', mobile_phone = '+380932212121', rating = 4.55;
INSERT INTO employee SET first_name = 'Lina', last_name = 'Samojlenko', employee_role = 'Real Estate Investor', mobile_phone = '+380932312121', rating = 3.95;
INSERT INTO employee SET first_name = 'Lidiya', last_name = 'Avramenko', employee_role = 'Head of Marketing', mobile_phone = '+380972412121', rating = 3.80;
INSERT INTO employee SET first_name = 'Larysa', last_name = 'Dudnyk', employee_role = 'Property Manager', mobile_phone = '+380932612121', rating = 3.50;
INSERT INTO employee SET first_name = 'Ulyana', last_name = 'Tymchenko', employee_role = 'Realtor', mobile_phone = '+380932712121';
INSERT INTO employee SET first_name = 'Yuliya', last_name = 'Kharchenko', employee_role = 'Commercial Leasing Manager', mobile_phone = '+380932812121';
INSERT INTO employee SET first_name = 'Kseniya', last_name = 'Kyrylenko', employee_role = 'Property Manager', mobile_phone = '+380972912121';
INSERT INTO employee SET first_name = 'Petro', last_name = 'Husak', employee_role = 'Realtor', mobile_phone = '+380983012121';
INSERT INTO employee SET first_name = 'Yehor', last_name = 'Bilous', employee_role = 'Mortgage Broker', mobile_phone = '+380983112121';
INSERT INTO employee SET first_name = 'Kateryna', last_name = 'Polyakova', employee_role = 'Realtor', mobile_phone = '+380932512121', rating = 3.70;
INSERT INTO employee SET first_name = 'Olena', last_name = 'Herasymenko', employee_role = 'Realtor', mobile_phone = '+380982512231', rating = 4.70;
INSERT INTO employee SET first_name = 'Zoya', last_name = 'Polishchuk', employee_role = 'Realtor', mobile_phone = '+380932512341', rating = 3.30;
INSERT INTO employee SET first_name = 'Afanasij', last_name = 'Kolisnyk', employee_role = 'Realtor', mobile_phone = '+380982512451', rating = 4.67;
INSERT INTO employee SET first_name = 'Mykhajlo', last_name = 'Pylypenko', employee_role = 'Realtor', mobile_phone = '+380932512561', rating = 3.25, employee_age = 25;
INSERT INTO employee SET first_name = 'Yevhen', last_name = 'Stelmakh', employee_role = 'Realtor', mobile_phone = '+380932512671', rating = 5.00, employee_age = 25;
INSERT INTO employee SET first_name = 'Oleksandr', last_name = 'Ishchenko', employee_role = 'Realtor', mobile_phone = '+380972512781', rating = 4.85;
INSERT INTO employee SET first_name = 'Ihor', last_name = 'Lyashenko', employee_role = 'Realtor', mobile_phone = '+380971512891', rating = 4.70, employee_age = 26;
INSERT INTO employee SET first_name = 'Vladyslava', last_name = 'Savchenko', employee_role = 'Realtor', mobile_phone = '+380971512123', rating = 5.00, employee_age = 25;
INSERT INTO employee SET first_name = 'Vita', last_name = 'Tretyak', employee_role = 'Realtor', mobile_phone = '+380932512124', rating = 4.5, employee_age = 26;
INSERT INTO employee SET first_name = 'Olesya', last_name = 'Kravets', employee_role = 'Realtor', mobile_phone = '+380971512125', rating = 4.50;
-- SELECT * FROM employee;


INSERT INTO estate SET estate_name = 'GreenFlat 1', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Flat'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 5/1', floor_area = 50.50, total_number_of_rooms = 5,number_of_floor = 1, number_of_bedrooms = 2, number_of_bathrooms = 1, pets_allowed = True, estate_description = 'Flat with great furniture', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'GreenFlat 2', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Flat'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 5/1', floor_area = 34.00, total_number_of_rooms = 3,number_of_floor = 1, number_of_bedrooms = 1, number_of_bathrooms = 1, pets_allowed = False, estate_description = 'Flat with great furniture', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'GreenFlat 3', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Flat'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 5/1', floor_area = 57.50, total_number_of_rooms = 5,number_of_floor = 2, number_of_bedrooms = 2, number_of_bathrooms = 1, pets_allowed = False, estate_description = 'Flat with great furniture', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'GreenFlat 4', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Flat'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 5/1', floor_area = 43.00, total_number_of_rooms = 4,number_of_floor = 2, number_of_bedrooms = 2, number_of_bathrooms = 1, pets_allowed = True, estate_description = 'Flat with great furniture', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'GreenFlat 5', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Flat'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 5/1', floor_area = 53.50, total_number_of_rooms = 5,number_of_floor = 2, number_of_bedrooms = 1, number_of_bathrooms = 2, pets_allowed = True, estate_description = 'Flat with great furniture', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'OldFlat 1', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Flat'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 5/3', floor_area = 40.50, total_number_of_rooms = 6,number_of_floor = 2, number_of_bedrooms = 2, number_of_bathrooms = 1, pets_allowed = True, estate_description = 'Flat with very great furniture', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'OldFlat 2', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Flat'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 5/3', floor_area = 54.00, total_number_of_rooms = 5,number_of_floor = 2, number_of_bedrooms = 1, number_of_bathrooms = 1, estate_description = 'Flat with very great furniture', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'OldFlat 3', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Flat'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 5/3', floor_area = 47.50, total_number_of_rooms = 3,number_of_floor = 3, number_of_bedrooms = 2, number_of_bathrooms = 1, estate_description = 'Flat with very great furniture', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'OldFlat 4', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Flat'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 5/3', floor_area = 53.00, total_number_of_rooms = 4,number_of_floor = 3, number_of_bedrooms = 2, number_of_bathrooms = 1, estate_description = 'Flat with very great furniture', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'OldFlat 5', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Flat'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 5/3', floor_area = 43.50, total_number_of_rooms = 3,number_of_floor = 3, number_of_bedrooms = 1, number_of_bathrooms = 2, pets_allowed = True, estate_description = 'Flat with very great furniture', estate_status = 'sold/bought';

INSERT INTO estate SET estate_name = 'BlueHouse 1', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'House'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 7/1', floor_area = 150.50, total_number_of_rooms = 5, number_of_bedrooms = 2, garage_presence = True, number_of_parking_spaces = 2, number_of_bathrooms = 1, pets_allowed = True, estate_description = 'House with blue furniture', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'BlueHouse 2', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'House'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 7/2', floor_area = 134.00, total_number_of_rooms = 3, number_of_bedrooms = 1, garage_presence = False, number_of_bathrooms = 1, pets_allowed = False, estate_description = 'House with blue furniture', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'BlueHouse 3', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'House'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 7/3', floor_area = 157.50, total_number_of_rooms = 5, number_of_bedrooms = 2, garage_presence = True, number_of_parking_spaces = 3, number_of_bathrooms = 1, pets_allowed = False, estate_description = 'House with blue furniture', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'BlueHouse 4', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'House'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 7/4', floor_area = 143.00, total_number_of_rooms = 4, number_of_bedrooms = 2, garage_presence = True, number_of_parking_spaces = 1, number_of_bathrooms = 1, pets_allowed = True, estate_description = 'House with blue furniture', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'BlueHouse 5', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'House'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 7/5', floor_area = 153.50, total_number_of_rooms = 5, number_of_bedrooms = 1, garage_presence = False, number_of_bathrooms = 2, pets_allowed = True, estate_description = 'House with blue furniture', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'NewHouse 1', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'House'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 9/1', floor_area = 240.50, total_number_of_rooms = 6, number_of_bedrooms = 2, garage_presence = True, number_of_parking_spaces = 3, number_of_bathrooms = 1, pets_allowed = True, estate_description = 'House with the newest furniture', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'NewHouse 2', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'House'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 9/2', floor_area = 254.00, total_number_of_rooms = 5, number_of_bedrooms = 1, garage_presence = False, number_of_bathrooms = 1, estate_description = 'House with the newest furniture', estate_status = 'leased/rented';
INSERT INTO estate SET estate_name = 'NewHouse 3', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'House'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 9/3', floor_area = 247.50, total_number_of_rooms = 3, number_of_bedrooms = 2, garage_presence = False, number_of_bathrooms = 1, estate_description = 'House with the newest furniture', estate_status = 'leased/rented';
INSERT INTO estate SET estate_name = 'NewHouse 4', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'House'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 9/4', floor_area = 253.00, total_number_of_rooms = 4, number_of_bedrooms = 2, garage_presence = False, number_of_bathrooms = 1, estate_description = 'House with the newest furniture', estate_status = 'leased/rented';
INSERT INTO estate SET estate_name = 'NewHouse 5', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'House'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 9/53', floor_area = 243.50, total_number_of_rooms = 3, number_of_bedrooms = 1, garage_presence = True, number_of_parking_spaces = 2, number_of_bathrooms = 2, pets_allowed = True, estate_description = 'House with the newest furniture', estate_status = 'leased/rented';

INSERT INTO estate SET estate_name = 'BigLand 1', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Land'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 777/1', floor_area = 10000.00, estate_description = '100 × 100 meters near butiful river', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'BigLand 2', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Land'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 777/2', floor_area = 40000.00, estate_description = '200 × 200 meters near butiful river', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'BigLand 3', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Land'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 777/3', floor_area = 10000.00, estate_description = '100 × 100 meters near butiful forest', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'BigLand 4', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Land'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 777/4', floor_area = 40000.00, estate_description = '200 × 200 meters near butiful river', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'BigLand 5', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Land'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 777/5', floor_area = 40000.00, estate_description = '200 × 200 meters near butiful forest', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'BigLand 6', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Land'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 777/6', floor_area = 10000.00, estate_description = '100 × 100 meters near butiful river', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'BigLand 7', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Land'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 777/7', floor_area = 40000.00, estate_description = '200 × 200 meters near butiful forest', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'BigLand 8', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Land'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 777/8', floor_area = 40000.00, estate_description = '200 × 200 meters near butiful river', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'BigLand 9', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Land'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 777/9', floor_area = 40000.00, estate_description = '200 × 200 meters near butiful forest', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'BigLand 10', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Land'), city_id = (SELECT city_id FROM city WHERE city_name = 'Lviv'), street = 'Stepan Bandera 777/10', floor_area = 10000.00, estate_description = '100 × 100 meters near butiful river', estate_status = 'sold/bought';


INSERT INTO estate SET estate_name = 'GreenFlat 1', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Flat'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 5/1', floor_area = 50.50, total_number_of_rooms = 5,number_of_floor = 1, number_of_bedrooms = 2, number_of_bathrooms = 1, pets_allowed = True, estate_description = 'Flat with great furniture', estate_status = 'leased/rented';
INSERT INTO estate SET estate_name = 'GreenFlat 2', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Flat'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 5/1', floor_area = 34.00, total_number_of_rooms = 3,number_of_floor = 1, number_of_bedrooms = 1, number_of_bathrooms = 1, pets_allowed = False, estate_description = 'Flat with great furniture', estate_status = 'leased/rented';
INSERT INTO estate SET estate_name = 'GreenFlat 3', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Flat'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 5/1', floor_area = 57.50, total_number_of_rooms = 5,number_of_floor = 2, number_of_bedrooms = 2, number_of_bathrooms = 1, pets_allowed = False, estate_description = 'Flat with great furniture', estate_status = 'leased/rented';
INSERT INTO estate SET estate_name = 'GreenFlat 4', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Flat'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 5/1', floor_area = 43.00, total_number_of_rooms = 4,number_of_floor = 2, number_of_bedrooms = 2, number_of_bathrooms = 1, pets_allowed = True, estate_description = 'Flat with great furniture', estate_status = 'leased/rented';
INSERT INTO estate SET estate_name = 'GreenFlat 5', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Flat'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 5/1', floor_area = 53.50, total_number_of_rooms = 5,number_of_floor = 2, number_of_bedrooms = 1, number_of_bathrooms = 2, pets_allowed = True, estate_description = 'Flat with great furniture', estate_status = 'leased/rented' ;
INSERT INTO estate SET estate_name = 'OldFlat 1', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Flat'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 5/3', floor_area = 40.50, total_number_of_rooms = 6,number_of_floor = 2, number_of_bedrooms = 2, number_of_bathrooms = 1, pets_allowed = True, estate_description = 'Flat with very great furniture', estate_status = 'leased/rented';
INSERT INTO estate SET estate_name = 'OldFlat 2', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Flat'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 5/3', floor_area = 54.00, total_number_of_rooms = 5,number_of_floor = 2, number_of_bedrooms = 1, number_of_bathrooms = 1, estate_description = 'Flat with very great furniture';
INSERT INTO estate SET estate_name = 'OldFlat 3', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Flat'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 5/3', floor_area = 47.50, total_number_of_rooms = 3,number_of_floor = 3, number_of_bedrooms = 2, number_of_bathrooms = 1, estate_description = 'Flat with very great furniture';
INSERT INTO estate SET estate_name = 'OldFlat 4', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Flat'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 5/3', floor_area = 53.00, total_number_of_rooms = 4,number_of_floor = 3, number_of_bedrooms = 2, number_of_bathrooms = 1, estate_description = 'Flat with very great furniture';
INSERT INTO estate SET estate_name = 'OldFlat 5', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Flat'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 5/3', floor_area = 43.50, total_number_of_rooms = 3,number_of_floor = 3, number_of_bedrooms = 1, number_of_bathrooms = 2, pets_allowed = True, estate_description = 'Flat with very great furniture';

INSERT INTO estate SET estate_name = 'BlueHouse 1', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'House'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 7/1', floor_area = 150.50, total_number_of_rooms = 5, number_of_bedrooms = 2, garage_presence = True, number_of_parking_spaces = 2, number_of_bathrooms = 1, pets_allowed = True, estate_description = 'House with blue furniture';
INSERT INTO estate SET estate_name = 'BlueHouse 2', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'House'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 7/2', floor_area = 134.00, total_number_of_rooms = 3, number_of_bedrooms = 1, garage_presence = False, number_of_bathrooms = 1, pets_allowed = False, estate_description = 'House with blue furniture';
INSERT INTO estate SET estate_name = 'BlueHouse 3', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'House'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 7/3', floor_area = 157.50, total_number_of_rooms = 5, number_of_bedrooms = 2, garage_presence = True, number_of_parking_spaces = 3, number_of_bathrooms = 1, pets_allowed = False, estate_description = 'House with blue furniture';
INSERT INTO estate SET estate_name = 'BlueHouse 4', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'House'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 7/4', floor_area = 143.00, total_number_of_rooms = 4, number_of_bedrooms = 2, garage_presence = True, number_of_parking_spaces = 1, number_of_bathrooms = 1, pets_allowed = True, estate_description = 'House with blue furniture';
INSERT INTO estate SET estate_name = 'BlueHouse 5', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'House'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 7/5', floor_area = 153.50, total_number_of_rooms = 5, number_of_bedrooms = 1, garage_presence = False, number_of_bathrooms = 2, pets_allowed = True, estate_description = 'House with blue furniture';
INSERT INTO estate SET estate_name = 'NewHouse 1', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'House'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 9/1', floor_area = 240.50, total_number_of_rooms = 6, number_of_bedrooms = 2, garage_presence = True, number_of_parking_spaces = 3, number_of_bathrooms = 1, pets_allowed = True, estate_description = 'House with the newest furniture';
INSERT INTO estate SET estate_name = 'NewHouse 2', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'House'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 9/2', floor_area = 254.00, total_number_of_rooms = 5, number_of_bedrooms = 1, garage_presence = False, number_of_bathrooms = 1, estate_description = 'House with the newest furniture';
INSERT INTO estate SET estate_name = 'NewHouse 3', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'House'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 9/3', floor_area = 247.50, total_number_of_rooms = 3, number_of_bedrooms = 2, garage_presence = False, number_of_bathrooms = 1, estate_description = 'House with the newest furniture';
INSERT INTO estate SET estate_name = 'NewHouse 4', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'House'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 9/4', floor_area = 253.00, total_number_of_rooms = 4, number_of_bedrooms = 2, garage_presence = False, number_of_bathrooms = 1, estate_description = 'House with the newest furniture';
INSERT INTO estate SET estate_name = 'NewHouse 5', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'House'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 9/53', floor_area = 243.50, total_number_of_rooms = 3, number_of_bedrooms = 1, garage_presence = True, number_of_parking_spaces = 2, number_of_bathrooms = 2, pets_allowed = True, estate_description = 'House with the newest furniture';

INSERT INTO estate SET estate_name = 'BigLand 1', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Land'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 777/1', floor_area = 10000.00, estate_description = '100 × 100 meters located near butiful river';
INSERT INTO estate SET estate_name = 'BigLand 2', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Land'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 777/2', floor_area = 20000.00, estate_description = '200 × 100 meters located near butiful river';
INSERT INTO estate SET estate_name = 'BigLand 3', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Land'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 777/3', floor_area = 10000.00, estate_description = '100 × 100 meters located near butiful forest';
INSERT INTO estate SET estate_name = 'BigLand 4', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Land'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 777/4', floor_area = 30000.00, estate_description = '300 × 100 meters located near butiful river';
INSERT INTO estate SET estate_name = 'BigLand 5', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Land'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 777/5', floor_area = 24000.00, estate_description = '240 × 100 meters located near butiful forest';
INSERT INTO estate SET estate_name = 'BigLand 6', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Land'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 777/6', floor_area = 26000.00, estate_description = '260 × 100 meters located near butiful river';
INSERT INTO estate SET estate_name = 'BigLand 7', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Land'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 777/7', floor_area = 12000.00, estate_description = '120 × 100 meters located near butiful forest';
INSERT INTO estate SET estate_name = 'BigLand 8', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Land'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 777/8', floor_area = 23000.00, estate_description = '230 × 100 meters located near butiful river';
INSERT INTO estate SET estate_name = 'BigLand 9', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Land'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 777/9', floor_area = 42000.00, estate_description = '210 × 200 meters located near butiful forest', estate_status = 'sold/bought';
INSERT INTO estate SET estate_name = 'BigLand 10', estate_type_id = (SELECT estate_type_id FROM estate_type WHERE estate_type_name = 'Land'), city_id = (SELECT city_id FROM city WHERE city_name = 'Khmelnytskyi'), street = 'Panas Myrny 777/10', floor_area = 23500.00, estate_description = '235 × 100 meters located near butiful river', estate_status = 'sold/bought';
-- SELECT * FROM estate;


INSERT INTO in_charge SET estate_id = 1, employee_id = 30, date_from = '2022-01-01', date_to = '2023-01-01';
INSERT INTO in_charge SET estate_id = 2, employee_id = 30, date_from = '2022-02-01', date_to = '2023-02-01';
INSERT INTO in_charge SET estate_id = 3, employee_id = 30, date_from = '2022-03-01', date_to = '2023-03-01';
INSERT INTO in_charge SET estate_id = 4, employee_id = 30, date_from = '2022-04-01', date_to = '2023-04-01';
INSERT INTO in_charge SET estate_id = 5, employee_id = 30, date_from = '2022-05-01', date_to = '2023-05-01';

INSERT INTO in_charge SET estate_id = 1, employee_id = 29, date_from = '2022-01-10', date_to = '2023-01-10';
INSERT INTO in_charge SET estate_id = 2, employee_id = 29, date_from = '2022-01-20', date_to = '2023-01-20';
INSERT INTO in_charge SET estate_id = 3, employee_id = 29, date_from = '2022-01-25', date_to = '2023-01-25';
INSERT INTO in_charge SET estate_id = 4, employee_id = 29, date_from = '2022-01-15', date_to = '2023-01-15';
INSERT INTO in_charge SET estate_id = 5, employee_id = 29, date_from = '2022-01-05', date_to = '2023-01-05';

INSERT INTO in_charge SET estate_id = 6, employee_id = 28, date_from = '2022-01-01';
INSERT INTO in_charge SET estate_id = 7, employee_id = 28, date_from = '2022-02-01';
INSERT INTO in_charge SET estate_id = 8, employee_id = 28, date_from = '2022-03-01';
INSERT INTO in_charge SET estate_id = 9, employee_id = 28, date_from = '2022-04-01';
INSERT INTO in_charge SET estate_id = 10, employee_id = 28, date_from = '2022-05-01';

INSERT INTO in_charge SET estate_id = 11, employee_id = 28, date_from = '2022-01-10';
INSERT INTO in_charge SET estate_id = 12, employee_id = 28, date_from = '2022-01-20';
INSERT INTO in_charge SET estate_id = 13, employee_id = 28, date_from = '2022-01-25';
INSERT INTO in_charge SET estate_id = 14, employee_id = 28, date_from = '2022-01-15';
INSERT INTO in_charge SET estate_id = 15, employee_id = 28, date_from = '2022-01-05';

INSERT INTO in_charge SET estate_id = 16, employee_id = 27, date_from = '2022-01-01';
INSERT INTO in_charge SET estate_id = 17, employee_id = 27, date_from = '2022-02-01';
INSERT INTO in_charge SET estate_id = 18, employee_id = 27, date_from = '2022-03-01';
INSERT INTO in_charge SET estate_id = 19, employee_id = 27, date_from = '2022-04-01';
INSERT INTO in_charge SET estate_id = 20, employee_id = 27, date_from = '2022-05-01';

INSERT INTO in_charge SET estate_id = 21, employee_id = 26, date_from = '2022-01-10';
INSERT INTO in_charge SET estate_id = 22, employee_id = 26, date_from = '2022-01-20';
INSERT INTO in_charge SET estate_id = 23, employee_id = 26, date_from = '2022-01-25';
INSERT INTO in_charge SET estate_id = 24, employee_id = 26, date_from = '2022-01-15';
INSERT INTO in_charge SET estate_id = 25, employee_id = 26, date_from = '2022-01-05';

INSERT INTO in_charge SET estate_id = 26, employee_id = 26, date_from = '2022-01-01';
INSERT INTO in_charge SET estate_id = 27, employee_id = 26, date_from = '2022-02-01';
INSERT INTO in_charge SET estate_id = 28, employee_id = 26, date_from = '2022-03-01';
INSERT INTO in_charge SET estate_id = 29, employee_id = 26, date_from = '2022-04-01';
INSERT INTO in_charge SET estate_id = 30, employee_id = 26, date_from = '2022-05-01';

INSERT INTO in_charge SET estate_id = 11, employee_id = 25, date_from = '2022-01-10';
INSERT INTO in_charge SET estate_id = 12, employee_id = 25, date_from = '2022-01-20';
INSERT INTO in_charge SET estate_id = 13, employee_id = 25, date_from = '2022-01-25';
INSERT INTO in_charge SET estate_id = 14, employee_id = 25, date_from = '2022-01-15';
INSERT INTO in_charge SET estate_id = 15, employee_id = 25, date_from = '2022-01-05';

INSERT INTO in_charge SET estate_id = 16, employee_id = 25, date_from = '2022-01-01';
INSERT INTO in_charge SET estate_id = 17, employee_id = 25, date_from = '2022-02-01';
INSERT INTO in_charge SET estate_id = 18, employee_id = 25, date_from = '2022-03-01';
INSERT INTO in_charge SET estate_id = 19, employee_id = 25, date_from = '2022-04-01';
INSERT INTO in_charge SET estate_id = 20, employee_id = 25, date_from = '2022-05-01';

INSERT INTO in_charge SET estate_id = 21, employee_id = 25, date_from = '2022-01-10';
INSERT INTO in_charge SET estate_id = 22, employee_id = 25, date_from = '2022-01-20';
INSERT INTO in_charge SET estate_id = 23, employee_id = 25, date_from = '2022-01-25';
INSERT INTO in_charge SET estate_id = 24, employee_id = 25, date_from = '2022-01-15';
INSERT INTO in_charge SET estate_id = 25, employee_id = 25, date_from = '2022-01-05';

INSERT INTO in_charge SET estate_id = 26, employee_id = 24, date_from = '2022-01-01';
INSERT INTO in_charge SET estate_id = 27, employee_id = 24, date_from = '2022-02-01';
INSERT INTO in_charge SET estate_id = 28, employee_id = 24, date_from = '2022-03-01';
INSERT INTO in_charge SET estate_id = 29, employee_id = 24, date_from = '2022-04-01';
INSERT INTO in_charge SET estate_id = 30, employee_id = 24, date_from = '2022-05-01';
INSERT INTO in_charge SET estate_id = 31, employee_id = 24, date_from = '2022-06-01';
INSERT INTO in_charge SET estate_id = 32, employee_id = 24, date_from = '2022-07-01';
INSERT INTO in_charge SET estate_id = 33, employee_id = 24, date_from = '2022-08-01';
INSERT INTO in_charge SET estate_id = 34, employee_id = 24, date_from = '2022-09-01';
INSERT INTO in_charge SET estate_id = 35, employee_id = 24, date_from = '2022-10-01';
INSERT INTO in_charge SET estate_id = 36, employee_id = 24, date_from = '2022-11-01';
-- SELECT * FROM in_charge;


INSERT INTO contract SET employee_id = 20, contract_type = 'mediation (buying/selling)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'Once a year'), number_of_invoices = 5, payment_amount = 30000.00, fee_percentage = 5.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-01-01', signed_date = '2022-01-01';
INSERT INTO contract SET employee_id = 21, contract_type = 'mediation (buying/selling)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'Once a year'), number_of_invoices = 5, payment_amount = 31000.00, fee_percentage = 5.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-02-01', signed_date = '2022-02-01';
INSERT INTO contract SET employee_id = 22, contract_type = 'mediation (buying/selling)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'Once a year'), number_of_invoices = 5, payment_amount = 32000.00, fee_percentage = 5.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-03-01', signed_date = '2022-03-01';
INSERT INTO contract SET employee_id = 23, contract_type = 'mediation (buying/selling)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'Once a year'), number_of_invoices = 5, payment_amount = 13000.00, fee_percentage = 5.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-04-01', signed_date = '2022-04-01';
INSERT INTO contract SET employee_id = 24, contract_type = 'mediation (buying/selling)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'Once a year'), number_of_invoices = 5, payment_amount = 14000.00, fee_percentage = 5.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-05-01', signed_date = '2022-05-01';

INSERT INTO contract SET employee_id = 20, contract_type = 'mediation (buying/selling)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'Once a year'), number_of_invoices = 5, payment_amount = 10000.00, fee_percentage = 3.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-01-01', signed_date = '2022-01-03';
INSERT INTO contract SET employee_id = 21, contract_type = 'mediation (buying/selling)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'Once a year'), number_of_invoices = 5, payment_amount = 11000.00, fee_percentage = 3.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-02-01', signed_date = '2022-02-04';
INSERT INTO contract SET employee_id = 22, contract_type = 'mediation (buying/selling)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'Once a year'), number_of_invoices = 5, payment_amount = 12000.00, fee_percentage = 3.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-03-01', signed_date = '2022-03-14';
INSERT INTO contract SET employee_id = 23, contract_type = 'mediation (buying/selling)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'Once a year'), number_of_invoices = 5, payment_amount = 13000.00, fee_percentage = 3.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-04-01', signed_date = '2022-04-20';
INSERT INTO contract SET employee_id = 24, contract_type = 'mediation (buying/selling)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'Once a year'), number_of_invoices = 5, payment_amount = 14000.00, fee_percentage = 3.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-05-01', signed_date = '2022-05-10';


INSERT INTO contract SET employee_id = 20, contract_type = 'mediation (renting out/leasing)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'Once a month'), number_of_invoices = 12, payment_amount = 1000.00, fee_percentage = 4.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-01-01', end_date = '2023-01-01', signed_date = '2022-01-01';
INSERT INTO contract SET employee_id = 21, contract_type = 'mediation (renting out/leasing)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'Once a month'), number_of_invoices = 12, payment_amount = 1100.00, fee_percentage = 4.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-02-01', end_date = '2023-02-01', signed_date = '2022-02-01';
INSERT INTO contract SET employee_id = 22, contract_type = 'mediation (renting out/leasing)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'Once a month'), number_of_invoices = 12, payment_amount = 1200.00, fee_percentage = 4.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-03-01', end_date = '2023-03-01', signed_date = '2022-03-01';
INSERT INTO contract SET employee_id = 23, contract_type = 'mediation (renting out/leasing)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'Once a month'), number_of_invoices = 12, payment_amount = 1300.00, fee_percentage = 4.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-04-01', end_date = '2023-04-01', signed_date = '2022-04-01';
INSERT INTO contract SET employee_id = 24, contract_type = 'mediation (renting out/leasing)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'Once a month'), number_of_invoices = 12, payment_amount = 1400.00, fee_percentage = 4.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-05-01', end_date = '2023-05-01', signed_date = '2022-05-01';

INSERT INTO contract SET employee_id = 20, contract_type = 'mediation (renting out/leasing)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'Once a month'), number_of_invoices = 12, payment_amount = 1000.00, fee_percentage = 3.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-01-01', end_date = '2023-01-01', signed_date = '2022-01-03';
INSERT INTO contract SET employee_id = 21, contract_type = 'mediation (renting out/leasing)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'Once a month'), number_of_invoices = 12, payment_amount = 1100.00, fee_percentage = 3.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-02-01', end_date = '2023-02-01', signed_date = '2022-02-04';
INSERT INTO contract SET employee_id = 22, contract_type = 'mediation (renting out/leasing)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'Once a month'), number_of_invoices = 12, payment_amount = 1200.00, fee_percentage = 3.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-03-01', end_date = '2023-03-01', signed_date = '2022-03-14';
INSERT INTO contract SET employee_id = 23, contract_type = 'mediation (renting out/leasing)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'Once a month'), number_of_invoices = 12, payment_amount = 1300.00, fee_percentage = 3.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-04-01', end_date = '2023-04-01', signed_date = '2022-04-20';
INSERT INTO contract SET employee_id = 24, contract_type = 'mediation (renting out/leasing)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'Once a month'), number_of_invoices = 12, payment_amount = 1400.00, fee_percentage = 3.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-05-01', end_date = '2023-05-01', signed_date = '2022-05-10';

INSERT INTO contract SET employee_id = 30, contract_type = 'selling (to a customer)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'One time'), number_of_invoices = 1, payment_amount = 1000000.00, fee_percentage = 0.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-01-01', signed_date = '2022-01-10';
INSERT INTO contract SET employee_id = 30, contract_type = 'selling (to a customer)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'One time'), number_of_invoices = 1, payment_amount = 1100000.00, fee_percentage = 0.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-02-01', signed_date = '2022-02-10';
INSERT INTO contract SET employee_id = 30, contract_type = 'selling (to a customer)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'One time'), number_of_invoices = 1, payment_amount = 1200000.00, fee_percentage = 0.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-03-01', signed_date = '2022-03-10';
INSERT INTO contract SET employee_id = 30, contract_type = 'selling (to a customer)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'One time'), number_of_invoices = 1, payment_amount = 900000.00, fee_percentage = 0.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-04-01', signed_date = '2022-04-10';
INSERT INTO contract SET employee_id = 30, contract_type = 'selling (to a customer)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'One time'), number_of_invoices = 1, payment_amount = 950000.00, fee_percentage = 0.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-05-01', signed_date = '2022-05-10';
INSERT INTO contract SET employee_id = 29, contract_type = 'selling (to a customer)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'One time'), number_of_invoices = 1, payment_amount = 9700000.00, fee_percentage = 0.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-06-01', signed_date = '2022-06-10';
INSERT INTO contract SET employee_id = 29, contract_type = 'selling (to a customer)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'One time'), number_of_invoices = 1, payment_amount = 1300000.00, fee_percentage = 0.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-07-01', signed_date = '2022-07-10';
INSERT INTO contract SET employee_id = 29, contract_type = 'selling (to a customer)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'One time'), number_of_invoices = 1, payment_amount = 2000000.00, fee_percentage = 0.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-08-01', signed_date = '2022-08-10';
INSERT INTO contract SET employee_id = 29, contract_type = 'selling (to a customer)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'One time'), number_of_invoices = 1, payment_amount = 1700000.00, fee_percentage = 0.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-09-01', signed_date = '2022-09-10';
INSERT INTO contract SET employee_id = 29, contract_type = 'selling (to a customer)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'One time'), number_of_invoices = 1, payment_amount = 800000.00, fee_percentage = 0.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-10-01', signed_date = '2022-10-10';
INSERT INTO contract SET employee_id = 29, contract_type = 'selling (to a customer)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'One time'), number_of_invoices = 1, payment_amount = 1000000.00, fee_percentage = 0.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-10-07', signed_date = '2022-11-10';
INSERT INTO contract SET employee_id = 29, contract_type = 'selling (to a customer)', contract_details = 'The two parties agreed', payment_frequency_id = (SELECT payment_frequency_id FROM payment_frequency WHERE payment_frequency_name = 'One time'), number_of_invoices = 1, payment_amount = 1000000.00, fee_percentage = 0.00, fee_amount = payment_amount * fee_percentage / 100.0, start_date = '2022-10-10', signed_date = '2022-12-10';
-- SELECT * FROM contract;

INSERT INTO client_contract SET client_id = 1, contract_id = 1, client_role = 'buyer';
INSERT INTO client_contract SET client_id = 2, contract_id = 1, client_role = 'seller';
INSERT INTO client_contract SET client_id = 3, contract_id = 2, client_role = 'buyer';
INSERT INTO client_contract SET client_id = 4, contract_id = 2, client_role = 'seller';
INSERT INTO client_contract SET client_id = 5, contract_id = 3, client_role = 'buyer';
INSERT INTO client_contract SET client_id = 6, contract_id = 3, client_role = 'seller';
INSERT INTO client_contract SET client_id = 7, contract_id = 4, client_role = 'buyer';
INSERT INTO client_contract SET client_id = 8, contract_id = 4, client_role = 'seller';
INSERT INTO client_contract SET client_id = 9, contract_id = 5, client_role = 'buyer';
INSERT INTO client_contract SET client_id = 10, contract_id = 5, client_role = 'seller';
INSERT INTO client_contract SET client_id = 11, contract_id = 6, client_role = 'buyer';
INSERT INTO client_contract SET client_id = 12, contract_id = 6, client_role = 'seller';
INSERT INTO client_contract SET client_id = 13, contract_id = 7, client_role = 'buyer';
INSERT INTO client_contract SET client_id = 14, contract_id = 7, client_role = 'seller';
INSERT INTO client_contract SET client_id = 1, contract_id = 8, client_role = 'buyer';
INSERT INTO client_contract SET client_id = 3, contract_id = 8, client_role = 'seller';
INSERT INTO client_contract SET client_id = 2, contract_id = 9, client_role = 'buyer';
INSERT INTO client_contract SET client_id = 4, contract_id = 9, client_role = 'seller';
INSERT INTO client_contract SET client_id = 5, contract_id = 10, client_role = 'buyer';
INSERT INTO client_contract SET client_id = 7, contract_id = 10, client_role = 'seller';

INSERT INTO client_contract SET client_id = 10, contract_id = 11, client_role = 'tenant';
INSERT INTO client_contract SET client_id = 13, contract_id = 11, client_role = 'landlord';
INSERT INTO client_contract SET client_id = 11, contract_id = 12, client_role = 'tenant';
INSERT INTO client_contract SET client_id = 14, contract_id = 12, client_role = 'landlord';
INSERT INTO client_contract SET client_id = 11, contract_id = 13, client_role = 'tenant';
INSERT INTO client_contract SET client_id = 15, contract_id = 13, client_role = 'landlord';
INSERT INTO client_contract SET client_id = 11, contract_id = 14, client_role = 'tenant';
INSERT INTO client_contract SET client_id = 16, contract_id = 14, client_role = 'landlord';
INSERT INTO client_contract SET client_id = 11, contract_id = 15, client_role = 'tenant';
INSERT INTO client_contract SET client_id = 17, contract_id = 15, client_role = 'landlord';
INSERT INTO client_contract SET client_id = 17, contract_id = 16, client_role = 'tenant';
INSERT INTO client_contract SET client_id = 10, contract_id = 16, client_role = 'landlord';
INSERT INTO client_contract SET client_id = 17, contract_id = 17, client_role = 'tenant';
INSERT INTO client_contract SET client_id = 1, contract_id = 17, client_role = 'landlord';
INSERT INTO client_contract SET client_id = 16, contract_id = 18, client_role = 'tenant';
INSERT INTO client_contract SET client_id = 2, contract_id = 18, client_role = 'landlord';
INSERT INTO client_contract SET client_id = 5, contract_id = 19, client_role = 'tenant';
INSERT INTO client_contract SET client_id = 3, contract_id = 19, client_role = 'landlord';
INSERT INTO client_contract SET client_id = 3, contract_id = 20, client_role = 'tenant';
INSERT INTO client_contract SET client_id = 14, contract_id = 20, client_role = 'landlord';

INSERT INTO client_contract SET client_id = 1, contract_id = 21, client_role = 'buyer';
INSERT INTO client_contract SET client_id = 2, contract_id = 22, client_role = 'buyer';
INSERT INTO client_contract SET client_id = 3, contract_id = 23, client_role = 'buyer';
INSERT INTO client_contract SET client_id = 4, contract_id = 24, client_role = 'buyer';
INSERT INTO client_contract SET client_id = 5, contract_id = 25, client_role = 'buyer';
INSERT INTO client_contract SET client_id = 6, contract_id = 26, client_role = 'buyer';
INSERT INTO client_contract SET client_id = 7, contract_id = 27, client_role = 'buyer';
INSERT INTO client_contract SET client_id = 8, contract_id = 28, client_role = 'buyer';
INSERT INTO client_contract SET client_id = 9, contract_id = 29, client_role = 'buyer';
INSERT INTO client_contract SET client_id = 10, contract_id = 30, client_role = 'buyer';
INSERT INTO client_contract SET client_id = 11, contract_id = 31, client_role = 'buyer';
INSERT INTO client_contract SET client_id = 12, contract_id = 32, client_role = 'buyer';
-- SELECT * FROM client_contract;

INSERT INTO under_contract SET estate_id = 1, contract_id = 1;
INSERT INTO under_contract SET estate_id = 2, contract_id = 1;
INSERT INTO under_contract SET estate_id = 3, contract_id = 1;
INSERT INTO under_contract SET estate_id = 4, contract_id = 2;
INSERT INTO under_contract SET estate_id = 5, contract_id = 2;
INSERT INTO under_contract SET estate_id = 6, contract_id = 2;
INSERT INTO under_contract SET estate_id = 7, contract_id = 3;
INSERT INTO under_contract SET estate_id = 8, contract_id = 3;
INSERT INTO under_contract SET estate_id = 9, contract_id = 3;

INSERT INTO under_contract SET estate_id = 10, contract_id = 4;
INSERT INTO under_contract SET estate_id = 11, contract_id = 5;
INSERT INTO under_contract SET estate_id = 12, contract_id = 6;
INSERT INTO under_contract SET estate_id = 13, contract_id = 7;
INSERT INTO under_contract SET estate_id = 14, contract_id = 8;
INSERT INTO under_contract SET estate_id = 15, contract_id = 9;
INSERT INTO under_contract SET estate_id = 16, contract_id = 10;
INSERT INTO under_contract SET estate_id = 17, contract_id = 11;
INSERT INTO under_contract SET estate_id = 18, contract_id = 12;
INSERT INTO under_contract SET estate_id = 19, contract_id = 13;
INSERT INTO under_contract SET estate_id = 20, contract_id = 14;
INSERT INTO under_contract SET estate_id = 21, contract_id = 21;
INSERT INTO under_contract SET estate_id = 22, contract_id = 22;
INSERT INTO under_contract SET estate_id = 23, contract_id = 23;
INSERT INTO under_contract SET estate_id = 24, contract_id = 24;
INSERT INTO under_contract SET estate_id = 25, contract_id = 25;
INSERT INTO under_contract SET estate_id = 26, contract_id = 26;
INSERT INTO under_contract SET estate_id = 27, contract_id = 27;
INSERT INTO under_contract SET estate_id = 28, contract_id = 28;
INSERT INTO under_contract SET estate_id = 29, contract_id = 29;
INSERT INTO under_contract SET estate_id = 30, contract_id = 30;
INSERT INTO under_contract SET estate_id = 59, contract_id = 31;
INSERT INTO under_contract SET estate_id = 60, contract_id = 32;

INSERT INTO under_contract SET estate_id = 31, contract_id = 15;
INSERT INTO under_contract SET estate_id = 32, contract_id = 16;
INSERT INTO under_contract SET estate_id = 33, contract_id = 17;
INSERT INTO under_contract SET estate_id = 34, contract_id = 18;
INSERT INTO under_contract SET estate_id = 35, contract_id = 19;
INSERT INTO under_contract SET estate_id = 36, contract_id = 20;
-- SELECT COUNT(*) FROM under_contract;

INSERT INTO contract_invoice SET contract_id = 1, issued_by = (SELECT client_name FROM client WHERE client_id = 2), issued_to = (SELECT client_name FROM client WHERE client_id = 1), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 1), date_created = '2022-02-01', billing_date = '2022-02-11', date_paid = '2022-02-10';
INSERT INTO contract_invoice SET contract_id = 2, issued_by = (SELECT client_name FROM client WHERE client_id = 4), issued_to = (SELECT client_name FROM client WHERE client_id = 3), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 2), date_created = '2022-02-02', billing_date = '2022-02-12', date_paid = '2022-02-12';
INSERT INTO contract_invoice SET contract_id = 3, issued_by = (SELECT client_name FROM client WHERE client_id = 6), issued_to = (SELECT client_name FROM client WHERE client_id = 5), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 3), date_created = '2022-02-03', billing_date = '2022-02-13', date_paid = '2022-02-13';
INSERT INTO contract_invoice SET contract_id = 4, issued_by = (SELECT client_name FROM client WHERE client_id = 8), issued_to = (SELECT client_name FROM client WHERE client_id = 7), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 4), date_created = '2022-02-04', billing_date = '2022-02-14', date_paid = '2022-02-14';
INSERT INTO contract_invoice SET contract_id = 5, issued_by = (SELECT client_name FROM client WHERE client_id = 10), issued_to = (SELECT client_name FROM client WHERE client_id = 9), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 5), date_created = '2022-02-05', billing_date = '2022-02-15', date_paid = '2022-02-15';
INSERT INTO contract_invoice SET contract_id = 6, issued_by = (SELECT client_name FROM client WHERE client_id = 12), issued_to = (SELECT client_name FROM client WHERE client_id = 11), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 6), date_created = '2022-02-06', billing_date = '2022-02-16', date_paid = '2022-02-16';
INSERT INTO contract_invoice SET contract_id = 7, issued_by = (SELECT client_name FROM client WHERE client_id = 14), issued_to = (SELECT client_name FROM client WHERE client_id = 13), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 7), date_created = '2022-02-07', billing_date = '2022-02-17', date_paid = '2022-02-16';
INSERT INTO contract_invoice SET contract_id = 8, issued_by = (SELECT client_name FROM client WHERE client_id = 3), issued_to = (SELECT client_name FROM client WHERE client_id = 1), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 8), date_created = '2022-02-08', billing_date = '2022-02-18', date_paid = '2022-02-14';
INSERT INTO contract_invoice SET contract_id = 9, issued_by = (SELECT client_name FROM client WHERE client_id = 4), issued_to = (SELECT client_name FROM client WHERE client_id = 2), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 9), date_created = '2022-02-09', billing_date = '2022-02-19', date_paid = '2022-02-13';
INSERT INTO contract_invoice SET contract_id = 10, issued_by = (SELECT client_name FROM client WHERE client_id = 7), issued_to = (SELECT client_name FROM client WHERE client_id = 5), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 10), date_created = '2022-02-10', billing_date = '2022-02-20', date_paid = '2022-02-18';
INSERT INTO contract_invoice SET contract_id = 11, issued_by = (SELECT client_name FROM client WHERE client_id = 13), issued_to = (SELECT client_name FROM client WHERE client_id = 10), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 11), date_created = '2022-03-01', billing_date = '2022-03-11', date_paid = '2022-03-09';
INSERT INTO contract_invoice SET contract_id = 12, issued_by = (SELECT client_name FROM client WHERE client_id = 14), issued_to = (SELECT client_name FROM client WHERE client_id = 11), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 12), date_created = '2022-03-02', billing_date = '2022-03-12', date_paid = '2022-03-10';
INSERT INTO contract_invoice SET contract_id = 13, issued_by = (SELECT client_name FROM client WHERE client_id = 15), issued_to = (SELECT client_name FROM client WHERE client_id = 11), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 13), date_created = '2022-03-03', billing_date = '2022-03-13', date_paid = '2022-03-12';
INSERT INTO contract_invoice SET contract_id = 14, issued_by = (SELECT client_name FROM client WHERE client_id = 16), issued_to = (SELECT client_name FROM client WHERE client_id = 11), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 14), date_created = '2022-03-04', billing_date = '2022-03-14', date_paid = '2022-03-12';
INSERT INTO contract_invoice SET contract_id = 15, issued_by = (SELECT client_name FROM client WHERE client_id = 17), issued_to = (SELECT client_name FROM client WHERE client_id = 11), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 15), date_created = '2022-03-05', billing_date = '2022-03-15', date_paid = '2022-03-13';
INSERT INTO contract_invoice SET contract_id = 16, issued_by = (SELECT client_name FROM client WHERE client_id = 10), issued_to = (SELECT client_name FROM client WHERE client_id = 17), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 16), date_created = '2022-03-06', billing_date = '2022-03-16', date_paid = '2022-03-14';
INSERT INTO contract_invoice SET contract_id = 17, issued_by = (SELECT client_name FROM client WHERE client_id = 1), issued_to = (SELECT client_name FROM client WHERE client_id = 17), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 17), date_created = '2022-03-07', billing_date = '2022-03-17', date_paid = '2022-03-15';
INSERT INTO contract_invoice SET contract_id = 18, issued_by = (SELECT client_name FROM client WHERE client_id = 2), issued_to = (SELECT client_name FROM client WHERE client_id = 16), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 18), date_created = '2022-03-08', billing_date = '2022-03-18', date_paid = '2022-03-16';
INSERT INTO contract_invoice SET contract_id = 19, issued_by = (SELECT client_name FROM client WHERE client_id = 3), issued_to = (SELECT client_name FROM client WHERE client_id = 5), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 19), date_created = '2022-03-09', billing_date = '2022-03-19', date_paid = '2022-03-17';
INSERT INTO contract_invoice SET contract_id = 20, issued_by = (SELECT client_name FROM client WHERE client_id = 14), issued_to = (SELECT client_name FROM client WHERE client_id = 3), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 20), date_created = '2022-03-10', billing_date = '2022-03-20', date_paid = '2022-03-18';

INSERT INTO contract_invoice SET contract_id = 21, issued_by = 'Mykhajlo Pylypenko', issued_to = (SELECT client_name FROM client WHERE client_id = 1), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 21), date_created = '2022-01-01', billing_date = '2022-02-01', date_paid = '2022-01-04';
INSERT INTO contract_invoice SET contract_id = 22, issued_by = 'Mykhajlo Pylypenko', issued_to = (SELECT client_name FROM client WHERE client_id = 2), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 22), date_created = '2022-02-01', billing_date = '2022-02-01', date_paid = '2022-02-07';
INSERT INTO contract_invoice SET contract_id = 23, issued_by = 'Mykhajlo Pylypenko', issued_to = (SELECT client_name FROM client WHERE client_id = 3), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 23), date_created = '2022-03-01', billing_date = '2022-02-01', date_paid = '2022-03-09';
INSERT INTO contract_invoice SET contract_id = 24, issued_by = 'Mykhajlo Pylypenko', issued_to = (SELECT client_name FROM client WHERE client_id = 4), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 24), date_created = '2022-04-01', billing_date = '2022-02-01', date_paid = '2022-04-11';
INSERT INTO contract_invoice SET contract_id = 25, issued_by = 'Mykhajlo Pylypenko', issued_to = (SELECT client_name FROM client WHERE client_id = 5), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 25), date_created = '2022-05-01', billing_date = '2022-02-01', date_paid = '2022-05-15';
INSERT INTO contract_invoice SET contract_id = 26, issued_by = 'Mykhajlo Pylypenko', issued_to = (SELECT client_name FROM client WHERE client_id = 6), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 26), date_created = '2022-06-01', billing_date = '2022-02-01', date_paid = '2022-06-13';
INSERT INTO contract_invoice SET contract_id = 27, issued_by = 'Mykhajlo Pylypenko', issued_to = (SELECT client_name FROM client WHERE client_id = 7), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 27), date_created = '2022-07-01', billing_date = '2022-02-01', date_paid = '2022-07-19';
INSERT INTO contract_invoice SET contract_id = 28, issued_by = 'Mykhajlo Pylypenko', issued_to = (SELECT client_name FROM client WHERE client_id = 8), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 28), date_created = '2022-08-01', billing_date = '2022-02-01', date_paid = '2022-08-20';
INSERT INTO contract_invoice SET contract_id = 29, issued_by = 'Mykhajlo Pylypenko', issued_to = (SELECT client_name FROM client WHERE client_id = 9), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 29), date_created = '2022-09-01', billing_date = '2022-02-01', date_paid = '2022-09-25';
INSERT INTO contract_invoice SET contract_id = 30, issued_by = 'Mykhajlo Pylypenko', issued_to = (SELECT client_name FROM client WHERE client_id = 10), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 30), date_created = '2022-10-01', billing_date = '2022-02-01', date_paid = '2022-10-21';
INSERT INTO contract_invoice SET contract_id = 31, issued_by = 'Mykhajlo Pylypenko', issued_to = (SELECT client_name FROM client WHERE client_id = 11), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 31), date_created = '2022-11-01', billing_date = '2022-02-01', date_paid = '2022-11-05';
INSERT INTO contract_invoice SET contract_id = 32, issued_by = 'Mykhajlo Pylypenko', issued_to = (SELECT client_name FROM client WHERE client_id = 12), invoice_details = 'OK', invoice_amount = (SELECT (payment_amount + fee_amount) AS invoice_amount FROM contract WHERE `contract`.contract_id = 32), date_created = '2022-12-01', billing_date = '2022-02-01', date_paid = '2022-12-13';
-- SELECT COUNT(*) FROM under_contract;
