class_name ZIPManager
extends Node


# Step 1 - Set up ZIP processing
# Step 2 - Loop through the ZIP content
#	If the file name ends in a "/", then create the directory
#	Otherwise copy the ZIP file to the content directory
func unzip_content(src: String) -> void:
# Step 1
	var zr = ZIPReader.new()
	var content_dir = DirAccess.open(Constant.CONTENT_DIR)
	if zr.open(src) != OK:
		print("Failed opening ZIP file: ", src)
		return
# Step 2
	var files = zr.get_files()
	for f in files:
		if f.ends_with('/'):
			content_dir.make_dir(Constant.CONTENT_DIR + f)
		else:
			var fa := FileAccess.open(Constant.CONTENT_DIR + f, FileAccess.WRITE)
			fa.store_buffer(zr.read_file(f))
	zr.close()
