import 'package:flutter/material.dart';
import 'package:lcwassist/Core/Abstracts/IsLcwAssistUIPage.dart';
import 'package:lcwassist/Core/BaseConst/LcwAssistEnumType.dart';

import 'package:lcwassist/Core/CoreFunctions/LcwAssistLoading.dart';
import 'package:lcwassist/Core/CoreFunctions/LcwAssistSnackBarDialogs/LcwAssistSnackBarDialogInfo.dart';
import 'package:lcwassist/DataAccess/CapacityAnaliysisDTOs/CapacityAnaliysisReportRequestDTO.dart';
import 'package:lcwassist/DataAccess/CapacityAnaliysisDTOs/CapacityAnaliysisReportResponseDTO.dart';
import 'package:lcwassist/DataAccess/CapacityAnaliysisDTOs/CapacityAnalysisMetricsFilterDTO.dart';
import 'package:lcwassist/DataAccess/StoreReportOperations/StoreChooseDTOs/StoreChooseResponeDTO.dart';
import 'package:lcwassist/LcwAssistBase/LcwAssistApplicationManager.dart';
import 'package:lcwassist/LcwAssistUI/CapacityOperations/CapacityFilterPage.dart';
import 'package:lcwassist/Style/CoreWidgets/LcwAssistCustomWidgets.dart';
import 'package:lcwassist/Style/LcwAssistColor.dart';
import 'package:lcwassist/Style/LcwAssistTextStyle.dart';


void main(){
  runApp(new MaterialApp(
    home:new CapacityAnalysisPage(),
  ));
}

class CapacityAnalysisPage extends StatefulWidget{

  @override
  CapacityAnalysisPageState createState() => new CapacityAnalysisPageState();
}

class CapacityAnalysisPageState extends State<CapacityAnalysisPage>  with TickerProviderStateMixin implements IsLcwAssistUIPage{

LcwAssistApplicationManager applicationManager = new LcwAssistApplicationManager();
Stores currentStore;
bool sayfaYuklendiMi = false;
final GlobalKey<ScaffoldState> scaffoldState = new GlobalKey<ScaffoldState>();

CapacityAnaliysisReportResponseDTO raporResult;
CapacityAnalysisMetricsFilterDTO raporFilterList;

//Floating buton için
    static const List<IconData> icons = const [  Icons.thumb_up, Icons.thumb_down ];
    static const List<Color> iconColors = const [ Color.fromRGBO(77,174,81, 1.0),Color.fromRGBO(255,99,71, 1.0) ];
    //static const List<Color> iconColors = const [ Colors.white,Colors.white ];
    //index == 0 ? Color.fromRGBO(255,99,71, 1.0) : Color.fromRGBO(77,174,81, 1.0),
    AnimationController _controller;
/////////////////


  @override
  void initState() {
super.initState();

//Floating buton için
    _controller = new AnimationController(vsync: this,
      duration: const Duration(milliseconds: 500),
    );
///////////////////////

 WidgetsBinding.instance
        .addPostFrameCallback((_) => loaded(context));
  }

Future<void> executeAfterBuild() async {
  
}


Future loaded(BuildContext context) async{
applicationManager.setCurrentLanguage = await applicationManager.languagesService.currentLanguage();
 //await new Future.delayed(const Duration(seconds: 2 ));
   setState(() {
LcwAssistLoading.showAlert(context,applicationManager.currentLanguage.getyukleniyor);
});

 currentStore = await applicationManager.serviceManager.storeChooseService.getCurrentStore();

 CapacityAnaliysisReportRequestDTO parameter = new CapacityAnaliysisReportRequestDTO();

parameter.setAksesuarUrun = "";
parameter.setBuyerGrupTanim = "";
parameter.setMagazaKod = currentStore.storeCode;
parameter.setMerchAltGrupKod = "";
parameter.setMerchYasGrupKod = "";

await loadCapacityReport(parameter);

//await new Future.delayed(const Duration(seconds: 2 ));

sayfaYuklendiMi = true;
 setState(() {
  Navigator.pop(context);

 });

    }


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: sayfaYuklendiMi == true ? storeReportPageBody() : Container(child: Text(''),),
      key: scaffoldState,
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endDocked,
    floatingActionButton: Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),child: thisFloatActionButton(),),//thisFloatActionButton(),
    bottomNavigationBar:thisBottomNavigator(),
      //body: storeReportPageBody()

    );


    }

  Widget storeReportPageBody(){
      return

       Container(
         color: LcwAssistColor.thirdColor,
         child: Column(children: <Widget>[
Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
     Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
       children: <Widget>[

Container(
height: 75.0,
width: 75.0,
  child:
Padding(child: Image.asset('assets/store_image.png',fit: BoxFit.cover,),padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),),),
Container(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
      Padding(padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),child: Text(applicationManager.currentLanguage.getmagazaKodu+ " : ",style: TextStyle(color: Colors.white,fontFamily: LcwAssistTextStyle.currentTextFontFamily,fontSize: 15.0,fontWeight: FontWeight.bold),),),
      Padding(padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),child: Text(currentStore.storeCode,style: TextStyle(color: Colors.white,fontFamily: LcwAssistTextStyle.currentTextFontFamily,fontSize: 15.0,fontWeight: FontWeight.bold),),)
    ],),
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
      Padding(padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 10.0),child: Text(applicationManager.currentLanguage.getmagazaAdi+' : ',style: TextStyle(color: Colors.white,fontFamily: LcwAssistTextStyle.currentTextFontFamily,fontSize: 15.0,fontWeight: FontWeight.bold),),),
      Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 10.0),child: Text(currentStore.storeName,style: TextStyle(color: Colors.white,fontFamily: LcwAssistTextStyle.currentTextFontFamily,fontSize: 15.0,fontWeight: FontWeight.bold),),)
    ],),

  ],),
)

     ],)

        ],
      ),
    





           
// Card(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//      Row(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.start,
//        children: <Widget>[

// Container(
// height: 75.0,
// width: 75.0,
//   child:
// Padding(child: Image.asset('assets/store_image.png',fit: BoxFit.cover,),padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),),),
// Container(
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: <Widget>[
//     Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: <Widget>[
//       Padding(padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),child: Text('Mağaza Kodu: ',style: TextStyle(color: LcwAssistColor.reportCardHeaderColor,fontFamily: LcwAssistTextStyle.currentTextFontFamily,fontSize: 15.0,fontWeight: FontWeight.bold),),),
//       Padding(padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),child: Text(currentStore.storeCode,style: TextStyle(color: LcwAssistColor.reportCardSubHeaderColor,fontFamily: LcwAssistTextStyle.currentTextFontFamily,fontSize: 15.0,fontWeight: FontWeight.bold),),)
//     ],),
//     Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: <Widget>[
//       Padding(padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 10.0),child: Text('Mağaza Adı: ',style: TextStyle(color: LcwAssistColor.reportCardHeaderColor,fontFamily: LcwAssistTextStyle.currentTextFontFamily,fontSize: 15.0,fontWeight: FontWeight.bold),),),
//       Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 10.0),child: Text(currentStore.storeName,style: TextStyle(color: LcwAssistColor.reportCardSubHeaderColor,fontFamily: LcwAssistTextStyle.currentTextFontFamily,fontSize: 15.0,fontWeight: FontWeight.bold),),)
//     ],),

//   ],),
// )

//      ],)

//         ],
//       ),
//     )
 
 Expanded(flex: 70,child: Container(color: Colors.grey[100],child: Padding(padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),child: buildPageView(),),),),
 Expanded(flex: 1,child: Container(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
        alignment: Alignment.centerRight,
        color: LcwAssistColor.backGroundColor,
        child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image.asset('assets/diagram1.png')
          ],
        ),),)

      ]));
    }

  Widget sayfa(List<Widget> satirlar){
    return Container(
    //padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
    child: Column(
    children: <Widget>[
      Expanded(child: satirlar[0]),
      Expanded(child: satirlar[1]),
      Expanded(child: satirlar[2]),
    ],
  ));
}

  Widget buildPageView() {


List<Widget> sayfa1 = new List<Widget>();

sayfa1.add(Row (children: <Widget>[
  Expanded(child :
  
  LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.gettoplamFiiliDolulukBDHaric,raporResult.toplamFiiliDolulukLCM,false)
  
  ),
  Expanded(child :LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.getnetNihaiLCMDoluluk,raporResult.netNihaiLCMDoluluk,false))],));

sayfa1.add(Row (children: <Widget>[
  Expanded(child :LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.getreyonDolulukLCM,raporResult.reyonDolulukLCM,false)),
  Expanded(child :LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.getdepoDolulukLCM,raporResult.depoDolulukLCM,false))],));


sayfa1.add(Row (children: <Widget>[
  Expanded(child :LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.getonayLimiti,raporResult.onayLimiti,false)),
  Expanded(child :LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.gettoplamKapLCMNetNihaiKapLCM,raporResult.toplamKapOverNetNihai,false))],));


//SAYFA 2

List<Widget> sayfa2 = new List<Widget>();

sayfa2.add(Row (children: <Widget>[
  Expanded(child :LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.getreyonStokAdet,raporResult.reyonStokAdet,false)),
  Expanded(child :LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.getdepoStokAdet,raporResult.depoStokAdet,false))],));
sayfa2.add(Row (children: <Widget>[
  Expanded(child :LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.gettoplamStokAdet,raporResult.toplamStokAdet,false)),
  Expanded(child :LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.getson7gunSatisAdet,raporResult.sonYediGunSatis,false))],));
sayfa2.add(Row (children: <Widget>[
  Expanded(child :LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.getfiiliCover,raporResult.fiiliCover,false)),
  Expanded(child :Text(''))],));



List<Widget> sayfa3 = new List<Widget>();

sayfa3.add(Row (children: <Widget>[
  Expanded(child :LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.getyolStokAdet,raporResult.yolStokAdet,false)),
  Expanded(child :LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.getonayliOnyasizRezerveAdet,raporResult.onayliOnaysizRezerveAdet,false))],));
sayfa3.add(Row (children: <Widget>[
  Expanded(child :LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.gettransferINOUT,raporResult.transferInOut,false)),
  Expanded(child :Text(''))],));

sayfa3.add(Row (children: <Widget>[
  Expanded(child :Text('')),
  Expanded(child :Text(''))],));

return PageView(
      children: [
        sayfa(sayfa1),
        sayfa(sayfa2),
        sayfa(sayfa3),
      ],
    );

// return ListView
// (
//   children: <Widget>[
//     LcwAssistCustomWidgets.tutarUcluCardAltAlta(LcwAssistColor.thirdColor,sayfaBirSatir1,false),
//     LcwAssistCustomWidgets.tutarUcluCardAltAlta(LcwAssistColor.thirdColor,sayfaBirSatir3,false),

// LcwAssistCustomWidgets.tutarCardYatay(LcwAssistColor.thirdColor,'Hedef Tutar',raporResult.bY_HedefTutar,false),
// LcwAssistCustomWidgets.tutarCardYatay(LcwAssistColor.thirdColor,'Hedef Tut. Yüz',raporResult.magazaHedefTutturmaYuzdesi,false),
// LcwAssistCustomWidgets.tutarCardYatay(LcwAssistColor.thirdColor,'Conversion Rate',raporResult.conversionRate,false),
// LcwAssistCustomWidgets.tutarCardYatay(LcwAssistColor.thirdColor,'Müş. Ziy. Say',raporResult.magazaTrafik,false),
// LcwAssistCustomWidgets.tutarCardYatay(LcwAssistColor.thirdColor,'Sep Büy.Adet',raporResult.sepetBuyukAdet,false),
// LcwAssistCustomWidgets.tutarCardYatay(LcwAssistColor.thirdColor,'Sepet Büy. Tutar(KDVsiz)',raporResult.sepetBuyukTutarKDVsiz,false),
// LcwAssistCustomWidgets.tutarCardYatay(LcwAssistColor.thirdColor,'Stok Devir Hızı',raporResult.stokDevirHizi,false),
// LcwAssistCustomWidgets.tutarCardYatay(LcwAssistColor.thirdColor,'M2 Verimlilik',raporResult.m2Verimlilik,false),

//   ],
// );


}

Future loadCapacityReport(CapacityAnaliysisReportRequestDTO parameter) async{



CapacityAnaliysisReportResponseDTO result = await applicationManager.serviceManager.capacityAnaliysisService.capacityAnalysisMetrics(parameter);
raporResult = result;

raporFilterList = await applicationManager.serviceManager.capacityAnaliysisService.capacityAnalysisMetricsFilters();

}

Widget thisBottomNavigator() {
  return
   BottomAppBar(
      color: Colors.white,//Color.fromRGBO(44, 152, 240, 1.0),
      //shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
           IconButton(icon: Icon(Icons.menu,color: Colors.white,), onPressed: () {},),
          // IconButton(icon: Icon(Icons.search), onPressed: () {},),
        ],
      ),
    );
}

Widget thisFloatActionButton(){
return FloatingActionButton(
      child: const Icon(Icons.filter_list), onPressed: () {_openFilterDialog();},);
    }

Widget buildFloatingButtonHasSub() {
  return  new Column(
        mainAxisSize: MainAxisSize.min,
        children: new List.generate(icons.length, (int index) {
          Widget child = new Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: new ScaleTransition(
              scale: new CurvedAnimation(
                parent: _controller,
                curve: new Interval(
                  0.0,
                  1.0 - index / icons.length / 2.0,
                  curve: Curves.easeOut
                ),
              ),
              child: new FloatingActionButton(
                heroTag: null,
                backgroundColor: Colors.white,//index == 0 ? Color.fromRGBO(255,99,71, 1.0) : Color.fromRGBO(77,174,81, 1.0),
                mini: false,
                child: new Icon(icons[index],  color: iconColors[index]),
                onPressed: () { },
              ),
            ),
          );
          return child;
        }).toList()..add(
          new FloatingActionButton(
            heroTag: null,
            backgroundColor: LcwAssistColor.floatingButtonColor,//Color.fromRGBO(44,45,58,1.0),
            child: new AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return new Transform(
                  transform: new Matrix4.rotationZ(_controller.value * 1 *3.14),
                  alignment: FractionalOffset.center,
                  child: new Icon(_controller.isDismissed ? Icons.filter_list : Icons.close,size: 35.0,),
                );
              },
            ),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
          ),
        ),
      );
  }

void _openFilterDialog() async{
//  CapacityAnaliysisReportRequestDTO  result = await  Navigator.of(context).push(new MaterialPageRoute<Null>(
//       builder: (BuildContext context) {
//         return new CapacityFilterPage(storesResponse:this.raporFilterList);
//       },
//     fullscreenDialog: true
//   ));

CapacityAnaliysisReportRequestDTO result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CapacityFilterPage(storesResponse:this.raporFilterList)),
  );
  //String assas = result.getAksesuarUrun;

  result.setMagazaKod = currentStore.storeCode;

await loadCapacityReport(result);
setState(() {  
});

  //LcwAssistSnackBarDialogInfo(result.getAksesuarUrun,scaffoldState,LcwAssistSnagitType.info).snackbarShow();
}



}

