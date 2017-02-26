# Use this to add smart_surf2_4g_mts to CM's lunch command menu
for var in eng user userdebug; do
  add_lunch_combo mk_smart_surf2_4g-$var
done
