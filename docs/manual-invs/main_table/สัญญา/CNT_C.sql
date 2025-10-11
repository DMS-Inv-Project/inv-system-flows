DROP TABLE IF EXISTS `CNT_C`;

CREATE TABLE `CNT_C` (
  `CNT_NO` varchar(20) /* COLLATE Thai_CI_AS */  NOT NULL,
  `WORKING_CODE` char(7) /* COLLATE Thai_CI_AS */  NULL,
  `BUY_UNIT_COST` double  NULL,
  `QTY_CNT` double  NULL,
  `PACK_RATIO` double  NULL,
  `ITEM_TYPE` int  NULL,
  `COST_CNT` double  NULL,
  `RECORD_NUMBER` int  AUTO_INCREMENT PRIMARY KEY NOT NULL,
  `USER_ID` varchar(20) /* COLLATE Thai_CI_AS */  NULL,
  `PERCENT_CNT` double  NULL,
  `QTY_REMAIN` double  NULL,
  `COST_REMAIN` double  NULL,
  `END_DATE` varchar(8) /* COLLATE Thai_CI_AS */  NULL,
  `PACK_CODE` int  NULL,
  `REMARK` longtext /* COLLATE Thai_CI_AS */  NULL,
  `MOD_SYS` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `TRADE_CODE` varchar(18) /* COLLATE Thai_CI_AS */  NULL,
  `BUY_COMMON` varchar(2) /* COLLATE Thai_CI_AS */  NULL
);
 
 