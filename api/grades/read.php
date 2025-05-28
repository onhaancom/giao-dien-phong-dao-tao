<?php
// CORS headers
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Include database connection
require_once '../config.php';

// Create response array
$response = ['status' => 'error', 'message' => ''];

try {
    // Establish database connection
    $database = new Database();
    $db = $database->getConnection();

    // SQL query to fetch grades with related information
    $query = "SELECT 
                g.id,
                s.student_name,
                c.course_name,
                cl.class_name,
                cl.semester,
                cl.academic_year,
                g.final_grade,
                g.created_at
              FROM grades g
              JOIN students s ON g.student_id = s.id
              JOIN classes cl ON g.class_id = cl.id
              JOIN courses c ON cl.course_id = c.id";
    
    $stmt = $db->prepare($query);
    $stmt->execute();

    $grades = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    if ($grades) {
        $response = [
            'status' => 'success',
            'records' => $grades
        ];
    } else {
        $response['message'] = 'No grades found';
    }
} catch(PDOException $e) {
    $response['message'] = 'Database error: ' . $e->getMessage();
    error_log($e->getMessage());
    http_response_code(500);
} catch(Exception $e) {
    $response['message'] = 'Error: ' . $e->getMessage();
    http_response_code(500);
}

// Output JSON response
echo json_encode($response);
?>