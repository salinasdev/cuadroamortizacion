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

    echo "****************************************************************"
    echo "Calculo by Victor Salinas"
    echo "****************************************************************"
    echo "Capital = $forma euros.                Pago mensual = $cround"
    echo "Interes = $tipo%.                        Intereses    = $inttotal"                     
    echo "Plazo   = $plazo meses.                  Pago total   = $pagototal"
    echo "****************************************************************"
    echo "Mes      Pendiente        Capital        Interes       Cuota    "
    echo "****************************************************************"

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

        Write-Host $j $espacio1 $global:pendiente[$i] "       " $global:pcapital[$i] "     " $global:pinteres[$i] "      " $global:cround

    }

    echo "****************************************************************"
    echo "Calculo by Victor Salinas"
    echo "****************************************************************"
    echo "Capital = $forma euros.                Pago mensual = $cround"
    echo "Interes = $tipo%.                        Intereses    = $inttotal"                     
    echo "Plazo   = $plazo meses.                  Pago total   = $pagototal"
    echo "****************************************************************"

}
#DEJAMOS BONITA LA PANTALLA:
$a = (Get-Host).UI.RawUI 
$a.ForegroundColor = "Yellow" 
$a.BackgroundColor = "DarkBlue" 
$a.WindowTitle     = "Calculo del cuadro by Victor Salinas"
Clear-Host

#LOGICA DEL PROGRAMA:
$opcion="N"
menu
calculos

pause





