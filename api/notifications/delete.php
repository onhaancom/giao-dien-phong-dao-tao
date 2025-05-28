<?php
// Xử lý CORS preflight request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Methods: POST, GET, DELETE, OPTIONS");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
    header("Access-Control-Max-Age: 86400");
    http_response_code(200);
    exit;
}

// Headers chính
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// Kết nối database
include_once __DIR__ . '/../config.php';
$database = new Database();
$db = $database->getConnection();

// Lấy dữ liệu JSON
$data = json_decode(file_get_contents("php://input"));

if (!empty($data->id)) {
    $id = $data->id;

    // Kiểm tra bản ghi có tồn tại không
    $checkQuery = "SELECT * FROM notifications WHERE notification_id = :id";
    $checkStmt = $db->prepare($checkQuery);
    $checkStmt->bindParam(":id", $id);
    $checkStmt->execute();

    if ($checkStmt->rowCount() > 0) {
        // Tiến hành xóa
        $deleteQuery = "DELETE FROM notifications WHERE notification_id = :id";
        $deleteStmt = $db->prepare($deleteQuery);
        $deleteStmt->bindParam(":id", $id);

        if ($deleteStmt->execute()) {
            echo json_encode([
                "status" => "success",
                "message" => "Notification was deleted."
            ]);
        } else {
            http_response_code(503);
            echo json_encode([
                "status" => "error",
                "message" => "Unable to delete notification."
            ]);
        }
    } else {
        http_response_code(404);
        echo json_encode([
            "status" => "error",
            "message" => "Notification not found"
        ]);
    }
} else {
    http_response_code(400);
    echo json_encode([
        "status" => "error",
        "message" => "Missing required field: id"
    ]);
}
?>
