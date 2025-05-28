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
$response = ['status' => 'error', 'message' => '', 'records' => []];

try {
    // Establish database connection
    $database = new Database();
    $db = $database->getConnection();

    // SQL query to fetch teaching schedule with related data
    $query = "SELECT 
                ts.id,
                ts.teacher_id,
                ts.teacher_name,
                ts.class_id,
                ts.class_name,
                ts.course_id,
                ts.course_name,
                ts.course_type,
                ts.schedule_date,
                DATE_FORMAT(ts.start_time, '%H:%i') as start_time,
                DATE_FORMAT(ts.end_time, '%H:%i') as end_time,
                ts.location,
                ts.semester,
                ts.academic_year,
                c.course_code,
                t.department as teacher_department
              FROM teaching_schedule ts
              LEFT JOIN courses c ON ts.course_id = c.id
              LEFT JOIN teachers t ON ts.teacher_id = t.teacher_id
              ORDER BY ts.schedule_date, ts.start_time";
              
    $stmt = $db->prepare($query);
    $stmt->execute();

    $records = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    if ($records) {
        $response = [
            'status' => 'success',
            'records' => $records
        ];
    } else {
        $response['message'] = 'No schedule records found';
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