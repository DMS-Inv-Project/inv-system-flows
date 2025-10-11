DROP TABLE IF EXISTS `SM_PO`;

CREATE TABLE `SM_PO` (
  `RECORD_NUMBER` int  AUTO_INCREMENT PRIMARY KEY NOT NULL,
  `SUB_PO_NO` char(12) /* COLLATE Thai_CI_AS */  NULL,
  `SUB_PO_DATE_OLD` datetime(3)  NULL,
  `DEPT_ID` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `ACC_NO` char(5) /* COLLATE Thai_CI_AS */  NULL,
  `TOTAL_ITEM` double  NULL,
  `TOTAL_COST` double  NULL,
  `TOTAL_VALUE` double  NULL,
  `SYSDATE` datetime(3)  NULL,
  `OK` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `PASSWORD` char(5) /* COLLATE Thai_CI_AS */  NULL,
  `PROCESS` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `ERROR_ENTER` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `ERROR_PROCESS` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `STOCK_ID` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `USER_ID` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `SUB_PO_DATE` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `CONFIRM_FLAG` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `PRIOR_FLAG` smallint DEFAULT 99 NULL,
  `R_S_STATUS` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `SEND_FLAG` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `PRINT_FLAG` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `MOD_SYS` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `REF_NO` varchar(15) /* COLLATE Thai_CI_AS */  NULL,
  `CONFIRM_DATE` varchar(8) /* COLLATE Thai_CI_AS */  NULL,
  `CONFIRM_TIME` varchar(4) /* COLLATE Thai_CI_AS */  NULL,
  `DIST_TYPE` int  NULL,
  `SUB_PO_UNO` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `REQ_INTER` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `CFM_INTER` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL
);
 


CREATE UNIQUE INDEX `INDEX0`
ON `SM_PO` (
  `RECORD_NUMBER` ASC
);
 

CREATE INDEX `INDEX1`
ON `SM_PO` (
  `SUB_PO_NO` ASC,
  `STOCK_ID` ASC,
  `SUB_PO_DATE` ASC
);
 

