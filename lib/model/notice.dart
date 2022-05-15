class Notice {
  String? _url;
  String? _title;
  String? _content;
  String? _author;
  String? _date;

  String get title => _title!;

  set title(String value) {
    _title = value;
  }

  String get content => _content!;

  String get date => _date!;

  set date(String value) {
    _date = value;
  }

  String get author => _author!;

  set author(String value) {
    _author = value;
  }

  set content(String value) {
    _content = value;
  }

  String get url => _url!;

  set url(String value) {
    _url = value;
  }
}
