<?php
// CORS headers
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: PUT, OPTIONS");
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
if (!isset($data->notification_id) || !isset($data->title) || !isset($data->message) || !isset($data->target_group)) {
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
    $query = "UPDATE notifications 
              SET 
                title = :title,
                message = :message,
                target_group = :target_group,
                status = :status,
                priority = :priority,
                attachment_url = :attachment_url,
                send_date = :send_date
              WHERE notification_id = :notification_id";
    
    $stmt = $db->prepare($query);

    // Bind parameters
    $stmt->bindParam(':notification_id', $data->notification_id);
    $stmt->bindParam(':title', $data->title);
    $stmt->bindParam(':message', $data->message);
    $stmt->bindParam(':target_group', $data->target_group);
    $stmt->bindParam(':status', $data->status);
    $stmt->bindParam(':priority', $data->priority);
    $stmt->bindParam(':attachment_url', $data->attachment_url);
    $stmt->bindParam(':send_date', $data->send_date);

    // Execute query
    if ($stmt->execute()) {
        if ($stmt->rowCount() > 0) {
            $response = [
                'status' => 'success',
                'message' => 'Notification was updated.'
            ];
            http_response_code(200);
        } else {
            $response['message'] = 'No notification found with that ID';
            http_response_code(404);
        }
    } else {
        $response['message'] = 'Unable to update notification';
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