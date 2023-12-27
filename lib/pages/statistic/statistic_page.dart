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

    _feedbackStream.listen((snapshot) {
      setState(() {
        dataList = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        localDataList = List.from(dataList);
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
                            showFilterDialog();
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
      return MaterialStateColor.resolveWith((states) => Colors.red);
    }
    if (rating == 'Bình thường') {
      return MaterialStateColor.resolveWith(
          (states) => const Color.fromARGB(255, 216, 244, 54));
    }
    if (rating == 'Tốt' || rating == 'Rất tốt') {
      return MaterialStateColor.resolveWith(
          (states) => const Color.fromARGB(255, 54, 244, 95));
    }
    return null;
  }

  String? getSelectedChecklistData(Map<String, dynamic> map, String title) {
    var feedbackDataList = map['feedbackDataList'] as List<dynamic>?;
    if (feedbackDataList != null) {
      for (var item in feedbackDataList) {
        if (item is Map<String, dynamic> && item.containsKey('title')) {
          if (item['title'] == title) {
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
    List<String> selectedShowrooms = [];

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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            applyShowroomFilter(selectedShowrooms);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            'Áp dụng',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            cancelFilter();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
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

  void applyShowroomFilter(List<String> selectedShowrooms) {
    setState(() {
      this.selectedShowrooms = selectedShowrooms;
      dataList = dataList
          .where((map) => selectedShowrooms
              .contains(getSelectedChecklistData(map, 'Selected Showroom')))
          .toList();
    });
  }

  void cancelFilter() {
    setState(() {
      selectedShowrooms = [];
      dataList = List.from(localDataList);
    });
  }

  List<String> getShowroomNames() {
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
    List<String> selectedParts = [];

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
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            applyPartFilter(selectedParts);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            'Áp dụng',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            cancelPartFilter();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
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

  void applyPartFilter(List<String> selectedParts) {
    setState(() {
      this.selectedParts = selectedParts;
      dataList = dataList
          .where((map) => selectedParts
              .contains(getSelectedChecklistData(map, 'Selected Part')))
          .toList();
    });
  }

  void cancelPartFilter() {
    setState(() {
      selectedParts = [];
      dataList = List.from(localDataList);
    });
  }

  List<String> getPartNames() {
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
    List<String> selectedImageRatings = [];

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
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            applyImageFilter(selectedImageRatings);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            'Áp dụng',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            cancelImageFilter();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
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

  void applyImageFilter(List<String> selectedImageRatings) {
    setState(() {
      this.selectedImageRatings = selectedImageRatings;
      dataList = dataList
          .where((map) => selectedImageRatings
              .contains(getSelectedChecklistData(map, 'feedback hình ảnh')))
          .toList();
    });
  }

  void cancelImageFilter() {
    setState(() {
      selectedImageRatings = [];
      dataList = List.from(localDataList);
    });
  }

  List<String> getImageRatings() {
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
