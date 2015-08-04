module.exports = (robot) ->

	robot.hear /github/i, (res) ->
		res.send $.get 'https://api.github.com/users/octocat/orgs'