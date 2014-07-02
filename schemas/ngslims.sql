-- MySQL dump 10.13  Distrib 5.5.28, for osx10.6 (i386)
--
-- Host: localhost    Database: ngslims
-- ------------------------------------------------------
-- Server version	5.5.28-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `controls`
--

DROP TABLE IF EXISTS `controls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `controls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `platform_code` varchar(100) NOT NULL,
  `active` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`),
  KEY `fk_controls_platforms_idx` (`platform_code`),
  CONSTRAINT `fk_controls_platforms` FOREIGN KEY (`platform_code`) REFERENCES `platforms` (`platform_code`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `flowcells`
--

DROP TABLE IF EXISTS `flowcells`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `flowcells` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `seq_runmode_type_id` int(11) DEFAULT NULL,
  `seq_run_type_scheme_id` int(11) DEFAULT NULL,
  `run_number` int(11) DEFAULT NULL,
  `instrument_id` int(11) DEFAULT NULL,
  `side` char(1) DEFAULT NULL,
  `dirname` varchar(200) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `notes` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_flowcells_instruments_idx` (`instrument_id`),
  KEY `fk_flowcells_seq_run_type_schemes_idx` (`seq_run_type_scheme_id`),
  KEY `fk_flowcells_seq_runmode_types_idx` (`seq_runmode_type_id`),
  CONSTRAINT `fk_flowcells_instruments` FOREIGN KEY (`instrument_id`) REFERENCES `instruments` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_flowcells_seq_runmode_types` FOREIGN KEY (`seq_runmode_type_id`) REFERENCES `seq_runmode_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_flowcells_seq_run_type_schemes` FOREIGN KEY (`seq_run_type_scheme_id`) REFERENCES `seq_run_type_schemes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `instrument_types`
--

DROP TABLE IF EXISTS `instrument_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instrument_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `platform_code` varchar(100) NOT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `active` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`),
  KEY `fk_instrument_types_platforms_idx` (`platform_code`),
  CONSTRAINT `fk_instrument_types_platforms` FOREIGN KEY (`platform_code`) REFERENCES `platforms` (`platform_code`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `instruments`
--

DROP TABLE IF EXISTS `instruments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instruments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `instrument_number` varchar(45) NOT NULL,
  `nickname` varchar(45) DEFAULT NULL,
  `instrument_type_id` int(11) NOT NULL,
  `active` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`),
  KEY `fk_instruments_instrument_types_idx` (`instrument_type_id`),
  CONSTRAINT `fk_instruments_instrument_types` FOREIGN KEY (`instrument_type_id`) REFERENCES `instrument_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lab_users`
--

DROP TABLE IF EXISTS `lab_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lab_users` (
  `lab_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`lab_id`,`user_id`),
  KEY `fk_lab_users_users_idx` (`user_id`),
  CONSTRAINT `fk_lab_users_labs` FOREIGN KEY (`lab_id`) REFERENCES `labs` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_lab_users_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `labs`
--

DROP TABLE IF EXISTS `labs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `labs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `department` varchar(255) DEFAULT NULL,
  `zipcode` varchar(45) DEFAULT NULL,
  `address1` varchar(255) DEFAULT NULL,
  `address2` varchar(255) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `fax` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `active` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oligobarcode_scheme_allows`
--

DROP TABLE IF EXISTS `oligobarcode_scheme_allows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oligobarcode_scheme_allows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oligobarcode_scheme_id` int(11) NOT NULL,
  `protocol_id` int(11) NOT NULL,
  `has_oligobarcodeB` char(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_oligobarcode_scheme_allows_oligobarcode_schemes_idx` (`oligobarcode_scheme_id`),
  KEY `fk_oligobarcode_scheme_allows_protocols_idx` (`protocol_id`),
  CONSTRAINT `fk_oligobarcode_scheme_allows_oligobarcode_schemes` FOREIGN KEY (`oligobarcode_scheme_id`) REFERENCES `oligobarcode_schemes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_oligobarcode_scheme_allows_protocols` FOREIGN KEY (`protocol_id`) REFERENCES `protocols` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oligobarcode_schemes`
--

DROP TABLE IF EXISTS `oligobarcode_schemes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oligobarcode_schemes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `is_oligobarcodeB` char(1) NOT NULL,
  `active` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oligobarcodes`
--

DROP TABLE IF EXISTS `oligobarcodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oligobarcodes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `barcode_seq` varchar(45) NOT NULL,
  `oligobarcode_scheme_id` int(11) NOT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `active` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`),
  KEY `fk_oligobarcodes_oligobarcode_schemes_idx` (`oligobarcode_scheme_id`),
  CONSTRAINT `fk_oligobarcodes_oligobarcode_schemes` FOREIGN KEY (`oligobarcode_scheme_id`) REFERENCES `oligobarcode_schemes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organisms`
--

DROP TABLE IF EXISTS `organisms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organisms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `taxonomy` varchar(200) DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `active` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `platforms`
--

DROP TABLE IF EXISTS `platforms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `platforms` (
  `platform_code` varchar(100) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `active` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`platform_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `project_types`
--

DROP TABLE IF EXISTS `project_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `create_at` datetime NOT NULL,
  `active` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `lab_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pi_user_id` int(11) NOT NULL,
  `project_type_id` int(11) NOT NULL DEFAULT '-1',
  `created_at` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_projects_labs_idx` (`lab_id`),
  KEY `fk_projects_users_idx` (`user_id`),
  KEY `fk_projects_project_types_idx` (`project_type_id`),
  CONSTRAINT `fk_projects_labs` FOREIGN KEY (`lab_id`) REFERENCES `labs` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_projects_project_types` FOREIGN KEY (`project_type_id`) REFERENCES `project_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_projects_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `protocols`
--

DROP TABLE IF EXISTS `protocols`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `protocols` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `step_id` int(11) NOT NULL,
  `min_multiplex_number` int(11) NOT NULL,
  `max_multiplex_number` int(11) NOT NULL,
  `next_step_phase_code` varchar(45) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `active` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`),
  UNIQUE KEY `protocols_name_UNIQUE` (`name`),
  KEY `fk_protocols_steps_idx` (`step_id`),
  KEY `fk_protocols_step_phases_idx` (`next_step_phase_code`),
  CONSTRAINT `fk_protocols_steps` FOREIGN KEY (`step_id`) REFERENCES `steps` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_protocols_step_phases` FOREIGN KEY (`next_step_phase_code`) REFERENCES `step_phases` (`step_phase_code`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `requests`
--

DROP TABLE IF EXISTS `requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `lab_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `seq_run_type_scheme_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_requests_projects_idx` (`project_id`),
  KEY `fk_requests_labs_idx` (`lab_id`),
  KEY `fk_requests_users_idx` (`user_id`),
  KEY `fk_requests_seq_run_type_schemes_idx` (`seq_run_type_scheme_id`),
  CONSTRAINT `fk_requests_labs` FOREIGN KEY (`lab_id`) REFERENCES `labs` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_requests_projects` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_requests_seq_run_type_schemes` FOREIGN KEY (`seq_run_type_scheme_id`) REFERENCES `seq_run_type_schemes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_requests_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_locations`
--

DROP TABLE IF EXISTS `sample_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `active` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_property_entries`
--

DROP TABLE IF EXISTS `sample_property_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample_property_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_property_type_id` int(11) NOT NULL,
  `sample_id` int(11) NOT NULL,
  `value` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_sample_property_entries_sample_property_types_idx` (`sample_property_type_id`),
  KEY `fk_sample_property_entries_sampls_idx` (`sample_id`),
  CONSTRAINT `fk_sample_property_entries_sample_property_types` FOREIGN KEY (`sample_property_type_id`) REFERENCES `sample_property_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_sample_property_entries_sampls` FOREIGN KEY (`sample_id`) REFERENCES `samples` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_property_types`
--

DROP TABLE IF EXISTS `sample_property_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample_property_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `mo_term_name` varchar(45) NOT NULL,
  `mo_id` varchar(45) DEFAULT NULL,
  `active` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`),
  UNIQUE KEY `mo_term_name_UNIQUE` (`mo_term_name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_types`
--

DROP TABLE IF EXISTS `sample_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `nucleotide_type` varchar(45) NOT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `active` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `samples`
--

DROP TABLE IF EXISTS `samples`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `samples` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `request_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `sample_type_id` int(11) NOT NULL,
  `organism_id` int(11) DEFAULT NULL,
  `qual_concentration` decimal(8,4) unsigned DEFAULT NULL,
  `qual_volume` decimal(8,3) unsigned DEFAULT NULL,
  `qual_amount` decimal(8,3) unsigned DEFAULT NULL,
  `qual_RIN` decimal(8,3) unsigned DEFAULT NULL,
  `qual_od260280` decimal(8,3) unsigned DEFAULT NULL,
  `qual_od260230` decimal(8,3) unsigned DEFAULT NULL,
  `qual_nanodrop_conc` decimal(8,4) unsigned DEFAULT NULL,
  `qual_fragment_size` int(11) unsigned DEFAULT NULL,
  `qual_date` datetime DEFAULT NULL,
  `notes` varchar(200) DEFAULT NULL,
  `barcode_number` int(10) DEFAULT NULL,
  `sample_location_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `samples_name_idx` (`name`),
  KEY `fk_samples_requests_idx` (`request_id`),
  KEY `fk_samples_projects_idx` (`project_id`),
  KEY `fk_samples_sample_types_idx` (`sample_type_id`),
  KEY `fk_samples_organisms_idx` (`organism_id`),
  KEY `fk_samples_sample_locations_idx` (`sample_location_id`),
  CONSTRAINT `fk_samples_organisms` FOREIGN KEY (`organism_id`) REFERENCES `organisms` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_samples_projects` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_samples_requests` FOREIGN KEY (`request_id`) REFERENCES `requests` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_samples_sample_locations` FOREIGN KEY (`sample_location_id`) REFERENCES `sample_locations` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_samples_sample_types` FOREIGN KEY (`sample_type_id`) REFERENCES `sample_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seq_demultiplex_results`
--

DROP TABLE IF EXISTS `seq_demultiplex_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seq_demultiplex_results` (
  `id` int(11) NOT NULL,
  `seqlib_id` int(11) DEFAULT NULL,
  `seqlane_id` int(11) DEFAULT NULL,
  `flowcell_id` int(11) DEFAULT NULL,
  `is_undetermined` char(1) DEFAULT NULL,
  `reads_total` bigint(20) DEFAULT NULL,
  `reads_passedfilter` bigint(20) DEFAULT NULL,
  `software_version` varchar(45) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_ seq_demultiplex_results_seqlibs_idx` (`seqlib_id`),
  KEY `fk_ seq_demultiplex_results_seqlanes_idx` (`seqlane_id`),
  KEY `fk_ seq_demultiplex_results_flowcells_idx` (`flowcell_id`),
  CONSTRAINT `fk_ seq_demultiplex_results_flowcells` FOREIGN KEY (`flowcell_id`) REFERENCES `flowcells` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ seq_demultiplex_results_seqlanes` FOREIGN KEY (`seqlane_id`) REFERENCES `seqlanes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ seq_demultiplex_results_seqlibs` FOREIGN KEY (`seqlib_id`) REFERENCES `seqlibs` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seq_run_type_schemes`
--

DROP TABLE IF EXISTS `seq_run_type_schemes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seq_run_type_schemes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `instrument_type_id` int(11) NOT NULL,
  `seq_runmode_type_id` int(11) NOT NULL,
  `seq_runread_type_id` int(11) NOT NULL,
  `seq_runcycle_type_id` int(11) NOT NULL,
  `active` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`,`instrument_type_id`,`seq_runmode_type_id`,`seq_runread_type_id`,`seq_runcycle_type_id`),
  KEY `seq_run_type_schemes_seq_runcycle_types_idx` (`seq_runcycle_type_id`),
  KEY `seq_run_type_schemes_seq_runmode_types_idx` (`seq_runmode_type_id`),
  KEY `seq_run_type_schemes_seq_runread_types_idx` (`seq_runread_type_id`),
  KEY `seq_run_type_schemes_instrument_types_idx` (`instrument_type_id`),
  CONSTRAINT `seq_run_type_schemes_instrument_types` FOREIGN KEY (`instrument_type_id`) REFERENCES `instrument_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `seq_run_type_schemes_seq_runcycle_types` FOREIGN KEY (`seq_runcycle_type_id`) REFERENCES `seq_runcycle_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `seq_run_type_schemes_seq_runmode_types` FOREIGN KEY (`seq_runmode_type_id`) REFERENCES `seq_runmode_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `seq_run_type_schemes_seq_runread_types` FOREIGN KEY (`seq_runread_type_id`) REFERENCES `seq_runread_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seq_runcycle_types`
--

DROP TABLE IF EXISTS `seq_runcycle_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seq_runcycle_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `active` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seq_runmode_types`
--

DROP TABLE IF EXISTS `seq_runmode_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seq_runmode_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `lane_per_flowcell` int(11) NOT NULL,
  `sort_order` varchar(45) DEFAULT NULL,
  `active` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seq_runread_types`
--

DROP TABLE IF EXISTS `seq_runread_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seq_runread_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `active` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seqlanes`
--

DROP TABLE IF EXISTS `seqlanes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seqlanes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `number` int(11) NOT NULL,
  `flowcell_id` int(11) NOT NULL,
  `seqtemplate_id` int(11) DEFAULT NULL,
  `number_sequencing_cycles_actual` int(11) DEFAULT NULL,
  `filename` varchar(45) DEFAULT NULL,
  `first_cycle_date` datetime DEFAULT NULL,
  `last_cycle_date` datetime DEFAULT NULL,
  `last_cycle_completed` char(1) DEFAULT NULL,
  `last_cycle_failed` char(1) DEFAULT NULL,
  `apply_conc` decimal(8,2) DEFAULT NULL,
  `is_control` char(1) DEFAULT NULL,
  `control_id` int(11) DEFAULT NULL,
  `reads_total` bigint(20) DEFAULT NULL,
  `reads_passed_filter` bigint(20) DEFAULT NULL,
  `q30_percent` decimal(4,3) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_seqlanes_flowcells_idx` (`flowcell_id`),
  KEY `fk_seqlanes_seqtemplates_idx` (`seqtemplate_id`),
  KEY `fk_seqlanes_controls_idx` (`control_id`),
  CONSTRAINT `fk_seqlanes_controls_idx` FOREIGN KEY (`control_id`) REFERENCES `controls` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_seqlanes_flowcells` FOREIGN KEY (`flowcell_id`) REFERENCES `flowcells` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_seqlanes_seqtemplates` FOREIGN KEY (`seqtemplate_id`) REFERENCES `seqtemplates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seqlibs`
--

DROP TABLE IF EXISTS `seqlibs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seqlibs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `sample_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `protocol_id` int(11) DEFAULT NULL,
  `oligobarcodeA_id` int(11) DEFAULT NULL,
  `oligobarcodeB_id` int(11) DEFAULT NULL,
  `bioanalyser_chip_code` varchar(45) DEFAULT NULL,
  `concentration` decimal(8,4) unsigned DEFAULT NULL,
  `stock_seqlib_volume` decimal(8,3) unsigned DEFAULT NULL,
  `fragment_size` int(11) unsigned DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `seqlibs_name_idx` (`name`),
  KEY `fk_seqlibs_oligobarcodeA_idx` (`oligobarcodeA_id`),
  KEY `fk_seqlibs_oligobarcodeB_idx` (`oligobarcodeB_id`),
  KEY `fk_seqlibs_samples_idx` (`sample_id`),
  KEY `fk_seqlibs_projects_idx` (`project_id`),
  KEY `fk_seqlibs_protocols_idx` (`protocol_id`),
  CONSTRAINT `fk_seqlibs_oligobarcodeA` FOREIGN KEY (`oligobarcodeA_id`) REFERENCES `oligobarcodes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_seqlibs_oligobarcodeB` FOREIGN KEY (`oligobarcodeB_id`) REFERENCES `oligobarcodes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_seqlibs_projects` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_seqlibs_protocols` FOREIGN KEY (`protocol_id`) REFERENCES `protocols` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_seqlibs_samples` FOREIGN KEY (`sample_id`) REFERENCES `samples` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seqtemplate_assocs`
--

DROP TABLE IF EXISTS `seqtemplate_assocs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seqtemplate_assocs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `seqtemplate_id` int(11) NOT NULL,
  `seqlib_id` int(11) NOT NULL,
  `conc_factor` decimal(8,4) unsigned DEFAULT '1.0000',
  `input_vol` decimal(8,3) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_seqtemplate_assocs_seqtemplates_idx` (`seqtemplate_id`),
  KEY `fk_seqtemplate_assocs_seqlibs_idx` (`seqlib_id`),
  CONSTRAINT `fk_seqtemplate_assocs_seqlibs` FOREIGN KEY (`seqtemplate_id`) REFERENCES `seqtemplates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_seqtemplate_assocs_seqtemplates` FOREIGN KEY (`seqlib_id`) REFERENCES `seqlibs` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `seqtemplates`
--

DROP TABLE IF EXISTS `seqtemplates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seqtemplates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `target_conc` decimal(8,4) unsigned DEFAULT NULL,
  `target_vol` decimal(8,3) unsigned DEFAULT NULL,
  `target_dw_vol` decimal(8,3) unsigned DEFAULT NULL,
  `initial_conc` decimal(8,4) unsigned DEFAULT NULL,
  `initial_vol` decimal(8,3) unsigned DEFAULT NULL,
  `final_conc` decimal(8,4) unsigned DEFAULT NULL,
  `final_vol` decimal(8,3) unsigned DEFAULT NULL,
  `final_dw_vol` decimal(8,3) unsigned DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `name_idx` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `step_entries`
--

DROP TABLE IF EXISTS `step_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `step_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_id` int(11) DEFAULT NULL,
  `seqlib_id` int(11) DEFAULT NULL,
  `seqtemplate_id` int(11) DEFAULT NULL,
  `flowcell_id` int(11) DEFAULT NULL,
  `step_phase_code` varchar(10) NOT NULL,
  `step_id` int(11) NOT NULL,
  `protocol_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `note` varchar(200) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_step_entries_samples_idx` (`sample_id`),
  KEY `fk_step_entries_seqlibs_idx` (`seqlib_id`),
  KEY `fk_step_entries_seqtemplates_idx` (`seqtemplate_id`),
  KEY `fk_step_entries_flowcells_idx` (`flowcell_id`),
  KEY `fk_step_entries_steps_idx` (`step_id`),
  CONSTRAINT `fk_step_entries_flowcells` FOREIGN KEY (`flowcell_id`) REFERENCES `flowcells` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_step_entries_samples` FOREIGN KEY (`sample_id`) REFERENCES `samples` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_step_entries_seqlibs` FOREIGN KEY (`seqlib_id`) REFERENCES `seqlibs` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_step_entries_seqtemplates` FOREIGN KEY (`seqtemplate_id`) REFERENCES `seqtemplates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_step_entries_steps` FOREIGN KEY (`step_id`) REFERENCES `steps` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `step_instrument_type_schemes`
--

DROP TABLE IF EXISTS `step_instrument_type_schemes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `step_instrument_type_schemes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `step_id` int(11) NOT NULL,
  `instrument_type_id` int(11) NOT NULL,
  PRIMARY KEY (`id`,`step_id`,`instrument_type_id`),
  KEY `fk_ step_instrument_type_schemes_steps_idx` (`step_id`),
  KEY `fk_ step_instrument_type_schemes_instrument_types_idx` (`instrument_type_id`),
  CONSTRAINT `fk_ step_instrument_type_schemes_instrument_types` FOREIGN KEY (`instrument_type_id`) REFERENCES `instrument_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ step_instrument_type_schemes_steps` FOREIGN KEY (`step_id`) REFERENCES `steps` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `step_phases`
--

DROP TABLE IF EXISTS `step_phases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `step_phases` (
  `step_phase_code` varchar(20) NOT NULL,
  `description` varchar(100) NOT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `active` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`step_phase_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `steps`
--

DROP TABLE IF EXISTS `steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `steps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `step_phase_code` varchar(20) NOT NULL,
  `seq_runmode_type_id` int(11) DEFAULT NULL,
  `platform_code` varchar(100) NOT NULL,
  `nucleotide_type` varchar(45) DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `active` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`),
  KEY `fk_steps_step_phases_idx` (`step_phase_code`),
  KEY `fk_steps_platforms_idx` (`platform_code`),
  KEY `fk_steps_seq_runmode_types_idx` (`seq_runmode_type_id`),
  CONSTRAINT `fk_steps_platforms` FOREIGN KEY (`platform_code`) REFERENCES `platforms` (`platform_code`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_steps_seq_runmode_types` FOREIGN KEY (`seq_runmode_type_id`) REFERENCES `seq_runmode_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_steps_step_phases` FOREIGN KEY (`step_phase_code`) REFERENCES `step_phases` (`step_phase_code`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL,
  `password` char(200) NOT NULL,
  `firstname` varchar(120) NOT NULL,
  `lastname` varchar(45) NOT NULL,
  `email` varchar(70) NOT NULL,
  `created_at` datetime NOT NULL,
  `active` char(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-07-02 15:11:00
