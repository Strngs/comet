Template.CometLayout.events
	'click .btn-delete': (e,t) ->
		_id = $(e.target).attr('doc')
		Session.set 'comet_id', _id
		if Session.equals 'comet_collection', 'Users'
			Session.set 'comet_doc', Meteor.users.findOne( _id:_id )
		else
			Session.set 'comet_doc', window[Session.get 'comet_collection'].findOne( _id:_id )

Template.CometDeleteModal.events
	'click #confirm-delete': () ->
		collection = Session.get 'comet_collection'
		_id = Session.get 'comet_id'
		Meteor.call 'cometRemoveDoc', collection, _id, (e,r)->
			$('#admin-delete-modal').modal('hide')

Template.CometDashboardUsersEdit.events
	'click .btn-add-role': (e,t) ->
		console.log 'adding user'
		Meteor.call 'cometAddUserToRole', $(e.target).attr('user'), $(e.target).attr('role')
	'click .btn-remove-role': (e,t) ->
		console.log 'removing user'
		Meteor.call 'cometRemoveUserToRole', $(e.target).attr('user'), $(e.target).attr('role')

Template.CometHeader.events
	'click .btn-sign-out': () ->
		Meteor.logout ->
			Router.go('/')