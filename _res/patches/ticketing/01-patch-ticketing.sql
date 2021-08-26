create index ix_title on turnstile (title)
; 
create index ix_createdby_name on turnstile (createdby_name)
; 


create index ix_title on turnstile_category (title)
; 


create index ix_categoryid on turnstile_item (categoryid)
; 


update turnstile set state = 'ACTIVE' where state = 'DRAFT'
; 


create index ix_dtused on ticket (dtused)
; 


create index ix_ticketid on ticket_void (ticketid)
; 
create index ix_txndate on ticket_void (txndate)
; 
create index ix_postedby_objid on ticket_void (postedby_objid)
; 
create index ix_postedby_name on ticket_void (postedby_name)
; 
alter table ticket_void modify ticketid varchar(50) character set latin1 not null 
;
alter table ticket_void add constraint fk_ticket_void_ticketid 
	foreign key (ticketid) references ticket (objid) 
; 


drop view if exists vw_ticket
;
create view vw_ticket as 
select t.*, 
	(case when v.objid is null then 0 else 1 end) as voided, 
	v.objid as void_objid, v.txndate as void_txndate, v.reason as void_reason 
from ticket t 
	left join ticket_void v on v.ticketid = t.objid 
;

drop view if exists vw_ticket_void
;
create view vw_ticket_void as 
select t.*, 
	(case when v.objid is null then 0 else 1 end) as voided, 
	v.objid as void_objid, v.txndate as void_txndate, v.reason as void_reason 
from ticket_void v 
	inner join ticket t on t.objid = v.ticketid 
;


alter table cashreceipt_terminal add (
	numsenior int not null default '0',
	numfil int not null default '0',
	numnonfil int not null default '0'
); 

update cashreceipt_terminal set discount = 0 where discount is null 
;
alter table cashreceipt_terminal modify discount decimal(16,4) not null default '0'
;

create unique index uix_ticketid on ticket_void (ticketid);



alter table cashreceipt_terminal add routeid varchar(50) null
;
update cashreceipt_terminal set 
	routeid = (select objid from terminal limit 1) 
where 
	routeid is null 
; 
alter table cashreceipt_terminal modify routeid varchar(50) not null 
;
alter table cashreceipt_terminal add constraint fk_cashreceipt_terminal_routeid 
	foreign key (routeid) REFERENCES terminal (objid) 
;

