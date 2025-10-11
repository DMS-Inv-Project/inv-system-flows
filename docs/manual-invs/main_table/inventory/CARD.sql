DROP TABLE IF EXISTS `CARD`; 

CREATE TABLE `CARD` (
  `RECORD_NUMBER` int  AUTO_INCREMENT PRIMARY KEY NOT NULL,
  `WORKING_CODE` char(7) /* COLLATE Thai_CI_AS */  NULL,
  `OPERATE_DATE` datetime(3)  NULL,
  `R_S_STATUS` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `BDG_TYPE` char(2) /* COLLATE Thai_CI_AS */  NULL,
  `R_S_NUMBER` char(12) /* COLLATE Thai_CI_AS */  NULL,
  `DEPT_ID` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `VALUE` double  NULL,
  `COST` double  NULL,
  `ACTIVE_QTY1` double  NULL,
  `ACTIVE_PACK1` double  NULL,
  `ACTIVE_QTY2` double  NULL,
  `ACTIVE_PACK2` double  NULL,
  `ACTIVE_QTY3` double  NULL,
  `ACTIVE_PACK3` double  NULL,
  `REMAIN_QTY` double  NULL,
  `TRADE_CODE` varchar(18) /* COLLATE Thai_CI_AS */  NULL,
  `STOCK_ID` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `ACTIVE_QTY` double  NULL,
  `ACTIVE_PACK` double  NULL,
  `USER_ID` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `R_S_DATE` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `LOT_NO` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `CANCEL_FLAG` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `REMAIN_VALUE` double  NULL,
  `FREE_FLAG` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `REMAIN_COST` double  NULL,
  `NLEM` smallint  NULL,
  `EXPIRED_DATE` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `MOD_SYS` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `REMAIN_QTY_T` double  NULL,
  `REMAIN_COST_T` double  NULL,
  `REMAIN_VALUE_T` double  NULL,
  `APP_VERSION` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `SMPOC_RECNO` int  NULL,
  `REMAIN_QTY_LOT` double  NULL,
  `REMAIN_COST_LOT` double  NULL,
  `REMAIN_VALUE_LOT` double  NULL,
  `VENDOR_CODE` int  NULL,
  `PACK_CODE` int  NULL,
  `WT_AVG` double  NULL,
  `PACK_COST` double  NULL,
  `HN` varchar(7) /* COLLATE Thai_CI_AS */  NULL,
  `VN` varchar(4) /* COLLATE Thai_CI_AS */  NULL,
  `RunNo` smallint  NULL
);
 
CREATE UNIQUE INDEX `CARD0`
ON `CARD` (
  `RECORD_NUMBER` ASC
);
 

CREATE INDEX `card1`
ON `CARD` (
  `WORKING_CODE` ASC,
  `OPERATE_DATE` ASC
);
 

CREATE INDEX `card2`
ON `CARD` (
  `WORKING_CODE` ASC,
  `OPERATE_DATE` ASC,
  `R_S_STATUS` ASC,
  `DEPT_ID` ASC,
  `STOCK_ID` ASC
);
 

CREATE INDEX `card3`
ON `CARD` (
  `R_S_NUMBER` ASC,
  `R_S_STATUS` ASC,
  `TRADE_CODE` ASC,
  `LOT_NO` ASC
);
 

CREATE INDEX `card4`
ON `CARD` (
  `R_S_STATUS` ASC,
  `R_S_NUMBER` ASC,
  `TRADE_CODE` ASC
);
 

CREATE INDEX `card5`
ON `CARD` (
  `R_S_NUMBER` ASC
);
 

CREATE INDEX `card6`
ON `CARD` (
  `R_S_STATUS` ASC
);
 

