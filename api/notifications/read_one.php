<?php
// CORS headers
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Include database connection
require_once '../config.php';

// Get notification ID from URL
$notification_id = isset($_GET['id']) ? $_GET['id'] : null;

// Create response array
$response = ['status' => 'error', 'message' => ''];

// Validate notification ID
if (!$notification_id) {
    $response['message'] = 'Notification ID is required';
    http_response_code(400);
    echo json_encode($response);
    exit;
}

try {
    // Establish database connection
    $database = new Database();
    $db = $database->getConnection();

    // Prepare SQL query
    $query = "SELECT * FROM notifications WHERE notification_id = :notification_id";
    $stmt = $db->prepare($query);
    $stmt->bindParam(':notification_id', $notification_id);
    $stmt->execute();

    $notification = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if ($notification) {
        $response = [
            'status' => 'success',
            'data' => $notification
        ];
    } else {
        $response['message'] = 'No notification found with that ID';
        http_response_code(404);
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