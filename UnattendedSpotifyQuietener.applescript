set delay_time to 1
set slowness_factor to 4 -- the larger the longer it takes to reduce volume to zero
set min_idle_time to 30 -- the period of time the user needs to be idle before beginning

repeat
	if application "Spotify" is running then
		log "Spotify is running"
		tell application "Spotify"
			set pState to player state
			if pState is playing then
				set r to random number from 0 to (100 * slowness_factor)
				set outputVolume to output volume of (get volume settings)
				if outputVolume = 0 then
					pause
					log "paused playback"
				else
					set idleTime to do shell script "ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {print int($NF/1000000000); exit}'"
					log r & "-" & outputVolume & "idle time:" & idleTime
					if r < outputVolume and idleTime > min_idle_time then
						set volume output volume (outputVolume - 1)
					end if
				end if
			else
				log "...but not playing"
			end if
		end tell
	end if
	
	delay delay_time
end repeat
