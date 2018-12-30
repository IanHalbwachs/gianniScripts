_ret, _track, _fx, _param = reaper.GetLastTouchedFX()

function checkLastTouchedFx()

  __ret, __track, __fx, __param = reaper.GetLastTouchedFX()
  
  while _track ~= __track or _fx ~= __fx or _param ~= __param do
    _track = __track
    _fx = __fx
    _param = __param
    if _track ~= 0 then
      ___val, ___min, __max = reaper.TrackFX_GetParam(reaper.GetTrack(0, _track-1), _fx, _param)
      reaper.StuffMIDIMessage(0, 190, 8, math.floor(___val * 127))
    end
  end

end

function main()

  checkLastTouchedFx()
  
  reaper.defer(main)

end

main()
