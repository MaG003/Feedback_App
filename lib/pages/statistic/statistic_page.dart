import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  late Stream<QuerySnapshot> _feedbackStream;
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> localDataList = [];
  List<String> selectedShowrooms = [];
  List<String> selectedParts = [];
  List<String> selectedImageRatings = [];

  @override
  void initState() {
    super.initState();
    _feedbackStream =
        FirebaseFirestore.instance.collection('feedback').snapshots();

    // Gán giá trị cho dataList từ dữ liệu Firestore
    _feedbackStream.listen((snapshot) {
      setState(() {
        dataList = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        localDataList = List.from(
            dataList); // Lưu trữ bản sao của dataList để khôi phục sau khi hủy lọc
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _feedbackStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Lỗi: Không thể tải dữ liệu. ${snapshot.error}');
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 40.0,
                  columns: [
                    const DataColumn(
                      label: SizedBox(
                        width: 80,
                        child: Text('Thời gian'),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 150,
                        child: InkWell(
                          onTap: () {
                            showFilterDialog(); // Hiển thị hộp thoại lọc
                          },
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: const Row(
                              children: [
                                Text('Showroom'),
                                SizedBox(width: 60),
                                Icon(Icons.filter_list, size: 15),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 100,
                        child: InkWell(
                          onTap: () {
                            // Xử lý khi nhấn vào "Bộ phận"
                            showPartFilterDialog();
                          },
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: const Row(children: [
                              Text('Bộ phận'),
                              SizedBox(width: 30),
                              Icon(Icons.filter_list, size: 15),
                            ]),
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 170,
                        child: InkWell(
                          onTap: () {
                            // Xử lý khi nhấn vào "Đánh giá trải nghiệm"
                            showImageFilterDialog();
                          },
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: const Row(children: [
                              Text('Đánh giá trải nghiệm'),
                              SizedBox(width: 18),
                              Icon(Icons.filter_list, size: 15),
                            ]),
                          ),
                        ),
                      ),
                    ),
                    const DataColumn(
                      label: SizedBox(
                        width: 200,
                        child: Text('Thái độ phục vụ và tư vấn'),
                      ),
                    ),
                    const DataColumn(
                      label: SizedBox(
                        width: 200,
                        child: Text('Chất lượng và thời gian xử lý'),
                      ),
                    ),
                    const DataColumn(
                      label: SizedBox(
                        width: 100,
                        child: Text('Giá sản phẩm'),
                      ),
                    ),
                    const DataColumn(
                      label: SizedBox(
                        width: 220,
                        child: Text('Trở ngại trong quá trình mua bán'),
                      ),
                    ),
                  ],
                  rows: dataList
                      .map(
                        (map) => DataRow(
                          color: getRowColor(map),
                          cells: [
                            DataCell(
                              SizedBox(
                                width: 80,
                                child: Text(
                                  DateFormat('yyyy-MM-dd HH:mm:ss')
                                      .format(map['timestamp']?.toDate()),
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 150,
                                child: Text(getSelectedChecklistData(
                                        map, 'Selected Showroom') ??
                                    ''),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 100,
                                child: Text(getSelectedChecklistData(
                                        map, 'Selected Part') ??
                                    ''),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 130,
                                child: Text(getSelectedChecklistData(
                                        map, 'feedback hình ảnh'.toString()) ??
                                    ''),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 200,
                                child: Text(getSelectedChecklistData(map,
                                        'Theo quý khách thái độ phục vụ và tư vấn của nhân viên như thế nào?') ??
                                    ''),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 200,
                                child: Text(getSelectedChecklistData(map,
                                        'Theo quý khách chất lượng và thời gian xử lý hỗ trợ, giải quyết các sự cố của nhân viên là:') ??
                                    ''),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 100,
                                child: Text(getSelectedChecklistData(map,
                                        'Theo quý khách giá sản phẩm của HACOM như thế nào?') ??
                                    ''),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 220,
                                child: Text(getSelectedChecklistData(map,
                                        'Quý khách có gặp trở ngại gì trong quá trình mua – nhận sản phẩm không?') ??
                                    ''),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  MaterialStateColor? getRowColor(Map<String, dynamic> map) {
    String? rating = getSelectedChecklistData(map, 'feedback hình ảnh');
    if (rating == 'Tệ' || rating == 'Rất tệ') {
      return MaterialStateColor.resolveWith(
          (states) => Colors.red); // Sử dụng màu đỏ
    }
    if (rating == 'Bình thường') {
      return MaterialStateColor.resolveWith((states) =>
          const Color.fromARGB(255, 216, 244, 54)); // Sử dụng màu đỏ
    }
    if (rating == 'Tốt' || rating == 'Rất tốt') {
      return MaterialStateColor.resolveWith(
          (states) => const Color.fromARGB(255, 54, 244, 95)); // Sử dụng màu đỏ
    }
    return null; // Sử dụng màu mặc định nếu không phải là đánh giá xấu
  }

  String? getSelectedChecklistData(Map<String, dynamic> map, String title) {
    var feedbackDataList = map['feedbackDataList'] as List<dynamic>?;
    if (feedbackDataList != null) {
      for (var item in feedbackDataList) {
        if (item is Map<String, dynamic> && item.containsKey('title')) {
          if (item['title'] == title) {
            // Xử lý trường hợp đặc biệt cho selectedImageValue
            if (title == 'feedback hình ảnh'.toString() &&
                item['selectedImageValue'] != null) {
              int selectedImageValue = item['selectedImageValue'];
              return _getImageRating(selectedImageValue);
            }
            return item['selectedChecklistData']?.toString() ??
                item['otherOpinion']?.toString() ??
                item['selectedShowroom']?.toString() ??
                item['selectedPart']?.toString();
          }
        }
      }
    }
    return null;
  }

  String _getImageRating(int selectedImageValue) {
    switch (selectedImageValue) {
      case 1:
        return 'Rất tệ';
      case 2:
        return 'Tệ';
      case 3:
        return 'Bình thường';
      case 4:
        return 'Tốt';
      case 5:
        return 'Rất tốt';
      default:
        return '';
    }
  }

  void showFilterDialog() {
    List<String> selectedShowrooms = []; // Danh sách showroom đã chọn

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Showroom'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // Hiển thị danh sách tên Showroom với checkbox
                    for (String showroomName in getShowroomNames())
                      CheckboxListTile(
                        title: Text(showroomName),
                        value: selectedShowrooms.contains(showroomName),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value != null) {
                              if (value) {
                                selectedShowrooms.add(showroomName);
                              } else {
                                selectedShowrooms.remove(showroomName);
                              }
                            }
                          });
                        },
                      ),
                    const SizedBox(
                        height:
                            20), // Khoảng cách giữa danh sách và nút Áp dụng, Hủy
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Đóng hộp thoại
                            applyShowroomFilter(selectedShowrooms);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, // Màu xanh lá
                          ),
                          child: const Text(
                            'Áp dụng',
                            style:
                                TextStyle(color: Colors.white), // Màu chữ trắng
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Đóng hộp thoại
                            cancelFilter(); // Hủy lọc
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Màu đỏ
                          ),
                          child: const Text(
                            'Hủy',
                            style:
                                TextStyle(color: Colors.white), // Màu chữ trắng
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Hàm này sẽ áp dụng bộ lọc theo danh sách các showroom đã chọn và cập nhật giao diện
  void applyShowroomFilter(List<String> selectedShowrooms) {
    setState(() {
      this.selectedShowrooms = selectedShowrooms;
      dataList = dataList
          .where((map) => selectedShowrooms
              .contains(getSelectedChecklistData(map, 'Selected Showroom')))
          .toList();
    });
  }

  // Hàm này sẽ hủy bỏ bộ lọc và cập nhật giao diện
  void cancelFilter() {
    setState(() {
      selectedShowrooms = []; // Đặt danh sách showroom đã chọn về rỗng
      dataList =
          List.from(localDataList); // Khôi phục danh sách dữ liệu ban đầu
    });
  }

  // Hàm này sẽ trả về danh sách các tên Showroom duy nhất từ dữ liệu
  List<String> getShowroomNames() {
    // Lấy danh sách các tên Showroom từ dataList
    Set<String> showroomNames = {};
    for (var map in dataList) {
      var showroomName = getSelectedChecklistData(map, 'Selected Showroom');
      if (showroomName != null) {
        showroomNames.add(showroomName);
      }
    }
    return showroomNames.toList();
  }

  void showPartFilterDialog() {
    List<String> selectedParts = []; // Danh sách bộ phận đã chọn

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Bộ phận'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // Hiển thị danh sách tên bộ phận với checkbox
                    for (String partName in getPartNames())
                      CheckboxListTile(
                        title: Text(partName),
                        value: selectedParts.contains(partName),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value != null) {
                              if (value) {
                                selectedParts.add(partName);
                              } else {
                                selectedParts.remove(partName);
                              }
                            }
                          });
                        },
                      ),
                    const SizedBox(
                      height: 20,
                    ), // Khoảng cách giữa danh sách và nút Áp dụng, Hủy
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Đóng hộp thoại
                            applyPartFilter(selectedParts);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, // Màu xanh lá
                          ),
                          child: const Text(
                            'Áp dụng',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Đóng hộp thoại
                            cancelPartFilter(); // Hủy lọc
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Màu đỏ
                          ),
                          child: const Text(
                            'Hủy',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

// Hàm này sẽ áp dụng bộ lọc theo danh sách các bộ phận đã chọn và cập nhật giao diện
  void applyPartFilter(List<String> selectedParts) {
    setState(() {
      this.selectedParts = selectedParts;
      dataList = dataList
          .where((map) => selectedParts
              .contains(getSelectedChecklistData(map, 'Selected Part')))
          .toList();
    });
  }

// Hàm này sẽ hủy bỏ bộ lọc và cập nhật giao diện
  void cancelPartFilter() {
    setState(() {
      selectedParts = []; // Đặt danh sách bộ phận đã chọn về rỗng
      dataList =
          List.from(localDataList); // Khôi phục danh sách dữ liệu ban đầu
    });
  }

// Hàm này sẽ trả về danh sách các tên bộ phận duy nhất từ dữ liệu
  List<String> getPartNames() {
    // Lấy danh sách các tên bộ phận từ dataList
    Set<String> partNames = {};
    for (var map in dataList) {
      var partName = getSelectedChecklistData(map, 'Selected Part');
      if (partName != null) {
        partNames.add(partName);
      }
    }
    return partNames.toList();
  }

  void showImageFilterDialog() {
    List<String> selectedImageRatings =
        []; // Danh sách đánh giá hình ảnh đã chọn

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Đánh giá trải nghiệm'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // Hiển thị danh sách đánh giá hình ảnh với checkbox
                    for (String rating in getImageRatings())
                      CheckboxListTile(
                        title: Text(rating),
                        value: selectedImageRatings.contains(rating),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value != null) {
                              if (value) {
                                selectedImageRatings.add(rating);
                              } else {
                                selectedImageRatings.remove(rating);
                              }
                            }
                          });
                        },
                      ),
                    const SizedBox(
                      height: 20,
                    ), // Khoảng cách giữa danh sách và nút Áp dụng, Hủy
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Đóng hộp thoại
                            applyImageFilter(selectedImageRatings);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, // Màu xanh lá
                          ),
                          child: const Text(
                            'Áp dụng',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Đóng hộp thoại
                            cancelImageFilter(); // Hủy lọc
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Màu đỏ
                          ),
                          child: const Text(
                            'Hủy',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

// Hàm này sẽ áp dụng bộ lọc theo danh sách các đánh giá hình ảnh đã chọn và cập nhật giao diện
  void applyImageFilter(List<String> selectedImageRatings) {
    setState(() {
      this.selectedImageRatings = selectedImageRatings;
      dataList = dataList
          .where((map) => selectedImageRatings
              .contains(getSelectedChecklistData(map, 'feedback hình ảnh')))
          .toList();
    });
  }

// Hàm này sẽ hủy bỏ bộ lọc và cập nhật giao diện
  void cancelImageFilter() {
    setState(() {
      selectedImageRatings =
          []; // Đặt danh sách đánh giá hình ảnh đã chọn về rỗng
      dataList =
          List.from(localDataList); // Khôi phục danh sách dữ liệu ban đầu
    });
  }

// Hàm này sẽ trả về danh sách các đánh giá hình ảnh duy nhất từ dữ liệu
  List<String> getImageRatings() {
    // Lấy danh sách các đánh giá hình ảnh từ dataList
    Set<String> imageRatings = {};
    for (var map in dataList) {
      var rating = getSelectedChecklistData(map, 'feedback hình ảnh');
      if (rating != null) {
        imageRatings.add(rating);
      }
    }
    return imageRatings.toList();
  }
}
