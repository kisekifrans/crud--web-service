<?php
    header("Access-Control-Allow-Origin: *");
    include 'koneksi.php';

    $id = $_POST['id'];
    $nama = $_POST['nama'];
    $NIM = $_POST['NIM'];
    $alamat = $_POST['alamat'];
    $image = $_POST['image'];

    // $connect->query("UPDATE identitas (nama, NIM, alamat) VALUES ('".$nama."', '".$NIM."', '".$alamat."');")

    $connect->query("UPDATE identitas SET nama = '".$nama."', NIM = '".$NIM."', alamat = '".$alamat."', image = '".$image."' WHERE identitas.id =" .$id);
?>