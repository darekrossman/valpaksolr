angular.module('app.filters', [])

  .filter('titleCase', () ->
    return (input) ->
      n = []
      for word in input.split(' ')
        n.push(word.substr(0,1).toUpperCase() + word.substr(1).toLowerCase())
      return n.join(' ')
  )