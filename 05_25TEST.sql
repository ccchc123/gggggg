
use lmsdb;

desc tbl_current_lecture;      -- t_id lec_code class_no
select * from tbl_current_lecture; 
desc tbl_lecture;
select * from tbl_lecture;
desc tbl_teacher;
desc tbl_classroom;

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





-- 5번 

drop trigger trg_student_update_trg;

delimiter //
create trigger trg_student_update_trg
after update
on tbl_student
for each row
begin
	insert into tbl_student_bak 
    values(OLD.s_id,OLD.s_name,OLD.s_phone, now());
    end //
delimiter ;
insert into tbl_student values('1122','나나나','010-1234-1234');
update tbl_student set s_name='우우우' where s_id='2019124';
select * from tbl_student;
select * from tbl_student_bak;

-- 6번 
delimiter $$
create trigger tbl_teacher_update_trg
after delete
on tbl_teacher
for each row
begin
	insert into tbl_teacher_bak values(
    old.t_id,old.t_name,old.t_phone,old.t_addr,now()
    );
end $$
delimiter ;

insert into tbl_teacher values(8,'아무개','010-222-333','대구광역시 달서구');
update tbl_teacher set t_name = '아무무' where t_id = 7;
update tbl_teacher set t_phone = '010-777-7777' where t_id =7;
select * from tbl_teacher;
select * from tbl_teacher_bak;


-- 7번 

drop trigger trg_student_delete_trg;

delimiter //
create trigger trg_student_delete_trg
after delete
on tbl_student
for each row
begin
	insert into tbl_student_bak
    values(OLD.s_id,OLD.s_name,OLD.s_phone);
    update tbl_student
	set delete_date = now()
    where tbl_student.t_id = tbl_student_bak.t_id;
    end //
delimiter ;
insert into tbl_student values('2000','나나나','010-1234-1234');
update tbl_student set s_name='우우우' where s_id='2000';
delete from tbl_student where s_id = '2000';
delete from tbl_student_bak where s_id = '20000';
select * from tbl_student;
select * from tbl_student_bak;




