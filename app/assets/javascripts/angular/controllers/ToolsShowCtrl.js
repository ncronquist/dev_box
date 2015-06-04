DevBox.controller( 'ToolsShowCtrl', [ '$scope' , '$resource', '$http', '$location', '$routeParams', '$rootScope',
 function( $scope, $resource, $http, $location, $routeParams, $rootScope ){
  $rootScope.isAuthenticated;
  // console.log('New Tools Ctrl Loaded');
  $scope.favorited = false;

  $scope.number = 5;
  $scope.getNumber = function(num) {
      return new Array(num);
  }

  $scope.addTool = function( toolId ){
    if ( $scope.tool.favorited === false ) {
      $http.post('/api/users/' + toolId + '/tool').success( function( data ){
        if (data.result === true){
          $scope.tool.favorited = true;
        }
      } )
    } else if ( $scope.tool.favorited === true ) {
      $http.delete( '/api/users/delete/tool/' + toolId ).success( function( data ){
        if (data.result === true){
          $scope.tool.favorited = false;
        }
      } )
    }
  }

  Tool = $resource('/api/tools/:id', null, {
    'update': { method:'PUT' }
  });


  var init = function(){
      Tool.get({id:$routeParams.id},function(data) {
        // $rootScope.loading = false;
        $scope.categories = data.navCats;
        $scope.tags = data.navTags;
        $scope.tool = data.result;
        console.log($scope.tags)
      },function(err){
        console.log(err);
      });
    }

    init()

}])
