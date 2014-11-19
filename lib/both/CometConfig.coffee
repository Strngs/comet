CometGeneralConfig = new Mongo.Collection('cometGeneralConfig');
CometWidgetConfig = new Mongo.Collection('cometWidgetConfig');
CometAutoFormConfig = new Mongo.Collection('cometAutoFormConfig');
CometCollectionConfig = new Mongo.Collection('cometCollectionConfig');


###
 # Provides structure for general config page
 # @type {SimpleSchema}
###
CometDashboard.schemas.CometGeneralConfig = new SimpleSchema({
  cometTitle: {
    type: String
    , label: 'Admin Title'
    , optional: true
  }
  , cometOffline: {
    type: Boolean
    , label: 'Offline'
    , optional: true
  }
  , cometHomeRoute: {
    type: String
    , label: 'Home Route'
    , optional: true
  }
  , cometAutoFormConfig: {
    type: [String]
    , label: 'Autoform Options'
    , optional: true
  }
  , cometRedirectRoute: {
    type: String
    , label: 'Redirect unauthorized user to:'
    , optional: true
  }
});

###
 # Provide structure for widgets config page
 # @type {SimpleSchema}
###
CometDashboard.schemas.CometWidgetConfig = new SimpleSchema({
  widgetTitle: {
    type: String
    , label: 'Title'
    , optional: true
  }
  , widgetClass: {
    type: String
    , label: 'Classes'
    , optional: true
  }
  , widgetCollection: {
    type: String
    , label: 'Collection'
    , optional: true
  }
});

###
 # Provides simple dashboard to help customize AutoForm
 # @type {SimpleSchema}
###
CometDashboard.schemas.CometAutoFormConfig = new SimpleSchema({
  omitFields: {
    type: String
    , label: 'Omit Fields <small>Comma seperated</small>'
    , optional: true
  }
});

###
 # Provide structure for UI Definied Collections
 # @type {SimpleSchema}
###
CometDashboard.schemas.CometCollectionConfig = new SimpleSchema({
  collectionName: {
    type: String
    , label: 'Name'
    , optional: false
  }
  , collectionColumns: {
    type: Object
    , label: 'Columns'
    , optional: false
  }
  , weight: {
    type: Number
    , label: 'Weight'
    , optional: true
  }
  , icon: {
    type: String
    , label: 'Icon'
    , optional: true
  }
  , templates: {
    type: [Object]
    , label: 'Templates'
    , optional: true
  }
  , showWidget: {
    type: String
    , label: 'Show Widget on Dashboard?'
    , optional: true
  }
  , widgetColor: {
    type: String
    , label: 'Widget Color'
    , optional: true
  }
  , editable: {
    type: String
    , label: 'Editable'
    , optional: true
  }
  , deletable: {
    type: String
    , label: 'Deleteable'
    , optional: true
  }
});

CometGeneralConfig.attachSchema( CometDashboard.schemas.CometGeneralConfig );
CometWidgetConfig.attachSchema( CometDashboard.schemas.CometWidgetConfig );
CometAutoFormConfig.attachSchema( CometDashboard.schemas.CometAutoFormConfig );
CometCollectionConfig.attachSchema( CometDashboard.schemas.CometCollectionConfig );
