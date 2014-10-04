'use strict';

var baseUrl = 'https://shining-fire-3470.firebaseio.com/';
var Firebase = require('firebase');
var baseFirebaseRef = new Firebase(baseUrl);
var matchesFirebaseRef = new Firebase(baseUrl + 'matches');
var _ = require('lodash');

baseFirebaseRef.child('pool').on('value', function(snapshot) {
	var val = snapshot.val();
	if (val !== null) {
		var keys = _.keys(val);
		if (keys.length >= 2) {
			var chosenKeys = _.sample(keys, 2);
			var matchesValue = {};
			_.forEach(chosenKeys, function(key) {
				// Remove from users pool
				console.log('Removing ' + key);
				var urlToRemove = baseUrl + 'pool/' + key;
				(new Firebase(urlToRemove)).remove();
				matchesValue[key] = val[key];
			});

			// Create a new match and add both users to the match
			var newMatchFirebaseRef = matchesFirebaseRef.push();
			newMatchFirebaseRef.child('users').set(matchesValue);
			newMatchFirebaseRef.child('score').set(0);
			newMatchFirebaseRef.child('foobar').set("foo");
		}
	}
});

