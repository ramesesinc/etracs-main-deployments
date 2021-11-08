use ticketing_caticlan;


INSERT INTO terminal (objid, state, name, address) VALUES ('038CAT', 'ACTIVE', 'CATICLAN JETTY PORT TERMINAL', 'CATICLAN JETTY PORT TERMINAL, AKLAN');

INSERT INTO route (objid, state, name, sortorder, originid) VALUES ('ROUTE290d16d3:17ba01919c0:-7ef0', 'ACTIVE', 'CATICLAN - CAGBAN', '0', '038CAT');

INSERT INTO sys_var (name, value) VALUES ('qr_ticket_route_id', 'ROUTE290d16d3:17ba01919c0:-7ef0');
