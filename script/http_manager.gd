class_name HTTPManager 
extends Node



#region Description
# Handles all http requests
#endregion


#region signals, enums, constants, variables, and such

# signals

signal stats_updated (f_size: int, f_bytes: int)
signal download_completed

# enums

# constants

# exports (The following properties must be set in the Inspector by the designer)

# public variables

var content_config: Dictionary

# private variables

var http: HTTPRequest
var file_size: int
var bytes_downloaded: int
var file_name: String
var download_inprogress: bool

# onready variables

#endregion


# Virtual Godot methods

func _ready():
	download_inprogress = false
	
func _process(delta):
	if download_inprogress: 
		update_stats()
		stats_updated.emit(file_size, bytes_downloaded)
	


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
	
	content_config.clear()
	var ret = http.request(Constant.CONTENT_SERVER + "config.json")
	if ret != 0: 
		http.queue_free()
		return false
# Step 2
	var response = await http.request_completed
	if not(response[0] == 0 and response[1] == 200):
		http.queue_free()
		return true
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
func download_file(src: String, dest: String) -> bool:
# Step 1
	http = HTTPRequest.new()
	http.timeout = 0.0
	http.download_file = dest
	file_name = dest
	add_child(http)
	var headers: Dictionary
	
	var ret = http.request(src, ['Accept-Encoding: identity'], HTTPClient.METHOD_HEAD)
	if ret != 0:
		http.queue_free()
		print("HEAD request failed")
		return false
	var response = await http.request_completed
	headers = array_to_dictionary(response[2])
	file_size = int(headers["content-length"])
	
	ret = http.request(src)
	if ret != 0: 
		http.queue_free()
		print("http request failed: ", ret)
		return false

# Step 2
	download_inprogress = true
	response = await http.request_completed
	if not(response[0] == 0 and response[1] == 200):
		http.queue_free()
		print("http request complete failed: ", response[0], ' ', response[1])
		return false
	download_inprogress = false
	
	return true
	
	
# Private Methods

func array_to_dictionary(arr: Array, sep: String = ":", strip: bool = true) -> Dictionary:
	var stripval = " "
	if not strip:
		stripval = ""
	var ret: Dictionary = {}
	for item in arr:
		ret[item.get_slice(sep, 0)] = item.get_slice(sep, 1).lstrip(stripval)
	return ret
	
	
func update_stats() -> void:
	var error : int
	var _file = FileAccess.open(file_name, FileAccess.READ)
	error = FileAccess.get_open_error()

	if error == OK:
		bytes_downloaded  = _file.get_length()
		_file.close()

# Subclasses

