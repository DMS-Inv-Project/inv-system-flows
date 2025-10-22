DROP TABLE IF EXISTS `DRUG_GN`;

CREATE TABLE `DRUG_GN` (
  `WORKING_CODE` char(7) /* COLLATE Thai_CI_AS */  NULL,
  `DRUG_NAME_KEY` char(15) /* COLLATE Thai_CI_AS */  NULL,
  `DRUG_NAME` char(50) /* COLLATE Thai_CI_AS */  NULL,
  `DOSAGE_FORM` char(20) /* COLLATE Thai_CI_AS */  NULL,
  `SALE_UNIT` char(5) /* COLLATE Thai_CI_AS */  NULL,
  `COMPOSITION` char(50) /* COLLATE Thai_CI_AS */  NULL,
  `GROUP_KEY` char(15) /* COLLATE Thai_CI_AS */  NULL,
  `GROUP` char(60) /* COLLATE Thai_CI_AS */  NULL,
  `STD_PRICE1` double  NULL,
  `STD_RATIO1` double  NULL,
  `STD_PRICE2` double  NULL,
  `STD_RATIO2` double  NULL,
  `STD_PRICE3` double  NULL,
  `STD_RATIO3` double  NULL,
  `SALE_UNIT_PRICE` double  NULL,
  `TOTAL_COST` double  NULL,
  `QTY_ON_HAND` double  NULL,
  `REORDER_QTY` double  NULL,
  `MIN_LEVEL` double  NULL,
  `RATE_PER_MONTH` double  NULL,
  `PRODUCTION` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `OK` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `TOTAL_VALUE` double  NULL,
  `WORK_CODE_KEY` char(3) /* COLLATE Thai_CI_AS */  NULL,
  `MAX_LEVEL` double  NULL,
  `SPECIAL_CODE` char(2) /* COLLATE Thai_CI_AS */  NULL,
  `DATE_ENTER` datetime(3)  NULL,
  `GROUP_CODE` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `SUPPLY_TYPE` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `ED_LIST_CODE` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `NOTE` char(60) /* COLLATE Thai_CI_AS */  NULL,
  `LOCATION` char(5) /* COLLATE Thai_CI_AS */  NULL,
  `QTY_UNIT` double  NULL,
  `PACK_UNIT` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `HIDE` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `DFORM_ID` int  NULL,
  `SALE_UNIT_ID` int  NULL,
  `STRENGTH` double  NULL,
  `STRENGTH_UNIT` varchar(20) /* COLLATE Thai_CI_AS */  NULL,
  `EXPRESS_CODE` char(15) /* COLLATE Thai_CI_AS */  NULL,
  `SUBCOM` varchar(5) /* COLLATE Thai_CI_AS */  NULL,
  `LAST_BUY` datetime(3)  NULL,
  `LAST_BUY_COST` double  NULL,
  `LAST_VENDOR_CODE` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `IS_ED` smallint  NULL,
  `ED_LIST` smallint  NULL,
  `HOSP_LIST` smallint  NULL,
  `VEN_FLAG` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `ISSUE_DATE` datetime(3)  NULL,
  `LAST_PACK_CODE` int  NULL,
  `GPUID` int  NULL,
  `DRUG_NAME_TH` varchar(50) /* COLLATE Thai_CI_AS */  NULL,
  `COLOR` int  NULL,
  `MOD_SYS` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `STRENGTH_DENO` double  NULL,
  `STR_UID` int  NULL,
  `STR_DENO_UID` int  NULL,
  `IS_HAD` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `USE_TRADE_DIS` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `LAST_NOTIFY_HAD` datetime(3)  NULL,
  `USER_ID` varchar(32) /* COLLATE Thai_CI_AS */  NULL,
  `REF_PRICE_DATE` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `MIT` varchar(1) /* COLLATE Thai_CI_AS */  NULL,
  `CONT_VALUE` double  NULL,
  `CONT_UNIT_ID` int  NULL,
  `CHANGE_DATE` datetime(3)  NULL,
  `STD_PRICE4` datetime(3)  NULL,
  `STD_PRICE5` double  NULL,
  `STD_RATIO4` double  NULL,
  `STD_RATIO5` double  NULL
);

CREATE INDEX `drug_gn0`
ON `DRUG_GN` (
  `WORKING_CODE` ASC
)
;
 
CREATE INDEX `drug_gn1`
ON `DRUG_GN` (
  `DRUG_NAME` ASC
)
;
 ALTER TABLE `DRUG_GN` ADD CONSTRAINT `UQ__DRUG_GN__1BFA42A3132C41B9` UNIQUE (`WORKING_CODE` ASC)
;
 

