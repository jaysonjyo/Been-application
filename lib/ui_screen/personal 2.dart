import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import '../features/personal_adding/personnel_adding_provider.dart';
import '../features/personal_adding/roles_model_class.dart';

class PersonnelDetailsForm extends StatefulWidget {
  final String token;
  const PersonnelDetailsForm({super.key, required this.token});

  @override
  State<PersonnelDetailsForm> createState() => _PersonnelDetailsFormState();
}

class _PersonnelDetailsFormState extends State<PersonnelDetailsForm> {
  bool isActive = false;
  bool isLoading = true;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController suburbController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postCodeController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  List<RoleModelClass> roles = [];
  List<int> selectedRoleIds = [];

  double? currentLatitude;
  double? currentLongitude;
  bool isGettingLocation = false;

  String addressHint = "Please type";

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    setState(() => isLoading = true);

    try {
      final repo =
          Provider.of<PersonnelAddingProvider>(context, listen: false).repo;
      final fetchedRoles = await repo.fetchRoles(widget.token);

      //print("✅ Loaded ${fetchedRoles.length} roles");

      setState(() {
        roles = fetchedRoles;
        isLoading = false;
      });
    } catch (e) {
     // print("❌ Error loading roles: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickCurrentLocation() async {
    if (isGettingLocation) return;
    setState(() {
      isGettingLocation = true;
      addressHint = "Fetching current location...";
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ft.Fluttertoast.showToast(msg: "Location permission denied");
          setState(() {
            isGettingLocation = false;
            addressHint = "Please type";
          });
          return;
        }
      }

      Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      currentLatitude = pos.latitude;
      currentLongitude = pos.longitude;

      //print("✅ Current Location: LAT=${pos.latitude}, LNG=${pos.longitude}");

      List<Placemark> placemarks =
      await placemarkFromCoordinates(pos.latitude, pos.longitude);
      Placemark place = placemarks.first;

      setState(() {
        addressController.text =
        "${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}";
        addressHint = "Please type";
      });

      ft.Fluttertoast.showToast(
        msg:
        "📍Location set: ${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}",
      );
    } catch (e) {
      ft.Fluttertoast.showToast(msg: "Error picking location: $e");
      //print("❌ Error fetching location: $e");
      setState(() {
        addressHint = "Please type";
      });
    } finally {
      setState(() => isGettingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final textScale = width / 400;

    return Scaffold(
      backgroundColor: const Color(0xfff6f8fb),
      body: Skeletonizer(
        enabled: isLoading,
        child: Column(
          children: [
            _buildHeader(height, width, textScale),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Full name", textScale),
                      _buildRoundedField(fullNameController,
                          hint: "Please type", textScale: textScale),

                      _buildLabel("Address", textScale),
                      _buildRoundedField(addressController,
                          hint: addressHint,
                          prefixIcon: Icons.location_on_outlined,
                          suffixIcon: Icons.my_location,
                          onSuffixTap: _pickCurrentLocation,
                          textScale: textScale),

                      _buildLabel("Suburb", textScale),
                      _buildRoundedField(suburbController,
                          hint: "Please type", textScale: textScale),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("State", textScale),
                                _buildRoundedField(stateController,
                                    hint: "Please type", textScale: textScale),
                              ],
                            ),
                          ),
                          SizedBox(width: width * 0.025),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Post code", textScale),
                                _buildRoundedField(postCodeController,
                                    keyboardType: TextInputType.phone,
                                    hint: "Please type", textScale: textScale),
                              ],
                            ),
                          ),
                        ],
                      ),

                      _buildLabel("Contact number", textScale),
                      _buildRoundedField(contactNumberController,
                          hint: "Please type",
                          keyboardType: TextInputType.phone,
                          textScale: textScale),

                      _buildLabel("Role", textScale),
                      Container(
                        padding: EdgeInsets.all(width * 0.025),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            // if (isLoading)
                            //   const Center(
                            //       child: CircularProgressIndicator(
                            //           color: Color(0xffffcc00)))
                            if (roles.isEmpty)
                              const Text("No roles found")
                            else
                              ...roles.map((role) {
                                final isSelected =
                                selectedRoleIds.contains(role.id);
                                return CheckboxListTile(
                                  value: isSelected,
                                  onChanged: (val) {
                                    setState(() {
                                      if (val == true) {
                                        selectedRoleIds.add(role.id);
                                      } else {
                                        selectedRoleIds.remove(role.id);
                                      }
                                    });
                                  },
                                  title: Text(
                                    role.role,
                                    style:
                                    TextStyle(fontSize: 14 * textScale),
                                  ),
                                  controlAffinity:
                                  ListTileControlAffinity.leading,
                                  activeColor: const Color(0xffffcc00),
                                );
                              }).toList(),
                          ],
                        ),
                      ),

                      _buildLabel("Additional Notes", textScale),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          _buildRoundedField(
                            notesController,
                            hint: "Please type",
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            onChanged: (val) => setState(() {}),
                            textScale: textScale,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(right: 12, bottom: 8),
                            child: Text(
                              "${notesController.text.length}/500",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12 * textScale,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.02),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLabel("Status", textScale),
                          Switch(
                            value: isActive,
                            onChanged: (val) =>
                                setState(() => isActive = val),
                            activeColor: Colors.green,
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.03),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade300,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: height * 0.018),
                              ),
                              child: Text(
                                "CANCEL",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15 * textScale,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.04),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _savePersonnel,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffffcc00),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: height * 0.018),
                              ),
                              child: Text(
                                "SAVE",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15 * textScale,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double height, double width, double textScale) {
    return Stack(
      children: [
        Image.asset(
          "assets/Frame 18341.png",
          fit: BoxFit.cover,
          height: height * 0.25,
          width: double.infinity,
        ),
        Padding(
          padding: EdgeInsets.only(top: height * 0.08),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(

                      icon: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: width * 0.05,
                        child: Icon(Icons.grid_view_rounded,
                            color: Colors.black, size: width * 0.05),
                      ), onPressed: () {  },
                    ),
                    IconButton(

                      icon: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: width * 0.05,
                        child: Icon(Icons.person_outline,
                            color: Colors.black, size: width * 0.05),

                      ), onPressed: () {  },
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.025),
              Text(
                "Personnel Details",
                style: GoogleFonts.poppins(
                  fontSize: 25 * textScale,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _savePersonnel() async {
    final token = widget.token;

    // 🟡 Step 1: Validate all required fields before sending
    if (fullNameController.text.trim().isEmpty) {
      ft.Fluttertoast.showToast(msg: "Please enter full name");
      return;
    }
    if (addressController.text.trim().isEmpty) {
      ft.Fluttertoast.showToast(msg: "Please enter address");
      return;
    }
    if (suburbController.text.trim().isEmpty) {
      ft.Fluttertoast.showToast(msg: "Please enter suburb");
      return;
    }
    if (stateController.text.trim().isEmpty) {
      ft.Fluttertoast.showToast(msg: "Please enter state");
      return;
    }
    if (postCodeController.text.trim().isEmpty) {
      ft.Fluttertoast.showToast(msg: "Please enter postcode");
      return;
    }
    if (contactNumberController.text.trim().isEmpty) {
      ft.Fluttertoast.showToast(msg: "Please enter contact number");
      return;
    }
    if (contactNumberController.text.trim().length < 8) {
      ft.Fluttertoast.showToast(msg: "Please enter a valid contact number");
      return;
    }
    if (selectedRoleIds.isEmpty) {
      ft.Fluttertoast.showToast(msg: "Please select at least one role");
      return;
    }
    if (currentLatitude == null || currentLongitude == null) {
      ft.Fluttertoast.showToast(
          msg: "Please fetch your current location before saving");
      return;
    }

    final body = {
      "first_name": fullNameController.text.trim(),
      "address": addressController.text.trim(),
      "latitude": currentLatitude?.toString() ?? "",
      "longitude": currentLongitude?.toString() ?? "",
      "suburb": suburbController.text.trim(),
      "state": stateController.text.trim(),
      "postcode": postCodeController.text.trim(),
      "country": "Australia",
      "contact_number": contactNumberController.text.trim(),
      "role_ids": selectedRoleIds.join(","), // ✅ multiple roles
      "status": isActive ? "1" : "0",
    };



    final provider = context.read<PersonnelAddingProvider>();
    await provider.addPersonnel(token, body);

    // Navigator.pop(context); // close progress dialog

    if (provider.error == null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Success"),
          content: const Text("✅ Details saved successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, true);

              },
              child: const Text("OK", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content:
          Text("Some issue, please enter valid details."),
          actions: [
            TextButton(
              onPressed: () { Navigator.pop(context);},
              child: const Text("OK", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );

      //print("📤 Sending POST body: $body");
      //print("provider.error ${provider.error}");
    }
  }

  Widget _buildRoundedField(
      TextEditingController controller, {
        required double textScale,
        String? hint,
        IconData? prefixIcon,
        IconData? suffixIcon,
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
        Function(String)? onChanged,
        VoidCallback? onSuffixTap,
      }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      readOnly: false,
      onTap: () async {
        if (suffixIcon == Icons.my_location && !isGettingLocation) {
          await _pickCurrentLocation();
        }
      },
      decoration: InputDecoration(
        prefixIcon:
        prefixIcon != null ? Icon(prefixIcon, color: Colors.grey) : null,
        suffixIcon: suffixIcon != null
            ? (isGettingLocation
            ? Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.grey,
            ),
          ),
        )
            : Icon(suffixIcon, color: Colors.grey))
            : null,
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14 * textScale, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
            horizontal: 16, vertical: maxLines > 1 ? 18 : 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildLabel(String text, double textScale) => Padding(
    padding: const EdgeInsets.only(bottom: 6, top: 16),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16 * textScale,
      ),
    ),
  );
}
