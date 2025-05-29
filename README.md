# Hướng dẫn kết nối API Training

## 1. Cấu trúc cơ bản API

### Endpoint cơ bản
http://yourdomain.com/api/training/[resource]

### Phương thức HTTP
- GET: Lấy dữ liệu
- POST: Tạo mới
- PUT/PATCH: Cập nhật
- DELETE: Xóa

## 2. Các API chính

### 2.1. Quản lý khóa học (Courses)

**Endpoint:** `/api/training/courses`

**Ví dụ GET all courses:**
// courses.php
$sql = "SELECT * FROM courses WHERE is_active = 1";
$result = $conn->query($sql);
$courses = [];
while($row = $result->fetch_assoc()) {
    $courses[] = $row;
}
header('Content-Type: application/json');
echo json_encode($courses);

**Giải thích code:**
- Truy vấn SQL lấy tất cả khóa học đang active
- Chuyển kết quả thành mảng JSON
- Trả về dưới dạng application/json

### 2.2. Quản lý lớp học (Classes)

**Endpoint:** `/api/training/classes`

**Ví dụ GET classes by course:**
```php
// classes.php
$course_id = $_GET['course_id'] ?? null;

$sql = "SELECT * FROM classes WHERE 1=1";
if ($course_id) {
    $sql .= " AND course_id = " . intval($course_id);
}

$result = $conn->query($sql);
$classes = [];
while($row = $result->fetch_assoc()) {
    $classes[] = $row;
}
echo json_encode($classes);
```

**Giải thích:**
- Lọc lớp học theo course_id nếu có
- Sử dụng intval() để phòng chống SQL injection
- Trả về danh sách lớp học dạng JSON

### 2.3. Đăng ký khóa học (Course Registrations)

**Endpoint:** `/api/training/registrations`

**Ví dụ POST đăng ký:**
```php
// registrations.php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    $student_id = intval($data['student_id']);
    $course_id = intval($data['course_id']);
    $class_id = intval($data['class_id']);
    
    // Kiểm tra lớp còn chỗ không
    $check_sql = "SELECT COUNT(*) as count FROM course_registrations 
                 WHERE class_id = $class_id AND status = 'approved'";
    $count = $conn->query($check_sql)->fetch_assoc()['count'];
    
    $max_sql = "SELECT max_students FROM classes WHERE id = $class_id";
    $max = $conn->query($max_sql)->fetch_assoc()['max_students'];
    
    if ($count >= $max) {
        http_response_code(400);
        echo json_encode(['error' => 'Lớp đã đầy']);
        exit;
    }
    
    // Thêm đăng ký
    $insert_sql = "INSERT INTO course_registrations 
                  (student_id, student_name, course_id, course_name, class_id, class_name, status)
                  VALUES (?, ?, ?, ?, ?, ?, 'pending')";
                  
    $stmt = $conn->prepare($insert_sql);
    $stmt->bind_param("iisiis", 
        $student_id, 
        $data['student_name'],
        $course_id,
        $data['course_name'],
        $class_id,
        $data['class_name']
    );
    
    if ($stmt->execute()) {
        echo json_encode(['success' => true]);
    } else {
        http_response_code(500);
        echo json_encode(['error' => 'Lỗi đăng ký']);
    }
}
```

**Giải thích:**
- Kiểm tra phương thức POST
- Lấy dữ liệu từ input JSON
- Kiểm tra số lượng học viên đã đăng ký
- Sử dụng prepared statement để tránh SQL injection
- Trả về kết quả dạng JSON

## 3. Authentication (Xác thực)

Thêm middleware xác thực cho API:

```php
// auth.php
function authenticate() {
    $headers = getallheaders();
    if (!isset($headers['Authorization'])) {
        http_response_code(401);
        echo json_encode(['error' => 'Unauthorized']);
        exit;
    }
    
    $token = str_replace('Bearer ', '', $headers['Authorization']);
    // Kiểm tra token trong database
    $sql = "SELECT * FROM api_tokens WHERE token = ? AND expires_at > NOW()";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $token);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows === 0) {
        http_response_code(401);
        echo json_encode(['error' => 'Invalid token']);
        exit;
    }
}

// Sử dụng trong các endpoint
require 'auth.php';
authenticate();
```

## 4. Pagination (Phân trang)

**Ví dụ phân trang:**

```php
// pagination.php
$page = $_GET['page'] ?? 1;
$per_page = $_GET['per_page'] ?? 10;
$offset = ($page - 1) * $per_page;

$sql = "SELECT * FROM students LIMIT $per_page OFFSET $offset";
$result = $conn->query($sql);

$total_sql = "SELECT COUNT(*) as total FROM students";
$total = $conn->query($total_sql)->fetch_assoc()['total'];

echo json_encode([
    'data' => $result->fetch_all(MYSQLI_ASSOC),
    'pagination' => [
        'total' => $total,
        'per_page' => $per_page,
        'current_page' => $page,
        'last_page' => ceil($total / $per_page)
    ]
]);
```

## 5. Error Handling (Xử lý lỗi)

```php
// error_handler.php
set_error_handler(function($errno, $errstr, $errfile, $errline) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Internal Server Error',
        'message' => $errstr,
        'file' => $errfile,
        'line' => $errline
    ]);
    exit;
});

set_exception_handler(function($exception) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Internal Server Error',
        'message' => $exception->getMessage(),
        'file' => $exception->getFile(),
        'line' => $exception->getLine()
    ]);
    exit;
});
```

## 6. Giải thích một số điểm quan trọng trong database

1. **Bảng `classes`**:
   - Có khóa ngoại `course_id` tham chiếu đến bảng `courses`
   - Trường `status` dùng enum để giới hạn giá trị
   - `max_students` giới hạn số học viên mỗi lớp

2. **Bảng `course_registrations`**:
   - Lưu trạng thái đăng ký (pending/approved/rejected)
   - Có tham chiếu đến student, course và class

3. **Bảng `teacher_assignments`**:
   - Xác định giáo viên dạy lớp nào, loại assignment (Primary/Substitute...)
   - Có tham chiếu đến `teachers` và `classes`

4. **Bảng `teaching_schedule`**:
   - Lịch giảng dạy chi tiết với thời gian, địa điểm
   - Có thông tin học kỳ, năm học

## 7. Best Practices

1. Luôn sử dụng prepared statements để tránh SQL injection
2. Validate input data trước khi xử lý
3. Sử dụng HTTP status code phù hợp
4. Trả về dữ liệu dạng JSON
5. Giới hạn rate limit cho API
6. Sử dụng caching cho dữ liệu ít thay đổi

## 8. Ví dụ hoàn chỉnh cho 1 endpoint

```php
// api/training/classes.php
require '../config/database.php';
require '../middleware/auth.php';

authenticate();

header('Content-Type: application/json');

try {
    $method = $_SERVER['REQUEST_METHOD'];
    
    switch ($method) {
        case 'GET':
            $course_id = $_GET['course_id'] ?? null;
            $status = $_GET['status'] ?? null;
            
            $sql = "SELECT c.*, co.course_name 
                    FROM classes c
                    LEFT JOIN courses co ON c.course_id = co.id
                    WHERE 1=1";
                    
            $params = [];
            
            if ($course_id) {
                $sql .= " AND c.course_id = ?";
                $params[] = intval($course_id);
            }
            
            if ($status) {
                $sql .= " AND c.status = ?";
                $params[] = $status;
            }
            
            $stmt = $conn->prepare($sql);
            if ($params) {
                $types = str_repeat('s', count($params));
                $stmt->bind_param($types, ...$params);
            }
            
            $stmt->execute();
            $result = $stmt->get_result();
            $classes = $result->fetch_all(MYSQLI_ASSOC);
            
            echo json_encode($classes);
            break;
            
        case 'POST':
            $data = json_decode(file_get_contents('php://input'), true);
            
            // Validate input
            $required = ['class_name', 'course_id', 'semester', 'academic_year'];
            foreach ($required as $field) {
                if (empty($data[$field])) {
                    http_response_code(400);
                    echo json_encode(['error' => "Missing required field: $field"]);
                    exit;
                }
            }
            
            $insert_sql = "INSERT INTO classes 
                          (class_name, course_id, semester, academic_year, 
                           start_date, end_date, schedule_info, location, max_students)
                          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                          
            $stmt = $conn->prepare($insert_sql);
            $stmt->bind_param(
                "sissdsssi",
                $data['class_name'],
                $data['course_id'],
                $data['semester'],
                $data['academic_year'],
                $data['start_date'],
                $data['end_date'],
                $data['schedule_info'],
                $data['location'],
                $data['max_students'] ?? 30
            );
            
            if ($stmt->execute()) {
                http_response_code(201);
                echo json_encode([
                    'id' => $conn->insert_id,
                    'message' => 'Class created successfully'
                ]);
            } else {
                http_response_code(500);
                echo json_encode(['error' => 'Failed to create class']);
            }
            break;
            
        default:
            http_response_code(405);
            echo json_encode(['error' => 'Method not allowed']);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
}