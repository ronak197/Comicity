import 'package:flutter/material.dart';
import 'package:nima/nima_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

void main(){
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MaterialApp(
      home: HomePage(),
    ));
  });
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/backg.png'), fit: BoxFit.cover),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 30.0, left: 30.0),
              child: Text("Comicity", style: TextStyle(color: Color(0xFFF700FF), fontSize: 40.0, fontWeight: FontWeight.w800),),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment(2, -1),
                  child: Container(
                    width: 300.0,
                    height: 400.0,
                    child: NimaActor('assets/robot.nma',fit: BoxFit.contain, animation: "Flight"),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: CupertinoButton(
                    child: Text('Show Comics', style: TextStyle(color: Color(0xFFE964FF)),),
                    padding: EdgeInsets.only(left: 18.0, right: 18.0),
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ComicPage()),);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ComicPage extends StatefulWidget {
  @override
  _ComicPageState createState() => _ComicPageState();
}

class _ComicPageState extends State<ComicPage> {

  List<String> comicNames = ['Doctor Strange','Skyward','Mister Miracle'];
  List<int> pageCount = [23,30,32];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF001272),
        elevation: 0.0,
        title: Text("Comics", style: TextStyle(color: Color(0xFFE964FF), fontSize: 25.0),),
      ),
      backgroundColor: Color(0xFF001272),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index){
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Comic(comicNames[index],pageCount[index])),);
              },
              child: Stack(
                children: <Widget>[
                  Image.asset('assets/contbg${index+1}.png', fit: BoxFit.fill),
                  Container(
                    padding: EdgeInsets.only(left: 20.0,top: 20.0),
                    child: Text( comicNames[index],
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Color(0xff031473)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Comic extends StatefulWidget {

  String comicName;
  int pageCount;

  Comic(this.comicName, this.pageCount);

  @override
  _ComicState createState() => _ComicState();
}

class _ComicState extends State<Comic> {

  int count = 0;
  bool urlsFetched = false;
  List<String> url = new List<String>();
  String name;

  Future<void> fetchImageUrls() async{
    for(int i =1 ; i<=(widget.pageCount); i+=1){
      StorageReference ref = FirebaseStorage.instance.ref().child('comics/$name/$name ($i).jpg');
      url.add((await ref.getDownloadURL()).toString());
      setState(() {
        count++;
      });
    }
    setState(() {
      urlsFetched = true;
    });
  }

  @override
  void initState() {
    name = widget.comicName;
    fetchImageUrls();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: urlsFetched ? PageView.builder(
            itemCount: widget.pageCount,
            itemBuilder: (BuildContext context, int index) {
              return Image.network('${url[index]}', fit: BoxFit.fill, scale: 1.0,);
            },
          ) : Text("Loading Images $count ..."),
        ),
      ),
    );
  }
}