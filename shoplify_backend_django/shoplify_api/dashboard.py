# from django.contrib.admin import site
# from django.db.models import Count
# from django.utils.translation import gettext_lazy as _
# from unfold.admin import UnfoldAdminDashboard
# from unfold.widgets import ChartWidget
# from .models import Order


# class MyAdminDashboard(UnfoldAdminDashboard):

#     def get_widgets(self, request):
#         # Query to get the number of orders per day
#         data = (
#             Order.objects.all()
#             .extra(select={"day": "DATE(placed_at)"})
#             .values("day")
#             .annotate(count=Count("id"))
#             .order_by("day")
#         )

#         # Extracting the data for the chart
#         labels = [entry["day"].strftime("%Y-%m-%d") for entry in data]
#         values = [entry["count"] for entry in data]

#         # Creating the chart widget
#         chart = ChartWidget(
#             data={
#                 "labels": labels,
#                 "datasets": [
#                     {
#                         "label": _("Orders per Day"),
#                         "data": values,
#                         "backgroundColor": "rgba(54, 162, 235, 0.2)",
#                         "borderColor": "rgba(54, 162, 235, 1)",
#                         "borderWidth": 1,
#                     }
#                 ],
#             },
#             options={"scales": {"y": {"beginAtZero": True}}},
#         )

#         return [chart]


# site.register_dashboard(MyAdminDashboard)
