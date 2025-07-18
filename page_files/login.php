<?php
$host = "localhost"; // or "127.0.0.1"
$dbname = "your_database";
$username = "your_db_username";
$password = "your_db_password";

// Connect to MySQL
$conn = new mysqli($host, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Retrieve form data
$user = $_POST['username'];
$pass = $_POST['password'];

// Query
$sql = "SELECT * FROM login WHERE username = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $user);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 1) {
    $row = $result->fetch_assoc();
    
    // You can use password_hash() and password_verify() for hashed passwords
    if ($pass === $row['password']) {
        header("Location: home.html");
        exit();
    } else {
        echo "<script>alert('Incorrect password'); window.location.href='login.html';</script>";
    }
} else {
    echo "<script>alert('User not found'); window.location.href='login.html';</script>";
}

$conn->close();
?>