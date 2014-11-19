Template.CometSidebar.rendered = function () {
  $(".treeview").tree();

  $('.sidebar-offcanvas').hoverIntent({
    over: function() {
      if(!$(this).closest('.wrapper').hasClass('relative')) {
        $('.right-side').stop().animate({
          marginLeft: '220px'
        }, 200);
      }
    },
    out: function() {
      if(!$(this).closest('.wrapper').hasClass('relative')) {
        $('.right-side').stop().animate({
          marginLeft: '40px'
        }, 200);
      }
    }
  });

  $('.left-side, .right-side').eqheight();

};

Template.CometHeader.rendered = function () {
  var relativeToggle = function() {
    if ($(window).width() <= 992) {
      $('.row-offcanvas').toggleClass('active');
      $('.left-side').removeClass("collapse-left");
      $(".right-side").removeClass("strech");
      $('.row-offcanvas').toggleClass("relative");
    } else {
      //Else, enable content streching
      $('.left-side').toggleClass("collapse-left");
      $(".right-side").toggleClass("strech");
    }
  };

  $("[data-toggle='offcanvas']").click(function(e) {
    e.preventDefault();
    relativeToggle();
  });


};

Template.CometHeader.created = function() {
  var resetClasses = function() {
    if ($(window).width() > 992) {
      $('.row-offcanvas').removeClass('relative');
    }
  }
  , waiter = _.throttle(resetClasses, 200);

  $(window).resize(waiter);
}

Template.CometHeader.destroyed = function() {
  $(window).off('resize');
}

dataTableOptions = {
  "aaSorting": [],
  "bPaginate": true,
  "bLengthChange": false,
  "bFilter": true,
  "bSort": true,
  "bInfo": true,
  "bAutoWidth": false
}

Template.CometDashboardUsersView.rendered = function () {
  $('[data-toggle="tooltip"]').tooltip();
};

Template.CometDashboardView.rendered = function () {
};

Template.cometAdminLink.rednered = function() {
};

Template.cometAdminLinkSmall.rednered = function() {
};

(function($) {
  "use strict";

  $.fn.eqheight = function() {
    var maxheight = 0,
    $this = $(this);
    $this.each( function() {
      var height = $(this).innerHeight();
      if ( height > maxheight ) {
        maxheight = height;
      }
    });
    return $this.css('height', maxheight);
  };

  $(window).resize(function() {
    $('.left-side, .right-side').eqheight();
  });

  $.fn.tree = function() {

  return this.each(function() {
    var btn = $(this).children("a").first();
    var menu = $(this).children(".treeview-menu").first();
    var isActive = $(this).hasClass('active');

    //initialize already active menus
    if (isActive) {
        menu.show();
    }
    //Slide open or close the menu on link click
    btn.click(function(e) {
      e.preventDefault();
      if (isActive) {
        //Slide up to close menu
        menu.slideUp();
        isActive = false;
        btn.children(".fa-angle-down").first().removeClass("fa-angle-down").addClass("fa-angle-left");
        btn.parent("li").removeClass("active");
      } else {
        //Slide down to open menu
        menu.slideDown();
        isActive = true;
        btn.children(".fa-angle-left").first().removeClass("fa-angle-left").addClass("fa-angle-down");
        btn.parent("li").addClass("active");
      }
    });

  });
};
}(jQuery));