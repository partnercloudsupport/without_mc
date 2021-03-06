import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lcwassist/Core/Abstracts/IsLcwAssistUIPage.dart';
import 'package:lcwassist/Core/BaseConst/LcwAssistEnumType.dart';
import 'package:lcwassist/Core/CoreFunctions/LcwAssistLoading.dart';
import 'package:lcwassist/Core/GlobalWidget/LcwAssistSnackBarDialogs/LcwAssistSnackBarDialogInfo.dart';
import 'package:lcwassist/Core/GlobalWidget/LcwAssistMessageDialogs/LcwAssistAlertDialogInfo.dart';
import 'package:lcwassist/Core/GlobalWidget/ChartWidgets/ScatterPlotComboLineChart.dart';
import 'package:lcwassist/Core/GlobalWidget/ChartWidgets/StackedAreaLineChart.dart';
import 'package:lcwassist/DataAccess/ResponseBase.dart';
import 'package:lcwassist/DataAccess/StoreReportOperations/StoreChooseDTOs/StoreChooseListViewDTO.dart';
import 'package:lcwassist/DataAccess/StoreReportOperations/StoreChooseDTOs/StoreChooseResponeDTO.dart';
import 'package:lcwassist/DataAccess/StoreReportOperations/StoreChooseDTOs/StoreReportRequestDTO.dart';
import 'package:lcwassist/DataAccess/StoreReportOperations/StoreChooseDTOs/StoreReportResponseDTO.dart';
import 'package:lcwassist/DataAccess/WidgetDto.dart';
import 'package:lcwassist/LcwAssistBase/LcwAssistApplicationManager.dart';
import 'package:lcwassist/LcwAssistUI/StoreReportOperations/StoreFilterPage.dart';
import 'package:lcwassist/Services/LcwAssistUIServiceOperations/StoreReportOperations/StoreChooseService.dart';
import 'package:lcwassist/Style/CoreWidgets/LcwAssistCustomWidgets.dart';

import 'package:lcwassist/Style/LcwAssistColor.dart';
import 'package:lcwassist/Style/LcwAssistTextStyle.dart';
import 'package:lcwassist/Style/LcwAssistWidgets/AssistReportTable.dart';
 

void main(){
  runApp(new MaterialApp(
    home:new StoreReportPage(),
  ));
}

class StoreReportPage extends StatefulWidget{

  @override
  StoreReportPageState createState() => new StoreReportPageState();
}

class StoreReportPageState extends State<StoreReportPage>  with TickerProviderStateMixin implements IsLcwAssistUIPage{

LcwAssistApplicationManager applicationManager = new LcwAssistApplicationManager();
StoreChooseListViewDTO currentStore;
List<AssitReportDataDTO> assitReportDataDTO;
bool sayfaYuklendiMi = false;
 final StoreReportRequestDTO parameter = new StoreReportRequestDTO();
StoreReportResponseDTO raporResult;
StorePeriodFilterDTO storeCurrentFilterParameter;
//Floating buton için
    static const List<IconData> icons = const [  Icons.thumb_up, Icons.thumb_down ];
    static const List<Color> iconColors = const [ Colors.green,Colors.red ];
    AnimationController _controller;
/////////////////


  @override
  void initState() {
super.initState();

SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
  ]);

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

 //await new Future.delayed(const Duration(seconds: 2 ));
 applicationManager.setCurrentLanguage = await applicationManager.serviceManager.languagesService.currentLanguage();


 if(await applicationManager.utils.checkToTokenExpireRedirectToLogin(applicationManager.currentLanguage, context))
 {
   applicationManager.utils.navigateToLoginPage(context);
 return;
 }


   setState(() {
LcwAssistLoading.showAlert(context,applicationManager.currentLanguage.getyukleniyor);
});

 currentStore = await applicationManager.serviceManager.storeChooseService.getCurrentStore();
 

 parameter.setStoreRef = 654;
 parameter.setFilterDonem = "YTD";

 await loadStoreReport(parameter);


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
      floatingActionButtonLocation: 
      FloatingActionButtonLocation.endDocked,
    floatingActionButton: Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),child: thisFloatActionButton(),),//buildFloatingButtonHasSub(),
    bottomNavigationBar:thisBottomNavigator(),
      //body: storeReportPageBody()

    );
    
    
    }

    Widget yeniHeader(){
  return 
   
  Column(
     mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
      Card(child: 
Container(
  padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
  decoration:  BoxDecoration(
    border:  Border(
       left:  BorderSide(width: 6.0, color:  Color.fromRGBO(0,116,198, 1.0)),
    )),
  child:
    Padding(padding: EdgeInsets.fromLTRB(10, 5, 10, 10),child: 
    Column(children: <Widget>[
      Container(
  padding: EdgeInsets.fromLTRB(0, 10, 5, 10),
  decoration:  BoxDecoration(
    border:  Border(
       bottom:  BorderSide(width: 0.5, color:  Colors.grey[400]),
    )),
  child: 
    Row(
      
      children: <Widget>[
    Padding(padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
    child: Icon(Icons.account_balance,
      color: LcwAssistColor.pageCardHeaderColor),),
    
        Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),child: 
        Text("Mağaza Bilgileri",style: TextStyle(color: LcwAssistColor.pageCardHeaderColor,
        fontFamily: LcwAssistTextStyle.currentTextFontFamily,fontSize: 17.0),),)
      
    ]))
    ,
        Row(
      
      children: <Widget>[
      Padding(padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),child: Text(applicationManager.currentLanguage.getmagazaAdi+' : ',style: TextStyle(color: LcwAssistColor.reportCardHeaderColor,fontFamily: LcwAssistTextStyle.currentTextFontFamily,fontSize: 17.0),),),
      
Expanded(child: 
        Padding(padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),child: 
        Text(currentStore.storeName,style: TextStyle(color: LcwAssistColor.reportCardSubHeaderColor,
        fontFamily: LcwAssistTextStyle.currentTextFontFamily,fontSize: 17.0),),)
      ,)
    ])
    
    ],),)
    ))    
    ],);
}


Widget storeReportPageBody(){

return 
new Column(
  children: <Widget>[

Padding(padding: EdgeInsets.fromLTRB(6, 3, 6, 0),child: yeniHeader(),),

Expanded(child: AssistReportTable(assitReportData: this.assitReportDataDTO)),

//SingleChildScrollView(
                //child:
// Column(children: <Widget>[
// LcwAssistCustomWidgets.satir(Color.fromRGBO(239,138,14, 1.0),  applicationManager.currentLanguage.getsatisTutarKDVsiz,raporResult.bY_SatisTutar_KDVsiz,false),
// LcwAssistCustomWidgets.satir(Color.fromRGBO(0,116,198, 1.0),   applicationManager.currentLanguage.gettutarBuyume,raporResult.tutarBuyume,false),
// LcwAssistCustomWidgets.satir(Color.fromRGBO(54,163,247, 1.0),  applicationManager.currentLanguage.getsatisTutarGY_KDVsiz,raporResult.gY_SatisTutar_KDVsiz,false),
// LcwAssistCustomWidgets.satir(Color.fromRGBO(100,105,188, 1.0), applicationManager.currentLanguage.gethedefTutar,raporResult.bY_HedefTutar,false),
// LcwAssistCustomWidgets.satir(Color.fromRGBO(196,66,88, 1.0),   applicationManager.currentLanguage.gethedefTutarYuzdesi,raporResult.magazaHedefTutturmaYuzdesi,false),
// LcwAssistCustomWidgets.satir(Color.fromRGBO(38,137,116, 1.0),  applicationManager.currentLanguage.getsatisAdet,raporResult.bY_SatisAdet,false),
// LcwAssistCustomWidgets.satir(Color.fromRGBO(0,162,181, 1.0),   applicationManager.currentLanguage.getadetBuyume,raporResult.adetBuyume,false),
// LcwAssistCustomWidgets.satir(Color.fromRGBO(54,163,247, 1.0),  applicationManager.currentLanguage.getsatisAdetGY,raporResult.gY_SatisAdet,false),
// LcwAssistCustomWidgets.satir(Color.fromRGBO(0,116,198, 1.0),   applicationManager.currentLanguage.getconversionRate,raporResult.conversionRate,false),
// LcwAssistCustomWidgets.satir(Color.fromRGBO(239,138,14, 1.0),  applicationManager.currentLanguage.getmusteriZiyareySayisi,raporResult.magazaTrafik,false),
// LcwAssistCustomWidgets.satir(Color.fromRGBO(100,105,188, 1.0), applicationManager.currentLanguage.getsepetBuyukluguAdet,raporResult.sepetBuyukAdet,false),
// LcwAssistCustomWidgets.satir(Color.fromRGBO(196,66,88, 1.0),   applicationManager.currentLanguage.getsepetBuyukluguTutarKDVsiz,raporResult.sepetBuyukTutarKDVsiz,false),
// LcwAssistCustomWidgets.satir(Color.fromRGBO(38,137,116, 1.0),  applicationManager.currentLanguage.getstokDevirHizi,raporResult.stokDevirHizi,false),
// LcwAssistCustomWidgets.satir(Color.fromRGBO(0,162,181, 1.0),   applicationManager.currentLanguage.getM2Verimlilik,raporResult.m2Verimlilik,false),

// ],)

 // ),
//)

  ]
);
}

Widget storeReportPageBody0(){

return 
new Column(
  children: <Widget>[
    Expanded(flex: 1,child: Card(child: Column(
      children: <Widget>[
        Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    Row(children: <Widget>[
    Padding(padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),child: Icon(Icons.account_balance,color: Colors.grey[700],size: 30,),),
      Padding(padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),child: Text(applicationManager.currentLanguage.getmagazaAdi+' : ',style: TextStyle(color: LcwAssistColor.reportCardHeaderColor,fontFamily: LcwAssistTextStyle.currentTextFontFamily,fontSize: 17.0),),),
      Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),child: Text(currentStore.storeName,style: TextStyle(color: LcwAssistColor.reportCardSubHeaderColor,fontFamily: LcwAssistTextStyle.currentTextFontFamily,fontSize: 17.0),),)
    ])
    
  ],)
      ],
    )),),
    Expanded(flex: 10,child: 
      SingleChildScrollView(
                child:
Column(children: <Widget>[
LcwAssistCustomWidgets.satir(Color.fromRGBO(54,163,247, 1.0),  applicationManager.currentLanguage.getsatisTutarKDVsiz,raporResult.bY_SatisTutar_KDVsiz,false),
LcwAssistCustomWidgets.satir(Color.fromRGBO(0,116,198, 1.0),   applicationManager.currentLanguage.gettutarBuyume,raporResult.tutarBuyume,false),
LcwAssistCustomWidgets.satir(Color.fromRGBO(239,138,14, 1.0),  applicationManager.currentLanguage.getsatisTutarGY_KDVsiz,raporResult.gY_SatisTutar_KDVsiz,false),
LcwAssistCustomWidgets.satir(Color.fromRGBO(100,105,188, 1.0), applicationManager.currentLanguage.gethedefTutar,raporResult.bY_HedefTutar,false),
LcwAssistCustomWidgets.satir(Color.fromRGBO(196,66,88, 1.0),   applicationManager.currentLanguage.gethedefTutarYuzdesi,raporResult.magazaHedefTutturmaYuzdesi,false),
LcwAssistCustomWidgets.satir(Color.fromRGBO(38,137,116, 1.0),  applicationManager.currentLanguage.getsatisAdet,raporResult.bY_SatisAdet,false),
LcwAssistCustomWidgets.satir(Color.fromRGBO(0,162,181, 1.0),   applicationManager.currentLanguage.getadetBuyume,raporResult.adetBuyume,false),
LcwAssistCustomWidgets.satir(Color.fromRGBO(54,163,247, 1.0),  applicationManager.currentLanguage.getsatisAdetGY,raporResult.gY_SatisAdet,false),
LcwAssistCustomWidgets.satir(Color.fromRGBO(0,116,198, 1.0),   applicationManager.currentLanguage.getconversionRate,raporResult.conversionRate,false),
LcwAssistCustomWidgets.satir(Color.fromRGBO(239,138,14, 1.0),  applicationManager.currentLanguage.getmusteriZiyareySayisi,raporResult.magazaTrafik,false),
LcwAssistCustomWidgets.satir(Color.fromRGBO(100,105,188, 1.0), applicationManager.currentLanguage.getsepetBuyukluguAdet,raporResult.sepetBuyukAdet,false),
LcwAssistCustomWidgets.satir(Color.fromRGBO(196,66,88, 1.0),   applicationManager.currentLanguage.getsepetBuyukluguTutarKDVsiz,raporResult.sepetBuyukTutarKDVsiz,false),
LcwAssistCustomWidgets.satir(Color.fromRGBO(38,137,116, 1.0),  applicationManager.currentLanguage.getstokDevirHizi,raporResult.stokDevirHizi,false),
LcwAssistCustomWidgets.satir(Color.fromRGBO(0,162,181, 1.0),   applicationManager.currentLanguage.getM2Verimlilik,raporResult.m2Verimlilik,false),

],)

  ),)
  ],
);
}

Widget storeReportPageBody2(){
      return
            
       Container(child: Column(children: <Widget>[
Card(
      child: Column(
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
      Padding(padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),child: Text(applicationManager.currentLanguage.getmagazaKodu+ ' : ',style: TextStyle(color: LcwAssistColor.reportCardHeaderColor,fontFamily: LcwAssistTextStyle.currentTextFontFamily,fontSize: 15.0,fontWeight: FontWeight.bold),),),
      Padding(padding: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 10.0),child: Text(currentStore.storeCode,style: TextStyle(color: LcwAssistColor.reportCardSubHeaderColor,fontFamily: LcwAssistTextStyle.currentTextFontFamily,fontSize: 15.0,fontWeight: FontWeight.bold),),)
    ],),
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
      Padding(padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 10.0),child: Text(applicationManager.currentLanguage.getmagazaAdi+' : ',style: TextStyle(color: LcwAssistColor.reportCardHeaderColor,fontFamily: LcwAssistTextStyle.currentTextFontFamily,fontSize: 15.0,fontWeight: FontWeight.bold),),),
      Padding(padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 10.0),child: Text(currentStore.storeName,style: TextStyle(color: LcwAssistColor.reportCardSubHeaderColor,fontFamily: LcwAssistTextStyle.currentTextFontFamily,fontSize: 15.0,fontWeight: FontWeight.bold),),)
    ],),
    
  ],),
)

     ],)
    
        ],
      ),
    )

 ,
 Expanded(flex: 70,child: Container(color: LcwAssistColor.backGroundColor,child: Padding(padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),child: buildPageView(),),),),
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
    child: Column(
    children: <Widget>[
      Expanded(child: satirlar[0]),
      Expanded(child: satirlar[1]),
      Expanded(child: satirlar[2]),
    ],
  ));
}

Widget buildPageView() {

List<UcluCardTextDTO> sayfaBirSatir1 = new List<UcluCardTextDTO>();
sayfaBirSatir1.add(new UcluCardTextDTO(applicationManager.currentLanguage.getsatisTutarKDVsiz,raporResult.bY_SatisTutar_KDVsiz));
sayfaBirSatir1.add(new UcluCardTextDTO(applicationManager.currentLanguage.gettutarBuyume,raporResult.tutarBuyume));
sayfaBirSatir1.add(new UcluCardTextDTO(applicationManager.currentLanguage.getsatisTutarGY_KDVsiz,raporResult.gY_SatisTutar_KDVsiz));

List<UcluCardTextDTO> sayfaBirSatir3 = new List<UcluCardTextDTO>();
sayfaBirSatir3.add(new UcluCardTextDTO(applicationManager.currentLanguage.getsatisAdet,raporResult.bY_SatisAdet));
sayfaBirSatir3.add(new UcluCardTextDTO(applicationManager.currentLanguage.getadetBuyume,raporResult.adetBuyume));
sayfaBirSatir3.add(new UcluCardTextDTO(applicationManager.currentLanguage.getsatisAdetGY,raporResult.gY_SatisAdet));

List<Widget> sayfa1 = new List<Widget>();
sayfa1.add(Row (children: <Widget>[Expanded(child :LcwAssistCustomWidgets.tutarUcluCardYanYana(sayfaBirSatir1,false))],));

sayfa1.add(Row (children: <Widget>[Expanded(child :LcwAssistCustomWidgets.tutarUcluCardYanYana(sayfaBirSatir3,false))],));

sayfa1.add(Row (children: <Widget>[
  Expanded(child :LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.gethedefTutar,raporResult.bY_HedefTutar,false)),
  Expanded(child :LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.gethedefTutarYuzdesi,raporResult.magazaHedefTutturmaYuzdesi,false))],));


//SAYFA 2

List<Widget> sayfa2 = new List<Widget>();

sayfa2.add(Row (children: <Widget>[
  Expanded(child :LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.getconversionRate,raporResult.conversionRate,false)),
  Expanded(child :LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.getmusteriZiyareySayisi,raporResult.magazaTrafik,false))],));
sayfa2.add(Row (children: <Widget>[
  Expanded(child :LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.getsepetBuyukluguAdet,raporResult.sepetBuyukAdet,false)),
  Expanded(child :LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.getsepetBuyukluguTutarKDVsiz,raporResult.sepetBuyukTutarKDVsiz,false))],));
sayfa2.add(Row (children: <Widget>[
  Expanded(child :LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.getstokDevirHizi,raporResult.stokDevirHizi,false)),
  Expanded(child :LcwAssistCustomWidgets.tutarCardDikey(applicationManager.currentLanguage.getM2Verimlilik,raporResult.m2Verimlilik  ,false))],));



return PageView(
      children: [
        sayfa(sayfa1),
        sayfa(sayfa2),
      ],
    );

}

Future loadStoreReport(StoreReportRequestDTO parameter) async{

ParsedResponse responseResult = await applicationManager.serviceManager.storeChooseService.storeReport(parameter);

if(responseResult.statusCode == 200){
raporResult = responseResult.body;

assitReportDataDTO = new List<AssitReportDataDTO>();

assitReportDataDTO.add(new AssitReportDataDTO(this.applicationManager.currentLanguage.getsatisTutarKDVsiz,raporResult.bY_SatisTutar_KDVsiz,false));
assitReportDataDTO.add(new AssitReportDataDTO(this.applicationManager.currentLanguage.gettutarBuyume,raporResult.tutarBuyume,false));
assitReportDataDTO.add(new AssitReportDataDTO( this.applicationManager.currentLanguage.getsatisTutarGY_KDVsiz,raporResult.gY_SatisTutar_KDVsiz,false));
assitReportDataDTO.add(new AssitReportDataDTO(this.applicationManager.currentLanguage.gethedefTutar,raporResult.bY_HedefTutar,false));
assitReportDataDTO.add(new AssitReportDataDTO(this.applicationManager.currentLanguage.gethedefTutarYuzdesi,raporResult.magazaHedefTutturmaYuzdesi,false));
assitReportDataDTO.add(new AssitReportDataDTO(this.applicationManager.currentLanguage.getsatisAdet,raporResult.bY_SatisAdet,false));
assitReportDataDTO.add(new AssitReportDataDTO(this.applicationManager.currentLanguage.getadetBuyume,raporResult.adetBuyume,false));
assitReportDataDTO.add(new AssitReportDataDTO(this.applicationManager.currentLanguage.getsatisAdetGY,raporResult.gY_SatisAdet,false));
assitReportDataDTO.add(new AssitReportDataDTO(this.applicationManager.currentLanguage.getconversionRate,raporResult.conversionRate,false));
assitReportDataDTO.add(new AssitReportDataDTO(this.applicationManager.currentLanguage.getmusteriZiyareySayisi,raporResult.magazaTrafik,false));
assitReportDataDTO.add(new AssitReportDataDTO(this.applicationManager.currentLanguage.getsepetBuyukluguAdet,raporResult.sepetBuyukAdet,false));
assitReportDataDTO.add(new AssitReportDataDTO(this.applicationManager.currentLanguage.getsepetBuyukluguTutarKDVsiz,raporResult.sepetBuyukTutarKDVsiz,false));
assitReportDataDTO.add(new AssitReportDataDTO(this.applicationManager.currentLanguage.getstokDevirHizi,raporResult.stokDevirHizi,false));
assitReportDataDTO.add(new AssitReportDataDTO(this.applicationManager.currentLanguage.getM2Verimlilik,raporResult.m2Verimlilik,false));



}
else
{
  await applicationManager.utils.resultApiStatus(context, responseResult.statusCode, applicationManager.currentLanguage);
  return;
}

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
                backgroundColor: Colors.white,
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

Widget thisFloatActionButton(){
return FloatingActionButton(
  backgroundColor: LcwAssistColor.floatingButtonColor,
      child: const Icon(Icons.filter_list), onPressed: () {_openFilterDialog();},);
    }

void _openFilterDialog() async{

var result = null;

result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => StoreFilterPage(storesDonemFilters:this.raporResult.periodFilterList,storeCurrentFilterParameter:this.storeCurrentFilterParameter)),
  );

storeCurrentFilterParameter = result ?? storeCurrentFilterParameter;

if(storeCurrentFilterParameter != null){
 
parameter.setFilterDonem = storeCurrentFilterParameter.deger;

await loadStoreReport(parameter);
setState(() {  
});
}
  
}


}

