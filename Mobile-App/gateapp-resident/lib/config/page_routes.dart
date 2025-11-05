import 'package:flutter/material.dart';

import 'package:gateapp_user/features_todo/new_message_popup_screen.dart';
import 'package:gateapp_user/pages/add_amenity_appointment_page.dart';
import 'package:gateapp_user/pages/add_complaint_admin_page.dart';
import 'package:gateapp_user/pages/add_complaint_page.dart';
import 'package:gateapp_user/pages/add_payment_request_page.dart';
import 'package:gateapp_user/pages/add_post_page.dart';
import 'package:gateapp_user/pages/add_service_booking_page.dart';
import 'package:gateapp_user/pages/add_visitor_log_custom_page.dart';
import 'package:gateapp_user/pages/add_visitor_log_page.dart';
import 'package:gateapp_user/pages/amenities_page.dart';
import 'package:gateapp_user/pages/amenity_appointment_payment_page.dart';
import 'package:gateapp_user/pages/amenity_appointments_page.dart';
import 'package:gateapp_user/pages/announcements_page.dart';
import 'package:gateapp_user/pages/chat_page.dart';
import 'package:gateapp_user/pages/complaint_detail_page.dart';
import 'package:gateapp_user/pages/complaints_page.dart';
import 'package:gateapp_user/pages/gate_pass_page.dart';
import 'package:gateapp_user/pages/language_page.dart';
import 'package:gateapp_user/pages/my_account_page.dart';
import 'package:gateapp_user/pages/my_profile_page.dart';
import 'package:gateapp_user/pages/my_residency_page.dart';
import 'package:gateapp_user/pages/notifications_page.dart';
import 'package:gateapp_user/pages/payment_requests_page.dart';
import 'package:gateapp_user/pages/payment_result_page.dart';
import 'package:gateapp_user/pages/add_comments_page.dart';
import 'package:gateapp_user/pages/process_payment_page.dart';
import 'package:gateapp_user/pages/service_bookings_page.dart';
import 'package:gateapp_user/pages/service_search_page.dart';
import 'package:gateapp_user/pages/support_page.dart';
import 'package:gateapp_user/pages/tnc_page.dart';

class PageRoutes {
  static const String newMessageScreen = "new_message";

  static const String addVisitorLogPage = "add_visitor_log_page";
  static const String gatePassPage = "gatepass_page";
  static const String complaintsPage = "complaints_page";
  static const String complaintDetailPage = "complaint_detail_page";
  static const String addComplaintPage = "add_complaint_page";
  static const String amenityAppointmentsPage = "amenity_appointments_page";
  static const String amenitiesPage = "amenities_page";
  static const String addAmenityAppointmentPage =
      "add_amenity_appointment_page";
  static const String amenityAppointmentPaymentPage =
      "amenity_appointment_payment_page";
  static const String processPaymentPage = "process_payment_page";
  static const String notificationsPage = "notifications_page";
  static const String addComplaintAdminPage = "add_complaint_admin_page";
  static const String myAccountPage = "my_account_page";
  static const String myResidencyPage = "my_residency_page";
  static const String languagePage = "language_page";
  static const String myProfilePage = "my_profile_page";
  static const String supportPage = "support_page";
  static const String tncPage = "tnc_page";
  static const String addVisitorLogCustomPage = "add_visitor_log_custom_page";
  static const String chatPage = "chat_page";
  static const String addPostPage = "add_post_page";
  static const String addCommentsPage = "add_comments_page";
  static const String addServiceBookingPage = "add_service_booking_page";
  static const String serviceBookingsPage = "service_bookings_page";
  static const String serviceSearchPage = "service_search_page";
  static const String paymentRequestsPage = "payment_requests_page";
  static const String addPaymentRequestPage = "add_payment_request_page";
  static const String paymentResultPage = "payment_result_page";
  static const String announcementsPage = "announcements_page";

  Map<String, WidgetBuilder> routes() => {
        newMessageScreen: (context) => const NewMessagePopupScreen(),
        //newblow
        addVisitorLogPage: (context) => const AddVisitorLogPage(),
        gatePassPage: (context) => const GatePassPage(),
        complaintsPage: (context) => const ComplaintsPage(),
        complaintDetailPage: (context) => const ComplaintDetailPage(),
        addComplaintPage: (context) => const AddComplaintPage(),
        amenityAppointmentsPage: (context) => const AmenityAppointmentsPage(),
        amenitiesPage: (context) => const AmenitiesPage(),
        addAmenityAppointmentPage: (context) =>
            const AddAmenityAppointmentPage(),
        amenityAppointmentPaymentPage: (context) =>
            const AmenityAppointmentPaymentPage(),
        processPaymentPage: (context) => const ProcessPaymentPage(),
        notificationsPage: (context) => const NotificationsPage(),
        addComplaintAdminPage: (context) => const AddComplaintAdminPage(),
        myResidencyPage: (context) => const MyResidencyPage(),
        languagePage: (context) => const LanguagePage(),
        myAccountPage: (context) => const MyAccountPage(),
        myProfilePage: (context) => const MyProfilePage(),
        supportPage: (context) => const SupportPage(),
        tncPage: (context) => const TncPage(),
        addVisitorLogCustomPage: (context) => const AddVisitorLogCustomPage(),
        chatPage: (context) => const ChatPage(),
        addPostPage: (context) => const AddPostPage(),
        addCommentsPage: (context) => const AddCommentsPage(),
        addServiceBookingPage: (context) => const AddServiceBookingPage(),
        serviceBookingsPage: (context) => const ServiceBookingsPage(),
        serviceSearchPage: (context) => const ServiceSearchPage(),
        paymentRequestsPage: (context) => const PaymentRequestsPage(),
        addPaymentRequestPage: (context) => const AddPaymentRequestPage(),
        paymentResultPage: (context) => const PaymentResultPage(),
        announcementsPage: (context) => const AnnouncementsPage(),
      };
}
