<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

require_once '../config.php';

$response = ['status' => 'error', 'message' => ''];

try {
    // Check if ID parameter is provided
    if (!isset($_GET['id']) || empty($_GET['id'])) {
        throw new Exception("Course ID is required");
    }

    $course_id = (int)$_GET['id'];

    $database = new Database();
    $db = $database->getConnection();

    // Prepare query to fetch course details
    $query = "SELECT 
                id as course_id, 
                course_code, 
                course_name, 
                course_description as description, 
                credits, 
                prerequisites, 
                department, 
                is_active, 
                created_at 
              FROM courses 
              WHERE id = :id";

    $stmt = $db->prepare($query);
    $stmt->bindParam(':id', $course_id, PDO::PARAM_INT);
    $stmt->execute();

    $course = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($course) {
        $response = [
            'status' => 'success',
            'data' => $course
        ];
    } else {
        throw new Exception("Course not found with ID: " . $course_id);
    }
} catch (PDOException $e) {
    $response['message'] = "Database error: " . $e->getMessage();
    http_response_code(500);
    error_log($e->getMessage());
} catch (Exception $e) {
    $response['message'] = $e->getMessage();
    http_response_code(404);
}

echo json_encode($response);
?>