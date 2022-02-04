drop trigger if exists check_user_account;
delimiter $$
create definer =root@localhost trigger check_user_account
before insert on user
for each row begin
    if new.id RLIKE '[a-zA-Z!@#$%a&*()_+=.,;:]'or length(new.id) <> 10 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID should only contain numbers and have a length of 10';
    end if;
    if new.password not rlike '[0-9]' or new.password not rlike '[a-z]' or length(new.password) < 8 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Password should contain both number and character and have a minimum length of 8';
    else
        set new.password = md5(new.password);
    end if;
end
$$
delimiter ;

drop trigger if exists check_doctor_account;
delimiter $$
create definer =root@localhost trigger check_doctor_account
before insert on doctor
for each row begin
    if new.medical_id RLIKE '[a-zA-Z!@#$%a&*()_+=.,;:]' or length(new.medical_id) <> 5 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Medical ID should only contain numbers and have a length of 5';
    end if;
end
$$
delimiter ;

drop trigger if exists check_nurse_account;
delimiter $$
create definer =root@localhost trigger check_nurse_account
before insert on nurse
for each row begin
    if new.nurse_id RLIKE '[a-zA-Z!@#$%a&*()_+=.,;:]' or length(new.nurse_id) <> 8 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Medical ID should only contain numbers and have a length of 8';
    end if;
    if new.degree not in ('metron', 'supervisor', 'nurse', 'behyar') then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'nurse degree is invalid';
    end if;
end
$$
delimiter ;

drop trigger if exists check_password;
delimiter $$
create definer =root@localhost trigger check_password
before update on user
for each row begin
    if new.password not rlike '[0-9]' or new.password not rlike '[a-z]' or length(new.password) < 8 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Password should contain both number and character and have a minimum length of 8';
    else
        set new.password = md5(new.password);
    end if;
end
$$
delimiter ;

drop trigger if exists check_serialNo;
delimiter $$
create definer =root@localhost trigger check_serialNo
before insert on vial
for each row begin
    if new.serial_number rlike '[a-zA-Z!@#$%a&*()_+=.,;:]' then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'serial number should only contain numbers';
    end if;
end
$$
delimiter ;
