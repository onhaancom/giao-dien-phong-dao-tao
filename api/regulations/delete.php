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

try {
    // Validate required fields
    if (empty($data->regulation_id)) {
        throw new Exception('Regulation ID is required');
    }

    // Establish database connection
    $database = new Database();
    $db = $database->getConnection();

    // Prepare SQL query
    $query = "DELETE FROM regulations WHERE regulation_id = :regulation_id";
    $stmt = $db->prepare($query);
    $stmt->bindParam(':regulation_id', $data->regulation_id, PDO::PARAM_INT);

    // Execute query
    if ($stmt->execute()) {
        if ($stmt->rowCount() > 0) {
            $response = [
                'status' => 'success',
                'message' => 'Regulation deleted successfully'
            ];
        } else {
            throw new Exception('Regulation not found or already deleted');
        }
    } else {
        throw new Exception('Failed to delete regulation');
    }
} catch(PDOException $e) {
    $response['message'] = 'Database error: ' . $e->getMessage();
    error_log($e->getMessage());
    http_response_code(500);
} catch(Exception $e) {
    $response['message'] = 'Error: ' . $e->getMessage();
    http_response_code(400);
}

// Output JSON response
echo json_encode($response);
?>