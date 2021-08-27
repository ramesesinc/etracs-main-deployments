use v255_caticlan_terminal_go;


-- ## 2021-08-20
INSERT INTO `sys_role` (`name`, `title`, `system`) VALUES ('ADMIN', 'ADMIN', '1');
INSERT INTO `sys_role` (`name`, `title`, `system`) VALUES ('COLLECTOR', 'COLLECTOR', '1');
INSERT INTO `sys_role` (`name`, `title`, `system`) VALUES ('MASTER', 'MASTER', '1');
INSERT INTO `sys_role` (`name`, `title`, `system`) VALUES ('SHARED', 'SHARED', '1');
INSERT INTO `sys_role` (`name`, `title`, `system`) VALUES ('REPORT', 'REPORT', '1');
INSERT INTO `sys_role` (`name`, `title`, `system`) VALUES ('RULE_AUTHOR', 'RULE_AUTHOR', '1');
INSERT INTO `sys_role` (`name`, `title`, `system`) VALUES ('WF_EDITOR', 'WF_EDITOR', '1');


insert into sys_user (
	objid, username, lastname, firstname, middlename, name, jobtitle, txncode 
) 
select 
	u.objid, u.username, u.lastname, u.firstname, u.middlename, u.name, u.jobtitle, u.txncode 
from ( 
	select distinct user_objid 
	from ( 
		select ugm.user_objid 
		from v255_caticlan_go.sys_usergroup_member ugm 
			inner join v255_caticlan_go.sys_usergroup ug on ug.objid = ugm.usergroup_objid 
		where ugm.usergroup_objid = 'TERMINAL.ADMIN' 

		union all 

		select ugm.user_objid 
		from v255_caticlan_go.sys_usergroup_member ugm 
			inner join v255_caticlan_go.sys_usergroup ug on ug.objid = ugm.usergroup_objid 
		where ugm.org_orgclass = 'TERMINAL'
			and ugm.usergroup_objid in ('TREASURY.COLLECTOR','TREASURY.SUBCOLLECTOR') 
	)t0 
)t1, v255_caticlan_go.sys_user u 
where u.objid = t1.user_objid 
	and (select count(*) from sys_user where objid = u.objid) = 0 
;


insert into sys_user_role (
	objid, role, userid, username, org_objid, org_name, securitygroup_objid, exclude, uid 
) 
select * 
from ( 
	select 
		ugm.objid, 'ADMIN' as role, ugm.user_objid as userid, ugm.user_username as username, 
		ugm.org_objid, ugm.org_name, ugm.securitygroup_objid, ugm.exclude, ugm.objid as uid 
	from v255_caticlan_go.sys_usergroup_member ugm 
		inner join v255_caticlan_go.sys_usergroup ug on ug.objid = ugm.usergroup_objid 
	where ugm.usergroup_objid = 'TERMINAL.ADMIN' 

	union all 

	select 
		ugm.objid, 'MASTER' as role, ugm.user_objid as userid, ugm.user_username as username, 
		ugm.org_objid, ugm.org_name, ugm.securitygroup_objid, ugm.exclude, ugm.objid as uid 
	from v255_caticlan_go.sys_usergroup_member ugm 
		inner join v255_caticlan_go.sys_usergroup ug on ug.objid = ugm.usergroup_objid 
	where ugm.org_orgclass = 'TERMINAL'
		and ugm.usergroup_objid in ('TREASURY.COLLECTOR','TREASURY.SUBCOLLECTOR') 
)t0 
where (select count(*) from sys_user_role where objid = t0.objid) = 0 
; 


insert into sys_user_role (
	objid, role, userid, username, org_objid, org_name, securitygroup_objid, exclude, uid 
) 
select t0.*, t0.objid as uid 
from ( 
	select 
		concat('UGM-',MD5(concat(r.userid, 'RULE_AUTHOR'))) as objid, 'RULE_AUTHOR' as role, 
		r.userid, r.username, r.org_objid, r.org_name, r.securitygroup_objid, r.exclude 
	from sys_user_role r 
	where role = 'ADMIN' 
)t0 
where (select count(*) from sys_user_role where objid = t0.objid) = 0 
; 


insert into sys_user_role (
	objid, role, userid, username, org_objid, org_name, securitygroup_objid, exclude, uid 
) 
select t0.*, t0.objid as uid 
from ( 
	select 
		concat('UGM-',MD5(concat(r.userid, 'WF_EDITOR'))) as objid, 'WF_EDITOR' as role, 
		r.userid, r.username, r.org_objid, r.org_name, r.securitygroup_objid, r.exclude 
	from sys_user_role r 
	where role = 'ADMIN' 
)t0 
where (select count(*) from sys_user_role where objid = t0.objid) = 0 
; 


delete from v255_caticlan_go.sys_usergroup_member where usergroup_objid like 'TERMINAL.%'
;
delete from v255_caticlan_go.sys_usergroup where domain='TERMINAL'
;


create table ztmp_duplicate_sys_user_role 
select t0.*, 
	(
		select objid from sys_user_role 
		where role = t0.role and userid = t0.userid and ifnull(org_objid,'') = ifnull(t0.org_objid,'') 
		limit 1 
	) as userroleid 
from ( 
	select role, userid, org_objid, count(*) as icount 
	from sys_user_role 
	group by role, userid, org_objid
	having count(*) > 1 
)t0 
; 

create table ztmp_delete_duplicate_sys_user_role 
select z.userroleid, r.* 
from sys_user_role r, ztmp_duplicate_sys_user_role z 
where r.role = z.role 
	and r.userid = z.userid 
	and ifnull(r.org_objid,'') = ifnull(z.org_objid,'')
	and r.objid <> z.userroleid 
;

delete from sys_user_role where objid in (
	select objid from ztmp_delete_duplicate_sys_user_role
);

drop table ztmp_delete_duplicate_sys_user_role; 
drop table ztmp_duplicate_sys_user_role; 

create unique index uix_role_userid_org_objid on sys_user_role (role, userid, org_objid)
; 


insert into sys_var (
	name, value, description, datatype, category 
) 
select 
	name, value, description, datatype, category 
from v255_caticlan_go.sys_var 
where name = 'thermal_printername'
;


insert into sys_sequence (
	objid, nextSeries 
) 
select 
	objid, nextSeries 
from v255_caticlan_go.sys_sequence 
where objid like '%-aklanterminal' 
;

update sys_sequence set 
	objid = replace(objid, '-aklanterminal', '-ticketing') 
where 
	objid like '%-aklanterminal'
; 





INSERT INTO `ticketing_itemaccount` VALUES (
	'TERMINAL_FEE','TERMINAL FEE', NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL
);



INSERT INTO `sys_ruleset` VALUES ('ticketingbilling','Ticketing Billing','ticketing','TICKETING','RULE_AUTHOR',NULL);

INSERT INTO `sys_rulegroup` VALUES ('initial','ticketingbilling','Initial',0),('compute-fee','ticketingbilling','Compute Fee',1),('map-accounts','ticketingbilling','Map Accounts',2);

INSERT INTO `sys_rule_fact` VALUES ('com.rameses.rules.common.CurrentDate','com.rameses.rules.common.CurrentDate','Current Date','com.rameses.rules.common.CurrentDate',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'SYSTEM',NULL),('ticketing.facts.TicketInfo','ticketing.facts.TicketInfo','Ticket Info','ticketing.facts.TicketInfo',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TICKETING',NULL),('treasury.facts.BillItem','treasury.facts.BillItem','Bill Item','treasury.facts.BillItem',1,NULL,'BILLITEM',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY','treasury.facts.AbstractBillItem'),('treasury.facts.CashReceipt','treasury.facts.CashReceipt','Cash Receipt','treasury.facts.CashReceipt',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL),('treasury.facts.CreditBillItem','treasury.facts.CreditBillItem','Credit Bill Item','treasury.facts.CreditBillItem',1,NULL,'CRBILL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY','treasury.facts.AbstractBillItem'),('treasury.facts.Deposit','treasury.facts.Deposit','Deposit','treasury.facts.Deposit',5,NULL,'PMT',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL),('treasury.facts.ExcessPayment','treasury.facts.ExcessPayment','Excess Payment','treasury.facts.ExcessPayment',5,NULL,'EXPMT',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL),('treasury.facts.HolidayFact','treasury.facts.HolidayFact','Holidays','treasury.facts.HolidayFact',1,NULL,'HOLIDAYS',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL),('treasury.facts.Payment','treasury.facts.Payment','Payment','treasury.facts.Payment',5,NULL,'PMT',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL),('treasury.facts.Requirement','treasury.facts.Requirement','Requirement','treasury.facts.Requirement',2,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL),('treasury.facts.TransactionDate','treasury.facts.TransactionDate','Transaction Date','treasury.facts.TransactionDate',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL),('treasury.facts.VarInteger','treasury.facts.VarInteger','Var Integer','treasury.facts.VarInteger',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL);
INSERT INTO `sys_rule_fact_field` VALUES ('com.rameses.rules.common.CurrentDate.date','com.rameses.rules.common.CurrentDate','date','Date','date',4,'date',NULL,NULL,NULL,NULL,NULL,NULL,'date',NULL),('com.rameses.rules.common.CurrentDate.day','com.rameses.rules.common.CurrentDate','day','Day','integer',5,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('com.rameses.rules.common.CurrentDate.month','com.rameses.rules.common.CurrentDate','month','Month','integer',3,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('com.rameses.rules.common.CurrentDate.qtr','com.rameses.rules.common.CurrentDate','qtr','Qtr','integer',1,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('com.rameses.rules.common.CurrentDate.year','com.rameses.rules.common.CurrentDate','year','Year','integer',2,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('ticketing.facts.TicketInfo.numadult','ticketing.facts.TicketInfo','numadult','Num Adult','integer',1,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('ticketing.facts.TicketInfo.numchildren','ticketing.facts.TicketInfo','numchildren','No. of Children','integer',2,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('ticketing.facts.TicketInfo.numfil','ticketing.facts.TicketInfo','numfil','No. of Filipino','integer',4,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('ticketing.facts.TicketInfo.numnonfil','ticketing.facts.TicketInfo','numnonfil','No. of Non-filipinos','integer',5,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('ticketing.facts.TicketInfo.numsenior','ticketing.facts.TicketInfo','numsenior','No. of Senior','integer',3,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('treasury.facts.BillItem.amount','treasury.facts.BillItem','amount','Amount','decimal',3,'decimal',NULL,NULL,NULL,NULL,NULL,NULL,'decimal',NULL),('treasury.facts.BillItem.billcode','treasury.facts.BillItem','billcode','Bill code','string',2,'lookup','market_itemaccount:lookup','objid','title',NULL,NULL,NULL,'string',NULL),('treasury.facts.BillItem.objid','treasury.facts.BillItem','objid','ObjID','string',1,'string',NULL,NULL,NULL,NULL,NULL,NULL,'string',NULL),('treasury.facts.BillItem.surcharge','treasury.facts.BillItem','surcharge','Surcharge','decimal',4,'decimal',NULL,NULL,NULL,NULL,NULL,NULL,'decimal',NULL),('treasury.facts.BillItem.tag','treasury.facts.BillItem','tag','Tag','string',5,'string',NULL,NULL,NULL,NULL,NULL,NULL,'string',NULL),('treasury.facts.CashReceipt.receiptdate','treasury.facts.CashReceipt','receiptdate','Receipt Date','date',2,'date',NULL,NULL,NULL,NULL,NULL,NULL,'date',NULL),('treasury.facts.CashReceipt.txnmode','treasury.facts.CashReceipt','txnmode','Txn Mode','string',1,'string',NULL,NULL,NULL,NULL,NULL,NULL,'string',NULL),('treasury.facts.CreditBillItem.amount','treasury.facts.CreditBillItem','amount','Amount','decimal',1,'decimal',NULL,NULL,NULL,NULL,NULL,NULL,'decimal',NULL),('treasury.facts.CreditBillItem.billcode','treasury.facts.CreditBillItem','billcode','Bill code','string',2,'lookup','waterworks_itemaccount:lookup','objid','title',NULL,NULL,NULL,'string',NULL),('treasury.facts.Deposit.amount','treasury.facts.Deposit','amount','Amount','decimal',1,'decimal',NULL,NULL,NULL,NULL,NULL,NULL,'decimal',NULL),('treasury.facts.ExcessPayment.amount','treasury.facts.ExcessPayment','amount','Amount','decimal',1,'decimal',NULL,NULL,NULL,NULL,NULL,NULL,'decimal',NULL),('treasury.facts.HolidayFact.id','treasury.facts.HolidayFact','id','ID','string',1,'string',NULL,NULL,NULL,NULL,NULL,NULL,'string',NULL),('treasury.facts.Payment.amount','treasury.facts.Payment','amount','Amount','decimal',1,'decimal',NULL,NULL,NULL,NULL,NULL,NULL,'decimal',NULL),('treasury.facts.Requirement.code','treasury.facts.Requirement','code','Code','string',1,'lookup','requirementtype:lookup','code','title',NULL,NULL,NULL,'string',NULL),('treasury.facts.Requirement.completed','treasury.facts.Requirement','completed','Completed','boolean',2,'boolean',NULL,NULL,NULL,NULL,NULL,NULL,'boolean',NULL),('treasury.facts.TransactionDate.date','treasury.facts.TransactionDate','date','Date','date',1,'date',NULL,NULL,NULL,NULL,NULL,NULL,'date',NULL),('treasury.facts.TransactionDate.day','treasury.facts.TransactionDate','day','Day','integer',4,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('treasury.facts.TransactionDate.month','treasury.facts.TransactionDate','month','Month','integer',3,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('treasury.facts.TransactionDate.qtr','treasury.facts.TransactionDate','qtr','Qtr','integer',5,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('treasury.facts.TransactionDate.tag','treasury.facts.TransactionDate','tag','Tag','string',6,'string',NULL,NULL,NULL,NULL,NULL,NULL,'string',NULL),('treasury.facts.TransactionDate.year','treasury.facts.TransactionDate','year','Year','integer',2,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('treasury.facts.VarInteger.tag','treasury.facts.VarInteger','tag','Tag','string',2,'string',NULL,NULL,NULL,NULL,NULL,NULL,'string',NULL),('treasury.facts.VarInteger.value','treasury.facts.VarInteger','value','Value','integer',1,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL);

INSERT INTO `sys_rule_actiondef` VALUES ('enterprise.actions.PrintTest','print-test','Print Test',1,'print-test','ENTERPRISE','enterprise.actions.PrintTest'),('enterprise.actions.ThrowException','throw-exeception','Throw Exception',1,'throw-exeception','ENTERPRISE','enterprise.actions.ThrowException'),('treasury.actions.AddBillItem','add-billitem','Add Bill Item',0,'add-billitem','TREASURY','treasury.actions.AddBillItem'),('treasury.actions.AddCreditBillItem','add-credit-billitem','Add Credit Bill Item',2,'add-credit-billitem','TREASURY','treasury.actions.AddCreditBillItem'),('treasury.actions.AddDiscountItem','add-discount-item','Add Discount',3,'add-discount-item','TREASURY','treasury.actions.AddDiscountItem'),('treasury.actions.AddExcessBillItem','add-excess-billitem','Add Excess Bill Item',2,'add-excess-billitem','TREASURY','treasury.actions.AddExcessBillItem'),('treasury.actions.AddInterestItem','add-interest-item','Add Interest',3,'add-interest-item','TREASURY','treasury.actions.AddInterestItem'),('treasury.actions.AddSurchargeItem','add-surcharge-item','Add Surcharge',3,'add-surcharge-item','TREASURY','treasury.actions.AddSurchargeItem'),('treasury.actions.AddVarInteger','add-var-integer','Add Var Integer',1,'add-var-integer','TREASURY','treasury.actions.AddVarInteger'),('treasury.actions.ApplyPayment','apply-payment','Apply Payment',5,'apply-payment','TREASURY','treasury.actions.ApplyPayment'),('treasury.actions.RemoveDiscountItem','remove-discount','Remove Discount',1,'remove-discount','TREASURY','treasury.actions.RemoveDiscountItem'),('treasury.actions.SetBillItemAccount','set-billitem-account','Set Bill Item Account',4,'set-billitem-account','TREASURY','treasury.actions.SetBillItemAccount'),('treasury.actions.SetBillItemProperty','set-billitem-property','Set BillItem Property Value',10,'set-billitem-property','TREASURY','treasury.actions.SetBillItemProperty'),('treasury.actions.UpdateBillItemAmount','update-billitem-amount','Update Billitem Amount',1,'update-billitem-amount','TREASURY','treasury.actions.UpdateBillItemAmount');
INSERT INTO `sys_rule_actiondef_param` VALUES ('enterprise.actions.PrintTest.message','enterprise.actions.PrintTest','message',1,'Message',NULL,'expression',NULL,NULL,NULL,NULL,NULL),('enterprise.actions.ThrowException.msg','enterprise.actions.ThrowException','msg',1,'Message',NULL,'expression',NULL,NULL,NULL,NULL,NULL),('treasury.actions.AddBillItem.amount','treasury.actions.AddBillItem','amount',1,'Amount',NULL,'expression',NULL,NULL,NULL,NULL,NULL),('treasury.actions.AddBillItem.billcode','treasury.actions.AddBillItem','billcode',2,'Bill code',NULL,'lookup','ticketing_itemaccount:lookup','objid','title','string',NULL),('treasury.actions.AddCreditBillItem.account','treasury.actions.AddCreditBillItem','account',1,'Account',NULL,'lookup','revenueitem:lookup','objid','title',NULL,NULL),('treasury.actions.AddCreditBillItem.amount','treasury.actions.AddCreditBillItem','amount',2,'Amount',NULL,'expression',NULL,NULL,NULL,NULL,NULL),('treasury.actions.AddCreditBillItem.billcode','treasury.actions.AddCreditBillItem','billcode',1,'Bill code',NULL,'lookup','waterworks_itemaccount:lookup','objid','title','string',NULL),('treasury.actions.AddCreditBillItem.reftype','treasury.actions.AddCreditBillItem','reftype',3,'Ref Type','string','string',NULL,NULL,NULL,'string',NULL),('treasury.actions.AddDiscountItem.account','treasury.actions.AddDiscountItem','account',4,'Account',NULL,'lookup','revenueitem:lookup','objid','title',NULL,NULL),('treasury.actions.AddDiscountItem.amount','treasury.actions.AddDiscountItem','amount',2,'Amount',NULL,'expression',NULL,NULL,NULL,NULL,NULL),('treasury.actions.AddDiscountItem.billcode','treasury.actions.AddDiscountItem','billcode',3,'Billcode',NULL,'lookup','waterworks_itemaccount:lookup','objid','title','string',NULL),('treasury.actions.AddDiscountItem.billitem','treasury.actions.AddDiscountItem','billitem',1,'Bill Item',NULL,'var',NULL,NULL,NULL,'treasury.facts.AbstractBillItem',NULL),('treasury.actions.AddExcessBillItem.account','treasury.actions.AddExcessBillItem','account',1,'Account',NULL,'lookup','revenueitem:lookup','objid','title',NULL,NULL),('treasury.actions.AddExcessBillItem.amount','treasury.actions.AddExcessBillItem','amount',2,'Amount',NULL,'expression',NULL,NULL,NULL,NULL,NULL),('treasury.actions.AddInterestItem.amount','treasury.actions.AddInterestItem','amount',2,'Amount',NULL,'expression',NULL,NULL,NULL,NULL,NULL),('treasury.actions.AddInterestItem.billcode','treasury.actions.AddInterestItem','billcode',3,'Billcode',NULL,'lookup','market_itemaccount:interest:lookup','objid','title','string',NULL),('treasury.actions.AddInterestItem.billitem','treasury.actions.AddInterestItem','billitem',1,'Bill Item',NULL,'var',NULL,NULL,NULL,'treasury.facts.AbstractBillItem',NULL),('treasury.actions.AddSurchargeItem.amount','treasury.actions.AddSurchargeItem','amount',2,'Amount',NULL,'expression',NULL,NULL,NULL,NULL,NULL),('treasury.actions.AddSurchargeItem.billcode','treasury.actions.AddSurchargeItem','billcode',3,'Bill code',NULL,'lookup','market_itemaccount:surcharge:lookup','objid','title','string',NULL),('treasury.actions.AddSurchargeItem.billitem','treasury.actions.AddSurchargeItem','billitem',1,'Bill Item',NULL,'var',NULL,NULL,NULL,'treasury.facts.AbstractBillItem',NULL),('treasury.actions.AddSurchargeItem.txntype','treasury.actions.AddSurchargeItem','txntype',4,'Txn Type',NULL,'lookup','billitem_txntype:lookup','objid','title','string',NULL),('treasury.actions.AddVarInteger.tag','treasury.actions.AddVarInteger','tag',2,'Tag','string','string',NULL,NULL,NULL,'string',NULL),('treasury.actions.AddVarInteger.value','treasury.actions.AddVarInteger','value',1,'Value',NULL,'expression',NULL,NULL,NULL,NULL,NULL),('treasury.actions.ApplyPayment.payment','treasury.actions.ApplyPayment','payment',1,'Payment',NULL,'var',NULL,NULL,NULL,'treasury.facts.Payment',NULL),('treasury.actions.RemoveDiscountItem.billitem','treasury.actions.RemoveDiscountItem','billitem',1,'Bill Item',NULL,'var',NULL,NULL,NULL,'treasury.facts.AbstractBillItem',NULL),('treasury.actions.SetBillItemAccount.account','treasury.actions.SetBillItemAccount','account',2,'Account',NULL,'lookup','revenueitem:lookup','objid','title',NULL,NULL),('treasury.actions.SetBillItemAccount.billcode','treasury.actions.SetBillItemAccount','billcode',3,'Billcode',NULL,'lookup','waterworks_itemaccount:lookup','objid','title','string',NULL),('treasury.actions.SetBillItemAccount.billitem','treasury.actions.SetBillItemAccount','billitem',1,'Bill Item',NULL,'var',NULL,NULL,NULL,'treasury.facts.AbstractBillItem',NULL),('treasury.actions.SetBillItemProperty.billitem','treasury.actions.SetBillItemProperty','billitem',1,'Bill Item',NULL,'var',NULL,NULL,NULL,'treasury.facts.AbstractBillItem',NULL),('treasury.actions.SetBillItemProperty.fieldname','treasury.actions.SetBillItemProperty','fieldname',2,'Property Field Name',NULL,'fieldlist',NULL,'billitem',NULL,NULL,NULL),('treasury.actions.SetBillItemProperty.value','treasury.actions.SetBillItemProperty','value',3,'Value',NULL,'expression',NULL,NULL,NULL,NULL,NULL),('treasury.actions.UpdateBillItemAmount.amount','treasury.actions.UpdateBillItemAmount','amount',3,'Amount',NULL,'expression',NULL,NULL,NULL,NULL,NULL),('treasury.actions.UpdateBillItemAmount.billitem','treasury.actions.UpdateBillItemAmount','billitem',1,'BillItem',NULL,'var',NULL,NULL,NULL,'treasury.facts.AbstractBillItem',NULL),('treasury.actions.UpdateBillItemAmount.type','treasury.actions.UpdateBillItemAmount','type',2,'Type',NULL,'lov',NULL,NULL,NULL,NULL,'UPDATE_BILLITEM_TYPE');

INSERT INTO `sys_ruleset_actiondef` VALUES ('ticketingbilling','enterprise.actions.ThrowException'),('ticketingbilling','treasury.actions.AddBillItem'),('ticketingbilling','treasury.actions.SetBillItemAccount'),('ticketingbilling','treasury.actions.UpdateBillItemAmount');

INSERT INTO `sys_ruleset_fact` VALUES ('ticketingbilling','ticketing.facts.TicketInfo'),('ticketingbilling','treasury.facts.BillItem');



INSERT INTO `sys_rule` VALUES ('RUL-34053c0e:17b57d3d81e:-7d01','DRAFT','ADD_TERMINAL_FEE','ticketingbilling','compute-fee','ADD TERMINAL FEE',NULL,50000,NULL,NULL,'2021-08-18 14:36:36','USR-ADMIN','ADMIN',1);

INSERT INTO `sys_rule_condition` VALUES ('RCOND-34053c0e:17b57d3d81e:-7cdb','RUL-34053c0e:17b57d3d81e:-7d01','ticketing.facts.TicketInfo','ticketing.facts.TicketInfo',NULL,0,NULL,NULL,NULL,NULL,NULL,0);

INSERT INTO `sys_rule_condition_var` VALUES ('RCONST-34053c0e:17b57d3d81e:-7c06','RCOND-34053c0e:17b57d3d81e:-7cdb','RUL-34053c0e:17b57d3d81e:-7d01','SEN','integer',2),('RCONST-34053c0e:17b57d3d81e:-7c6b','RCOND-34053c0e:17b57d3d81e:-7cdb','RUL-34053c0e:17b57d3d81e:-7d01','CHILD','integer',1),('RCONST-34053c0e:17b57d3d81e:-7cb3','RCOND-34053c0e:17b57d3d81e:-7cdb','RUL-34053c0e:17b57d3d81e:-7d01','ADULT','integer',0);

INSERT INTO `sys_rule_condition_constraint` VALUES ('RCONST-34053c0e:17b57d3d81e:-7c06','RCOND-34053c0e:17b57d3d81e:-7cdb','ticketing.facts.TicketInfo.numsenior','numsenior','SEN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,2),('RCONST-34053c0e:17b57d3d81e:-7c6b','RCOND-34053c0e:17b57d3d81e:-7cdb','ticketing.facts.TicketInfo.numchildren','numchildren','CHILD',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1),('RCONST-34053c0e:17b57d3d81e:-7cb3','RCOND-34053c0e:17b57d3d81e:-7cdb','ticketing.facts.TicketInfo.numadult','numadult','ADULT',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0);

INSERT INTO `sys_rule_action` VALUES ('RACT-34053c0e:17b57d3d81e:-7a5f','RUL-34053c0e:17b57d3d81e:-7d01','treasury.actions.AddBillItem','add-billitem',0);

INSERT INTO `sys_rule_action_param` VALUES ('RULACT-34053c0e:17b57d3d81e:-7a1f','RACT-34053c0e:17b57d3d81e:-7a5f','treasury.actions.AddBillItem.amount',NULL,NULL,NULL,NULL,'(ADULT * 50) + ( CHILD * 10 ) + ( SEN * 20 )','expression',NULL,NULL,NULL,NULL,NULL,NULL),('RULACT-34053c0e:17b57d3d81e:-7a47','RACT-34053c0e:17b57d3d81e:-7a5f','treasury.actions.AddBillItem.billcode',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TERMINAL_FEE','TERMINAL FEE',NULL,NULL,NULL);




insert into sys_user_role (
	objid, uid, role, userid, username, org_objid, org_name 
) 
select 
	concat('UGM-',MD5(concat(u.objid, o.objid, t0.role))) as objid, 
	concat('UGM-',MD5(concat(u.objid, o.objid, t0.role))) as uid, 
	t0.role, u.objid as userid, u.username, o.objid as org_objid, o.name as org_name
from ( 
	select distinct user_objid, org_objid, 'COLLECTOR' as role  
	from v255_caticlan_go.sys_usergroup_member 
	where org_orgclass = 'TERMINAL' 
		and usergroup_objid in ('TREASURY.COLLECTOR','TREASURY.SUBCOLLECTOR') 
)t0 
	inner join v255_caticlan_go.sys_user u on u.objid = t0.user_objid 
	inner join v255_caticlan_go.sys_org o on o.objid = t0.org_objid 
;

delete from sys_user_role where role = 'MASTER' and username <> 'ADMIN'
;

INSERT INTO `sys_var` (`name`, `value`, `description`, `datatype`, `category`) 
VALUES ('lgu_name', 'PROVINCIAL GOVT OF AKLAN', NULL, NULL, NULL);



INSERT INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('ticketing.facts.TicketInfo.routeid', 'ticketing.facts.TicketInfo', 'routeid', 'Route', 'string', '7', 'lookup', 'ticketing_terminal:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);

