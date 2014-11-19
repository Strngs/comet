Meteor.publish 'cometCollection', (collection) ->
	if Roles.userIsInRole @userId, ['superadmin', 'admin']
		global[collection].find()
	else
		@ready()

Meteor.publish 'cometAuxCollections', (collection) ->
	if Roles.userIsInRole @userId, ['superadmin', 'admin']
		if typeof CometConfig != 'undefined' and typeof CometConfig.collections[collection].auxCollections == 'object'
			subscriptions = []
			_.each CometConfig.collections[collection].auxCollections, (collection)->
				subscriptions.push global[collection].find()
			subscriptions
		else
			@ready()
	else
		@ready()

Meteor.publish 'cometAllCollections', ->
	if Roles.userIsInRole @userId, ['superadmin', 'admin']
		if typeof CometConfig != 'undefined'  and typeof CometConfig.collections == 'object'
			subscriptions = []
			_.map CometConfig.collections, (obj, key)->
				subscriptions.push global[key].find()
			subscriptions
	else
		@ready()

Meteor.publish 'cometUsers', ->
	if Roles.userIsInRole @userId, ['superadmin', 'admin']
		Meteor.users.find()
	else
		@ready()

Meteor.publish 'cometUser', ->
	Meteor.users.find @userId

Meteor.publish null, ->
	Meteor.roles.find({})