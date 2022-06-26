<?php
    header("Access-Control-Allow-Origin: *");
    $connect= new mysqli("localhost", "root", "", "mahasiswa");

    if ($connect) {
        
    } else {
        echo "koneksi gagal";
        exit();
    }
?>