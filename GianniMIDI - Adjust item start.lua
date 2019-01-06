_,_,_,_,_,_, val = reaper.get_action_context()
-- reaper.ShowConsoleMsg(val)

viewStart, viewEnd = reaper.BR_GetArrangeView(0)
delta = (val > 0 and 1 or -1) * (viewEnd - viewStart) / 400

--get first visible selected item
selectedItem = nil
for i = 0, reaper.CountMediaItems(0)-1 do
  item = reaper.GetMediaItem(0, i)
  if reaper.IsMediaItemSelected(item) and not selectedItem then
    track = reaper.GetMediaItem_Track(item)
    if reaper.IsTrackVisible(track, false) then -- false -> TCP
      itemStart = reaper.GetMediaItemInfo_Value(item, 'D_POSITION')
      itemLength = reaper.GetMediaItemInfo_Value(item, 'D_LENGTH')
      if itemStart >= viewStart and itemStart <= viewEnd then
        selectedItem = item
        take = reaper.GetTake(item, 0)
        itemOffset = reaper.GetMediaItemTakeInfo_Value(take, 'D_STARTOFFS')
        source = reaper.GetMediaItemTake_Source(take)
        sourceLength = reaper.GetMediaSourceLength(source)
        sourceStart = itemStart - itemOffset
      end
    end
  end
end

if not selectedItem then
  return
end

newStart = itemStart + delta
if newStart < sourceStart then
  newStart = sourceStart
  newOffset = 0
  newLength = (itemStart - sourceStart) + itemLength
else 
  newOffset = itemOffset + delta
  newLength = itemLength - delta
end

if newLength > 0.001 then
  reaper.SetMediaItemTakeInfo_Value(take, 'D_STARTOFFS', newOffset)
  reaper.SetMediaItemInfo_Value(selectedItem, 'D_POSITION', newStart)
  reaper.SetMediaItemInfo_Value(selectedItem, 'D_LENGTH', newLength)
end

reaper.UpdateArrange()
