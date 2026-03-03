import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../shared/const/colors.dart';
import '../../../auth/presentation/blocs/security/security_bloc.dart';
import '../../../auth/presentation/blocs/security/security_event.dart';
import '../../../auth/presentation/blocs/security/security_state.dart';
import '../../../auth/domain/entities/device.dart';

class DeviceManagementScreen extends StatefulWidget {
  const DeviceManagementScreen({super.key});

  @override
  State<DeviceManagementScreen> createState() => _DeviceManagementScreenState();
}

class _DeviceManagementScreenState extends State<DeviceManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SecurityBloc>().add(GetDevicesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          "Trusted Devices",
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<SecurityBloc, SecurityState>(
        builder: (context, state) {
          if (state is SecurityLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DevicesLoaded) {
            if (state.devices.isEmpty) {
              return _buildEmptyState();
            }
            return _buildDeviceList(state.devices);
          }

          if (state is SecurityFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(state.errorMessage),
                  TextButton(
                    onPressed: () => context.read<SecurityBloc>().add(GetDevicesRequested()),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.devices, size: 64, color: AppColors.border),
          SizedBox(height: 16.h),
          Text(
            "No devices found",
            style: GoogleFonts.poppins(fontSize: 16.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceList(List<Device> devices) {
    return ListView.separated(
      padding: EdgeInsets.all(24.w),
      itemCount: devices.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final device = devices[index];
        return _buildDeviceTile(device);
      },
    );
  }

  Widget _buildDeviceTile(Device device) {
    final lastActive = DateFormat.yMMMd().add_jm().format(device.lastActive);
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  device.deviceType == 'mobile' ? Icons.phone_android : Icons.computer,
                  color: AppColors.primary,
                  size: 20.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.deviceName,
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      "${device.platform} • ${device.browser}",
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (device.isTrusted)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    "Trusted",
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          const Divider(),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Last Active",
                    style: GoogleFonts.poppins(fontSize: 10.sp, color: AppColors.textSecondary),
                  ),
                  Text(
                    lastActive,
                    style: GoogleFonts.poppins(fontSize: 12.sp, color: AppColors.textPrimary),
                  ),
                ],
              ),
              Row(
                children: [
                  if (!device.isTrusted)
                    TextButton(
                      onPressed: () => context.read<SecurityBloc>().add(TrustDeviceRequested(device.deviceId)),
                      child: const Text("Trust"),
                    ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _showRemoveDialog(device),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRemoveDialog(Device device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove Device"),
        content: Text("Are you sure you want to remove ${device.deviceName}? You will be logged out from this device."),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              context.read<SecurityBloc>().add(RemoveDeviceRequested(device.deviceId));
              context.pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Remove", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
