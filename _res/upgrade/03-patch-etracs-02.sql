use etracs255_cagban;


-- ## 2021-11-05

drop table if exists async_notification_failed;
drop table if exists async_notification_delivered;
drop table if exists async_notification_processing;
drop table if exists async_notification_pending;
drop table if exists async_notification;

drop table if exists cashreceiptitem_rpt_noledger; 
drop table if exists cashreceiptitem_rpt; 

rename table cashreceipt_terminal to z20211105_cashreceipt_terminal; 

drop table if exists cloud_notification_failed;
drop table if exists cloud_notification_delivered;
drop table if exists cloud_notification_received;
drop table if exists cloud_notification_pending;
drop table if exists cloud_notification_attachment;
drop table if exists cloud_notification;

drop table if exists image_header; 
drop table if exists image_chunk; 


CREATE TABLE `municipality` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NULL,
  `indexno` varchar(15) NULL,
  `pin` varchar(15) NULL,
  `name` varchar(50) NULL,
  `previd` varchar(50) NULL,
  `parentid` varchar(50) NULL,
  `mayor_name` varchar(100) NULL,
  `mayor_title` varchar(50) NULL,
  `mayor_office` varchar(50) NULL,
  `assessor_name` varchar(100) NULL,
  `assessor_title` varchar(50) NULL,
  `assessor_office` varchar(50) NULL,
  `treasurer_name` varchar(100) NULL,
  `treasurer_title` varchar(50) NULL,
  `treasurer_office` varchar(50) NULL,
  `address` varchar(100) NULL,
  `fullname` varchar(50) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_lgu_municipality_indexno` (`indexno`),
  KEY `ix_lgu_municipality_parentid` (`parentid`),
  KEY `ix_lgu_municipality_previd` (`previd`),
  CONSTRAINT `municipality_ibfk_1` FOREIGN KEY (`objid`) REFERENCES `sys_org` (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


drop table if exists psic; 


CREATE TABLE `remote_mapping` (
  `objid` varchar(50) NOT NULL,
  `doctype` varchar(50) NOT NULL,
  `remote_objid` varchar(50) NOT NULL,
  `createdby_name` varchar(255) NOT NULL,
  `createdby_title` varchar(100) NULL,
  `dtcreated` datetime NOT NULL,
  `orgcode` varchar(10) NULL,
  `remote_orgcode` varchar(10) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_doctype` (`doctype`),
  KEY `ix_orgcode` (`orgcode`),
  KEY `ix_remote_orgcode` (`remote_orgcode`),
  KEY `ix_remote_objid` (`remote_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


rename table specialpass_account to z20211105_specialpass_account; 
rename table specialpass_type to z20211105_specialpass_type; 

rename table sreaccount_incometarget to z20211105_sreaccount_incometarget;
rename table sre_revenue_mapping to z20211105_sre_revenue_mapping;
rename table sreaccount to z20211105_sreaccount;


CREATE TABLE `signatory` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `doctype` varchar(50) NOT NULL,
  `indexno` int(11) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `middlename` varchar(50) NULL,
  `name` varchar(150) NULL,
  `title` varchar(50) NOT NULL,
  `department` varchar(50) NULL,
  `personnelid` varchar(50) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_signatory_doctype` (`doctype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `txnsignatory` (
  `objid` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `personnelid` varchar(50) NULL,
  `type` varchar(25) NOT NULL,
  `caption` varchar(25) NULL,
  `name` varchar(200) NULL,
  `title` varchar(50) NULL,
  `dtsigned` datetime NULL,
  `seqno` int(11) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_signatory_refid` (`refid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

