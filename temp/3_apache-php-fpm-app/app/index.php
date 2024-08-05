<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>Hello World</title>
</head>
<body>
	<?php 
		echo "<h1>NOW I'M FEELING SO FLAT LIKE A G6</h1>"; 
	?>
	<?php
		$host = 'mysql-db';
		$user = 'db_user';
		$pass = 'password';
		$db = 'test_database';

		$conn = new mysqli($host, $user, $pass, $db);

		if ($conn->connect_error) {
			die("Connection failed: " . $conn->connect_error);
		}

		echo "Connected to MySQL successfully";

		$conn->close();
	?>
</body>
</html>