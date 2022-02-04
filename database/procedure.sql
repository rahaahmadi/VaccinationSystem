drop procedure if exists register;
delimiter $$
create procedure register (
	in id varchar(10),
	in password varchar(64),
    in name varchar(32),
    in last_name varchar(32),
    in date_of_birth date,
    in gender varchar(8),
    in disease varchar(4)
)
begin
	insert into user values(id, password, current_timestamp, name, last_name, date_of_birth, gender, disease);
end
$$
delimiter ;

drop procedure if exists doctorRegister;
delimiter $$
create procedure doctorRegister (
	in id varchar(10),
	in password varchar(64),
    in name varchar(32),
    in last_name varchar(32),
    in date_of_birth date,
    in gender varchar(8),
    in disease varchar(4),
    in medical_id varchar(5)
) begin
    insert into user values(id, password, current_timestamp, name, last_name, date_of_birth, gender, disease);
    insert into doctor values (id, medical_id);
end $$
delimiter ;

drop procedure if exists nurseRegister;
delimiter $$
create procedure nurseRegister (
	in id varchar(10),
	in password varchar(64),
    in name varchar(32),
    in last_name varchar(32),
    in date_of_birth date,
    in gender varchar(8),
    in disease varchar(4),
    in nurse_id varchar(8),
    in degree varchar(16)
) begin
    insert into user values(id, password, current_timestamp, name, last_name, date_of_birth, gender, disease);
    insert into nurse values (id, nurse_id, degree);
end $$
delimiter ;

drop procedure if exists login;
delimiter $$
create procedure login (
	in id varchar(10),
	in password varchar(64)
)
begin
    if not exists(select * from project.user as u where u.id = id and u.password = md5(password)) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'username or password is incorrect';
    elseif exists(select * from log where log.id = id) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'you are already logged in';
    else
        insert into log values (default, id, current_timestamp);
        select log.tag from log where log.id = id;
    end if;
end
$$
delimiter ;

drop procedure if exists addBrand;
delimiter $$
create procedure addBrand (
    in tag int ,
    in name varchar(64) ,
    in dose int ,
    in interval_day int
)
begin
    if not exists(select * from doctor where doctor.id in (select log.id from log where log.tag = tag)) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'only doctors can add brand';
    else
        select doctor.medical_id into @creator_id from doctor inner join log on doctor.id = log.id;
        insert into brand values(name, dose, interval_day, @creator_id);
    end if;
end
$$
delimiter ;

drop procedure if exists addHealthCenter;
delimiter $$
create procedure addHealthCenter (
    in tag int ,
    in name varchar(64) ,
    in address varchar(512)
)
begin
    if not exists(select * from doctor where doctor.id in (select log.id from log where log.tag = tag)) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'only doctors can add health center';
    else
        insert into heath_center values(name, address);
    end if;
end
$$
delimiter ;

drop procedure if exists deleteAccount;
delimiter $$
create procedure deleteAccount (
    in tag int ,
    in id varchar(10)
)
begin
    if not exists(select * from doctor where doctor.id in (select log.id from log where log.tag = tag)) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'only doctors can delete user account';
    else
        delete from user where user.id = id;
    end if;
end
$$
delimiter ;

drop procedure if exists addVial;
delimiter $$
create procedure addVial (
    in tag int,
    in serial_number varchar(64) ,
    in brand varchar(64) ,
    in date_of_production date,
    in dose int,
    in center varchar(64)
)
begin
    if not exists(select * from nurse
    where nurse.id in (select log.id from log where log.tag = tag) and nurse.degree = 'metron') then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'only metron nurse can add vial';
    else
        insert into vial values (serial_number, brand, date_of_production, dose, center);
    end if;
end
$$
delimiter ;

drop procedure if exists addInjection;
delimiter $$
create procedure addInjection (
    in tag int,
    in vaccinated_id varchar(10) ,
    in vaccine_center varchar(64) ,
    in vial_id varchar(64)
)
begin
    if not exists(select * from nurse where nurse.id in (select log.id from log where log.tag = tag)) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'only nurse can add injection';
    elseif not exists(select * from user where user.id = vaccinated_id) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'user id does not exist';
    elseif not exists(select * from heath_center where heath_center.name = vaccine_center) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'vaccination center is invalid';
    elseif not exists(select * from vial where vial.serial_number = vial_id) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'vial serial number is invalid';
    elseif exists(select * from vaccine_injection as injection where injection.vaccinated_id = vaccinated_id) then
        if (select vial.brand from vial where vial.serial_number = vial_id) <>
           (select vial.brand from vial where vial.serial_number = (select injection.vial_id from vaccine_injection as injection where injection.vaccinated_id = vaccinated_id)) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'All doses should be from one brand';
        end if;
    elseif (select count(injection.vial_id) from vaccine_injection as injection where injection.vial_id = vial_id) > (select vial.dose from vial where vial.serial_number = vial_id) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Vial is empty';
    else
        select nurse.nurse_id into @nurse_id from nurse where nurse.id in (select log.id from log where log.tag = tag);
        insert into vaccine_injection values (vaccinated_id, @nurse_id, vaccine_center, vial_id, sysdate());
    end if;
end
$$
delimiter ;

drop procedure if exists viewProfile;
delimiter $$
create procedure viewProfile (
	in tag int
)
begin
    select * from user where user.id = (select log.id from log where log.tag = tag);
end
$$
delimiter ;

drop procedure if exists changePassword;
delimiter $$
create procedure changePassword (
	in tag int,
	in oldPass varchar(64),
	in newPass varchar(64)
)
begin
    if oldPass = newPass then
        update user
        set
            password = newPass
        where user.id = (select log.id from log where log.tag = tag);
    else
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'you do not have injection in this center';
    end if;
end $$
delimiter ;

drop procedure if exists rateVaccinationCenter;
delimiter $$
create procedure rateVaccinationCenter (
	in tag int,
	in center varchar(64),
	in rate int
)
begin
    select log.id into @user_id from log where log.tag = tag;
    if exists(select * from vaccine_injection as v where v.vaccinated_id = @user_id and v.vaccine_center = center) then
        insert into center_rate values (@user_id, center, rate);
    else
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'you do not have injection in this center';
    end if;
end $$
delimiter ;

drop procedure if exists getRate;
delimiter $$
create procedure getRate (
    in pageNumber int
)
begin
    declare x int default 0;
    set x = 5 * (pageNumber - 1);
    select center_rate.vaccination_center, round(avg(center_rate.rate), 1)
        as rate_avg from center_rate group by center_rate.vaccination_center order by rate_avg desc limit 5 offset x;
end
$$
delimiter ;

drop procedure if exists getNumberOfInjection;
delimiter $$
create procedure getNumberOfInjection (
)
begin
    select injection.date, count(injection.vaccinated_id)
    from vaccine_injection as injection group by injection.date order by injection.date desc;
end
$$
delimiter ;

drop procedure if exists getNumberOfVaccinatedPerBrand;
delimiter $$
create procedure getNumberOfVaccinatedPerBrand (
)
begin
    select * from countvaccinatedperbrand;
end
$$
delimiter ;

drop procedure if exists getTotalNumberOfVaccinated;
delimiter $$
create procedure getTotalNumberOfVaccinated (
)
begin
    select sum(countvaccinatedperbrand.count_vaccinated) from countvaccinatedperbrand;
end
$$
delimiter ;

drop procedure if exists getCenterRatePerBrand;
delimiter $$
create procedure getCenterRatePerBrand (
)
begin
    select vaccination_center, brand, round(avg(center_rate.rate), 1) as rate_avg from vaccine_injection as injection inner join vial
    on injection.vial_id = vial.serial_number inner join center_rate
    on injection.vaccine_center = center_rate.vaccination_center group by vial.brand order by rate_avg desc limit 3;
end
$$
delimiter ;

drop procedure if exists customizeCenterRate;
delimiter $$
create procedure customizeCenterRate (
    in tag int
)
begin
    if not exists(select * from vaccine_injection as injection where injection.vaccinated_id = (select log.id from log where log.tag = tag)) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'you do not have any injection yet';
    else
        select log.id into @vaccinated from log where log.tag = tag;
        select injection.vial_id into @vial_id from vaccine_injection as injection where injection.vaccinated_id = @vaccinated;
        select vial.brand into @brand from vial where vial.serial_number = @vial_id;
        select @brand, vaccination_center, rate_avg from center_avg_rate where vaccination_center in (select vial.center from vial where vial.brand = @brand) order by rate_avg desc;
    end if;
end
$$
delimiter ;















