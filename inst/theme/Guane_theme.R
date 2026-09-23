  guane_theme <- bs_theme(version = 5,bootswatch = "flatly", "form-group-margin-bottom"= "0.2rem",
                  "enable-rounded" = T) %>% bs_add_rules(
                    ".navbar.navbar-default {
  background-color: #0d5368 !important;
  --bs-navbar-brand-margin-end: 0rem;}


 .form-label, .shiny-input-container .control-label {
    margin-bottom: .5rem;
    margin-top: 0.5rem;
 }



.navbar-nav{
--bs-nav-link-hover-color: #88acb7;
}


.nav-tabs .nav-link.active, .nav-tabs ul.nav.navbar-nav > li > a.active, .nav-tabs > li > a.active, .nav-tabs .nav-pills > li > a.active, .nav-tabs .nav-link.active:focus, .nav-tabs .nav-link.active:hover, .nav-tabs .nav-item.open .nav-link, .nav-tabs ul.nav.navbar-nav > li.open:not(.dropdown) .nav-link, .nav-tabs > li.open .nav-link, .nav-tabs .nav-pills > li.open .nav-link, .nav-tabs .nav-item.open ul.nav.navbar-nav > li > a, .nav-tabs ul.nav.navbar-nav > li.open:not(.dropdown) ul.nav.navbar-nav > li > a, .nav-tabs > li.open ul.nav.navbar-nav > li > a, .nav-tabs .nav-pills > li.open ul.nav.navbar-nav > li > a, .nav-tabs .nav-item.open .nav-tabs > li > a, .nav-tabs ul.nav.navbar-nav > li.open:not(.dropdown) .nav-tabs > li > a, .nav-tabs > li.open .nav-tabs > li > a, .nav-tabs .nav-pills > li.open .nav-tabs > li > a, .nav-tabs .nav-item.open .nav-pills > li > a, .nav-tabs ul.nav.navbar-nav > li.open:not(.dropdown) .nav-pills > li > a, .nav-tabs > li.open .nav-pills > li > a, .nav-tabs .nav-pills > li.open .nav-pills > li > a, .nav-tabs .nav-item.open .nav-link:focus, .nav-tabs .nav-item.open .nav-link:hover {
	color: #139c8b;
}

.nav-link, .nav-tabs>li>a, .nav-pills>li>a, ul.nav.navbar-nav>li>a {
    color: #fff;
}


.nav-tabs .nav-link, .nav-tabs>li>a, .nav-tabs .nav-pills>li>a, .nav-tabs ul.nav.navbar-nav>li>a{
    background: #2c3e503d;
}

.navbar:not(.fixed-bottom):not(.navbar-fixed-bottom):not(.navbar-fixed-bottom) {
    margin-bottom: 10px;
}

.nav-tabs{
margin-bottom: 10px;
}

  ")
