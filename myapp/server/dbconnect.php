<?php
$servername = "localhost";
$username   = "crimsonw_270150_myshopadmin";
$password   = "!1Q@2w#3e";
$dbname     = "crimsonw_270150_myshopdb";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>