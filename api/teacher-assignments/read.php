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

    // Check if a specific assignment is requested
    $assignment_id = isset($_GET['id']) ? $_GET['id'] : null;

    if ($assignment_id) {
        // Fetch single assignment with details
        $query = "SELECT ta.*, t.name AS teacher_name, c.class_name, co.course_name, 
                  c.semester, c.academic_year
                  FROM teacher_assignments ta
                  JOIN teachers t ON ta.teacher_id = t.teacher_id
                  JOIN classes c ON ta.class_id = c.id
                  JOIN courses co ON c.course_id = co.id
                  WHERE ta.assignment_id = :assignment_id";
        
        $stmt = $db->prepare($query);
        $stmt->bindParam(':assignment_id', $assignment_id, PDO::PARAM_INT);
        $stmt->execute();
        
        $assignment = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($assignment) {
            $response = [
                'status' => 'success',
                'data' => $assignment
            ];
        } else {
            $response['message'] = 'Teacher assignment not found';
            http_response_code(404);
        }
    } else {
        // Fetch all assignments with details
        $query = "SELECT ta.assignment_id, ta.assignment_type, ta.start_date, ta.end_date,
                  ta.hours_per_week, ta.notes, t.name AS teacher_name, t.department,
                  c.class_name, co.course_name, c.semester, c.academic_year
                  FROM teacher_assignments ta
                  JOIN teachers t ON ta.teacher_id = t.teacher_id
                  JOIN classes c ON ta.class_id = c.id
                  JOIN courses co ON c.course_id = co.id
                  ORDER BY ta.assignment_id DESC";
        
        $stmt = $db->prepare($query);
        $stmt->execute();

        $assignments = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        if ($assignments) {
            $response = [
                'status' => 'success',
                'records' => $assignments
            ];
        } else {
            $response['message'] = 'No teacher assignments found';
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