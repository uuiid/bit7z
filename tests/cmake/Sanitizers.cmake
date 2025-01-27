macro( add_sanitizer name )
    set( CMAKE_REQUIRED_FLAGS "-fsanitize=${name}" )
    check_cxx_compiler_flag( -fsanitize=${name} COMPILER_SUPPORTS_SANITIZE_${name} )
    if( COMPILER_SUPPORTS_SANITIZE_${name} )
        message( STATUS "Supported sanitizer: ${name}" )
        set( CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fsanitize=${name}" )
    else()
        message( STATUS "Unsupported sanitizer: ${name}" )
    endif()
    unset( CMAKE_REQUIRED_FLAGS )
endmacro()

if( MSVC )
    set( CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /RTCsu /analyze" )
elseif( NOT WIN32 ) # GCC on Linux (i.e., not MinGW)
    set( CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fno-omit-frame-pointer" )

    if( CMAKE_CXX_COMPILER_ID MATCHES "Clang" )
        set( CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -static-libsan" )
    endif()

    # Use the highest stack protection level supported by the target toolchain.
    include( CheckCXXCompilerFlag )
    check_cxx_compiler_flag( -fstack-protector-strong COMPILER_SUPPORT_STRONG_STACK_PROTECTOR )
    check_cxx_compiler_flag( -fstack-protector COMPILER_SUPPORT_STACK_PROTECTOR )
    if( COMPILER_SUPPORT_STRONG_STACK_PROTECTOR )
        set( CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_DEBUG} -fstack-protector-strong" )
    elseif( COMPILER_SUPPORT_STACK_PROTECTOR )
        set( CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_DEBUG} -fstack-protector" )
    endif()

    # For some reasons, using the leak sanitizer on Clang 14 gives lots of 'undefined reference'
    # issues during linking... ¯\_(ツ)_/¯
    if( NOT CMAKE_CXX_COMPILER_ID MATCHES "Clang" )
        add_sanitizer( leak )
    endif()

    add_sanitizer( address )
    check_cxx_compiler_flag( -fsanitize-address-use-after-scope COMPILER_SUPPORT_SANITIZE_USE_AFTER_SCOPE )
    if( COMPILER_SUPPORT_SANITIZE_USE_AFTER_SCOPE )
        set( CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fsanitize-address-use-after-scope" )
    endif()

    add_sanitizer( float-divide-by-zero )
    add_sanitizer( implicit-conversion )
    add_sanitizer( integer )
    add_sanitizer( local-bounds )
    add_sanitizer( nullability )
    add_sanitizer( undefined )
endif()

