use lmsdb;

desc tbl_current_lecture;      -- t_id lec_code class_no
select * from tbl_current_lecture; 
desc tbl_lecture;
select * from tbl_lecture;
desc tbl_teacher;
desc tbl_classroom;

-- CREATE VIEW view_current_lecture_details AS
SELECT cl.*, cr.amount, lec.lec_name, t.*
FROM tbl_current_lecture cl
INNER JOIN tbl_classroom cr ON cl.class_no = cr.class_no
INNER JOIN tbl_lecture lec ON cl.lec_code = lec.lec_code
INNER JOIN tbl_teacher t ON cl.t_id = t.t_id;



create view view_current_lecture 
as
select lec_code
from tbl_current_lecture CU
inner join tbl_classroom C on CU.class_no = C.class_no
inner join tbl_teacher T
on CU.t_id = T.t_id
inner join tbl_lecture L
on CU.lec_code = L.lec_code;

SELECT l.lec_name, cl.lec_time  AS lec_time_count
FROM tbl_current_lecture cl
JOIN tbl_lecture l ON cl.lec_code = l.lec_code
GROUP BY l.lec_name, cl.lec_time;


select lec.lec_name, cl.lec_time
from tbl_current_lecture cl
inner join tbl_lecture lec on lec.lec_code = cl.lec_code
group by rollup (cl.lec_time, lec.lec_name);



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




delimiter //
create trigger trg_student_update_trg2
after update
on c_tbl_student
for each row
begin
	insert into c_tbl_student_bak 
    values(OLD.s_id,OLD.s_name,OLD.s_phone);
    end //
delimiter ;
insert into c_tbl_student values('20191234','나나나','010-1234-1234',now(),now());
update c_tbl_student set s_name='우우우' where s_id='20191234';
select * from c_tbl_student;
select * from c_tbl_student_bak;





USE lmsdb;

SHOW ERRORS;

DROP PROCEDURE IF EXISTS proc_insert_tbl_registration;
DELIMITER $$
CREATE PROCEDURE proc_insert_tbl_registration(IN sid VARCHAR(45), IN icode INT, IN iduration VARCHAR(100))
BEGIN
    DECLARE error_code VARCHAR(5);
    DECLARE error_message VARCHAR(255);
    
    -- PK duplication exception handling
    DECLARE CONTINUE HANDLER FOR 1062
    BEGIN
        SHOW ERRORS;
        GET DIAGNOSTICS CONDITION 1
            error_code = MYSQL_ERRNO,
            error_message = MESSAGE_TEXT;
        -- SELECT error_code, error_message;
        INSERT INTO tbl_registration_errlog VALUES (sid, icode, iduration);
    END;
    
    -- Exception Code 1265 
    DECLARE CONTINUE HANDLER FOR 1265
    BEGIN
        SHOW ERRORS;
        GET DIAGNOSTICS CONDITION 1
            error_code = MYSQL_ERRNO,
            error_message = MESSAGE_TEXT;
        -- SELECT error_code, error_message;
        INSERT INTO tbl_std_errlog VALUES (no, error_code, error_date, error_message);
        INSERT INTO tbl_registration_errlog VALUES (sid, icode, iduration);
    END;
    
    INSERT INTO tbl_registration_errlog VALUES (sid, icode, iduration);
    SELECT * FROM tbl_registration_errlog;
END $$
DELIMITER ;

select * from tbl_registration;
CALL proc_insert_tbl_registration('20190001',1001,'2023-05-22- 2023-06-21');
show errors;
