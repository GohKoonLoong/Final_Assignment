-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jul 20, 2023 at 08:30 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.0.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `barterlt_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_cards`
--

CREATE TABLE `tbl_cards` (
  `user_id` int(5) NOT NULL,
  `bank_name` varchar(50) NOT NULL,
  `card_number` varchar(40) NOT NULL,
  `card_expiry` varchar(10) NOT NULL,
  `card_cvv` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_cards`
--

INSERT INTO `tbl_cards` (`user_id`, `bank_name`, `card_number`, `card_expiry`, `card_cvv`) VALUES
(1, 'Public Bank', '2000 4000 3000 1000', '02/28', 'a29a915763340588bf154e0ebd7f38bc6f9beb47');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_carts`
--

CREATE TABLE `tbl_carts` (
  `cart_id` int(5) NOT NULL,
  `item_id` varchar(5) NOT NULL,
  `cart_price` float NOT NULL,
  `cart_qty` int(5) NOT NULL,
  `user_id` varchar(5) NOT NULL,
  `uploader_id` varchar(5) NOT NULL,
  `cart_date` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_carts`
--

INSERT INTO `tbl_carts` (`cart_id`, `item_id`, `cart_price`, `cart_qty`, `user_id`, `uploader_id`, `cart_date`) VALUES
(3, '12', 250, 1, '1', '2', '2023-07-21 01:53:01.376558');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_items`
--

CREATE TABLE `tbl_items` (
  `item_id` int(5) NOT NULL,
  `user_id` int(5) NOT NULL,
  `item_name` varchar(50) NOT NULL,
  `item_desc` varchar(255) NOT NULL,
  `item_type` varchar(50) NOT NULL,
  `item_lat` varchar(50) NOT NULL,
  `item_long` varchar(50) NOT NULL,
  `item_state` varchar(50) NOT NULL,
  `item_locality` varchar(50) NOT NULL,
  `item_date` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `item_interested` varchar(50) NOT NULL,
  `market_value` float NOT NULL,
  `images_num` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_items`
--

INSERT INTO `tbl_items` (`item_id`, `user_id`, `item_name`, `item_desc`, `item_type`, `item_lat`, `item_long`, `item_state`, `item_locality`, `item_date`, `item_interested`, `market_value`, `images_num`) VALUES
(1, 1, 'Nike Running Shoes', 'Men wear', 'Shoes', '6.4318283', '100.4299967', 'Kedah', 'Changlun', '2023-07-20 22:40:34', 'Puma Running Shoes', 350, 1),
(2, 1, 'Black Shoes', 'Brand New', 'Shoes', '6.4318283', '100.4299967', 'Kedah', 'Changlun', '2023-07-20 22:41:23', 'White Shoes', 200, 4),
(3, 1, 'PS4 Games Bundle', 'Condition 10/10', 'Shoes', '6.4318283', '100.4299967', 'Kedah', 'Changlun', '2023-07-20 22:42:36', 'None', 200, 3),
(4, 1, 'PS4 Games', 'Free Painting', 'Video Games', '6.4318283', '100.4299967', 'Kedah', 'Changlun', '2023-07-20 22:43:55', 'Other Games', 10, 3),
(5, 1, 'Brand New Chair', 'Made in China', 'Furniture', '6.4318283', '100.4299967', 'Kedah', 'Changlun', '2023-07-20 22:44:46', 'Stool', 50, 1),
(6, 1, 'Outdoor Camping Chair', 'Comfortable', 'Furniture', '6.4318283', '100.4299967', 'Kedah', 'Changlun', '2023-07-20 22:45:33', 'Outdoor Tent', 100, 2),
(7, 1, 'Drones', 'Good Condition', 'Others', '6.4318283', '100.4299967', 'Kedah', 'Changlun', '2023-07-20 22:46:15', 'None', 550, 2),
(8, 1, 'Sony and Fuji Camera', 'Both in good condition', 'Others', '6.4318283', '100.4299967', 'Kedah', 'Changlun', '2023-07-20 22:47:18', 'Mobile phone', 150, 3),
(9, 1, 'Coat', 'Still New', 'Shoes', '6.4318283', '100.4299967', 'Kedah', 'Changlun', '2023-07-20 22:50:08', 'nothing', 30, 1),
(10, 1, 'Hoodies', 'Wear once only', 'Shoes', '6.4318283', '100.4299967', 'Kedah', 'Changlun', '2023-07-20 22:50:46', 'none', 45, 1),
(11, 2, 'Prad Handbag', 'Brand New', 'Others', '6.4318283', '100.4299967', 'Kedah', 'Changlun', '2023-07-20 22:52:02', 'None', 350, 1),
(12, 2, 'Sony Television', 'Still in good condition', 'Shoes', '6.4318283', '100.4299967', 'Kedah', 'Changlun', '2023-07-20 22:52:45', 'Nothing', 250, 2),
(13, 2, 'Jacquemus slingbag', 'Two different colour', 'Others', '6.4318283', '100.4299967', 'Kedah', 'Changlun', '2023-07-20 22:53:36', 'Bagpack', 400, 2),
(16, 2, 'Coach Bag', 'Brand New', 'Others', '6.4318283', '100.4299967', 'Kedah', 'Changlun', '2023-07-20 22:56:05', 'LV Bag', 1000, 3),
(17, 2, 'LG Television', 'Still got warranty', 'Others', '6.4318283', '100.4299967', 'Kedah', 'Changlun', '2023-07-20 22:56:58', 'None', 350, 3),
(18, 2, 'Package A', 'Got one T-shirt, handbag and Baju Melayu', 'Others', '6.4318283', '100.4299967', 'Kedah', 'Changlun', '2023-07-20 22:58:13', 'Nothing', 200, 3),
(19, 2, 'Camera Lens', 'Still New', 'Tools', '6.4318283', '100.4299967', 'Kedah', 'Changlun', '2023-07-20 22:58:46', 'None', 200, 2),
(20, 1, '2010 Black Mercedes E250 CGI-W212', 'Second Hand', 'Car', '37.4226711', '-122.0849872', 'California', 'Mountain View', '2023-07-21 00:33:50', 'BMW', 50000, 7);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_orders`
--

CREATE TABLE `tbl_orders` (
  `order_id` int(5) NOT NULL,
  `order_bill` varchar(8) NOT NULL,
  `item_id` int(5) NOT NULL,
  `order_paid` float NOT NULL,
  `user_id` varchar(5) NOT NULL,
  `uploader_id` varchar(5) NOT NULL,
  `order_date` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `order_status` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_orders`
--

INSERT INTO `tbl_orders` (`order_id`, `order_bill`, `item_id`, `order_paid`, `user_id`, `uploader_id`, `order_date`, `order_status`) VALUES
(1, 'hsT00M36', 15, 50, '1', '2', '2023-07-21 00:50:34.952943', 'New'),
(2, 'n4b948F3', 14, 50, '1', '2', '2023-07-21 01:52:27.331510', 'New');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(5) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `user_phone` varchar(12) NOT NULL,
  `user_password` varchar(40) NOT NULL,
  `user_otp` varchar(6) NOT NULL,
  `user_datereg` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_email`, `user_name`, `user_phone`, `user_password`, `user_otp`, `user_datereg`) VALUES
(1, 'gohkoonloong01@gmail.com', 'Goh Koon Loong', '0185755357', 'a95d89e5935ecdba19b66318c745a0bbcedda4f5', '39841', '2023-06-13 03:31:15'),
(2, 'ngshiqing0216@gmail.com', 'Ng Shi Qing', '0105025999', '53db1987e680ce04831e3ab11535f07fd0eb9f66', '48434', '2023-07-04 17:57:07'),
(3, 'phantom@gmail.com', 'Phantom', '0102030401', 'da39a3ee5e6b4b0d3255bfef95601890afd80709', '75807', '2023-07-06 15:30:56');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_cards`
--
ALTER TABLE `tbl_cards`
  ADD PRIMARY KEY (`card_number`);

--
-- Indexes for table `tbl_carts`
--
ALTER TABLE `tbl_carts`
  ADD PRIMARY KEY (`cart_id`);

--
-- Indexes for table `tbl_items`
--
ALTER TABLE `tbl_items`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `tbl_orders`
--
ALTER TABLE `tbl_orders`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_email` (`user_email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_carts`
--
ALTER TABLE `tbl_carts`
  MODIFY `cart_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tbl_items`
--
ALTER TABLE `tbl_items`
  MODIFY `item_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `tbl_orders`
--
ALTER TABLE `tbl_orders`
  MODIFY `order_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
