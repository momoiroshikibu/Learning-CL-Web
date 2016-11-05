create table access_tokens (
    `id` integer auto_increment,
    `user_id` integer,
    `access_token` varchar(255),
    `last_name` varchar(255),
    `created_at` date,
    primary key(id)
);
