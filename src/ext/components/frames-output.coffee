H2O.FramesOutput = (_, _frames) ->
  toSize = (bytes) ->
    sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB']
    return '0 Byte' if bytes is 0
    i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)))
    Math.round(bytes / Math.pow(1024, i), 2) + sizes[i]

  createFrameView = (frame) ->
    columnLabels = head (map frame.columns, (column) -> column.label), 15
    description = 'Columns: ' + (columnLabels.join ', ') + if frame.columns.length > columnLabels.length then "... (#{frame.columns.length - columnLabels.length} more columns)" else ''

    key: frame.key.name
    description: description
    size: toSize frame.byteSize
    rowCount: frame.rows
    columnCount: frame.columns.length
    isText: frame.isText
    inspect: -> 
      if frame.isText
        _.insertAndExecuteCell 'cs', "setupParse [ #{stringify frame.key.name } ]"
      else
        _.insertAndExecuteCell 'cs', "getFrame #{stringify frame.key.name}"

  importFiles = ->
    _.insertAndExecuteCell 'cs', 'importFiles'

  frameViews: map _frames, createFrameView
  hasFrames: _frames.length > 0
  importFiles: importFiles
  template: 'flow-frames-output'
