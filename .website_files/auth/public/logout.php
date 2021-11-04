<?php

require __DIR__ . '/../src/bootstrap.php';
logout();
?>

<?php view('header', ['title' => 'Dashboard']) ?>

<p>You Have been Logged Out</p>

<?php view('footer') ?>