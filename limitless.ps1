param
(
    [Alias("m")]
    [switch]$mirror
)

function Run-LimitlessLegacy {

    param(
        [string]$params
    )

    $maxRetryCount = 3
    $retryInterval = 5

    if ($mirror) { 
        # النسخة mirror (ممكن تعمل نسخة تانية على GitHub باسم mirror لو حابب)
$url = 'https://raw.githubusercontent.com/HazemYoriichi/Spotify-Patch/main/limitless.ps1'
        $params += " -m"
    }
    else {
        # النسخة الرئيسية اللي هتكون رافعها عندك على GitHub
$url = 'https://raw.githubusercontent.com/HazemYoriichi/Spotify-Patch/main/limitless.ps1'    
    }

    for ($retry = 1; $retry -le $maxRetryCount; $retry++) {
        try {
            $response = iwr -useb $url
            $StatusCode = $response.StatusCode
        }
        catch {
            $StatusCode = $_.Exception.Response.StatusCode.value__
        }

        if ($StatusCode -eq 200) {
            iex "& {$($response)} $params"
            return
        }
        else {
            Write-Host ("[Limitless Legacy] Attempt $($retry): HTTP status code: $($StatusCode). Retrying in $($retryInterval) seconds...")
            Start-Sleep -Seconds $retryInterval
        }
    }

    Write-Host
    Write-Warning "[Limitless Legacy] Failed to make the request after $maxRetryCount attempts, script terminated."
    Write-Host $Error[0].Exception.Message
    pause
    exit
}

[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12;
Run-LimitlessLegacy -params $args
