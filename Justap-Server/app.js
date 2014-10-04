// Generated by CoffeeScript 1.8.0
(function() {
  var BASE_URL, Firebase, myF, _;

  BASE_URL = 'https://fiery-fire-7775.firebaseio.com/';

  _ = require('lodash');

  Firebase = require('firebase');

  myF = new Firebase(BASE_URL);

  myF.child('users').on('child_added', function(snapshot) {
    myF.child('users').child(snapshot.name()).child('state').set('pool');
    return myF.child('pool').push(snapshot.name());
  });

  myF.child('pool').on('value', function(snapshot) {
    var match, matchedKeys, matchedVals, o, pool;
    pool = snapshot.val();
    if (!pool) {
      return;
    }
    matchedKeys = _.first((_.keys(pool)).sort(), 2);
    if (matchedKeys.length < 2) {
      return;
    }
    matchedVals = _.map(matchedKeys, function(key) {
      return pool[key];
    });
    myF.child('pool').transaction(function(pool) {
      delete pool[matchedKeys[0]];
      delete pool[matchedKeys[1]];
      return pool;
    });
    o = {};
    o[matchedVals[0]] = {
      score: 0
    };
    o[matchedVals[1]] = {
      score: 0
    };
    match = (myF.child('matches').push(o)).name();
    myF.child('users').child(matchedVals[0]).child('matches').child(match).set(match);
    myF.child('users').child(matchedVals[1]).child('matches').child(match).set(match);
    myF.child('users').child(matchedVals[0]).child('state').set('match');
    return myF.child('users').child(matchedVals[1]).child('state').set('match');
  });

}).call(this);
