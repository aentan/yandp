window.onload = function() {

  var menuItems = document.querySelectorAll(".menu li a");

  for (var i = 0; i < menuItems.length; i++) {
    menuItems[i].addEventListener("click", function(e) {
      e.preventDefault();
      document.querySelector(this.getAttribute('href')).scrollIntoView({ behavior: 'smooth' });
    });
  }

}