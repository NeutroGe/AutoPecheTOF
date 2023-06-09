#RequireAdmin

#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

HotKeySet ("{F6}", "stop")

$peche_started = 0

$array_curseur = 0
$array_rectangle = 0

$touches_neutralise = 0

$pos_curseur = 971
$pos_rectangle = 928
$pos_centre_rectangle = 928 + 35

$check_endu_poisson = 0

$timer = 0
$timer_started = 0

$timer_catch = 0
$timer_catch_started = 0


;paramétrage résolutions

if @DesktopWidth = 1920 AND @DesktopHeight = 1080 Then
	$bordure_gauche = 676
	$bordure_droite = 1246
	$bordure_hauteur = 83
	$pixel_endurance_x = 631
	$pixel_endurance_y = 117
	$bouton_canne_x = 1702
	$bouton_canne_y = 903
EndIf

if @DesktopWidth = 1680 AND @DesktopHeight = 1050 Then
	$bordure_gauche = 591
	$bordure_droite = 1091
	$bordure_hauteur = 72
	$pixel_endurance_x = 552
	$pixel_endurance_y = 102
	$bouton_canne_x = 1489
	$bouton_canne_y = 900
EndIf


While 1

	$time = Number(@HOUR & @MIN)

	;if $time > 1400 Then Shutdown(5) ;désactiver si besoin

		$array_curseur=Pixelsearch($bordure_gauche, $bordure_hauteur, $bordure_droite, $bordure_hauteur, 0xFFFFFF, 20) ; 1920x1080 réso

		$array_rectangle=Pixelsearch($bordure_gauche, $bordure_hauteur, $bordure_droite, $bordure_hauteur, 0xFFB040, 20)

		if IsArray($array_curseur) then

			$peche_started = 1

			$touches_neutralise = 0

			$pos_curseur=$array_curseur[0]

		Else

			$peche_started = 0

			;consolewrite("stop" & @CRLF)

		EndIf

		if IsArray($array_rectangle) Then

			$peche_started = 1

			$pos_rectangle=$array_rectangle[0]

			$pos_centre_rectangle = $pos_rectangle + 35

		Else

			$peche_started = 0

		Endif

		if $peche_started = 1 then

			;check endurance poisson

			if $timer_started = 0 Then

				$timer_started = 1

				$timer = TimerInit()

			EndIf

			;consolewrite(PixelGetColor($pixel_endurance_x, $pixel_endurance_y) & @CRLF)

			if  timerdiff($timer) > 5000 AND PixelGetColor($pixel_endurance_x, $pixel_endurance_y) = 4802889 then

				$timer_started = 0

				if $timer_catch_started = 0 Then

					$timer_catch = TimerInit()

					$timer_catch_started = 1

				endif

				if timerdiff($timer_catch) > 3000 Then

					$timer_catch_started = 0

					$timer_catch = 0

					$timer = 0

					$timer_started = 0

					MouseClick("left", $bouton_canne_x, $bouton_canne_y, 1, 0)

					sleep(3000)

					MouseClick("left", $bouton_canne_x, $bouton_canne_y, 1, 0)

					sleep(2500)

					MouseClick("left", $bouton_canne_x, $bouton_canne_y, 1, 0)

				EndIf

			EndIf

			if $pos_centre_rectangle + 10 < $pos_curseur Then

					Send("{d up}")
					Send("{a down}")
					Send("{q down}")

			elseif $pos_centre_rectangle - 10 > $pos_curseur Then

				Send("{a up}")
				Send("{q up}")
				Send("{d down}")

			Else

				Send("{d up}")
				Send("{a up}")
				Send("{q up}")

			EndIf

		Elseif $touches_neutralise = 0 Then

			$touches_neutralise = 1

			Send("{d up}")
			Send("{a up}")
			Send("{q up}")

		EndIf

		sleep(1)

WEnd


Func stop()

	Send("{d up}")
	Send("{a up}")
	Send("{q up}")

	Exit

EndFunc
