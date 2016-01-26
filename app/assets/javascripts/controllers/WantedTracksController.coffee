controllers = angular.module('controllers')
controllers.controller("WantedTracksController", [ '$scope', '$routeParams', '$location', '$resource', '$http',
  ($scope,$routeParams,$location,$resource,$http)->
    getData = ->
      $http.get('/api/wanted_tracks?&page=' + $scope.currentPage).then (response) ->
        $scope.totalItems = response.data.meta.total_pages * 10
        angular.copy response.data.wanted_tracks, $scope.WantedTracks
        return
      return

    $scope.currentPage = 1
    $scope.WantedTracks = []
    getData()

    $scope.pageChanged = ->
      getData()
      return
])
