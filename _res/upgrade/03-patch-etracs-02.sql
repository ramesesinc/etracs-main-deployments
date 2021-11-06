use caticlan_go;


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



-- ## 2021-08-27 for Ticketing Module

insert into sys_domain (
  name, connection
) 
select * 
from ( 
  select 'Ticketing' as name, 'ticketing' as connection 
)t0 
where (
  select count(*) from sys_domain where name = t0.name 
) = 0 
; 

insert into cashreceipt_plugin (
  objid, connection, servicename
) 
select * 
from ( 
  select 
    'ticketing' as objid, 
    'ticketing' as connection, 
    'TicketingPaymentService' as servicename 
)t0 
where (
  select count(*) from cashreceipt_plugin where objid = t0.objid 
) = 0 
; 



-- ## 2021-11-05 for Ticketing Module

INSERT IGNORE INTO sys_orgclass (name, title, parentclass, handler) 
VALUES ('TERMINAL', 'TERMINAL', 'PROVINCE', NULL);

INSERT IGNORE INTO sys_org (objid, name, orgclass, parent_objid, parent_orgclass, code, root, txncode) 
VALUES ('038CAT', 'CAGBAN JETTY PORT TERMINAL', 'TERMINAL', '038', 'PROVINCE', '038CAT', 0, NULL);


INSERT IGNORE INTO itemaccount (
  objid, state, type, 
  code, title, description, 
  org_objid, org_name, defaultvalue, valuetype, 
  parentid, generic, sortorder, hidefromlookup, 
  fund_objid, fund_code, fund_title   
) 
select t0.*, 
  fund.objid as fund_objid, fund.code as fund_code, fund.title as fund_title  
from ( 
  select 
    'AKLAN_TERMINAL_ONLINE_CATICLAN' as objid, 'ACTIVE' as state, 'REVENUE' as type, 
    '623_CJPPT' as code, 'AKLAN TERMINAL (ONLINE) - CATICLAN' as title, 'AKLAN TERMINAL (ONLINE) - CATICLAN' as description, 
    '038CAT' as org_objid, 'CATICLAN JETTY PORT TERMINAL' as org_name, 0.00 as defaultvalue, 'ANY' as valuetype, 
    NULL as parentid, 0 as generic, 0 as sortorder, 0 as hidefromlookup 
)t0, fund 
where fund.title = 'EEDD' 
;



create table ztmp_collectors 
select * 
from ( 
  select distinct 
    collector_objid as user_objid, 'TREASURY.COLLECTOR' as usergroup_objid 
  from cashreceipt 
  union 
  select distinct 
    subcollector_objid as user_objid, 'TREASURY.SUBCOLLECTOR' as usergroup_objid 
  from cashreceipt 
)t0 
where user_objid is not null 
order by user_objid, usergroup_objid 
;

delete from sys_usergroup_member where usergroup_objid = 'TREASURY.SUBCOLLECTOR'
; 

insert into sys_usergroup_member (
  objid, usergroup_objid, user_objid, user_username, user_firstname, user_lastname, org_objid, org_name, org_orgclass 
) 
select 
  CONCAT('UGM-', MD5(CONCAT(z.user_objid, z.usergroup_objid, org.objid))) as objid, 
  z.usergroup_objid, z.user_objid, u.username as user_username, u.firstname as user_firstname, u.lastname as user_lastname, 
  org.objid as org_objid, org.name as org_name, org.orgclass as org_orgclass 
from ztmp_collectors z 
  inner join sys_org org on org.orgclass = 'TERMINAL' 
  inner join sys_user u on u.objid = z.user_objid 
where z.usergroup_objid = 'TREASURY.SUBCOLLECTOR'
  and org.objid in ('1','AKL','RORO') 
;

drop table ztmp_collectors
;



update collectiontype set state='INACTIVE', system=1 where `handler` like '%terminal%' 
;

insert into collectiontype (
  objid, state, name, title, formno, `handler`, 
  allowbatch, allowonline, allowoffline, sortorder, 
  org_objid, org_name, allowpaymentorder, allowkiosk, 
  allowcreditmemo, system 
) 
select 
  CONCAT('COLLTYPE-', MD5(CONCAT(ct.name, ct.handler, ct.org_objid))) as objid, 
  'ACTIVE' as state, ct.name, ct.title, ct.formno, 'ticketing' as `handler`, 
  0 as allowbatch, 1 as allowonline, 1 as allowoffline, ct.sortorder, ct.org_objid, ct.org_name, 
  0 as allowpaymentorder, 0 as allowkiosk, 0 as allowcreditmemo, 0 as system 
from collectiontype ct 
where ct.name = 'AKLAN-TERMINAL-TOURIST' 
;
