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

// Validate required field
if (empty($data->assignment_id)) {
    $response['message'] = 'Assignment ID is required';
    http_response_code(400);
    echo json_encode($response);
    exit;
}

try {
    // Establish database connection
    $database = new Database();
    $db = $database->getConnection();

    // Prepare SQL query
    $query = "DELETE FROM teacher_assignments WHERE assignment_id = :assignment_id";
    
    $stmt = $db->prepare($query);
    $stmt->bindParam(':assignment_id', $data->assignment_id, PDO::PARAM_INT);

    // Execute the query
    if ($stmt->execute()) {
        $response = [
            'status' => 'success',
            'message' => 'Teacher assignment deleted successfully'
        ];
        http_response_code(200);
    } else {
        $response['message'] = 'Failed to delete teacher assignment';
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