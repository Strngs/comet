Router.map ->
  @route "cometDashboard",
    path: "/admin"
    template: "CometDashboard"
    layoutTemplate: "CometLayout"
    waitOn: ->
      [
        Meteor.subscribe 'cometUsers'
        Meteor.subscribe 'cometAllCollections'
        Meteor.subscribe 'cometUser'
      ]
    action: ->
      @render()
    onAfterAction: ->
      Session.set 'comet_title', 'Dashboard'
      Session.set 'comet_collection', ''
      Session.set 'comet_collection_page', ''

  @route "cometDashboardConfig",
    path: "/admin/config"
    template: "CometDashboardConfig"
    layoutTemplate: "CometLayout"
    waitOn: ->
      [
        Meteor.subscribe 'cometGeneralConfig'
        Meteor.subscribe 'cometWidgetConfig'
        Meteor.subscribe 'cometAutoFormConfig'
        Meteor.subscribe 'cometCollectionConfig'
        Meteor.subscribe 'cometUsers'
        Meteor.subscribe 'cometAllCollections'
        Meteor.subscribe 'cometUser'
      ]
    action: ->
      @render()
    onAfterAction: ->
      Session.set 'comet_title', 'Configure Comet'
      Session.set 'comet_collection', ''
      Session.set 'comet_collection_page', ''

  @route "cometDashboardUsersNew",
    path: "/admin/Users/new"
    template: "CometDashboardUsersNew"
    layoutTemplate: "CometLayout"
    waitOn: ->
      [
        Meteor.subscribe 'cometUsers'
        Meteor.subscribe 'cometUser'
      ]
    action: ->
      @render()
    onAfterAction: ->
      Session.set 'comet_title', 'Users'
      Session.set 'comet_subtitle', 'Create new user'
      Session.set 'comet_collection_page', 'New'
      Session.set 'comet_collection', 'Users'

  @route "cometDashboardUsersView",
    path: "/admin/Users/"
    template: "CometDashboardUsersView"
    layoutTemplate: "CometLayout"
    waitOn: ->
      [
        Meteor.subscribe 'cometUsers'
        Meteor.subscribe 'cometUser'
      ]
    data: -> { users : Meteor.users.find({},{sort: {createdAt: -1}}).fetch() }
    action: ->
      @render()
    onAfterAction: ->
      Session.set 'comet_title', 'Users'
      Session.set 'comet_subtitle', 'View users'
      Session.set 'comet_collection_page', ''
      Session.set 'comet_collection', 'Users'

  @route "cometDashboardUsersEdit",
    path: "/admin/Users/:_id/edit"
    template: "CometDashboardUsersEdit"
    layoutTemplate: "CometLayout"
    waitOn: ->
      [
        Meteor.subscribe 'cometUsers'
        Meteor.subscribe 'cometUser'
      ]
    data: ->
      user : Meteor.users.find({_id:@params._id}).fetch()
      roles: Roles.getRolesForUser @params._id
      otherRoles: _.difference _.map( Meteor.roles.find().fetch(), (role)-> role.name), Roles.getRolesForUser(@params._id)
    action: ->
      @render()
    onAfterAction: ->
      Session.set 'comet_title', 'Users'
      Session.set 'comet_subtitle', 'Edit user ' + @params._id
      Session.set 'comet_collection_page', 'edit'
      Session.set 'comet_collection', 'Users'
      Session.set 'comet_id', @params._id
      Session.set 'comet_doc', Meteor.users.findOne({_id:@params._id})

  @route "cometDashboardView",
    path: "/admin/collection/:collection/"
    template: "CometDashboardView"
    layoutTemplate: "CometLayout"
    waitOn: ->
      [
        Meteor.subscribe('cometCollection', @params.collection)
        Meteor.subscribe('cometAuxCollections', @params.collection)
        Meteor.subscribe('cometUsers'), Meteor.subscribe 'cometUser'
      ]
    data: -> { documents : window[ @params.collection ].find({},{sort: {createdAt: -1}}).fetch() }
    action: ->
      @render()
    onAfterAction: ->
      Session.set 'comet_title', CometDashboard.collectionLabel(@params.collection)
      Session.set 'comet_subtitle', 'View '
      Session.set 'comet_collection_page', ''
      Session.set 'comet_collection', @params.collection.charAt(0).toUpperCase() + @params.collection.slice(1)

  @route "cometDashboardNew",
    path: "/admin/collection/:collection/new"
    template: "CometDashboardNew"
    layoutTemplate: "CometLayout"
    waitOn: ->
      [
        Meteor.subscribe 'cometAuxCollections', @params.collection
        Meteor.subscribe 'cometUsers'
        Meteor.subscribe 'cometUser'
      ]
    action: ->
      @render()
    onAfterAction: ->
      Session.set 'comet_title', CometDashboard.collectionLabel(@params.collection)
      Session.set 'comet_subtitle', 'Create new'
      Session.set 'comet_collection_page', 'new'
      Session.set 'comet_collection', @params.collection.charAt(0).toUpperCase() + @params.collection.slice(1)

  @route "cometDashboardEdit",
    path: "/admin/collection/:collection/:_id/edit"
    template: "CometDashboardEdit"
    layoutTemplate: "CometLayout"
    waitOn: ->
      [
        Meteor.subscribe 'cometCollection', @params.collection
        Meteor.subscribe 'cometAuxCollections', @params.collection
        Meteor.subscribe 'cometUsers'
        Meteor.subscribe 'cometUser'
      ]
    action: ->
      @render()
    onAfterAction: ->
      Session.set 'comet_title', CometDashboard.collectionLabel(@params.collection)
      Session.set 'comet_subtitle', 'Edit ' + @params._id
      Session.set 'comet_collection_page', 'edit'
      Session.set 'comet_collection', @params.collection.charAt(0).toUpperCase() + @params.collection.slice(1)
      Session.set 'comet_id', @params._id
      Session.set 'comet_doc', window[@params.collection].findOne _id : @params._id

Router.onBeforeAction CometDashboard.checkAdmin, {only: CometDashboard.cometRoutes}
Router.onBeforeAction CometDashboard.clearAlerts, {only: CometDashboard.cometRoutes}