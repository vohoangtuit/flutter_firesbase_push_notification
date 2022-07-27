import 'package:flutter/material.dart';
import 'package:flutter_notifications/screens/setting.dart';

import '../my_router.dart';

class DetailPage extends StatefulWidget {
  final String? content;
  DetailPage({this.content});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
centerTitle: true,
      ),
      body: Center(
        child: Container(
          color: Colors.blueGrey,
          child: Column(
            children: [
              Text("Detail: "+widget.content!, style: TextStyle(fontSize: 18,color: Colors.white),),
              SizedBox(height: 30,),
              InkWell(child: Text('godo detail'),onTap: (){
                //var route =Navigator(context).pages.length.toString();
                String? route =ModalRoute.of(context)!.settings.name;
                print('route $route');
                if(Navigator.canPop(context)){
                  print('can pop:');
                  // Navigator.popUntil(context,
                  //   ModalRoute.withName(route),
                  // );
                  if(route!.compareTo(TAG_DETAIL_SCREEN)==0){
                    Navigator.pop(context);
                  }else{
                    print('not compareTo');
                  }

                }else{
                  print('can not pop:');
                }
                Navigator.push(context, MaterialPageRoute(builder: (content)=>DetailPage(content: 'content')));

              },)
            ],
          ),
        ),
      ),

    );
  }
}
