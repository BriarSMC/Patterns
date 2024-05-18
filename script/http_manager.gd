class_name HTTPManager 
extends Node



#region Description
# Handles all http requests
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

# exports (The following properties must be set in the Inspector by the designer)

# public variables

var content_config: Dictionary

# private variables

# onready variables

#endregion


# Virtual Godot methods



# Built-in Signal Callbacks


# Custom Signal Callbacks


# Public Methods

# we_have_http()
# Try to connect to the game server.
# If that works, then download the content config file and return true
# Otherwise, just return a false
#
# Parameters
#	None
# Return
#	true							http there and config downloaded
#	false							no http
#==
# Step 1
# 	Create a child HTTPRequest node (HTTPRequest must be in the tree for await to work)
# 	Try to get the config.json file from the remote web server
# 	If the request failed, then return no http available
# Step 2
# 	Wait for the request to complete 
#	If either the request failed or the config wasn't returned, then return no http available
# Step 3
#	Extract the JSON from the http load
func we_have_http() -> bool:
# Step 1
	var http = HTTPRequest.new()
	add_child(http)
	
	var ret = http.request(Constant.CONTENT_SERVER + "config.json")
	if ret != 0: 
		http.queue_free()
		return false
# Step 2
	var response = await http.request_completed
	if not(response[0] == 0 and response[1] == 200):
		http.queue_free()
		return false
# Step 3
	var json := JSON.new()
	json.parse(response[3].get_string_from_utf8())
	content_config = json.get_data()
	return true


# download_file(src, dest) 
# Download a file to specified location
#
# Parameters
#	src: String						Source file name on remote server
#	dest: String					Destination path
# Return
#	None
#==
# Step 1 - Initiate the http download request for the src URL
# Step 2 - Wait for the response from the server
# Step 3 - Create the dest directories as needed
# Step 4 - Write the response to the dest path
func download_file(src: String, dest: String) -> void:
# Step 1
	var http = HTTPRequest.new()
	add_child(http)
	
	var ret = http.request(src)
	if ret != 0: 
		http.queue_free()
		print("http request failed: ", ret)
		return
# Step 2
	var response = await http.request_completed
	if not(response[0] == 0 and response[1] == 200):
		http.queue_free()
		print("http request complete failed: ", response[0], ' ', response[1])
		return
# Step 3
	var content_dir = DirAccess.open("user://")
	content_dir.make_dir_recursive(dest.get_base_dir())
# Step 4
	var fa: FileAccess = FileAccess.open(dest, FileAccess.WRITE)
	fa.store_buffer(response[3])
	fa.close()
	
	
# Private Methods


# Subclasses

