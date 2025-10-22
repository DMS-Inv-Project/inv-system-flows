DROP TABLE IF EXISTS `INV_MD_C`;
 

CREATE TABLE `INV_MD_C` (
  `RECORD_NUMBER` int  AUTO_INCREMENT PRIMARY KEY NOT NULL,
  `WORKING_CODE` char(7) /* COLLATE Thai_CI_AS */  NULL,
  `PACK_RATIO` double  NULL,
  `QTY_ON_HAND` double  NULL,
  `EXPIRED_DATE_OLD` datetime(3)  NULL,
  `LOCATION` char(5) /* COLLATE Thai_CI_AS */  NULL,
  `LOT_COST` double  NULL,
  `VENDOR_CODE` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `MANUFAC_CODE` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `RECORD_STATUS` char(1) /* COLLATE Thai_CI_AS */  NULL,
  `LOT_VALUE` double  NULL,
  `BAR_CODE` char(13) /* COLLATE Thai_CI_AS */  NULL,
  `TRADE_CODE` varchar(18) /* COLLATE Thai_CI_AS */  NULL,
  `DEPT_ID` char(6) /* COLLATE Thai_CI_AS */  NULL,
  `LOT_NO` char(20) /* COLLATE Thai_CI_AS */ DEFAULT 'Lot001' NULL,
  `USER_ID` varchar(30) /* COLLATE Thai_CI_AS */  NULL,
  `EXPIRED_DATE` char(8) /* COLLATE Thai_CI_AS */  NULL,
  `PACK_COST` double  NULL,
  `PACK_CODE` int  NULL,
  `MOD_SYS` varchar(10) /* COLLATE Thai_CI_AS */  NULL
);
 
CREATE INDEX `inv_md_c0`
ON `INV_MD_C` (
  `EXPIRED_DATE` ASC,
  `TRADE_CODE` ASC,
  `DEPT_ID` ASC,
  `LOT_NO` ASC
);
 


-- SQLINES DEMO *** -----------
-- SQLINES DEMO *** cture for table INV_MD_C
-- SQLINES DEMO *** -----------
ALTER TABLE `INV_MD_C` ADD CONSTRAINT `dep_id` FOREIGN KEY (`DEPT_ID`) REFERENCES `DEPT_ID` (`DEPT_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION;
 

