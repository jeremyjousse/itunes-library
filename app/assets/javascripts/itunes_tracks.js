var ready;

bindRatingHover = function() {
  console.log('bindRatingHover');
}

bindRatingClick = function() {
  console.log('bindRatingClick');
}

ready = function() {
  bindRatingHover();
  bindRatingClick();
};

$(document).ready(ready);

$(document).on('page:load', ready);
