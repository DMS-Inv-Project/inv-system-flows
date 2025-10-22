DROP TABLE IF EXISTS `DRUG_VN`;


CREATE TABLE `DRUG_VN` (
  `RECORD_NUMBER` int  AUTO_INCREMENT PRIMARY KEY NOT NULL,
  `WORKING_CODE` char(7) /* COLLATE Thai_CI_AS */  NULL,
  `VENDOR_CODE` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `TRADE_NAME_KEY` char(15) /* COLLATE Thai_CI_AS */  NULL,
  `TRADE_NAME` char(50) /* COLLATE Thai_CI_AS */  NULL,
  `PACK_RATIO` double  NULL,
  `BUY_UNIT_COST` double  NULL,
  `MANUFAC_CODE` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `RECORD_STATUS` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `LAST_BUY` datetime(3)  NULL,
  `REGIST_NO` char(15) /* COLLATE Thai_CI_AS */  NULL,
  `NOTE` char(30) /* COLLATE Thai_CI_AS */  NULL,
  `BAR_CODE` char(13) /* COLLATE Thai_CI_AS */  NULL,
  `STD_CODE` char(24) /* COLLATE Thai_CI_AS */  NULL,
  `GENERIC_CODE` char(24) /* COLLATE Thai_CI_AS */  NULL,
  `SALE_UNIT_PRICE` double  NULL,
  `TRADE_CODE` varchar(18) /* COLLATE Thai_CI_AS */  NOT NULL,
  `LAST_VENDOR` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `LAST_PACK_RATIO` double  NULL,
  `LAST_BUY_COST` double  NULL,
  `HIDE` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `TRADE_FLAG` smallint  NULL,
  `IMPORT_FLAG` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `ED_LIST` smallint  NULL,
  `IS_ED` smallint  NULL,
  `SUB_COM_CODE` int  NULL,
  `HOSP_LIST` int  NULL,
  `UNIT_PRICE` double  NULL,
  `IS_ED_OLD` smallint  NULL,
  `IMPORT_FLAG_OLD` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `ED_LIST_OLD` smallint  NULL,
  `TRADE_FLAG_OLD` smallint  NULL,
  `HOSP_LIST_OLD` int  NULL,
  `PICTURE` longblob  NULL,
  `TMTID` bigint  NULL,
  `24DIGIT` char(24) /* COLLATE Thai_CI_AS */  NULL,
  `ATC` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `GTIN` varchar(128) /* COLLATE Thai_CI_AS */  NULL,
  `CUSTOMER_PRICE` double  NULL,
  `ISSUE_DATE` datetime(3)  NULL,
  `MOD_SYS` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `USER_ID` varchar(32) /* COLLATE Thai_CI_AS */  NULL,
  `CHANGE_DATE` datetime(3)  NULL,
  `PREMA_FLAG` varchar(1) /* COLLATE Thai_CI_AS */  NULL,
  `DEF_BUYCOM` varchar(2) /* COLLATE Thai_CI_AS */  NULL,
  `REMARK` varchar(255) /* COLLATE Thai_CI_AS */  NULL,
  `USE_IMPORT_PROD` varchar(255) /* COLLATE Thai_CI_AS */  NULL,
  `GPSC` varchar(20) /* COLLATE Thai_CI_AS */  NULL
);
 

CREATE INDEX `drug_vn0`
ON `DRUG_VN` (
  `TRADE_CODE` ASC
);
 

CREATE UNIQUE INDEX `INDEX0`
ON `DRUG_VN` (
  `RECORD_NUMBER` ASC
);
 

CREATE INDEX `drug_vn1`
ON `DRUG_VN` (
  `TRADE_NAME` ASC
)
;
 

CREATE INDEX `drug_vn2`
ON `DRUG_VN` (
  `WORKING_CODE` ASC
)
; 

