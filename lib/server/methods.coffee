Meteor.methods
	cometInsertDoc: (doc,collection)->
		if Roles.userIsInRole this.userId, ['admin']
			Future = Npm.require('fibers/future');
			fut = new Future();

			global[collection].insert doc, (e,_id)->
				fut['return']( {e:e,_id:_id} )
			return fut.wait()

	cometUpdateDoc: (modifier,collection,_id)->
		if Roles.userIsInRole this.userId, ['admin']
			Future = Npm.require('fibers/future');
			fut = new Future();
			global[collection].update {_id:_id},modifier,(e,r)->
				fut['return']( {e:e,r:r} )
			return fut.wait()

	cometRemoveDoc: (collection,_id)->
		if Roles.userIsInRole this.userId, ['admin']
			if collection == 'Users'
				Meteor.users.remove {_id:_id}
			else
				global[collection].remove {_id:_id}


	cometNewUser: (doc) ->
		if Roles.userIsInRole this.userId, ['admin']
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
		if Roles.userIsInRole this.userId, ['admin']
			Future = Npm.require('fibers/future');
			fut = new Future();
			Meteor.users.update {_id:_id},modifier,(e,r)->
				fut['return']( {e:e,r:r} )
			return fut.wait()

	cometSendResetPasswordEmail: (doc)->
		if Roles.userIsInRole this.userId, ['admin']
			console.log 'Changing password for user ' + doc._id
			Accounts.sendResetPasswordEmail(doc._id)

	cometChangePassword: (doc)->
		if Roles.userIsInRole this.userId, ['admin']
			console.log 'Changing password for user ' + doc._id
			Accounts.setPassword(doc._id, doc.password)
			label: 'Email user their new password'

	cometCheckAdmin: ->
		if this.userId and !Roles.userIsInRole this.userId, ['admin']
			email = Meteor.users.findOne(_id:this.userId).emails[0].address
			if typeof CometConfig != 'undefined' and typeof CometConfig.cometEmails == 'object'
				cometEmails = CometConfig.adminEmails
				if cometEmails.indexOf(email) > -1
					console.log 'Adding admin user: ' + email
					Roles.addUsersToRoles this.userId, ['admin']
			else if this.userId == Meteor.users.findOne({},{sort:{createdAt:1}})._id
				console.log 'Making first user admin: ' + email
				Roles.addUsersToRoles this.userId, ['admin']

	cometAddUserToRole: (_id,role)->
		if Roles.userIsInRole this.userId, ['admin']
			Roles.addUsersToRoles _id, role
	cometRemoveUserToRole: (_id,role)->
		if Roles.userIsInRole this.userId, ['admin']
			Roles.removeUsersFromRoles _id, role