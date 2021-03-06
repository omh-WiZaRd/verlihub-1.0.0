#-------------------------------------------------------------------
# This file is taken from KDE CMake build system
# http://www.kde.org/
#
# The contents of this file are placed in the public domain. Feel
# free to make use of it in any way you like.
#-------------------------------------------------------------------

# This file defines the Feature Logging macros.
#
# MACRO_LOG_FEATURE(VAR FEATURE DESCRIPTION URL [MIN_VERSION [COMMENTS]]])
#   Logs the information so that it can be displayed at the end
#   of the configure run
#   VAR : TRUE or FALSE, indicating whether the feature is supported
#   FEATURE: name of the feature, e.g. "libjpeg"
#   DESCRIPTION: description what this feature provides
#   URL: home page
#   MIN_VERSION: minimum version number. empty string if unneeded
#   COMMENTS: More info you may want to provide.  empty string if unnecessary
#
# MACRO_DISPLAY_FEATURE_LOG()
#   Call this to display the collected results.
#   Exits CMake with a FATAL error message if a required feature is missing
#
# Example:
#
# INCLUDE(MacroLogFeature)
#
# FIND_PACKAGE(JPEG)
# MACRO_LOG_FEATURE(JPEG_FOUND "libjpeg" "Support JPEG images" "http://www.ijg.org" "3.2a")
# ...
# MACRO_DISPLAY_FEATURE_LOG()

# Copyright (c) 2006, Alexander Neundorf, <neundorf@kde.org>
# Copyright (c) 2006, Allen Winter, <winter@kde.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

IF (NOT _macroLogFeatureAlreadyIncluded)

   SET(_file ${VERLIHUB_BINARY_DIR}/EnabledFeatures.txt)
   IF (EXISTS ${_file})
      FILE(REMOVE ${_file})
   ENDIF (EXISTS ${_file})

   SET(_file ${VERLIHUB_BINARY_DIR}/DisabledFeatures.txt)
   IF (EXISTS ${_file})
      FILE(REMOVE ${_file})
  ENDIF (EXISTS ${_file})

  SET(_macroLogFeatureAlreadyIncluded TRUE)
ENDIF (NOT _macroLogFeatureAlreadyIncluded)

MACRO(MACRO_LOG_FEATURE _var _package _description) # _url _minvers _comments

	SET(_minvers "${ARGV4}")
	SET(_url "${ARGV3}")
	SET(_comments "${ARGV5}")

	IF (${_var})
		SET(_LOGFILENAME ${VERLIHUB_BINARY_DIR}/EnabledFeatures.txt)
	ELSE (${_var})
		SET(_LOGFILENAME ${VERLIHUB_BINARY_DIR}/DisabledFeatures.txt)
	ENDIF (${_var})

	SET(_logtext "+ ${_package}")

	IF (${_minvers} MATCHES ".*")
			SET(_logtext "${_logtext} (>=${_minvers})")
	ENDIF (${_minvers} MATCHES ".*")
	SET(_logtext "${_logtext}: ${_description}")
	IF (${_url} MATCHES ".*")
		SET(_logtext "${_logtext} <${_url}>")
	ENDIF (${_url} MATCHES ".*")

	STRING(TOUPPER ${_package} FEATURE_NAME)
	SET(_logtext "${_logtext} (WITH_${FEATURE_NAME})")
	IF (NOT ${_var})
		IF (${_comments} MATCHES ".*")
			SET(_logtext "${_logtext}: ${_comments}")
		ENDIF (${_comments} MATCHES ".*")
	ENDIF (NOT ${_var})
	FILE(APPEND "${_LOGFILENAME}" "${_logtext}\n")
 
ENDMACRO(MACRO_LOG_FEATURE)

MACRO(MACRO_DISPLAY_FEATURE_LOG)
	SET(_summary "\n")

	SET(_elist 0)
	SET(_file ${VERLIHUB_BINARY_DIR}/EnabledFeatures.txt)
	IF (EXISTS ${_file})
		SET(_elist 1)
		FILE(READ ${_file} _enabled)
		FILE(REMOVE ${_file})
		SET(_summary "${_summary}-----------------------------------------------------------------------------\n-- The following external packages were located on your system.\n-- This installation will have the extra features provided by these packages.\n${_enabled}")
	ENDIF (EXISTS ${_file})

	SET(_dlist 0)
	SET(_file ${VERLIHUB_BINARY_DIR}/DisabledFeatures.txt)
	IF (EXISTS ${_file})
		SET(_dlist 1)
		FILE(READ ${_file} _disabled)
		FILE(REMOVE ${_file})
		SET(_summary "${_summary}-----------------------------------------------------------------------------\n-- The following OPTIONAL packages could NOT be located on your system.\n-- Consider installing them to enable more features from this software.\n${_disabled}")
	ELSE (EXISTS ${_file})
		IF (${_elist})
			SET(_summary "${_summary}Congratulations! All external packages have been found.\n")
		ENDIF (${_elist})
	ENDIF (EXISTS ${_file})

	IF (${_elist} OR ${_dlist})
		SET(_summary "${_summary}-----------------------------------------------------------------------------\n")
	ENDIF (${_elist} OR ${_dlist})
	MESSAGE(STATUS "${_summary}")
ENDMACRO(MACRO_DISPLAY_FEATURE_LOG)
