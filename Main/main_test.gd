extends Node2D

var API_KEY: String = "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" # Replace with your actual API key
var API_URL = "https://api.openai.com/v1/chat/completions"
var request_counter: int = 0

@onready var http_request: HTTPRequest = $HTTPRequest

func _ready():
	# Connect the request_completed signal to handle responses
	http_request.request_completed.connect(_on_request_completed)

	# Access the API key from the environment variable

	# Send a simple request to OpenAI
	send_simple_request("Hello! What's your name?")

func send_simple_request(prompt):
	request_counter += 1
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + API_KEY
	]

	# Create the request payload as a Dictionary
	var data = {
		"model": "gpt-3.5-turbo",  # Use "gpt-4" if desired
		"messages": [
			{"role": "user", "content": prompt}
		]
	}

	# Serialize the Dictionary to JSON
	var json_data = JSON.stringify(data)
	# Send the HTTP request with the JSON payload
	var error = http_request.request(API_URL, headers, HTTPClient.METHOD_POST, json_data)

	if error != OK:
		print("Error sending request: ", error)

# Handle the API response
func _on_request_completed(result, response_code, headers, body):
	print("the amount of requests sent: ", request_counter)
	var json = JSON.new()
	if response_code == 200:
		# Parse the JSON response body
		var response = json.parse(body.get_string_from_utf8())
		if response.error == OK:
			var message = response.result["choices"][0]["message"]["content"]
			print("Response: ", message)
		else:
			print("JSON Parse Error: ", response.error_string)
	else:
		print("Request failed with response code: ", response_code)
