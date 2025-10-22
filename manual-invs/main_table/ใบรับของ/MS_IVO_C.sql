DROP TABLE IF EXISTS `MS_IVO_C`;

CREATE TABLE `MS_IVO_C` (
  `RECORD_NUMBER` int  AUTO_INCREMENT PRIMARY KEY NOT NULL,
  `INVOICE_NO` char(18) /* COLLATE Thai_CI_AS */  NULL,
  `WORKING_CODE` char(7) /* COLLATE Thai_CI_AS */  NULL,
  `MANUFAC_CODE` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `BUY_UNIT_COST` double  NULL,
  `QTY_ORDER` double  NULL,
  `PACK_RATIO` double  NULL,
  `QTY_FREE` double  NULL,
  `PACK_RATIO2` double  NULL,
  `EXPIRED_DATE1` date  NULL,
  `LOCATION` char(5) /* COLLATE Thai_CI_AS */  NULL,
  `EXPIRED_DATE2` datetime(3)  NULL,
  `LOCATION2` char(5) /* COLLATE Thai_CI_AS */  NULL,
  `PROCESS` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `SUB_PROCESS` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `RECEIVE_NO` char(10) /* COLLATE Thai_CI_AS */  NULL,
  `BAR_CODE` char(13) /* COLLATE Thai_CI_AS */  NULL,
  `EXPIRED_DATE` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `FREE_FLAG` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `REF_FREE` varchar(18) /* COLLATE Thai_CI_AS */  NULL,
  `TRADE_CODE` varchar(18) /* COLLATE Thai_CI_AS */  NULL,
  `MSPOC_RECNO` int  NULL,
  `DEPT_ID` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `VALUE` double  NULL,
  `COST` double  NULL,
  `USER_ID` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `REV_FLAG` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `RCV_FLAG` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `LOT_NO` varchar(40) /* COLLATE Thai_CI_AS */  NULL,
  `USER_CFM` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `TRANSDATA_FLAG` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `QTY_REMCONT` double  NULL,
  `VALUE_REMCONT` double  NULL,
  `CUTPLAN_FLAG` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `TRANSDATA_DATE` datetime(3)  NULL,
  `PLAN_DATE` datetime(3)  NULL,
  `QTY_REMPLAN` double  NULL,
  `VALUE_REMPLAN` double  NULL,
  `QTY_RCV` double  NULL,
  `PACK_CODE` int  NULL,
  `NLEM` smallint  NULL,
  `MOD_SYS` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `REMAIN_QTY` double  NULL,
  `PO_ITEM_TYPE` int  NULL,
  `SEND_FLAG` varchar(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL
);
 


CREATE INDEX `INDEX0`
ON `MS_IVO_C` (
  `RECORD_NUMBER` ASC
);
 

CREATE INDEX `ms_ivo_c0`
ON `MS_IVO_C` (
  `INVOICE_NO` ASC,
  `DEPT_ID` ASC,
  `RECEIVE_NO` ASC
);
 

CREATE INDEX `ms_ivo_c1`
ON `MS_IVO_C` (
  `RECEIVE_NO` ASC,
  `TRADE_CODE` ASC
);
 

CREATE INDEX `ms_ivo_c2`
ON `MS_IVO_C` (
  `RECEIVE_NO` ASC,
  `FREE_FLAG` ASC,
  `TRADE_CODE` ASC,
  `LOT_NO` ASC
);
 

