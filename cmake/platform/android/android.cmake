set(PLATFORM_REQUIRED_DEPS LibAndroidJNI OpenGLES EGL LibZip)
set(PLATFORM_OPTIONAL_DEPS_EXCLUDE CEC)
set(APP_RENDER_SYSTEM gles)
list(APPEND PLATFORM_OPTIONAL_DEPS LibDovi)

# Compile and target Android 15 APIs while remaining compatible with newer
# Android 16 devices. NDK r28 requires API 23 for libiconv's mempcpy usage.
set(TARGET_SDK 35)
# Minimum supported SDK version (Android 6.0).
set(TARGET_MINSDK 23)

set(${CORE_PLATFORM_NAME_LC}_SEARCH_CONFIG NO_DEFAULT_PATH CACHE STRING "")
