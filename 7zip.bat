@echo off
set "folder_to_compress=D:\Ziptest\"
set "zip_file_name=D:\Ziptest2\Archive.zip"

"C:\Program Files\7-Zip\7z.exe" a -tzip "%zip_file_name%" "%folder_to_compress%"
