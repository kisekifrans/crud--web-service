<?php
    header("Access-Control-Allow-Origin: *");
    include 'koneksi.php';

    $nama = $_POST['nama'];
    $NIM = $_POST['NIM'];
    $alamat = $_POST['alamat'];
    $image = $_POST['image'];
    // $image = date('dmYHis').str_replace(" ","",basename($_FILES['image']['name']));
    // $imagePath="./gambar".$image;
    // move_uploaded_file($_FILES['image']['tmp_name'],$imagePath);

    $connect->query("INSERT INTO identitas (nama, NIM, alamat, image) VALUES ('".$nama."', '".$NIM."', '".$alamat."', '".$image."');")
?>