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
    if (empty($data->title)) {
        throw new Exception('Title is required');
    }
    if (empty($data->category)) {
        throw new Exception('Category is required');
    }
    if (empty($data->description)) {
        throw new Exception('Description is required');
    }
    if (empty($data->effective_date)) {
        throw new Exception('Effective date is required');
    }

    // Establish database connection
    $database = new Database();
    $db = $database->getConnection();

    // Prepare SQL query
    $query = "UPDATE regulations SET
        title = :title, 
        category = :category, 
        description = :description, 
        content = :content, 
        effective_date = :effective_date, 
        expiry_date = :expiry_date, 
        is_active = :is_active, 
        file_reference = :file_reference,
        updated_at = NOW()
    WHERE regulation_id = :regulation_id";

    $stmt = $db->prepare($query);

    // Bind parameters
    $stmt->bindParam(':regulation_id', $data->regulation_id, PDO::PARAM_INT);
    $stmt->bindParam(':title', $data->title);
    $stmt->bindParam(':category', $data->category);
    $stmt->bindParam(':description', $data->description);
    $stmt->bindParam(':content', $data->content);
    $stmt->bindParam(':effective_date', $data->effective_date);
    $stmt->bindParam(':expiry_date', $data->expiry_date);
    $stmt->bindParam(':is_active', $data->is_active, PDO::PARAM_INT);
    $stmt->bindParam(':file_reference', $data->file_reference);

    // Execute query
    if ($stmt->execute()) {
        $response = [
            'status' => 'success',
            'message' => 'Regulation updated successfully'
        ];
    } else {
        throw new Exception('Failed to update regulation');
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