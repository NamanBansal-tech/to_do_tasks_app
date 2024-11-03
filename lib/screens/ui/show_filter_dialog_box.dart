import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_tasks/models/task_model/task_model.dart';
import 'package:to_do_tasks/screens/bloc/home_bloc.dart';
import 'package:to_do_tasks/utils/app_strings.dart';
import 'package:to_do_tasks/utils/utility.dart';

class ShowFilterDialogBox extends StatelessWidget {
  const ShowFilterDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 6.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.priority,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
            Row(
              children: [
                Radio(
                  value: TaskPriority.low,
                  visualDensity: const VisualDensity(horizontal: -4),
                  groupValue: state.selectedFilterPriority,
                  onChanged: (val) {
                    if (val != null) {
                      context.read<HomeBloc>().updateFilterPriority(val);
                    }
                  },
                  fillColor: WidgetStateProperty.all(
                      Utility.getPriorityColor(TaskPriority.low)),
                ),
                Text(
                  AppStrings.low,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                  ),
                ),
                Radio(
                  value: TaskPriority.medium,
                  groupValue: state.selectedFilterPriority,
                  onChanged: (val) {
                    if (val != null) {
                      context.read<HomeBloc>().updateFilterPriority(val);
                    }
                  },
                  fillColor: WidgetStateProperty.all(
                      Utility.getPriorityColor(TaskPriority.medium)),
                ),
                Text(
                  AppStrings.medium,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                  ),
                ),
                Radio(
                  value: TaskPriority.high,
                  groupValue: state.selectedFilterPriority,
                  onChanged: (val) {
                    if (val != null) {
                      context.read<HomeBloc>().updateFilterPriority(val);
                    }
                  },
                  fillColor: WidgetStateProperty.all(
                      Utility.getPriorityColor(TaskPriority.high)),
                ),
                Text(
                  AppStrings.high,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                AppStrings.deadLine,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5.w,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 6.h,horizontal: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.selectedFilterDateTime != null
                          ? Utility.formatDisplayDate(
                              state.selectedFilterDateTime!)
                          : 'dd/MM/yyyy',
                    ),
                    InkWell(
                      onTap: () async {
                        final currentDate = DateTime.now();
                        final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(currentDate.year - 100),
                          lastDate: DateTime(currentDate.year + 12),
                          currentDate: state.selectedFilterDateTime,
                        );
                        if (context.mounted && date != null) {
                          context
                              .read<HomeBloc>()
                              .updateSelectedFilteredDate(date);
                        }
                      },
                      child: const Icon(
                        Icons.calendar_month_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().getTaskStream();
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppStrings.submit,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().updateFilterPriority(null);
                      context.read<HomeBloc>().updateSelectedFilteredDate(null);
                      context.read<HomeBloc>().getTaskStream();
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppStrings.reset,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
