$.widget 'vp.googlemap',
  options:
    zoom: 4
    mapTypeId: google.maps.MapTypeId.ROADMAP
    locations: []
    width: '300px'
    height: '300px'
    widgetClassName: 'vp-googlemap'
    onMapClick: () -> @
    onLocationAdded: () -> @
  widgetEventPrefix: 'googlemap:'
  map: null


  # Private Methods
  # ----------------------------------------
  _create: ->
    @.element.addClass @options.widgetClassName
    @.element.on 'googlemap:locationadded', (event, data) =>
      @options.onLocationAdded(data, @)
    @._initMap()


  _destroy: ->
    this.element.removeClass @options.widgetClassName


  _setOption: (key, value) ->
    prev = this.options[key]
    fnMap =
      'center': => setMapCenter(value, this)
      'width': => setMapSize('width', value, this)
      'height': => setMapSize('height', value, this)
    this._super(key, value);
    if fnMap[key]?
      fnMap[key]()
      this._triggerOptionChanged(key, prev, value)


  _triggerOptionChanged: (optionKey, previousValue, currentValue) ->
    this._trigger 'setoption', type: 'setoption',
      option: optionKey
      previous: previousValue
      current: currentValue


  _initMap: ->
    @._addLocationToMap loc for loc in @options.locations                             # create map locations w/ latlong
    gmapOptions =
      center: @options.primaryLocation?.latlong || new google.maps.LatLng(40.76104083532429, -73.97850036621094)
      mapTypeId: @options.mapTypeId
      zoom: @options.zoom
    @map = new google.maps.Map(@.element[0], gmapOptions)                             # initialize map
    @._addLocationMarker loc for loc in @options.locations                            # add markers for each location
    @._setOptions
      'width': @options.width
      'height': @options.height
    google.maps.event.addListener @map, 'click', (event) =>
      @options.onMapClick(event, @)


  _addLocationToMap: (loc) ->
    loc.latlong = new google.maps.LatLng(loc.lat, loc.lon)
    @options.primaryLocation = loc if loc.primary
    @._addLocationMarker(loc)
    @._trigger('locationAdded', type: 'locationAdded', loc)


  _addLocationMarker: (loc) ->
    loc.marker = new google.maps.Marker
      position: loc.latlong
      map: @map
      # animation: google.maps.Animation.DROP
    if @.options.overlay?.trigger?
      @map.infoWindow = new google.maps.InfoWindow()
      google.maps.event.addListener loc.marker, @options.overlay.trigger, () ->
        @map.infoWindow.setContent(loc.overlayContent)
        @map.infoWindow.open(@map, loc.marker)


  # Public Methods
  # ----------------------------------------
  addLocation: (loc) ->
    for l in @options.locations
      if loc.lat == l.lat and loc.lon == l.lon
        return false
    @options.locations.push(loc)
    @._addLocationToMap(loc)



  getMap: -> @map


# ----------------------------------------
# end widget


# Static Helpers
# ----------------------------------------
setMapCenter = (latlong, widget, animated) ->
  # if !animated
  #   widget.map.setCenter(latlong)
  # else
    widget.map.panTo(latlong)

setMapSize = (dimension, size, widget) ->
  o = widget.option()
  widget.element.css(dimension, size)
  widget.option('center', widget.getMap().getCenter())



