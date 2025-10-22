DROP TABLE IF EXISTS `MS_PO_C`;

CREATE TABLE `MS_PO_C` (
  `RECORD_NUMBER` int  AUTO_INCREMENT PRIMARY KEY NOT NULL,
  `PO_NO` char(10) /* COLLATE Thai_CI_AS */  NULL,
  `WORKING_CODE` char(7) /* COLLATE Thai_CI_AS */  NULL,
  `VENDOR_CODE` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `MANUFAC_CODE` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `BUY_UNIT_COST` double  NULL,
  `QTY_ORDER` double  NULL,
  `QTY_ORDER_RCV` double  NULL,
  `PACK_RATIO1` double  NULL,
  `QTY_FREE` double  NULL,
  `QTY_FREE_RCV` double  NULL,
  `PACK_RATIO2` double  NULL,
  `RCV_FLAG` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `PROCESS` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `FREE_FLAG` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `del_flag` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `ref_free` char(18) /* COLLATE Thai_CI_AS */  NULL,
  `PO_DATE` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `TRADE_CODE` varchar(18) /* COLLATE Thai_CI_AS */  NULL,
  `PACK_RATIO` double  NULL,
  `USER_ID` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `VALUExVAT` double  NULL,
  `MINUSVAT` double  NULL,
  `contract_number` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `remain_qty` double  NULL,
  `remain_amount` double  NULL,
  `ref_flag_remain` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `cancel_flag_remain` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `Cp_flag` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `flg_vat` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `RCV_DATE` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `RUNNO` smallint  NULL,
  `MIDPRICE` double  NULL,
  `PACKUNIT` varchar(20) /* COLLATE Thai_CI_AS */  NULL,
  `CONTRACT_DATE` datetime(3)  NULL,
  `QTY_REMPLAN` double  NULL,
  `VALUE_REMPLAN` double  NULL,
  `PLAN_DATE` datetime(3)  NULL,
  `MESSAGE_REC_DATE` varchar(8) /* COLLATE Thai_CI_AS */  NULL,
  `CHECK_BUYPLAN_DATE` varchar(8) /* COLLATE Thai_CI_AS */  NULL,
  `APPLOVE_BUYPLAN_DATE` varchar(8) /* COLLATE Thai_CI_AS */  NULL,
  `BUY_IN_OUT_PLANFLAG` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `USER_APPLOVE` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `USER_CHECK` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `APPLOVE_BUYPLAN_M_FLAG` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `CHECK_BUYPLAN_M_FLAG` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `TRANS_CREDIT` varchar(3) /* COLLATE Thai_CI_AS */  NULL,
  `PRINT_PODATE` varchar(8) /* COLLATE Thai_CI_AS */  NULL,
  `PRINT_PO_USER` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `PRINT_PO_FLAG` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `VALUE_C` double  NULL,
  `OUTPLAN_REASON` varchar(100) /* COLLATE Thai_CI_AS */  NULL,
  `CP_FLAG_YEAR` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `REMAIN_QTY_BUYPLAN_Y` double  NULL,
  `REMAIN_VALUE_BUYPLAN_Y` double  NULL,
  `SALE_UNIT_ID` int  NULL,
  `REV_FLAG` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `COST` double  NULL,
  `QTY_ON_HAND` double  NULL,
  `RATE_3_MONTH` double  NULL,
  `REMAIN_QTY_EX` double  NULL,
  `RCV_QTY_EX` double  NULL,
  `CNT_NO` varchar(20) /* COLLATE Thai_CI_AS */  NULL,
  `SEND_EX_FLAG` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `REMAIN_QTY_BP` double  NULL,
  `REMAIN_VALUE_BP` double  NULL,
  `BF_QTY_BP` double  NULL,
  `BF_VALUE_BP` double  NULL,
  `SEND_FLAG` char(1) /* COLLATE Thai_CI_AS */ DEFAULT 'N' NULL,
  `REMAIN_QTY_CNT` double  NULL,
  `REMAIN_VALUE_CNT` double  NULL,
  `BF_QTY_CNT` double  NULL,
  `BF_VALUE_CNT` double  NULL,
  `PACK_CODE` int  NULL,
  `NLEM` smallint  NULL,
  `RATE_PER_MONTH` double  NULL,
  `MOD_SYS` varchar(10) /* COLLATE Thai_CI_AS */  NULL,
  `CHG_REF` varchar(13) /* COLLATE Thai_CI_AS */  NULL,
  `MSIVOC_RECNO` int  NULL,
  `BUY_COMMON` varchar(2) /* COLLATE Thai_CI_AS */  NULL,
  `EDI_FLAG` varchar(1) /* COLLATE Thai_CI_AS */  NULL,
  `USER_CANCEL` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `REASON_CANCEL` int  NULL
);
 
CREATE UNIQUE INDEX `INDEX0`
ON `MS_PO_C` (
  `RECORD_NUMBER` ASC
);
 

CREATE INDEX `ms_po_c0`
ON `MS_PO_C` (
  `PO_NO` ASC
);
 

CREATE UNIQUE INDEX `ms_po_c1`
ON `MS_PO_C` (
  `PO_NO` ASC,
  `FREE_FLAG` ASC,
  `WORKING_CODE` ASC,
  `VENDOR_CODE` ASC
);
 

CREATE INDEX `ms_po_c2`
ON `MS_PO_C` (
  `PO_NO` ASC,
  `WORKING_CODE` ASC
);
 


