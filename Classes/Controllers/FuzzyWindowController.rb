# FuzzyWindowController.rb
# FuzzyWindow
#
# Created by Geoffrey Grosenbach on 3/16/10.
# Copyright 2010 Topfunky Corporation. All rights reserved.

class FuzzyWindowController < NSWindowController

  attr_accessor :tableViewController, :window, :searchField, :statusLabel

  def activate
    showWindow self
    tableViewController.selectFirstRow
    searchField.setStringValue("")
    window.makeFirstResponder(searchField)
    updateStatusLabel
  end

  def close
    window.close
  end

  ##
  # Called when text is entered into the search field.

  def didSearchForString(sender)
    tableViewController.searchForString(sender.stringValue)
    updateStatusLabel
  end

  def updateStatusLabel
    statusLabel.stringValue = "%i records" % [tableViewController.records.size]
  end

  ##
  # Handle Enter, arrows, and other events in search field.
  #
  # Returns true if this class handles it, false otherwise.

  def control(control, textView:textView, doCommandBySelector:commandSelector)
    case commandSelector
    when :"insertNewline:"
      handleNewline
      return true

    when :"moveUp:"
      tableViewController.selectPreviousRow
      return true

    when :"moveDown:"
      tableViewController.selectNextRow
      return true

    when :"cancel:"
      handleCancel
      return true
    end
    return false
  end

  def handleNewline
    tableViewController.handleRowClick(tableViewController.tableView.selectedRow)
    window.close
  end

  def handleCancel
    editorApplicationName =
      NSUserDefaults.standardUserDefaults.stringForKey('editorApplicationName')
    NSWorkspace.sharedWorkspace.launchApplication(editorApplicationName)
    window.close
  end

end

