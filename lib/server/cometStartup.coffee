validateCometAdminUsers = (newUser, newUserId) ->
	throwErrors =
		configure: ->
			console.warn "[Comet]: Superadmin must be defined in Meteor settings file!"
		createAccount: ->
			console.warn "[Comet]: To utilize Comet, please create an account with the superAdmin email defined in your Meteor.settings"
		noAccountForThisUser: (email) ->
			console.warn "[Comet]: There is no account for the user with email: " + email
			console.warn "[Comet]: If this is intended, for security remove the email from Meteor.settings!"

	createSuperUsers =
		new: (newUser, newUserId) ->
			if !Roles.userIsInRole newUserId, 'superadmin'
				console.log "adding new user " + newUser + "(" + newUserId + ") to superadmin role"
				Roles.addUsersToRoles newUserId, 'superadmin'

		single: (email) ->
			superUser = Meteor.users.find({
				emails:
					$elemMatch:
						address: email
			}, {
				fields:
					_id: 1
			})

			if Meteor.users.find().count() == 0 || superUser.count() == 0
				throwErrors.createAccount();
				return true

			superUser = superUser.fetch()
			hasSuper = Roles.userIsInRole superUser[0]._id, 'superadmin'

			if hasSuper == false
				console.log "adding " + superEmail + "(" + superUser[0]._id + ") to superadmin role"
				Roles.addUsersToRoles superUser[0]._id, 'superadmin'

		multi: (emails) ->
			hasSuperUserAlready = false;

			if Meteor.users.find().count() == 0
				throwErrors.createAccount();
				return true

			_.each(emails, (element, index) ->
				superUser = Meteor.users.find({
					emails:
						$elemMatch:
							address: element
				}, {
					fields:
						_id: 1
				})

				if superUser.count() == 0
					throwErrors.noAccountForThisUser(element)
				else
					superUser = superUser.fetch()
					hasSuper = Roles.userIsInRole superUser[0]._id, 'superadmin'

					if hasSuper == false
						console.log "adding " + emails[index] + "(" + superUser[0]._id + ") to superadmin role"
						Roles.addUsersToRoles superUser[0]._id, 'superadmin'
						hasSuperUserAlready == true
					else
						hasSuperUserAlready == true
			)

	if typeof Meteor.settings != 'undefined' && typeof Meteor.settings.Comet != 'undefined' && typeof Meteor.settings.Comet.superadmin != 'undefined'
		superEmail = Meteor.settings.Comet.superadmin

		if typeof newUser != 'undefined'
			createSuperUsers.new(newUser, newUserId);
		else
			if _.isArray(superEmail)
				createSuperUsers.multi(superEmail);
			else
				createSuperUsers.single(superEmail);
	else
		throwErrors.configure();

	return true

Meteor.startup ->
	validateCometAdminUsers()

	Accounts.validateLoginAttempt (attempt) ->
		if attempt.allowed
			if typeof Meteor.settings.Comet.superadmin != 'undefined'
				userCheck = attempt.user
				if _.contains(Meteor.settings.Comet.superadmin, userCheck.emails[0].address)
					validateCometAdminUsers(userCheck.emails[0].address, userCheck._id)
			return true