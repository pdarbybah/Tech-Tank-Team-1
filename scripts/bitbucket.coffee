module.exports = (robot) ->
	robot.hear /last commmit/i, (res) ->
		res.send "The last commit was:"