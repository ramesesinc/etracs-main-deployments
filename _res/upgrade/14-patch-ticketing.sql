use ticketing_cagban;


INSERT INTO terminal (objid, state, name, address) VALUES ('038CAG', 'ACTIVE', 'CAGBAN JETTY PORT TERMINAL', 'CAGBAN JETTY PORT TERMINAL, AKLAN');

INSERT INTO route (objid, state, name, sortorder, originid) VALUES ('ROUTE5e26f8cc:17ba02c32c0:-7f77', 'ACTIVE', 'CAGBAN - CATICLAN', '1', '038CAG');

INSERT INTO sys_var (name, value) VALUES ('qr_ticket_route_id', 'ROUTE5e26f8cc:17ba02c32c0:-7f77');
