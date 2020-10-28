import 'package:equatable/equatable.dart';

abstract class CovidEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class InitialCovidEvent extends CovidEvent {}

class SearchCountryCovidEvent extends CovidEvent {
  final String countryname;
  SearchCountryCovidEvent({this.countryname});
}

class RefreshDataCovidEvent extends CovidEvent{

}

class ReSetDataCovidEvent extends CovidEvent{

}

class NoInternetCovidEvent extends CovidEvent{

}

class FocusCountryCovidEvent extends CovidEvent{
  final int index;
  FocusCountryCovidEvent(this.index);
}