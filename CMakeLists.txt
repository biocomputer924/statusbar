cmake_minimum_required(VERSION 3.8)

project(
    statusbar
    VERSION 0.0.0
)

find_package(Qt5 COMPONENTS
    Core
    WebKitWidgets
)

add_executable(main
    src/main.cpp
)

include_directories(
    include
)

set(CMAKE_CXX_EXTENSIONS OFF)

set_property(
    TARGET
        main
    PROPERTY OUTPUT_NAME ${PROJECT_NAME}
)

target_compile_features(main PUBLIC cxx_std_17)

target_link_libraries(main
    Qt5::Core
    Qt5::WebKitWidgets
)

install(
    TARGETS main
    DESTINATION bin
    COMPONENT bin
)

install(
    DIRECTORY include/${PROJECT_NAME}
    DESTINATION include
    COMPONENT include
)

install(
    DIRECTORY etc/${PROJECT_NAME}
    DESTINATION etc
    COMPONENT etc
)
