use v255_caticlan_go;


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
