-- =============================
-- ETRACS Database Upgrade Guide
-- =============================
-- 
-- Source-DB:  cagban_go 
-- Target-DB:  etracs255_cagban 
-- 
-- 
-- 01. Create the target database "etracs255_cagban"
-- 
--     mysql -u root -p1234 -e "CREATE DATABASE etracs255_cagban CHARACTER SET utf8"
-- 
-- 
-- 02. Dump the source schemas and import to the target database 
-- 
--     mysqldump -u root -p1234 -f -d cagban_go | mysql -u root -p1234 -f -v -D etracs255_cagban  
-- 
-- 
-- 03. Run the following scripts below
-- 
-- 

use etracs255_cagban
; 

set foreign_key_checks=0
;

insert into af 
select * from cagban_go.af
; 

insert into af_control 
select * from cagban_go.af_control
; 

insert into af_inventory 
select * from cagban_go.af_inventory
; 

insert into af_inventory_detail 
select * from cagban_go.af_inventory_detail
; 

insert into af_inventory_detail_cancelseries 
select * from cagban_go.af_inventory_detail_cancelseries
; 

insert into af_inventory_return 
select * from cagban_go.af_inventory_return
; 

insert into bank 
select * from cagban_go.bank
; 

insert into bankaccount 
select * from cagban_go.bankaccount
; 

insert into bankaccount_account 
select * from cagban_go.bankaccount_account
; 

insert into bankaccount_entry 
select * from cagban_go.bankaccount_entry
; 

insert into bankdeposit 
select * from cagban_go.bankdeposit
; 

insert into bankdeposit_entry 
select * from cagban_go.bankdeposit_entry
; 

insert into bankdeposit_entry_check 
select * from cagban_go.bankdeposit_entry_check
; 

insert into bankdeposit_liquidation 
select * from cagban_go.bankdeposit_liquidation
; 

insert into barangay 
select * from cagban_go.barangay
; 

insert into batchcapture_collection 
select * 
from cagban_go.batchcapture_collection
where txndate >= '2021-01-01' 
; 

insert into batchcapture_collection_entry 
select ce.* 
from cagban_go.batchcapture_collection c 
	inner join cagban_go.batchcapture_collection_entry ce on ce.parentid = c.objid 
where c.txndate >= '2021-01-01' 
; 

insert into batchcapture_collection_entry_item 
select cei.* 
from cagban_go.batchcapture_collection c 
	inner join cagban_go.batchcapture_collection_entry ce on ce.parentid = c.objid 
	inner join cagban_go.batchcapture_collection_entry_item cei on cei.parentid = ce.objid 
where c.txndate >= '2021-01-01' 
; 

insert into billitem_txntype 
select * from cagban_go.billitem_txntype
; 

insert into brgyshare_account_mapping 
select * from cagban_go.brgyshare_account_mapping
; 


create table cagban_go.ztmp_cashreceipt 
select * 
from ( 
	select c.objid  
	from cagban_go.cashreceipt c
	where c.receiptdate >= '2021-01-01' 
	union 
	select rc.objid  
	from cagban_go.remittance r 
		inner join cagban_go.remittance_cashreceipt rc on rc.remittanceid = r.objid 
	where r.dtposted >= '2021-01-01' 
	union 
	select rc.objid  
	from cagban_go.liquidation l 
		inner join cagban_go.liquidation_remittance lr on lr.liquidationid = l.objid 
		inner join cagban_go.remittance r on r.objid = lr.objid 
		inner join cagban_go.remittance_cashreceipt rc on rc.remittanceid = r.objid 
	where l.dtposted >= '2021-01-01' 
	union 
	select rc.objid 
	from ( 
		select distinct lcf.liquidationid 
		from cagban_go.bankdeposit bd
			inner join cagban_go.bankdeposit_liquidation bdl on bdl.bankdepositid = bd.objid 
			inner join cagban_go.liquidation_cashier_fund lcf on lcf.objid = bdl.objid 
		where bd.dtposted >= '2021-01-01' 
	)t0 
		inner join cagban_go.liquidation_remittance lr on lr.liquidationid = t0.liquidationid 
		inner join cagban_go.remittance r on r.objid = lr.objid 
		inner join cagban_go.remittance_cashreceipt rc on rc.remittanceid = r.objid 
)t1
; 
create index ix_objid on cagban_go.ztmp_cashreceipt (objid)
; 

insert into cashreceipt 
select c.* 
from cagban_go.ztmp_cashreceipt z 
	inner join cagban_go.cashreceipt c on c.objid = z.objid 
; 

insert into cashreceipt_burial 
select c.* 
from cagban_go.ztmp_cashreceipt z 
	inner join cagban_go.cashreceipt_burial c on c.objid = z.objid 
; 

insert into cashreceipt_cancelseries 
select c.* 
from cagban_go.ztmp_cashreceipt z 
	inner join cagban_go.cashreceipt_cancelseries c on c.receiptid = z.objid 
; 

insert into cashreceipt_cashticket 
select c.* 
from cagban_go.ztmp_cashreceipt z 
	inner join cagban_go.cashreceipt_cashticket c on c.objid = z.objid 
; 

insert into cashreceipt_largecattleownership 
select c.* 
from cagban_go.ztmp_cashreceipt z 
	inner join cagban_go.cashreceipt_largecattleownership c on c.objid = z.objid 
;

insert into cashreceipt_largecattletransfer 
select c.* 
from cagban_go.ztmp_cashreceipt z 
	inner join cagban_go.cashreceipt_largecattletransfer c on c.objid = z.objid 
; 

insert into cashreceipt_marriage 
select c.* 
from cagban_go.ztmp_cashreceipt z 
	inner join cagban_go.cashreceipt_marriage c on c.objid = z.objid 
; 

insert into cashreceipt_slaughter 
select c.* 
from cagban_go.ztmp_cashreceipt z 
	inner join cagban_go.cashreceipt_slaughter c on c.objid = z.objid 
; 

insert into cashreceipt_void 
select c.* 
from cagban_go.ztmp_cashreceipt z 
	inner join cagban_go.cashreceipt_void c on c.receiptid = z.objid 
; 

insert into cashreceiptitem 
select c.* 
from cagban_go.ztmp_cashreceipt z 
	inner join cagban_go.cashreceiptitem c on c.receiptid = z.objid 
;

insert into cashreceiptitem_discount 
select c.* 
from cagban_go.ztmp_cashreceipt z 
	inner join cagban_go.cashreceiptitem_discount c on c.receiptid = z.objid 
;

insert into cashreceiptpayment_creditmemo 
select c.* 
from cagban_go.ztmp_cashreceipt z 
	inner join cagban_go.cashreceiptpayment_creditmemo c on c.receiptid = z.objid 
; 

insert into cashreceiptpayment_noncash 
select c.* 
from cagban_go.ztmp_cashreceipt z 
	inner join cagban_go.cashreceiptpayment_noncash c on c.receiptid = z.objid 
; 

insert into citizenship 
select * from cagban_go.citizenship
; 

insert into collectiongroup 
select * from cagban_go.collectiongroup
; 

insert into collectiongroup_revenueitem 
select * from cagban_go.collectiongroup_revenueitem
; 

insert into collectiontype 
select * from cagban_go.collectiontype
; 

insert into collectiontype_account 
select * from cagban_go.collectiontype_account
; 

insert into creditmemo 
select * from cagban_go.creditmemo
; 

insert into creditmemoitem 
select * from cagban_go.creditmemoitem
; 

insert into creditmemotype 
select * from cagban_go.creditmemotype
; 

insert into creditmemotype_account 
select * from cagban_go.creditmemotype_account
; 

insert into directcash_collection 
select * from cagban_go.directcash_collection
; 

insert into directcash_collection_item 
select * from cagban_go.directcash_collection_item
; 

insert into entity 
select * from cagban_go.entity
; 

insert into entity_address 
select * from cagban_go.entity_address
; 

insert into entity_relation 
select * from cagban_go.entity_relation
; 

insert into entitycontact 
select * from cagban_go.entitycontact
; 

insert into entityid 
select * from cagban_go.entityid
; 

insert into entityindividual 
select * from cagban_go.entityindividual
; 

insert into entityjuridical 
select * from cagban_go.entityjuridical
; 

insert into fund 
select * from cagban_go.fund
; 

insert into government_property 
select * from cagban_go.government_property
; 

insert into itemaccount 
select * from cagban_go.itemaccount
; 

insert into itemaccount_tag 
select * from cagban_go.itemaccount_tag
; 


create table cagban_go.ztmp_liquidation_remittance 
select lr.liquidationid, lr.objid as remittanceid 
from cagban_go.liquidation l 
	inner join cagban_go.liquidation_remittance lr on lr.liquidationid = l.objid 
where l.dtposted >= '2021-01-01' 
; 
create index ix_remittanceid on cagban_go.ztmp_liquidation_remittance (remittanceid);
create index ix_liquidationid on cagban_go.ztmp_liquidation_remittance (liquidationid);

insert into liquidation 
select l.* 
from ( 
	select distinct liquidationid 
	from cagban_go.ztmp_liquidation_remittance
)z 
	inner join cagban_go.liquidation l on l.objid = z.liquidationid 
; 

insert into liquidation_cashier_fund 
select lcf.* 
from ( 
	select distinct liquidationid 
	from cagban_go.ztmp_liquidation_remittance
)z 
	inner join cagban_go.liquidation l on l.objid = z.liquidationid 
	inner join cagban_go.liquidation_cashier_fund lcf on lcf.liquidationid = l.objid 
; 

insert into liquidation_creditmemopayment 
select lcm.* 
from ( 
	select distinct liquidationid 
	from cagban_go.ztmp_liquidation_remittance
)z 
	inner join cagban_go.liquidation l on l.objid = z.liquidationid 
	inner join cagban_go.liquidation_creditmemopayment lcm on lcm.liquidationid = l.objid 
;

insert into liquidation_noncashpayment 
select lcm.* 
from ( 
	select distinct liquidationid 
	from cagban_go.ztmp_liquidation_remittance
)z 
	inner join cagban_go.liquidation l on l.objid = z.liquidationid 
	inner join cagban_go.liquidation_noncashpayment lcm on lcm.liquidationid = l.objid 
;

insert into liquidation_remittance 
select lr.* 
from ( 
	select distinct liquidationid 
	from cagban_go.ztmp_liquidation_remittance
)z 
	inner join cagban_go.liquidation l on l.objid = z.liquidationid 
	inner join cagban_go.liquidation_remittance lr on lr.liquidationid = l.objid 
;

insert into profession 
select * from cagban_go.profession
; 

insert into province 
select * from cagban_go.province
; 

insert into religion 
select * from cagban_go.religion
; 

insert into remittance 
select r.* 
from ( 
	select distinct remittanceid  
	from cagban_go.ztmp_liquidation_remittance
)z 
	inner join cagban_go.remittance r on r.objid = z.remittanceid 
; 

insert into remittance_af 
select ra.* 
from ( 
	select distinct remittanceid  
	from cagban_go.ztmp_liquidation_remittance
)z 
	inner join cagban_go.remittance r on r.objid = z.remittanceid 
	inner join cagban_go.remittance_af ra on ra.remittanceid = r.objid 
; 

insert into remittance_cashreceipt 
select ra.* 
from ( 
	select distinct remittanceid  
	from cagban_go.ztmp_liquidation_remittance
)z 
	inner join cagban_go.remittance r on r.objid = z.remittanceid 
	inner join cagban_go.remittance_cashreceipt ra on ra.remittanceid = r.objid 
;

insert into remittance_creditmemopayment 
select ra.* 
from ( 
	select distinct remittanceid  
	from cagban_go.ztmp_liquidation_remittance
)z 
	inner join cagban_go.remittance r on r.objid = z.remittanceid 
	inner join cagban_go.remittance_creditmemopayment ra on ra.remittanceid = r.objid 
;

insert into remittance_fund 
select ra.* 
from ( 
	select distinct remittanceid  
	from cagban_go.ztmp_liquidation_remittance
)z 
	inner join cagban_go.remittance r on r.objid = z.remittanceid 
	inner join cagban_go.remittance_fund ra on ra.remittanceid = r.objid 
;

insert into remittance_noncashpayment 
select ra.* 
from ( 
	select distinct remittanceid  
	from cagban_go.ztmp_liquidation_remittance
)z 
	inner join cagban_go.remittance r on r.objid = z.remittanceid 
	inner join cagban_go.remittance_noncashpayment ra on ra.remittanceid = r.objid 
;

insert into requirement_type 
select * from cagban_go.requirement_type
; 

insert into stockissue 
select * from cagban_go.stockissue
; 

insert into stockissueitem 
select * from cagban_go.stockissueitem
; 

insert into stockitem 
select * from cagban_go.stockitem
; 

insert into stockitem_unit 
select * from cagban_go.stockitem_unit
; 

insert into stockreceipt 
select * from cagban_go.stockreceipt
; 

insert into stockreceiptitem 
select * from cagban_go.stockreceiptitem
; 

insert into stockrequest 
select * from cagban_go.stockrequest
; 

insert into stockrequestitem 
select * from cagban_go.stockrequestitem
; 

insert into stockreturn 
select * from cagban_go.stockreturn
; 

insert into stocksale 
select * from cagban_go.stocksale
; 

insert into stocksaleitem 
select * from cagban_go.stocksaleitem
; 

insert into subcollector_remittance 
select r.* 
from cagban_go.subcollector_remittance r 
where r.dtposted >= '2021-01-01' 
; 

insert into subcollector_remittance_cashreceipt 
select rc.* 
from cagban_go.subcollector_remittance r 
	inner join cagban_go.subcollector_remittance_cashreceipt rc on rc.remittanceid = r.objid 
where r.dtposted >= '2021-01-01' 
;

insert into sys_dataset 
select * from cagban_go.sys_dataset
; 

insert into sys_org 
select * from cagban_go.sys_org
; 

insert into sys_orgclass 
select * from cagban_go.sys_orgclass
; 

insert into sys_quarter 
select * from cagban_go.sys_quarter
; 

insert into sys_report 
select * from cagban_go.sys_report
; 

insert into sys_report_admin 
select * from cagban_go.sys_report_admin
; 

insert into sys_report_folder 
select * from cagban_go.sys_report_folder
; 

insert into sys_report_member 
select * from cagban_go.sys_report_member
; 

insert into sys_requirement_type 
select * from cagban_go.sys_requirement_type
; 

insert into sys_rule 
select * from cagban_go.sys_rule
; 

insert into sys_rule_action 
select * from cagban_go.sys_rule_action
; 

insert into sys_rule_action_param 
select * from cagban_go.sys_rule_action_param
; 

insert into sys_rule_actiondef 
select * from cagban_go.sys_rule_actiondef
; 

insert into sys_rule_actiondef_param 
select * from cagban_go.sys_rule_actiondef_param
; 

insert into sys_rule_condition 
select * from cagban_go.sys_rule_condition
; 

insert into sys_rule_condition_constraint 
select * from cagban_go.sys_rule_condition_constraint
; 

insert into sys_rule_condition_var 
select * from cagban_go.sys_rule_condition_var
; 

insert into sys_rule_deployed 
select * from cagban_go.sys_rule_deployed
; 

insert into sys_rule_fact 
select * from cagban_go.sys_rule_fact
; 

insert into sys_rule_fact_field 
select * from cagban_go.sys_rule_fact_field
; 

insert into sys_rulegroup 
select * from cagban_go.sys_rulegroup
; 

insert into sys_ruleset 
select * from cagban_go.sys_ruleset
; 

insert into sys_ruleset_actiondef 
select * from cagban_go.sys_ruleset_actiondef
; 

insert into sys_ruleset_fact 
select * from cagban_go.sys_ruleset_fact
; 

insert into sys_script 
select * from cagban_go.sys_script
; 

insert into sys_securitygroup 
select * from cagban_go.sys_securitygroup
; 

insert into sys_sequence 
select * from cagban_go.sys_sequence
; 

insert into sys_session 
select r.* 
from cagban_go.sys_session r 
where r.timein >= '2021-01-01' 
;

insert into sys_session_log 
select r.* 
from cagban_go.sys_session_log r 
where r.timeout >= '2021-01-01' 
;

insert into sys_terminal 
select * from cagban_go.sys_terminal
; 

insert into sys_user 
select * from cagban_go.sys_user
; 

insert into sys_usergroup 
select * from cagban_go.sys_usergroup
; 

insert into sys_usergroup_admin 
select * from cagban_go.sys_usergroup_admin
; 

insert into sys_usergroup_member 
select * from cagban_go.sys_usergroup_member
; 

insert into sys_usergroup_permission 
select * from cagban_go.sys_usergroup_permission
; 

insert into sys_var 
select * from cagban_go.sys_var
; 

insert into sys_wf 
select * from cagban_go.sys_wf
; 

insert into sys_wf_assignee 
select * from cagban_go.sys_wf_assignee
; 

insert into sys_wf_node 
select * from cagban_go.sys_wf_node
; 

insert into sys_wf_subtask 
select * from cagban_go.sys_wf_subtask
; 

insert into sys_wf_task 
select * from cagban_go.sys_wf_task
; 

insert into sys_wf_transition 
select * from cagban_go.sys_wf_transition
; 

insert into sys_wf_workitemtype 
select * from cagban_go.sys_wf_workitemtype
; 

insert into txnlog 
select r.* 
from cagban_go.txnlog r 
where r.txndate >= '2021-01-01' 
; 

insert into variableinfo 
select * from cagban_go.variableinfo
; 

insert into workflowstate 
select * from cagban_go.workflowstate
; 

drop table if exists cagban_go.ztmp_cashreceipt;
drop table if exists cagban_go.ztmp_liquidation_remittance; 

set foreign_key_checks=1
;
