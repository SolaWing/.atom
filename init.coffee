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
