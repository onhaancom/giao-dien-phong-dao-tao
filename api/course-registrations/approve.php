<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

require_once '../config.php';

$response = ['status' => 'error', 'message' => ''];

try {
    $database = new Database();
    $db = $database->getConnection();

    // Get input data
    $data = json_decode(file_get_contents("php://input"));
    
    if (empty($data->registration_id) || empty($data->status)) {
        throw new Exception("Missing required fields");
    }

    // Validate status
    if (!in_array($data->status, ['approved', 'rejected'])) {
        throw new Exception("Invalid status value");
    }

    // Check if registration exists
    $checkQuery = "SELECT * FROM course_registrations WHERE registration_id = :id";
    $checkStmt = $db->prepare($checkQuery);
    $checkStmt->bindParam(':id', $data->registration_id);
    $checkStmt->execute();
    
    if ($checkStmt->rowCount() === 0) {
        throw new Exception("Registration not found");
    }

    // Update registration
    $query = "UPDATE course_registrations 
              SET status = :status, 
                  processed_date = NOW(),
                  processed_by = :processed_by
              WHERE registration_id = :id";
    
    $stmt = $db->prepare($query);
    $stmt->bindParam(':status', $data->status);
    $stmt->bindParam(':id', $data->registration_id);
    $stmt->bindValue(':processed_by', 1); // Replace with actual user ID from auth
    
    if ($stmt->execute()) {
        $response = [
            'status' => 'success',
            'message' => 'Registration updated successfully'
        ];
    } else {
        throw new Exception("Failed to update registration");
    }
} catch(PDOException $e) {
    $response['message'] = 'Database error: ' . $e->getMessage();
    error_log($e->getMessage());
    http_response_code(500);
} catch(Exception $e) {
    $response['message'] = 'Error: ' . $e->getMessage();
    http_response_code(400);
}

echo json_encode($response);
?>