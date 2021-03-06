# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"

atom.commands.add 'atom-text-editor', 'user:open-in-vim', -> 
  if editor = atom.workspace.getActiveTextEditor()
    filePath = editor.getPath()
    require("child_process").exec "open -a MacVim.app '#{filePath}'"
    
atom.commands.add 'atom-text-editor', 'user:open-in-gitup', -> 
  if editor = atom.workspace.getActiveTextEditor()
    filePath = editor.getPath()
    
    {dirname} = require "path"
    if filePath and (d = dirname filePath)
      require('child_process').exec("cd '#{d}'; gitup commit")
    else
      atom.notifications.addError('Not in a git repository!')
    
# Objc bracket
smartBracket = (e) ->
  unless (editor = atom.workspace.getActiveTextEditor()) and !editor.hasMultipleCursors()
    return e.abortKeyBinding()
  p = editor.getCursorBufferPosition()
  return e.abortKeyBinding() unless p.column > 0
  
  line = editor.lineTextForBufferRow(p.row)
  if line[p.column] == ']' then c = 1
  else if line[p.column-1] == ']' then c = 0
  else return e.abortKeyBinding()
    
  type = c
  # console.log "type #{c}"
  editor.backwardsScanInBufferRange /[\[\]]/g, [[ ( if p.row > 20 then p.row - 20 else 0), 0], p], (it)->
    if it.matchText == ']' then ++c else --c
    # console.log it.matchText, it.range.start
    if c == 0
      it.stop()
      it.replace('[[')
      editor.moveLeft() if type == 0 # before ]
      editor.insertText '] '
  return e.abortKeyBinding() if c != 0
  
atom.commands.add "atom-text-editor[data-grammar~='objc']", 'user:smart-bracket', smartBracket
