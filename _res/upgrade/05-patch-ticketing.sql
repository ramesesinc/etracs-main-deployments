use caticlan_terminal_go;


create table ztmp_user_admin
select 
	u.objid, u.username, u.lastname, u.firstname, u.middlename, u.name, u.jobtitle, u.txncode 
from ( 
	select ugm.user_objid 
	from caticlan_go.sys_usergroup_member ugm 
		inner join caticlan_go.sys_usergroup ug on ug.objid = ugm.usergroup_objid 
	where ugm.usergroup_objid = 'TERMINAL.ADMIN' 
)t0, caticlan_go.sys_user u 
where u.objid = t0.user_objid 
;

create table ztmp_user_collector
select 
	u.objid, u.username, u.lastname, u.firstname, u.middlename, u.name, u.jobtitle, u.txncode 
from ( 
	select distinct collector_objid as user_objid from caticlan_go.cashreceipt 
	union 
	select distinct subcollector_objid as user_objid from caticlan_go.cashreceipt 
)t0, caticlan_go.sys_user u 
where u.objid = t0.user_objid 
;

create table ztmp_user_role 
select * 
from ( 
	select 
		ugm.objid, 'ADMIN' as role, ugm.user_objid as userid, ugm.user_username as username, 
		ugm.org_objid, ugm.org_name, ugm.securitygroup_objid, ugm.exclude, ugm.objid as uid 
	from caticlan_go.sys_usergroup_member ugm 		
		inner join caticlan_go.sys_usergroup ug on ug.objid = ugm.usergroup_objid 
		inner join ztmp_user_admin zua on zua.objid = ugm.user_objid 
	where ugm.usergroup_objid = 'TERMINAL.ADMIN' 

	union all 

	select distinct 
		ugm.objid, 'MASTER' as role, ugm.user_objid as userid, ugm.user_username as username, 
		ugm.org_objid, ugm.org_name, ugm.securitygroup_objid, ugm.exclude, ugm.objid as uid 
	from caticlan_go.sys_usergroup_member ugm 
		inner join caticlan_go.sys_usergroup ug on ug.objid = ugm.usergroup_objid 
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

drop table ztmp_user_admin;
drop table ztmp_user_collector;
drop table ztmp_user_role;


delete from caticlan_go.sys_usergroup_member where usergroup_objid like 'TERMINAL.%'
;
delete from caticlan_go.sys_usergroup where domain='TERMINAL'
;


insert ignore into sys_var (
	name, value, description, datatype, category 
) 
select 
	name, value, description, datatype, category 
from caticlan_go.sys_var 
where name = 'thermal_printername'
;


insert into sys_sequence (
	objid, nextSeries 
) 
select 
	objid, nextSeries 
from caticlan_go.sys_sequence 
where objid like '%-aklanterminal' 
;

update sys_sequence set 
	objid = replace(objid, '-aklanterminal', '-ticketing') 
where 
	objid like '%-aklanterminal'
; 




create table ztmp_user_role_master 
select * from sys_user_role where role='MASTER'
;
delete from sys_user_role where objid in (
	select objid from ztmp_user_role_master 
)
;
delete from sys_user where objid in (
	select userid from ztmp_user_role_master 
) and (
	select count(*) from sys_user_role 
	where userid = sys_user.objid 
) = 0 
;
drop table ztmp_user_role_master
;


insert ignore into sys_user (
	objid, username, firstname, lastname, middlename, name, jobtitle, txncode 
) 
select 
	u.objid, u.username, u.firstname, u.lastname, u.middlename, u.name, u.jobtitle, u.txncode 
from (
	select distinct ugm.user_objid 
	from caticlan_go.sys_usergroup_member ugm 
		inner join caticlan_go.sys_usergroup ug on ug.objid = ugm.usergroup_objid 
		inner join terminal t on t.objid = ugm.org_objid 
	where ugm.org_orgclass = 'TERMINAL'
		and ugm.usergroup_objid in ('TREASURY.COLLECTOR','TREASURY.SUBCOLLECTOR') 
)t0, caticlan_go.sys_user u 
where u.objid = t0.user_objid 
;

insert ignore into sys_user_role (
	objid, uid, role, userid, username, org_objid, org_name 
) 
select 
	CONCAT('UR-', MD5(CONCAT(t0.userid, t0.role, t0.org_objid))) as objid, 
	CONCAT('UR-', MD5(CONCAT(t0.userid, t0.role, t0.org_objid))) as uid, 
	t0.role, t0.userid, u.username, t0.org_objid, t0.org_name 
from ( 
	select distinct 
		'MASTER' as role, ugm.user_objid as userid, ugm.user_username as username, ugm.org_objid, ugm.org_name 
	from caticlan_go.sys_usergroup_member ugm 
		inner join caticlan_go.sys_usergroup ug on ug.objid = ugm.usergroup_objid 
		inner join terminal t on t.objid = ugm.org_objid 
	where ugm.org_orgclass = 'TERMINAL'
		and ugm.usergroup_objid in ('TREASURY.COLLECTOR','TREASURY.SUBCOLLECTOR') 
)t0, sys_user u 
where u.objid = t0.userid 
;



create table ztmp_terminal 
select distinct 
	cto.org_objid as objid, 'ACTIVE' as state, cto.org_name as name, 
	'Caticlan Jetty Port Terminal, Aklan' as address 
from caticlan_go.collectiontype ct
	inner join caticlan_go.collectiontype_org cto on cto.collectiontypeid = ct.objid 
where ct.handler = 'ticketing' 
order by ct.org_objid
;
insert into terminal (
	objid, state, name, address 
) 
select 
	objid, state, name, address 
from ztmp_terminal z 
where (
		select count(*) from terminal where objid = z.objid 
	) = 0
; 
drop table ztmp_terminal
; 


create table ztmp_route 
select distinct 
	cto.org_objid as objid, 'ACTIVE' as state, cto.org_name as name, 
	0 as sortorder, cto.org_objid as originid, null as destinationid 
from caticlan_go.collectiontype ct
	inner join caticlan_go.collectiontype_org cto on cto.collectiontypeid = ct.objid 
	inner join terminal t on t.objid = cto.org_objid 
where ct.handler = 'ticketing' 
order by cto.org_objid 
;
insert into route ( 
	objid, state, name, sortorder, originid, destinationid 
)
select 
	objid, state, name, sortorder, originid, destinationid 
from ztmp_route r 
where ( select count(*) from route where objid = r.objid ) = 0 
; 
update 
	route aa, ztmp_route bb 
set
	aa.state = bb.state, 
	aa.name = bb.name, 
	aa.sortorder = bb.sortorder, 
	aa.originid = bb.originid, 
	aa.destinationid = bb.destinationid 
where 
	aa.objid = bb.objid 
; 
drop table ztmp_route
;
