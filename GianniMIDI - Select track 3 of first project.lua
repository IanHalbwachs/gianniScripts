--select track 3 of first project tab

project = reaper.EnumProjects(0, '')

if not project then
  return
end

trackCount = reaper.CountTracks(project)

if trackCount == 0 then
  return
end

for i = 0, trackCount - 1 do 
  track = reaper.GetTrack(project, i)
  if i == 2 then
    reaper.SetTrackSelected(track, true)
  else
    reaper.SetTrackSelected(track, false)
  end
end
