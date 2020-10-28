import 'dart:async';
import 'dart:convert';

import 'package:flutter_app_covid19/covid19/covid_event.dart';
import 'package:flutter_app_covid19/covid19/covid_state.dart';
import 'package:flutter_app_covid19/models/country.dart';
import 'package:flutter_app_covid19/models/global.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:translator/translator.dart';

class CovidBloc extends Bloc<CovidEvent, CovidState> {
  Map<String, String> listCountryNameVN = ListCountryNameVN();
  CovidBloc() : super(CovidState()) {}

  @override
  Stream<CovidState> mapEventToState(CovidEvent event) async* {
    switch (event.runtimeType) {
      case InitialCovidEvent:
        Global _global;
        Country _vn;
        List<Country> _listCountry = [];
        // --------------------------------
        try {
          var response = await http.get('https://api.covid19api.com/summary');
          print('statusCode: ${response.statusCode}');
          var jsonResponse = convert.jsonDecode(response.body);
          var rest = await jsonResponse["Countries"] as List;
          print(rest.length);

          _global = new Global(
            jsonResponse["Global"]["NewConfirmed"].toString(),
            jsonResponse["Global"]["TotalConfirmed"].toString(),
            jsonResponse["Global"]["NewDeaths"].toString(),
            jsonResponse["Global"]["TotalDeaths"].toString(),
            jsonResponse["Global"]["NewRecovered"].toString(),
            jsonResponse["Global"]["TotalRecovered"].toString(),
          );

          // GoogleTranslator translator = GoogleTranslator();
          // for(int i = 0 ; i < rest.length; i++){
          //   String input = rest[i]["Country"];
          //
          //   // Passing the translation to a variable
          //   var translation = await translator
          //       .translate(input, from: 'en', to: 'vi');
          //   print(input +" =>> " + translation.toString());
          //   }

          for (int i = 0; i < rest.length; i++) {
            Country item = new Country(
                rest[i]["Country"],
                "",
                rest[i]["CountryCode"].toString(),
                rest[i]["TotalConfirmed"].toString(),
                rest[i]["TotalRecovered"].toString(),
                rest[i]["TotalDeaths"].toString());
            _listCountry.add(item);

            if (item.countryNameEn == "Viet Nam") {
              _vn = item;
            }
          }
        }catch (error) {
          print(error);
        }

        // --------------------------------
        yield state.copyWith(
          internet: true,
          global:  _global,
          mycountry:  _vn,
          listcountry:  _listCountry,
        );
        break;

      case SearchCountryCovidEvent:
        List<Country> _listCountry = [];
        print(listCountryNameVN.length);
        try {
          final _event = event as SearchCountryCovidEvent;
          String _countryNameSearch = ConvertToUnsign(_event.countryname.toUpperCase()).replaceAll(" ", "");

          var response = await http.get('https://api.covid19api.com/summary');
          var jsonResponse = convert.jsonDecode(response.body);
          var rest = jsonResponse["Countries"] as List;

          for (int i = 0; i < rest.length; i++) {
            String CountryEN = rest[i]["Country"].toString().toUpperCase();
            String CountryVN = "";

            CountryVN = ConvertToUnsign(listCountryNameVN[CountryEN].replaceAll(" ", ""));

            //print(_countryNameSearch +" =>> " + CountryEN + " =>> " + CountryVN);
            if (CountryEN.replaceAll(" ", "").contains(_countryNameSearch) || CountryVN.contains(_countryNameSearch)) {
              Country item = new Country(
                  rest[i]["Country"],
                  "",
                  rest[i]["CountryCode"].toString(),
                  rest[i]["TotalConfirmed"].toString(),
                  rest[i]["TotalRecovered"].toString(),
                  rest[i]["TotalDeaths"].toString());
              _listCountry.add(item);
            }
          }
        }catch (error) {
          print(error);
        }

        yield state.copyWith(
          internet: true,
          listcountry: _listCountry,
        );
        break;

      case FocusCountryCovidEvent:
        break;

      case NoInternetCovidEvent:
        yield state.copyWith(
          internet: false,
        );
        break;

      case RefreshDataCovidEvent:
        break;

      case ReSetDataCovidEvent:
        yield state.copyWith(
          internet: true,
          global:  null,
          mycountry:  null,
          listcountry:  null,
        );
        break;

      default:
        break;
    }
  }
}

String ConvertToUnsign(String str) {
  List<String> signs = [
    "aAeEoOuUiIdDyY",
    "áàạảãâấầậẩẫăắằặẳẵ",
    "ÁÀẠẢÃÂẤẦẬẨẪĂẮẰẶẲẴ",
    "éèẹẻẽêếềệểễ",
    "ÉÈẸẺẼÊẾỀỆỂỄ",
    "óòọỏõôốồộổỗơớờợởỡ",
    "ÓÒỌỎÕÔỐỒỘỔỖƠỚỜỢỞỠ",
    "úùụủũưứừựửữ",
    "ÚÙỤỦŨƯỨỪỰỬỮ",
    "íìịỉĩ",
    "ÍÌỊỈĨ",
    "đ",
    "Đ",
    "ýỳỵỷỹ",
    "ÝỲỴỶỸ"
  ];
  for (int i = 1; i < signs.length; i++) {
    for (int j = 0; j < signs[i].length; j++) {
      str = str.replaceAll(signs[i][j], signs[0][i - 1]);
    }
  }
  return str;
}

Map<String, String> ListCountryNameVN() {
  Map<String, String> list = {
    "AFGHANISTAN":"AFGHANISTAN",
    "ALBANIA":"ALBANIA",
    "ALGERIA":"ALGERIA",
    "ANDORRA":"ANDORRA",
    "ANGOLA":"ANGOLA",
    "ANTIGUA AND BARBUDA":"ANTIGUA VÀ BARBUDA",
    "ARGENTINA":"ARGENTINA",
    "ARMENIA":"ARMENIA",
    "AUSTRALIA":"CHÂU ÚC",
    "AUSTRIA":"ÚC",
    "AZERBAIJAN":"AZERBAIJAN",
    "BAHAMAS":"BAHAMAS",
    "BAHRAIN":"BAHRAIN",
    "BANGLADESH":"BANGLADESH",
    "BARBADOS":"BARBADOS",
    "BELARUS":"BELARUS",
    "BELGIUM":"NƯỚC BỈ",
    "BELIZE":"BELIZE",
    "BENIN":"BENIN",
    "BHUTAN":"BHUTAN",
    "BOLIVIA":"BOLIVIA",
    "BOSNIA AND HERZEGOVINA":"BOSNIA VÀ HERZEGOVINA",
    "BOTSWANA":"BOTSWANA",
    "BRAZIL":"BRAZIL",
    "BRUNEI DARUSSALAM":"VƯƠNG QUỐC BRU-NÂY",
    "BULGARIA":"BULGARIA",
    "BURKINA FASO":"BURKINA FASO",
    "BURUNDI":"BURUNDI",
    "CAMBODIA":"CAMPUCHIA",
    "CAMEROON":"CAMEROON",
    "CANADA":"CANADA",
    "CAPE VERDE":"CHỮ HOA",
    "CENTRAL AFRICAN REPUBLIC":"CỘNG HÒA TRUNG PHI",
    "CHAD":"CHAD",
    "CHILE":"CHILE",
    "CHINA":"TRUNG QUỐC",
    "COLOMBIA":"COLOMBIA",
    "COMOROS":"COMOROS",
    "CONGO (BRAZZAVILLE)":"CONGO (BRAZZAVILLE)",
    "CONGO (KINSHASA)":"CONGO (KINSHASA)",
    "COSTA RICA":"COSTA RICA",
    "CROATIA":"CROATIA",
    "CUBA":"CUBA",
    "CYPRUS":"SÍP",
    "CZECH REPUBLIC":"CỘNG HÒA SÉC",
    "CÔTE D'IVOIRE":"CÔTE D'IVOIRE",
    "DENMARK":"ĐAN MẠCH",
    "DJIBOUTI":"DJIBOUTI",
    "DOMINICA":"DOMINICA",
    "DOMINICAN REPUBLIC":"CỘNG HÒA DOMINICAN",
    "ECUADOR":"ECUADOR",
    "EGYPT":"AI CẬP",
    "EL SALVADOR":"EL SALVADOR",
    "EQUATORIAL GUINEA":"EQUATORIAL GUINEA",
    "ERITREA":"ERITREA",
    "ESTONIA":"ESTONIA",
    "ETHIOPIA":"ETHIOPIA",
    "FIJI":"FIJI",
    "FINLAND":"PHẦN LAN",
    "FRANCE":"PHÁP",
    "GABON":"GABON",
    "GAMBIA":"GAMBIA",
    "GEORGIA":"GEORGIA",
    "GERMANY":"NƯỚC ĐỨC",
    "GHANA":"GHANA",
    "GREECE":"GREECE",
    "GRENADA":"GRENADA",
    "GUATEMALA":"GUATEMALA",
    "GUINEA":"GUINEA",
    "GUINEA-BISSAU":"GUINEA-BISSAU",
    "GUYANA":"GUYANA",
    "HAITI":"HAITI",
    "HOLY SEE (VATICAN CITY STATE)":"THÁNH XEM (VATICAN CITY STATE)",
    "HONDURAS":"HONDURAS",
    "HUNGARY":"HUNGARY",
    "ICELAND":"NƯỚC ICELAND",
    "INDIA":"ẤN ĐỘ",
    "INDONESIA":"INDONESIA",
    "IRAN, ISLAMIC REPUBLIC OF":"IRAN (CỘNG HÒA HỒI GIÁO",
    "IRAQ":"IRAQ",
    "IRELAND":"IRELAND",
    "ISRAEL":"NGƯỜI ISRAEL",
    "ITALY":"NƯỚC Ý",
    "JAMAICA":"JAMAICA",
    "JAPAN":"NHẬT BẢN",
    "JORDAN":"JORDAN",
    "KAZAKHSTAN":"KAZAKHSTAN",
    "KENYA":"KENYA",
    "KOREA (SOUTH)":"NAM TRIỀU TIÊN)",
    "KUWAIT":"KUWAIT",
    "KYRGYZSTAN":"KYRGYZSTAN",
    "LAO PDR":"CHDCND LÀO",
    "LATVIA":"LATVIA",
    "LEBANON":"LEBANON",
    "LESOTHO":"LESOTHO",
    "LIBERIA":"LIBERIA",
    "LIBYA":"LIBYA",
    "LIECHTENSTEIN":"LIECHTENSTEIN",
    "LITHUANIA":"LITHUANIA",
    "LUXEMBOURG":"LUXEMBOURG",
    "MACAO, SAR CHINA":"MACAO, SAR CHINA",
    "MACEDONIA, REPUBLIC OF":"MACEDONIA, CỘNG HÒA",
    "MADAGASCAR":"MADAGASCAR",
    "MALAWI":"MALAWI",
    "MALAYSIA":"MALAYSIA",
    "MALDIVES":"MALDIVES",
    "MALI":"MALI",
    "MALTA":"MALTA",
    "MAURITANIA":"MAURITANIA",
    "MAURITIUS":"MAURITIUS",
    "MEXICO":"MEXICO",
    "MOLDOVA":"MOLDOVA",
    "MONACO":"MONACO",
    "MONGOLIA":"MONGOLIA",
    "MONTENEGRO":"MONTENEGRO",
    "MOROCCO":"MOROCCO",
    "MOZAMBIQUE":"MOZAMBIQUE",
    "MYANMAR":"MYANMAR",
    "NAMIBIA":"NAMIBIA",
    "NEPAL":"NEPAL",
    "NETHERLANDS":"NƯỚC HÀ LAN",
    "NEW ZEALAND":"ZEALAND MỚI",
    "NICARAGUA":"NICARAGUA",
    "NIGER":"NIGER",
    "NIGERIA":"NIGERIA",
    "NORWAY":"NA UY",
    "OMAN":"OMAN",
    "PAKISTAN":"PAKISTAN",
    "PALESTINIAN TERRITORY":"LÃNH THỔ CỦA NGƯỜI PALESTIN",
    "PANAMA":"PANAMA",
    "PAPUA NEW GUINEA":"PAPUA MỚI GUINEA",
    "PARAGUAY":"PARAGUAY",
    "PERU":"PERU",
    "PHILIPPINES":"PHILIPPINES",
    "POLAND":"POLAND",
    "PORTUGAL":"BỒ ĐÀO NHA",
    "QATAR":"QATAR",
    "REPUBLIC OF KOSOVO":"CỘNG HÒA KOSOVO",
    "ROMANIA":"ROMANIA",
    "RUSSIAN FEDERATION":"LIÊN BANG NGA",
    "RWANDA":"RWANDA",
    "RÉUNION":"SUM HỌP",
    "SAINT KITTS AND NEVIS":"SAINT KITTS VÀ NEVIS",
    "SAINT LUCIA":"SAINT LUCIA",
    "SAINT VINCENT AND GRENADINES":"SAINT VINCENT VÀ CÁC LỚP",
    "SAN MARINO":"SAN MARINO",
    "SAO TOME AND PRINCIPE":"SAO TOME VÀ PRINCIPE",
    "SAUDI ARABIA":"SAUDI ARABIA",
    "SENEGAL":"SENEGAL",
    "SERBIA":"SERBIA",
    "SEYCHELLES":"SEYCHELLES",
    "SIERRA LEONE":"SIERRA LEONE",
    "SINGAPORE":"SINGAPORE",
    "SLOVAKIA":"SLOVAKIA",
    "SLOVENIA":"SLOVENIA",
    "SOLOMON ISLANDS":"QUẦN ĐẢO SOLOMON",
    "SOMALIA":"SOMALIA",
    "SOUTH AFRICA":"NAM PHI",
    "SOUTH SUDAN":"PHÍA NAM SUDAN",
    "SPAIN":"TÂY BAN NHA",
    "SRI LANKA":"SRI LANKA",
    "SUDAN":"SUDAN",
    "SURINAME":"SURINAME",
    "SWAZILAND":"SWAZILAND",
    "SWEDEN":"THỤY ĐIỂN",
    "SWITZERLAND":"THỤY SĨ",
    "SYRIAN ARAB REPUBLIC (SYRIA)":"SYRIAN ARAB CỘNG HÒA (SYRIA)",
    "TAIWAN, REPUBLIC OF CHINA":"ĐÀI LOAN, CỘNG HÒA TRUNG QUỐC",
    "TAJIKISTAN":"TAJIKISTAN",
    "TANZANIA, UNITED REPUBLIC OF":"TANZANIA, CỘNG HÒA HOA KỲ",
    "THAILAND":"NƯỚC THÁI LAN",
    "TIMOR-LESTE":"TIMOR-LESTE",
    "TOGO":"ĐI",
    "TRINIDAD AND TOBAGO":"TRINIDAD VÀ TOBAGO",
    "TUNISIA":"TUNISIA",
    "TURKEY":"GÀ TÂY",
    "UGANDA":"UGANDA",
    "UKRAINE":"UKRAINE",
    "UNITED ARAB EMIRATES":"CÁC TIỂU VƯƠNG QUỐC Ả RẬP THỐNG NHẤT",
    "UNITED KINGDOM":"VƯƠNG QUỐC ANH",
    "UNITED STATES OF AMERICA":"NƯỚC MỸ",
    "URUGUAY":"URUGUAY",
    "UZBEKISTAN":"UZBEKISTAN",
    "VENEZUELA (BOLIVARIAN REPUBLIC)":"VENEZUELA (CỘNG HÒA BOLIVARIAN)",
    "VIET NAM":"VIỆT NAM",
    "WESTERN SAHARA":"PHÍA TÂY SAHARA",
    "YEMEN":"YEMEN",
    "ZAMBIA":"ZAMBIA",
    "ZIMBABWE":"ZIMBABWE"
  };

  return list;
}


