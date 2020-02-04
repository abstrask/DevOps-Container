[CmdletBinding()]
param (
    [Parameter()]
    [ValidateSet('build', 'run', 'attach', 'remove')]
    [string]
    $Action,

    # [Parameter(ParameterSetName = 'Run')]
    [string]
    $WorkDir,

    # [Parameter(ParameterSetName = 'Build')]
    # [Parameter(ParameterSetName = 'Run')]
    [string]
    $Name = 'devops',

    # [Parameter(ParameterSetName = 'Build')]
    # [Parameter(ParameterSetName = 'Run')]
    [string]
    $Tag = 'latest'

)

Switch ($Action) {

    "build" { & docker build -t ${Name}:${Tag} ${PSScriptRoot} }

    "run" {
        & docker run -ti --name ${Name} -v /code:/code -v ~/.ssh:/root/.ssh -v ~/.kube:/root/.kube -v ~/.aws:/root/.aws -v ~/.k9s:/root/.k9s ${Name}:${Tag}
    }

    "attach" {
        & docker start ${Name}
        & docker attach ${Name}
    }

    "remove" {
        & docker stop ${Name}
        & docker rm ${Name}
    }

    Default { Write-Warning "Unrecognised action" }
}

# -v C:\Code:/code 