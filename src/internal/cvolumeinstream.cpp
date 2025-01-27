// This is an open source non-commercial project. Dear PVS-Studio, please check it.
// PVS-Studio Static Code Analyzer for C, C++ and C#: http://www.viva64.com

/*
 * bit7z - A C++ static library to interface with the 7-zip shared libraries.
 * Copyright (c) 2014-2022 Riccardo Ostani - All Rights Reserved.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

#include "internal/cvolumeinstream.hpp"

using bit7z::CVolumeInStream;

CVolumeInStream::CVolumeInStream( const fs::path& volume_path, uint64_t global_offset )
    : CFileInStream{ volume_path }, mSize{ fs::file_size( volume_path ) }, mGlobalOffset{ global_offset } {}

BIT7Z_NODISCARD
uint64_t CVolumeInStream::globalOffset() const {
    return mGlobalOffset;
}

BIT7Z_NODISCARD
uint64_t CVolumeInStream::size() const {
    return mSize;
}