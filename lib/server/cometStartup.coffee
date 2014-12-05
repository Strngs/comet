Meteor.startup ->
	if typeof Meteor.settings != 'undefined' && typeof Meteor.settings.Comet != 'undefined' && typeof Meteor.settings.Comet.superadmin != 'undefined'
		if Meteor.users.find().count() == 0
			console.warn "To utilize Comet, please create an account with the superAdmin email defined in your Meteor.settings"
			return

		superEmail = Meteor.settings.Comet.superadmin
		superUser = Meteor.users.find({
			emails:
				$elemMatch:
					address: superEmail
		}, {
			fields:
				_id: 1
		}).fetch()

		hasSuper = Roles.userIsInRole superUser[0]._id, 'superadmin'

		if hasSuper == false
			console.log "adding " + superEmail + "(" + superUser[0]._id + ") to superadmin role"
			Roles.addUsersToRoles superUser[0]._id, 'superadmin'
	else
		console.error "Comet requires that you define a superadmin in your Meteor settings file!"
