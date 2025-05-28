<?php
// CORS headers
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Include database connection
require_once '../config.php';

// Get posted data
$data = json_decode(file_get_contents("php://input"));

// Create response array
$response = ['status' => 'error', 'message' => ''];

// Validate required fields
if (!isset($data->title) || !isset($data->message) || !isset($data->target_group)) {
    $response['message'] = 'Missing required fields';
    http_response_code(400);
    echo json_encode($response);
    exit;
}

try {
    // Establish database connection
    $database = new Database();
    $db = $database->getConnection();

    // Prepare SQL query
    $query = "INSERT INTO notifications 
              (title, message, target_group, status, priority, attachment_url, created_at, send_date) 
              VALUES 
              (:title, :message, :target_group, :status, :priority, :attachment_url, :created_at, :send_date)";
    
    $stmt = $db->prepare($query);

    // Bind parameters
    $stmt->bindParam(':title', $data->title);
    $stmt->bindParam(':message', $data->message);
    $stmt->bindParam(':target_group', $data->target_group);
    $stmt->bindParam(':status', $data->status);
    $stmt->bindParam(':priority', $data->priority);
    $stmt->bindParam(':attachment_url', $data->attachment_url);
    $stmt->bindParam(':created_at', $data->created_at);
    $stmt->bindParam(':send_date', $data->send_date);

    // Execute query
    if ($stmt->execute()) {
        $response = [
            'status' => 'success',
            'message' => 'Notification was created.',
            'notification_id' => $db->lastInsertId()
        ];
        http_response_code(201);
    } else {
        $response['message'] = 'Unable to create notification';
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