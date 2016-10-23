create table users (
    `id` integer auto_increment,
    `first_name` varchar(255),
    `last_name` varchar(255),
    `created_at` date,
    primary key(id)
);


-- alter table users add `mail_address` varchar(255);
-- alter table users add `password_hash` varchar(255);

-- alter table users modify created_at date after mail_address;
-- alter table users modify created_at varchar(255) after password_hash;
