drop table if exists user;
create table user (
    id varchar(10) primary key,
    password varchar(64),
    accountCreationDate timestamp,
    name varchar(32) not null ,
    last_name varchar(32) not null ,
    date_of_birth date not null ,
    gender varchar(8) not null check ( gender in ('female', 'male') ),
    disease varchar(4) not null check ( disease in ('yes', 'no') )
);
call register('0024299960', 'password1', 'raha', 'ahmadi', '2001-6-28', 'female', 'no');
call register('0034299960', 'password2', 'amir', 'ahmadi', '1980-2-10', 'male', 'yes');
call register('0044299960', 'password3', 'niki', 'majidi', '2000-9-20', 'female', 'no');


drop table if exists doctor;
create table doctor (
    id varchar(10) primary key, foreign key (id) references user(id) on delete cascade ,
    medical_id varchar(5) not null unique
);
call doctorRegister('0055839584', 'docpass1', 'zahra', 'khadem', '1990-6-29', 'female', 'no', '12345');


drop table if exists nurse;
create table nurse (
    id varchar(10) primary key, foreign key (id) references user(id) on delete cascade ,
    nurse_id varchar(8) not null unique ,
    degree varchar(16) not null
);
call nurseRegister('0013244470', 'nursepass1', 'danial', 'kafi', '2000-2-2', 'male', 'yes', '11111111', 'metron');
call nurseRegister('0048755560', 'nursepass2', 'sara', 'shayan', '2000-10-10', 'female', 'no', '22222222', 'behyar');

drop table if exists log;
create table log (
    tag int auto_increment primary key ,
    id varchar(10) not null, foreign key (id) references user(id) on delete cascade ,
    time timestamp not null
);
call login('0024299960', 'password1');
call login('0034299960', 'password2');
call login('0044299960', 'password3');
call login('0055839584', 'docpass1');
call login('0013244470', 'nursepass1');
call login('0048755560', 'nursepass2');

drop table if exists brand;
create table brand (
    name varchar(64) primary key,
    dose int not null ,
    interval_day int not null ,
    creator varchar(10) not null ,
    foreign key (creator) references doctor(medical_id) on delete cascade
);
call addBrand(4, 'pfizer', 2, 21);
call addBrand(4, 'moderna', 2, 28);
call addBrand(4, 'sinopharm', 2, 28);
call addBrand(4, 'astrazeneca', 2, 60);


drop table if exists heath_center;
create table heath_center (
    name varchar(64) primary key,
    address varchar(512) not null
);
call addHealthCenter(4, 'center1', 'address1');
call addHealthCenter(4, 'center2', 'address2');
call addHealthCenter(4, 'center3', 'address3');
call addHealthCenter(4, 'center4', 'address4');

drop table if exists vial;
create table vial (
    serial_number varchar(64) primary key,
    brand varchar(64) not null,
    date_of_production date,
    dose int not null,
    center varchar(64) not null,
    foreign key (brand) references brand (name) on delete cascade,
    foreign key (center) references heath_center(name) on delete cascade
);
call addVial(5, '111', 'pfizer', '2020-9-9', 4, 'center1');
call addVial(5, '222', 'moderna', '2021-9-9', 6, 'center2');
call addVial(5, '333', 'sinopharm', '2020-11-9', 6, 'center3');
call addVial(5, '444', 'astrazeneca', '2021-2-2', 6, 'center1');
call addVial(5, '555', 'pfizer', '2021-3-3', 4, 'center2');
call addVial(5, '666', 'sinopharm', '2021-4-4', 6, 'center1');

drop table if exists vaccine_injection;
create table vaccine_injection (
    vaccinated_id varchar(10) not null,
    nurse_id varchar(8) not null,
    vaccine_center varchar(64) not null,
    vial_id varchar(64) not null,
    date date not null ,
    foreign key (vaccinated_id) references user (id) on delete cascade ,
    foreign key (nurse_id) references nurse (nurse_id) on delete cascade,
    foreign key (vaccine_center) references heath_center (name) on delete cascade ,
    foreign key (vial_id) references vial (serial_number) on delete cascade
#     primary key (vaccinated_id, date)
);
call addInjection(5, '0024299960', 'center1', '111');
call addInjection(5, '0034299960', 'center2', '222');
call addInjection(5, '0044299960', 'center3', '333');
call addInjection(6, '0055839584', 'center1', '666');
call addInjection(6, '0013244470', 'center2', '555');
call addInjection(5, '0048755560', 'center1', '111');
call addInjection(5, '0024299960', 'center2', '555');
call addInjection(5, '0034299960', 'center2', '222');
call addInjection(5, '0013244470', 'center1', '111');


drop table if exists center_rate;
create table center_rate (
    user_id varchar(10),
    vaccination_center varchar(64),
    rate int  not null,
    check ( rate <= 5 and rate >= 1 ),
    primary key (user_id, vaccination_center),
    foreign key (user_id) references user(id),
    foreign key (vaccination_center) references heath_center(name)
);
call rateVaccinationCenter(1,'center1', 4);
call rateVaccinationCenter(2,'center2', 5);
call rateVaccinationCenter(3,'center3', 3);
call rateVaccinationCenter(4,'center1', 3);
call rateVaccinationCenter(5,'center2', 2);
call rateVaccinationCenter(6,'center1', 3);


drop view if exists countvaccinatedperbrand;
create view countVaccinatedPerBrand as
    select brand.name, count(vaccinated_count.vaccinated_id) as count_vaccinated
    from vial inner join (select *, count(injection.vaccinated_id) as count
    from vaccine_injection as injection group by vaccinated_id ) as vaccinated_count
    on vial.serial_number = vaccinated_count.vial_id inner join brand on vial.brand = brand.name
    where vaccinated_count.count = brand.dose group by brand.name order by count_vaccinated;

drop view if exists center_avg_rate;
create view center_avg_rate as
    select center_rate.vaccination_center, round(avg(center_rate.rate), 1)
        as rate_avg from center_rate group by center_rate.vaccination_center order by rate_avg desc;


call getRate(1);
call getNumberOfInjection();
call getNumberOfVaccinatedPerBrand();
call getTotalNumberOfVaccinated();
call getCenterRatePerBrand();
call customizeCenterRate(4);