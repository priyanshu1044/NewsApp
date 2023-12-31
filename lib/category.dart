import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:news/model.dart';

class Category extends StatefulWidget {
  String Query;
  Category({required this.Query});
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  bool isLoading = true;
  getNewsByQuery(String query) async {
    String url = "";
    if(query == "Top News" || query == "India"){
      url ="https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=8d79f51b5b9a4fbfa3f7e4c82f262f8d";
    }
    else if(query == "World"){
      url =
      "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=8d79f51b5b9a4fbfa3f7e4c82f262f8d";
    }
    else if(query == "Business"){
      url =
      "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=8d79f51b5b9a4fbfa3f7e4c82f262f8d";
    }
    else {
      url =
          "https://newsapi.org/v2/everything?q=$query&from=2023-06-20&sortBy=publishedAt&apiKey=8d79f51b5b9a4fbfa3f7e4c82f262f8d";
    }
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelList.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });
      });
    });

  }

  @override
  void initState() {
    super.initState();
    getNewsByQuery(widget.Query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "NewsApp",
          style: TextStyle(color: Color.fromARGB(120, 193, 243, 255), fontSize:20),
        ),
        backgroundColor: Color(0xff232321),
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                margin : EdgeInsets.fromLTRB(15, 25, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 12,),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child: Text(widget.Query, style: TextStyle(fontWeight: FontWeight.bold , fontSize: 30),
                      ),
                    ),
                  ],
                ),
              ),
              isLoading ? Container(height: MediaQuery.of(context).size.height - 500,
                  child :Center(child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black54),
                  ) ,)) :
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: newsModelList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 1.0,
                          child: Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(newsModelList[index].newsImg ,fit: BoxFit.fitHeight, height: 230,width: double.infinity, )
                              ),
                              Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.black12.withOpacity(0),
                                                Colors.black
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter
                                          )
                                      ),
                                      padding: EdgeInsets.fromLTRB(15, 15, 10, 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            newsModelList[index].newsHead,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(newsModelList[index].newsDes.length > 50 ? "${newsModelList[index].newsDes.substring(0,55)}...." : newsModelList[index].newsDes , style: TextStyle(color: Colors.white , fontSize: 12)
                                            ,)
                                        ],
                                      )))
                            ],
                          )),
                    );
                  }),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ElevatedButton(onPressed: () {}, child: Text("SHOW MORE")),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(120, 193, 243, 255),
                      ),
                      child: Text(
                        "SHOW MORE",
                        style: TextStyle(color: Color(0xff232321)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
