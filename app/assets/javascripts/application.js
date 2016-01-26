// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require select2
//= require raty/lib/jquery.raty
//= require_tree .


var ready;
ready = function() {

  $('#bt-play').bind('click', function() {tell_itunes_to_play();});
  $('#bt-next').bind('click', function() {tell_itunes_to_next();});
  $('#bt-previous').bind('click', function() {tell_itunes_to_previous();});
  $('#bt_update_library').bind('click', function() {update_library();});
  $('#bt_update_all_ratings').bind('click', function() {update_all_ratings();});

};

$(document).ready(ready);
$(document).on('page:load', ready);

function tell_itunes_to_play()
{
 $.ajax({url: $('#bt-play').attr("data-action"),success: function(data) {}});
}

function tell_itunes_to_next()
{
 $.ajax({url: $('#bt-next').attr("data-action"),success: function(data) {}});
}

function tell_itunes_to_previous()
{
 $.ajax({url: $('#bt-previous').attr("data-action"),success: function(data) {}});
}

function update_library()
{
 $.ajax({url: $('#bt_update_library').attr("data-action"),success: function(data) {}});
}

function update_all_ratings()
{
 $.ajax({url: $('#bt_update_all_ratings').attr("data-action"),success: function(data) {}});
}
