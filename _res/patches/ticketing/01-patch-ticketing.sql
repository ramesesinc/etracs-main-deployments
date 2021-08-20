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

