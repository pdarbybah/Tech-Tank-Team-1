# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->

  NOTIFY_ROOM = process.env.HUBOT_STARTUP_ROOM ? 'Shell'
  MESSAGE = process.env.HUBOT_STARTUP_MESSAGE ? 'I AM BORN ANEW'

  robot.messageRoom NOTIFY_ROOM, MESSAGE

  robot.hear /set message (.*)/i, (res) ->
    MESSAGE = res[1]

  robot.respond /corgi me/i, (msg) ->
    msg.http("http://corginator.herokuapp.com/random")
      .get() (err, res, body) ->
        msg.send JSON.parse(body).corgi

  robot.respond /startup room/i, (res) ->
    res.send process.env.HUBOT_STARTUP_ROOM

  # If the robot "hears" anyone say badger, even if it's not directed at the robot, it'll respond.
  robot.hear /badger/i, (res) ->
    res.send "badger badger badger"

  # If someone is talking to the bot directly, it'll respond.
  robot.respond /hi!/i, (res) ->
    res.send "Hello!"

  # If someone enters the room.
  robot.enter (res) ->
    res.send "I SEE YOU"

  # If someone leaves the room.
  robot.leave (res) ->
    res.send "Now he can't hear me talk trash about him."

  displayChangeSet = (commit, res) ->
    res.send "#{commit.node} - #{commit.message}"
    res.send "( https://bitbucket.org/tutorials/tutorials.bitbucket.org/commits/#{commit.raw_node} )"
    
  robot.hear /last commit/i, (res) ->
    robot.http("https://bitbucket.org/api/1.0/repositories/tutorials/tutorials.bitbucket.org/changesets?limit=1")
      .get() (err, msg, body) ->
        if err
          res.send "Encountered Error: #{err}"
          return

        data = JSON.parse body
        commit = data.changesets[0]

        displayChangeSet(commit, res)
		
  robot.hear /last major issue/i, (res) ->
    robot.http("https://bitbucket.org/api/1.0/repositories/tutorials/tutorials.bitbucket.org/issues?limit=1&sort=utc_created_on&priority=major")
      .get() (err, msg, body) ->
        if err
          res.send "Encountered Error: #{err}"
          return

        data = JSON.parse body
        issue = data.issues[0]

        res.send "#{issue.title}"
        res.send "( https://bitbucket.org/tutorials/tutorials.bitbucket.org/issues/#{issue.local_id} )"

  robot.hear /recent commit by (.*)/i, (res) ->
    name = res.match[1]
    name = name.toLowerCase()
    robot.http("https://bitbucket.org/api/1.0/repositories/tutorials/tutorials.bitbucket.org/changesets?limit=50")
      .get() (err, msg, body) ->
        if err
          res.send "Encountered Error: #{err}"
          return

        data = JSON.parse body
        array = data.changesets
        array.reverse()
        for commit in array
          author = "#{commit.raw_author}"
          author = author.toLowerCase()
          index = author.indexOf "#{name}", 0
          if index > -1
            displayChangeSet(commit, res)
            return
        
        res.send "No recent commits by #{name}!"
        
  #
  # robot.respond /open the (.*) doors/i, (res) ->
  #   doorType = res.match[1]
  #   if doorType is "pod bay"
  #     res.reply "I'm afraid I can't let you do that."
  #   else
  #     res.reply "Opening #{doorType} doors"
  #
  # robot.hear /I like pie/i, (res) ->
  #   res.emote "makes a freshly baked pie"
  #
  # lulz = ['lol', 'rofl', 'lmao']
  #
  # robot.respond /lulz/i, (res) ->
  #   res.send res.random lulz
  #
  # robot.topic (res) ->
  #   res.send "#{res.message.text}? That's a Paddlin'"
  #
  #
  # enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
  # leaveReplies = ['Are you still there?', 'Target lost', 'Searching']
  #
  # robot.enter (res) ->
  #   res.send res.random enterReplies
  # robot.leave (res) ->
  #   res.send res.random leaveReplies
  #
  # answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING
  #
  # robot.respond /what is the answer to the ultimate question of life/, (res) ->
  #   unless answer?
  #     res.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
  #     return
  #   res.send "#{answer}, but what is the question?"
  #
  # robot.respond /you are a little slow/, (res) ->
  #   setTimeout () ->
  #     res.send "Who you calling 'slow'?"
  #   , 60 * 1000
  #
  #
  # robot.respond /unannoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "GUYS, GUYS, GUYS!"
  #     clearInterval(annoyIntervalId)
  #     annoyIntervalId = null
  #   else
  #     res.send "Not annoying you right now, am I?"
  #
  #
  # robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
  #   room   = req.params.room
  #   data   = JSON.parse req.body.payload
  #   secret = data.secret
  #
  #   robot.messageRoom room, "I have a secret: #{secret}"
  #
  #   res.send 'OK'
  #
  # robot.error (err, res) ->
  #   robot.logger.error "DOES NOT COMPUTE"
  #
  #   if res?
  #     res.reply "DOES NOT COMPUTE"
  #
  # robot.respond /have a soda/i, (res) ->
  #   # Get number of sodas had (coerced to a number).
  #   sodasHad = robot.brain.get('totalSodas') * 1 or 0
  #
  #   if sodasHad > 4
  #     res.reply "I'm too fizzy.."
  #
  #   else
  #     res.reply 'Sure!'
  #
  #     robot.brain.set 'totalSodas', sodasHad+1
  #
  # robot.respond /sleep it off/i, (res) ->
  #   robot.brain.set 'totalSodas', 0
  #   res.reply 'zzzzz'
