GSDownloaderSDK
===============

基于AFNetworking 1.x封装的一个下载SDK，对外提供任务下载、暂停、恢复、取消及相关批量操作。详细使用可以参考Demo代码。

适用平台:
--------------------
考虑到通用性，底层没有使用最新只适用于iOS7的AFNetworking 2.x，而是最高版本的AFNetworking 1.x。适用平台：iOS5.0+

如何编译SDK:
--------------------
1:open workspace with xcode

2:edit GSDownloaderSDK scheme

3:copy below script into Build/Pre-actions.(note:must select Provide build settings from:GSDownloaderSDK)

	# Sets the target folders and the final framework product.

	FMK_NAME=GSDownloaderSDK

	FMK_VERSION=A



	# Install dir will be the final output to the framework.

	# The following line create it in the root folder of the current project.

	INSTALL_DIR=${SRCROOT}/Products/${FMK_NAME}.framework

	# Working dir will be deleted after the framework creation.

	#WRK_DIR=build

	DEVICE_DIR=Release-iphoneos/${FMK_NAME}.framework

	SIMULATOR_DIR=Release-iphonesimulator/${FMK_NAME}.framework

	cd ${PROJECT_DIR}
	rm -rf build

	# Building both architectures.

	xcodebuild -sdk iphoneos -configuration "Release"

	xcodebuild -sdk iphonesimulator -configuration "Release"



	# Cleaning the oldest.

	if [ -d "${INSTALL_DIR}" ]

	then

	rm -rf "${INSTALL_DIR}"

	fi



	# Creates and renews the final product folder.

	mkdir -p "${INSTALL_DIR}"

	mkdir -p "${INSTALL_DIR}/Versions"

	mkdir -p "${INSTALL_DIR}/Versions/${FMK_VERSION}"

	mkdir -p "${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources"

	mkdir -p "${INSTALL_DIR}/Versions/${FMK_VERSION}/Headers"



	# Creates the internal links.

	# It MUST uses relative path, otherwise will not work when the folder is copied/moved.

	ln -s "${FMK_VERSION}" "${INSTALL_DIR}/Versions/Current"

	ln -s "Versions/Current/Headers" "${INSTALL_DIR}/Headers"

	ln -s "Versions/Current/Resources" "${INSTALL_DIR}/Resources"

	ln -s "Versions/Current/${FMK_NAME}" "${INSTALL_DIR}/${FMK_NAME}"

	#into build
	cd build

	# Copies the headers and resources files to the final product folder.

	cp -R "${DEVICE_DIR}/Headers/" "${INSTALL_DIR}/Versions/${FMK_VERSION}/Headers/"

	cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources/"



	# Removes the binary and header from the resources folder.

	rm -r "${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources/Headers" "${INSTALL_DIR}/Versions/${FMK_VERSION}/Resources/${FMK_NAME}"



	# Uses the Lipo Tool to merge both binary files (i386 + armv6/armv7) into one Universal final product.

	lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/Versions/${FMK_VERSION}/${FMK_NAME}"

	cd ..

	rm -rf build

	#rm -r "${WRK_DIR}"

4:select GSDownloaderSDK scheme,and cmd+B.

GSDownloaderSDK.framework will create into GSDownloaderSDK/Products

如何编译Demo:
--------------------
由于GSDownloaderSDK工程内，依赖了我自己封装的另外两个framework（GSUtiliesSDK.framework和GSCoreThirdParty.framework），用于我自己的项目。我把这两个framework放在SDK工程下的Frameworks目录下。Demo工程直接引用SDK工程下的framework文件。所以导致Demo工程下的Framework Search路径无法写成绝对路径的形式（或者是我不知道怎么写）
所以第一次编译Demo工程前，先需要将对应Frameworks下的GSUtiliesSDK.framework和GSCoreThirdParty.framework重新引用一遍即可。

将要做的事:
--------------------
取消framework的形式（做成framewok只是为自身项目提供封装），将Demo和SDK统一为一份工程文件。