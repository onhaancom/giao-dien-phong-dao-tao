<?php
// CORS headers
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
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

// Only accept POST requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    $response['message'] = 'Invalid request method';
    http_response_code(405);
    echo json_encode($response);
    exit;
}

// Get the posted data
$data = json_decode(file_get_contents("php://input"));

// Validate required fields
if (empty($data->teacher_id) || empty($data->class_id) || empty($data->assignment_type)) {
    $response['message'] = 'Teacher ID, Class ID, and Assignment Type are required';
    http_response_code(400);
    echo json_encode($response);
    exit;
}

try {
    // Establish database connection
    $database = new Database();
    $db = $database->getConnection();

    // Prepare SQL query
    $query = "INSERT INTO teacher_assignments 
              (teacher_id, class_id, assignment_type, start_date, end_date, hours_per_week, notes)
              VALUES (:teacher_id, :class_id, :assignment_type, :start_date, :end_date, :hours_per_week, :notes)";
    
    $stmt = $db->prepare($query);

    // Bind parameters
    $stmt->bindParam(':teacher_id', $data->teacher_id, PDO::PARAM_INT);
    $stmt->bindParam(':class_id', $data->class_id, PDO::PARAM_INT);
    $stmt->bindParam(':assignment_type', $data->assignment_type);
    
    $start_date = !empty($data->start_date) ? $data->start_date : null;
    $end_date = !empty($data->end_date) ? $data->end_date : null;
    $hours_per_week = !empty($data->hours_per_week) ? $data->hours_per_week : null;
    $notes = !empty($data->notes) ? $data->notes : null;
    
    $stmt->bindParam(':start_date', $start_date);
    $stmt->bindParam(':end_date', $end_date);
    $stmt->bindParam(':hours_per_week', $hours_per_week);
    $stmt->bindParam(':notes', $notes);

    // Execute the query
    if ($stmt->execute()) {
        $response = [
            'status' => 'success',
            'message' => 'Teacher assignment created successfully',
            'assignment_id' => $db->lastInsertId()
        ];
        http_response_code(201);
    } else {
        $response['message'] = 'Failed to create teacher assignment';
        http_response_code(500);
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