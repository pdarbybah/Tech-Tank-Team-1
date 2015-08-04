module.exports = (robot) ->
#	robot.hear /^hubot:? (.+)/i, (res) ->
#		response = "Sorry, I'm a diva and only respond to 'Hey you'"
#		res.reply response

	# If the robot "hears" anyone say "hey, you", even if it's not directed at the robot, it'll respond.
	heys = ['hey, you', 'hey', 'hey you']
	robot.hear /heys/i, (res) ->
		res.send "You rang...?"    