-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th5 26, 2025 lúc 01:40 PM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `training`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `classes`
--

CREATE TABLE `classes` (
  `id` int(11) NOT NULL,
  `class_name` varchar(255) NOT NULL,
  `course_id` int(11) DEFAULT NULL,
  `semester` varchar(50) NOT NULL,
  `academic_year` varchar(10) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `schedule_info` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `max_students` int(11) DEFAULT 30,
  `status` enum('Upcoming','Active','Completed','Cancelled') DEFAULT 'Upcoming',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `classes`
--

INSERT INTO `classes` (`id`, `class_name`, `course_id`, `semester`, `academic_year`, `start_date`, `end_date`, `schedule_info`, `location`, `max_students`, `status`, `notes`, `created_at`, `updated_at`) VALUES
(1, 'Math 101', 1, 'Fall', '2024-2025', '2024-09-01', '2024-12-15', 'Mon-Wed-Fri 08:00-10:00', 'Room A1', 30, 'Upcoming', 'Basic math course.', '2025-05-21 09:43:11', '2025-05-21 09:48:17'),
(2, 'English 201', 2, 'Fall', '2024-2025', '2024-09-01', '2024-12-20', 'Tue-Thu 09:00-11:00', 'Room B2', 30, 'Upcoming', 'Advanced English class.', '2025-05-21 09:43:11', '2025-05-21 09:48:22'),
(3, 'Physics 301', 3, 'Spring', '2024-2025', '2025-01-10', '2025-05-10', 'Mon-Wed 13:00-15:00', 'Room C3', 30, 'Upcoming', 'Physics with lab work.', '2025-05-21 09:43:11', '2025-05-21 09:48:25'),
(4, 'CS 101', 4, 'Spring', '2024-2025', '2025-01-10', '2025-04-30', 'Tue-Thu 14:00-16:00', 'Lab 101', 25, 'Upcoming', 'Intro to programming.', '2025-05-21 09:43:11', '2025-05-21 09:48:30'),
(5, 'Biology 202', 5, 'Summer', '2024-2025', '2025-06-01', '2025-08-15', 'Mon-Wed-Fri 10:00-12:00', 'Room D4', 30, 'Upcoming', 'Human biology focus.', '2025-05-21 09:43:11', '2025-05-21 09:48:40');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `courses`
--

CREATE TABLE `courses` (
  `id` int(11) NOT NULL,
  `course_name` varchar(255) NOT NULL,
  `course_description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `course_code` varchar(50) NOT NULL,
  `prerequisites` text DEFAULT NULL,
  `department` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `credits` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `courses`
--

INSERT INTO `courses` (`id`, `course_name`, `course_description`, `created_at`, `course_code`, `prerequisites`, `department`, `is_active`, `credits`) VALUES
(1, 'English', 'ka', '2025-05-21 09:39:36', '101', '01', 'Eng', 1, 3),
(2, 'math', 'ht', '2025-05-21 09:39:57', 'Math', '102', 'computer', 1, 5),
(3, 'Physical', 'ưeee', '2025-05-21 09:40:31', '103', '104', 'rh', 1, 6),
(4, 'yyyewe', 'ưq', '2025-05-21 09:41:04', 'Computer Science', '106', 'ew', 1, 5),
(5, 'Biology', 'eqw', '2025-05-21 09:41:42', '107', '111', 'pA', 1, 7);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `course_registrations`
--

CREATE TABLE `course_registrations` (
  `registration_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `student_name` varchar(255) NOT NULL,
  `course_id` int(11) NOT NULL,
  `course_name` varchar(255) NOT NULL,
  `class_id` int(11) NOT NULL,
  `class_name` varchar(255) NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `request_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `processed_date` timestamp NULL DEFAULT NULL,
  `processed_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `course_registrations`
--

INSERT INTO `course_registrations` (`registration_id`, `student_id`, `student_name`, `course_id`, `course_name`, `class_id`, `class_name`, `status`, `request_date`, `processed_date`, `processed_by`) VALUES
(1, 101, 'Nguyen Van A', 1, 'Introduction to Programming', 101, 'CS 101', 'pending', '2025-05-21 10:05:52', NULL, NULL),
(2, 102, 'Tran Thi B', 2, 'Data Structures', 201, 'CS 201', 'pending', '2025-05-21 10:05:52', NULL, NULL),
(3, 103, 'Le Van C', 3, 'Database Systems', 301, 'CS 301', 'approved', '2025-05-21 10:05:52', NULL, NULL),
(4, 104, 'Pham Thi D', 4, 'Algorithms', 401, 'CS 401', 'rejected', '2025-05-21 10:05:52', NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `curriculum`
--

CREATE TABLE `curriculum` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `type` enum('framework','lesson','resource','material','equipment') NOT NULL DEFAULT 'lesson',
  `course_id` int(11) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `curriculum`
--

INSERT INTO `curriculum` (`id`, `title`, `description`, `type`, `course_id`, `content`, `file_path`, `is_active`, `created_at`, `updated_at`) VALUES
(2, 'dsD', 'rư', 'material', NULL, 'ửu', 'link', 1, '2025-05-16 21:59:09', '2025-05-16 21:59:09'),
(3, 'hieu', 'dz', 'resource', NULL, 'zd', 'src', 0, '2025-05-20 03:45:10', '2025-05-20 03:52:25'),
(4, 'te', 'fe', 'resource', NULL, 'g', 'jy', 1, '2025-05-20 03:46:49', '2025-05-20 03:48:52');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `grades`
--

CREATE TABLE `grades` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `class_id` int(11) NOT NULL,
  `final_grade` decimal(5,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `grades`
--

INSERT INTO `grades` (`id`, `student_id`, `class_id`, `final_grade`, `created_at`) VALUES
(1, 1, 1, 8.50, '2025-05-21 09:50:57'),
(2, 2, 2, 7.80, '2025-05-21 09:50:57'),
(3, 3, 3, 9.20, '2025-05-21 09:50:57'),
(4, 4, 4, 8.20, '2025-05-21 09:50:57'),
(5, 5, 5, 8.90, '2025-05-21 09:50:57');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `target_group` varchar(50) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'Scheduled',
  `priority` varchar(20) NOT NULL DEFAULT 'normal',
  `attachment_url` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `send_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `notifications`
--

INSERT INTO `notifications` (`notification_id`, `title`, `message`, `target_group`, `status`, `priority`, `attachment_url`, `created_at`, `send_date`) VALUES
(11, 'srfb', 'sbf', 'Teachers', 'Sent', 'high', 'linkkk', '2025-05-16 21:35:41', '2025-05-16 21:35:41'),
(12, 'nơ', 'ềwfe', 'Students', 'Sent', 'high', 'lop truong', '2025-05-21 08:06:33', '2025-05-21 08:06:33');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `regulations`
--

CREATE TABLE `regulations` (
  `regulation_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `category` varchar(100) NOT NULL DEFAULT 'General',
  `description` text DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `effective_date` date NOT NULL,
  `expiry_date` date DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `file_reference` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `regulations`
--

INSERT INTO `regulations` (`regulation_id`, `title`, `category`, `description`, `content`, `effective_date`, `expiry_date`, `is_active`, `file_reference`, `created_at`, `updated_at`) VALUES
(1, 'no smoking', 'Attendance', 'we', 'ajewkle', '2025-05-21', '2025-05-31', 1, 'link', '2025-05-21 14:50:42', '2025-05-21 17:21:55');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `retake_courses`
--

CREATE TABLE `retake_courses` (
  `registration_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `student_name` varchar(255) NOT NULL,
  `course_id` int(11) NOT NULL,
  `course_name` varchar(255) NOT NULL,
  `class_id` int(11) DEFAULT NULL,
  `class_name` varchar(255) DEFAULT NULL,
  `previous_grade` varchar(10) NOT NULL,
  `semester` varchar(50) NOT NULL,
  `academic_year` varchar(10) NOT NULL,
  `reason` text NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `request_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `processed_date` timestamp NULL DEFAULT NULL,
  `processed_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `retake_courses`
--

INSERT INTO `retake_courses` (`registration_id`, `student_id`, `student_name`, `course_id`, `course_name`, `class_id`, `class_name`, `previous_grade`, `semester`, `academic_year`, `reason`, `status`, `request_date`, `processed_date`, `processed_by`) VALUES
(1, 101, 'Nguyen Van A', 1, 'Calculus', 101, 'Math 101', 'D', 'Spring', '2024-2025', 'Need to improve grade for scholarship', 'pending', '2025-05-21 10:05:00', NULL, NULL),
(2, 102, 'Tran Thi B', 2, 'Physics', 201, 'Physics 201', 'F', 'Spring', '2024-2025', 'Failed the course, need to retake', 'pending', '2025-05-21 10:05:00', NULL, NULL),
(3, 103, 'Le Van C', 3, 'Chemistry', 301, 'Chem 101', 'C', 'Spring', '2024-2025', 'Want to improve GPA', 'approved', '2025-05-21 10:05:00', NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `retake_exams`
--

CREATE TABLE `retake_exams` (
  `registration_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `student_name` varchar(255) NOT NULL,
  `course_id` int(11) NOT NULL,
  `course_name` varchar(255) NOT NULL,
  `exam_id` int(11) NOT NULL,
  `exam_name` varchar(255) NOT NULL,
  `previous_grade` varchar(10) NOT NULL,
  `reason` text NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `request_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `processed_date` timestamp NULL DEFAULT NULL,
  `processed_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `retake_exams`
--

INSERT INTO `retake_exams` (`registration_id`, `student_id`, `student_name`, `course_id`, `course_name`, `exam_id`, `exam_name`, `previous_grade`, `reason`, `status`, `request_date`, `processed_date`, `processed_by`) VALUES
(1, 101, 'Nguyen Van A', 1, 'Calculus', 1001, 'Final Exam', 'D', 'Did not perform well in final exam', 'pending', '2025-05-21 10:05:33', NULL, NULL),
(2, 102, 'Tran Thi B', 2, 'Physics', 2001, 'Midterm Exam', 'F', 'Was sick during exam', 'pending', '2025-05-21 10:05:33', NULL, NULL),
(3, 103, 'Le Van C', 3, 'Chemistry', 3001, 'Practical Exam', 'C', 'Need higher grade for major requirement', 'approved', '2025-05-21 10:05:33', NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `students`
--

CREATE TABLE `students` (
  `id` int(11) NOT NULL,
  `student_name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `students`
--

INSERT INTO `students` (`id`, `student_name`, `email`, `phone`, `created_at`) VALUES
(1, 'Alice Nguyen', 'alice@example.com', '0905123456', '2025-05-21 09:46:44'),
(2, 'Bob Tran', 'bob@example.com', '0911222333', '2025-05-21 09:46:44'),
(3, 'Charlie Le', 'charlie@example.com', '0922333444', '2025-05-21 09:46:44'),
(4, 'David Pham', 'david@example.com', '0933444555', '2025-05-21 09:46:44'),
(5, 'Emma Vo', 'emma@example.com', '0944555666', '2025-05-21 09:46:44');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `teachers`
--

CREATE TABLE `teachers` (
  `teacher_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  `qualification` varchar(100) DEFAULT NULL,
  `join_date` date DEFAULT NULL,
  `status` enum('Active','Inactive','On Leave') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `teachers`
--

INSERT INTO `teachers` (`teacher_id`, `name`, `email`, `phone`, `department`, `qualification`, `join_date`, `status`, `created_at`, `updated_at`) VALUES
(1, 'John Smith', 'john.smith@example.com', '1234567890', 'Computer Science', 'PhD in Computer Science', '2020-01-15', 'Active', '2025-05-19 11:14:14', '2025-05-19 11:14:14'),
(2, 'Mary Johnson', 'mary.johnson@example.com', '2345678901', 'Mathematics', 'MSc in Mathematics', '2019-05-20', 'Active', '2025-05-19 11:14:14', '2025-05-19 11:14:14'),
(3, 'David Lee', 'david.lee@example.com', '3456789012', 'Physics', 'PhD in Physics', '2021-03-10', 'Active', '2025-05-19 11:14:14', '2025-05-19 11:14:14'),
(4, 'Sarah Williams', 'sarah.williams@example.com', '4567890123', 'English', 'MA in English Literature', '2018-09-01', 'On Leave', '2025-05-19 11:14:14', '2025-05-19 11:14:14'),
(5, 'Robert Brown', 'robert.brown@example.com', '5678901234', 'History', 'PhD in History', '2020-11-05', 'Active', '2025-05-19 11:14:14', '2025-05-19 11:14:14');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `teacher_assignments`
--

CREATE TABLE `teacher_assignments` (
  `assignment_id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `class_id` int(11) NOT NULL,
  `assignment_type` enum('Primary','Substitute','Assistant','Guest Lecturer') NOT NULL DEFAULT 'Primary',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `hours_per_week` decimal(5,2) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `teacher_assignments`
--

INSERT INTO `teacher_assignments` (`assignment_id`, `teacher_id`, `class_id`, `assignment_type`, `start_date`, `end_date`, `hours_per_week`, `notes`, `created_at`, `updated_at`) VALUES
(20, 2, 2, 'Primary', '2023-09-01', '2023-12-20', 8.00, 'Responsible for all lectures', '2025-05-19 11:18:59', '2025-05-19 11:18:59'),
(21, 3, 3, 'Primary', '2023-09-01', '2023-12-20', 12.00, NULL, '2025-05-19 11:18:59', '2025-05-19 11:18:59'),
(22, 1, 3, 'Substitute', '2025-05-19', '2025-06-06', 11.00, 'newss', '2025-05-19 11:19:55', '2025-05-19 11:19:55'),
(24, 5, 2, 'Substitute', '2025-05-20', '2025-05-30', 4.00, 'ko', '2025-05-20 03:23:04', '2025-05-20 03:23:04');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `teaching_schedule`
--

CREATE TABLE `teaching_schedule` (
  `id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `teacher_name` varchar(255) NOT NULL,
  `class_id` int(11) NOT NULL,
  `class_name` varchar(255) NOT NULL,
  `course_id` int(11) NOT NULL,
  `course_name` varchar(255) NOT NULL,
  `course_type` varchar(50) NOT NULL COMMENT 'lecture, lab, seminar, workshop, exam',
  `schedule_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `semester` varchar(50) NOT NULL,
  `academic_year` varchar(10) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `teaching_schedule`
--

INSERT INTO `teaching_schedule` (`id`, `teacher_id`, `teacher_name`, `class_id`, `class_name`, `course_id`, `course_name`, `course_type`, `schedule_date`, `start_time`, `end_time`, `location`, `semester`, `academic_year`, `created_at`, `updated_at`) VALUES
(1, 1, 'John Smith', 101, 'CS 101', 1, 'Introduction to Programming', 'lecture', '2025-05-19', '08:00:00', '09:30:00', 'Room 101', 'Spring', '2024-2025', '2025-05-21 07:47:17', '2025-05-21 07:47:17'),
(2, 1, 'John Smith', 102, 'CS 201', 2, 'Data Structures', 'lab', '2025-05-19', '10:00:00', '12:00:00', 'Lab A', 'Spring', '2024-2025', '2025-05-21 07:47:17', '2025-05-21 07:47:17'),
(3, 2, 'Mary Johnson', 201, 'Math 101', 3, 'Calculus I', 'lecture', '2025-05-20', '09:00:00', '10:30:00', 'Room 202', 'Spring', '2024-2025', '2025-05-21 07:47:17', '2025-05-21 07:47:17'),
(4, 2, 'Mary Johnson', 202, 'Math 201', 4, 'Linear Algebra', 'seminar', '2025-05-21', '13:00:00', '14:30:00', 'Room 205', 'Spring', '2024-2025', '2025-05-21 07:47:17', '2025-05-21 07:47:17'),
(5, 3, 'David Lee', 301, 'HIST 101', 5, 'World History', 'lecture', '2025-05-20', '11:00:00', '12:30:00', 'Room 301', 'Spring', '2024-2025', '2025-05-21 07:47:17', '2025-05-21 07:47:17'),
(6, 4, 'Sarah Williams', 401, 'CHEM 101', 6, 'General Chemistry', 'lecture', '2025-05-21', '08:00:00', '09:30:00', 'Room 401', 'Spring', '2024-2025', '2025-05-21 07:47:17', '2025-05-21 07:47:17'),
(7, 4, 'Sarah Williams', 402, 'CHEM 101', 6, 'General Chemistry', 'lab', '2025-05-21', '10:00:00', '12:00:00', 'Lab C', 'Spring', '2024-2025', '2025-05-21 07:47:17', '2025-05-21 07:47:17'),
(8, 5, 'Robert Brown', 501, 'ECON 101', 7, 'Principles of Economics', 'lecture', '2025-05-22', '09:00:00', '10:30:00', 'Room 501', 'Spring', '2024-2025', '2025-05-21 07:47:17', '2025-05-21 07:47:17'),
(9, 6, 'Michael Wilson', 601, 'PSY 101', 8, 'Introduction to Psychology', 'lecture', '2025-05-22', '11:00:00', '12:30:00', 'Room 601', 'Spring', '2024-2025', '2025-05-21 07:47:17', '2025-05-21 07:47:17'),
(10, 7, 'Jennifer Taylor', 103, 'CS 301', 9, 'Database Systems', 'lecture', '2025-05-23', '08:00:00', '09:30:00', 'Room 103', 'Spring', '2024-2025', '2025-05-21 07:47:17', '2025-05-21 07:47:17'),
(11, 7, 'Jennifer Taylor', 104, 'CS 301', 9, 'Database Systems', 'workshop', '2025-05-23', '10:00:00', '12:00:00', 'Lab B', 'Spring', '2024-2025', '2025-05-21 07:47:17', '2025-05-21 07:47:17'),
(12, 8, 'Thomas Anderson', 203, 'Math 301', 10, 'Discrete Mathematics', 'lecture', '2025-05-23', '13:00:00', '14:30:00', 'Room 203', 'Spring', '2024-2025', '2025-05-21 07:47:17', '2025-05-21 07:47:17'),
(13, 9, 'Lisa Martinez', 701, 'PHYS 101', 11, 'General Physics', 'lecture', '2025-05-24', '09:00:00', '10:30:00', 'Room 701', 'Spring', '2024-2025', '2025-05-21 07:47:17', '2025-05-21 07:47:17'),
(14, 9, 'Lisa Martinez', 702, 'PHYS 101', 11, 'General Physics', 'lab', '2025-05-24', '11:00:00', '13:00:00', 'Lab D', 'Spring', '2024-2025', '2025-05-21 07:47:17', '2025-05-21 07:47:17'),
(15, 10, 'Emily Johnson', 204, 'Math 202', 12, 'Probability & Statistics', 'lecture', '2025-05-24', '14:00:00', '15:30:00', 'Room 204', 'Spring', '2024-2025', '2025-05-21 07:47:17', '2025-05-21 07:47:17'),
(16, 11, 'Michael Brown', 703, 'PHYS 201', 13, 'Modern Physics', 'seminar', '2025-05-19', '14:00:00', '16:00:00', 'Room 703', 'Spring', '2024-2025', '2025-05-21 07:47:17', '2025-05-21 07:47:17');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `test_scores`
--

CREATE TABLE `test_scores` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `class_id` int(11) NOT NULL,
  `test_type` varchar(50) NOT NULL,
  `score` decimal(5,2) NOT NULL,
  `test_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `test_scores`
--

INSERT INTO `test_scores` (`id`, `student_id`, `class_id`, `test_type`, `score`, `test_date`, `created_at`) VALUES
(1, 1, 1, 'Midterm', 8.00, '2024-10-15', '2025-05-21 09:52:07'),
(2, 2, 2, 'Final', 7.80, '2024-12-18', '2025-05-21 09:52:07'),
(3, 3, 3, 'Midterm', 9.00, '2025-03-01', '2025-05-21 09:52:07'),
(4, 4, 4, 'Final', 4.80, '2025-04-25', '2025-05-21 09:52:07'),
(5, 5, 5, 'Midterm', 9.10, '2025-07-10', '2025-05-21 09:52:07');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `classes`
--
ALTER TABLE `classes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `course_id` (`course_id`);

--
-- Chỉ mục cho bảng `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `course_registrations`
--
ALTER TABLE `course_registrations`
  ADD PRIMARY KEY (`registration_id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `course_id` (`course_id`),
  ADD KEY `class_id` (`class_id`),
  ADD KEY `status` (`status`);

--
-- Chỉ mục cho bảng `curriculum`
--
ALTER TABLE `curriculum`
  ADD PRIMARY KEY (`id`),
  ADD KEY `course_id` (`course_id`);

--
-- Chỉ mục cho bảng `grades`
--
ALTER TABLE `grades`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `class_id` (`class_id`);

--
-- Chỉ mục cho bảng `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`);

--
-- Chỉ mục cho bảng `regulations`
--
ALTER TABLE `regulations`
  ADD PRIMARY KEY (`regulation_id`);

--
-- Chỉ mục cho bảng `retake_courses`
--
ALTER TABLE `retake_courses`
  ADD PRIMARY KEY (`registration_id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `course_id` (`course_id`),
  ADD KEY `status` (`status`);

--
-- Chỉ mục cho bảng `retake_exams`
--
ALTER TABLE `retake_exams`
  ADD PRIMARY KEY (`registration_id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `course_id` (`course_id`),
  ADD KEY `exam_id` (`exam_id`),
  ADD KEY `status` (`status`);

--
-- Chỉ mục cho bảng `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`teacher_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Chỉ mục cho bảng `teacher_assignments`
--
ALTER TABLE `teacher_assignments`
  ADD PRIMARY KEY (`assignment_id`),
  ADD KEY `teacher_id` (`teacher_id`),
  ADD KEY `class_id` (`class_id`);

--
-- Chỉ mục cho bảng `teaching_schedule`
--
ALTER TABLE `teaching_schedule`
  ADD PRIMARY KEY (`id`),
  ADD KEY `teacher_id` (`teacher_id`),
  ADD KEY `class_id` (`class_id`),
  ADD KEY `course_id` (`course_id`),
  ADD KEY `schedule_date` (`schedule_date`);

--
-- Chỉ mục cho bảng `test_scores`
--
ALTER TABLE `test_scores`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `class_id` (`class_id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `classes`
--
ALTER TABLE `classes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT cho bảng `courses`
--
ALTER TABLE `courses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT cho bảng `course_registrations`
--
ALTER TABLE `course_registrations`
  MODIFY `registration_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `curriculum`
--
ALTER TABLE `curriculum`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `grades`
--
ALTER TABLE `grades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT cho bảng `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT cho bảng `regulations`
--
ALTER TABLE `regulations`
  MODIFY `regulation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `retake_courses`
--
ALTER TABLE `retake_courses`
  MODIFY `registration_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `retake_exams`
--
ALTER TABLE `retake_exams`
  MODIFY `registration_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `students`
--
ALTER TABLE `students`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT cho bảng `teachers`
--
ALTER TABLE `teachers`
  MODIFY `teacher_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `teacher_assignments`
--
ALTER TABLE `teacher_assignments`
  MODIFY `assignment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT cho bảng `teaching_schedule`
--
ALTER TABLE `teaching_schedule`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT cho bảng `test_scores`
--
ALTER TABLE `test_scores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `classes`
--
ALTER TABLE `classes`
  ADD CONSTRAINT `classes_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE SET NULL;

--
-- Các ràng buộc cho bảng `curriculum`
--
ALTER TABLE `curriculum`
  ADD CONSTRAINT `curriculum_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE SET NULL;

--
-- Các ràng buộc cho bảng `grades`
--
ALTER TABLE `grades`
  ADD CONSTRAINT `grades_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`),
  ADD CONSTRAINT `grades_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`);

--
-- Các ràng buộc cho bảng `teacher_assignments`
--
ALTER TABLE `teacher_assignments`
  ADD CONSTRAINT `teacher_assignments_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`teacher_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `teacher_assignments_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `test_scores`
--
ALTER TABLE `test_scores`
  ADD CONSTRAINT `test_scores_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`),
  ADD CONSTRAINT `test_scores_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
