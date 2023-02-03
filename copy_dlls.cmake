function(copy_runtime_deps target_name target_path dll_paths is_debug)
    message("=== Target name: ${target_name}")
    message("=== Target directory: ${target_path}")
    message("=== Bin directory: ${dll_paths}")

    file(GLOB EXISTS_DLLS_TMP ${target_path}/*.dll)

    # Strip off the path
    foreach(aDLL ${EXISTS_DLLS_TMP})
        get_filename_component(filenameWithExt ${aDLL} NAME)
        list(APPEND EXISTS_DLLS ${filenameWithExt})
    endforeach(aDLL)

    file(GET_RUNTIME_DEPENDENCIES
        EXECUTABLES ${target_name}
        DIRECTORIES ${dll_paths}
        RESOLVED_DEPENDENCIES_VAR RESOLVED_DEPS
        UNRESOLVED_DEPENDENCIES_VAR UNRESOLVED_DEPS
        PRE_EXCLUDE_REGEXES "api-ms-*" "ext-ms-*" ${EXISTS_DLLS}
        POST_EXCLUDE_REGEXES ".*system32/.*\\.dll"
    )
    list(LENGTH RESOLVED_DEPS RESOLVED_DEPS_LEN)
    list(LENGTH UNRESOLVED_DEPS UNRESOLVED_DEPS_LEN)
    message(STATUS "Resolved deps to be copied: ${RESOLVED_DEPS_LEN}")
    message(STATUS "Unresolved deps: ${UNRESOLVED_DEPS_LEN}")

    if(is_debug)
        message(STATUS "Resolved deps to be copied: ${RESOLVED_DEPS}")
        message(STATUS "Unresolved deps: ${UNRESOLVED_DEPS}")
    else()
        file(COPY ${RESOLVED_DEPS} DESTINATION ${target_path} FOLLOW_SYMLINK_CHAIN)
    endif()
endfunction()

message("DLL_SEARCH_PATH_LIST: ${DLL_SEARCH_PATH_LIST}")
copy_runtime_deps(${TARGET_NAME} ${TARGET_PATH} ${DLL_SEARCH_PATH_LIST} ${IS_DEBUG})