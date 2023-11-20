import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_auth/data/location_config.dart';
import 'package:jwt_auth/data/problem_config.dart';
import 'package:jwt_auth/data/sectors_config.dart';
import 'package:jwt_auth/data/ticket_config.dart';
import 'package:jwt_auth/data/solution_config.dart';
import 'package:jwt_auth/data/towers_config.dart';
import 'package:jwt_auth/main.dart';
import 'package:jwt_auth/screens/home.dart';
import 'package:jwt_auth/screens/survey_page.dart';
import 'package:jwt_auth/services/api_service.dart';
import 'package:jwt_auth/services/debouncer.dart';
import 'package:jwt_auth/services/location_services.dart';
import 'package:jwt_auth/widgets/map_box.dart';
import 'package:jwt_auth/widgets/text_field.dart';
import 'package:jwt_auth/widgets/comment_section.dart';
import 'package:permission_handler/permission_handler.dart';

class AddTicket extends StatefulWidget {
  final Widget? comments;
  final Ticket? ticket;
  const AddTicket({Key? key, this.comments, this.ticket}) : super(key: key);

  @override
  State<AddTicket> createState() => _AddTicketState();
}

class _AddTicketState extends State<AddTicket> {
  //Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController accController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController sectorController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  String name = '';
  String account = '';
  String phone = '';
  String place = '';
  String sector = '';
  double? longitude;
  double? latitude;
  bool hasError = false;
  double zoomLvl = 14;
  Tower? selectedTower;
  Sector? selectedSector;

  List<Problem> problemsCheckbox = [];
  List<Solution> solutionsCheckbox = [];
  List<String> textTrueProblem = [];
  List<String> textTrueSolution = [];
  List<Tower> towers = [];
  late List<bool> problemCheckboxGroup;
  late List<bool> solutionCheckboxGroup;

  TextEditingController locationController = TextEditingController();
  final LocationService locationService = LocationService();
  LocationData? locationData;
  final Debouncer _debouncer = Debouncer();
  bool isSaving = false;

  bool isLoadingLoc = false;

  void init() {
    if (widget.ticket != null) {
      name = nameController.text = widget.ticket!.userName;
      phone = phoneController.text = widget.ticket!.mobile;
      place = placeController.text = widget.ticket!.place!;
      sector = sectorController.text = widget.ticket!.sector!;
      account = accController.text = widget.ticket!.acc!;
      longitude = widget.ticket!.locationData!.longitude;
      latitude = widget.ticket!.locationData!.latitude;
    }
    if (latitude != 0 && longitude != 0 && longitude != null) {
      locationController.text = '$latitude, $longitude';
    }
    _fetchData();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void _handleError() {
    setState(() {
      hasError = true;
    });
  }

  void _retryFetchingData() {
    // Clear the error flag and attempt to fetch data again.
    setState(() {
      hasError = false;
      zoomLvl = 13;
    });
    init();
  }

  void _fetchData() async {
    try {
      // Check for internet connectivity
      bool hasInternet = await checkInternetConnectivity();

      if (hasInternet) {
        // Fetch towers
        List<Tower> fetchedTowers = await ApiService().fetchTowers();
        setState(() {
          towers = fetchedTowers;
        });

        // Fetch problems
        List<Problem> fetchedProblems = await ApiService().fetchProblems();
        setState(() {
          problemsCheckbox = fetchedProblems;
          problemCheckboxGroup = List.generate(problemsCheckbox.length, (index) => false);

          if (widget.ticket != null) {
            for (var item in widget.ticket!.problems!) {
              for (var i = 0; i < problemsCheckbox.length; i++) {
                if (item == problemsCheckbox[i].id) {
                  textTrueProblem.add(problemsCheckbox[i].name);
                  problemCheckboxGroup[i] = true;
                }
              }
            }
          }
        });

        // Fetch solutions
        List<Solution> fetchedSolutions = await ApiService().fetchSolutions();
        setState(() {
          solutionsCheckbox = fetchedSolutions;
          solutionCheckboxGroup = List.generate(solutionsCheckbox.length, (index) => false);

          if (widget.ticket != null) {
            for (var item in widget.ticket!.solutions!) {
              for (var i = 0; i < solutionsCheckbox.length; i++) {
                if (item == solutionsCheckbox[i].id) {
                  textTrueSolution.add(solutionsCheckbox[i].name);
                  solutionCheckboxGroup[i] = true;
                }
              }
            }
          }
        });
      } else {
        if (kDebugMode) {
          print("No internet connection.");
        }
      }
    } catch (error) {
      ApiService().handleErrorMessage(msg: 'Error fetching data: $error');
      _handleError();
      if (kDebugMode) {
        print("Error fetching data: $error");
      }
    }
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: [
          buildSaveButton(),
        ],
        title: const Text(
          'إضافة بلاغ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: hasError
          ? buildErrorBody()
          : FutureBuilder<bool>(
              future: checkInternetConnectivity(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (snapshot.data == false) {
                  return buildNoInternetBody();
                } else {
                  return problemsCheckbox.isEmpty && solutionsCheckbox.isEmpty && towers.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : buildBody();
                }
              },
            ),
    );
  }

  Widget buildErrorBody() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "حدث عطل ما!",
              style: TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () {
                _retryFetchingData();
              },
              child: const Text('حاول مجددا'),
            )
          ],
        ),
      ),
    );
  }

  Widget buildNoInternetBody() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "لا يوجد اتصال بالانترنت",
              style: TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () {
                _retryFetchingData();
              },
              child: const Text('حاول مجددا'),
            )
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            IgnorePointer(
              ignoring: widget.ticket == null || widget.ticket?.status == "inprogress" ? false : true,
              child: Column(
                children: [
                  buildTicketFields(),
                  const SizedBox(height: 10),
                  buildContainer('المشاكل', textTrueProblem, () => _debouncer.run(() => _showBottomSheetProblem())),
                  const SizedBox(height: 10),
                  buildContainer('الحلول', textTrueSolution, () => _debouncer.run(() => _showBottomSheetSolution())),
                  buildLocationSection(),
                ],
              ),
            ),
            buildLocationMap(),
            //* Comment section
            const SizedBox(height: 16.0),
            if (widget.ticket != null) CommentSection(id: widget.ticket!.id, user: widget.ticket!, comments: widget.ticket!.comments),
          ],
        ),
      ),
    );
  }

  Container buildSaveButton() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ElevatedButton(
        onPressed: () {
          _debouncer.run(() {
            _submitReport();
          });
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
        child: isSaving
            ? const CircularProgressIndicator(
                color: Colors.black,
              )
            : const Text(
                'حفظ',
                style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w300),
              ),
      ),
    );
  }

  Column buildTicketFields() {
    return Column(
      children: [
        IgnorePointer(
          ignoring: widget.ticket == null || widget.ticket?.status == "inprogress" ? false : true,
          child: Column(
            children: [
              textReports('الاسم', 'خالد جمعة', name, nameController, (value) {
                setState(() {
                  name = value;
                });
              }),
              buildRow(
                  textReports('الهاتف', '091XXXXXXX', name, phoneController, (value) {
                    setState(() {
                      phone = value;
                    });
                  }),
                  textReports('الحساب', 'HTIX00000', account, accController, (value) {
                    setState(() {
                      account = value;
                    });
                  })),
              buildRow(
                  textReports('المكان', 'ش طرابلس', place, placeController, (value) {
                    setState(() {
                      place = value;
                    });
                  }),
                  textReports('البرج', 'ZXX-SECXX', sector, sectorController, (value) {
                    setState(() {
                      sector = value;
                    });
                  })),
              buildTowersAndSectorsDropdowns(),
            ],
          ),
        ),
      ],
    );
  }

  Row buildRow(Widget leftChild, Widget rightChild) {
    return Row(
      children: [
        Expanded(child: leftChild),
        const SizedBox(width: 8.0),
        Expanded(child: rightChild),
      ],
    );
  }

  Container buildTowersAndSectorsDropdowns() {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: buildTowersDropdown(),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: buildSectorsDropdown(),
            ),
          ),
        ],
      ),
    );
  }

  Container buildTowersDropdown() {
    return Container(
      child: DropdownButton<Tower>(
        value: selectedTower,
        items: towers.map((Tower tower) {
          return DropdownMenuItem<Tower>(
            value: tower,
            child: Text(tower.name),
          );
        }).toList(),
        onChanged: (Tower? newValue) {
          setState(() {
            selectedTower = newValue;
            selectedSector = null;
          });
        },
        hint: const Text(
          'اختر برج',
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  Container buildSectorsDropdown() {
    return Container(
      child: DropdownButton<Sector>(
        isExpanded: true,
        value: selectedSector,
        items: selectedTower?.sectors?.map((Sector sector) {
              return DropdownMenuItem<Sector>(
                value: sector,
                child: Text(sector.name),
              );
            }).toList() ??
            [],
        onChanged: (Sector? newValue) {
          setState(() {
            selectedSector = newValue;
          });
        },
        hint: const Text('اختر قطاع'),
      ),
    );
  }

  Widget buildContainer(String title, List<String> items, VoidCallback? onPressed) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 100,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    dense: true,
                    leading: Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.fiber_manual_record,
                        size: 12,
                        color: Colors.black,
                      ),
                    ),
                    title: Text(
                      items[index],
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: IconButton(
                  onPressed: onPressed,
                  icon: const Icon(Icons.edit, color: Colors.black),
                  iconSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLocationSection() {
    return Column(
      children: [
        const SizedBox(height: 15),
        Row(
          children: [
            SizedBox(
              width: 120,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  _debouncer.run(() async {
                    try {
                      setState(() {
                        isLoadingLoc = true;
                      });

                      locationData = await locationService.getUserLocation();
                      locationController.text = '${locationData!.latitude}, ${locationData!.longitude}';
                      setState(() {
                        longitude = locationData!.longitude;
                        latitude = locationData!.latitude;
                      });
                    } catch (e) {
                      // ApiService().handleErrorMessage(msg: 'Error fetching location: $e');
                      openAppSettings();
                      debugPrint("Error fetching location: $e");
                    } finally {
                      setState(() {
                        isLoadingLoc = false; // Set loading to false when done fetching data
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(60, 80),
                  backgroundColor: Colors.grey[300],
                ),
                child: Center(
                  child: isLoadingLoc
                      ? const CircularProgressIndicator() // Show loading indicator
                      : const Text(
                          "جلب احداثيات الموقع",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  controller: locationController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'احداثيات الموقع',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    hintText: 'xx.xxxx, xx.xxxx',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildLocationMap() {
    return Column(
      children: [
        const SizedBox(height: 10),
        if (latitude != 0 && longitude != 0 && longitude != null)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 2),
            ),
            width: 400,
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: MapBox(latitude: latitude!, longitude: longitude!, zoomLvl: zoomLvl),
            ),
          ),
        const SizedBox(height: 15),
      ],
    );
  }

  void _submitReport() async {
    if (name.isEmpty || account.isEmpty || phone.isEmpty || place.isEmpty || sector.isEmpty || locationController.text.isEmpty) {
      Fluttertoast.showToast(msg: "الرجاء ملء الحقول");
      return;
    }
    List<int> selectedSolutionIds =
        solutionCheckboxGroup.asMap().entries.where((entry) => entry.value).map((entry) => solutionsCheckbox[entry.key].id).toList();

    List<int> selectedProblemIds =
        problemCheckboxGroup.asMap().entries.where((entry) => entry.value).map((entry) => problemsCheckbox[entry.key].id).toList();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        Fluttertoast.showToast(msg: 'جاري الحفظ');
        if (widget.ticket == null) {
          await ApiService().addReport(
              name,
              account,
              phone,
              place,
              //('${selectedTower!.name}-${selectedSector!.name}'),
              sector,
              selectedProblemIds,
              selectedSolutionIds,
              locationData!.longitude!,
              locationData!.latitude!);
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } else {
          await ApiService().updateReport(
              name: nameController.text,
              acc: accController.text,
              phone: phoneController.text,
              place: placeController.text,
              sector: sector, //('${selectedTower!.name}-${selectedSector!.name}'),
              id: widget.ticket!.id,
              problems: selectedProblemIds,
              solution: selectedSolutionIds,
              longitude: longitude,
              latitude: latitude);
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => SurveyPage(ticket: widget.ticket),
            ),
          );
        }
      } catch (e) {
        ApiService().handleErrorMessage(msg: "_submitReport ERROR: $e");
      }
    } else {
      Fluttertoast.showToast(msg: "لا يوجد اتصال بالانترنت");
    }
  }

  void _updateSelectedProblems() {
    textTrueProblem.clear();
    for (int index = 0; index < problemsCheckbox.length; index++) {
      if (problemCheckboxGroup[index]) {
        textTrueProblem.add(problemsCheckbox[index].name);
      }
    }
  }

  void _updateSelectedSolution() {
    textTrueSolution.clear();
    for (int index = 0; index < solutionsCheckbox.length; index++) {
      if (solutionCheckboxGroup[index]) {
        textTrueSolution.add(solutionsCheckbox[index].name);
      }
    }
  }

  void _showBottomSheetProblem() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return ListView.builder(
              itemCount: problemsCheckbox.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          problemsCheckbox[index].name,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  value: problemCheckboxGroup[index],
                  onChanged: (value) {
                    setState(() {
                      problemCheckboxGroup[index] = value!;
                    });
                  },
                );
              },
            );
          },
        );
      },
    ).then((result) {
      _updateSelectedProblems();
      setState(() {});
    });
  }

  void _showBottomSheetSolution() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return ListView.builder(
              itemCount: solutionsCheckbox.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          solutionsCheckbox[index].name,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  value: solutionCheckboxGroup[index],
                  onChanged: (value) {
                    setState(() {
                      solutionCheckboxGroup[index] = value!;
                    });
                  },
                );
              },
            );
          },
        );
      },
    ).then((result) {
      _updateSelectedSolution();
      setState(() {});
    });
  }
}
