import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAHASISWA',
      home: HomePageMahasiswa(),
    );
  }
}



class HomePageMahasiswa extends StatefulWidget {
  @override
  State<HomePageMahasiswa> createState() => _HomePageMahasiswaState();
}

class _HomePageMahasiswaState extends State<HomePageMahasiswa> {
  Future<List> ambilData() async {
    var data = await http
        .get(Uri.parse("http://192.168.1.17/mahasiswa/ambilData.php"));
    var jsonData = json.decode(data.body);
    return jsonData;
  }
  _showImage(String image){
    return Image.memory(base64Decode(image), height: 100);
  }

  @override
  void initState() {
    super.initState();
    ambilData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LIST MAHASISWA"),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => new formTambah())),
        child: Icon(Icons.add),
      ),
      body: Container(
          child: FutureBuilder(
        future: ambilData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: Text("Loading . . ."),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return Detail(list: snapshot.data, index: index);
                      }));
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(snapshot.data[index]['nama']),
                        leading: Hero(
                          tag: snapshot.data[index]['nama'],
                          child: _showImage(snapshot.data[index]['image']),
                        ),
                        subtitle: Text(snapshot.data[index]['NIM']),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      )),
    );
  }
}



class Detail extends StatefulWidget {
  List list;
  int index;
  Detail({required this.list, required this.index});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  
  void hapusData(){
     http.post(Uri.parse("http://192.168.1.17/mahasiswa/hapusData.php"),
     body: {
      "id":widget.list[widget.index]['id'],
     }
     );
  }
  
  void konfirmasi() {
    AlertDialog alertDialog = AlertDialog(
      title: const Text("Hapus Identitas"),
      content: Text("Yakin ingin menghapus identitas ${widget.list[widget.index]['nama']} ini?"),
      actions: <Widget>[
        new ElevatedButton(
          child: Text("Ya"),
          onPressed: () {
            hapusData();
            Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => new HomePageMahasiswa() ));
          }),
          new ElevatedButton(
          child: Text("Tidak"),
          onPressed: () {
            Navigator.pop(context);
          })
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }
 
  
  Future<List> ambilData() async {
    var data = await http
        .get(Uri.parse("http://192.168.1.17/mahasiswa/ambilData.php"));
    var jsonData = json.decode(data.body);
    return jsonData;
  }
  _showImage(String image){
    return Image.memory(base64Decode(image), height: 200);
  }

  @override
  void initState() {
    super.initState();
    ambilData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list[widget.index]['nama']),
      ),
      body: Container(
        child: Card(
          child: Center(
            child: Column(
              children: [
                Container(
                  child: Hero(
                    tag: widget.list[widget.index]['nama'],
                    child: _showImage(widget.list[widget.index]['image']),),
                ),
                Text(widget.list[widget.index]['nama']),
                Text(widget.list[widget.index]['NIM']),
                Text(widget.list[widget.index]['alamat']),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => new formEdit(
                            list: widget.list, 
                            index: widget.index,
                          ))), 
                      child: Text("Edit")),
                    Padding(padding: EdgeInsets.all(10.0)),
                    ElevatedButton(
                      onPressed: () =>konfirmasi(), 
                      child: Text("Hapus"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class formTambah extends StatefulWidget {
  // const formTambah({Key? key}) : super(key: key);

  @override
  State<formTambah> createState() => _formTambahState();
}

class _formTambahState extends State<formTambah> {
  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerNIM = TextEditingController();
  TextEditingController controllerAlamat = TextEditingController();

  String? imageData;
  
  File? _imageFile;
  Future _pilihGambar() async{
    var pickedImage = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxHeight: 200.0,
      maxWidth: 200.0
    );

    setState(() {
      _imageFile = File(pickedImage!.path);
    });
    imageData = base64Encode(_imageFile!.readAsBytesSync());
  }

  simpanData() async {
    var response = await http.post(Uri.parse("http://192.168.1.17/mahasiswa/tambahData.php"),
    body: {
      "nama": controllerNama.text,
      "NIM": controllerNIM.text, 
      "alamat": controllerAlamat.text,
      "image": imageData
    });
  }

  _showImage(String image){
    return Image.memory(base64Decode(image));
  }


  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      width: double.infinity,
      height: 50.0,
      child: Icon(Icons.add_a_photo, size: 50.0,),
      // child: Image.asset('./img/thumbnail.png'),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Identitas Mahasiswa")
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  child: InkWell(
                    onTap: () async{
                      await _pilihGambar();
                    },
                    child: _imageFile == null 
                    ? placeholder
                    : Container(child: _showImage(imageData!), height: 100,)
                  ),
                ),
                TextField(
                  controller: controllerNama,
                  decoration: InputDecoration(
                    hintText: "Nama", 
                    labelText: "Nama"
                  ),
                ),
                TextField(
                  controller: controllerNIM,
                  decoration: InputDecoration(
                    hintText: "NIM", 
                    labelText: "NIM"
                  ),
                ),
                TextField(
                  controller: controllerAlamat,
                  decoration: InputDecoration(
                    hintText: "Alamat", 
                    labelText: "Alamat"
                  ),
                ),

                Padding(padding: EdgeInsets.all(10)),
                ElevatedButton(
                  onPressed: () {
                    simpanData();
                    Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => new HomePageMahasiswa() ));
                  }, 
                  child: Text("Simpan")
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}



class formEdit extends StatefulWidget {
  List list;
  int index;
  formEdit({required this.list, required this.index});
  @override
  State<formEdit> createState() => _formEditState();
}

class _formEditState extends State<formEdit> {
  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerNIM = TextEditingController();
  TextEditingController controllerAlamat = TextEditingController();

  String? imageData;
  
  File? _imageFile;
  Future _pilihGambar() async{
    var pickedImage = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxHeight: 200.0,
      maxWidth: 200.0
    );

    setState(() {
      _imageFile = File(pickedImage!.path);
    });
    imageData = base64Encode(_imageFile!.readAsBytesSync());
  }

  editData(){
    http.post(Uri.parse("http://192.168.1.17/mahasiswa/editData.php"),
    body: {
      "nama": controllerNama.text,
      "NIM": controllerNIM.text, 
      "alamat": controllerAlamat.text,
      "image": imageData,
      "id":widget.list[widget.index]['id'],
    }
    );
  }
  
   _showImage(String image){
    return Image.memory(base64Decode(image));
  }

  @override
  void initState() {
    controllerNama.text = widget.list[widget.index]['nama'];
    controllerNIM.text = widget.list[widget.index]['NIM'];
    controllerAlamat.text = widget.list[widget.index]['alamat'];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      width: double.infinity,
      height: 50.0,
      child: Icon(Icons.add_a_photo, size: 50.0,),
    );
    return Scaffold(
      appBar: AppBar(title: Text("Edit Identitas Mahasiswa"),),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  child: InkWell(
                    onTap: () async{
                      await _pilihGambar();
                    },
                    child: _imageFile == null 
                    ? placeholder
                    : Container(child: _showImage(imageData!), height: 100,)
                  ),
                ),
                TextField(
                  controller: controllerNama,
                  decoration: InputDecoration(
                    hintText: "Nama", 
                    labelText: "Nama"
                  ),
                ),
                TextField(
                  controller: controllerNIM,
                  decoration: InputDecoration(
                    hintText: "NIM", 
                    labelText: "NIM"
                  ),
                ),
                TextField(
                  controller: controllerAlamat,
                  decoration: InputDecoration(
                    hintText: "Alamat", 
                    labelText: "Alamat"
                  ),
                ),

                Padding(padding: EdgeInsets.all(10)),
                ElevatedButton(
                  onPressed: () {
                    editData();
                    Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => new HomePageMahasiswa() ));
                  }, 
                  child: Text("Simpan")
                )
              ],
            )
          ],
        ),
      ),
      
    );
  }
}