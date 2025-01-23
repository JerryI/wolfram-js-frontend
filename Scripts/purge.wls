#!/usr/bin/env wolframscript

PacletDirectoryUnload /@ PacletDirectoryLoad[]; (* FIXME WL autoloads some crap *)

ParentDirectory[DirectoryName[$InputFileName]] // SetDirectory;
PacletDirectoryLoad[Directory[]];

DeleteFile /@ {
    ".wl_timestamp",
    ".wljs_timestamp",
    "wl_packages_lock.wl",
    "wljs_packages_lock.wl",
    "wljs_packages_users.wl"
};

DeleteDirectory[#, DeleteContents -> True] &/@ {
    "wl_packages",
    "wljs_packages"
};

Echo["Purged"];