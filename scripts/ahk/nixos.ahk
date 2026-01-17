;Arrows
repeat_every_ms = 50
repeat_delay_ms = 250

!w::
	Send, {Up}
	Sleep, %repeat_delay_ms%
	loop,
	{
		GetKeyState, w_state, w
		GetKeyState, lalt_state, LAlt
		if w_state = U
			break
		if lalt_state = U
			break
		Send, {Up}
		Sleep, %repeat_every_ms%
	}
	return

!s::
	Send, {Down}
	Sleep, %repeat_delay_ms%
	loop,
	{
		GetKeyState, s_state, s
		GetKeyState, lalt_state, LAlt
		if s_state = U
			break
		if lalt_state = U
			break
		Send, {Down}
		Sleep, %repeat_every_ms%
	}
	return

!a::
	Send, {Left}
	Sleep, %repeat_delay_ms%
	loop,
	{
		GetKeyState, a_state, a
		GetKeyState, lalt_state, LAlt
		if a_state = U
			break
		if lalt_state = U
			break
		Send, {Left}
		Sleep, %repeat_every_ms%
	}
	return


!d::
	Send, {Right}
	Sleep, %repeat_delay_ms%
	loop,
	{
		GetKeyState, d_state, d
		GetKeyState, lalt_state, LAlt
		if d_state = U
			break
		if lalt_state = U
			break
		Send, {Right}
		Sleep, %repeat_every_ms%
	}
	return

!space::Send, {Media_Play_Pause}
!j::Send, {Media_Next}
!l::Send, {Media_Prev}
!i::Send, {Volume_Up}
!k::Send, {Volume_Down}
