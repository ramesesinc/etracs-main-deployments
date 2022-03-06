use etracs255_cagban;


-- ## 2021-08-20
INSERT INTO `sys_domain` (`name`, `connection`) VALUES ('Ticketing', 'ticketing');



-- ## 2021-08-23
DROP VIEW IF EXISTS `vw_collectiontype`
;
CREATE VIEW `vw_collectiontype` AS 
select 
	`c`.`objid` AS `objid`,
	`c`.`state` AS `state`,
	`c`.`name` AS `name`,
	`c`.`title` AS `title`,
	`c`.`formno` AS `formno`,
	`c`.`handler` AS `handler`,
	`c`.`allowbatch` AS `allowbatch`,
	`c`.`barcodekey` AS `barcodekey`,
	`c`.`allowonline` AS `allowonline`,
	`c`.`allowoffline` AS `allowoffline`,
	`c`.`sortorder` AS `sortorder`,
	`o`.`org_objid` AS `orgid`,
	`c`.`fund_objid` AS `fund_objid`,
	`c`.`fund_title` AS `fund_title`,
	`c`.`category` AS `category`,
	`c`.`queuesection` AS `queuesection`,
	`c`.`system` AS `system`,
	`af`.`formtype` AS `af_formtype`,
	`af`.`serieslength` AS `af_serieslength`,
	`af`.`denomination` AS `af_denomination`,
	`af`.`baseunit` AS `af_baseunit`,
	`c`.`allowpaymentorder` AS `allowpaymentorder`,
	`c`.`allowkiosk` AS `allowkiosk`,
	`c`.`allowcreditmemo` AS `allowcreditmemo`, 
	`c`.`info` AS `info`
from `collectiontype_org` `o` 
	inner join `collectiontype` `c` on `c`.`objid` = `o`.`collectiontypeid` 
	inner join `af` on `af`.`objid` = `c`.`formno` 
where `c`.`state` = 'ACTIVE' 
union 
select 
	`c`.`objid` AS `objid`,
	`c`.`state` AS `state`,
	`c`.`name` AS `name`,
	`c`.`title` AS `title`,
	`c`.`formno` AS `formno`,
	`c`.`handler` AS `handler`,
	`c`.`allowbatch` AS `allowbatch`,
	`c`.`barcodekey` AS `barcodekey`,
	`c`.`allowonline` AS `allowonline`,
	`c`.`allowoffline` AS `allowoffline`,
	`c`.`sortorder` AS `sortorder`, 
	NULL AS `orgid`,
	`c`.`fund_objid` AS `fund_objid`,
	`c`.`fund_title` AS `fund_title`,
	`c`.`category` AS `category`,
	`c`.`queuesection` AS `queuesection`,
	`c`.`system` AS `system`,
	`af`.`formtype` AS `af_formtype`,
	`af`.`serieslength` AS `af_serieslength`,
	`af`.`denomination` AS `af_denomination`,
	`af`.`baseunit` AS `af_baseunit`,
	`c`.`allowpaymentorder` AS `allowpaymentorder`,
	`c`.`allowkiosk` AS `allowkiosk`,
	`c`.`allowcreditmemo` AS `allowcreditmemo`, 
	`c`.`info` AS `info`	
from `collectiontype` `c` 
	inner join `af` on `af`.`objid` = `c`.`formno` 
	left join `collectiontype_org` `o` on `c`.`objid` = `o`.`collectiontypeid` 
where `c`.`state` = 'ACTIVE' 
	and `o`.`objid` is null 
; 




-- ## 2021-09-15

drop view if exists vw_remittance_cashreceiptshare
;
create view vw_remittance_cashreceiptshare AS 
select 
	c.remittanceid AS remittanceid, 
	r.controldate AS remittance_controldate, 
	r.controlno AS remittance_controlno, 
	r.collectionvoucherid AS collectionvoucherid, 
	c.formno AS formno, 
	c.formtype AS formtype, 
  c.controlid as controlid, 
  c.series as series,
	cs.receiptid AS receiptid, 
	c.receiptdate AS receiptdate, 
	c.receiptno AS receiptno, 
	c.paidby AS paidby, 
	c.paidbyaddress AS paidbyaddress, 
	c.org_objid AS org_objid, 
	c.org_name AS org_name, 
	c.collectiontype_objid AS collectiontype_objid, 
	c.collectiontype_name AS collectiontype_name, 
	c.collector_objid AS collectorid, 
	c.collector_name AS collectorname, 
	c.collector_title AS collectortitle, 
	cs.refitem_objid AS refacctid, 
	ia.fund_objid AS fundid, 
	ia.objid AS acctid, 
	ia.code AS acctcode, 
	ia.title AS acctname, 
	(case when v.objid is null then cs.amount else 0.0 end) AS amount, 
	(case when v.objid is null then 0 else 1 end) AS voided, 
	(case when v.objid is null then 0.0 else cs.amount end) AS voidamount, 
	(case when (c.formtype = 'serial') then 0 else 1 end) AS formtypeindex  
from remittance r 
	inner join cashreceipt c on c.remittanceid = r.objid 
	inner join cashreceipt_share cs on cs.receiptid = c.objid 
	inner join itemaccount ia on ia.objid = cs.payableitem_objid 
	left join cashreceipt_void v on v.receiptid = c.objid 
; 


drop view if exists vw_collectionvoucher_cashreceiptshare
;
create view vw_collectionvoucher_cashreceiptshare AS 
select 
  cv.controldate AS collectionvoucher_controldate, 
  cv.controlno AS collectionvoucher_controlno, 
  v.* 
from collectionvoucher cv 
  inner join vw_remittance_cashreceiptshare v on v.collectionvoucherid = cv.objid 
; 



-- ## 2021-09-24

INSERT IGNORE INTO sys_var (name, value, description, datatype, category) 
VALUES ('CASHBOOK_CERTIFIED_BY_NAME', NULL, 'Cashbook Report Certified By Name', 'text', 'REPORT');

INSERT IGNORE INTO sys_var (name, value, description, datatype, category) 
VALUES ('CASHBOOK_CERTIFIED_BY_TITLE', NULL, 'Cashbook Report Certified By Title', 'text', 'REPORT');



-- ## 2021-09-27




-- ## 2021-10-01

INSERT IGNORE INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('cashbook_report_allow_multiple_fund_selection', '0', 'Cashbook Report: Allow Multiple Fund Selection', 'checkbox', 'TC');

INSERT IGNORE INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('liquidate_remittance_as_of_date', '1', 'Liquidate Remittances as of Date', 'checkbox', 'TC');

INSERT IGNORE INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('cashreceipt_reprint_requires_approval', 'false', 'CashReceipt Reprinting Requires Approval', 'checkbox', 'TC');

INSERT IGNORE INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('cashreceipt_void_requires_approval', 'true', 'CashReceipt Void Requires Approval', 'checkbox', 'TC');

INSERT IGNORE INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('deposit_collection_by_bank_account', '0', 'Deposit collection by bank account instead of by fund', 'checkbox', 'TC');