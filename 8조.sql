use lmsdb;




-- 1번
SELECT no, lec_duration, lec_time, t_name, lec.lec_name, cl.class_no
FROM tbl_current_lecture cl
INNER JOIN tbl_classroom cr 
ON cl.class_no = cr.class_no
INNER JOIN tbl_lecture lec 
ON cl.lec_code = lec.lec_code
INNER JOIN tbl_teacher t 
ON cl.t_id = t.t_id;


-- 2번 
create view view_current_lecture 
as
SELECT no, lec_duration, lec_time, t_name, lec.lec_name, cl.class_no
FROM tbl_current_lecture cl
INNER JOIN tbl_classroom cr 
ON cl.class_no = cr.class_no
INNER JOIN tbl_lecture lec 
ON cl.lec_code = lec.lec_code
INNER JOIN tbl_teacher t 
ON cl.t_id = t.t_id;

select * from view_current_lecture;


-- 3번 
SELECT
  L.lec_name,
  SUM(IF(CL.lec_time = '09:00 - 12:00', 1, 0)) AS '09:00 - 12:00',
  SUM(IF(CL.lec_time = '13:00 - 15:00', 1, 0)) AS '13:00 - 15:00',
  SUM(IF(CL.lec_time = '15:00 - 17:00', 1, 0)) AS '15:00 - 17:00'
FROM
  tbl_current_lecture CL
JOIN tbl_lecture L ON CL.lec_code = L.lec_code
GROUP BY L.lec_name
WITH ROLLUP;

-- 04
delimiter $$
create procedure proc_insert_tbl_registration(in s_id varchar(45),in lec_code int,in lec_duration varchar(100))
begin 
    DECLARE error_code VARCHAR(5);
    DECLARE error_msg VARCHAR(255);
	
    declare continue handler for 1062 
    begin
        GET DIAGNOSTICS CONDITION 1
            error_code = MYSQL_ERRNO,
            error_msg = MESSAGE_TEXT;
       
        insert into tbl_errlog (error_date, error_code, error_msg)
        values (now(), error_code, error_msg);
    end;
    
  
    declare continue handler for 1452
    begin
        GET DIAGNOSTICS CONDITION 1
            error_code = MYSQL_ERRNO,
            error_msg = MESSAGE_TEXT;
     
        insert into tbl_errlog (error_date, error_code, error_msg)
        values (now(), error_code, error_msg);
        
        set lec_code = 0;
        insert into tbl_registration values (s_id, lec_code, lec_duration);
    end;

    insert into tbl_registration values (s_id, lec_code, lec_duration);
    select * from tbl_registration;
end $$
delimiter ;
CALL proc_insert_tbl_registration('20190001', 1001, '2023-05-22 - 2023-06-21');
CALL proc_insert_tbl_registration('20190001', 1001, '2023-05-22 - 2023-06-21');
CALL proc_insert_tbl_registration('20190001', 7001, '2023-05-22 - 2023-06-21');
CALL proc_insert_tbl_registration('70190001', 1001, '2023-05-22 - 2023-06-21');
delete from tbl_errlog;
delete from tbl_registration;
select * from tbl_errlog;
select * from tbl_registration;
show errors;

-- 05
drop trigger trg_student_update_trg;
drop table c_tbl_student;

DELETE FROM tbl_student WHERE s_id='20191234';
delimiter //
create trigger trg_student_update_trg
after update
on tbl_student
for each row
begin
	insert into tbl_student_bak (s_id, s_name, s_phone,update_date)
    values(OLD.s_id,OLD.s_name,OLD.s_phone,now());
    end //
delimiter ;
insert into tbl_student(s_id, s_name, s_phone) values('20191234','나나나','010-1234-1234');
update tbl_student set s_name='우우우' where s_id='20191234';
select * from tbl_student;
select * from tbl_student_bak;
delete from tbl_student where s_id='20191234';
delete from tbl_student_bak;
show triggers;

-- 06
drop trigger trg_teacher_update_trg;
drop table c_tbl_student;

DELETE FROM tbl_teacher WHERE s_id='20191234';
delimiter //
create trigger trg_teacher_update_trg
after update
on tbl_teacher
for each row
begin
	insert into tbl_teacher_bak (t_id, t_name, t_phone,t_addr,update_date)
    values(old.t_id,old.t_name,old.t_phone,old.t_addr,now());
    end //
delimiter ;
insert into tbl_teacher(t_id, t_name, t_phone,t_addr) values(7,'아무개','010-222-333','대구광역시 달서구');
update tbl_teacher set t_name = '아무무' where t_id = 7;
update tbl_teacher set t_phone = '010-777-7777' where t_id =7;
select * from tbl_teacher;
select * from tbl_teacher_bak;
delete from tbl_teacher where t_id=8;
delete from tbl_teacher_bak;




-- 07
drop trigger trg_student_update_trg;
drop table c_tbl_student;

DELETE FROM tbl_student WHERE s_id='20191234';
delimiter //
create trigger trg_student_delete_trg
after delete
on tbl_student
for each row
begin
	insert into tbl_student_bak (s_id, s_name, s_phone,delete_date)
    values(OLD.s_id,OLD.s_name,OLD.s_phone,now());
    end //
delimiter ;
insert into tbl_student(s_id, s_name, s_phone) values('2000','나나나','010-1234-1234');
update tbl_student set s_name='우우우' where s_id='2000';
delete from tbl_student where s_id = '2000';
delete from tbl_student_bak where s_id = '20000';
select * from tbl_student;
select * from tbl_student_bak;

-- 08
delimiter //
create trigger trg_teacher_delete_trg
after delete
on tbl_teacher
for each row
begin
	insert into tbl_teacher_bak (t_id, t_name, t_phone,t_addr,delete_date)
    values(old.t_id,old.t_name,old.t_phone,old.t_addr,now());
    end //
delimiter ;

delete from tbl_teacher where t_id=7;
select * from tbl_teacher;
select * from tbl_teacher_bak;



