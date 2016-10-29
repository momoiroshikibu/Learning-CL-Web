create table locations (
    `id` int(11) unsigned not null auto_increment,
    `lat` double(8,6) default null,
    `lng` double(9,6) default null,
    `created_at` date,
    `created_by` int(11),
    `updated_at` date,
    `updated_by` int(11),
    primary key(id)
);
