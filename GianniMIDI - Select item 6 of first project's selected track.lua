--select first item of selected track in first project

--position in track of item we're interested in
position = 5;

--get pointer to item we're interested in
firstProject = reaper.EnumProjects(0, '')
if not firstProject then
  return
end
trackCount = reaper.CountTracks(firstProject)
if trackCount == 0 then
  return
end
for i = 0, trackCount-1 do 
  track = reaper.GetTrack(firstProject, i)
  if reaper.IsTrackSelected(track) then
    selectedTrack = track
    break
  end
end
if not selectedTrack then
  return
end
itemToSelect = reaper.GetTrackMediaItem(selectedTrack, position)
if not itemToSelect then
  return
end

reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(100)

--deselect all items in first project
itemsInFirstProject = reaper.CountMediaItems(firstProject)
for i = 0, itemsInFirstProject-1 do
  reaper.SetMediaItemSelected(reaper.GetMediaItem(firstProject, i), false) 
end

--deselect all items in current project such that we can re-select them once we're done
selectedItems = {}
for i = 0, reaper.CountMediaItems(0)-1 do
  item = reaper.GetMediaItem(0, i)
  if reaper.IsMediaItemSelected(item) then
    table.insert(selectedItems, i)
    reaper.SetMediaItemSelected(item, false)
  end
end

--get reference to current project
currentProject = reaper.EnumProjects(-1, '')
--focus 1st project
reaper.SelectProjectInstance(reaper.GetItemProjectContext(itemToSelect))
--select item
reaper.SetMediaItemSelected(itemToSelect, true)
--copy item
reaper.Main_OnCommand(40698, 0)
-- focus current project
reaper.SelectProjectInstance(currentProject);
--insert file on current track at the end of the project
startTime, endTime = reaper.BR_GetArrangeView(0)
cursorPosition = reaper.GetCursorPosition()
endOfProject = reaper.GetProjectLength(0)
reaper.SetEditCurPos(endOfProject, false, false)
--paste item
reaper.Main_OnCommand(40058, 0)
--preview item
reaper.Main_OnCommand(reaper.NamedCommandLookup('_XENAKIOS_ITEMASPCM1'), 0)
--cut item
reaper.Main_OnCommand(40699, 0)
--restpre zoom & cursor
reaper.SetEditCurPos(cursorPosition, false, false)
reaper.BR_SetArrangeView(0, startTime, endTime)

-- reselect item & track in first project
reaper.SetMediaItemSelected(itemToSelect, true)
reaper.SetTrackSelected(selectedTrack, true)

-- reselect items in current project
for i = 1, #selectedItems do
  reaper.SetMediaItemSelected(reaper.GetMediaItem(0, selectedItems[i]), true)
end

reaper.PreventUIRefresh(-100)
reaper.Undo_EndBlock(-1, 0)
