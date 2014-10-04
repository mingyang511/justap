BASE_URL = 'https://shining-fire-3470.firebaseio.com/'
#BASE_URL = 'https://fiery-fire-7775.firebaseio.com/'
_ = require 'lodash'


Firebase = require 'firebase'
myF = new Firebase BASE_URL

myF.child('users').on 'child_added', (snapshot) ->
  # add to pool
  myF.child('users').child(snapshot.name()).child('state').set('pool')
  myF.child('pool').push(snapshot.name())

myF.child('pool').on 'value', (snapshot) ->
  pool = snapshot.val()
  if not pool
    return
  matchedKeys = _.first (_.keys pool).sort(), 2
  if matchedKeys.length < 2
    return
  matchedVals = _.map matchedKeys, (key) -> pool[key]
  myF.child('pool').transaction (pool) ->
    delete pool[matchedKeys[0]]
    delete pool[matchedKeys[1]]
    pool
  o = {}
  o[matchedVals[0]] = score: 0
  o[matchedVals[1]] = score: 0
  match = (myF.child('match').push o).name()
  myF.child('users').child(matchedVals[0]).child('matches').child(match).set(match_id)
  myF.child('users').child(matchedVals[1]).child('matches').child(match).set(match_id)
  myF.child('users').child(matchedVals[0]).child('state').set('match')
  myF.child('users').child(matchedVals[1]).child('state').set('match')

# pool:
#   <pool_id>: <user_id>
#   <pool_id>: <user_id>
# matches:
#   <match_id>:
#     <user_id>:
#       score: 0
#     <user_id>:
#       score: 0
# users:
#   <user_id>:
#     state: pool | match
#     matches:
#       <match_id>: <match_id>
#       <match_id>: <match_id>
#   <user_id>:
#     ...

