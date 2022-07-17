-- ## 2022-07-11

CREATE TABLE sys_report_template (
  name varchar(100) NOT NULL,
  title varchar(255) NULL,
  filepath varchar(255) NOT NULL,
  master int NULL,
  icon mediumblob,
  constraint pk_sys_report_template PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index uix_filepath on sys_report_template (filepath)
;


CREATE TABLE sys_report_def (
  name varchar(100) NOT NULL,
  title varchar(255) NULL,
  category varchar(255) NULL,
  template varchar(255) NULL,
  reportheader varchar(100) NULL,
  role varchar(50) NULL,
  sortorder int NULL,
  statement longtext, 
  permission varchar(100) NULL,
  parameters longtext,
  querytype varchar(50) NULL,
  state varchar(10) NULL,
  description varchar(255) NULL,
  properties longtext,
  constraint pk_sys_report_def PRIMARY KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index ix_template on sys_report_def (template)
;


CREATE TABLE sys_report_subreport_def (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NULL,
  reportid varchar(100) NULL,
  name varchar(50) NULL,
  querytype varchar(50) NULL,
  statement longtext,
  constraint pk_sys_report_subreport_def PRIMARY KEY (objid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index ix_reportid on sys_report_subreport_def (reportid)
;
alter table sys_report_subreport_def 
  add CONSTRAINT fk_sys_report_subreport_def_reportid 
  FOREIGN KEY (reportid) REFERENCES sys_report_def (name)
;
