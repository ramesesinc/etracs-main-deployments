use cagban_terminal_go;

--
-- fix existing tables to utf8 character set
--

ALTER TABLE `cashreceipt_terminal`
  add `numsenior` int(11) NOT NULL DEFAULT '0' ,
  add `numfil` int(11) NOT NULL DEFAULT '0' ,
  add `numnonfil` int(11) NOT NULL DEFAULT '0' 
; 

ALTER TABLE `terminal`
  DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
; 
ALTER TABLE `terminal` 
  modify `objid` varchar(50) CHARACTER SET utf8 NOT NULL,
  modify `state` varchar(25) CHARACTER SET utf8 NULL,
  modify `name` varchar(150) CHARACTER SET utf8 NULL,
  modify `address` varchar(255) CHARACTER SET utf8 NULL
; 

ALTER TABLE `specialpass_account`
  DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
; 
ALTER TABLE `specialpass_account` 
  modify `objid` varchar(50) CHARACTER SET utf8 NOT NULL,
  modify `state` varchar(25) CHARACTER SET utf8 NULL,
  modify `createdby_objid` varchar(50) CHARACTER SET utf8 NULL,
  modify `createdby_name` varchar(160) CHARACTER SET utf8 NULL,
  modify `acctno` varchar(25) CHARACTER SET utf8 NULL,
  modify `accttype_objid` varchar(50) CHARACTER SET utf8 NULL,
  modify `name` varchar(160) CHARACTER SET utf8 NULL,
  modify `address` varchar(255) CHARACTER SET utf8 NULL,
  modify `gender` varchar(1) CHARACTER SET utf8 NULL,
  modify `idtype` varchar(50) CHARACTER SET utf8 NULL,
  modify `idno` varchar(50) CHARACTER SET utf8 NULL,
  modify `citizenship` varchar(50) CHARACTER SET utf8 NULL,
  modify `civilstatus` varchar(25) CHARACTER SET utf8 NULL
; 

ALTER TABLE `specialpass_type`
  DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
; 
ALTER TABLE `specialpass_type` 
  modify `objid` varchar(50) CHARACTER SET utf8 NOT NULL,
  modify `title` varchar(150) CHARACTER SET utf8 NULL
;

ALTER TABLE `terminalpass`
  DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
; 
ALTER TABLE `terminalpass` 
  modify `objid` varchar(50) CHARACTER SET utf8 NOT NULL,
  modify `collector_objid` varchar(50) CHARACTER SET utf8 NULL,
  modify `collector_name` varchar(150) CHARACTER SET utf8 NULL,
  modify `org_objid` varchar(50) CHARACTER SET utf8 NULL,
  modify `org_name` varchar(255) CHARACTER SET utf8 NULL,
  modify `startseqno` varchar(25) CHARACTER SET utf8 NULL,
  modify `endseqno` varchar(25) CHARACTER SET utf8 NULL,
  modify `tag` varchar(50) CHARACTER SET utf8 NULL 
;

alter table turnstile_item 
  drop foreign key fk_turnstileitem_categoryid, 
  drop foreign key fk_turnstileitem_turnstileid
;


ALTER TABLE `turnstile`
  DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
; 
ALTER TABLE `turnstile`
  modify `objid` varchar(50) CHARACTER SET utf8 NOT NULL,
  modify `state` varchar(25) CHARACTER SET utf8 NULL,
  modify `createdby_objid` varchar(50) CHARACTER SET utf8 NULL,
  modify `createdby_name` varchar(100) CHARACTER SET utf8 NULL,
  modify `title` varchar(100) CHARACTER SET utf8 NULL,
  modify `location` varchar(255) CHARACTER SET utf8 NULL
;

ALTER TABLE `turnstile_category`
  DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
; 
ALTER TABLE `turnstile_category`
  modify `objid` varchar(50) CHARACTER SET utf8 NOT NULL,
  modify `title` varchar(100) CHARACTER SET utf8 NULL
;

ALTER TABLE `turnstile_item`
  DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
; 
ALTER TABLE `turnstile_item`
  modify `categoryid` varchar(50) CHARACTER SET utf8 NOT NULL,
  modify `turnstileid` varchar(50) CHARACTER SET utf8 NOT NULL
;

alter table turnstile_item 
  add CONSTRAINT `fk_turnstileitem_categoryid` 
    FOREIGN KEY (`categoryid`) REFERENCES `turnstile_category` (`objid`),
  
  add CONSTRAINT `fk_turnstileitem_turnstileid` 
    FOREIGN KEY (`turnstileid`) REFERENCES `turnstile` (`objid`)
; 



--
-- Table structure for table `route`
--
CREATE TABLE `route` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `name` varchar(100) NOT NULL,
  `sortorder` int(255) NOT NULL DEFAULT '0',
  `originid` varchar(50) NOT NULL,
  `destinationid` varchar(50) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_destinationid` (`destinationid`),
  KEY `ix_originid` (`originid`),
  KEY `ix_name` (`name`),
  KEY `uix_originid_destinationid` (`originid`,`destinationid`),
  CONSTRAINT `fk_route_destinationid` FOREIGN KEY (`destinationid`) REFERENCES `terminal` (`objid`),
  CONSTRAINT `fk_route_originid` FOREIGN KEY (`originid`) REFERENCES `terminal` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `sys_email_queue`
--
CREATE TABLE `sys_email_queue` (
  `objid` varchar(50) NOT NULL,
  `refid` varchar(50) NULL,
  `state` int(11) NULL,
  `reportid` varchar(50) NULL,
  `dtsent` datetime NULL,
  `to` varchar(255) NULL,
  `subject` varchar(255) NULL,
  `message` mediumtext,
  `errmsg` varchar(255) NULL,
  `connection` varchar(50) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_state` (`state`),
  KEY `ix_reportid` (`reportid`),
  KEY `ix_dtsent` (`dtsent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_email_template`
--
CREATE TABLE `sys_email_template` (
  `objid` varchar(50) NOT NULL,
  `subject` varchar(255) NULL,
  `message` mediumtext,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_file`
--
CREATE TABLE `sys_file` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(50) NULL,
  `filetype` varchar(50) NULL,
  `dtcreated` datetime NULL,
  `createdby_objid` varchar(50) NULL,
  `createdby_name` varchar(255) NULL,
  `keywords` varchar(255) NULL,
  `description` text,
  PRIMARY KEY (`objid`),
  KEY `ix_title` (`title`),
  KEY `ix_dtcreated` (`dtcreated`),
  KEY `ix_createdby_objid` (`createdby_objid`),
  KEY `ix_keywords` (`keywords`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_fileitem`
--
CREATE TABLE `sys_fileitem` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NULL,
  `parentid` varchar(50) NULL,
  `dtcreated` datetime NULL,
  `createdby_objid` varchar(50) NULL,
  `createdby_name` varchar(255) NULL,
  `caption` varchar(155) NULL,
  `remarks` varchar(255) NULL,
  `filelocid` varchar(50) NULL,
  `filesize` int(11) NULL,
  `thumbnail` text,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_dtcreated` (`dtcreated`),
  KEY `ix_createdby_objid` (`createdby_objid`),
  KEY `ix_createdby_name` (`createdby_name`),
  KEY `ix_filelocid` (`filelocid`),
  CONSTRAINT `fk_sys_fileitem_parentid` FOREIGN KEY (`parentid`) REFERENCES `sys_file` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_fileloc`
--
CREATE TABLE `sys_fileloc` (
  `objid` varchar(50) NOT NULL,
  `url` varchar(255) NOT NULL,
  `rootdir` varchar(255) NULL,
  `defaultloc` int(11) NOT NULL,
  `loctype` varchar(20) NULL,
  `user_name` varchar(50) NULL,
  `user_pwd` varchar(50) NULL,
  `info` text,
  PRIMARY KEY (`objid`),
  KEY `ix_loctype` (`loctype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_report_header`
--
CREATE TABLE `sys_report_header` (
  `objid` varchar(50) NOT NULL,
  `value` mediumtext,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_report_tag`
--
CREATE TABLE `sys_report_tag` (
  `objid` varchar(150) NOT NULL,
  `description` varchar(255) NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_role`
--
CREATE TABLE `sys_role` (
  `name` varchar(50) NOT NULL,
  `title` varchar(255) NULL,
  `system` int(11) NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `sys_role` VALUES ('ADMIN','ADMIN',1),('COLLECTOR','COLLECTOR',1),('MASTER','MASTER',1),('REPORT','REPORT',1),('RULE_AUTHOR','RULE AUTHOR',1),('SHARED','SHARED',1),('WF_EDITOR','WORKFLOW EDITOR',1);

--
-- Table structure for table `sys_role_permission`
--
CREATE TABLE `sys_role_permission` (
  `objid` varchar(100) NOT NULL,
  `role` varchar(50) NULL,
  `object` varchar(25) NULL,
  `permission` varchar(25) NULL,
  `title` varchar(50) NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_role_object_permission` (`role`,`object`,`permission`),
  KEY `ix_role` (`role`),
  CONSTRAINT `fk_sys_role_permission_role` FOREIGN KEY (`role`) REFERENCES `sys_role` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `sys_role_permission` VALUES ('COLLECTOR-terminalpass-reprint','COLLECTOR','terminalpass','reprint','Reprint Terminal Pass');

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
drop table if exists sys_signature;
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


--
-- Table structure for table `sys_rule`
--
CREATE TABLE `sys_rule` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NULL,
  `name` varchar(50) NOT NULL,
  `ruleset` varchar(50) NOT NULL,
  `rulegroup` varchar(50) NULL,
  `title` varchar(250) NULL,
  `description` longtext,
  `salience` int(11) NULL,
  `effectivefrom` date NULL,
  `effectiveto` date NULL,
  `dtfiled` datetime NULL,
  `user_objid` varchar(50) NULL,
  `user_name` varchar(100) NULL,
  `noloop` int(11) NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_ruleset_name` (`ruleset`,`name`),
  KEY `ix_state` (`state`),
  KEY `ix_name` (`name`),
  KEY `ix_ruleset` (`ruleset`),
  KEY `ix_rulegroup` (`rulegroup`),
  KEY `ix_dtfiled` (`dtfiled`),
  KEY `sys_rule_ibfk_1` (`rulegroup`,`ruleset`),
  CONSTRAINT `sys_rule_ibfk_1` FOREIGN KEY (`rulegroup`, `ruleset`) REFERENCES `sys_rulegroup` (`name`, `ruleset`),
  CONSTRAINT `sys_rule_ibfk_2` FOREIGN KEY (`ruleset`) REFERENCES `sys_ruleset` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_rule_action`
--
CREATE TABLE `sys_rule_action` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NULL,
  `actiondef_objid` varchar(50) NULL,
  `actiondef_name` varchar(50) NULL,
  `pos` int(11) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_actiondef_objid` (`actiondef_objid`),
  CONSTRAINT `sys_rule_action_actiondef` FOREIGN KEY (`actiondef_objid`) REFERENCES `sys_rule_actiondef` (`objid`),
  CONSTRAINT `sys_rule_action_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `sys_rule` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_rule_action_param`
--
CREATE TABLE `sys_rule_action_param` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NULL,
  `actiondefparam_objid` varchar(100) NULL,
  `stringvalue` varchar(255) NULL,
  `booleanvalue` int(11) NULL,
  `var_objid` varchar(50) NULL,
  `var_name` varchar(50) NULL,
  `expr` longtext,
  `exprtype` varchar(25) NULL,
  `pos` int(11) NULL,
  `obj_key` varchar(50) NULL,
  `obj_value` varchar(255) NULL,
  `listvalue` longtext,
  `lov` varchar(50) NULL,
  `rangeoption` int(11) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_actiondefparam_objid` (`actiondefparam_objid`),
  KEY `ix_var_objid` (`var_objid`),
  KEY `ix_var_name` (`var_name`),
  KEY `ix_obj_key` (`obj_key`),
  CONSTRAINT `fk_sys_rule_action_param_actiondefparam_objid` FOREIGN KEY (`actiondefparam_objid`) REFERENCES `sys_rule_actiondef_param` (`objid`),
  CONSTRAINT `fk_sys_rule_action_param_obj_key` FOREIGN KEY (`obj_key`) REFERENCES `ticketing_itemaccount` (`objid`),
  CONSTRAINT `fk_sys_rule_action_param_parentid` FOREIGN KEY (`parentid`) REFERENCES `sys_rule_action` (`objid`),
  CONSTRAINT `fk_sys_rule_action_param_var_objid` FOREIGN KEY (`var_objid`) REFERENCES `sys_rule_condition_var` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_rule_actiondef`
--
CREATE TABLE `sys_rule_actiondef` (
  `objid` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `title` varchar(250) NULL,
  `sortorder` int(11) NULL,
  `actionname` varchar(50) NULL,
  `domain` varchar(50) NULL,
  `actionclass` varchar(255) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_name` (`name`),
  KEY `ix_title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_rule_actiondef_param`
--
CREATE TABLE `sys_rule_actiondef_param` (
  `objid` varchar(100) NOT NULL DEFAULT '',
  `parentid` varchar(50) NULL,
  `name` varchar(50) NOT NULL,
  `sortorder` int(11) NULL,
  `title` varchar(50) NULL,
  `datatype` varchar(50) NULL,
  `handler` varchar(50) NULL,
  `lookuphandler` varchar(50) NULL,
  `lookupkey` varchar(50) NULL,
  `lookupvalue` varchar(50) NULL,
  `vardatatype` varchar(50) NULL,
  `lovname` varchar(50) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_name` (`name`),
  KEY `ix_title` (`title`),
  CONSTRAINT `sys_rule_actiondef_param_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `sys_rule_actiondef` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_rule_condition`
--
CREATE TABLE `sys_rule_condition` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NULL,
  `fact_name` varchar(50) NULL,
  `fact_objid` varchar(50) NULL,
  `varname` varchar(50) NULL,
  `pos` int(11) NULL,
  `ruletext` longtext,
  `displaytext` longtext,
  `dynamic_datatype` varchar(50) NULL,
  `dynamic_key` varchar(50) NULL,
  `dynamic_value` varchar(50) NULL,
  `notexist` int(11) NOT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_fact_objid` (`fact_objid`),
  KEY `ix_fact_name` (`fact_name`),
  CONSTRAINT `sys_rule_condition_fact` FOREIGN KEY (`fact_objid`) REFERENCES `sys_rule_fact` (`objid`),
  CONSTRAINT `sys_rule_condition_ibfk_1` FOREIGN KEY (`fact_objid`) REFERENCES `sys_rule_fact` (`objid`),
  CONSTRAINT `sys_rule_condition_ibfk_2` FOREIGN KEY (`parentid`) REFERENCES `sys_rule` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_rule_condition_constraint`
--
CREATE TABLE `sys_rule_condition_constraint` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NULL,
  `field_objid` varchar(100) NULL,
  `fieldname` varchar(50) NULL,
  `varname` varchar(50) NULL,
  `operator_caption` varchar(50) NULL,
  `operator_symbol` varchar(50) NULL,
  `usevar` int(11) NULL,
  `var_objid` varchar(50) NULL,
  `var_name` varchar(50) NULL,
  `decimalvalue` decimal(16,2) NULL,
  `intvalue` int(11) NULL,
  `stringvalue` varchar(255) NULL,
  `listvalue` longtext,
  `datevalue` date NULL,
  `pos` int(11) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_field_objid` (`field_objid`),
  KEY `ix_var_objid` (`var_objid`),
  CONSTRAINT `sys_rule_condition_constraint_fact_field` FOREIGN KEY (`field_objid`) REFERENCES `sys_rule_fact_field` (`objid`),
  CONSTRAINT `sys_rule_condition_constraint_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `sys_rule_condition` (`objid`),
  CONSTRAINT `sys_rule_condition_constraint_ibfk_2` FOREIGN KEY (`var_objid`) REFERENCES `sys_rule_condition_var` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_rule_condition_var`
--
CREATE TABLE `sys_rule_condition_var` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NULL,
  `ruleid` varchar(50) NULL,
  `varname` varchar(50) NULL,
  `datatype` varchar(50) NULL,
  `pos` int(11) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_ruleid` (`ruleid`),
  CONSTRAINT `sys_rule_condition_var_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `sys_rule_condition` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_rule_deployed`
--
CREATE TABLE `sys_rule_deployed` (
  `objid` varchar(50) NOT NULL,
  `ruletext` longtext,
  PRIMARY KEY (`objid`),
  CONSTRAINT `sys_rule_deployed_ibfk_1` FOREIGN KEY (`objid`) REFERENCES `sys_rule` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_rule_fact`
--
CREATE TABLE `sys_rule_fact` (
  `objid` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `title` varchar(160) NULL,
  `factclass` varchar(50) NULL,
  `sortorder` int(11) NULL,
  `handler` varchar(50) NULL,
  `defaultvarname` varchar(25) NULL,
  `dynamic` int(11) NULL,
  `lookuphandler` varchar(50) NULL,
  `lookupkey` varchar(50) NULL,
  `lookupvalue` varchar(50) NULL,
  `lookupdatatype` varchar(50) NULL,
  `dynamicfieldname` varchar(50) NULL,
  `builtinconstraints` varchar(50) NULL,
  `domain` varchar(50) NULL,
  `factsuperclass` varchar(50) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_name` (`name`),
  KEY `ix_title` (`title`),
  KEY `ix_factclass` (`factclass`),
  KEY `ix_factsuperclass` (`factsuperclass`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_rule_fact_field`
--
CREATE TABLE `sys_rule_fact_field` (
  `objid` varchar(100) NOT NULL DEFAULT '',
  `parentid` varchar(50) NULL,
  `name` varchar(50) NOT NULL,
  `title` varchar(160) NULL,
  `datatype` varchar(50) NULL,
  `sortorder` int(11) NULL,
  `handler` varchar(50) NULL,
  `lookuphandler` varchar(50) NULL,
  `lookupkey` varchar(50) NULL,
  `lookupvalue` varchar(50) NULL,
  `lookupdatatype` varchar(50) NULL,
  `multivalued` int(11) NULL,
  `required` int(11) NULL,
  `vardatatype` varchar(50) NULL,
  `lovname` varchar(50) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_name` (`name`),
  KEY `ix_title` (`title`),
  CONSTRAINT `sys_rule_fact_field_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `sys_rule_fact` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_rulegroup`
--
CREATE TABLE `sys_rulegroup` (
  `name` varchar(50) NOT NULL,
  `ruleset` varchar(50) NOT NULL,
  `title` varchar(160) NULL,
  `sortorder` int(11) NULL,
  PRIMARY KEY (`name`,`ruleset`),
  KEY `ruleset` (`ruleset`),
  CONSTRAINT `sys_rulegroup_ibfk_1` FOREIGN KEY (`ruleset`) REFERENCES `sys_ruleset` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_ruleset`
--
CREATE TABLE `sys_ruleset` (
  `name` varchar(50) NOT NULL,
  `title` varchar(160) NULL,
  `packagename` varchar(50) NULL,
  `domain` varchar(50) NULL,
  `role` varchar(50) NULL,
  `permission` varchar(50) NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_ruleset_actiondef`
--
CREATE TABLE `sys_ruleset_actiondef` (
  `ruleset` varchar(50) NOT NULL,
  `actiondef` varchar(50) NOT NULL,
  PRIMARY KEY (`actiondef`,`ruleset`),
  KEY `ix_ruleset` (`ruleset`),
  KEY `ix_actiondef` (`actiondef`),
  CONSTRAINT `fk_sys_ruleset_actiondef_actiondef` FOREIGN KEY (`actiondef`) REFERENCES `sys_rule_actiondef` (`objid`),
  CONSTRAINT `sys_ruleset_actiondef_ibfk_2` FOREIGN KEY (`ruleset`) REFERENCES `sys_ruleset` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_ruleset_fact`
--
CREATE TABLE `sys_ruleset_fact` (
  `ruleset` varchar(50) NOT NULL,
  `rulefact` varchar(50) NOT NULL,
  PRIMARY KEY (`rulefact`,`ruleset`),
  KEY `ix_ruleset` (`ruleset`),
  KEY `ix_rulefact` (`rulefact`),
  CONSTRAINT `fk_sys_ruleset_fact_rulefact` FOREIGN KEY (`rulefact`) REFERENCES `sys_rule_fact` (`objid`),
  CONSTRAINT `sys_ruleset_fact_ibfk_2` FOREIGN KEY (`ruleset`) REFERENCES `sys_ruleset` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_sequence`
--
CREATE TABLE `sys_sequence` (
  `objid` varchar(100) NOT NULL,
  `nextSeries` int(11) NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_signature`
--
CREATE TABLE `sys_signature` (
  `objid` varchar(50) NOT NULL,
  `userid` varchar(50) NULL,
  `user_name` varchar(255) NULL,
  `displayname` varchar(255) NULL,
  `position` varchar(255) NULL,
  `signature` mediumblob,
  `tag` varchar(50) NULL,
  `system` int(11) NULL,
  `state` int(11) NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_user`
--
CREATE TABLE `sys_user` (
  `objid` varchar(50) NOT NULL,
  `username` varchar(50) NULL,
  `firstname` varchar(50) NULL,
  `lastname` varchar(50) NULL,
  `middlename` varchar(50) NULL,
  `name` varchar(150) NULL,
  `jobtitle` varchar(50) NULL,
  `txncode` varchar(10) NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_username` (`username`),
  KEY `ix_lastname_firstname` (`lastname`,`firstname`),
  KEY `ix_firstname` (`firstname`),
  KEY `ix_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `sys_user_role`
--
CREATE TABLE `sys_user_role` (
  `objid` varchar(50) NOT NULL,
  `role` varchar(50) NULL,
  `userid` varchar(50) NOT NULL,
  `username` varchar(50) NULL,
  `org_objid` varchar(50) NULL,
  `org_name` varchar(50) NULL,
  `securitygroup_objid` varchar(50) NULL,
  `exclude` varchar(255) NULL,
  `uid` varchar(150) NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_uid` (`uid`),
  UNIQUE KEY `uix_role_userid_org_objid` (`role`,`userid`,`org_objid`),
  KEY `ix_role` (`role`),
  KEY `ix_userid` (`userid`),
  KEY `ix_org_objid` (`org_objid`),
  KEY `ix_securitygroup_objid` (`securitygroup_objid`),
  CONSTRAINT `fk_sys_user_role_role` FOREIGN KEY (`role`) REFERENCES `sys_role` (`name`),
  CONSTRAINT `fk_sys_user_role_userid` FOREIGN KEY (`userid`) REFERENCES `sys_user` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_var`
--
CREATE TABLE `sys_var` (
  `name` varchar(50) NOT NULL,
  `value` longtext,
  `description` varchar(255) NULL,
  `datatype` varchar(15) NULL,
  `category` varchar(50) NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_wf`
--
CREATE TABLE `sys_wf` (
  `name` varchar(50) NOT NULL,
  `title` varchar(100) NULL,
  `domain` varchar(50) NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_wf_node`
--
CREATE TABLE `sys_wf_node` (
  `name` varchar(50) NOT NULL,
  `processname` varchar(50) NOT NULL DEFAULT '',
  `title` varchar(100) NULL,
  `nodetype` varchar(10) NULL,
  `idx` int(11) NULL,
  `salience` int(11) NULL,
  `domain` varchar(50) NULL,
  `role` varchar(255) NULL,
  `ui` text,
  `properties` text,
  `tracktime` int(11) NULL,
  PRIMARY KEY (`name`,`processname`),
  KEY `ix_name` (`name`),
  KEY `ix_processname` (`processname`),
  KEY `ix_role` (`role`),
  CONSTRAINT `fk_sys_wf_node_role` FOREIGN KEY (`role`) REFERENCES `sys_role` (`name`),
  CONSTRAINT `fk_syw_wf_node_processname` FOREIGN KEY (`processname`) REFERENCES `sys_wf` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `sys_wf_transition`
--
CREATE TABLE `sys_wf_transition` (
  `parentid` varchar(50) NOT NULL DEFAULT '',
  `processname` varchar(50) NOT NULL DEFAULT '',
  `action` varchar(50) NOT NULL,
  `to` varchar(50) NOT NULL,
  `idx` int(11) NULL,
  `eval` mediumtext,
  `properties` varchar(255) NULL,
  `permission` varchar(255) NULL,
  `caption` varchar(255) NULL,
  `ui` text,
  PRIMARY KEY (`action`,`parentid`,`processname`,`to`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_processname_parentid` (`processname`,`parentid`),
  CONSTRAINT `fk_sys_wf_transition_processname_parentid` FOREIGN KEY (`processname`, `parentid`) REFERENCES `sys_wf_node` (`processname`, `name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

set foreign_key_checks=1
;


--
-- Table structure for table `ticket`
--

set foreign_key_checks=0
;

alter table `ticket` 
  add `routeid` varchar(50) CHARACTER SET utf8 NULL,
  add `traveldate` date NULL,

  add KEY `ix_dtused` (`dtused`),
  add KEY `ix_routeid` (`routeid`),
  add KEY `ix_traveldate` (`traveldate`)
; 
alter table `ticket` 
  add CONSTRAINT `fk_ticket_routeid` 
  FOREIGN KEY (`routeid`) REFERENCES `route` (`objid`)
;

--
-- Table structure for table `ticket_void`
--

ALTER TABLE `ticket_void`
  ADD UNIQUE KEY `uix_ticketid` (`ticketid`),
  ADD KEY `ix_ticketid` (`ticketid`),
  ADD KEY `ix_txndate` (`txndate`),
  ADD KEY `ix_postedby_objid` (`postedby_objid`),
  ADD KEY `ix_postedby_name` (`postedby_name`)
; 
ALTER TABLE `ticket_void` 
  ADD CONSTRAINT `fk_ticket_void_ticketid` 
  FOREIGN KEY (`ticketid`) REFERENCES `ticket` (`objid`)
;

set foreign_key_checks=1
;


--
-- Table structure for table `ticketing_itemaccount`
--
CREATE TABLE `ticketing_itemaccount` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(50) NOT NULL,
  `item_objid` varchar(50) NULL,
  `item_code` varchar(50) NULL,
  `item_title` varchar(255) NULL,
  `item_fund_objid` varchar(50) NULL,
  `item_fund_title` varchar(100) NULL,
  `sortorder` int(11) NOT NULL DEFAULT '0',
  `itemtype` varchar(50) NULL,
  `tag` varchar(50) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_title` (`title`),
  KEY `ix_item_objid` (`item_objid`),
  KEY `ix_item_title` (`item_title`),
  KEY `ix_item_fund_objid` (`item_fund_objid`),
  KEY `ix_item_fund_title` (`item_fund_title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `turnstile`
--

ALTER TABLE `turnstile`
  ADD KEY `ix_title` (`title`),
  ADD KEY `ix_createdby_name` (`createdby_name`)
;

--
-- Table structure for table `turnstile_category`
--

ALTER TABLE `turnstile_category`
  ADD KEY `ix_title` (`title`)
;

--
-- Table structure for table `turnstile_item`
--

ALTER TABLE `turnstile_item`
  ADD KEY `ix_categoryid` (`categoryid`) 
;

--
-- Table structure for table `txnlog`
--
CREATE TABLE `txnlog` (
  `objid` varchar(50) NOT NULL,
  `ref` varchar(100) NOT NULL,
  `refid` longtext NOT NULL,
  `txndate` datetime NOT NULL,
  `action` varchar(50) NOT NULL,
  `userid` varchar(50) NOT NULL,
  `remarks` longtext,
  `diff` longtext,
  `username` varchar(150) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_action` (`action`),
  KEY `ix_ref` (`ref`),
  KEY `ix_userid` (`userid`),
  KEY `ix_userid_action` (`userid`,`action`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE VIEW `vw_ticket` AS 
select `t`.`objid` AS `objid`,`t`.`seqno` AS `seqno`,`t`.`barcode` AS `barcode`,`t`.`dtfiled` AS `dtfiled`,`t`.`dtused` AS `dtused`,`t`.`guesttype` AS `guesttype`,`t`.`refid` AS `refid`,`t`.`reftype` AS `reftype`,`t`.`tag` AS `tag`,`t`.`tokenid` AS `tokenid`,`t`.`refno` AS `refno`,`t`.`routeid` AS `routeid`,`r`.`objid` AS `route_objid`,`r`.`name` AS `route_name`,`r`.`sortorder` AS `route_sortorder`,`o`.`objid` AS `route_origin_objid`,`o`.`name` AS `route_origin_name`,`o`.`address` AS `route_origin_address`,(case when isnull(`v`.`objid`) then 0 else 1 end) AS `voided`,`v`.`objid` AS `void_objid`,`v`.`txndate` AS `void_txndate`,`v`.`reason` AS `void_reason` from (((`ticket` `t` left join `route` `r` on((`r`.`objid` = `t`.`routeid`))) left join `terminal` `o` on((`o`.`objid` = `r`.`originid`))) left join `ticket_void` `v` on((`v`.`ticketid` = `t`.`objid`)))
;

CREATE VIEW `vw_ticket_void` AS 
select `t`.`objid` AS `objid`,`t`.`seqno` AS `seqno`,`t`.`barcode` AS `barcode`,`t`.`dtfiled` AS `dtfiled`,`t`.`dtused` AS `dtused`,`t`.`guesttype` AS `guesttype`,`t`.`refid` AS `refid`,`t`.`reftype` AS `reftype`,`t`.`tag` AS `tag`,`t`.`tokenid` AS `tokenid`,`t`.`refno` AS `refno`,(case when isnull(`v`.`objid`) then 0 else 1 end) AS `voided`,`v`.`objid` AS `void_objid`,`v`.`txndate` AS `void_txndate`,`v`.`reason` AS `void_reason` from (`ticket_void` `v` join `ticket` `t` on((`t`.`objid` = `v`.`ticketid`)))
;



INSERT INTO ticketing_itemaccount (objid, title, item_objid, item_code, item_title, item_fund_objid, item_fund_title, sortorder, itemtype, tag) 
VALUES ('TERMINAL_FEE_-_RORO_TOURIST', 'TERMINAL FEE - RORO TOURIST', 'ITMACCT-79100522:160c3ce5dfc:-7e71', '623_CJPPT', 'AKLAN TERMINAL (RORO)', 'FUND-3afca170:1511de24dba:-7f9f', 'EEDD', '0', 'FEE', NULL);

INSERT INTO ticketing_itemaccount (objid, title, item_objid, item_code, item_title, item_fund_objid, item_fund_title, sortorder, itemtype, tag) 
VALUES ('TERMINAL_FEE_-_TOURIST', 'TERMINAL FEE - TOURIST', 'REVITEM-5e5a6bef:1493191e5fd:-7e10', '623_CJPPT', 'AKLAN TERMINAL (TOURIST)', 'FUND-3afca170:1511de24dba:-7f9f', 'EEDD', '0', 'FEE', NULL);


INSERT INTO `sys_ruleset` VALUES ('ticketingbilling','Ticketing Billing','ticketing','TICKETING','RULE_AUTHOR',NULL);
INSERT INTO `sys_rulegroup` VALUES ('compute-fee','ticketingbilling','Compute Fee',1),('initial','ticketingbilling','Initial',0),('map-accounts','ticketingbilling','Map Accounts',2);
INSERT INTO `sys_rule_fact` VALUES ('com.rameses.rules.common.CurrentDate','com.rameses.rules.common.CurrentDate','Current Date','com.rameses.rules.common.CurrentDate',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'SYSTEM',NULL),('ticketing.facts.TicketInfo','ticketing.facts.TicketInfo','Ticket Info','ticketing.facts.TicketInfo',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TICKETING',NULL),('treasury.facts.BillItem','treasury.facts.BillItem','Bill Item','treasury.facts.BillItem',1,NULL,'BILLITEM',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY','treasury.facts.AbstractBillItem'),('treasury.facts.CashReceipt','treasury.facts.CashReceipt','Cash Receipt','treasury.facts.CashReceipt',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL),('treasury.facts.CreditBillItem','treasury.facts.CreditBillItem','Credit Bill Item','treasury.facts.CreditBillItem',1,NULL,'CRBILL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY','treasury.facts.AbstractBillItem'),('treasury.facts.Deposit','treasury.facts.Deposit','Deposit','treasury.facts.Deposit',5,NULL,'PMT',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL),('treasury.facts.ExcessPayment','treasury.facts.ExcessPayment','Excess Payment','treasury.facts.ExcessPayment',5,NULL,'EXPMT',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL),('treasury.facts.HolidayFact','treasury.facts.HolidayFact','Holidays','treasury.facts.HolidayFact',1,NULL,'HOLIDAYS',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL),('treasury.facts.Payment','treasury.facts.Payment','Payment','treasury.facts.Payment',5,NULL,'PMT',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL),('treasury.facts.Requirement','treasury.facts.Requirement','Requirement','treasury.facts.Requirement',2,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL),('treasury.facts.TransactionDate','treasury.facts.TransactionDate','Transaction Date','treasury.facts.TransactionDate',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL),('treasury.facts.VarInteger','treasury.facts.VarInteger','Var Integer','treasury.facts.VarInteger',0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'TREASURY',NULL);
INSERT INTO `sys_rule_fact_field` VALUES ('com.rameses.rules.common.CurrentDate.date','com.rameses.rules.common.CurrentDate','date','Date','date',4,'date',NULL,NULL,NULL,NULL,NULL,NULL,'date',NULL),('com.rameses.rules.common.CurrentDate.day','com.rameses.rules.common.CurrentDate','day','Day','integer',5,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('com.rameses.rules.common.CurrentDate.month','com.rameses.rules.common.CurrentDate','month','Month','integer',3,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('com.rameses.rules.common.CurrentDate.qtr','com.rameses.rules.common.CurrentDate','qtr','Qtr','integer',1,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('com.rameses.rules.common.CurrentDate.year','com.rameses.rules.common.CurrentDate','year','Year','integer',2,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('ticketing.facts.TicketInfo.numadult','ticketing.facts.TicketInfo','numadult','No. of Adult','integer',1,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('ticketing.facts.TicketInfo.numchildren','ticketing.facts.TicketInfo','numchildren','No. of Children','integer',2,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('ticketing.facts.TicketInfo.numfil','ticketing.facts.TicketInfo','numfil','No. of Filipino','integer',4,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('ticketing.facts.TicketInfo.numnonfil','ticketing.facts.TicketInfo','numnonfil','No. of Non-filipinos','integer',5,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('ticketing.facts.TicketInfo.numsenior','ticketing.facts.TicketInfo','numsenior','No. of Senior','integer',3,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('ticketing.facts.TicketInfo.routeid','ticketing.facts.TicketInfo','routeid','Route','string',7,'lookup','ticketing_route:lookup','objid','name',NULL,NULL,NULL,'string',NULL),('ticketing.facts.TicketInfo.tag','ticketing.facts.TicketInfo','tag','Tag','string',6,'lookup','ticketing_turnstile_category:lookup','objid','title',NULL,NULL,NULL,'string',NULL),('treasury.facts.BillItem.amount','treasury.facts.BillItem','amount','Amount','decimal',3,'decimal',NULL,NULL,NULL,NULL,NULL,NULL,'decimal',NULL),('treasury.facts.BillItem.billcode','treasury.facts.BillItem','billcode','Bill code','string',2,'lookup','market_itemaccount:lookup','objid','title',NULL,NULL,NULL,'string',NULL),('treasury.facts.BillItem.objid','treasury.facts.BillItem','objid','ObjID','string',1,'string',NULL,NULL,NULL,NULL,NULL,NULL,'string',NULL),('treasury.facts.BillItem.surcharge','treasury.facts.BillItem','surcharge','Surcharge','decimal',4,'decimal',NULL,NULL,NULL,NULL,NULL,NULL,'decimal',NULL),('treasury.facts.BillItem.tag','treasury.facts.BillItem','tag','Tag','string',5,'string',NULL,NULL,NULL,NULL,NULL,NULL,'string',NULL),('treasury.facts.CashReceipt.receiptdate','treasury.facts.CashReceipt','receiptdate','Receipt Date','date',2,'date',NULL,NULL,NULL,NULL,NULL,NULL,'date',NULL),('treasury.facts.CashReceipt.txnmode','treasury.facts.CashReceipt','txnmode','Txn Mode','string',1,'string',NULL,NULL,NULL,NULL,NULL,NULL,'string',NULL),('treasury.facts.CreditBillItem.amount','treasury.facts.CreditBillItem','amount','Amount','decimal',1,'decimal',NULL,NULL,NULL,NULL,NULL,NULL,'decimal',NULL),('treasury.facts.CreditBillItem.billcode','treasury.facts.CreditBillItem','billcode','Bill code','string',2,'lookup','waterworks_itemaccount:lookup','objid','title',NULL,NULL,NULL,'string',NULL),('treasury.facts.Deposit.amount','treasury.facts.Deposit','amount','Amount','decimal',1,'decimal',NULL,NULL,NULL,NULL,NULL,NULL,'decimal',NULL),('treasury.facts.ExcessPayment.amount','treasury.facts.ExcessPayment','amount','Amount','decimal',1,'decimal',NULL,NULL,NULL,NULL,NULL,NULL,'decimal',NULL),('treasury.facts.HolidayFact.id','treasury.facts.HolidayFact','id','ID','string',1,'string',NULL,NULL,NULL,NULL,NULL,NULL,'string',NULL),('treasury.facts.Payment.amount','treasury.facts.Payment','amount','Amount','decimal',1,'decimal',NULL,NULL,NULL,NULL,NULL,NULL,'decimal',NULL),('treasury.facts.Requirement.code','treasury.facts.Requirement','code','Code','string',1,'lookup','requirementtype:lookup','code','title',NULL,NULL,NULL,'string',NULL),('treasury.facts.Requirement.completed','treasury.facts.Requirement','completed','Completed','boolean',2,'boolean',NULL,NULL,NULL,NULL,NULL,NULL,'boolean',NULL),('treasury.facts.TransactionDate.date','treasury.facts.TransactionDate','date','Date','date',1,'date',NULL,NULL,NULL,NULL,NULL,NULL,'date',NULL),('treasury.facts.TransactionDate.day','treasury.facts.TransactionDate','day','Day','integer',4,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('treasury.facts.TransactionDate.month','treasury.facts.TransactionDate','month','Month','integer',3,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('treasury.facts.TransactionDate.qtr','treasury.facts.TransactionDate','qtr','Qtr','integer',5,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('treasury.facts.TransactionDate.tag','treasury.facts.TransactionDate','tag','Tag','string',6,'string',NULL,NULL,NULL,NULL,NULL,NULL,'string',NULL),('treasury.facts.TransactionDate.year','treasury.facts.TransactionDate','year','Year','integer',2,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL),('treasury.facts.VarInteger.tag','treasury.facts.VarInteger','tag','Tag','string',2,'string',NULL,NULL,NULL,NULL,NULL,NULL,'string',NULL),('treasury.facts.VarInteger.value','treasury.facts.VarInteger','value','Value','integer',1,'integer',NULL,NULL,NULL,NULL,NULL,NULL,'integer',NULL);
INSERT INTO `sys_rule_actiondef` VALUES ('enterprise.actions.PrintTest','print-test','Print Test',1,'print-test','ENTERPRISE','enterprise.actions.PrintTest'),('enterprise.actions.ThrowException','throw-exeception','Throw Exception',1,'throw-exeception','ENTERPRISE','enterprise.actions.ThrowException'),('treasury.actions.AddBillItem','add-billitem','Add Bill Item',0,'add-billitem','TREASURY','treasury.actions.AddBillItem'),('treasury.actions.AddCreditBillItem','add-credit-billitem','Add Credit Bill Item',2,'add-credit-billitem','TREASURY','treasury.actions.AddCreditBillItem'),('treasury.actions.AddDiscountItem','add-discount-item','Add Discount',3,'add-discount-item','TREASURY','treasury.actions.AddDiscountItem'),('treasury.actions.AddExcessBillItem','add-excess-billitem','Add Excess Bill Item',2,'add-excess-billitem','TREASURY','treasury.actions.AddExcessBillItem'),('treasury.actions.AddInterestItem','add-interest-item','Add Interest',3,'add-interest-item','TREASURY','treasury.actions.AddInterestItem'),('treasury.actions.AddSurchargeItem','add-surcharge-item','Add Surcharge',3,'add-surcharge-item','TREASURY','treasury.actions.AddSurchargeItem'),('treasury.actions.AddVarInteger','add-var-integer','Add Var Integer',1,'add-var-integer','TREASURY','treasury.actions.AddVarInteger'),('treasury.actions.ApplyPayment','apply-payment','Apply Payment',5,'apply-payment','TREASURY','treasury.actions.ApplyPayment'),('treasury.actions.RemoveDiscountItem','remove-discount','Remove Discount',1,'remove-discount','TREASURY','treasury.actions.RemoveDiscountItem'),('treasury.actions.SetBillItemAccount','set-billitem-account','Set Bill Item Account',4,'set-billitem-account','TREASURY','treasury.actions.SetBillItemAccount'),('treasury.actions.SetBillItemProperty','set-billitem-property','Set BillItem Property Value',10,'set-billitem-property','TREASURY','treasury.actions.SetBillItemProperty'),('treasury.actions.UpdateBillItemAmount','update-billitem-amount','Update Billitem Amount',1,'update-billitem-amount','TREASURY','treasury.actions.UpdateBillItemAmount');

INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('enterprise.actions.PrintTest.message', 'enterprise.actions.PrintTest', 'message', '1', 'Message', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('enterprise.actions.ThrowException.msg', 'enterprise.actions.ThrowException', 'msg', '1', 'Message', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddBillItem.amount', 'treasury.actions.AddBillItem', 'amount', '1', 'Amount', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddBillItem.billcode', 'treasury.actions.AddBillItem', 'billcode', '2', 'Bill code', NULL, 'lookup', 'ticketing_itemaccount:lookup', 'objid', 'title', 'string', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddCreditBillItem.account', 'treasury.actions.AddCreditBillItem', 'account', '1', 'Account', NULL, 'lookup', 'revenueitem:lookup', 'objid', 'title', NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddCreditBillItem.amount', 'treasury.actions.AddCreditBillItem', 'amount', '2', 'Amount', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddCreditBillItem.billcode', 'treasury.actions.AddCreditBillItem', 'billcode', '1', 'Bill code', NULL, 'lookup', 'waterworks_itemaccount:lookup', 'objid', 'title', 'string', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddCreditBillItem.reftype', 'treasury.actions.AddCreditBillItem', 'reftype', '3', 'Ref Type', 'string', 'string', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddDiscountItem.account', 'treasury.actions.AddDiscountItem', 'account', '4', 'Account', NULL, 'lookup', 'revenueitem:lookup', 'objid', 'title', NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddDiscountItem.amount', 'treasury.actions.AddDiscountItem', 'amount', '2', 'Amount', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddDiscountItem.billcode', 'treasury.actions.AddDiscountItem', 'billcode', '3', 'Billcode', NULL, 'lookup', 'waterworks_itemaccount:lookup', 'objid', 'title', 'string', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddDiscountItem.billitem', 'treasury.actions.AddDiscountItem', 'billitem', '1', 'Bill Item', NULL, 'var', NULL, NULL, NULL, 'treasury.facts.AbstractBillItem', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddExcessBillItem.account', 'treasury.actions.AddExcessBillItem', 'account', '1', 'Account', NULL, 'lookup', 'revenueitem:lookup', 'objid', 'title', NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddExcessBillItem.amount', 'treasury.actions.AddExcessBillItem', 'amount', '2', 'Amount', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddInterestItem.amount', 'treasury.actions.AddInterestItem', 'amount', '2', 'Amount', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddInterestItem.billcode', 'treasury.actions.AddInterestItem', 'billcode', '3', 'Billcode', NULL, 'lookup', 'market_itemaccount:interest:lookup', 'objid', 'title', 'string', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddInterestItem.billitem', 'treasury.actions.AddInterestItem', 'billitem', '1', 'Bill Item', NULL, 'var', NULL, NULL, NULL, 'treasury.facts.AbstractBillItem', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddSurchargeItem.amount', 'treasury.actions.AddSurchargeItem', 'amount', '2', 'Amount', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddSurchargeItem.billcode', 'treasury.actions.AddSurchargeItem', 'billcode', '3', 'Bill code', NULL, 'lookup', 'market_itemaccount:surcharge:lookup', 'objid', 'title', 'string', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddSurchargeItem.billitem', 'treasury.actions.AddSurchargeItem', 'billitem', '1', 'Bill Item', NULL, 'var', NULL, NULL, NULL, 'treasury.facts.AbstractBillItem', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddSurchargeItem.txntype', 'treasury.actions.AddSurchargeItem', 'txntype', '4', 'Txn Type', NULL, 'lookup', 'billitem_txntype:lookup', 'objid', 'title', 'string', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddVarInteger.tag', 'treasury.actions.AddVarInteger', 'tag', '2', 'Tag', 'string', 'string', NULL, NULL, NULL, 'string', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddVarInteger.value', 'treasury.actions.AddVarInteger', 'value', '1', 'Value', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.ApplyPayment.payment', 'treasury.actions.ApplyPayment', 'payment', '1', 'Payment', NULL, 'var', NULL, NULL, NULL, 'treasury.facts.Payment', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.RemoveDiscountItem.billitem', 'treasury.actions.RemoveDiscountItem', 'billitem', '1', 'Bill Item', NULL, 'var', NULL, NULL, NULL, 'treasury.facts.AbstractBillItem', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.SetBillItemAccount.account', 'treasury.actions.SetBillItemAccount', 'account', '2', 'Account', NULL, 'lookup', 'revenueitem:lookup', 'objid', 'title', NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.SetBillItemAccount.billcode', 'treasury.actions.SetBillItemAccount', 'billcode', '3', 'Billcode', NULL, 'lookup', 'waterworks_itemaccount:lookup', 'objid', 'title', 'string', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.SetBillItemAccount.billitem', 'treasury.actions.SetBillItemAccount', 'billitem', '1', 'Bill Item', NULL, 'var', NULL, NULL, NULL, 'treasury.facts.AbstractBillItem', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.SetBillItemProperty.billitem', 'treasury.actions.SetBillItemProperty', 'billitem', '1', 'Bill Item', NULL, 'var', NULL, NULL, NULL, 'treasury.facts.AbstractBillItem', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.SetBillItemProperty.fieldname', 'treasury.actions.SetBillItemProperty', 'fieldname', '2', 'Property Field Name', NULL, 'fieldlist', NULL, 'billitem', NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.SetBillItemProperty.value', 'treasury.actions.SetBillItemProperty', 'value', '3', 'Value', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.UpdateBillItemAmount.amount', 'treasury.actions.UpdateBillItemAmount', 'amount', '3', 'Amount', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.UpdateBillItemAmount.billitem', 'treasury.actions.UpdateBillItemAmount', 'billitem', '1', 'BillItem', NULL, 'var', NULL, NULL, NULL, 'treasury.facts.AbstractBillItem', NULL);
INSERT INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.UpdateBillItemAmount.type', 'treasury.actions.UpdateBillItemAmount', 'type', '2', 'Type', NULL, 'lov', NULL, NULL, NULL, NULL, 'UPDATE_BILLITEM_TYPE');

INSERT INTO `sys_ruleset_fact` VALUES ('ticketingbilling','ticketing.facts.TicketInfo'),('ticketingbilling','treasury.facts.BillItem');
INSERT INTO `sys_ruleset_actiondef` VALUES ('ticketingbilling','enterprise.actions.ThrowException'),('ticketingbilling','treasury.actions.AddBillItem'),('ticketingbilling','treasury.actions.SetBillItemAccount'),('ticketingbilling','treasury.actions.UpdateBillItemAmount');


INSERT INTO sys_rule VALUES ('RUL4df1f298:17cf3a52b7d:-764c', 'DEPLOYED', 'TOURIST_FEE', 'ticketingbilling', 'compute-fee', 'TERMINAL FEE - TOURIST', null, '50000', null, null, '2021-11-06 14:50:03', 'USR-56431050:1497de4bc1b:-7fec', 'ADMIN', '1'), ('RUL4df1f298:17cf3a52b7d:-7698', 'DEPLOYED', 'RORO_TOURIST_FEE', 'ticketingbilling', 'compute-fee', 'TERMINAL FEE - RORO TOURIST', null, '50000', null, null, '2021-11-06 14:49:26', 'USR-56431050:1497de4bc1b:-7fec', 'ADMIN', '1');
INSERT INTO sys_rule_condition VALUES ('RC15f4ea66:17cf402583c:-7ff9', 'RUL4df1f298:17cf3a52b7d:-764c', 'ticketing.facts.TicketInfo', 'ticketing.facts.TicketInfo', null, '0', null, null, null, null, null, '0'), ('RC15f4ea66:17cf402583c:-8000', 'RUL4df1f298:17cf3a52b7d:-7698', 'ticketing.facts.TicketInfo', 'ticketing.facts.TicketInfo', null, '0', null, null, null, null, null, '0');
INSERT INTO sys_rule_condition_var VALUES ('RCC15f4ea66:17cf402583c:-7ff7', 'RC15f4ea66:17cf402583c:-7ff9', 'RUL4df1f298:17cf3a52b7d:-764c', 'NUM_ADULT', 'integer', '1'), ('RCC15f4ea66:17cf402583c:-7ffe', 'RC15f4ea66:17cf402583c:-8000', 'RUL4df1f298:17cf3a52b7d:-7698', 'NUM_ADULT', 'integer', '1');
INSERT INTO sys_rule_condition_constraint VALUES ('RCC15f4ea66:17cf402583c:-7ff6', 'RC15f4ea66:17cf402583c:-7ff9', 'ticketing.facts.TicketInfo.tag', 'tag', null, 'is any of the ff.', 'matches', null, null, null, null, null, null, '[[key:\"TOURIST\",value:\"TOURIST\"]]', null, '3'), ('RCC15f4ea66:17cf402583c:-7ff7', 'RC15f4ea66:17cf402583c:-7ff9', 'ticketing.facts.TicketInfo.numadult', 'numadult', 'NUM_ADULT', null, null, null, null, null, null, null, null, null, null, '1'), ('RCC15f4ea66:17cf402583c:-7ff8', 'RC15f4ea66:17cf402583c:-7ff9', 'ticketing.facts.TicketInfo.routeid', 'routeid', null, 'is any of the ff.', 'matches', null, null, null, null, null, null, '[[key:\"1\",value:\"CATICLAN JETTY PORT TERMINAL\"]]', null, '2'), ('RCC15f4ea66:17cf402583c:-7ffd', 'RC15f4ea66:17cf402583c:-8000', 'ticketing.facts.TicketInfo.routeid', 'routeid', null, 'is any of the ff.', 'matches', null, null, null, null, null, null, '[[key:\"RORO\",value:\"CJPPT-RORO\"]]', null, '2'), ('RCC15f4ea66:17cf402583c:-7ffe', 'RC15f4ea66:17cf402583c:-8000', 'ticketing.facts.TicketInfo.numadult', 'numadult', 'NUM_ADULT', null, null, null, null, null, null, null, null, null, null, '1'), ('RCC15f4ea66:17cf402583c:-7fff', 'RC15f4ea66:17cf402583c:-8000', 'ticketing.facts.TicketInfo.tag', 'tag', null, 'is any of the ff.', 'matches', null, null, null, null, null, null, '[[key:\"RORO_TOURIST\",value:\"RORO TOURIST\"]]', null, '3');
INSERT INTO sys_rule_action VALUES ('RA15f4ea66:17cf402583c:-7ff5', 'RUL4df1f298:17cf3a52b7d:-764c', 'treasury.actions.AddBillItem', 'add-billitem', '0'), ('RA15f4ea66:17cf402583c:-7ffc', 'RUL4df1f298:17cf3a52b7d:-7698', 'treasury.actions.AddBillItem', 'add-billitem', '0');
INSERT INTO sys_rule_action_param VALUES ('RAP15f4ea66:17cf402583c:-7ff3', 'RA15f4ea66:17cf402583c:-7ff5', 'treasury.actions.AddBillItem.billcode', null, null, null, null, null, null, null, 'TERMINAL_FEE_-_TOURIST', 'TERMINAL FEE - TOURIST', null, null, null), ('RAP15f4ea66:17cf402583c:-7ff4', 'RA15f4ea66:17cf402583c:-7ff5', 'treasury.actions.AddBillItem.amount', null, null, null, null, 'NUM_ADULT * 100', 'expression', null, null, null, null, null, null), ('RAP15f4ea66:17cf402583c:-7ffa', 'RA15f4ea66:17cf402583c:-7ffc', 'treasury.actions.AddBillItem.amount', null, null, null, null, 'NUM_ADULT * 50', 'expression', null, null, null, null, null, null), ('RAP15f4ea66:17cf402583c:-7ffb', 'RA15f4ea66:17cf402583c:-7ffc', 'treasury.actions.AddBillItem.billcode', null, null, null, null, null, null, null, 'TERMINAL_FEE_-_RORO_TOURIST', 'TERMINAL FEE - RORO TOURIST', null, null, null);
INSERT INTO sys_rule_deployed VALUES ('RUL4df1f298:17cf3a52b7d:-764c', '\npackage ticketingbilling.TOURIST_FEE;\nimport ticketingbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"TOURIST_FEE\"\n agenda-group \"compute-fee\"\n  salience 50000\n  no-loop\n when\n    \n    \n     ticketing.facts.TicketInfo (  NUM_ADULT:numadult,routeid matches \"1\",tag matches \"TOURIST\" ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"NUM_ADULT\", NUM_ADULT );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"amount\", (new ActionExpression(\"NUM_ADULT * 100\", bindings)) );\n_p0.put( \"billcode\", new KeyValue(\"TERMINAL_FEE_-_TOURIST\", \"TERMINAL FEE - TOURIST\") );\naction.execute( \"add-billitem\",_p0,drools);\n\nend\n\n\n '), ('RUL4df1f298:17cf3a52b7d:-7698', '\npackage ticketingbilling.RORO_TOURIST_FEE;\nimport ticketingbilling.*;\nimport java.util.*;\nimport com.rameses.rules.common.*;\n\nglobal RuleAction action;\n\nrule \"RORO_TOURIST_FEE\"\n  agenda-group \"compute-fee\"\n  salience 50000\n  no-loop\n when\n    \n    \n     ticketing.facts.TicketInfo (  NUM_ADULT:numadult,routeid matches \"RORO\",tag matches \"RORO_TOURIST\" ) \n    \n  then\n    Map bindings = new HashMap();\n   \n    bindings.put(\"NUM_ADULT\", NUM_ADULT );\n    \n  Map _p0 = new HashMap();\n_p0.put( \"amount\", (new ActionExpression(\"NUM_ADULT * 50\", bindings)) );\n_p0.put( \"billcode\", new KeyValue(\"TERMINAL_FEE_-_RORO_TOURIST\", \"TERMINAL FEE - RORO TOURIST\") );\naction.execute( \"add-billitem\",_p0,drools);\n\nend\n\n\n  ');


INSERT INTO `sys_user` VALUES ('USR-48c6872f:17b9f7070a0:-7e77','ADMIN','ADMIN','ADMIN','ADMIN','ADMIN, ADMIN ADMIN','ADMIN',NULL),('USR24c72011:17b9f749b0e:-7e78','JDC','JUAN','DELA CRUZ','M','DELA CRUZ, JUAN M','COLLECTOR','JDC');
INSERT INTO `sys_user_role` VALUES ('USRROL-44614eed:17ba4606b00:-7ff3','WF_EDITOR','USR24c72011:17b9f749b0e:-7e78','JDC','CAT','CATICLAN JETTY PORT TERMINAL',NULL,NULL,'USR24c72011:17b9f749b0e:-7e78-WF_EDITOR-CAT'),('USRROL-44614eed:17ba4606b00:-7ff4','SHARED','USR24c72011:17b9f749b0e:-7e78','JDC','CAT','CATICLAN JETTY PORT TERMINAL',NULL,NULL,'USR24c72011:17b9f749b0e:-7e78-SHARED-CAT'),('USRROL-44614eed:17ba4606b00:-7ff5','RULE_AUTHOR','USR24c72011:17b9f749b0e:-7e78','JDC','CAT','CATICLAN JETTY PORT TERMINAL',NULL,NULL,'USR24c72011:17b9f749b0e:-7e78-RULE_AUTHOR-CAT'),('USRROL-44614eed:17ba4606b00:-7ff6','REPORT','USR24c72011:17b9f749b0e:-7e78','JDC','CAT','CATICLAN JETTY PORT TERMINAL',NULL,NULL,'USR24c72011:17b9f749b0e:-7e78-REPORT-CAT'),('USRROL-44614eed:17ba4606b00:-7ff7','MASTER','USR24c72011:17b9f749b0e:-7e78','JDC','CAT','CATICLAN JETTY PORT TERMINAL',NULL,NULL,'USR24c72011:17b9f749b0e:-7e78-MASTER-CAT'),('USRROL-44614eed:17ba4606b00:-7ff8','COLLECTOR','USR24c72011:17b9f749b0e:-7e78','JDC','CAT','CATICLAN JETTY PORT TERMINAL',NULL,NULL,'USR24c72011:17b9f749b0e:-7e78-COLLECTOR-CAT'),('USRROL-44614eed:17ba4606b00:-7ff9','ADMIN','USR24c72011:17b9f749b0e:-7e78','JDC','CAT','CATICLAN JETTY PORT TERMINAL',NULL,NULL,'USR24c72011:17b9f749b0e:-7e78-ADMIN-CAT'),('USRROL-dbce2cf:17b9f8f6448:-7ffa','COLLECTOR','USR-48c6872f:17b9f7070a0:-7e77','ADMIN',NULL,NULL,NULL,NULL,'USR-48c6872f:17b9f7070a0:-7e77-COLLECTOR'),('USRROL-dbce2cf:17b9f8f6448:-7ffb','WF_EDITOR','USR-48c6872f:17b9f7070a0:-7e77','ADMIN',NULL,NULL,NULL,NULL,'USR-48c6872f:17b9f7070a0:-7e77-WF_EDITOR'),('USRROL-dbce2cf:17b9f8f6448:-7ffc','SHARED','USR-48c6872f:17b9f7070a0:-7e77','ADMIN',NULL,NULL,NULL,NULL,'USR-48c6872f:17b9f7070a0:-7e77-SHARED'),('USRROL-dbce2cf:17b9f8f6448:-7ffd','RULE_AUTHOR','USR-48c6872f:17b9f7070a0:-7e77','ADMIN',NULL,NULL,NULL,NULL,'USR-48c6872f:17b9f7070a0:-7e77-RULE_AUTHOR'),('USRROL-dbce2cf:17b9f8f6448:-7ffe','REPORT','USR-48c6872f:17b9f7070a0:-7e77','ADMIN',NULL,NULL,NULL,NULL,'USR-48c6872f:17b9f7070a0:-7e77-REPORT'),('USRROL-dbce2cf:17b9f8f6448:-7fff','MASTER','USR-48c6872f:17b9f7070a0:-7e77','ADMIN',NULL,NULL,NULL,NULL,'USR-48c6872f:17b9f7070a0:-7e77-MASTER'),('USRROL-dbce2cf:17b9f8f6448:-8000','ADMIN','USR-48c6872f:17b9f7070a0:-7e77','ADMIN',NULL,NULL,NULL,NULL,'USR-48c6872f:17b9f7070a0:-7e77-ADMIN');
INSERT INTO `sys_var` VALUES ('lgu_name','PROVINCIAL GOVT OF AKLAN',NULL,NULL,NULL),('thermal_printername','TSP100',NULL,NULL,NULL);

update turnstile set state = 'ACTIVE' where state = 'DRAFT';
