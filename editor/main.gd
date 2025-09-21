class_name App
extends Node

enum LogLevels {
	NONE,
	FATAL,
	ERR,
	WARN,
	INFO,
	DEBUG,
	TRACE
}

var is_verbose = false
var input_scene = ""
var output = ""

static var log_level = LogLevels.INFO

static func print(text: String):
	App.log(text, LogLevels.INFO)

static func log(text: String, level: LogLevels = LogLevels.INFO):
	if int(level) < int(log_level): return

	var log_name = LogLevels.keys()[level]
	var final = "[%s] %s" % [log_name, text]
	match level:
		LogLevels.WARN:
			print_rich("[color=yellow]%s[/color]" % [final])
		LogLevels.INFO:
			print_rich("[color=gray]%s[/color]" % [final])
		LogLevels.DEBUG:
			print_rich("[color=cyan]%s[/color]" % [final])
			print_stack()
		LogLevels.ERR:
			push_error(final)
		LogLevels.ERR:
			push_error(final)

func _ready():
	var args = OS.get_cmdline_args()

	var params = {}

	if args.size() <= 1:
		App.log("No command-line arguments provided.", LogLevels.INFO)
		get_tree().quit()
		return

	for i in range(1, args.size()):
		var arg = args[i]
		if arg.begins_with("--"):
			var val = args[i+1] if i < args.size() - 1 else null
			params.set(arg.substr(2, -1), val)
		elif arg.begins_with("-"):
			var val = args[i+1] if i < args.size() - 1 else null
			params.set(arg.substr(1, -1), val)
	
	print(str(params))
	get_tree().quit()
