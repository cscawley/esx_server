create table if not exists compensation
(
    id bigint unsigned auto_increment PRIMARY KEY,
    compensator text not null,
    receiver text not null,
    reason longtext not null,
    amount int not null,
    constraint id
        unique (id)
);
