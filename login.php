<?php
session_start();
require ("config.php");
@$username = $_POST["login-username"];
@$password = $_POST["login-password"];
$error = "";
$complete = "";
if (isset($_POST["login"])) {
    if (empty($username) && empty($password)) {
        $error = "Thiếu tên người dùng và mật khẩu";
    } 
    else if (empty($username)) {
        $error = "Thiếu tên người dùng";
    } 
    else if (empty($password)) {
        $error = "Thiếu mật khẩu";
    } 
    else {
        $query = "SELECT * FROM users";
        $result = mysqli_query($conn, $query);
        if($result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                if ($row["Username"] == $username && $row["UserPassword"] == $password) {
                    $complete = "done";
                    break;
                }
                else if ($row["Username"] != $username || $row["UserPassword"] != $password) {
                    $error = "Sai thông tin";
                }
            }
        }
    }
}
?>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">

    <title>Login</title>

</head>
<body>
    <h1>Đăng nhập</h1>
    <form action="login.php" method="post">
        <table>
            <tr>
                <td>Tên người dùng</td>
                <td><input type="text" name="login-username" autocomplete="off"></td>
            </tr>
            <tr>
                <td>Mật khẩu</td>
                <td><input type="password" name="login-password" autocomplete="off"></td>
            </tr>
            <tr>
                <td><button>Đăng kí</button></td>
                <td><button type="submit" name="login">Đăng nhập</button></td>
            </tr>
        </table>
    </form>
    <?php
        if(!empty($error)) echo"$error"; else echo"";
        if(!empty($complete)) echo "$complete"; else echo"";
    ?>
    <script>
    if (window.history.replaceState ) {
        window.history.replaceState( null, null, window.location.href );
    }
    </script>

</body>
</html>