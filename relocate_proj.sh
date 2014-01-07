create_Makefile () {
	cp Makefile_Template ../../projects/$1/proj.android/Makefile
}

edit_android () {
	sed -i "" "s/\"\.\.\/\.\.\/\.\./\"..\/..\/..\/cocos2d-x-3.0alpha1/" build_native.py
	sed -i "" "s/\/cocos/\/cocos2d-x-3.0alpha1\/cocos/" project.properties
	sed -i "" "s/REPLACE/$1/g" Makefile
	sed -i "" "s/cocos2dx_static/cocos2dx_static\\
LOCAL_WHOLE_STATIC_LIBRARIES += cocos_extension_static\\
LOCAL_WHOLE_STATIC_LIBRARIES += cocosbuilder_static/" jni/Android.mk
	sed -i "" "s/Box2D)/Box2D\)\\
\$\(call import-module,extensions\)\\
\$\(call import-module,cocosbuilder\)/" jni/Android.mk
}

relocate () {
	if [ $# != 3 ]; then
		echo Usage: relocate proj_name abs_dst_path android_target_id
	else
		# create_Makefile must be called before the mv command
		create_Makefile $1
		echo created Makefile
		mv ../../projects/$1 $2
		cd $2/$1/proj.android
		edit_android $1
		echo finished updating settings for android project
		android update project -p . --target $3
		android update project -p /Users/jackyc/myWorkspace/Tools/cocos2d-x-3.0alpha1/cocos/2d/platform/android/java --target $3
		echo finished updating android target version
	fi;
}

relocate $@
