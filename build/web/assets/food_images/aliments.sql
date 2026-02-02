-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jan 17, 2026 at 02:58 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `nutrit`
--

-- --------------------------------------------------------

--
-- Table structure for table `aliments`
--

CREATE TABLE `aliments` (
  `id` int(11) NOT NULL,
  `nom_fr` varchar(150) NOT NULL,
  `nom_ar` varchar(150) DEFAULT NULL,
  `categorie` varchar(50) NOT NULL,
  `objectifs_recommandes` varchar(255) DEFAULT NULL COMMENT 'Comma-separated: perte_poids,prise_masse,diabete,sport,etc',
  `moment_ideal` varchar(50) DEFAULT 'matin,midi,soir' COMMENT 'When to eat: matin,midi,soir,collation',
  `unite_portion` varchar(20) DEFAULT 'g',
  `portion_defaut` int(11) DEFAULT 100,
  `calories_100g` int(11) DEFAULT 0,
  `proteines_g` decimal(5,2) DEFAULT 0.00,
  `glucides_g` decimal(5,2) DEFAULT 0.00,
  `lipides_g` decimal(5,2) DEFAULT 0.00,
  `fibres_g` decimal(5,2) DEFAULT 0.00,
  `est_actif` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `aliments`
--

INSERT INTO `aliments` (`id`, `nom_fr`, `nom_ar`, `categorie`, `objectifs_recommandes`, `moment_ideal`, `unite_portion`, `portion_defaut`, `calories_100g`, `proteines_g`, `glucides_g`, `lipides_g`, `fibres_g`, `est_actif`) VALUES
(16, 'Couscous', 'كسكسي', 'glucides', NULL, 'midi,soir', 'g', 100, 112, 0.00, 0.00, 0.00, 0.00, 1),
(61, 'Huile d\'Olive', 'زيت زيتون', 'lipides', NULL, 'matin,midi,soir', 'c. à s.', 1, 884, 0.00, 0.00, 0.00, 0.00, 1),
(62, 'Blanc de Poulet Grillé', 'صدر دجاج مشوي', 'proteines', 'perte_poids,prise_masse,sport,diabete', 'midi,soir', 'g', 100, 165, 31.00, 0.00, 3.60, 0.00, 1),
(63, 'Escalope de Dinde', 'سكالوب ديك رومي', 'proteines', 'perte_poids,prise_masse,sport', 'midi,soir', 'g', 100, 147, 29.00, 0.00, 2.00, 0.00, 1),
(64, 'Poulet Rôti (sans peau)', 'دجاج محمر بدون جلد', 'proteines', 'perte_poids,sport', 'midi,soir', 'ml', 200, 190, 28.00, 0.00, 7.40, 0.00, 1),
(65, 'Cuisse de Poulet (sans peau)', 'فخذ دجاج', 'proteines', 'prise_masse,sport', 'midi,soir', 'ml', 200, 209, 26.00, 0.00, 10.90, 0.00, 1),
(66, 'Dinde Hachée (5% MG)', 'ديك رومي مفروم', 'proteines', 'perte_poids,sport', 'midi,soir', 'g', 100, 150, 29.00, 0.00, 2.50, 0.00, 1),
(67, 'Steak de Boeuf (5% MG)', 'شريحة لحم بقر', 'proteines', 'prise_masse,sport', 'midi', 'unité', 1, 130, 21.00, 0.00, 5.00, 0.00, 1),
(68, 'Boeuf Haché Maigre', 'لحم بقر مفروم', 'proteines', 'prise_masse', 'midi', 'unité', 1, 176, 20.00, 0.00, 10.00, 0.00, 1),
(69, 'Gigot d\'Agneau', 'لحم خروف', 'proteines', 'prise_masse', 'midi', 'ml', 200, 294, 25.00, 0.00, 21.00, 0.00, 1),
(70, 'Côtelette d\'Agneau', 'قطلية خروف', 'proteines', 'prise_masse', 'midi', 'ml', 200, 360, 18.00, 0.00, 32.00, 0.00, 1),
(71, 'Filet de Veau', 'لحم العجل', 'proteines', 'perte_poids,sport', 'midi', 'ml', 200, 109, 20.00, 0.00, 3.00, 0.00, 1),
(72, 'Foie de Veau', 'كبدة', 'proteines', 'anemie,fer', 'midi', 'ml', 200, 140, 20.00, 3.90, 3.60, 0.00, 1),
(73, 'Merguez', 'مرقاز', 'proteines', 'plaisir', 'midi', 'g', 100, 297, 16.00, 1.00, 25.00, 0.00, 1),
(74, 'Saumon Cuit', 'سلمون مطبوخ', 'proteines', 'prise_masse,cholesterol,sport', 'midi,soir', 'g', 100, 208, 20.00, 0.00, 13.00, 0.00, 1),
(75, 'Thon au Naturel', 'تن معلب طبيعي', 'proteines', 'perte_poids,sport,diabete', 'midi,soir,collation', 'g', 100, 116, 26.00, 0.00, 1.00, 0.00, 1),
(76, 'Sardines Grillées', 'سردين مشوي', 'proteines', 'cholesterol,sport,omega3', 'midi,soir', 'g', 100, 208, 25.00, 0.00, 11.00, 0.00, 1),
(77, 'Sardines en Conserve', 'سردين معلب', 'proteines', 'omega3,pratique', 'midi,collation', 'g', 100, 185, 21.00, 0.00, 11.00, 0.00, 1),
(78, 'Dorade Grillée', 'دنيس مشوي', 'proteines', 'perte_poids', 'midi,soir', 'g', 100, 96, 20.00, 0.00, 1.80, 0.00, 1),
(79, 'Loup de Mer (Bar)', 'قاروص', 'proteines', 'perte_poids', 'midi,soir', 'g', 100, 97, 18.00, 0.00, 2.00, 0.00, 1),
(80, 'Merlan Frit', 'ميرلان مقلي', 'proteines', 'plaisir', 'midi', 'g', 100, 191, 17.00, 7.00, 11.00, 0.00, 1),
(81, 'Rouget Grillé', 'سلطان ابراهيم', 'proteines', 'perte_poids', 'soir', 'g', 100, 127, 24.00, 0.00, 3.00, 0.00, 1),
(82, 'Calamar', 'سبيط/كلمار', 'proteines', 'perte_poids', 'midi,soir', 'g', 100, 92, 15.60, 3.10, 1.40, 0.00, 1),
(83, 'Poulpe', 'اخطبوط', 'proteines', 'perte_poids', 'midi,soir', 'g', 100, 82, 14.90, 2.20, 1.00, 0.00, 1),
(84, 'Crevettes', 'جمبري', 'proteines', 'perte_poids,sport', 'midi,soir', 'g', 100, 99, 24.00, 0.20, 0.30, 0.00, 1),
(85, 'Moules', 'بلح البحر', 'proteines', 'fer', 'midi,soir', 'g', 100, 86, 11.90, 3.70, 2.20, 0.00, 1),
(86, 'Palourdes', 'محار', 'proteines', 'fer,zinc', 'midi,soir', 'g', 100, 74, 12.80, 2.60, 1.00, 0.00, 1),
(87, 'Oeuf Dur (unité ~50g)', 'بيضة مسلوقة', 'proteines', 'perte_poids,prise_masse,maintien', 'matin,midi,soir', 'unité', 1, 155, 13.00, 1.10, 11.00, 0.00, 1),
(88, 'Blanc d\'Oeuf', 'بياض البيض', 'proteines', 'perte_poids,sport', 'matin,soir', 'unité', 1, 52, 11.00, 0.70, 0.20, 0.00, 1),
(89, 'Oeuf au Plat', 'بيض مقلي', 'proteines', 'maintien', 'matin', 'unité', 1, 196, 13.60, 0.80, 15.00, 0.00, 1),
(90, 'Omelette Nature', 'عجة', 'proteines', 'maintien', 'matin,soir', 'g', 100, 154, 10.60, 0.60, 11.70, 0.00, 1),
(91, 'Lentilles Cuites', 'عدس مطبوخ', 'proteines', 'vegetarien,vegan,diabete,cholesterol', 'midi', 'g', 100, 116, 9.00, 20.00, 0.40, 7.90, 1),
(92, 'Pois Chiches Cuits', 'حمص مطبوخ', 'proteines', 'vegetarien,vegan,prise_masse', 'midi,collation', 'g', 100, 164, 8.90, 27.00, 2.60, 7.60, 1),
(93, 'Haricots Blancs Cuits', 'فاصوليا بيضاء', 'proteines', 'vegetarien,fibres', 'midi', 'g', 100, 140, 9.70, 25.00, 0.50, 6.40, 1),
(94, 'Haricots Rouges Cuits', 'لوبيا حمراء', 'proteines', 'vegetarien,diabete', 'midi', 'g', 100, 127, 8.70, 22.80, 0.50, 6.40, 1),
(95, 'Fèves Cuites', 'فول', 'proteines', 'vegetarien,traditionnel', 'matin,midi', 'g', 100, 110, 7.60, 19.70, 0.40, 5.40, 1),
(96, 'Petits Pois Cuits', 'جلبانة', 'proteines', 'vegetarien', 'midi', 'g', 100, 84, 5.40, 15.60, 0.40, 5.50, 1),
(97, 'Riz Blanc Cuit', 'أرز أبيض مطبوخ', 'glucides', 'prise_masse,sport', 'midi', 'g', 100, 130, 2.70, 28.00, 0.30, 0.40, 1),
(98, 'Riz Basmati Cuit', 'أرز بسمتي', 'glucides', 'maintien,sport', 'midi', 'g', 100, 121, 3.50, 25.00, 0.40, 1.00, 1),
(99, 'Riz Brun Cuit', 'أرز بني', 'glucides', 'perte_poids,diabete', 'midi', 'g', 100, 111, 2.60, 23.00, 0.90, 1.80, 1),
(100, 'Pâtes Blanches Cuites', 'مقرونة بيضاء', 'glucides', 'sport,prise_masse', 'midi', 'g', 100, 158, 5.80, 30.90, 0.90, 1.80, 1),
(101, 'Pâtes Complètes Cuites', 'مقرونة كاملة', 'glucides', 'perte_poids,diabete,cholesterol', 'midi', 'g', 100, 124, 5.30, 26.00, 0.50, 4.50, 1),
(102, 'Couscous Cuit', 'كسكسي', 'glucides', 'maintien,traditionnel', 'midi', 'g', 100, 112, 3.80, 23.00, 0.20, 1.40, 1),
(103, 'Couscous Complet', 'كسكسي كامل', 'glucides', 'diabete,fibres', 'midi', 'g', 100, 95, 3.50, 19.00, 0.30, 2.80, 1),
(104, 'Quinoa Cuit', 'كينوا', 'glucides', 'gluten_free,vegetarien,sport', 'midi,soir', 'g', 100, 120, 4.40, 21.00, 1.90, 2.80, 1),
(105, 'Boulgour Cuit', 'برغل', 'glucides', 'fibres,diabete', 'midi', 'g', 100, 83, 3.10, 18.60, 0.20, 4.50, 1),
(106, 'Semoule Moyenne', 'سميذ', 'glucides', 'prise_masse', 'matin', 'g', 100, 360, 12.70, 72.80, 1.10, 3.90, 1),
(107, 'Frik (blé vert)', 'فريك', 'glucides', 'traditionnel,fibres', 'midi,soir', 'g', 100, 325, 11.00, 68.00, 2.00, 8.00, 1),
(108, 'Pain Blanc (tranche 30g)', 'خبز أبيض', 'glucides', 'energie', 'matin,midi', 'tranche', 2, 265, 9.00, 49.00, 3.20, 2.70, 1),
(109, 'Pain Complet (tranche)', 'خبز كامل', 'glucides', 'diabete,perte_poids', 'matin,midi', 'tranche', 2, 247, 13.00, 41.00, 3.40, 7.00, 1),
(110, 'Pain Tabouna', 'خبز طابونة', 'glucides', 'traditionnel,prise_masse', 'matin,midi', 'tranche', 2, 275, 8.00, 55.00, 1.50, 2.50, 1),
(111, 'Pain Mlaoui', 'ملاوي', 'glucides', 'traditionnel', 'matin', 'tranche', 2, 310, 7.00, 50.00, 9.00, 2.00, 1),
(112, 'Chapati', 'شباتي', 'glucides', 'traditionnel', 'matin,midi', 'g', 100, 297, 9.60, 51.00, 6.60, 3.00, 1),
(113, 'Pain de Mie', 'توست', 'glucides', 'pratique', 'matin', 'tranche', 2, 266, 8.90, 48.30, 3.30, 2.30, 1),
(114, 'Baguette', 'باغيت', 'glucides', 'energie', 'matin,midi', 'g', 100, 280, 9.00, 55.00, 2.00, 3.00, 1),
(115, 'Flocons d\'Avoine (cru)', 'شوفان', 'glucides', 'perte_poids,sport,cholesterol,diabete', 'matin,collation', 'g', 100, 389, 16.90, 66.00, 6.90, 10.60, 1),
(116, 'Muesli', 'موسلي', 'glucides', 'sport,fibres', 'matin', 'g', 100, 352, 9.70, 66.00, 5.90, 7.70, 1),
(117, 'Corn Flakes', 'كورن فليكس', 'glucides', 'energie', 'matin', 'g', 100, 357, 7.50, 84.00, 0.40, 3.00, 1),
(118, 'Pomme de Terre Vapeur', 'بطاطا مسلوقة', 'glucides', 'sport,maintien', 'midi,soir', 'g', 100, 77, 2.00, 17.00, 0.10, 2.20, 1),
(119, 'Pomme de Terre Frite', 'بطاطا مقلية', 'glucides', 'plaisir', 'midi', 'g', 100, 312, 3.40, 41.00, 15.00, 3.80, 1),
(120, 'Purée de Pommes de Terre', 'بطاطا مهروسة', 'glucides', 'pratique', 'midi,soir', 'g', 100, 83, 2.00, 17.00, 0.10, 2.20, 1),
(121, 'Patate Douce Cuite', 'بطاطا حلوة', 'glucides', 'sport,diabete,antioxydant', 'midi,soir', 'g', 100, 86, 1.60, 20.00, 0.10, 3.00, 1),
(122, 'Laitue/Salade Verte', 'سلطة خضراء', 'legumes', 'perte_poids,diabete,cholesterol', 'midi,soir', 'ml', 200, 15, 1.40, 2.90, 0.20, 1.30, 1),
(123, 'Roquette', 'جرجير', 'legumes', 'perte_poids,antioxydant', 'midi,soir', 'g', 100, 25, 2.60, 3.70, 0.70, 1.60, 1),
(124, 'Épinards Cuits', 'سبناخ', 'legumes', 'perte_poids,anemie,fer', 'midi,soir', 'g', 100, 23, 3.00, 3.80, 0.30, 2.40, 1),
(125, 'Épinards Crus', 'سبناخ طازج', 'legumes', 'fer,vitamines', 'midi,soir', 'g', 100, 23, 2.90, 3.60, 0.40, 2.20, 1),
(126, 'Brocoli Vapeur', 'بروكلو', 'legumes', 'perte_poids,sport,diabete,cancer', 'midi,soir', 'g', 100, 35, 2.40, 7.20, 0.40, 3.30, 1),
(127, 'Chou-fleur Cuit', 'قرنبيط', 'legumes', 'perte_poids,diabete', 'midi,soir', 'g', 100, 23, 1.80, 4.10, 0.50, 2.30, 1),
(128, 'Chou Vert', 'كرنب أخضر', 'legumes', 'perte_poids,fibres', 'midi,soir', 'g', 100, 25, 1.30, 5.80, 0.10, 2.50, 1),
(129, 'Chou Rouge', 'كرنب أحمر', 'legumes', 'antioxydant', 'midi,soir', 'g', 100, 31, 1.40, 7.40, 0.20, 2.10, 1),
(130, 'Tomate', 'طماطم', 'legumes', 'perte_poids,maintien,antioxydant', 'matin,midi,soir', 'g', 100, 18, 0.90, 3.90, 0.20, 1.20, 1),
(131, 'Tomate Cerise', 'طماطم كرزية', 'legumes', 'perte_poids,snack', 'collation', 'g', 100, 18, 0.90, 3.90, 0.20, 1.20, 1),
(132, 'Concombre', 'فقوس', 'legumes', 'perte_poids,diabete,hydratation', 'matin,midi,soir', 'g', 100, 15, 0.70, 3.60, 0.10, 0.50, 1),
(133, 'Poivron Vert', 'فلفل أخضر', 'legumes', 'perte_poids,immunite', 'midi,soir', 'g', 100, 20, 0.90, 4.60, 0.20, 1.70, 1),
(134, 'Poivron Rouge', 'فلفل أحمر', 'legumes', 'antioxydant,vitamine_c', 'midi,soir', 'g', 100, 31, 1.00, 6.00, 0.30, 2.10, 1),
(135, 'Poivron Jaune', 'فلفل أصفر', 'legumes', 'vitamine_c', 'midi,soir', 'g', 100, 27, 1.00, 6.30, 0.20, 0.90, 1),
(136, 'Aubergine Grillée', 'بتنجان', 'legumes', 'fibres', 'midi,soir', 'g', 100, 35, 0.80, 8.60, 0.20, 3.00, 1),
(137, 'Courgettes', 'قرع أخضر', 'legumes', 'perte_poids', 'midi,soir', 'g', 100, 17, 1.20, 3.10, 0.30, 1.00, 1),
(138, 'Carottes Crues', 'جزر نيء', 'legumes', 'maintien,vision', 'collation,midi', 'g', 100, 41, 0.90, 9.60, 0.20, 2.80, 1),
(139, 'Carottes Cuites', 'جزر مطبوخ', 'legumes', 'vision,facile_digestion', 'midi,soir', 'g', 100, 35, 0.80, 8.20, 0.20, 3.00, 1),
(140, 'Betterave Cuite', 'شمندر', 'legumes', 'anemie,sport', 'midi,collation', 'g', 100, 44, 1.70, 10.00, 0.20, 2.00, 1),
(141, 'Navet', 'لفت', 'legumes', 'perte_poids', 'midi,soir', 'g', 100, 28, 0.90, 6.40, 0.10, 1.80, 1),
(142, 'Radis', 'فجل', 'legumes', 'perte_poids,detox', 'collation', 'g', 100, 16, 0.70, 3.40, 0.10, 1.60, 1),
(143, 'Haricots Verts', 'لوبيا خضراء', 'legumes', 'perte_poids,diabete', 'midi,soir', 'g', 100, 31, 1.80, 7.00, 0.10, 3.40, 1),
(144, 'Oignon', 'بصل', 'legumes', 'maintien,saveur', 'midi,soir', 'g', 100, 40, 1.10, 9.30, 0.10, 1.70, 1),
(145, 'Oignon Rouge', 'بصل أحمر', 'legumes', 'antioxydant', 'midi,soir', 'g', 100, 42, 0.90, 10.10, 0.10, 1.40, 1),
(146, 'Ail', 'ثوم', 'legumes', 'immunite,cholesterol', 'midi,soir', 'g', 100, 149, 6.40, 33.10, 0.50, 2.10, 1),
(147, 'Artichaut', 'قوق', 'legumes', 'fibres,foie', 'midi', 'g', 100, 47, 3.30, 10.50, 0.20, 5.40, 1),
(148, 'Asperges', 'هليون', 'legumes', 'perte_poids,detox', 'midi,soir', 'g', 100, 20, 2.20, 3.90, 0.10, 2.10, 1),
(149, 'Champignons', 'فطر', 'legumes', 'perte_poids,vegan', 'midi,soir', 'g', 100, 22, 3.10, 3.30, 0.30, 1.00, 1),
(150, 'Céleri', 'كرفس', 'legumes', 'perte_poids,detox', 'midi,soir', 'g', 100, 16, 0.70, 3.00, 0.20, 1.60, 1),
(151, 'Pomme (moyenne)', 'تفاح', 'fruits', 'perte_poids,diabete,cholesterol', 'matin,collation', 'unité', 1, 52, 0.30, 14.00, 0.20, 2.40, 1),
(152, 'Poire', 'إجاص', 'fruits', 'fibres,constipation', 'matin,collation', 'unité', 1, 57, 0.40, 15.20, 0.10, 3.10, 1),
(153, 'Banane', 'موز', 'fruits', 'sport,prise_masse,potassium', 'matin,collation', 'unité', 1, 89, 1.10, 22.80, 0.30, 2.60, 1),
(154, 'Orange', 'برتقال', 'fruits', 'immunite,perte_poids,vitamine_c', 'matin,collation', 'unité', 1, 47, 0.90, 11.80, 0.10, 2.40, 1),
(155, 'Mandarine', 'مندرين', 'fruits', 'vitamine_c', 'matin,collation', 'g', 100, 53, 0.80, 13.30, 0.30, 1.80, 1),
(156, 'Clémentine', 'كلمنتين', 'fruits', 'vitamine_c,pratique', 'matin,collation', 'g', 100, 47, 0.90, 12.00, 0.20, 1.70, 1),
(157, 'Pamplemousse', 'جريب فروت', 'fruits', 'perte_poids,detox', 'matin', 'g', 100, 42, 0.80, 10.70, 0.10, 1.60, 1),
(158, 'Citron (jus)', 'ليمون', 'fruits', 'detox,vitamine_c', 'matin', 'ml', 200, 29, 1.10, 9.30, 0.30, 2.80, 1),
(159, 'Pêche', 'خوخ', 'fruits', 'perte_poids,hydratation', 'matin,collation', 'unité', 1, 39, 0.90, 9.50, 0.30, 1.50, 1),
(160, 'Nectarine', 'برقوق احمر', 'fruits', 'perte_poids', 'collation', 'g', 100, 44, 1.10, 10.60, 0.30, 1.70, 1),
(161, 'Abricot', 'مشمش', 'fruits', 'vision,fer', 'matin,collation', 'unité', 1, 48, 1.40, 11.10, 0.40, 2.00, 1),
(162, 'Prune', 'برقوق', 'fruits', 'digestion', 'collation', 'g', 100, 46, 0.70, 11.40, 0.30, 1.40, 1),
(163, 'Cerise', 'حب الملوك', 'fruits', 'antioxydant,sport', 'collation', 'g', 100, 63, 1.10, 16.00, 0.20, 2.10, 1),
(164, 'Fraises', 'فراولة', 'fruits', 'perte_poids,diabete,antioxydant', 'matin,collation', 'g', 100, 32, 0.70, 7.70, 0.30, 2.00, 1),
(165, 'Framboises', 'توت العليق', 'fruits', 'antioxydant,fibres', 'matin,collation', 'g', 100, 52, 1.20, 11.90, 0.70, 6.50, 1),
(166, 'Myrtilles', 'توت أزرق', 'fruits', 'antioxydant,cerveau', 'matin,collation', 'g', 100, 57, 0.70, 14.50, 0.30, 2.40, 1),
(167, 'Mûres', 'توت أسود', 'fruits', 'antioxydant,fibres', 'matin,collation', 'g', 100, 43, 1.40, 9.60, 0.50, 5.30, 1),
(168, 'Kiwi', 'كيوي', 'fruits', 'immunite,constipation,vitamine_c', 'matin,collation', 'unité', 1, 61, 1.10, 14.70, 0.50, 3.00, 1),
(169, 'Ananas', 'اناناس', 'fruits', 'digestion,anti_inflammatoire', 'matin,collation', 'g', 100, 50, 0.50, 13.10, 0.10, 1.40, 1),
(170, 'Mangue', 'مانجو', 'fruits', 'vitamine_a,plaisir', 'matin,collation', 'unité', 1, 60, 0.80, 15.00, 0.40, 1.60, 1),
(171, 'Papaye', 'باباي', 'fruits', 'digestion,tropical', 'matin,collation', 'g', 100, 43, 0.50, 11.00, 0.30, 1.70, 1),
(172, 'Raisins', 'عنب', 'fruits', 'prise_masse,energie', 'matin,collation', 'g', 100, 69, 0.70, 18.00, 0.20, 0.90, 1),
(173, 'Figue Fraîche', 'كرموص', 'fruits', 'fibres,energie', 'matin,collation', 'g', 100, 74, 0.80, 19.20, 0.30, 2.90, 1),
(174, 'Dattes (Deglet Nour)', 'تمر', 'fruits', 'sport,prise_masse,energie', 'matin,collation', 'pièce', 3, 282, 2.50, 75.00, 0.40, 8.00, 1),
(175, 'Grenade', 'رمان', 'fruits', 'antioxydant,sport', 'collation', 'unité', 1, 83, 1.70, 18.70, 1.20, 4.00, 1),
(176, 'Pastèque', 'دلاع', 'fruits', 'perte_poids,hydratation,ete', 'collation', 'g', 100, 30, 0.60, 7.60, 0.20, 0.40, 1),
(177, 'Melon', 'بطيخ', 'fruits', 'perte_poids,hydratation', 'collation', 'g', 100, 34, 0.80, 8.20, 0.20, 0.90, 1),
(178, 'Lait Entier (100ml)', 'حليب كامل الدسم', 'laitier', 'calcium,enfants', 'matin', 'ml', 200, 61, 3.20, 4.80, 3.30, 0.00, 1),
(179, 'Lait Demi-Écrémé (100ml)', 'حليب نصف دسم', 'laitier', 'maintien,calcium', 'matin', 'ml', 200, 47, 3.40, 4.90, 1.50, 0.00, 1),
(180, 'Lait Écrémé (100ml)', 'حليب منزوع الدسم', 'laitier', 'perte_poids,calcium', 'matin', 'ml', 200, 34, 3.40, 5.00, 0.10, 0.00, 1),
(181, 'Yaourt Nature (pot)', 'ياغورت طبيعي', 'laitier', 'perte_poids,digestion,probiotiques', 'matin,collation,soir', 'pot', 1, 63, 5.30, 7.00, 1.60, 0.00, 1),
(182, 'Yaourt Grec 0%', 'ياغورت يوناني', 'laitier', 'sport,proteines', 'matin,collation', 'pot', 1, 59, 10.20, 3.60, 0.40, 0.00, 1),
(183, 'Yaourt aux Fruits', 'ياغورت بالفواكه', 'laitier', 'plaisir', 'collation', 'pot', 1, 97, 4.00, 18.60, 0.90, 0.00, 1),
(184, 'Fromage Blanc 0%', 'جبن أبيض 0%', 'laitier', 'perte_poids,sport', 'matin,soir,collation', 'g', 100, 48, 8.00, 3.50, 0.10, 0.00, 1),
(185, 'Fromage Blanc 20%', 'جبن أبيض 20%', 'laitier', 'maintien', 'matin,soir', 'g', 100, 116, 6.80, 3.00, 8.00, 0.00, 1),
(186, 'Fromage Edam', 'جبن أحمر', 'laitier', 'prise_masse,calcium', 'matin', 'g', 100, 357, 25.00, 1.40, 28.00, 0.00, 1),
(187, 'Emmental', 'إيمنتال', 'laitier', 'calcium,proteines', 'matin', 'g', 100, 380, 28.50, 0.40, 29.00, 0.00, 1),
(188, 'Mozzarella', 'موزاريلا', 'laitier', 'pizza,calcium', 'midi', 'g', 100, 280, 28.00, 2.20, 17.00, 0.00, 1),
(189, 'Feta', 'فيتا', 'laitier', 'salade,calcium', 'midi,soir', 'g', 100, 264, 14.20, 4.10, 21.30, 0.00, 1),
(190, 'Ricotta', 'ريكوتا', 'laitier', 'maintien', 'matin', 'g', 100, 174, 11.00, 3.00, 13.00, 0.00, 1),
(191, 'Chèvre Frais', 'جبن ماعز', 'laitier', 'digestion_facile', 'matin,midi', 'g', 100, 268, 18.50, 2.30, 21.10, 0.00, 1),
(192, 'Lben (Verre)', 'لبن', 'laitier', 'digestion,hydratation,probiotiques', 'midi,soir', 'g', 100, 42, 3.00, 4.50, 1.00, 0.00, 1),
(193, 'Raïeb', 'رايب', 'laitier', 'digestion,traditionnel', 'soir', 'g', 100, 52, 3.50, 5.00, 1.50, 0.00, 1),
(194, 'Huile d\'Olive', 'زيت زيتون', 'lipides', 'cholesterol,diabete,maintien,omega9', 'midi,soir,matin', 'c. à s.', 1, 884, 0.00, 0.00, 100.00, 0.00, 1),
(195, 'Huile de Tournesol', 'زيت دوار الشمس', 'lipides', 'cuisson', 'midi,soir', 'c. à s.', 1, 884, 0.00, 0.00, 100.00, 0.00, 1),
(196, 'Huile de Colza', 'زيت كانولا', 'lipides', 'omega3,cholesterol', 'midi,soir', 'c. à s.', 1, 884, 0.00, 0.00, 100.00, 0.00, 1),
(197, 'Amandes (non salées)', 'لوز', 'lipides', 'cholesterol,sport,collation', 'collation', 'poignée', 1, 579, 21.00, 22.00, 50.00, 12.50, 1),
(198, 'Noix', 'الجوز/زوزة', 'lipides', 'cerveau,cholesterol,omega3', 'collation,matin', 'poignée', 1, 654, 15.00, 14.00, 65.00, 6.70, 1),
(199, 'Noisettes', 'بندق', 'lipides', 'energie,cholesterol', 'collation', 'poignée', 1, 628, 15.00, 17.00, 61.00, 9.70, 1),
(200, 'Pistaches', 'فستق', 'lipides', 'proteines,collation', 'collation', 'poignée', 1, 560, 20.00, 28.00, 45.00, 10.60, 1),
(201, 'Cacahuètes', 'كاوكاو', 'lipides', 'proteines,sport', 'collation', 'poignée', 1, 567, 26.00, 16.00, 49.00, 8.50, 1),
(202, 'Noix de Cajou', 'كاجو', 'lipides', 'energie,minerals', 'collation', 'poignée', 1, 553, 18.00, 30.00, 44.00, 3.30, 1),
(203, 'Graines de Tournesol', 'حب دوار الشمس', 'lipides', 'vitamines,minerals', 'collation', 'g', 100, 584, 20.80, 20.00, 51.50, 8.60, 1),
(204, 'Graines de Courge', 'حب القرع', 'lipides', 'zinc,proteines', 'collation', 'g', 100, 559, 30.20, 10.70, 49.00, 6.00, 1),
(205, 'Graines de Chia', 'بذور الشيا', 'lipides', 'omega3,fibres', 'matin,collation', 'g', 100, 486, 16.50, 42.10, 30.70, 34.40, 1),
(206, 'Graines de Lin', 'بذر الكتان', 'lipides', 'omega3,fibres', 'matin', 'g', 100, 534, 18.30, 29.00, 42.20, 27.30, 1),
(207, 'Avocat', 'أفوكادو', 'lipides', 'prise_masse,cholesterol,omega9', 'matin,midi,soir', 'g', 100, 160, 2.00, 8.50, 14.70, 6.70, 1),
(208, 'Beurre de Cacahuète', 'زبدة الفول السوداني', 'lipides', 'prise_masse,sport', 'matin,collation', 'poignée', 1, 588, 25.00, 20.00, 50.00, 6.00, 1),
(209, 'Tahini (Tahiné)', 'طحينة', 'lipides', 'calcium,traditonnel', 'matin,midi', 'g', 100, 595, 17.00, 21.00, 53.00, 9.30, 1),
(210, 'Olives Noires', 'زيتون أسود', 'lipides', 'antioxydant,traditonnel', 'midi,soir', 'g', 100, 115, 0.80, 6.30, 10.70, 3.20, 1),
(211, 'Olives Vertes', 'زيتون أخضر', 'lipides', 'antioxydant,traditonnel', 'midi,soir', 'g', 100, 145, 1.00, 3.80, 15.30, 3.30, 1),
(212, 'Brik à l\'oeuf (frit)', 'بريك', 'traditionnel', 'prise_masse,plaisir', 'soir', 'pièce', 1, 280, 8.00, 25.00, 18.00, 1.00, 1),
(213, 'Brik au Thon', 'بريك بالتن', 'traditionnel', 'plaisir', 'soir', 'pièce', 1, 265, 10.00, 24.00, 16.00, 1.00, 1),
(214, 'Ojja Merguez', 'عجة مرقاز', 'traditionnel', 'maintien,plaisir', 'matin,midi', 'g', 100, 180, 10.00, 8.00, 14.00, 2.00, 1),
(215, 'Ojja aux Crevettes', 'عجة بالجمبري', 'traditionnel', 'proteines,mer', 'midi', 'g', 100, 140, 12.00, 8.00, 8.00, 2.00, 1),
(216, 'Couscous au Poulet (portion)', 'كسكسي بالدجاج', 'traditionnel', 'complet,famille', 'midi', 'g', 100, 180, 12.00, 25.00, 5.00, 3.00, 1),
(217, 'Couscous à l\'Agneau', 'كسكسي بلحم الخروف', 'traditionnel', 'prise_masse,famille', 'midi', 'ml', 200, 220, 14.00, 26.00, 8.00, 3.00, 1),
(218, 'Salade Mechouia (huile)', 'سلطة مشوية', 'traditionnel', 'maintien,fibres,vitamines', 'midi,soir', 'c. à s.', 1, 120, 3.00, 8.00, 10.00, 4.00, 1),
(219, 'Slata Tounsia', 'سلطة تونسية', 'traditionnel', 'perte_poids,ete,fraicheur', 'midi,soir', 'g', 100, 90, 2.00, 6.00, 7.00, 2.00, 1),
(220, 'Salade de Poivrons', 'سلطة فلفل', 'traditionnel', 'antioxydant,huile_olive', 'midi,soir', 'g', 100, 110, 2.00, 9.00, 8.00, 3.00, 1),
(221, 'Lablabi (bol)', 'لبلابي', 'traditionnel', 'prise_masse,hiver,energie', 'matin', 'g', 100, 350, 15.00, 45.00, 12.00, 10.00, 1),
(222, 'Chorba Frik', 'شربة فريك', 'traditionnel', 'perte_poids,soir,digestion', 'soir', 'g', 100, 80, 4.00, 12.00, 3.00, 2.00, 1),
(223, 'Chorba (Soupe)', 'شربة', 'traditionnel', 'facile,soir', 'soir', 'g', 100, 65, 3.50, 8.00, 2.50, 1.50, 1),
(224, 'Kamounia', 'كمونية', 'traditionnel', 'maintien,epices', 'midi', 'g', 100, 160, 18.00, 4.00, 9.00, 1.00, 1),
(225, 'Mlourhia', 'ملوخية', 'traditionnel', 'fer,tradition,vitamines', 'midi', 'g', 100, 190, 8.00, 10.00, 15.00, 5.00, 1),
(226, 'Masfouf (avec fruits secs)', 'مسفوف', 'traditionnel', 'prise_masse,energie,fetes', 'matin,collation', 'g', 100, 380, 6.00, 65.00, 12.00, 5.00, 1),
(227, 'Assida Zgougou', 'عصيدة زقوقو', 'traditionnel', 'tradition,hiver', 'matin', 'g', 100, 320, 5.00, 58.00, 9.00, 2.00, 1),
(228, 'Tajine Tunisien (morceau)', 'طاجين', 'traditionnel', 'maintien,picnic,fetes', 'midi', 'ml', 200, 260, 15.00, 10.00, 18.00, 1.00, 1),
(229, 'Fricassé', 'فريكاسي', 'traditionnel', 'plaisir,street_food', 'matin,collation', 'g', 100, 295, 8.00, 38.00, 13.00, 2.00, 1),
(230, 'Makroudh (pièce)', 'مقروض', 'traditionnel', 'fetes,energie', 'collation', 'g', 100, 420, 5.00, 58.00, 19.00, 2.00, 1),
(231, 'Harissa (1 cuillère)', 'هريسة', 'traditionnel', 'epices,saveur', 'midi,soir', 'g', 100, 50, 2.00, 7.00, 2.00, 3.00, 1),
(232, 'Mechouia (sans huile)', 'مشوية', 'traditionnel', 'perte_poids', 'midi,soir', 'c. à s.', 1, 45, 2.00, 8.00, 1.00, 3.00, 1),
(233, 'Eau (1L)', 'ماء', 'boissons', 'hydratation,tout,essentiel', 'matin,midi,soir,collation', 'ml', 200, 0, 0.00, 0.00, 0.00, 0.00, 1),
(234, 'Eau Gazeuse', 'ماء غازي', 'boissons', 'hydratation,digestion', 'midi,soir', 'ml', 200, 0, 0.00, 0.00, 0.00, 0.00, 1),
(235, 'Thé Vert (sans sucre)', 'شاي أخضر', 'boissons', 'perte_poids,antioxydant,detox', 'matin,collation', 'ml', 200, 1, 0.00, 0.00, 0.00, 0.00, 1),
(236, 'Thé Noir (sans sucre)', 'شاي أسود', 'boissons', 'energie,tradition', 'matin,soir', 'ml', 200, 1, 0.00, 0.20, 0.00, 0.00, 1),
(237, 'Thé à la Menthe', 'أتاي بالنعناع', 'boissons', 'digestion,tradition', 'midi,soir', 'ml', 200, 2, 0.00, 0.50, 0.00, 0.00, 1),
(238, 'Café Noir (sans sucre)', 'قهوة كحلة', 'boissons', 'energie,sport,concentration', 'matin', 'ml', 200, 2, 0.30, 0.00, 0.00, 0.00, 1),
(239, 'Café au Lait', 'قهوة بالحليب', 'boissons', 'energie', 'matin', 'ml', 200, 38, 2.00, 3.00, 2.00, 0.00, 1),
(240, 'Expresso', 'اكسبريسو', 'boissons', 'energie', 'matin', 'ml', 200, 2, 0.10, 0.00, 0.00, 0.00, 1),
(241, 'Jus d\'Orange Frais', 'عصير برتقال', 'boissons', 'vitamines,plaisir,vitamine_c', 'matin', 'ml', 200, 45, 0.70, 10.40, 0.20, 0.20, 1),
(242, 'Jus de Pomme', 'عصير تفاح', 'boissons', 'vitamines', 'matin,collation', 'ml', 200, 46, 0.10, 11.30, 0.10, 0.20, 1),
(243, 'Jus de Grenade', 'عصير رمان', 'boissons', 'antioxydant', 'collation', 'ml', 200, 54, 0.40, 13.70, 0.30, 0.00, 1),
(244, 'Smoothie Fruits Rouges', 'سموزي توت', 'boissons', 'antioxydant,sport', 'matin,collation', 'ml', 200, 65, 1.50, 14.00, 0.50, 2.00, 1),
(245, 'Smoothie Vert', 'سموزي أخضر', 'boissons', 'detox,vitamines', 'matin', 'ml', 200, 42, 1.80, 8.00, 0.30, 2.50, 1),
(246, 'Barre de Céréales', 'بار حبوب', 'collation', 'sport,pratique', 'collation', 'pièce', 1, 420, 7.00, 65.00, 14.00, 4.00, 1),
(247, 'Barre Protéinée', 'بار بروتين', 'collation', 'sport,musculation', 'collation', 'pièce', 1, 380, 20.00, 40.00, 12.00, 3.00, 1),
(248, 'Crackers Complets', 'بسكويت كامل', 'collation', 'fibres', 'collation', 'g', 100, 440, 10.00, 68.00, 13.00, 5.00, 1),
(249, 'Biscottes', 'بسكوت محمص', 'collation', 'pratique', 'matin,collation', 'g', 100, 394, 11.00, 75.00, 5.00, 4.00, 1),
(250, 'Chocolat Noir 70%', 'شوكولاتة سوداء', 'collation', 'antioxydant,plaisir', 'collation', 'g', 100, 546, 7.80, 45.90, 35.00, 10.90, 1),
(251, 'Chocolat au Lait', 'شوكولاتة بالحليب', 'collation', 'plaisir', 'collation', 'ml', 200, 535, 8.00, 59.00, 30.00, 3.00, 1),
(252, 'Miel', 'عسل', 'collation', 'energie,immunite,naturel', 'matin', 'c. à s.', 1, 304, 0.30, 82.00, 0.00, 0.20, 1),
(253, 'Confiture', 'مربى', 'collation', 'plaisir', 'matin', 'c. à s.', 1, 278, 0.40, 69.00, 0.10, 1.00, 1),
(254, 'Protéine Whey (30g)', 'مسحوق بروتين', 'supplement', 'sport,musculation', 'matin,soir', 'g', 100, 120, 24.00, 3.00, 1.50, 0.00, 1),
(255, 'Spiruline (10g)', 'سبيرولينا', 'supplement', 'proteines,vegan,fer', 'matin', 'g', 100, 29, 5.70, 2.40, 0.80, 0.30, 1),
(256, 'Son d\'Avoine', 'نخالة الشوفان', 'supplement', 'fibres,cholesterol', 'matin', 'g', 100, 246, 17.30, 66.20, 7.00, 15.40, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `aliments`
--
ALTER TABLE `aliments`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `aliments`
--
ALTER TABLE `aliments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=257;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
