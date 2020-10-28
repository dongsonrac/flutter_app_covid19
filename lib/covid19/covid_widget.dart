import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_covid19/covid19/covid_bloc.dart';
import 'package:flutter_app_covid19/covid19/covid_event.dart';
import 'package:flutter_app_covid19/covid19/covid_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io' show Platform;

class CovidWidget extends StatefulWidget {
  @override
  _CovidWidgetState createState() => _CovidWidgetState();
}

class _CovidWidgetState extends State<CovidWidget> {
  Bloc covidbloc;
  TextEditingController searchController;

  final GlobalKey<ScaffoldState> mScaffoldState = new GlobalKey<ScaffoldState>();

  void RefreshClick(String str) {
    final snackBar = new SnackBar(content: Text(str));
    mScaffoldState.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    covidbloc = CovidBloc();
    covidbloc.add(InitialCovidEvent());
    TimerInternet(covidbloc);
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double heightscreen = MediaQuery.of(context).size.height;
    double widthscreen = MediaQuery.of(context).size.width;

    return Scaffold(
      key: mScaffoldState,
      resizeToAvoidBottomPadding: false,
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("COVID-19"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              print("Refresh tap");
              searchController = TextEditingController();
              covidbloc.add(InitialCovidEvent());
              RefreshClick("Refresh !!!");
              TimerInternetF5(covidbloc);
            },
          )
        ],
      ),
      body: BlocBuilder<CovidBloc, CovidState>(
        cubit: covidbloc,
        builder: (context, state) {
          return Container(
            width: widthscreen,
            color: Colors.white,
            child: state.global == null
                ? Center(
                    child: state.internet == true
                        ? Center(child: Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator(),)
                        : Center(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("images/no-wifi.png", width: 100, height: 100,),
                            SizedBox(height: 10,),
                            Text("No internet access !", style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        )), // Loads Circular Loading Animation
                  )
                : Padding(
                  padding: EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onPanDown: (_) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(top: 0.0, bottom: 4.0),
                            child: Row(
                              children: [
                                Image.asset("images/global.png", height: 20,),
                                Text(" Global COVID-19 Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2.0,
                                color: Colors.indigo,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              color: Colors.indigo.withOpacity(0.8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 104,
                                    child: Container(
                                      color: Colors.indigo,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("   " + state.global.totalConfirmed + "   ",style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),),
                                          SizedBox(height: 2.0,),
                                          Text("TotalConfirmed", style: TextStyle(color: Colors.white, fontSize: 14),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16.0,),
                                  Container(
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("New Confirmed:   " + state.global.newConfirmed, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white),), SizedBox(height: 2.0,),
                                        Text("New Deaths:         " + state.global.newDeaths, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white),),SizedBox(height: 2.0,),
                                        Text("Total Deaths:        " + state.global.totalDeaths, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white),),SizedBox(height: 2.0,),
                                        Text("New Recovered:   " + state.global.newRecovered, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white),),SizedBox(height: 2.0,),
                                        Text("Total Recovered:  " + state.global.totalRecovered, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white),),SizedBox(height: 2.0,),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                              child: Row(
                                children: [
                                  Image.asset("images/vietnam.png", height: 16,),
                                  Text(" VietNam COVID-19 Summary", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                                ],
                              ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 52,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: Colors.orangeAccent),
                                    color: Colors.orangeAccent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(state.mycountry.totalConfirmed,style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),),
                                      Text("Confirmed", style: TextStyle(color: Colors.white, fontSize: 14),),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  height: 52,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: Colors.green),
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(state.mycountry.totalRecovered,style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),),
                                      Text("Recovered", style: TextStyle(color: Colors.white, fontSize: 14),),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  height: 52,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: Colors.redAccent),
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(state.mycountry.totalDeaths, style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),),
                                      Text("Deaths",style: TextStyle(color: Colors.white, fontSize: 14),),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height: 4.0,),
                           Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 38,
                                        alignment: Alignment.center,
                                        child: TextField(
                                          controller: searchController,
                                            decoration: InputDecoration(
                                              hintText: 'Type Text Here...',
                                              hintStyle: TextStyle(color: Colors.grey),
                                              fillColor: Colors.white70,
                                              contentPadding: EdgeInsets.all(8.0),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                borderSide: BorderSide(color: Colors.indigo.withOpacity(0.7)),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                borderSide: BorderSide(color: Colors.indigo.withOpacity(0.7)),
                                              ),
                                            )
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4.0,),
                                    RaisedButton(
                                      color: Colors.indigo.withOpacity(0.7),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          side: BorderSide(color: Colors.indigo.withOpacity(0.7)),
                                      ),
                                      onPressed: () {
                                        print("search");
                                        covidbloc.add(SearchCountryCovidEvent(
                                            countryname: searchController.text));
                                        FocusScope.of(context).requestFocus(FocusNode());
                                      },
                                      child: Text(" SEARCH ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0,),
                                /// list view
                                state.internet == true ?
                                Container(
                                  width: widthscreen,
                                  height: heightscreen - 378,
                                  child: ListView.builder(
                                    itemCount: state.listcountry.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.indigo.withOpacity(0.4),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                             ),
                                            child: ExpansionTile(
                                              onExpansionChanged: (value){
                                                FocusScope.of(context).requestFocus(FocusNode());
                                              },
                                              title: Text(
                                                  "[${index + 1}] - ${state.listcountry[index].countryNameEn.toUpperCase()}", style: TextStyle(fontWeight: FontWeight.w500),),
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("\u{1F499} Total Confirmed: " + state.listcountry[index].totalConfirmed), SizedBox(height: 1.0,),
                                                    Text("\u{1F497} Total Recovered: " + state.listcountry[index].totalRecovered), SizedBox(height: 1.0,),
                                                    Text("\u{1F494} Total Deaths: " + state.listcountry[index].totalDeaths), SizedBox(height: 10.0,),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 6.0,)
                                        ],
                                      );
                                    },
                                  ),
                                ) : Container(
                                  width: widthscreen,
                                  height: heightscreen - 380,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.perm_scan_wifi),
                                      Text(" Check Your Connection and Try Again!",
                                        style: TextStyle(fontSize: 16),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ),
                ),
          );
        },
      ),
    );
  }
}

void TimerInternet(CovidBloc covidbloc) {
  final seconds = Duration(seconds: 15);
  Timer(seconds, () {
    if (covidbloc.state.global == null) {
      covidbloc.add(NoInternetCovidEvent());
      print("No Internet !!!");
    }
  });
}
void TimerInternetF5(CovidBloc covidbloc) {
  final seconds = Duration(seconds: 10);
  Timer(seconds, () {
    //print(covidbloc.state.listcountry.length);
    try {
      if (covidbloc.state.listcountry.length == 0) {
        covidbloc.add(NoInternetCovidEvent());
        print("No Internet F5 !!!");
      }
    } catch (e) {
      print(e);
    }
  });
}
