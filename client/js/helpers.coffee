utils = {
	getTableCols: ->
		if typeof CometConfig != 'undefined' and typeof CometConfig.collections[Session.get 'comet_collection'] != 'undefined' and typeof CometConfig.collections[Session.get 'comet_collection'].tableColumns == 'object'
			cols = CometConfig.collections[Session.get 'comet_collection'].tableColumns
		else
			if Session.get('comet_collection') == 'Users'
				cols = CometDashboard.coreColumns.users
			else
				cols = [
					{title: 'ID', data: '_id'},
					{title: 'Title', data: 'title'},
					{title: 'Edit', data:'_id', render: CometDashboard.formatters.edit},
					{title: 'Delete', data:'_id', render: CometDashboard.formatters.del}
				]

		_.map cols, (entry) ->
			if typeof entry.title == 'undefined'
				entry.title = entry.label
			if typeof entry.data == 'undefined'
				entry.data = entry.name

		cols
}

UI.registerHelper 'CometConfig', ->
	CometConfig if typeof CometConfig != 'undefined'

UI.registerHelper 'comet_collections', ->
	if typeof CometConfig != 'undefined'  and typeof CometConfig.collections == 'object'
		_.map CometConfig.collections, (obj, key)->
			obj = _.extend obj, {name:key}
			obj = _.defaults obj, {label: key,icon:'plus',color:'blue'}

UI.registerHelper 'comet_collection', ->
	Session.get 'comet_collection'

UI.registerHelper 'comet_current_id', ->
	Session.get 'comet_id'

UI.registerHelper 'comet_current_doc', ->
	Session.get 'comet_doc'


UI.registerHelper 'comet_fields', ->
	if not Session.equals('comet_collection','Users') and typeof CometConfig != 'undefined' and typeof CometConfig.collections[Session.get 'comet_collection'].fields == 'object'
		x = CometConfig.collections[Session.get 'comet_collection'].fields
		console.log x
		x

UI.registerHelper 'comet_omit_fields', ->
	if typeof CometConfig.autoForm != 'undefined' and typeof CometConfig.autoForm.omitFields == 'object'
		global = CometConfig.autoForm.omitFields
	if not Session.equals('comet_collection','Users') and typeof CometConfig != 'undefined' and typeof CometConfig.collections[Session.get 'comet_collection'].omitFields == 'object'
		collection = CometConfig.collections[Session.get 'comet_collection'].omitFields
	if typeof global == 'object' and typeof collection == 'object'
		_.union global, collection
	else if typeof global == 'object'
		global
	else if typeof collection == 'object'
		collection

UI.registerHelper 'comet_table_columns', ->
	utils.getTableCols()

UI.registerHelper 'comet_table_value', (field,_id) ->
	if typeof field.collection == 'string' && typeof window[Session.get 'comet_collection'].findOne({_id:_id}) != 'undefined'
		aux_id = window[Session.get 'comet_collection'].findOne({_id:_id})[field.name]
		if field.collection == 'Users' and typeof Meteor.users.findOne({_id:aux_id}) != 'undefined'
			if typeof field.collection_property != 'undefined'
				aux_property = Meteor.users.findOne({_id:aux_id}).profile[field.collection_property]
			else
				aux_property = Meteor.users.findOne({_id:aux_id}).emails[0].address
			'<a class="btn btn-default btn-xs" href="/admin/' +  'users' + '/' + aux_id + '/edit">' + aux_property + '</a>'
		else if typeof field.collection_property == 'string' and typeof window[field.collection].findOne({_id:aux_id}) != 'undefined'
			aux_property = window[field.collection].findOne({_id:aux_id})[field.collection_property]
			'<a class="btn btn-default btn-xs" href="/admin/' +  field.collection + '/' + aux_id + '/edit">' + aux_property + '</a>'
	else if typeof window[Session.get 'comet_collection'] != 'undefined' and typeof window[Session.get 'comet_collection'].findOne({_id:_id}) != 'undefined'
		value = window[Session.get 'comet_collection'].findOne({_id:_id})[field.name]
		if typeof value == 'boolean' && value
			'<i class="fa fa-check"></i>'
		else
			value

UI.registerHelper 'CometSchemas', ->
	CometDashboard.schemas

UI.registerHelper 'cometGetSkin', ->
	if typeof CometConfig.dashboard != 'undefined' and typeof CometConfig.dashboard.skin == 'string'
		CometConfig.dashboard.skin
	else
		'black'

UI.registerHelper 'cometIsUserInRole', (_id,role)->
	Roles.userIsInRole _id, role

UI.registerHelper 'cometGetUsers', ->
	Meteor.users

UI.registerHelper 'cometUserSchemaExists', ->
	typeof Meteor.users._c2 == 'object'

UI.registerHelper 'cometCollectionLabel', (collection)->
	CometDashboard.collectionLabel(collection) if collection?

UI.registerHelper 'cometCollectionCount', (collection)->
	if collection == 'Users'
		Meteor.users.find().fetch().length
	else
		window[collection].find().fetch().length

UI.registerHelper 'cometTemplate', (collection,mode)->
	if collection.toLowerCase() != 'users' && typeof CometConfig.collections[collection].templates != 'undefined'
		CometConfig.collections[collection].templates[mode]

UI.registerHelper 'cometGetCollection', (collection)->
	CometConfig.collections[collection]

UI.registerHelper 'cometWidgets', ->
	if typeof CometConfig.dashboard != 'undefined' and typeof CometConfig.dashboard.widgets != 'undefined'
		CometConfig.dashboard.widgets

UI.registerHelper 'cometUserEmail', (user) ->
	CometDashboard.helpers.getUserEmail(user)

UI.registerHelper 'cometDataTableOpts', ->
	cols = utils.getTableCols()
	opts = _.extend dataTableOptions, { columns: cols }
	return opts

UI.registerHelper 'cometDataTableData', ->
	cols = utils.getTableCols()
	getFields = {}
	data = null

	_.map cols, (val, key, list) ->
		getFields[val.data] = 1

	if typeof Session.get 'comet_collection' != 'undefined'
		if Session.get('comet_collection') == 'Users'
			data = ->
				return (
					Meteor.users.find({}, {fields: getFields }).fetch()
				)
		else
			data = ->
				return (
					window[Session.get('comet_collection')].find({}, {fields: getFields }).fetch()
				)

		data
	else
		console.warn 'No Data'