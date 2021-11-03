use ticketing_caticlan;


create table ztmp_user_admin
select 
	u.objid, u.username, u.lastname, u.firstname, u.middlename, u.name, u.jobtitle, u.txncode 
from ( 
	select ugm.user_objid 
	from caticlan.sys_usergroup_member ugm 
		inner join caticlan.sys_usergroup ug on ug.objid = ugm.usergroup_objid 
	where ugm.usergroup_objid = 'TERMINAL.ADMIN' 
)t0, caticlan.sys_user u 
where u.objid = t0.user_objid 
;

create table ztmp_user_collector
select 
	u.objid, u.username, u.lastname, u.firstname, u.middlename, u.name, u.jobtitle, u.txncode 
from ( 
	select distinct collector_objid as user_objid from caticlan.cashreceipt 
	union 
	select distinct subcollector_objid as user_objid from caticlan.cashreceipt 
)t0, caticlan.sys_user u 
where u.objid = t0.user_objid 
;

create table ztmp_user_role 
select * 
from ( 
	select 
		ugm.objid, 'ADMIN' as role, ugm.user_objid as userid, ugm.user_username as username, 
		ugm.org_objid, ugm.org_name, ugm.securitygroup_objid, ugm.exclude, ugm.objid as uid 
	from caticlan.sys_usergroup_member ugm 		
		inner join caticlan.sys_usergroup ug on ug.objid = ugm.usergroup_objid 
		inner join ztmp_user_admin zua on zua.objid = ugm.user_objid 
	where ugm.usergroup_objid = 'TERMINAL.ADMIN' 

	union all 

	select distinct 
		ugm.objid, 'MASTER' as role, ugm.user_objid as userid, ugm.user_username as username, 
		ugm.org_objid, ugm.org_name, ugm.securitygroup_objid, ugm.exclude, ugm.objid as uid 
	from caticlan.sys_usergroup_member ugm 
		inner join caticlan.sys_usergroup ug on ug.objid = ugm.usergroup_objid 
		inner join ztmp_user_collector zuc on zuc.objid = ugm.user_objid 
	where ugm.org_orgclass = 'TERMINAL'
		and ugm.usergroup_objid in ('TREASURY.COLLECTOR','TREASURY.SUBCOLLECTOR') 
)t0 
;

alter table ztmp_user_role modify role varchar(50) not null 
; 

insert into ztmp_user_role (
	objid, role, userid, username, org_objid, org_name, securitygroup_objid, exclude, uid 
) 
select t0.*, t0.objid as uid 
from ( 
	select 
		concat('UGM-',MD5(concat(r.userid, 'RULE_AUTHOR'))) as objid, 'RULE_AUTHOR' as role, 
		r.userid, r.username, r.org_objid, r.org_name, r.securitygroup_objid, r.exclude 
	from ztmp_user_role r 
	where role = 'ADMIN' 
)t0
where (select count(*) from ztmp_user_role where objid = t0.objid) = 0 
;

insert into ztmp_user_role (
	objid, role, userid, username, org_objid, org_name, securitygroup_objid, exclude, uid 
) 
select t0.*, t0.objid as uid 
from ( 
	select 
		concat('UGM-',MD5(concat(r.userid, 'WF_EDITOR'))) as objid, 'WF_EDITOR' as role, 
		r.userid, r.username, r.org_objid, r.org_name, r.securitygroup_objid, r.exclude 
	from ztmp_user_role r 
	where role = 'ADMIN' 
)t0 
where (select count(*) from sys_user_role where objid = t0.objid) = 0 
; 

insert into sys_user (
	objid, username, lastname, firstname, middlename, name, jobtitle, txncode 
)
select * 
from (  
	select * from ztmp_user_admin 
	union 
	select * from ztmp_user_collector 
)t0 
where (select count(*) from sys_user where objid = t0.objid) = 0 
	and (select count(*) from sys_user where username = t0.username) = 0 
;

insert ignore into sys_user_role (
	objid, role, userid, username, org_objid, org_name, securitygroup_objid, exclude, uid 
) 
select ur.*  
from ztmp_user_role ur 
	inner join sys_user u on u.objid = ur.userid 
;


delete from caticlan.sys_usergroup_member where usergroup_objid like 'TERMINAL.%'
;
delete from caticlan.sys_usergroup where domain='TERMINAL'
;


insert ignore into sys_var (
	name, value, description, datatype, category 
) 
select 
	name, value, description, datatype, category 
from caticlan.sys_var 
where name = 'thermal_printername'
;


insert into sys_sequence (
	objid, nextSeries 
) 
select 
	objid, nextSeries 
from caticlan.sys_sequence 
where objid like '%-aklanterminal' 
;

update sys_sequence set 
	objid = replace(objid, '-aklanterminal', '-ticketing') 
where 
	objid like '%-aklanterminal'
; 
