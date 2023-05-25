
-- 04 Error_log 기록하는 테이블처리
USE lmsdb;

SHOW ERRORS;

DROP PROCEDURE IF EXISTS proc_insert_tbl_registration;
DELIMITER $$
CREATE PROCEDURE proc_insert_tbl_registration(IN sid VARCHAR(20), IN icode INT, IN iduration VARCHAR(100))
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
SELECT * FROM tbl_registration_errlog;
show errors;





