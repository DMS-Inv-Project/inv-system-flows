DROP TABLE IF EXISTS `CNT`;

CREATE TABLE `CNT` (
  `CNT_NO` varchar(20) /* COLLATE Thai_CI_AS */  NOT NULL,
  `EGP_NO` varchar(20) /* COLLATE Thai_CI_AS */  NULL,
  `PJT_NO` varchar(20) /* COLLATE Thai_CI_AS */  NULL,
  `PARTIES_CODE` varchar(20) /* COLLATE Thai_CI_AS */  NULL,
  `EFFECTIVE_DATE` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `END_DATE` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `BUY_METHOD` char(2) /* COLLATE Thai_CI_AS */  NULL,
  `BUY_COMMON` char(2) /* COLLATE Thai_CI_AS */  NULL,
  `LEAD_TIME` varchar(3) /* COLLATE Thai_CI_AS */  NULL,
  `DOC_NO` varchar(20) /* COLLATE Thai_CI_AS */  NULL,
  `AUTH_NO` varchar(20) /* COLLATE Thai_CI_AS */  NULL,
  `AUTH_DATE` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `AUTH_TIME` char(4) /* COLLATE Thai_CI_AS */  NULL,
  `AIC_NO` varchar(20) /* COLLATE Thai_CI_AS */  NULL,
  `REMARK` nvarchar(255) /* COLLATE Thai_CI_AS */  NULL,
  `TOTAL_ITEM` int  NULL,
  `TOTAL_COST` double  NULL,
  `USER_ID` varchar(20) /* COLLATE Thai_CI_AS */  NULL,
  `DEPOSIT` double  NULL,
  `AIC_NAME` varchar(60) /* COLLATE Thai_CI_AS */  NULL,
  `AIC_DATE` varchar(8) /* COLLATE Thai_CI_AS */  NULL,
  `FISCAL_YEAR` char(4) /* COLLATE Thai_CI_AS */  NULL,
  `REMAIN_COST` double  NULL,
  `LAST_UPDATE` datetime(3)  NULL,
  `MOD_SYS` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `GF_NO` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `CNT_DATE` varchar(8) /* COLLATE Thai_CI_AS */  NULL
);
 