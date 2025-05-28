<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

require_once '../config.php';

$response = ['status' => 'error', 'message' => '', 'records' => []];

try {
    $database = new Database();
    $db = $database->getConnection();

    // Get status filter from query parameter
    $status = isset($_GET['status']) ? $_GET['status'] : 'pending';
    
    // Validate status
    if (!in_array($status, ['pending', 'approved', 'rejected'])) {
        $status = 'pending';
    }

    $query = "SELECT * FROM retake_exams WHERE status = :status ORDER BY request_date DESC";
    $stmt = $db->prepare($query);
    $stmt->bindParam(':status', $status);
    $stmt->execute();

    $records = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    if ($records) {
        $response = [
            'status' => 'success',
            'records' => $records
        ];
    } else {
        $response['message'] = 'No retake exam registrations found';
    }
} catch(PDOException $e) {
    $response['message'] = 'Database error: ' . $e->getMessage();
    error_log($e->getMessage());
    http_response_code(500);
} catch(Exception $e) {
    $response['message'] = 'Error: ' . $e->getMessage();
    http_response_code(500);
}

echo json_encode($response);
?>