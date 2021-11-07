-- ===============================
-- Terminal Database Upgrade Guide
-- ===============================
-- 
-- Source-DB:  caticlan_terminal_go 
-- Target-DB:  ticketing_caticlan
-- 
-- 
-- 01. Create the target database "ticketing_caticlan"
-- 
--     mysql -u root -p1234 -e "CREATE DATABASE ticketing_caticlan CHARACTER SET utf8"
-- 
-- 
-- 02. Dump the source schemas and import to the target database 
-- 
--     mysqldump -u root -p1234 -f -d caticlan_terminal_go | mysql -u root -p1234 -f -v -D ticketing_caticlan  
-- 
-- 
-- 03. Run the following scripts below
-- 
-- 

use ticketing_caticlan
; 

set foreign_key_checks=0
;

insert into cashreceipt_terminal 
select c.* 
from caticlan_terminal_go.cashreceipt_terminal c 
where dtfiled >= '2021-01-01' 
;

insert into specialpass_account 
select c.* 
from ( 
	select c.objid 
	from caticlan_terminal_go.specialpass_account c 
	where c.dtfiled >= '2021-01-01' 
	union 
	select c.objid 
	from caticlan_terminal_go.specialpass_account c 
	where c.expirydate >= '2021-01-01' 
)t0 
	inner join caticlan_terminal_go.specialpass_account c on c.objid = t0.objid 
;

insert into specialpass_type 
select * from caticlan_terminal_go.specialpass_type
;

insert into terminal 
select * from caticlan_terminal_go.terminal
;

insert into terminalpass 
select c.*  
from caticlan_terminal_go.terminalpass c 
where c.dtfiled >= '2021-01-01' 
;

create index ix_dtused on caticlan_terminal_go.ticket (dtused)
; 

create index ix_ticketid on caticlan_terminal_go.ticket_void (ticketid)
;
create index ix_txndate on caticlan_terminal_go.ticket_void (txndate)
;

create table caticlan_terminal_go.ztmp_ticket (
	objid varchar(50) not null, 
	constraint pk_objid primary key (objid) 
) ENGINE=MyISAM
;
insert ignore into caticlan_terminal_go.ztmp_ticket 
select c.objid 
from caticlan_terminal_go.ticket c 
where c.dtfiled >= '2021-01-01' 
;
insert ignore into caticlan_terminal_go.ztmp_ticket 
select c.ticketid as objid  
from caticlan_terminal_go.ticket_void c 
where c.txndate >= '2021-01-01' 
;
insert ignore into caticlan_terminal_go.ztmp_ticket 
select c.objid 
from caticlan_terminal_go.ticket c 
where c.dtused is null 
;

insert into ticket 
select c.* 
from caticlan_terminal_go.ztmp_ticket z 
	inner join caticlan_terminal_go.ticket c on c.objid = z.objid
;

insert into ticket_void 
select c.*  
from caticlan_terminal_go.ticket_void c 
where c.txndate >= '2021-01-01' 
;

insert into turnstile 
select * from caticlan_terminal_go.turnstile
;

insert into turnstile_category 
select * from caticlan_terminal_go.turnstile_category
;

insert into turnstile_item 
select * from caticlan_terminal_go.turnstile_item
;

insert into terminalpass 
select p.* 
from ( 
	select distinct refid 
	from ticket t 
	where t.reftype = 'terminalpass' 
)t0 
	inner join caticlan_terminal_go.terminalpass p on p.objid = t0.refid 
;

drop table if exists caticlan_terminal_go.ztmp_ticket;

set foreign_key_checks=1
;
