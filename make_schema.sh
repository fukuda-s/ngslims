#!/bin/sh

 mysqldump --no-data ngslims | perl -ne 's/AUTO_INCREMENT=\d+/AUTO_INCREMENT=1/;print' >| schemas/ngslims.sql 

cat << EOS >> schemas/ngslims.sql
INSERT INTO labs VALUES (1,'Genome Science',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y');

INSERT INTO platforms VALUES ('DNAQC','Quality Control for DNA','Y'),('ILLUMINANGS','Illumina NGS (HiSeq/MiSeq/GAIIx) Platform','Y'),('RNAQC','Quality Control for RNA','Y');
INSERT INTO instrument_types VALUES (1,'GAIIx','ILLUMINANGS',3,'1','{\"1\":\"1\"}','Y'),(2,'HiSeq2000','ILLUMINANGS',2,'2','{\"1\":\"A\", \"2\":\"B\"}','Y'),(3,'HiSeq2500','ILLUMINANGS',1,'2','{\"1\":\"A\", \"2\":\"B\"}','Y'),(4,'MiSeq','ILLUMINANGS',4,'1','{\"1\":\"1\"}','Y');
INSERT INTO instruments VALUES (1,'SN1095','HS2','Frog',3,'Y');

INSERT INTO seq_runmode_types VALUES (1,'High Output','ILLUMINANGS',8,'1','Y'),(2,'Rapid','ILLUMINANGS',2,'2','Y');
INSERT INTO seq_runread_types VALUES (1,'Single-Read',1,'Y'),(2,'Paired-End',2,'Y');
INSERT INTO seq_runcycle_types VALUES (1,'18',1,'Y'),(2,'25',2,'Y'),(3,'35',3,'Y'),(4,'50',4,'Y'),(5,'75',5,'Y'),(6,'100',6,'Y'),(7,'150',7,'Y'),(8,'125',8,'N');
INSERT INTO seq_run_type_schemes VALUES (1,1,1,1,3,'N'),(3,1,1,1,5,'N'),(5,1,1,1,7,'N'),(8,2,1,1,7,'N'),(10,3,1,1,5,'N'),(12,3,1,1,7,'N'),(19,1,1,2,3,'N'),(21,1,1,2,5,'N'),(23,1,1,2,7,'N'),(26,2,1,2,7,'N'),(28,3,1,2,5,'N'),(30,3,1,2,7,'N'),(37,3,2,1,5,'N'),(38,3,2,2,5,'N'),(39,3,1,2,8,'N'),(2,1,1,1,4,'Y'),(4,1,1,1,6,'Y'),(6,2,1,1,4,'Y'),(7,2,1,1,6,'Y'),(9,3,1,1,4,'Y'),(11,3,1,1,6,'Y'),(13,3,2,1,4,'Y'),(14,3,2,1,6,'Y'),(15,3,2,1,7,'Y'),(16,4,1,1,4,'Y'),(17,4,1,1,6,'Y'),(18,4,1,1,7,'Y'),(20,1,1,2,4,'Y'),(22,1,1,2,6,'Y'),(24,2,1,2,4,'Y'),(25,2,1,2,6,'Y'),(27,3,1,2,4,'Y'),(29,3,1,2,6,'Y'),(31,3,2,2,4,'Y'),(32,3,2,2,6,'Y'),(33,3,2,2,7,'Y'),(34,4,1,2,4,'Y'),(35,4,1,2,6,'Y'),(36,4,1,2,7,'Y');


INSERT INTO step_phases VALUES ('DUALMULTIPLEX','Dual Multiplexing',3,'Y'),('FLOWCELL','Flowcell Setup',4,'Y'),('MULTIPLEX','Single Multiplexing',2,'Y'),('PIPELINE','Pipeline',6,'Y'),('PREP','Seqlib',1,'Y'),('QC','QC',0,'Y'),('RUN','Sequening Setup',5,'Y');
INSERT INTO steps VALUES (1,'DNA Initial QC','DNA_QC','QC',NULL,'DNAQC','DNA',0,'Y'),(2,'RNA Initial QC','RNA_QC','QC',NULL,'RNAQC','RNA',1,'Y'),(3,'Illuimina Library Preparation for Exome-Seq','Exome-Seq','PREP',NULL,'ILLUMINANGS','DNA',2,'Y'),(4,'Illuimina Library Preparation for RNA-Seq','RNA-Seq','PREP',NULL,'ILLUMINANGS','RNA',3,'Y'),(5,'Illuimina Library Preparation for ChIP-Seq','ChIP-Seq','PREP',NULL,'ILLUMINANGS','DNA',4,'Y'),(6,'Illuimina Library Preparation for DNA-Seq','DNA-Seq','PREP',NULL,'ILLUMINANGS','DNA',5,'Y'),(8,'Illumina Library Multiplex with Single Index',NULL,'MULTIPLEX',NULL,'ILLUMINANGS',NULL,0,'Y'),(9,'Illumina Library Multiplex with Dual Index',NULL,'DUALMULTIPLEX',NULL,'ILLUMINANGS',NULL,1,'Y'),(10,'Illumina HiSeq High Output Flowcell Setup',NULL,'FLOWCELL',1,'ILLUMINANGS',NULL,0,'Y'),(11,'Illumina HiSeq Rapid Flowcell Setup',NULL,'FLOWCELL',2,'ILLUMINANGS',NULL,1,'Y'),(12,'Illuimina Library Preparation for WGBS',NULL,'PREP',NULL,'ILLUMINANGS','DNA',6,'Y');

INSERT INTO oligobarcode_schemes VALUES (1,'GAIIx 4 sequence tag scheme','GAII 4 sequence tag scheme, allows for 2-4 samples per flowcell channel','N','N'),(2,'HiSeq 12 sequence tag scheme','HiSeq 12 sequence tag scheme, allows for 2-12 samples per flowcell channel','N','N'),(3,'HiSeq 48 sequence tag scheme','HiSeq 48 sequence tag scheme, allows for 2-24 samples per flowcell channel','N','Y'),(4,'TruSeq Custom Amplicon index A (i7) scheme','TruSeq Custom Amplicon index A (i7) scheme for illumina sequencer','N','Y'),(5,'TruSeq Custom Amplicon index B (i5) scheme','TruSeq Custom Amplicon index B (i5) scheme for illumina sequencer','Y','Y'),(6,'Nextera XT index A (i7) scheme','Nextera XT Index Kit index A (i7) scheme for illumina sequencer','N','Y'),(7,'Nextera XT index B (i5) scheme','Nextera XT Index Kit index B (i5) scheme for illumina sequencer','Y','Y'),(8,'HaloPlex Indexes','HaloPlex Indexes for illumina sequencer','N','Y'),(9,'SureSelect Indexes','SureSelect Indexes for illumina sequencer','N','Y'),(10,'Ovation SP Ultralow Library System scheme ','Ovation SP Ultralow Library System scheme ','N','Y'),(11,'Custom index scheme','Custom index scheme','N','Y'),(12,'HaloPlex HS index A (i7) scheme','HaloPlex HS Index A (i7) scheme for illumina sequencer','N','Y'),(13,'HaloPlex HS index B (i5) scheme','HaloPlex HS Index B (i5) scheme for illumina sequencer','Y','Y'),(14,'Nextera index A (i7) scheme','Nextera Index Kit index A (i7) scheme for illumina sequencer','N','Y'),(15,'Nextera index B (i5) scheme','Nextera Index Kit index B (i5) scheme for illumina sequencer','Y','Y'),(16,'10x index scheme','10x index scheme','N','Y'),(17,'Nextera XT index A (i7) 6bp scheme',NULL,'N','Y');
INSERT INTO oligobarcodes VALUES (1,'GAII Tag 1','AAT',1,1,'N'),(2,'GAII Tag 2','CCT',1,2,'N'),(3,'GAII Tag 3','GGT',1,3,'N'),(4,'GAII Tag 4','TTT',1,4,'N'),(5,'HiSeq Tag 1','CGTGAT',2,1,'N'),(6,'HiSeq Tag 2','ACATCG',2,2,'N'),(7,'HiSeq Tag 3','GCCTAA',2,3,'N'),(8,'HiSeq Tag 4','TGGTCA',2,4,'N'),(9,'HiSeq Tag 5','CACTGT',2,5,'N'),(10,'HiSeq Tag 6','ATTGGC',2,6,'N'),(11,'HiSeq Tag 7','GATCTG',2,7,'N'),(12,'HiSeq Tag 8','TCAAGT',2,8,'N'),(13,'HiSeq Tag 9','CTGATC',2,9,'N'),(14,'HiSeq Tag 10','AAGCTA',2,10,'N'),(15,'HiSeq Tag 11','GTAGCC',2,11,'N'),(16,'HiSeq Tag 12','TACAAG',2,12,'N'),(17,'AD001','ATCACG',3,1,'Y'),(18,'AD002','CGATGT',3,2,'Y'),(19,'AD003','TTAGGC',3,3,'Y'),(20,'AD004','TGACCA',3,4,'Y'),(21,'AD005','ACAGTG',3,5,'Y'),(22,'AD006','GCCAAT',3,6,'Y'),(23,'AD007','CAGATC',3,7,'Y'),(24,'AD008','ACTTGA',3,8,'Y'),(25,'AD009','GATCAG',3,9,'Y'),(26,'AD010','TAGCTT',3,10,'Y'),(27,'AD011','GGCTAC',3,11,'Y'),(28,'AD012','CTTGTA',3,12,'Y'),(29,'AD013','AGTCAA',3,13,'Y'),(30,'AD014','AGTTCC',3,14,'Y'),(31,'AD015','ATGTCA',3,15,'Y'),(32,'AD016','CCGTCC',3,16,'Y'),(33,'AD018','GTCCGC',3,17,'Y'),(34,'AD019','GTGAAA',3,18,'Y'),(35,'AD020','GTGGCC',3,19,'Y'),(36,'AD021','GTTTCG',3,20,'Y'),(37,'AD022','CGTACG',3,21,'Y'),(38,'AD023','GAGTGG',3,22,'Y'),(39,'AD025','ACTGAT',3,23,'Y'),(40,'AD027','ATTCCT',3,24,'Y'),(41,'AD030','CACCGG',3,25,'Y'),(42,'AD031','CACGAT',3,26,'Y'),(43,'AD046','TCCCGA',3,27,'Y'),(44,'AD017','GTAGAG',3,28,'Y'),(45,'AD029','CAACTA',3,29,'Y'),(46,'AD033','CAGGCG',3,30,'Y'),(47,'AD035','CATTTT',3,31,'Y'),(48,'AD037','CGGAAT',3,32,'Y'),(49,'AD039','CTATAC',3,33,'Y'),(50,'AD041','GACGAC',3,34,'Y'),(51,'AD043','TACAGC',3,35,'Y'),(52,'AD045','TCATTC',3,36,'Y'),(53,'AD047','TCGAAG',3,37,'Y'),(54,'AD024','GGTAGC',3,38,'Y'),(55,'AD026','ATGAGC',3,39,'Y'),(56,'AD028','CAAAAG',3,40,'Y'),(57,'AD032','CACTCA',3,41,'Y'),(58,'AD034','CATGGC',3,42,'Y'),(59,'AD036','CCAACA',3,43,'Y'),(60,'AD038','CTAGCT',3,44,'Y'),(61,'AD040','CTCAGA',3,45,'Y'),(62,'AD042','TAATCG',3,46,'Y'),(63,'AD044','TATAAT',3,47,'Y'),(64,'AD048','TCGGCA',3,48,'Y'),(65,'A701','ATCACGAC',4,1,'Y'),(66,'A702','ACAGTGGT',4,2,'Y'),(67,'A703','CAGATCCA',4,3,'Y'),(68,'A704','ACAAACGG',4,4,'Y'),(69,'A705','ACCCAGCA',4,5,'Y'),(70,'A706','AACCCCTC',4,6,'Y'),(71,'A707','CCCAACCT',4,7,'Y'),(72,'A708','CACCACAC',4,8,'Y'),(73,'A709','GAAACCCA',4,9,'Y'),(74,'A710','TGTGACCA',4,10,'Y'),(75,'A711','AGGGTCAA',4,11,'Y'),(76,'A712','AGGAGTGG',4,12,'Y'),(77,'A501','TGAACCTT',5,1,'Y'),(78,'A502','TGCTAAGT',5,2,'Y'),(79,'A503','TGTTCTCT',5,3,'Y'),(80,'A504','TAAGACAC',5,4,'Y'),(81,'A505','CTAATCGA',5,5,'Y'),(82,'A506','CTAGAACA',5,6,'Y'),(83,'A507','TAAGTTCC',5,7,'Y'),(84,'A508','TAGACCTA',5,8,'Y'),(85,'N701','TAAGGCGA',6,1,'Y'),(86,'N702','CGTACTAG',6,2,'Y'),(87,'N703','AGGCAGAA',6,3,'Y'),(88,'N704','TCCTGAGC',6,4,'Y'),(89,'N705','GGACTCCT',6,5,'Y'),(90,'N706','TAGGCATG',6,6,'Y'),(91,'N707','CTCTCTAC',6,7,'Y'),(92,'N708','CAGAGAGG',6,8,'Y'),(93,'N709','GCTACGCT',6,9,'Y'),(94,'N710','CGAGGCTG',6,10,'Y'),(95,'N711','AAGAGGCA',6,11,'Y'),(96,'N712','GTAGAGGA',6,12,'Y'),(97,'S501','TAGATCGC',7,1,'Y'),(98,'S502','CTCTCTAT',7,2,'Y'),(99,'S503','TATCCTCT',7,3,'Y'),(100,'S504','AGAGTAGA',7,4,'Y'),(101,'S505','GTAAGGAG',7,5,'Y'),(102,'S506','ACTGCATA',7,6,'Y'),(103,'S507','AAGGAGTA',7,7,'Y'),(104,'S508','CTAAGCCT',7,8,'Y'),(105,'HaloPlex 1','AACGTGAT',8,1,'Y'),(106,'HaloPlex 2','AAACATCG',8,2,'Y'),(107,'HaloPlex 3','ATGCCTAA',8,3,'Y'),(108,'HaloPlex 4','AGTGGTCA',8,4,'Y'),(109,'HaloPlex 5','ACCACTGT',8,5,'Y'),(110,'HaloPlex 6','ACATTGGC',8,6,'Y'),(111,'HaloPlex 7','CAGATCTG',8,7,'Y'),(112,'HaloPlex 8','CATCAAGT',8,8,'Y'),(113,'HaloPlex 9','CGCTGATC',8,9,'Y'),(114,'HaloPlex 10','ACAAGCTA',8,10,'Y'),(115,'HaloPlex 11','CTGTAGCC',8,11,'Y'),(116,'HaloPlex 12','AGTACAAG',8,12,'Y'),(117,'HaloPlex 13','AACAACCA',8,13,'Y'),(118,'HaloPlex 14','AACCGAGA',8,14,'Y'),(119,'HaloPlex 15','AACGCTTA',8,15,'Y'),(120,'HaloPlex 16','AAGACGGA',8,16,'Y'),(121,'HaloPlex 17','AAGGTACA',8,17,'Y'),(122,'HaloPlex 18','ACACAGAA',8,18,'Y'),(123,'HaloPlex 19','ACAGCAGA',8,19,'Y'),(124,'HaloPlex 20','ACCTCCAA',8,20,'Y'),(125,'HaloPlex 21','ACGCTCGA',8,21,'Y'),(126,'HaloPlex 22','ACGTATCA',8,22,'Y'),(127,'HaloPlex 23','ACTATGCA',8,23,'Y'),(128,'HaloPlex 24','AGAGTCAA',8,24,'Y'),(129,'HaloPlex 25','AGATCGCA',8,25,'Y'),(130,'HaloPlex 26','AGCAGGAA',8,26,'Y'),(131,'HaloPlex 27','AGTCACTA',8,27,'Y'),(132,'HaloPlex 28','ATCCTGTA',8,28,'Y'),(133,'HaloPlex 29','ATTGAGGA',8,29,'Y'),(134,'HaloPlex 30','CAACCACA',8,30,'Y'),(135,'HaloPlex 31','CAAGACTA',8,31,'Y'),(136,'HaloPlex 32','CAATGGAA',8,32,'Y'),(137,'HaloPlex 33','CACTTCGA',8,33,'Y'),(138,'HaloPlex 34','CAGCGTTA',8,34,'Y'),(139,'HaloPlex 35','CATACCAA',8,35,'Y'),(140,'HaloPlex 36','CCAGTTCA',8,36,'Y'),(141,'HaloPlex 37','CCGAAGTA',8,37,'Y'),(142,'HaloPlex 38','CCGTGAGA',8,38,'Y'),(143,'HaloPlex 39','CCTCCTGA',8,39,'Y'),(144,'HaloPlex 40','CGAACTTA',8,40,'Y'),(145,'HaloPlex 41','CGACTGGA',8,41,'Y'),(146,'HaloPlex 42','CGCATACA',8,42,'Y'),(147,'HaloPlex 43','CTCAATGA',8,43,'Y'),(148,'HaloPlex 44','CTGAGCCA',8,44,'Y'),(149,'HaloPlex 45','CTGGCATA',8,45,'Y'),(150,'HaloPlex 46','GAATCTGA',8,46,'Y'),(151,'HaloPlex 47','GACTAGTA',8,47,'Y'),(152,'HaloPlex 48','GAGCTGAA',8,48,'Y'),(153,'HaloPlex 49','GATAGACA',8,49,'Y'),(154,'HaloPlex 50','GCCACATA',8,50,'Y'),(155,'HaloPlex 51','GCGAGTAA',8,51,'Y'),(156,'HaloPlex 52','GCTAACGA',8,52,'Y'),(157,'HaloPlex 53','GCTCGGTA',8,53,'Y'),(158,'HaloPlex 54','GGAGAACA',8,54,'Y'),(159,'HaloPlex 55','GGTGCGAA',8,55,'Y'),(160,'HaloPlex 56','GTACGCAA',8,56,'Y'),(161,'HaloPlex 57','GTCGTAGA',8,57,'Y'),(162,'HaloPlex 58','GTCTGTCA',8,58,'Y'),(163,'HaloPlex 59','GTGTTCTA',8,59,'Y'),(164,'HaloPlex 60','TAGGATGA',8,60,'Y'),(165,'HaloPlex 61','TATCAGCA',8,61,'Y'),(166,'HaloPlex 62','TCCGTCTA',8,62,'Y'),(167,'HaloPlex 63','TCTTCACA',8,63,'Y'),(168,'HaloPlex 64','TGAAGAGA',8,64,'Y'),(169,'HaloPlex 65','TGGAACAA',8,65,'Y'),(170,'HaloPlex 66','TGGCTTCA',8,66,'Y'),(171,'HaloPlex 67','TGGTGGTA',8,67,'Y'),(172,'HaloPlex 68','TTCACGCA',8,68,'Y'),(173,'HaloPlex 69','AACTCACC',8,69,'Y'),(174,'HaloPlex 70','AAGAGATC',8,70,'Y'),(175,'HaloPlex 71','AAGGACAC',8,71,'Y'),(176,'HaloPlex 72','AATCCGTC',8,72,'Y'),(177,'HaloPlex 73','AATGTTGC',8,73,'Y'),(178,'HaloPlex 74','ACACGACC',8,74,'Y'),(179,'HaloPlex 75','ACAGATTC',8,75,'Y'),(180,'HaloPlex 76','AGATGTAC',8,76,'Y'),(181,'HaloPlex 77','AGCACCTC',8,77,'Y'),(182,'HaloPlex 78','AGCCATGC',8,78,'Y'),(183,'HaloPlex 79','AGGCTAAC',8,79,'Y'),(184,'HaloPlex 80','ATAGCGAC',8,80,'Y'),(185,'HaloPlex 81','ATCATTCC',8,81,'Y'),(186,'HaloPlex 82','ATTGGCTC',8,82,'Y'),(187,'HaloPlex 83','CAAGGAGC',8,83,'Y'),(188,'HaloPlex 84','CACCTTAC',8,84,'Y'),(189,'HaloPlex 85','CCATCCTC',8,85,'Y'),(190,'HaloPlex 86','CCGACAAC',8,86,'Y'),(191,'HaloPlex 87','CCTAATCC',8,87,'Y'),(192,'HaloPlex 88','CCTCTATC',8,88,'Y'),(193,'HaloPlex 89','CGACACAC',8,89,'Y'),(194,'HaloPlex 90','CGGATTGC',8,90,'Y'),(195,'HaloPlex 91','CTAAGGTC',8,91,'Y'),(196,'HaloPlex 92','GAACAGGC',8,92,'Y'),(197,'HaloPlex 93','GACAGTGC',8,93,'Y'),(198,'HaloPlex 94','GAGTTAGC',8,94,'Y'),(199,'HaloPlex 95','GATGAATC',8,95,'Y'),(200,'HaloPlex 96','GCCAAGAC',8,96,'Y'),(201,'SureSelect 1','AACGTG',9,1,'Y'),(202,'SureSelect 2','AAACAT',9,2,'Y'),(203,'SureSelect 3','ATGCCT',9,3,'Y'),(204,'SureSelect 4','AGTGGT',9,4,'Y'),(205,'SureSelect 5','ACCACT',9,5,'Y'),(206,'SureSelect 6','ACATTG',9,6,'Y'),(207,'SureSelect 7','CAGATC',9,7,'Y'),(208,'SureSelect 8','CATCAA',9,8,'Y'),(209,'SureSelect 9','CGCTGA',9,9,'Y'),(210,'SureSelect 10','ACAAGC',9,10,'Y'),(211,'SureSelect 11','CTGTAG',9,11,'Y'),(212,'SureSelect 12','AGTACA',9,12,'Y'),(213,'SureSelect 13','AACAAC',9,13,'Y'),(214,'SureSelect 14','AACCGA',9,14,'Y'),(215,'SureSelect 15','AACGCT',9,15,'Y'),(216,'SureSelect 16','AAGACG',9,16,'Y'),(217,'SureSelect 17','AAGGTA',9,17,'Y'),(218,'SureSelect 18','ACACAG',9,18,'Y'),(219,'SureSelect 19','ACAGCA',9,19,'Y'),(220,'SureSelect 20','ACCTCC',9,20,'Y'),(221,'SureSelect 21','ACGCTC',9,21,'Y'),(222,'SureSelect 22','ACGTAT',9,22,'Y'),(223,'SureSelect 23','ACTATG',9,23,'Y'),(224,'SureSelect 24','AGAGTC',9,24,'Y'),(225,'SureSelect 25','AGATCG',9,25,'Y'),(226,'SureSelect 26','AGCAGG',9,26,'Y'),(227,'SureSelect 27','AGTCAC',9,27,'Y'),(228,'SureSelect 28','ATCCTG',9,28,'Y'),(229,'SureSelect 29','ATTGAG',9,29,'Y'),(230,'SureSelect 30','CAACCA',9,30,'Y'),(231,'SureSelect 31','CAAGAC',9,31,'Y'),(232,'SureSelect 32','CAATGG',9,32,'Y'),(233,'SureSelect 33','CACTTC',9,33,'Y'),(234,'SureSelect 34','CAGCGT',9,34,'Y'),(235,'SureSelect 35','CATACC',9,35,'Y'),(236,'SureSelect 36','CCAGTT',9,36,'Y'),(237,'SureSelect 37','CCGAAG',9,37,'Y'),(238,'SureSelect 38','CCGTGA',9,38,'Y'),(239,'SureSelect 39','CCTCCT',9,39,'Y'),(240,'SureSelect 40','CGAACT',9,40,'Y'),(241,'SureSelect 41','CGACTG',9,41,'Y'),(242,'SureSelect 42','CGCATA',9,42,'Y'),(243,'SureSelect 43','CTCAAT',9,43,'Y'),(244,'SureSelect 44','CTGAGC',9,44,'Y'),(245,'SureSelect 45','CTGGCA',9,45,'Y'),(246,'SureSelect 46','GAATCT',9,46,'Y'),(247,'SureSelect 47','GACTAG',9,47,'Y'),(248,'SureSelect 48','GAGCTG',9,48,'Y'),(249,'SureSelect 49','GATAGA',9,49,'Y'),(250,'SureSelect 50','GCCACA',9,50,'Y'),(251,'SureSelect 51','GCGAGT',9,51,'Y'),(252,'SureSelect 52','GCTAAC',9,52,'Y'),(253,'SureSelect 53','GCTCGG',9,53,'Y'),(254,'SureSelect 54','GGAGAA',9,54,'Y'),(255,'SureSelect 55','GGTGCG',9,55,'Y'),(256,'SureSelect 56','GTACGC',9,56,'Y'),(257,'SureSelect 57','GTCGTA',9,57,'Y'),(258,'SureSelect 58','GTCTGT',9,58,'Y'),(259,'SureSelect 59','GTGTTC',9,59,'Y'),(260,'SureSelect 60','TAGGAT',9,60,'Y'),(261,'SureSelect 61','TATCAG',9,61,'Y'),(262,'SureSelect 62','TCCGTC',9,62,'Y'),(263,'SureSelect 63','TCTTCA',9,63,'Y'),(264,'SureSelect 64','TGAAGA',9,64,'Y'),(265,'SureSelect 65','TGGAAC',9,65,'Y'),(266,'SureSelect 66','TGGCTT',9,66,'Y'),(267,'SureSelect 67','TGGTGG',9,67,'Y'),(268,'SureSelect 68','TTCACG',9,68,'Y'),(269,'SureSelect 69','AACTCA',9,69,'Y'),(270,'SureSelect 70','AAGAGA',9,70,'Y'),(271,'SureSelect 71','AAGGAC',9,71,'Y'),(272,'SureSelect 72','AATCCG',9,72,'Y'),(273,'SureSelect 73','AATGTT',9,73,'Y'),(274,'SureSelect 74','ACACGA',9,74,'Y'),(275,'SureSelect 75','ACAGAT',9,75,'Y'),(276,'SureSelect 76','AGATGT',9,76,'Y'),(277,'SureSelect 77','AGCACC',9,77,'Y'),(278,'SureSelect 78','AGCCAT',9,78,'Y'),(279,'SureSelect 79','AGGCTA',9,79,'Y'),(280,'SureSelect 80','ATAGCG',9,80,'Y'),(281,'SureSelect 81','ATCATT',9,81,'Y'),(282,'SureSelect 82','ATTGGC',9,82,'Y'),(283,'SureSelect 83','CAAGGA',9,83,'Y'),(284,'SureSelect 84','CACCTT',9,84,'Y'),(285,'SureSelect 85','CCATCC',9,85,'Y'),(286,'SureSelect 86','CCGACA',9,86,'Y'),(287,'SureSelect 87','CCTAAT',9,87,'Y'),(288,'SureSelect 88','CCTCTA',9,88,'Y'),(289,'SureSelect 89','CGACAC',9,89,'Y'),(290,'SureSelect 90','CGGATT',9,90,'Y'),(291,'SureSelect 91','CTAAGG',9,91,'Y'),(292,'SureSelect 92','GAACAG',9,92,'Y'),(293,'SureSelect 93','GACAGT',9,93,'Y'),(294,'SureSelect 94','GAGTTA',9,94,'Y'),(295,'SureSelect 95','GATGAA',9,95,'Y'),(296,'SureSelect 96','GCCAAG',9,96,'Y'),(297,'L2v9Dr-BC1 ','AAGGGA',10,1,'Y'),(298,'L2v9Dr-BC2 ','CCTTCA',10,2,'Y'),(299,'L2v9Dr-BC3 ','GGACCC',10,3,'Y'),(300,'L2v9Dr-BC4 ','TTCAGC',10,4,'Y'),(301,'L2v9Dr-BC5 ','AAGACG',10,5,'Y'),(302,'L2v9Dr-BC6 ','CCTCGG',10,6,'Y'),(303,'L2v9Dr-BC7 ','GGATGT',10,7,'Y'),(304,'L2v9Dr-BC8 ','TTCGCT',10,8,'Y'),(305,'L2v9Dr-BC9 ','ACACGA',10,9,'Y'),(306,'L2v9Dr-BC10 ','CACACA',10,10,'Y'),(307,'L2v9Dr-BC11 ','GTGTTA',10,11,'Y'),(308,'L2v9Dr-BC12 ','TGTGAA',10,12,'Y'),(309,'L2v9Dr-BC13 ','ACAAAC',10,13,'Y'),(310,'L2v9Dr-BC14 ','CACCTC',10,14,'Y'),(311,'L2v9Dr-BC15 ','GTGGCC',10,15,'Y'),(312,'L2v9Dr-BC16 ','TGTTGC',10,16,'Y'),(313,'Custom 001','ATAGCG',11,1,'Y'),(314,'Custom 002','ATCATT',11,2,'Y'),(315,'Custom 003','CCATCC',11,3,'Y'),(316,'Custom 004','AAACAT',11,4,'Y'),(317,'Custom 005','GAAACC',11,5,'Y'),(318,'Custom 006','CACCTT',11,6,'Y'),(319,'Custom 007','AGGCTA',11,7,'Y'),(320,'S517','GCGTAAGA',7,0,'N'),(321,'HaloplexHS A01','ATGCCTAA',12,1,'Y'),(322,'HaloplexHS B01','GAATCTGA',12,2,'Y'),(323,'HaloplexHS C01','AACGTGAT',12,3,'Y'),(324,'HaloplexHS D01','CACTTCGA',12,4,'Y'),(325,'HaloplexHS E01','GCCAAGAC',12,5,'Y'),(326,'HaloplexHS F01','GACTAGTA',12,6,'Y'),(327,'HaloplexHS G01','ATTGGCTC',12,7,'Y'),(328,'HaloplexHS H01','GATGAATC',12,8,'Y'),(329,'HaloplexHS A02','AGCAGGAA',12,9,'Y'),(330,'HaloplexHS B02','GAGCTGAA',12,10,'Y'),(331,'HaloplexHS C02','AAACATCG',12,11,'Y'),(332,'HaloplexHS D02','GAGTTAGC',12,12,'Y'),(333,'HaloplexHS E02','CGAACTTA',12,13,'Y'),(334,'HaloplexHS F02','GATAGACA',12,14,'Y'),(335,'HaloplexHS G02','AAGGACAC',12,15,'Y'),(336,'HaloplexHS H02','GACAGTGC',12,16,'Y'),(337,'HaloplexHS A03','ATCATTCC',12,17,'Y'),(338,'HaloplexHS B03','GCCACATA',12,18,'Y'),(339,'HaloplexHS C03','ACCACTGT',12,19,'Y'),(340,'HaloplexHS D03','CTGGCATA',12,20,'Y'),(341,'HaloplexHS E03','ACCTCCAA',12,21,'Y'),(342,'HaloplexHS F03','GCGAGTAA',12,22,'Y'),(343,'HaloplexHS G03','ACTATGCA',12,23,'Y'),(344,'HaloplexHS H03','CGGATTGC',12,24,'Y'),(345,'HaloplexHS A04','AACTCACC',12,25,'Y'),(346,'HaloplexHS B04','GCTAACGA',12,26,'Y'),(347,'HaloplexHS C04','CAGATCTG',12,27,'Y'),(348,'HaloplexHS D04','ATCCTGTA',12,28,'Y'),(349,'HaloplexHS E04','CTGTAGCC',12,29,'Y'),(350,'HaloplexHS F04','GCTCGGTA',12,30,'Y'),(351,'HaloplexHS G04','ACACGACC',12,31,'Y'),(352,'HaloplexHS H04','AGTCACTA',12,32,'Y'),(353,'HaloplexHS A05','AACGCTTA',12,33,'Y'),(354,'HaloplexHS B05','GGAGAACA',12,34,'Y'),(355,'HaloplexHS C05','CATCAAGT',12,35,'Y'),(356,'HaloplexHS D05','AAGGTACA',12,36,'Y'),(357,'HaloplexHS E05','CGCTGATC',12,37,'Y'),(358,'HaloplexHS F05','GGTGCGAA',12,38,'Y'),(359,'HaloplexHS G05','CCTAATCC',12,39,'Y'),(360,'HaloplexHS H05','CTGAGCCA',12,40,'Y'),(361,'HaloplexHS A06','AGCCATGC',12,41,'Y'),(362,'HaloplexHS B06','GTACGCAA',12,42,'Y'),(363,'HaloplexHS C06','AGTACAAG',12,43,'Y'),(364,'HaloplexHS D06','ACATTGGC',12,44,'Y'),(365,'HaloplexHS E06','ATTGAGGA',12,45,'Y'),(366,'HaloplexHS F06','GTCGTAGA',12,46,'Y'),(367,'HaloplexHS G06','AGAGTCAA',12,47,'Y'),(368,'HaloplexHS H06','CCGACAAC',12,48,'Y'),(369,'HaloplexHS A07','ACGTATCA',12,49,'Y'),(370,'HaloplexHS B07','GTCTGTCA',12,50,'Y'),(371,'HaloplexHS C07','CTAAGGTC',12,51,'Y'),(372,'HaloplexHS D07','CGACACAC',12,52,'Y'),(373,'HaloplexHS E07','CCGTGAGA',12,53,'Y'),(374,'HaloplexHS F07','GTGTTCTA',12,54,'Y'),(375,'HaloplexHS G07','CAATGGAA',12,55,'Y'),(376,'HaloplexHS H07','AGCACCTC',12,56,'Y'),(377,'HaloplexHS A08','CAGCGTTA',12,57,'Y'),(378,'HaloplexHS B08','TAGGATGA',12,58,'Y'),(379,'HaloplexHS C08','AGTGGTCA',12,59,'Y'),(380,'HaloplexHS D08','ACAGCAGA',12,60,'Y'),(381,'HaloplexHS E08','CATACCAA',12,61,'Y'),(382,'HaloplexHS F08','TATCAGCA',12,62,'Y'),(383,'HaloplexHS G08','ATAGCGAC',12,63,'Y'),(384,'HaloplexHS H08','ACGCTCGA',12,64,'Y'),(385,'HaloplexHS A09','CTCAATGA',12,65,'Y'),(386,'HaloplexHS B09','TCCGTCTA',12,66,'Y'),(387,'HaloplexHS C09','AGGCTAAC',12,67,'Y'),(388,'HaloplexHS D09','CCATCCTC',12,68,'Y'),(389,'HaloplexHS E09','AGATGTAC',12,69,'Y'),(390,'HaloplexHS F09','TCTTCACA',12,70,'Y'),(391,'HaloplexHS G09','CCGAAGTA',12,71,'Y'),(392,'HaloplexHS H09','CGCATACA',12,72,'Y'),(393,'HaloplexHS A10','AATGTTGC',12,73,'Y'),(394,'HaloplexHS B10','TGAAGAGA',12,74,'Y'),(395,'HaloplexHS C10','AGATCGCA',12,75,'Y'),(396,'HaloplexHS D10','AAGAGATC',12,76,'Y'),(397,'HaloplexHS E10','CAACCACA',12,77,'Y'),(398,'HaloplexHS F10','TGGAACAA',12,78,'Y'),(399,'HaloplexHS G10','CCTCTATC',12,79,'Y'),(400,'HaloplexHS H10','ACAGATTC',12,80,'Y'),(401,'HaloplexHS A11','CCAGTTCA',12,81,'Y'),(402,'HaloplexHS B11','TGGCTTCA',12,82,'Y'),(403,'HaloplexHS C11','CGACTGGA',12,83,'Y'),(404,'HaloplexHS D11','CAAGACTA',12,84,'Y'),(405,'HaloplexHS E11','CCTCCTGA',12,85,'Y'),(406,'HaloplexHS F11','TGGTGGTA',12,86,'Y'),(407,'HaloplexHS G11','AACAACCA',12,87,'Y'),(408,'HaloplexHS H11','AATCCGTC',12,88,'Y'),(409,'HaloplexHS A12','CAAGGAGC',12,89,'Y'),(410,'HaloplexHS B12','TTCACGCA',12,90,'Y'),(411,'HaloplexHS C12','CACCTTAC',12,91,'Y'),(412,'HaloplexHS D12','AAGACGGA',12,92,'Y'),(413,'HaloplexHS E12','ACACAGAA',12,93,'Y'),(414,'HaloplexHS F12','GAACAGGC',12,94,'Y'),(415,'HaloplexHS G12','AACCGAGA',12,95,'Y'),(416,'HaloplexHS H12','ACAAGCTA',12,96,'Y'),(417,'HaloplexHS indexB','NNNNNNNNNN',13,1,'Y'),(418,'N714','GCTCATGA',6,13,'Y'),(419,'N715','ATCTCAGG',6,14,'Y'),(420,'N716','ACTCGCTA',6,15,'Y'),(421,'N718','GGAGCTAC',6,16,'Y'),(422,'N719','GCGTAGTA',6,17,'Y'),(423,'N720','CGGAGCCT',6,18,'Y'),(424,'N721','TACGCTGC',6,19,'Y'),(425,'N722','ATGCGCAG',6,20,'Y'),(426,'N723','TAGCGCTC',6,21,'Y'),(427,'N724','ACTGAGCG',6,22,'Y'),(428,'N726','CCTAAGAC',6,23,'Y'),(429,'N727','CGATCAGT',6,24,'Y'),(430,'N728','TGCAGCTA',6,25,'Y'),(431,'N729','TCGACGTC',6,26,'Y'),(432,'S510','CGTCTAAT',7,9,'Y'),(433,'S511','TCTCTCCG',7,10,'Y'),(434,'S513','TCGACTAG',7,11,'Y'),(435,'S515','TTCTAGCT',7,12,'Y'),(436,'S516','CCTAGAGT',7,13,'Y'),(437,'S517','GCGTAAGA',7,14,'Y'),(438,'S518','CTATTAAG',7,15,'Y'),(439,'S520','AAGGCTAT',7,16,'Y'),(440,'S521','GAGCCTTA',7,17,'Y'),(441,'S522','TTATGCGA',7,18,'Y'),(442,'N701','TAAGGCGA',14,1,'Y'),(443,'N702','CGTACTAG',14,2,'Y'),(444,'N703','AGGCAGAA',14,3,'Y'),(445,'N704','TCCTGAGC',14,4,'Y'),(446,'N705','GGACTCCT',14,5,'Y'),(447,'N706','TAGGCATG',14,6,'Y'),(448,'N707','CTCTCTAC',14,7,'Y'),(449,'N708','CAGAGAGG',14,8,'Y'),(450,'N709','GCTACGCT',14,9,'Y'),(451,'N710','CGAGGCTG',14,10,'Y'),(452,'N711','AAGAGGCA',14,11,'Y'),(453,'N712','GTAGAGGA',14,12,'Y'),(454,'N501','TAGATCGC',15,1,'Y'),(455,'N502','CTCTCTAT',15,2,'Y'),(456,'N503','TATCCTCT',15,3,'Y'),(457,'N504','AGAGTAGA',15,4,'Y'),(458,'N505','GTAAGGAG',15,5,'Y'),(459,'N506','ACTGCATA',15,6,'Y'),(460,'N507','AAGGAGTA',15,7,'Y'),(461,'N508','CTAAGCCT',15,8,'Y'),(462,'N517','GCGTAAGA',15,9,'Y'),(463,'SI-GA-D1-01','CACTCGGA',16,17,'Y'),(464,'SI-GA-D1-02','GCTGAATT',16,18,'Y'),(465,'SI-GA-D1-03','TGAAGTAC',16,19,'Y'),(466,'SI-GA-D1-04','ATGCTCCG',16,20,'Y'),(467,'SI-GA-E1-01','TGGTAAAC',16,21,'Y'),(468,'SI-GA-E1-02','GAAAGGGT',16,22,'Y'),(469,'SI-GA-E1-03','ACTGCTCG',16,23,'Y'),(470,'SI-GA-E1-04','CTCCTCTA',16,24,'Y'),(471,'SI-GA-A1-01','GGTTTACT',16,1,'Y'),(472,'SI-GA-A1-02','CTAAACGG',16,2,'Y'),(473,'SI-GA-A1-03','TCGGCGTC',16,3,'Y'),(474,'SI-GA-A1-04','AACCGTAA',16,4,'Y'),(475,'SI-GA-A2-01','TTTCATGA',16,5,'Y'),(476,'SI-GA-A2-02','ACGTCCCT',16,6,'Y'),(477,'SI-GA-A2-03','CGCATGTG',16,7,'Y'),(478,'SI-GA-A2-04','GAAGGAAC',16,8,'Y'),(479,'SI-GA-A3-01','CAGTACTG',16,9,'Y'),(480,'SI-GA-A3-02','AGTAGTCT',16,10,'Y'),(481,'SI-GA-A3-03','GCAGTAGA',16,11,'Y'),(482,'SI-GA-A3-04','TTCCCGAC',16,12,'Y'),(483,'SI-GA-B1-01','GTAATCTT',16,13,'Y'),(484,'SI-GA-B1-02','TCCGGAAG',16,14,'Y'),(485,'SI-GA-B1-03','AGTTCGGC',16,15,'Y'),(486,'SI-GA-B1-04','CAGCATCA',16,16,'Y'),(487,'N701_6bp','TAAGGC',17,1,'Y'),(488,'N702_6bp','CGTACT',17,2,'Y'),(489,'N703_6bp','AGGCAG',17,3,'Y'),(490,'N704_6bp','TCCTGA',17,4,'Y'),(491,'N705_6bp','GGACTC',17,5,'Y'),(492,'N706_6bp','TAGGCA',17,6,'Y'),(493,'N707_6bp','CTCTCT',17,7,'Y'),(494,'N708_6bp','CAGAGA',17,8,'Y'),(495,'N709_6bp','GCTACG',17,9,'Y'),(496,'N710_6bp','CGAGGC',17,10,'Y'),(497,'N711_6bp','AAGAGG',17,11,'Y'),(498,'N712_6bp','GTAGAG',17,12,'Y');
INSERT INTO protocols VALUES (1,'illumina_Genomic_DNA',NULL,6,1,48,'MULTIPLEX','2014-01-29 00:00:00','Y'),(2,'illumina_Mate-Pair_v2',NULL,6,1,48,'MULTIPLEX','2014-01-29 00:00:00','Y'),(3,'Nextera_DNA',NULL,6,1,48,'DUALMULTIPLEX','2014-01-29 00:00:00','Y'),(4,'Nextera_Mate-Pair',NULL,6,1,48,'DUALMULTIPLEX','2014-01-29 00:00:00','Y'),(5,'NexteraXT_DNA',NULL,6,1,48,'DUALMULTIPLEX','2014-01-29 00:00:00','Y'),(6,'TruSeq_DNA_PCR-Free',NULL,6,1,48,'MULTIPLEX','2014-01-29 00:00:00','Y'),(7,'TruSeq_DNA',NULL,6,1,48,'MULTIPLEX','2014-01-29 00:00:00','Y'),(8,'TruSeq_Nano_DNA',NULL,6,1,48,'MULTIPLEX','2014-01-29 00:00:00','Y'),(9,'SureSelectXT2_V5',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','N'),(10,'SureSelectXT2_V5+UTRs',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','N'),(11,'SureSelectXT2_V5+lncRNA',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','N'),(12,'SureSelectXT2_V5Plus',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','N'),(13,'SureSelectXT2_V4',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','N'),(14,'SureSelectXT2_V4+UTRs',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','N'),(15,'SureSelectXT2_Kinome',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','N'),(16,'SureSelectXT2_Mouse',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','N'),(17,'SureSelectXT2_Custom',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','N'),(18,'SureSelectXT_50Mb',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','N'),(19,'SureSelectXT_V4',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','Y'),(20,'SureSelectXT_V4+UTRs',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','N'),(21,'SureSelectXT_V5',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','Y'),(22,'SureSelectXT_V5+UTRs',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','Y'),(23,'SureSelectXT_V5+lncRNA',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','Y'),(24,'SureSelectXT_V5Plus',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','N'),(25,'SureSelectXT_Mouse',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','N'),(26,'SureSelectXT_Kinome',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','N'),(27,'SureSelectXT_chrX',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','N'),(28,'SureSelectXT_Custom',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','Y'),(29,'HaloPlex',NULL,3,1,96,'MULTIPLEX','2014-01-29 00:00:00','Y'),(30,'TruSeq_Exome',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','Y'),(31,'TruSeq_Custom_Enrichment',NULL,3,1,48,'MULTIPLEX','2014-01-29 00:00:00','Y'),(32,'Nextera_Rapid_Exome',NULL,3,1,48,'DUALMULTIPLEX','2014-01-29 00:00:00','Y'),(33,'Nextera_Rapid_Custom_Enrichment',NULL,3,1,48,'DUALMULTIPLEX','2014-01-29 00:00:00','Y'),(34,'Nextera_Rapid_Enrichment',NULL,3,1,48,'DUALMULTIPLEX','2014-01-29 00:00:00','Y'),(35,'Nextera_Exome',NULL,3,1,48,'DUALMULTIPLEX','2014-01-29 00:00:00','Y'),(36,'Nextera_Custom_Enrichment',NULL,3,1,48,'DUALMULTIPLEX','2014-01-29 00:00:00','Y'),(37,'TruSeq_Stranded_mRNA',NULL,4,1,48,'MULTIPLEX','2014-01-29 00:00:00','Y'),(38,'TruSeq_Stranded_totalRNA_ribozeroGlobin',NULL,4,1,48,'MULTIPLEX','2014-01-29 00:00:00','Y'),(39,'TruSeq_Stranded_totalRNA_ribozeroGold',NULL,4,1,48,'MULTIPLEX','2014-01-29 00:00:00','Y'),(40,'TruSeq_Stranded_totalRNA_ribozeroHuman',NULL,4,1,48,'MULTIPLEX','2014-01-29 00:00:00','Y'),(41,'C1_NexteraXT',NULL,4,1,48,'DUALMULTIPLEX','2014-01-29 00:00:00','Y'),(42,'TruSeq_ChIP',NULL,5,1,48,'MULTIPLEX','2014-01-29 00:00:00','Y'),(43,'ChIA-PET',NULL,5,1,48,'MULTIPLEX','2014-01-29 00:00:00','Y'),(44,'Bisulfite',NULL,12,1,48,'MULTIPLEX','2014-01-29 00:00:00','Y'),(45,'TruSeq_Custom_Amplicon_v1.5',NULL,3,1,48,'DUALMULTIPLEX','2014-01-29 00:00:00','Y'),(46,'ChIP_Ovation_SP_Ultralow_Library_Systems',NULL,5,1,16,'MULTIPLEX','2014-09-03 00:00:00','Y'),(47,'SeqCap_EZ_Human_Exome_Library_v3.0',NULL,3,1,96,'MULTIPLEX','2014-09-03 00:00:00','Y'),(48,'SureSelectXT_V5+Regulatory',NULL,3,1,48,'MULTIPLEX','2014-09-04 00:00:00','Y'),(49,'Hi-C',NULL,5,1,48,'MULTIPLEX','2014-09-04 00:00:00','Y'),(50,'3C',NULL,5,1,48,'MULTIPLEX','2014-09-04 00:00:00','Y'),(51,'4C',NULL,5,1,48,'MULTIPLEX','2014-09-04 00:00:00','Y'),(52,'TruSeq_RNA_Access',NULL,4,1,48,'MULTIPLEX','2014-09-04 00:00:00','Y'),(53,'TruSeq_RNA_v2',NULL,4,1,48,'MULTIPLEX','2014-09-25 00:00:00','Y'),(54,'Bisulfite_TruSeq_Nano_DNA',NULL,12,1,48,'MULTIPLEX','2014-10-06 00:00:00','Y'),(55,'ATAC-seq',NULL,5,1,48,'DUALMULTIPLEX','2014-10-21 00:00:00','Y'),(56,'SureSelectXT_KAPA_HTP_SS_Mouse_allexon',NULL,3,1,48,'MULTIPLEX','2015-01-29 00:00:00','Y'),(57,'KAPA_HyperPrep',NULL,6,1,48,'MULTIPLEX','2015-05-25 00:00:00','Y'),(58,'HaloPlex HS',NULL,3,1,96,'MULTIPLEX','2015-06-02 00:00:00','Y'),(59,'FAIRE',NULL,5,1,48,'MULTIPLEX','2015-06-03 00:00:00','Y'),(60,'C1_800_Cells',NULL,4,1,96,'MULTIPLEX','2015-07-14 15:31:00','Y'),(89,'SureSelectXT_V4_new8bpINDEX',NULL,3,1,96,'MULTIPLEX','2015-07-31 18:36:46','Y'),(90,'SureSelectXT_V5_new8bpINDEX',NULL,3,1,96,'MULTIPLEX','2015-07-31 18:36:46','Y'),(91,'SureSelectXT_V5+UTRs_new8bpINDEX',NULL,3,1,96,'MULTIPLEX','2015-07-31 18:36:46','Y'),(92,'SureSelectXT_V5+lncRNA_new8bpINDEX',NULL,3,1,96,'MULTIPLEX','2015-07-31 18:36:46','Y'),(93,'SureSelectXT_Custom_new8bpINDEX',NULL,3,1,96,'MULTIPLEX','2015-07-31 18:36:46','Y'),(94,'SureSelectXT_V5+Regulatory_new8bpINDEX',NULL,3,1,96,'MULTIPLEX','2015-07-31 18:36:46','Y'),(95,'SureSelectXT_KAPA_HTP_SS_Mouse_allexon_new8bpINDEX',NULL,3,1,96,'MULTIPLEX','2015-07-31 18:36:46','Y'),(96,'Swift_Accell-NGS_2S',NULL,6,1,48,'MULTIPLEX','2015-08-12 10:52:40','Y'),(97,'Nextera_ChIP',NULL,5,1,48,'DUALMULTIPLEX','2015-11-25 00:00:00','Y'),(98,'SureSelectXT2_V6+COSMIC',NULL,3,1,48,'MULTIPLEX','2016-02-26 00:00:00','Y'),(99,'SingleCell_mRNASeq',NULL,4,1,48,'DUALMULTIPLEX','2016-04-14 00:00:00','Y'),(100,'TargetGene_RNAseq',NULL,4,2,48,'MULTIPLEX','2016-07-08 10:08:17','Y'),(101,'SingleCell_mRNASeq_10x','SingleCell_mRNASeq_10x',4,1,96,'MULTIPLEX','2017-02-28 12:01:40','Y'),(102,'SureSelectXT_KAPA_HyperPlus_SS_TOPV3',NULL,3,1,48,'MULTIPLEX','2017-03-21 12:08:19','Y'),(103,'SMART-Seq',NULL,4,1,96,'DUALMULTIPLEX','2017-05-10 16:18:18','Y'),(104,'SMART-Seq2',NULL,4,1,96,'DUALMULTIPLEX','2017-05-10 16:18:36','Y'),(105,'Chromium_Single_Cell',NULL,4,1,96,'MULTIPLEX','2017-05-17 16:46:29','Y'),(106,'ATAC-seq_single',NULL,5,1,48,'MULTIPLEX','2017-07-20 15:50:46','Y');
INSERT INTO oligobarcode_scheme_allows VALUES (2,3,2,'N'),(3,3,9,'N'),(4,3,10,'N'),(5,3,11,'N'),(6,3,12,'N'),(7,3,13,'N'),(8,3,14,'N'),(9,3,15,'N'),(10,3,16,'N'),(11,3,17,'N'),(12,3,18,'N'),(13,3,19,'N'),(14,3,20,'N'),(15,3,21,'N'),(16,3,22,'N'),(17,3,23,'N'),(18,3,24,'N'),(19,3,25,'N'),(20,3,26,'N'),(21,3,27,'N'),(22,3,28,'N'),(23,6,3,'Y'),(24,7,3,'Y'),(25,6,4,'Y'),(26,7,4,'Y'),(27,6,5,'Y'),(28,7,5,'Y'),(29,3,6,'N'),(30,3,7,'N'),(31,3,8,'N'),(32,9,9,'N'),(33,9,10,'N'),(34,9,11,'N'),(35,9,12,'N'),(36,9,13,'N'),(37,9,14,'N'),(38,9,15,'N'),(39,9,16,'N'),(40,9,17,'N'),(41,9,18,'N'),(42,9,19,'N'),(43,9,20,'N'),(44,9,21,'N'),(45,9,22,'N'),(46,9,23,'N'),(47,9,24,'N'),(48,9,25,'N'),(49,9,26,'N'),(50,9,27,'N'),(51,9,28,'N'),(52,8,29,'N'),(53,3,30,'N'),(54,3,31,'N'),(55,6,32,'Y'),(56,7,32,'Y'),(57,6,33,'Y'),(58,7,33,'Y'),(59,6,34,'Y'),(60,7,34,'Y'),(61,6,35,'Y'),(62,7,35,'Y'),(63,6,36,'Y'),(64,7,36,'Y'),(65,3,37,'N'),(66,3,38,'N'),(67,3,39,'N'),(68,3,40,'N'),(69,6,41,'Y'),(70,7,41,'Y'),(71,3,42,'N'),(72,3,43,'N'),(73,3,44,'N'),(74,4,45,'Y'),(75,5,45,'Y'),(76,10,46,'Y'),(77,9,47,'Y'),(78,3,48,'Y'),(79,9,48,'Y'),(80,3,49,'N'),(81,3,50,'N'),(82,3,51,'N'),(83,3,52,'N'),(84,3,53,'N'),(85,6,55,'Y'),(86,7,55,'Y'),(87,3,56,'N'),(88,12,58,'N'),(89,13,58,'Y'),(90,3,59,'N'),(91,6,60,'N'),(92,12,89,'N'),(93,12,90,'N'),(94,12,91,'N'),(95,12,92,'N'),(96,12,93,'N'),(97,12,94,'N'),(98,12,95,'N'),(99,3,96,'Y'),(100,14,97,'Y'),(101,15,97,'Y'),(102,9,49,'Y'),(103,3,98,'Y'),(104,9,98,'Y'),(105,3,57,'Y'),(106,6,99,'Y'),(107,7,99,'Y'),(108,9,29,'Y'),(111,3,100,'N'),(112,16,101,'N'),(120,8,102,'N'),(121,3,102,'N'),(122,9,102,'N'),(123,8,23,'N'),(124,8,56,'N'),(125,9,56,'N'),(129,3,1,'N'),(130,6,103,'Y'),(131,7,103,'Y'),(133,6,104,'Y'),(134,7,104,'Y'),(135,16,105,'N'),(136,17,106,'N');

INSERT INTO organisms VALUES (1,'Lizard',100,'Anolis carolinensis',NULL,'Y'),(2,'A.gambiae',200,'Anopheles gambiae',NULL,'Y'),(3,'A_mellifera',300,'Apis mellifera',NULL,'Y'),(4,'A. thaliana',400,'Arabidopsis thaliana',NULL,'Y'),(5,'Cow',500,'Bos taurus',NULL,'Y'),(6,'Lancet',600,'Branchiostoma floridae',NULL,'Y'),(7,'Marmoset',700,'Callithrix jacchus',NULL,'Y'),(8,'Guinea Pig',800,'Cavia porcellus',NULL,'Y'),(9,'C. intestinalis',900,'Ciona intestinalis',NULL,'Y'),(10,'C. brenneri',1000,'Caenorhabditis brenneri',NULL,'Y'),(11,'C. briggsae',1100,'Caenorhabditis briggsae',NULL,'Y'),(12,'C. elegans',1200,'Caenorhabditis elegans',NULL,'Y'),(13,'C. japonica',1300,'Caenorhabditis japonica',NULL,'Y'),(14,'C. remanei',1400,'Caenorhabditis remanei',NULL,'Y'),(15,'Dog',1500,'Canis lupus familiaris',NULL,'Y'),(16,'D. ananassae',1600,'Drosophila ananassae',NULL,'Y'),(17,'D. erecta',1700,'Drosophila erecta',NULL,'Y'),(18,'D. grimshawi',1800,'Drosophila grimshawi',NULL,'Y'),(19,'Drosophila melanogaster',1900,'Drosophila melanogaster',NULL,'Y'),(20,'Drosophila mojavensis',2000,'Drosophila mojavensis',NULL,'Y'),(21,'Drosophila persimilis',2100,'Drosophila persimilis',NULL,'Y'),(22,'Drosophila pseudoobscura',2200,'Drosophila pseudoobscura',NULL,'Y'),(23,'Drosophila sechellia',2300,'Drosophila sechellia',NULL,'Y'),(24,'Drosophila simulans',2400,'Drosophila simulans',NULL,'Y'),(25,'Drosophila virilis',2500,'Drosophila virilis',NULL,'Y'),(26,'Drosophila yakuba',2600,'Drosophila yakuba',NULL,'Y'),(27,'Zebrafish',2700,'Danio rerio',NULL,'Y'),(28,'Horse',2800,'Equus caballus',NULL,'Y'),(29,'E. coli',2900,'Escherichia coli',NULL,'Y'),(30,'Cat',3000,'Felis catus',NULL,'Y'),(31,'Chicken',3100,'Gallus gallus',NULL,'Y'),(32,'Stickleback G_aculeatus',3200,'Gasterosteus aculeatus',NULL,'Y'),(33,'Soybean',3300,'Glycine max',NULL,'Y'),(34,'Human',3400,'Homo sapiens',0,'Y'),(35,'Rhesus',3500,'Macaca mulatta',NULL,'Y'),(36,'Barrel Medic',3600,'Medicago truncatula',NULL,'Y'),(37,'Opossum',3700,'Monodelphis domestica',NULL,'Y'),(38,'Mouse',3800,'Mus musculus',1,'Y'),(39,'M. abcessus',3900,'Mycobacterium abscessus',NULL,'Y'),(40,'M. smegmatis',4000,'Mycobacterium smegmatis',NULL,'Y'),(41,'M. tuberculosis',4100,'Mycobacterium tuberculosis',NULL,'Y'),(42,'Platypus',4200,'Ornithorhynchus anatinus',NULL,'Y'),(43,'Rice',4300,'Oryza sativa',NULL,'Y'),(44,'Medaka',4400,'Oryzias latipes',NULL,'Y'),(45,'O. lucimarinus',4500,'Ostreococcus lucimarinus',NULL,'Y'),(46,'Chimp',4600,'Pan troglodytes',NULL,'Y'),(47,'Lamprey',4700,'Petromyzon marinus',NULL,'Y'),(48,'P. falciparum',4800,'Plasmodium falciparum',NULL,'Y'),(49,'Orangutan',4900,'Pongo pygmaeus abelii',NULL,'Y'),(50,'Black Cottonwood',5000,'Populus trichocarpa',NULL,'Y'),(51,'P. pacificus',5100,'Pristionchus pacificus',NULL,'Y'),(52,'Rat',5200,'Rattus norvegicus',NULL,'Y'),(53,'Yeast',5300,'Saccharomyces cerevisiae',NULL,'Y'),(54,'Fission Yeast',5400,'Schizosaccharomyces pombe',NULL,'Y'),(55,'S. glossinidius',5500,'Sodalis glossinidius',NULL,'Y'),(56,'Sorghum',5600,'Sorghum bicolor',NULL,'Y'),(57,'Purple Sea Urchin',5700,'Strongylocentrotus purpuratus',NULL,'Y'),(58,'Zebra Finch',5800,'Taeniopygia guttata',NULL,'Y'),(59,'Fugu',5900,'Takifugu rubripes',NULL,'Y'),(60,'Tetraodon',6000,'Tetraodon nigroviridis',NULL,'Y'),(61,'Common Grape Vine',6100,'Vitis vinifera',NULL,'Y'),(62,'Pipid Frog',6200,'Xenopus tropicalis',NULL,'Y');
INSERT INTO sample_types VALUES (1,'genomic DNA','DNA','GD',1,'Y'),(2,'aRNA','RNA',NULL,NULL,'N'),(3,'miRNA','RNA',NULL,11,'Y'),(4,'mRNA','RNA','MR',7,'Y'),(5,'Total RNA','RNA','TR',1,'Y'),(6,'FFPE DNA','DNA','FD',2,'Y'),(7,'ChIP DNA','DNA','PD',3,'Y'),(8,'polyA RNA','RNA',NULL,NULL,'N'),(9,'Total RNA (prokaryote)','RNA',NULL,NULL,'N'),(10,'Cell free DNA','DNA',NULL,4,'Y'),(11,'cap RNA','RNA',NULL,NULL,'N'),(12,'small RNA','RNA',NULL,11,'Y'),(13,'Single Cell DNA','DNA','SD',2,'Y'),(14,'FAIRE DNA','DNA','RD',6,'Y'),(15,'rebozero RNA','RNA','RR',9,'Y'),(16,'Single Cell RNA','RNA','SR',10,'Y');

INSERT INTO controls VALUES (1,'PhiX','ILLUMINANGS','Y');
EOS