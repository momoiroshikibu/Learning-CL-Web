create table access_tokens (
    `access_token` varchar(255),
    `user_id` integer,
    `created_at` date,
    primary key(access_token)
);
