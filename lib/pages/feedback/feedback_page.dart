import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  final String selectedPart;
  final String selectedShowroom;

  const FeedbackPage({
    Key? key,
    required this.selectedPart,
    required this.selectedShowroom,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  bool isSubmitting = false;
  final List<Map<String, dynamic>> checklistData = [
    {
      'title':
          'Theo quý khách thái độ phục vụ và tư vấn của nhân viên như thế nào?',
      'items': [
        'Thân thiện, lịch sự, có thái độ tốt, quan tâm đến khách hàng',
        'Chấp nhận được',
        'Thiếu tính chuyên nghiệp, không chấp nhận được',
      ],
    },
    {
      'title':
          'Theo quý khách chất lượng và thời gian xử lý hỗ trợ, giải quyết các sự cố của nhân viên là:',
      'items': [
        'Nhanh chóng, kịp thời, thấu đáo',
        'Chấp nhận được',
        'Chưa kịp thời, chậm',
      ],
    },
    {
      'title': 'Theo quý khách giá sản phẩm của HACOM như thế nào?',
      'items': [
        'Giá cao',
        'Giá hợp lí',
        'Giá rẻ',
      ],
    },
    {
      'title':
          'Quý khách có gặp trở ngại gì trong quá trình mua – nhận sản phẩm không?',
      'items': [
        'Dễ dàng và nhanh chóng',
        'Bình thường',
        'Còn gặp vấn đề',
      ],
    },
  ];

  final CollectionReference feedbackCollection =
      FirebaseFirestore.instance.collection('feedback');

  List<Map<String, dynamic>> selectedChecklistData = [];

  List<int> selectedItems = List.filled(4, -1);

  List<String> otherOpinionsList = List.filled(4, '');

  int selectedImageValue = -1;

  void handleImageTap(int index) {
    if (selectedImageValue == index + 1) {}
  }

  void resetForm() {
    setState(() {
      selectedImageValue = -1;
      selectedChecklistData.clear();
      selectedItems = List.filled(4, -1);
      otherOpinionsList = List.filled(4, '');
      isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 50),
              _buildText(),
              const SizedBox(height: 24),
              _buildImageGallery(handleImageTap),
              const SizedBox(height: 24),
              for (int i = 0; i < checklistData.length; i++)
                Column(
                  children: [
                    _buildChecklistTitle(title: checklistData[i]['title']),
                    for (int j = 0; j < checklistData[i]['items'].length; j++)
                      _buildChecklistItem(
                        item: checklistData[i]['items'][j],
                        titleIndex: i,
                        itemIndex: j,
                      ),
                    _buildOtherOpinionItem(i),
                  ],
                ),
              _buildElevatedButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: 143,
      height: 51,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/hacom.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildText() {
    return const Text(
      'Trải nghiệm hôm nay của quý khách thế nào ?',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFF181619),
        fontSize: 20,
        fontFamily: 'Manrope',
        fontWeight: FontWeight.w700,
        height: 0.06,
      ),
    );
  }

  Widget _buildImageGallery(Function(int) onTap) {
    return Container(
      width: 642,
      height: 134,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFFF0000)),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (i) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedImageValue = i + 1;
              });
              onTap(i);
            },
            child: _buildImage('assets/images/Rectangle${5 - i}.png',
                isSelected: selectedImageValue == i + 1),
          );
        }),
      ),
    );
  }

  Widget _buildImage(String imagePath, {required bool isSelected}) {
    return Container(
      width: 94,
      height: 94,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? const Color.fromARGB(255, 92, 255, 59)
                : const Color(0x19D31994),
            blurRadius: 20,
            offset: const Offset(0, 0),
            spreadRadius: 4,
          )
        ],
      ),
      child: Container(
        width: 94,
        height: 94,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF181619),
          fontSize: 16,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildChecklistItem({
    required String item,
    required int titleIndex,
    required int itemIndex,
  }) {
    return Center(
      child: SizedBox(
        width: 650,
        height: 80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRoundedCheckboxListTile(
              title: Text(item),
              value: selectedItems[titleIndex] == itemIndex,
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    if (value) {
                      selectedItems[titleIndex] = itemIndex;
                      selectedChecklistData.add({
                        'title': checklistData[titleIndex]['title'],
                        'answer': item,
                      });
                    } else {
                      selectedItems[titleIndex] = -1;
                      // Xóa câu trả lời nếu người dùng bỏ chọn
                      selectedChecklistData.removeWhere((data) =>
                          data['title'] == checklistData[titleIndex]['title'] &&
                          data['answer'] == item);
                    }
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherOpinionItem(int titleIndex) {
    return Center(
      child: SizedBox(
        width: 650,
        height: 80,
        child: Column(
          children: [
            _buildOtherOpinion(
              titleIndex,
              otherOpinionsList[titleIndex],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedCheckboxListTile({
    required Widget title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.all(8),
      child: CheckboxListTile(
        title: title,
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildOtherOpinion(int titleIndex, String opinion) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          onChanged: (value) {
            otherOpinionsList[titleIndex] = value;
          },
          decoration: const InputDecoration(
            hintText: 'Ý kiến khác',
            contentPadding: EdgeInsets.fromLTRB(21, 16.0, 16.0, 16.0),
            isDense: true,
            border: InputBorder.none,
          ),
          controller: TextEditingController(text: opinion),
        ),
      ),
    );
  }

  // Gửi dữ liệu phản hồi lên Firestore
  Future<void> sendFeedbackToFirestore() async {
    setState(() {
      isSubmitting = true;
    });
    try {
      final List<Map<String, dynamic>> feedbackDataList = [];
      feedbackDataList.add({
        'title': 'Selected Part',
        'selectedPart': widget.selectedPart,
      });

      feedbackDataList.add({
        'title': 'Selected Showroom',
        'selectedShowroom': widget.selectedShowroom,
      });

      if (selectedImageValue != -1) {
        feedbackDataList.add({
          'title': 'feedback hình ảnh',
          'selectedImageValue': selectedImageValue,
        });
      }

      for (int i = 0; i < checklistData.length; i++) {
        Map<String, dynamic> feedbackItem = {
          'title': checklistData[i]['title'],
        };
        if (selectedItems[i] != -1) {
          feedbackItem['selectedChecklistData'] =
              checklistData[i]['items'][selectedItems[i]];
        }
        if (otherOpinionsList[i].isNotEmpty) {
          feedbackItem['otherOpinion'] = otherOpinionsList[i];
        }

        feedbackDataList.add(feedbackItem);
      }
      if (feedbackDataList.isNotEmpty) {
        await feedbackCollection.add({
          'timestamp': FieldValue.serverTimestamp(),
          'feedbackDataList': feedbackDataList,
        });
      }
      resetForm();
    } catch (e) {
      // ignore: avoid_print
      print('Lỗi khi lưu dữ liệu phản hồi: $e');
    }
  }

  Widget _buildElevatedButton() {
    return InkWell(
      onTap: () {
        if (!isSubmitting) {
          sendFeedbackToFirestore();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 40,
        width: 80,
        // width: isSubmitting ? 40 : double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF14B8A6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: isSubmitting
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : const Text(
                  'Đánh giá',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.30,
                  ),
                ),
        ),
      ),
    );
  }
}
