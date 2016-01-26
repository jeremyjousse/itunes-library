receta = angular.module('itunesTracks',[
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
  # 'angular-flash.service',
  # 'angular-flash.flash-alert-directive'
])

# receta.config([ '$routeProvider', 'flashProvider',
#   ($routeProvider,flashProvider)->
receta.config([ '$routeProvider',
  ($routeProvider)->

    # flashProvider.errorClassnames.push("alert-danger")
    # flashProvider.warnClassnames.push("alert-warning")
    # flashProvider.infoClassnames.push("alert-info")
    # flashProvider.successClassnames.push("alert-success")

    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'IndexController'
      ).when('/wanted_tracks',
        templateUrl: "wanted_tracks/index.html"
        controller: 'WantedTracksController'
      )
])

controllers = angular.module('controllers',[])
