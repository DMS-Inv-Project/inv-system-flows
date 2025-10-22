DROP TABLE IF EXISTS `MS_IVO`;

CREATE TABLE `MS_IVO` (
  `RECORD_NUMBER` int  AUTO_INCREMENT PRIMARY KEY NOT NULL,
  `INVOICE_NO` char(18) /* COLLATE Thai_CI_AS */  NULL,
  `INVOICE_DATE_OLD` datetime(3)  NULL,
  `DATE_RECEIVE_OLD` datetime(3)  NULL,
  `PO_NO` varchar(15) /* COLLATE Thai_CI_AS */  NULL,
  `VENDOR_CODE` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `BUDGET_TYPE` char(2) /* COLLATE Thai_CI_AS */  NULL,
  `TOTAL_COST` double  NULL,
  `TOTAL_ITEM` double  NULL,
  `DISCOUNT` double  NULL,
  `DISCOUNT2` double  NULL,
  `PROCESS` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `RECEIVE_NO` char(10) /* COLLATE Thai_CI_AS */  NULL,
  `ERROR_ENTER` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `ERROR_PROCESS` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `RCV_CHKER1` char(3) /* COLLATE Thai_CI_AS */  NULL,
  `RCV_CHKER2` char(3) /* COLLATE Thai_CI_AS */  NULL,
  `RCV_CHKER3` char(3) /* COLLATE Thai_CI_AS */  NULL,
  `BUY_METHOD` char(2) /* COLLATE Thai_CI_AS */  NULL,
  `BUY_COMMON` char(2) /* COLLATE Thai_CI_AS */  NULL,
  `DATE_ACC` datetime(3)  NULL,
  `HOLD_ACC` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `PO_DATE` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `DEPT_ID` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `TOTAL_VALUE` double  NULL,
  `USER_ID` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `INVOICE_DATE` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `RECEIVE_DATE` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `RCV_FLAG` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `AIC_NAME` varchar(60) /* COLLATE Thai_CI_AS */  NULL,
  `AI_NO` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `BILLING_DATE` varchar(8) /* COLLATE Thai_CI_AS */  NULL,
  `MOD_SYS` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `PRE_RECEIVE_NO` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `RCV_TIME` char(4) /* COLLATE Thai_CI_AS */  NULL,
  `ASN_NO` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `SEND_FLAG` varchar(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL
);
 


CREATE UNIQUE INDEX `ms_ivo0`
ON `MS_IVO` (
  `RECORD_NUMBER` ASC
);
 

CREATE INDEX `ms_ivo1`
ON `MS_IVO` (
  `RECEIVE_NO` ASC
);
 

