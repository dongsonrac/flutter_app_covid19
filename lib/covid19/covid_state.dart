import 'package:equatable/equatable.dart';
import 'package:flutter_app_covid19/models/country.dart';
import 'package:flutter_app_covid19/models/global.dart';


class CovidState extends Equatable {
  final bool internet;
  final Global global;
  final Country mycountry;
  final List<Country> listcountry;

  CovidState({
    this.internet = true,
    this.global = null,
    this.mycountry = null,
    this.listcountry = null,
  });

  CovidState copyWith({
    bool internet,
    Global global,
    Country mycountry,
    List<Country> listcountry,
  }) =>
      CovidState(
        internet: internet ?? this.internet,
        global: global ?? this.global,
        mycountry: mycountry ?? this.mycountry,
        listcountry: listcountry ?? this.listcountry,
      );

  @override
  // TODO: implement props
  List<Object> get props => [internet, global, mycountry, listcountry];

  @override
  bool operator ==(Object other) {
    if (props == null || props.isEmpty) {
      return false;
    }
    return super == other;
  }

  @override
  bool get stringify {
    return true;
  }

  @override
  int get hashCode {
    return super.hashCode;
  }
}