set(PLATFORM_REQUIRED_DEPS LibAndroidJNI OpenGLES EGL LibZip)
set(PLATFORM_OPTIONAL_DEPS_EXCLUDE CEC)
set(APP_RENDER_SYSTEM gles)
list(APPEND PLATFORM_OPTIONAL_DEPS LibDovi)

# Compile and target Android 15 APIs while remaining compatible with newer
# Android 16 devices. The linker flags below provide 16 KB ELF alignment with NDK r27.
set(TARGET_SDK 35)
# Minimum supported SDK version (Android 5.0).
set(TARGET_MINSDK 21)

add_link_options("-Wl,-z,max-page-size=16384" "-Wl,-z,common-page-size=16384")

set(${CORE_PLATFORM_NAME_LC}_SEARCH_CONFIG NO_DEFAULT_PATH CACHE STRING "")
