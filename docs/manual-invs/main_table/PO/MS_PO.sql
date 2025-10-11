DROP TABLE IF EXISTS `MS_PO`;

CREATE TABLE `MS_PO` (
  `RECORD_NUMBER` int  AUTO_INCREMENT PRIMARY KEY NOT NULL,
  `PO_NO` char(10) /* COLLATE Thai_CI_AS */  NOT NULL,
  `PO_DATE_OLD` datetime(3)  NULL,
  `VENDOR_CODE` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `BUDGET_TYPE` char(2) /* COLLATE Thai_CI_AS */  NULL,
  `TOTAL_ITEM` double  NULL,
  `TOTAL_COST` double  NULL,
  `OLD_TOTAL_COST` double  NULL,
  `TOTAL_COST_RCV` double  NULL,
  `DISCOUNT` double  NULL,
  `DISCOUNT2` double  NULL,
  `OK` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `PROCESS` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `ERROR_ENTER` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `RCV_CHKER1` char(3) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `RCV_CHKER2` char(3) /* COLLATE Thai_CI_AS */  NULL,
  `RCV_CHKER3` char(3) /* COLLATE Thai_CI_AS */  NULL,
  `BUY_METHOD` char(2) /* COLLATE Thai_CI_AS */  NULL,
  `BUY_COMMON` char(2) /* COLLATE Thai_CI_AS */  NULL,
  `PRINTED` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `del_flag` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `PO_DATE` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `USER_ID` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `PROJECT_NO` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `EGP_NO` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `contract_number` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `SVALUExVAT` double  NULL,
  `SMINUSVAT` double  NULL,
  `flg_vat` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `MIDPRICE` double  NULL,
  `TRANS_CREDIT` varchar(3) /* COLLATE Thai_CI_AS */  NULL,
  `PRINT_PODATE` varchar(8) /* COLLATE Thai_CI_AS */  NULL,
  `PRINT_PO_USER` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `PRINT_PO_FLAG` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `REMARK` varchar(255) /* COLLATE Thai_CI_AS */  NULL,
  `SUPPLIER` varchar(6) /* COLLATE Thai_CI_AS */  NULL,
  `MESSAGE_REC_DATE` varchar(8) /* COLLATE Thai_CI_AS */  NULL,
  `RCV_DATE` varchar(8) /* COLLATE Thai_CI_AS */  NULL,
  `OUTPLAN_REASON` varchar(100) /* COLLATE Thai_CI_AS */  NULL,
  `DEPT_ID` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `VAT_COST` double  NULL,
  `VAT_PERCENT` double  NULL,
  `TOTAL_COST_AV` double  NULL,
  `SUPPLIER_CODE` varchar(6) /* COLLATE Thai_CI_AS */  NULL,
  `REQ_APP_DATE` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `DELIVERY_DATE` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `BILLNUMBER_EX` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `RCV_NO_EX` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `RCV_DATE_EX` varchar(8) /* COLLATE Thai_CI_AS */  NULL,
  `BILLNUMBER_DATE_EX` varchar(8) /* COLLATE Thai_CI_AS */  NULL,
  `REF_NO` varchar(20) /* COLLATE Thai_CI_AS */  NULL,
  `CNT_NO` varchar(20) /* COLLATE Thai_CI_AS */  NULL,
  `AIC_NAME` varchar(60) /* COLLATE Thai_CI_AS */  NULL,
  `TOTAL_COST_AD` double  NULL,
  `REV_FLAG` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `SEND_FLAG` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `BDG_BF` double  NULL,
  `BDG_RM` double  NULL,
  `REQ_APP_NO` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `MOD_SYS` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `RES_DATE` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `GF_NO` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `EDI_FLAG` varchar(1) /* COLLATE Thai_CI_AS */  NULL,
  `EDI_RES` varchar(50) /* COLLATE Thai_CI_AS */  NULL,
  `SEND_PO_DATE` varchar(8) /* COLLATE Thai_CI_AS */  NULL,
  `ACK_DATE` varchar(8) /* COLLATE Thai_CI_AS */  NULL
);
 

CREATE UNIQUE INDEX `INDEX0`
ON `MS_PO` (
  `RECORD_NUMBER` ASC
);
 

CREATE INDEX `ms_po0`
ON `MS_PO` (
  `PO_NO` ASC
);
 

