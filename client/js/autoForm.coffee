AutoForm.hooks
	comet_insert:
		onSubmit: (insertDoc, updateDoc, currentDoc)->
			Meteor.call 'cometInsertDoc', insertDoc, Session.get('comet_collection'), (e,r)->
				if e
					CometDashboard.alertFailure 'Error: ' + e
				else
					$('.btn-primary').removeClass('disabled')
					AutoForm.resetForm('comet_insert')
					Router.go '/admin/' + Session.get('comet_collection')
					CometDashboard.alertSuccess 'Successfully created'
			false
		beginSubmit: (formId, template)->
			$('.btn-primary').addClass('disabled')
		onError: (operation, error, template)->
			CometDashboard.alertFailure error.message

	comet_update:
		onSubmit: (insertDoc, updateDoc, currentDoc)->
			Meteor.call 'cometUpdateDoc', updateDoc, Session.get('comet_collection'), Session.get('comet_id'), (e,r)->
				if e
					console.log e
					CometDashboard.alertFailure 'Error: ' + e
				else
					CometDashboard.alertSuccess 'Updated'
					$('.btn-primary').removeClass('disabled')
					AutoForm.resetForm('comet_insert')
					$('.btn-primary').removeClass('disabled')
					Router.go '/admin/' + Session.get('comet_collection')
			false
		beginSubmit: (formId, template)->
			$('.btn-primary').addClass('disabled')
		onError: (operation, error, template)->
			CometDashboard.alertFailure error.message

	cometNewUser:
		onSuccess: (operation, result, template)->
			Router.go 'cometDashboardUsersView'
		onError: (operation, error, template)->
			CometDashboard.alertFailure error.message

	comet_update_user:
		onSubmit: (insertDoc, updateDoc, currentDoc)->
			Meteor.call 'cometUpdateUser', updateDoc, Session.get('comet_id'), (e,r)->
				$('.btn-primary').removeClass('disabled')
			false
		onError: (operation, error, template)->
			CometDashboard.alertFailure error.message

	cometSendResetPasswordEmail:
		onSuccess: (operation, result, template)->
			CometDashboard.alertSuccess 'Email Sent'
		onError: (operation, error, template)->
			CometDashboard.alertFailure error.message

	cometChangePassword:
		onSuccess: (operation, result, template)->
			CometDashboard.alertSuccess 'Password reset'
		onError: (operation, error, template)->
			CometDashboard.alertFailure error.message
