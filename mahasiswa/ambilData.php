<?php
    include 'koneksi.php';

    $hasilQuery=$connect->query("SELECT * FROM identitas");
    $hasil = array();
    if ($hasilQuery) {
        while($potonganData=$hasilQuery->fetch_assoc()){
            $hasil[]=$potonganData;
        }
    
        echo json_encode($hasil);
    }

    $connect->close();
    return;

?>