Meteor.methods
	cometInsertDoc: (doc,collection)->
		if Roles.userIsInRole this.userId, ['superadmin', 'admin']
			Future = Npm.require('fibers/future');
			fut = new Future();

			global[collection].insert doc, (e,_id)->
				fut['return']( {e:e,_id:_id} )
			return fut.wait()

	cometUpdateDoc: (modifier,collection,_id)->
		if Roles.userIsInRole this.userId, ['superadmin', 'admin']
			Future = Npm.require('fibers/future');
			fut = new Future();
			global[collection].update {_id:_id},modifier,(e,r)->
				fut['return']( {e:e,r:r} )
			return fut.wait()

	cometRemoveDoc: (collection,_id)->
		if Roles.userIsInRole this.userId, ['superadmin', 'admin']
			if collection == 'Users'
				Meteor.users.remove {_id:_id}
			else
				global[collection].remove {_id:_id}

	cometNewUser: (doc) ->
		if Roles.userIsInRole this.userId, ['superadmin', 'admin']
			emails = doc.email.split(',')
			_.each emails, (email)->
				user = {}
				user.email = email
				unless doc.chooseOwnPassword
					user.password = doc.password

				_id = Accounts.createUser user

				if doc.sendPassword && typeof CometConfig.fromEmail != 'undefined'
					Email.send(
						to: user.email
						from: CometConfig.fromEmail
						subject: 'Your accout has been created'
						html: 'You\'ve just had an account created for ' + Meteor.absoluteUrl() + ' with password ' + doc.password
						)

	cometUpdateUser: (modifier,_id)->
		if Roles.userIsInRole this.userId, ['superadmin', 'admin']
			Future = Npm.require('fibers/future');
			fut = new Future();
			Meteor.users.update {_id:_id},modifier,(e,r)->
				fut['return']( {e:e,r:r} )
			return fut.wait()

	cometSendResetPasswordEmail: (doc)->
		if Roles.userIsInRole this.userId, ['superadmin', 'admin']
			console.log 'Changing password for user ' + doc._id
			Accounts.sendResetPasswordEmail(doc._id)

	cometChangePassword: (doc)->
		if Roles.userIsInRole this.userId, ['superadmin', 'admin']
			console.log 'Changing password for user ' + doc._id
			Accounts.setPassword(doc._id, doc.password)
			label: 'Email user their new password'

	cometAddUserToRole: (_id,role)->
		if Roles.userIsInRole this.userId, ['superadmin', 'admin']
			if Roles.userIsInRole this.userId, ['admin'] and role == 'superadmin'
				Meteor.call 'cometThrowUserError', "error", "You do not have permission to do this"

			Roles.addUsersToRoles _id, role

	cometRemoveUserFromRole: (_id,role)->
		if Roles.userIsInRole this.userId, ['superadmin', 'admin']
			if Roles.userIsInRole this.userId, ['admin']
				targetUser = Meteor.users.find(_id, {fields: {_id: 1}})
				if Roles.userIsInRole targetUser[0]._id, ['superadmin']
					Meteor.call 'cometThrowUserError', "error", "You do not have permission to do this"
					return
			Roles.removeUsersFromRoles _id, role

	cometThrowUserError: (type, text) ->
		console[type] text

	cometUpdateGeneralConfig: () ->
		console.log arguments