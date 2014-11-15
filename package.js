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
    'lib/both/router.coffee'
  ], both);

  api.add_files([
    'lib/client/html/comet_templates.html',
    'lib/client/html/comet_widgets.html',
    'lib/client/html/comet_layouts.html',
    'lib/client/html/comet_sidebar.html',
    'lib/client/html/comet_header.html',
    'lib/client/css/comet-layout.less',
    'lib/client/css/comet-custom.less',
    'lib/client/lib/slim_scroll.js',
    'lib/client/lib/jquery.hoverIntent.minified.js',
    'lib/client/js/comet_layout.js',
    'lib/client/js/helpers.coffee',
    'lib/client/js/events.coffee',
    'lib/client/js/autoForm.coffee',
    'lib/client/lib/bootstrap-datatables/css/bootstrap-datatables.css',
    'lib/client/lib/bootstrap-datatables/js/bootstrap-datatables.js',
    'lib/client/lib/bootstrap-datatables/images/sort_asc_disabled.png',
    'lib/client/lib/bootstrap-datatables/images/sort_asc.png',
    'lib/client/lib/bootstrap-datatables/images/sort_both.png',
    'lib/client/lib/bootstrap-datatables/images/sort_desc_disabled.png',
    'lib/client/lib/bootstrap-datatables/images/sort_desc.png'
    ], 'client');

  api.add_files([
    'lib/server/publish.coffee',
    'lib/server/methods.coffee'
  ], 'server');

  api.export('CometDashboard',both)
});
