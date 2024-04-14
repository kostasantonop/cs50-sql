CREATE TABLE `users` (
    `id` INT AUTO_INCREMENT,
    `first_name` VARCHAR(255) NOT NULL,
    `last_name` VARCHAR(255) NOT NULL,
    `user_username` VARCHAR(255) NOT NULL,
    `user_password` VARCHAR(255) NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE `schools` (
    `id` INT AUTO_INCREMENT,
    `school_name` VARCHAR(255) NOT NULL,
    `school_type` ENUM('Primary', 'Secondary', 'Higher Education') NOT NULL,
    `school_location` VARCHAR(255) NOT NULL,
    `founding_year` YEAR NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `companies` (
    `id` INT AUTO_INCREMENT,
    `company_name` VARCHAR(255) NOT NULL,
    `company_industry` ENUM('Technology', 'Education', 'Buisiness') NOT NULL,
    `comapny_location` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`id`)
);

CREATE TABLE `userConnections` (
    `id` INT AUTO_INCREMENT,
    `user1_id` INT NOT NULL,
    `user2_id` INT NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY(`user1_id`) REFERENCES `users`(`id`),
    FOREIGN KEY(`user2_id`) REFERENCES `users`(`id`)
);

CREATE TABLE `schoolConnections` (
    `id` INT AUTO_INCREMENT,
    `user_id` INT NOT NULL,
    `school_id` INT NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE,
    `type_degree` ENUM('BA', 'MA', 'PhD') NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY(`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY(`school_id`) REFERENCES `schools`(`id`)
);

CREATE TABLE `companyConnections`(
    `id` INT AUTO_INCREMENT,
    `user_id` INT NOT NULL,
    `company_id` INT NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE,
    PRIMARY KEY (`id`),
    FOREIGN KEY(`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY(`company_id`) REFERENCES `companies`(`id`)
);




