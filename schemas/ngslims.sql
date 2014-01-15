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
-- Current Database: `ngslims`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ngslims` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `ngslims`;

--
-- Table structure for table `flowcells`
--

DROP TABLE IF EXISTS `flowcells`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `flowcells` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `seq_runmode_type_id` int(11) DEFAULT NULL,
  `seq_runcycle_type_id` int(11) DEFAULT NULL,
  `run_number` int(11) DEFAULT NULL,
  `instrument_id` int(11) DEFAULT NULL,
  `side` char(1) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `notes` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_flowcells_instruments_idx` (`instrument_id`),
  KEY `fk_flowcells_seq_runcycle_types_idx` (`seq_runcycle_type_id`),
  KEY `fk_flowcells_seq_runmode_types_idx` (`seq_runmode_type_id`),
  CONSTRAINT `fk_flowcells_seq_runcycle_types` FOREIGN KEY (`seq_runcycle_type_id`) REFERENCES `seq_runcycle_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_flowcells_seq_runmode_types` FOREIGN KEY (`seq_runmode_type_id`) REFERENCES `seq_runmode_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_flowcells_instruments` FOREIGN KEY (`instrument_id`) REFERENCES `instrument` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flowcells`
--

LOCK TABLES `flowcells` WRITE;
/*!40000 ALTER TABLE `flowcells` DISABLE KEYS */;
/*!40000 ALTER TABLE `flowcells` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `instrument`
--

DROP TABLE IF EXISTS `instrument`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instrument` (
  `id` int(11) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `instrument_number` varchar(45) DEFAULT NULL,
  `nickname` varchar(45) DEFAULT NULL,
  `active` char(1) DEFAULT NULL,
  `instrument_type_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_instrument_instrument_types_idx` (`instrument_type_id`),
  CONSTRAINT `fk_instrument_instrument_types` FOREIGN KEY (`instrument_type_id`) REFERENCES `instrument_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instrument`
--

LOCK TABLES `instrument` WRITE;
/*!40000 ALTER TABLE `instrument` DISABLE KEYS */;
/*!40000 ALTER TABLE `instrument` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `instrument_type`
--

DROP TABLE IF EXISTS `instrument_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instrument_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `active` char(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instrument_type`
--

LOCK TABLES `instrument_type` WRITE;
/*!40000 ALTER TABLE `instrument_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `instrument_type` ENABLE KEYS */;
UNLOCK TABLES;

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
  `active` char(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `labs`
--

LOCK TABLES `labs` WRITE;
/*!40000 ALTER TABLE `labs` DISABLE KEYS */;
/*!40000 ALTER TABLE `labs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oligobarcode_scheme_allows`
--

DROP TABLE IF EXISTS `oligobarcode_scheme_allows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oligobarcode_scheme_allows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oligobarcode_scheme_id` int(11) NOT NULL,
  `seqlib_protocol_id` int(11) NOT NULL,
  `has_oligobarcodeB` char(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_oligobarcode_scheme_allows_oligobarcode_schemes_idx` (`oligobarcode_scheme_id`),
  KEY `fk_oligobarcode_scheme_allows_seqlib_protocols_idx` (`seqlib_protocol_id`),
  CONSTRAINT `fk_oligobarcode_scheme_allows_oligobarcode_schemes` FOREIGN KEY (`oligobarcode_scheme_id`) REFERENCES `oligobarcode_schemes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_oligobarcode_scheme_allows_seqlib_protocols` FOREIGN KEY (`seqlib_protocol_id`) REFERENCES `seqlib_protocols` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oligobarcode_scheme_allows`
--

LOCK TABLES `oligobarcode_scheme_allows` WRITE;
/*!40000 ALTER TABLE `oligobarcode_scheme_allows` DISABLE KEYS */;
/*!40000 ALTER TABLE `oligobarcode_scheme_allows` ENABLE KEYS */;
UNLOCK TABLES;

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
  `active` char(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oligobarcode_schemes`
--

LOCK TABLES `oligobarcode_schemes` WRITE;
/*!40000 ALTER TABLE `oligobarcode_schemes` DISABLE KEYS */;
/*!40000 ALTER TABLE `oligobarcode_schemes` ENABLE KEYS */;
UNLOCK TABLES;

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
  `active` char(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_oligobarcodes_oligobarcode_schemes_idx` (`oligobarcode_scheme_id`),
  CONSTRAINT `fk_oligobarcodes_oligobarcode_schemes` FOREIGN KEY (`oligobarcode_scheme_id`) REFERENCES `oligobarcode_schemes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=297 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oligobarcodes`
--

LOCK TABLES `oligobarcodes` WRITE;
/*!40000 ALTER TABLE `oligobarcodes` DISABLE KEYS */;
/*!40000 ALTER TABLE `oligobarcodes` ENABLE KEYS */;
UNLOCK TABLES;

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
  `active` char(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6201 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organisms`
--

LOCK TABLES `organisms` WRITE;
/*!40000 ALTER TABLE `organisms` DISABLE KEYS */;
/*!40000 ALTER TABLE `organisms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lab_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `user_id` int(11) NOT NULL,
  `create_at` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_projects_labs_idx` (`lab_id`),
  KEY `fk_projects_users_idx` (`user_id`),
  CONSTRAINT `fk_projects_labs` FOREIGN KEY (`lab_id`) REFERENCES `labs` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_projects_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;

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
  `create_at` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_requests_projects_idx` (`project_id`),
  KEY `fk_requests_labs_idx` (`lab_id`),
  KEY `fk_requests_users_idx` (`user_id`),
  CONSTRAINT `fk_requests_labs` FOREIGN KEY (`lab_id`) REFERENCES `labs` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_requests_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_requests_projects` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=264 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requests`
--

LOCK TABLES `requests` WRITE;
/*!40000 ALTER TABLE `requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `requests` ENABLE KEYS */;
UNLOCK TABLES;

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
  CONSTRAINT `fk_sample_property_entries_sampls` FOREIGN KEY (`sample_id`) REFERENCES `samples` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_sample_property_entries_sample_property_types` FOREIGN KEY (`sample_property_type_id`) REFERENCES `sample_property_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2048 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sample_property_entries`
--

LOCK TABLES `sample_property_entries` WRITE;
/*!40000 ALTER TABLE `sample_property_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `sample_property_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sample_property_types`
--

DROP TABLE IF EXISTS `sample_property_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample_property_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `mo_term_name` varchar(45) DEFAULT NULL,
  `mo_id` varchar(45) DEFAULT NULL,
  `active` char(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sample_property_types`
--

LOCK TABLES `sample_property_types` WRITE;
/*!40000 ALTER TABLE `sample_property_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `sample_property_types` ENABLE KEYS */;
UNLOCK TABLES;

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
  `active` char(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sample_types`
--

LOCK TABLES `sample_types` WRITE;
/*!40000 ALTER TABLE `sample_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `sample_types` ENABLE KEYS */;
UNLOCK TABLES;

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
  `qual_concentration` decimal(8,3) unsigned DEFAULT NULL,
  `qual_volume` decimal(8,3) unsigned DEFAULT NULL,
  `qual_amount` decimal(8,3) unsigned DEFAULT NULL,
  `qual_RIN` decimal(8,3) unsigned DEFAULT NULL,
  `qual_od260280` decimal(8,3) unsigned DEFAULT NULL,
  `qual_od260230` decimal(8,3) unsigned DEFAULT NULL,
  `qual_nanodrop_conc` decimal(8,3) unsigned DEFAULT NULL,
  `qual_fragment_size` int(11) unsigned DEFAULT NULL,
  `qual_date` datetime DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `samples_name_idx` (`name`),
  KEY `fk_samples_requests_idx` (`request_id`),
  KEY `fk_samples_projects_idx` (`project_id`),
  KEY `fk_samples_sample_types_idx` (`sample_type_id`),
  KEY `fk_samples_organisms_idx` (`organism_id`),
  CONSTRAINT `fk_samples_organisms` FOREIGN KEY (`organism_id`) REFERENCES `organisms` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_samples_requests` FOREIGN KEY (`request_id`) REFERENCES `requests` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_samples_sample_types` FOREIGN KEY (`sample_type_id`) REFERENCES `sample_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_samples_projects` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3606 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `samples`
--

LOCK TABLES `samples` WRITE;
/*!40000 ALTER TABLE `samples` DISABLE KEYS */;
/*!40000 ALTER TABLE `samples` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seq_runcycle_types`
--

DROP TABLE IF EXISTS `seq_runcycle_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seq_runcycle_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `sort_order` int(11) DEFAULT NULL,
  `active` char(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seq_runcycle_types`
--

LOCK TABLES `seq_runcycle_types` WRITE;
/*!40000 ALTER TABLE `seq_runcycle_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `seq_runcycle_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seq_runmode_types`
--

DROP TABLE IF EXISTS `seq_runmode_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seq_runmode_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `instrument_type_id` int(11) DEFAULT NULL,
  `active` char(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_seq_runmode_types_instrument_types_idx` (`instrument_type_id`),
  CONSTRAINT `fk_seq_runmode_types_instrument_types` FOREIGN KEY (`instrument_type_id`) REFERENCES `instrument_type` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seq_runmode_types`
--

LOCK TABLES `seq_runmode_types` WRITE;
/*!40000 ALTER TABLE `seq_runmode_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `seq_runmode_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seqlanes`
--

DROP TABLE IF EXISTS `seqlanes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seqlanes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `number` int(11) DEFAULT NULL,
  `flowcell_id` int(11) DEFAULT NULL,
  `seqtemplate_id` int(11) DEFAULT NULL,
  `number_sequencing_cycles_actual` int(11) DEFAULT NULL,
  `filename` varchar(45) DEFAULT NULL,
  `first_cycle_date` datetime DEFAULT NULL,
  `last_cycle_date` datetime DEFAULT NULL,
  `last_cycle_completed` char(1) DEFAULT NULL,
  `last_cycle_failed` char(1) DEFAULT NULL,
  `apply_conc` decimal(8,2) DEFAULT NULL,
  `is_control` char(1) DEFAULT NULL,
  `q30_yield` decimal(4,1) DEFAULT NULL,
  `q30_percent` decimal(4,3) DEFAULT NULL,
  `read1_clusters_total` bigint(20) DEFAULT NULL,
  `read1_clusters_passed_filter` bigint(20) DEFAULT NULL,
  `read2_clusters_total` bigint(20) DEFAULT NULL,
  `read2_clusters_passed_filter` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_seqlanes_flowcells_idx` (`flowcell_id`),
  KEY `fk_seqlanes_seqtemplates_idx` (`seqtemplate_id`),
  CONSTRAINT `fk_seqlanes_flowcells` FOREIGN KEY (`flowcell_id`) REFERENCES `flowcells` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_seqlanes_seqtemplates` FOREIGN KEY (`seqtemplate_id`) REFERENCES `seqtemplates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seqlanes`
--

LOCK TABLES `seqlanes` WRITE;
/*!40000 ALTER TABLE `seqlanes` DISABLE KEYS */;
/*!40000 ALTER TABLE `seqlanes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seqlib_protocols`
--

DROP TABLE IF EXISTS `seqlib_protocols`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seqlib_protocols` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  `active` char(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seqlib_protocols`
--

LOCK TABLES `seqlib_protocols` WRITE;
/*!40000 ALTER TABLE `seqlib_protocols` DISABLE KEYS */;
/*!40000 ALTER TABLE `seqlib_protocols` ENABLE KEYS */;
UNLOCK TABLES;

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
  `request_id` int(11) NOT NULL,
  `seqlib_protocol_id` int(11) DEFAULT NULL,
  `oligobarcodeA_id` int(11) DEFAULT NULL,
  `oligobarcodeB_id` int(11) DEFAULT NULL,
  `bioanalyser_chip_code` varchar(45) DEFAULT NULL,
  `concentration` decimal(8,3) unsigned DEFAULT NULL,
  `stock_seqlib_volume` decimal(8,3) unsigned DEFAULT NULL,
  `fragment_size` int(11) unsigned DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `seqlibs_name_idx` (`name`),
  KEY `fk_seqlibs_oligobarcodeA_idx` (`oligobarcodeA_id`),
  KEY `fk_seqlibs_oligobarcodeB_idx` (`oligobarcodeB_id`),
  KEY `fk_seqlibs_samples_idx` (`sample_id`),
  KEY `fk_seqlibs_requests_idx` (`request_id`),
  KEY `fk_seqlibs_seqlib_protocols_idx` (`seqlib_protocol_id`),
  CONSTRAINT `fk_seqlibs_oligobarcodeA` FOREIGN KEY (`oligobarcodeA_id`) REFERENCES `oligobarcodes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_seqlibs_oligobarcodeB` FOREIGN KEY (`oligobarcodeB_id`) REFERENCES `oligobarcodes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_seqlibs_requests` FOREIGN KEY (`request_id`) REFERENCES `requests` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_seqlibs_samples` FOREIGN KEY (`sample_id`) REFERENCES `samples` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_seqlibs_seqlib_protocols` FOREIGN KEY (`seqlib_protocol_id`) REFERENCES `seqlib_protocols` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4096 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seqlibs`
--

LOCK TABLES `seqlibs` WRITE;
/*!40000 ALTER TABLE `seqlibs` DISABLE KEYS */;
/*!40000 ALTER TABLE `seqlibs` ENABLE KEYS */;
UNLOCK TABLES;

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
  `assoc_factor` decimal(8,4) unsigned DEFAULT NULL,
  `assoc_vol` decimal(8,3) unsigned DEFAULT NULL,
  `reads_total` bigint(20) DEFAULT NULL,
  `reads_passed_filter` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_seqtemplate_assocs_seqtemplate_idx` (`seqtemplate_id`),
  KEY `fk_seqtemplate_assocs_seqlib_idx` (`seqlib_id`),
  CONSTRAINT `fk_seqtemplate_assocs_seqtemplate` FOREIGN KEY (`seqlib_id`) REFERENCES `seqlibs` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_seqtemplate_assocs_seqlib` FOREIGN KEY (`seqtemplate_id`) REFERENCES `seqtemplates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8192 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seqtemplate_assocs`
--

LOCK TABLES `seqtemplate_assocs` WRITE;
/*!40000 ALTER TABLE `seqtemplate_assocs` DISABLE KEYS */;
/*!40000 ALTER TABLE `seqtemplate_assocs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seqtemplates`
--

DROP TABLE IF EXISTS `seqtemplates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seqtemplates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `init_conc` decimal(8,3) unsigned DEFAULT NULL,
  `init_vol` decimal(8,3) unsigned DEFAULT NULL,
  `target_conc` decimal(8,3) unsigned DEFAULT NULL,
  `target_dw_vol` decimal(8,3) unsigned DEFAULT NULL,
  `target_vol` decimal(8,3) unsigned DEFAULT NULL,
  `final_conc` decimal(8,3) unsigned DEFAULT NULL,
  `final_dw_vol` decimal(8,3) unsigned DEFAULT NULL,
  `final_vol` decimal(8,3) unsigned DEFAULT NULL,
  `create_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name_idx` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1024 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seqtemplates`
--

LOCK TABLES `seqtemplates` WRITE;
/*!40000 ALTER TABLE `seqtemplates` DISABLE KEYS */;
/*!40000 ALTER TABLE `seqtemplates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL,
  `password` char(40) NOT NULL,
  `name` varchar(120) NOT NULL,
  `email` varchar(70) NOT NULL,
  `created_at` datetime NOT NULL,
  `active` char(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-01-15 18:20:51
