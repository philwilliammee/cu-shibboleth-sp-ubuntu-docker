<?php

require_once __DIR__ . '/../layout.php';

$message = "Use this page to test a simple oracle connection using php";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // process the form submission
    $host = $_POST['host'] ?? 'localhost';
    $port = $_POST['port'] ?? '1521';
    $path = $_POST['service_name'] ?? 'test';
    $username = $_POST['user'] ?? 'test';
    $password = $_POST['pass'] ?? 'test';

    $message = "Connecting to $host:$port/$path as $username";

    try {
        // Test a connection to the database
        $connection_string = "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=" . $host . ")(PORT=$port))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=" . $db . ")))";
        $conn = oci_connect($username, $password, $connection_string);
        if (!$conn) {
            $e = oci_error();
            $message = "Error: " . $e['message'];
        } else {
            $message = "Successfully connected!";
        }
    } catch (\Throwable $th) {
        $message = $th->getMessage();
    }
}


$html = <<<HTML
<style>
    form {
        display: flex;
        flex-direction: column;
        align-items: flex-start;
    }
    .form-group {
        display: flex;
        min-width: 300px;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 8px;
    }
</style>
<h2>OCI8 Oracle test connection</h2>
<p class='intro'>
    $message
</p>

<form action=""></form>

<form action="./" method='POST'>
    <div class="form-group">
        <label for="host">Host</label>
        <input type="text" class="form-control" id="host" name="host" value="localhost">
    </div>
    <div class="form-group">
        <label for="port">Port</label>
        <input type="text" class="form-control" id="port" name="port" value="1521">
    </div>
    <div class="form-group">
        <label for="user">User</label>
        <input type="text" class="form-control" id="user" name="user" value="test">
    </div>
    <div class="form-group">
        <label for="pass">Password</label>
        <input type="text" class="form-control" id="pass" name="pass" value="test">
    </div>
    <div class="form-group">
        <label for="service_name">Service Name</label>
        <input type="text" class="form-control" id="service_name" name="service_name" value="test">
    </div>
    <button type="submit" class="btn btn-primary">Submit</button>
</form>
HTML;

render($html);
