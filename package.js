/**
 * Comet - Highly extensible Meteor admin
 * Forked from: https://github.com/yogiben/meteor-admin/ @1.0.4
 * Special thanks to @yogiben for laying a solid foundation to build on
 */

Package.describe({
  name: "strngs:comet",
  summary: "A highly extensible admin interface for meteor",
  version: "1.0.3",
  git: "https://github.com/Strngs/comet"
});

Package.on_use(function(api){
  both = ['client','server']

  api.versionsFrom('1.0');

  api.use([
    'iron:router@1.0.0',
    'zimme:iron-router-active@1.0.1',
    'coffeescript',
    'accounts-base',
    'accounts-password',
    'underscore',
    'aldeed:collection2@2.2.0',
    'aldeed:autoform@4.0.0',
    'alanning:roles@1.2.13',
    'raix:handlebar-helpers@0.1.3',
    'ephemer:reactive-datatables@1.0.1',
    'mrt:moment@2.8.1'
  ], both);

  api.use(['less','session','jquery','templating'],'client')

  api.use(['email'],'server')

  api.add_files([
    'lib/both/CometDashboard.coffee',
    'lib/both/CometConfig.coffee',
    'lib/both/router.coffee'
  ], both);

  api.add_files([
    'client/html/comet_templates.html',
    'client/html/comet_widgets.html',
    'client/html/comet_layouts.html',
    'client/html/comet_sidebar.html',
    'client/html/comet_header.html',
    'client/css/comet-layout.less',
    'client/css/comet-custom.less',
    'lib/client/slim_scroll.js',
    'lib/client/jquery.hoverIntent.minified.js',
    'client/js/comet_layout.js',
    'client/js/helpers.coffee',
    'client/js/events.coffee',
    'client/js/autoForm.coffee',
    'lib/client/bootstrap-datatables/css/bootstrap-datatables.css',
    'lib/client/bootstrap-datatables/js/bootstrap-datatables.js',
    'lib/client/bootstrap-datatables/images/sort_asc_disabled.png',
    'lib/client/bootstrap-datatables/images/sort_asc.png',
    'lib/client/bootstrap-datatables/images/sort_both.png',
    'lib/client/bootstrap-datatables/images/sort_desc_disabled.png',
    'lib/client/bootstrap-datatables/images/sort_desc.png'
    ], 'client');

  api.add_files([
    'lib/server/cometStartup.coffee',
    'server/publish.coffee',
    'server/methods.coffee'
  ], 'server');

  api.export('CometDashboard',both)
});
