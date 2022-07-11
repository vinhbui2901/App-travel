// ignore_for_file: public_member_api_docs, sort_constructors_first
class Video {
  final String urlVideo;
  final String name;
  Video(this.urlVideo, this.name);
  static List<Video> videos = [
    Video('mc01.mp4', 'HaNa'),
    Video('mc02.mp4', 'Cendy Nguyen'),
    Video('hg01.mp4', 'Duc Tran')
  ];
}

class Locator {
  final String url, name;

  Locator(this.name, this.url);
  static List<Locator> locators = [
    Locator("Hạ Long", "assets/images/halong.jpg"),
    Locator("Đà Nẵng", "assets/images/danang.jpg"),
    Locator("Nha Trang", "assets/images/nhatrang.jpg"),
    Locator("Đà Lạt", "assets/images/dalat.jpg"),
    Locator("Phú Quốc", "assets/images/phuquoc.jpg"),
  ];
}

class Destination {
  final String province, country, discription, imageAsset;
  final int activities, id;

  Destination(this.id, this.province, this.country, this.activities,
      this.discription, this.imageAsset);
  static List<Destination> discriptions = [
    Destination(1, 'Quảng Ninh', 'Việt Nam', 17,
        'Được coi là Việt Nam thu nhỏ ', 'assets/images/QN.jpg'),
    Destination(
        2,
        'Sơn La',
        'Việt Nam',
        20,
        'Sơn La là tỉnh miền núi nằm ở vùng Tây Bắc Bộ',
        'assets/images/SL.jpg'),
    Destination(
        3,
        'Hà Giang',
        'Việt Nam',
        20,
        'Thời gian du lịch đẹp nhất là tháng 10, 11 và 12, khi hoa tam giác mạch hay những cánh đồng cải khoe sắc',
        'assets/images/HG.jpg'),
  ];
}

class Activity {
  Activity(this.nameActivities, this.detail, this.rating, this.imageUrl);
  List<String> nameActivities, detail;
  List<int> rating;
  List<String> imageUrl;
  static List<Activity> acty = [
    Activity([
      "Vịnh Hạ Long",
      "Tuần Châu",
      "Núi Bài Thơ",
      "Cô Tô"
    ], [
      "Vịnh Hạ Long bao gồm 2000 hòn đảo lớn nhỏ và các hang động, bãi tắm đẹp, trong đó phải kể đến những hang động nguyên sơ đẹp bậc nhất như động Thiên Cung, hang Đầu Gỗ, hang Trinh Nữ,... sẽ cho du khách có được những chuyến đi khám phá thú vị, đầy hấp dẫn.",
      "Đây là một hòn đảo với địa chất gồm đất lẫn phiến thạch duy nhất trong các đảo của vùng biển Hạ Long, sở hữu những bãi cát trắng mịn trải dài, nước biển xanh trong vắt và đặc biệt khí hậu luôn mát mẻ thích hợp cho những ai muốn đi du lịch nghỉ dưỡng.",
      "núi Bài Thơ- ngọn núi đá vôi đẹp thuộc thành phố Hạ Long, tỉnh Quảng Ninh. Sở dĩ núi có tên là Bài Thơ bởi trên núi hiện còn lưu lại các bài thơ chữ Hán của Lê Thánh Tông khắc trên đá năm 1468, và của Trịnh Cương năm 1729. ",
      "Cô Tô là xã thuộc huyện Móng Cái, sau đó là hai xã đặc biệt trực thuộc tỉnh. Từ 1964, hai xã đã được sát nhập vào huyện Cẩm Phả. Năm 1994, Chính phủ đổi tên huyện Cẩm Phả thành huyện Vân Đồn đồng thời tách quần đảo Cô Tô gồm hai xã Thanh Lân, Cô Tô thành lập huyện Cô Tô vào ngày 23 tháng 3 năm 1994"
    ], [
      5,
      5,
      4,
      4
    ], [
      "assets/images/HL01.jpg",
      "assets/images/TC.jpg",
      "assets/images/NBT.jpg",
      "assets/images/CT.jpg",
    ]),
    Activity([
      "Thác Dải Yếm",
      "Happy Land",
      "Rừng thông Bản Áng",
      "Thung lũng mận Nà Ka"
    ], [
      "",
      "",
      'Địa chỉ: Đông Sang, Mộc Châu, Sơn La',
      ""
    ], [
      5,
      4,
      4,
      5,
      4,
      5
    ], []),
  ];
}
