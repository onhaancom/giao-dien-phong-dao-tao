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
$response = ['status' => 'error', 'message' => ''];

try {
    // Establish database connection
    $database = new Database();
    $db = $database->getConnection();

    // Check if we're requesting a single regulation
    if (isset($_GET['id'])) {
        $id = $_GET['id'];
        $query = "SELECT * FROM regulations WHERE regulation_id = :id";
        $stmt = $db->prepare($query);
        $stmt->bindParam(':id', $id);
        $stmt->execute();
        $regulation = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($regulation) {
            $response = [
                'status' => 'success',
                'data' => $regulation
            ];
        } else {
            $response['message'] = 'Regulation not found';
            http_response_code(404);
        }
    } else {
        // Get all regulations
        $query = "SELECT * FROM regulations ORDER BY effective_date DESC";
        $stmt = $db->prepare($query);
        $stmt->execute();

        $regulations = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        if ($regulations) {
            $response = [
                'status' => 'success',
                'records' => $regulations
            ];
        } else {
            $response['message'] = 'No regulations found';
        }
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