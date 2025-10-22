DROP TABLE IF EXISTS `SM_PO_C`;

CREATE TABLE `SM_PO_C` (
  `RECORD_NUMBER` int  AUTO_INCREMENT PRIMARY KEY NOT NULL,
  `SUB_PO_NO` char(12) /* COLLATE Thai_CI_AS */  NULL,
  `WORKING_CODE` char(7) /* COLLATE Thai_CI_AS */  NULL,
  `QTY_ORDER` double  NULL,
  `QTY_RCV` double  NULL,
  `PACK_RATIO` double  NULL,
  `COST` double  NULL,
  `VALUE` double  NULL,
  `VENDOR_CODE` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `MANUFAC_CODE` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `QTY_RCV1` double  NULL,
  `PACK_RATIO1` double  NULL,
  `EXPIRED_DATE1` datetime(3)  NULL,
  `LOCATION1` char(5) /* COLLATE Thai_CI_AS */  NULL,
  `COST1` double  NULL,
  `VALUE1` double  NULL,
  `VENDOR_CODE2` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `MANUFAC_CODE2` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `QTY_RCV2` double  NULL,
  `PACK_RATIO2` double  NULL,
  `EXPIRED_DATE2` datetime(3)  NULL,
  `LOCATION2` char(5) /* COLLATE Thai_CI_AS */  NULL,
  `COST2` double  NULL,
  `VALUE2` double  NULL,
  `VENDOR_CODE3` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `MANUFAC_CODE3` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `QTY_RCV3` double  NULL,
  `PACK_RATIO3` double  NULL,
  `EXPIRED_DATE3` datetime(3)  NULL,
  `LOCATION3` char(5) /* COLLATE Thai_CI_AS */  NULL,
  `COST3` double  NULL,
  `VALUE3` double  NULL,
  `PROCESS` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `SUB_PROCESS` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `BAR_CODE` char(13) /* COLLATE Thai_CI_AS */  NULL,
  `TRADE_CODE` varchar(18) /* COLLATE Thai_CI_AS */  NULL,
  `EXPIRED_DATE` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `LOCATION` char(5) /* COLLATE Thai_CI_AS */  NULL,
  `USER_ID` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `CONFIRM_FLAG` varchar(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `BUY_UNIT_COST` double  NULL,
  `LOT_NO` varchar(40) /* COLLATE Thai_CI_AS */  NULL,
  `USER_CFM` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `CANCEL_DISP` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `SUB_FLAG` int  NULL,
  `PACK_COST` double  NULL,
  `REQ_DATE` varchar(8) /* COLLATE Thai_CI_AS */  NULL,
  `CONFIRM_DATE` varchar(8) /* COLLATE Thai_CI_AS */  NULL,
  `PACK_CODE` int  NULL,
  `NLEM` smallint  NULL,
  `MOD_SYS` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `REMARK` varchar(100) /* COLLATE Thai_CI_AS */  NULL,
  `CLIENT_IP` varchar(15) /* COLLATE Thai_CI_AS */  NULL,
  `SEND_CANCEL` varchar(1) /* COLLATE Thai_CI_AS */  NULL,
  `QTY_CFM` varchar(1) /* COLLATE Thai_CI_AS */  NULL,
  `LAST_UPD` datetime(3)  NULL,
  `REV_DATE` datetime(3)  NULL,
  `APP_VERSION` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `WA_COST` double  NULL
);
 
 
CREATE UNIQUE INDEX `INDEX0`
ON `SM_PO_C` (
  `RECORD_NUMBER` ASC
);
 

CREATE INDEX `SM_PO_C1`
ON `SM_PO_C` (
  `SUB_PO_NO` ASC
);
 

