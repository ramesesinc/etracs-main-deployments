-- ===============================
-- Terminal Database Upgrade Guide
-- ===============================
-- 
-- Source-DB:  cagban_terminal_go 
-- Target-DB:  ticketing_cagban
-- 
-- 
-- 01. Create the target database "ticketing_cagban"
-- 
--     mysql -u root -p1234 -e "CREATE DATABASE ticketing_cagban CHARACTER SET utf8"
-- 
-- 
-- 02. Dump the source schemas and import to the target database 
-- 
--     mysqldump -u root -p1234 -f -d cagban_terminal_go | mysql -u root -p1234 -f -v -D ticketing_cagban  
-- 
-- 
-- 03. Run the following scripts below
-- 
-- 

use ticketing_cagban
; 

set foreign_key_checks=0
;

-- insert into cashreceipt_terminal 
-- select c.* 
-- from cagban_terminal_go.cashreceipt_terminal c 
-- where dtfiled >= '2021-01-01' 
-- ;

-- insert into specialpass_account 
-- select c.* 
-- from ( 
-- 	select c.objid 
-- 	from cagban_terminal_go.specialpass_account c 
-- 	where c.dtfiled >= '2021-01-01' 
-- 	union 
-- 	select c.objid 
-- 	from cagban_terminal_go.specialpass_account c 
-- 	where c.expirydate >= '2021-01-01' 
-- )t0 
-- 	inner join cagban_terminal_go.specialpass_account c on c.objid = t0.objid 
-- ;

insert into specialpass_type 
select * from cagban_terminal_go.specialpass_type
;

insert into terminal 
select * from cagban_terminal_go.terminal
;

-- insert into terminalpass 
-- select c.*  
-- from cagban_terminal_go.terminalpass c 
-- where c.dtfiled >= '2021-01-01' 
-- ;

create index ix_dtused on cagban_terminal_go.ticket (dtused)
; 

create index ix_ticketid on cagban_terminal_go.ticket_void (ticketid)
;
create index ix_txndate on cagban_terminal_go.ticket_void (txndate)
;

-- create table cagban_terminal_go.ztmp_ticket (
-- 	objid varchar(50) not null, 
-- 	constraint pk_objid primary key (objid) 
-- ) ENGINE=MyISAM
-- ;
-- insert ignore into cagban_terminal_go.ztmp_ticket 
-- select c.objid 
-- from cagban_terminal_go.ticket c 
-- where c.dtfiled >= '2021-01-01' 
-- ;
-- insert ignore into cagban_terminal_go.ztmp_ticket 
-- select c.ticketid as objid  
-- from cagban_terminal_go.ticket_void c 
-- where c.txndate >= '2021-01-01' 
-- ;
-- insert ignore into cagban_terminal_go.ztmp_ticket 
-- select c.objid 
-- from cagban_terminal_go.ticket c 
-- where c.dtused is null 
-- ;

-- insert into ticket 
-- select c.* 
-- from cagban_terminal_go.ztmp_ticket z 
-- 	inner join cagban_terminal_go.ticket c on c.objid = z.objid
-- ;

-- insert into ticket_void 
-- select c.*  
-- from cagban_terminal_go.ticket_void c 
-- where c.txndate >= '2021-01-01' 
-- ;

insert into turnstile 
select * from cagban_terminal_go.turnstile
;

insert into turnstile_category 
select * from cagban_terminal_go.turnstile_category
;

insert into turnstile_item 
select * from cagban_terminal_go.turnstile_item
;

-- insert into terminalpass 
-- select p.* 
-- from ( 
-- 	select distinct refid 
-- 	from ticket t 
-- 	where t.reftype = 'terminalpass' 
-- )t0 
-- 	inner join cagban_terminal_go.terminalpass p on p.objid = t0.refid 
-- ;

drop table if exists cagban_terminal_go.ztmp_ticket;

set foreign_key_checks=1
;



set foreign_key_checks=0
;
drop table if exists af; 
drop table if exists af_control; 
drop table if exists af_inventory; 
drop table if exists af_inventory_detail; 
drop table if exists af_inventory_detail_cancelseries; 
drop table if exists af_inventory_return; 
drop table if exists ap; 
drop table if exists ap_detail; 
drop table if exists ar; 
drop table if exists ar_detail; 
drop table if exists async_notification; 
drop table if exists async_notification_delivered; 
drop table if exists async_notification_failed; 
drop table if exists async_notification_pending; 
drop table if exists async_notification_processing; 
drop table if exists bank; 
drop table if exists bankaccount; 
drop table if exists bankaccount_account; 
drop table if exists bankaccount_entry; 
drop table if exists bankdeposit; 
drop table if exists bankdeposit_entry; 
drop table if exists bankdeposit_entry_check; 
drop table if exists bankdeposit_liquidation; 
drop table if exists barangay; 
drop table if exists batchcapture_collection; 
drop table if exists batchcapture_collection_entry; 
drop table if exists batchcapture_collection_entry_item; 
drop table if exists billitem_txntype; 
drop table if exists brgyshare_account_mapping; 
drop table if exists cashbook; 
drop table if exists cashbook_entry; 
drop table if exists cashreceipt; 
drop table if exists cashreceipt_burial; 
drop table if exists cashreceipt_cancelseries; 
drop table if exists cashreceipt_cashticket; 
drop table if exists cashreceipt_ctc_corporate; 
drop table if exists cashreceipt_ctc_individual; 
drop table if exists cashreceipt_largecattleownership; 
drop table if exists cashreceipt_largecattletransfer; 
drop table if exists cashreceipt_marriage; 
drop table if exists cashreceipt_rpt; 
drop table if exists cashreceipt_slaughter; 
drop table if exists cashreceipt_void; 
drop table if exists cashreceiptitem; 
drop table if exists cashreceiptitem_discount; 
drop table if exists cashreceiptitem_rpt; 
drop table if exists cashreceiptitem_rpt_account; 
drop table if exists cashreceiptitem_rpt_noledger; 
drop table if exists cashreceiptitem_rpt_online; 
drop table if exists cashreceiptpayment_creditmemo; 
drop table if exists cashreceiptpayment_noncash; 
drop table if exists cashreceipts; 
drop table if exists certification; 
drop table if exists citizenship; 
drop table if exists city; 
drop table if exists cloud_notification; 
drop table if exists cloud_notification_attachment; 
drop table if exists cloud_notification_delivered; 
drop table if exists cloud_notification_failed; 
drop table if exists cloud_notification_pending; 
drop table if exists cloud_notification_received; 
drop table if exists collectiongroup; 
drop table if exists collectiongroup_revenueitem; 
drop table if exists collectiontype; 
drop table if exists collectiontype_account; 
drop table if exists creditmemo; 
drop table if exists creditmemoitem; 
drop table if exists creditmemotype; 
drop table if exists creditmemotype_account; 
drop table if exists directcash_collection; 
drop table if exists directcash_collection_item; 
drop table if exists district; 
drop table if exists draft_remittance; 
drop table if exists draft_remittance_cashreceipt; 
drop table if exists draftremittance; 
drop table if exists draftremittance_cashreceipt; 
drop table if exists entity; 
drop table if exists entity_address; 
drop table if exists entity_relation; 
drop table if exists entitycontact; 
drop table if exists entityid; 
drop table if exists entityindividual; 
drop table if exists entityjuridical; 
drop table if exists entitymember; 
drop table if exists entitymultiple; 
drop table if exists fund; 
drop table if exists government_property; 
drop table if exists image_chunk; 
drop table if exists image_header; 
drop table if exists income_summary; 
drop table if exists itemaccount; 
drop table if exists itemaccount_tag; 
drop table if exists liquidation; 
drop table if exists liquidation_cashier_fund; 
drop table if exists liquidation_creditmemopayment; 
drop table if exists liquidation_noncashpayment; 
drop table if exists liquidation_remittance; 
drop table if exists ngas_revenue; 
drop table if exists ngas_revenue_deposit; 
drop table if exists ngas_revenue_mapping; 
drop table if exists ngas_revenue_remittance; 
drop table if exists ngas_revenueitem; 
drop table if exists ngasaccount; 
drop table if exists paymentorder; 
drop table if exists paymentorder_type; 
drop table if exists profession; 
drop table if exists province; 
drop table if exists religion; 
drop table if exists remittance; 
drop table if exists remittance_af; 
drop table if exists remittance_cashreceipt; 
drop table if exists remittance_creditmemopayment; 
drop table if exists remittance_fund; 
drop table if exists remittance_noncashpayment; 
drop table if exists remoteserverdata; 
drop table if exists requirement_type; 
drop table if exists sms_inbox; 
drop table if exists sms_inbox_pending; 
drop table if exists sms_outbox; 
drop table if exists sms_outbox_pending; 
drop table if exists sre_revenue_mapping; 
drop table if exists sreaccount; 
drop table if exists sreaccount_incometarget; 
drop table if exists stockissue; 
drop table if exists stockissueitem; 
drop table if exists stockitem; 
drop table if exists stockitem_unit; 
drop table if exists stockreceipt; 
drop table if exists stockreceiptitem; 
drop table if exists stockrequest; 
drop table if exists stockrequestitem; 
drop table if exists stockreturn; 
drop table if exists stocksale; 
drop table if exists stocksaleitem; 
drop table if exists subcollector_remittance; 
drop table if exists subcollector_remittance_cashreceipt; 
drop table if exists sys_dataset; 
drop table if exists sys_notification; 
drop table if exists sys_org; 
drop table if exists sys_orgclass; 
drop table if exists sys_quarter; 
drop table if exists sys_report; 
drop table if exists sys_report_admin; 
drop table if exists sys_report_folder; 
drop table if exists sys_report_member; 
drop table if exists sys_requirement_type; 
drop table if exists sys_rule; 
drop table if exists sys_rule_action; 
drop table if exists sys_rule_action_param; 
drop table if exists sys_rule_actiondef; 
drop table if exists sys_rule_actiondef_param; 
drop table if exists sys_rule_condition; 
drop table if exists sys_rule_condition_constraint; 
drop table if exists sys_rule_condition_var; 
drop table if exists sys_rule_deployed; 
drop table if exists sys_rule_fact; 
drop table if exists sys_rule_fact_field; 
drop table if exists sys_rulegroup; 
drop table if exists sys_ruleset; 
drop table if exists sys_ruleset_actiondef; 
drop table if exists sys_ruleset_fact; 
drop table if exists sys_script; 
drop table if exists sys_securitygroup; 
drop table if exists sys_sequence; 
drop table if exists sys_session; 
drop table if exists sys_session_log; 
drop table if exists sys_terminal; 
drop table if exists sys_user; 
drop table if exists sys_usergroup; 
drop table if exists sys_usergroup_admin; 
drop table if exists sys_usergroup_member; 
drop table if exists sys_usergroup_permission; 
drop table if exists sys_var; 
drop table if exists sys_wf; 
drop table if exists sys_wf_assignee; 
drop table if exists sys_wf_node; 
drop table if exists sys_wf_subtask; 
drop table if exists sys_wf_task; 
drop table if exists sys_wf_transition; 
drop table if exists sys_wf_workitemtype; 
drop table if exists txnlog; 
drop table if exists variableinfo; 
drop table if exists workflowstate; 

set foreign_key_checks=1
;
