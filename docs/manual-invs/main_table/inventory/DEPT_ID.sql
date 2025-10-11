DROP TABLE IF EXISTS `DEPT_ID`;

CREATE TABLE `DEPT_ID` (
  `RECORD_NUMBER` int  AUTO_INCREMENT PRIMARY KEY NOT NULL,
  `DEPT_ID` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `DEPT_NAME` char(50) /* COLLATE Thai_CI_AS */  NULL,
  `KEEP_INV` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `HIDE` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `INV_TYPE` varchar(2) /* COLLATE Thai_CI_AS */  NULL,
  `HOSP_TYPE` int  NULL,
  `DISP_DEPT` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `DEPT_TYPE` varchar(2) /* COLLATE Thai_CI_AS */  NULL,
  `SUPPLY_OFFICER` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `SUPPLY_DIRECTOR` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `DOC_REF` varchar(20) /* COLLATE Thai_CI_AS */  NULL,
  `INV_DIRECTOR` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `PREFIX_PO` varchar(2) /* COLLATE Thai_CI_AS */  NULL,
  `STD_CODE` varchar(6) /* COLLATE Thai_CI_AS */  NULL,
  `MOD_SYS` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `SUPPLY_DIRECTOR_ID` int  NULL,
  `SUPPLY_OFFICER_ID` int  NULL,
  `INV_DIRECTOR_ID` int  NULL,
  `DEPT_UID` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `LINE_TOKEN` varchar(50) /* COLLATE Thai_CI_AS */  NULL,
  `CAL_RATE` varchar(1) /* COLLATE Thai_CI_AS */  NULL,
  `EMAIL` varchar(60) /* COLLATE Thai_CI_AS */  NULL,
  `ADDRESS` varchar(150) /* COLLATE Thai_CI_AS */  NULL,
  `RCV_TRANSFER` varchar(1) /* COLLATE Thai_CI_AS */  NULL
);
 

CREATE UNIQUE INDEX `dept_id`
ON `DEPT_ID` (
  `DEPT_ID` ASC
);
 

