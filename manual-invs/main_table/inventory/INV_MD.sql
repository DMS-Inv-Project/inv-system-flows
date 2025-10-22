DROP TABLE IF EXISTS `INV_MD`;

CREATE TABLE `INV_MD` (
  `RECORD_NUMBER` int  AUTO_INCREMENT PRIMARY KEY NOT NULL,
  `WORKING_CODE` char(7) /* COLLATE Thai_CI_AS */  NULL,
  `STD_PRICE` double  NULL,
  `STD_RATIO` double  NULL,
  `SALE_UNIT_PRICE` double  NULL,
  `TOTAL_COST` double  NULL,
  `QTY_ON_HAND` double  NULL,
  `REORDER_QTY` double  NULL,
  `MIN_LEVEL` double  NULL,
  `RATE` double  NULL,
  `PRODUCTION` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `TOTAL_VALUE` double  NULL,
  `WORK_CODE_KEY` char(3) /* COLLATE Thai_CI_AS */  NULL,
  `MAX_LEVEL` double  NULL,
  `SPECIAL_CODE` char(2) /* COLLATE Thai_CI_AS */  NULL,
  `LAST_UPDATE` datetime(3)  NULL,
  `NOTE` char(60) /* COLLATE Thai_CI_AS */  NULL,
  `LOCATION` char(5) /* COLLATE Thai_CI_AS */  NULL,
  `QTY_UNIT` double  NULL,
  `PACK_UNIT` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `DEPT_ID` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `USER_ID` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `SELECT_FLAG` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `QTY_REQ` double  NULL,
  `QTY_DISP` double  NULL,
  `FIRST_PACK_RATIO` double  NULL,
  `QTY_ADV` double  NULL,
  `ACCRUED_QTY` double  NULL,
  `RATE_PER_DAY` double  NULL,
  `ABC_USE` double  NULL,
  `ABC_PERCENT` double  NULL,
  `ABC_CUM` double  NULL,
  `ABC_FLAG` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `LAST_PACK_RATIO` double  NULL,
  `LAST_PACK_CODE` int  NULL,
  `HIDE` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `MOD_SYS` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `FORECAST` double  NULL,
  `HIS_RATE` double  NULL,
  `LAST_VENDOR_CODE` int  NULL,
  `KANBAN_RATIO` int  NULL,
  `USE_MINMAX` varchar(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `WA_COST` double DEFAULT 0 NULL,
  `COUNT_ON_HAND` int  NULL
);
 
CREATE UNIQUE INDEX `INDEX0`
ON `INV_MD` (
  `RECORD_NUMBER` ASC
);
 

CREATE INDEX `inv_md_c1`
ON `INV_MD` (
  `WORKING_CODE` ASC,
  `DEPT_ID` ASC
);

ALTER TABLE `INV_MD` ADD CONSTRAINT `UQ__INV_MD__CEE8E7395CAA4170` UNIQUE (`WORKING_CODE` ASC, `DEPT_ID` ASC)
;


