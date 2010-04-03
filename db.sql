-- MySQL dump 10.10
--
-- Host: localhost    Database: pastoral
-- ------------------------------------------------------
-- Server version	5.0.27

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
-- Table structure for table `cubes`
--

DROP TABLE IF EXISTS `cubes`;
CREATE TABLE `cubes` (
  `id` int(11) NOT NULL auto_increment,
  `description` text,
  `distant_description` text,
  `x` int(4) default NULL,
  `y` int(4) default NULL,
  `z` int(4) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=30 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `cubes`
--

LOCK TABLES `cubes` WRITE;
/*!40000 ALTER TABLE `cubes` DISABLE KEYS */;
INSERT INTO `cubes` VALUES (1,'You find yourself so close to a gigantic hardwood tree that you can feel warmth on your face with every breath. Stepping back, you see a bronze plaque, engulfed on the edges by bulging bark, that reads, \"ARBORIGIN\". Looking up, you see its sprawling branches extending in every direction.','A large hardwood tree.',0,0,0),(2,'The cobblestones in the central square of the town refect the heat from the sun onto your body.','Part of the town\'s central square, exposed to the bright sun.',1,0,0),(3,'You\'re inside a small, single-story shop. Tables along the walls are covered in cloths and arrayed with kitch, like small dolls, silverware and animal bones.','A small shop.',2,0,0),(4,'The stones of the public square appear swept and oft-trodden.','The public square.',0,1,0),(11,'A small gazeebo for town meetings appears to have been built recently above the age-old stones of the central square. Above flies the town flag--the head of a roaring lion on a red background.','A newly-built gazeebo.',1,1,0),(12,'The inside of the town hall is simple, but dignified. The rotunda has a second story around the edge, allowing a clear view of the artwork on the inside of the dome from the ground floor. A small, shriveled woman sits at a desk to the left of the door, shuffling papers, completely unaware of--or unconcerned with--your presence.','The town hall.',2,1,0),(13,'Walking around the inside of the rotunda, you can look down over the railing to the ground floor below. Above, a stylized interpretation of the town\'s symbol--a roaring lion--adorns the inside of the dome. Along the walkway are doors leading to interior offices.','A walkway with railings under the dome.',2,1,1),(15,'The stones of the town\'s central square feel warm and dusty under your feet.','Dusty stones of the central square.',-1,1,0),(16,'The shade from Arborigin stretches over you as you stand upon the aged stones of the town\'s central square.','Aged stones shaded by Arborigin.',-1,0,0),(17,'It appears that the stones here were recently replaced--at least within the last 100 years. They are swept, and don\'t seem to see much traffic.','Newer, swept stones of the central square.',-1,-1,0),(18,'A small, dry bird\'s bath full of bird seed attracts birds from all around. Finches and pigeons gorge themselves on the buffet.','Birds congregate around a bird\'s bath.',0,-1,0),(19,'The sun dries and cracks the ground that has blown over the stones in this remote corner of the town\'s central square. It\'s as if the world is reclaiming the square one stone at a time.','A remote corner of the square being reclaimed.',1,-1,0),(20,'You find yourself in a small but very nice home. To the left, dark-wood bookshelves line the walls around the fireplace. To the right, you see a small kitchen, complete with wood stove, water bucket, and wooden cabinets.','A small but very nice home.',-1,-2,0),(22,'None.','A very nice, three-story home.',-2,-1,0),(23,'None','A expensive two-story home.',-2,0,0),(24,'The small outdoor market is covered above by a canvas stretched over four staked poles. The market\'s owner is nowhere to be found, but woven baskets, small stools, and crates of fresh fruit cover the ground.','A small outdoor market.',-2,1,0),(25,'None.','A small, dirty hut.',0,-2,0),(26,'A narrow, stone path splits and leads north or east. The path is lined by landscaped gardens of flowers and shrubs.','A narrow, stone path.',1,2,0),(27,'The spartan lobby has naught but two waiting chairs and and small reception desk against the back wall. The walls, ceiling and floor are a gleaming white.','The lobby of an industrial-looking brick building with small windows.',0,2,0),(28,'The room contains twelve desks, arranged in 4 columns of three, each bearing the weight of a giant, metallic terminal with a large, dark screen and an input device arrayed with labeled buttons.','Stairs lead up to another bright, white room.',0,2,1),(29,'The storage room contains crates of papers, each carefully labeled, that appear heavy and private.','A storage room.',-1,2,0);
/*!40000 ALTER TABLE `cubes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goto_link`
--

DROP TABLE IF EXISTS `goto_link`;
CREATE TABLE `goto_link` (
  `id` int(11) NOT NULL auto_increment,
  `x1` int(4) default NULL,
  `y1` int(4) default NULL,
  `z1` int(4) default NULL,
  `x2` int(4) default NULL,
  `y2` int(4) default NULL,
  `z2` int(4) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=31 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `goto_link`
--

LOCK TABLES `goto_link` WRITE;
/*!40000 ALTER TABLE `goto_link` DISABLE KEYS */;
INSERT INTO `goto_link` VALUES (1,0,0,0,1,0,0),(2,1,0,0,2,0,0),(3,0,0,0,0,1,0),(12,1,1,0,1,0,0),(11,1,1,0,0,1,0),(13,2,1,0,1,1,0),(14,2,1,1,2,1,0),(16,-1,1,0,0,1,0),(17,-1,0,0,-1,1,0),(18,-1,0,0,0,0,0),(19,-1,-1,0,-1,0,0),(20,0,-1,0,-1,-1,0),(21,0,-1,0,0,0,0),(22,1,-1,0,1,0,0),(23,1,-1,0,0,-1,0),(24,-1,-2,0,-1,-1,0),(26,-2,1,0,-1,1,0),(27,1,2,0,1,1,0),(28,0,2,0,0,1,0),(29,0,2,1,0,2,0),(30,-1,2,0,0,2,0);
/*!40000 ALTER TABLE `goto_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seeto_link`
--

DROP TABLE IF EXISTS `seeto_link`;
CREATE TABLE `seeto_link` (
  `id` int(11) NOT NULL auto_increment,
  `x1` int(4) default NULL,
  `y1` int(4) default NULL,
  `z1` int(4) default NULL,
  `x2` int(4) default NULL,
  `y2` int(4) default NULL,
  `z2` int(4) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `seeto_link`
--

LOCK TABLES `seeto_link` WRITE;
/*!40000 ALTER TABLE `seeto_link` DISABLE KEYS */;
INSERT INTO `seeto_link` VALUES (1,0,0,0,1,0,0),(2,1,0,0,2,0,0),(3,0,0,0,0,1,0),(12,1,1,0,1,0,0),(11,1,1,0,0,1,0),(13,2,1,0,1,1,0),(14,2,1,1,2,1,0),(16,-1,1,0,0,1,0),(17,-1,0,0,-1,1,0),(18,-1,0,0,0,0,0),(19,-1,-1,0,-1,0,0),(20,0,-1,0,-1,-1,0),(21,0,-1,0,0,0,0),(22,1,-1,0,1,0,0),(23,1,-1,0,0,-1,0),(24,-1,-2,0,-1,-1,0),(26,-2,-1,0,-1,-1,0),(27,-2,0,0,-1,0,0),(28,-2,1,0,-1,1,0),(29,0,-2,0,0,-1,0),(30,1,2,0,1,1,0),(31,0,2,0,0,1,0),(32,0,2,1,0,2,0),(33,-1,2,0,0,2,0);
/*!40000 ALTER TABLE `seeto_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `username` varchar(20) default NULL,
  `password` varchar(32) default NULL,
  `em` tinyint(1) default '0',
  `fm` tinyint(1) default '0',
  `wm` tinyint(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'moneo','42d388f8b1db997faaf7dab487f11290',1,1,1);
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

-- Dump completed on 2007-09-30  5:57:40
