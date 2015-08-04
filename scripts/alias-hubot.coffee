# Description:
#   Tell people Megatodd's new name if they use the old one
#
# Commands:
#   None
#
module.exports = (robot) ->
  robot.hear /^hubot:? (.+)/i, (res) ->
    response = "Sorry, I'm a diva and only respond to 'Hey you'"
    response += " or #{robot.alias}" if robot.alias
    res.reply response
    return
heys = ['hey, you', 'hey', 'hey you']

# If the robot "hears" anyone say "hey, you", even if it's not directed at the robot, it'll respond.
  robot.hear /heys/i, (res) ->
    res.send "You rang...?"    