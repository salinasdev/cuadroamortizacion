#DECLARAMOS VARIABLES GLOBALES
$global:forma    		 = $null
$global:plazo    	 	 = $null
$global:tipo     		 = $null
$global:pcapital         = @()
$global:pinteres         = @()
$global:pendiente        = @()
[double]$global:cround   = $null
[double]$global:divok1   = $null
[double]$global:divok2   = $null
[double]$global:cuota    = $null
[double]$global:tipoefec = $null
[double]$global:tipo12   = $null
[double]$global:interes  = $null
$global:i                = $null
$global:j                = $null
[double]$global:inttotal = $null
[double]$global:pend        = $null
[double]$global:amor        = $null
[double]$global:pagototal   = $null
    


#DECLARAMOS LAS FUNCIONES
function menu() {
	while($opcion -eq "N" -or $opcion -eq "n")  {
		cls
		$global:forma = read-host "Escribe el formalizado"
		$global:plazo = read-host "Escribe el plazo (meses)"
		$global:tipo  = read-host "Escribe el tipo(Ej: 1.23)"

		echo "formalizado $forma , plazo $plazo , tipo $tipo"
		$opcion  = read-host "Son correctos los datos? (S o N)"
	}
}
function calculos(){
	cls
    #CALCULAMOS LA CUOTA BASE
    [double]$global:tipo12    = ($tipo / 12) / 100
    [double]$global:tipoefec  = ([math]::Pow((1 + $tipo),$tipo12)) - 1

    [double]$global:divok1    = $tipo12 * ([math]::Pow((1 + $tipo12),$plazo))
    [double]$global:divok2    = ([math]::Pow((1 + $tipo12),$plazo)) - 1
    [double]$global:cuota     = ($divok1 / $divok2) * ($forma)
    [double]$global:cround    = [math]::round($cuota,2)

    #CALCULAMOS LOS INTERESES 

    $pend = $forma
    $inttotal = 0
    for ($i=0 ; $i -lt $plazo; $i++)
    {
        #Guardamos la liquidacion
        [double]$global:interes   = (30 * $pend * $tipo) / 36000
        [double]$global:iround    = [math]::round($interes,10)
        $global:pinteres += [math]::round($interes,2)
        $inttotal = $inttotal + $iround


        #Guardamos la amortizacion
        $amor = $cuota - $interes
        $global:pcapital += [math]::round($amor,2)

        #Guardamos el pendiente
        $pend = $pend - $amor
        $global:pendiente += [math]::round($pend,2)

    }
    #Redondeamos a 2 decimales para el resumen
    $inttotal = [math]::round($inttotal,2)
    $pagototal = [double]$forma + [double]$inttotal

    $resumenCapital = "Capital = $forma euros."
    $resumenIntereses = "Interes = $tipo%."
    $resumenPlazo = "Plazo   = $plazo meses."

    $resumenMensual = "Pago mensual = $("{0:N2}" -f $cround)."
    $resumenIntTotal = "Intereses    = $("{0:N2}" -f $inttotal)."
    $resumenPagoTotal = "Pago total   =  $("{0:N2}" -f $pagototal)."
    
    Write-Host "****************************************************************"
    Write-Host "**************    Calculo by Victor Salinas    *****************"
    Write-Host "****************************************************************"

    Write-Host $resumenCapital (" " * (36 -  $resumenCapital.tostring().length)) $resumenMensual
    Write-Host $resumenIntereses (" " * (36 -  $resumenIntereses.tostring().length)) $resumenIntTotal
    Write-Host $resumenPlazo (" " * (36 -  $resumenPlazo.tostring().length)) $resumenPagoTotal

    Write-Host "****************************************************************"
    Write-Host "Mes         Pendiente       Capital        Intereses      Cuota "
    Write-Host "****************************************************************"
    for ($i=0 ; $i -lt $plazo; $i++)
    {
        #Informamos el numero de meses
        $j = $i + 1 
	

	
        #Dejamos bonito el espacio1
        if ($j -lt 10) {
            $espacio1 = "      "
        }elseif ($j -ge 10 -and $j -lt 100) {
            $espacio1 = "     "
        }else{
            $espacio1 = "    "
        }

	#Dejamos bonito el espacio2
	

        #Write-Host $j $espacio1 "$("{0:N2}" -f $global:pendiente[$i])" "       " "$("{0:N2}" -f $global:pcapital[$i])" "     " "$("{0:N2}" -f $global:pinteres[$i])" "      " "$("{0:N2}" -f $global:cround)"
	
	$mipendiente = "$("{0:N2}" -f $global:pendiente[$i])"
	$micapital = "$("{0:N2}" -f $global:pcapital[$i])"
	$miinteres = "$("{0:N2}" -f $global:pinteres[$i])"
	$micuota = "$("{0:N2}" -f $global:cround)"
	
	Write-Host $j $espacio1 (" " * (10 - $mipendiente.tostring().length))  "$("{0:N2}" -f $global:pendiente[$i])" -nonewline
	Write-Host (" " *(14 - $micapital.tostring().length)) "$("{0:N2}" -f $global:pcapital[$i])" -nonewline
	Write-Host (" " *(12 - $miinteres.tostring().length)) "$("{0:N2}" -f $global:pinteres[$i])" -nonewline
	Write-Host (" " *(14 - $micuota.tostring().length)) "$("{0:N2}" -f $global:cround)" 

	
    }
	

    Write-Host "****************************************************************"
    Write-Host "**************    Calculo by Victor Salinas    *****************"
    Write-Host "****************************************************************"

    Write-Host $resumenCapital (" " * (36 -  $resumenCapital.tostring().length)) $resumenMensual
    Write-Host $resumenIntereses (" " * (36 -  $resumenIntereses.tostring().length)) $resumenIntTotal
    Write-Host $resumenPlazo (" " * (36 -  $resumenPlazo.tostring().length)) $resumenPagoTotal

    Write-Host "****************************************************************"
}
#DEJAMOS BONITA LA PANTALLA:
$a = (Get-Host).UI.RawUI 
$a.ForegroundColor = "Yellow" 
#$a.BackgroundColor = "DarkBlue" 
$a.WindowTitle     = "Calculo del cuadro by Victor Salinas"
Clear-Host

#LOGICA DEL PROGRAMA:
$opcion="N"
menu
calculos

pause





