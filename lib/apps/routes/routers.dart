import 'package:feedbackapp/apps/routes/router_name.dart';
import 'package:feedbackapp/pages/feedback/feedback_page.dart';
import 'package:feedbackapp/pages/info/info_page.dart';
import 'package:feedbackapp/pages/statistic/statistic_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouterConfigCustom {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: RoutersPath.infoPath,
        builder: (BuildContext context, GoRouterState state) {
          return const InfoPage();
        },
        routes: <RouteBase>[
          GoRoute(
            name: RoutersName.feedbackName,
            path: RoutersPath.feedbackPath,
            builder: (BuildContext context, GoRouterState state) {
              // Lấy dữ liệu từ tham số
              String selectedPart = '';
              String selectedShowroom = '';

              if (state.extra != null && state.extra is Map<String, dynamic>) {
                selectedPart =
                    (state.extra as Map<String, dynamic>)['selectedPart'] ?? '';
                selectedShowroom =
                    (state.extra as Map<String, dynamic>)['selectedShowroom'] ??
                        '';
              }

              // Truyền dữ liệu vào FeedbackPage
              return FeedbackPage(
                selectedPart: selectedPart,
                selectedShowroom: selectedShowroom,
              );
            },
          ),
          GoRoute(
            name: RoutersName.statisticName,
            path: RoutersPath.statisticPath,
            builder: (BuildContext context, GoRouterState state) {
              return const StatisticPage();
            },
          ),
        ],
      ),
    ],
  );
}
