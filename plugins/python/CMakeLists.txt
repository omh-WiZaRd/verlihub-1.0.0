SET(PYTHON_VERSION_MAJOR 1)
SET(PYTHON_VERSION_MINOR 2)
SET(PYTHON_VERSION_PATCH 0)
SET(PYTHON_VERSION "${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR}.${PYTHON_VERSION_PATCH}")

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})
IF(${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION} EQUAL 2.6)
	INCLUDE_DIRECTORIES(${PYTHON_INCLUDE_PATH})
ELSE(${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION} EQUAL 2.6)
	INCLUDE_DIRECTORIES(${PYTHON_INCLUDE_DIRS})
ENDIF(${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION} EQUAL 2.6)

SET(PYTHON_HDRS
	cconsole.h
	cpipython.h
	cpythoninterpreter.h
	wrapper.h
)

SET(PYTHON_SRCS
	cconsole.cpp
	cpythoninterpreter.cpp
)

SET(PYTHON_WRAPPER_SRCS
	wrapper.cpp
)

CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/cpipython.cpp" "${CMAKE_CURRENT_BINARY_DIR}/cpipython.cpp" @ONLY)
LIST(APPEND PYTHON_SRCS "${CMAKE_CURRENT_BINARY_DIR}/cpipython.cpp")

ADD_LIBRARY(libpython_pi MODULE ${PYTHON_SRCS})
SET_TARGET_PROPERTIES(libpython_pi PROPERTIES OUTPUT_NAME "python_pi")
target_link_libraries(libpython_pi ${DL_LIBRARIES})

ADD_LIBRARY(libvh_python_wrapper MODULE ${PYTHON_WRAPPER_SRCS})
SET_TARGET_PROPERTIES(libvh_python_wrapper PROPERTIES OUTPUT_NAME "vh_python_wrapper")
target_link_libraries(libvh_python_wrapper ${PYTHON_LIBRARIES})

INSTALL(TARGETS libpython_pi libvh_python_wrapper LIBRARY DESTINATION lib)
