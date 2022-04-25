# Gather Information for case, user being seperated, and admin performing tasks
$casename = Read-Host -Prompt "Please Enter the Case Name to be Created (ex. User Name - 2019.01.04)"
$upn = Read-Host -Prompt "Please enter the Seperated User's UserPrincipalName (ex. UserName@domain.com)"
$mgmtupn = Read-Host -Prompt "Please Enter the UserPrincipalName to authenticate to O365 with for Administration (ex. UserName@domain.com)"

# Create Variables for case, policy, and rule creation
$rulename = "$casename - Rule"
$policyName = "In-Place Hold - $casename"
$description = "Standard Employee Separation hold & archive"

# Import EXOv2 Module and Authenticate to O365 Sec. and Compliance Center
Import-Module ExchangeOnlineManagement
Connect-IPPSSession -UserPrincipalName $mgmtupn

# Create the Case, Policy for the case, and assign the rule to the policy.
New-ComplianceCase –Name $caseName –Description $description
Write-Host -ForegroundColor Green "Created Compliance Case $casename for $upn"
New-CaseHoldPolicy –Name $policyName –Case $caseName –ExchangeLocation $upn –Enabled $true -Comment "Standard In-Place eDiscovery email hold process."
Write-Host -ForegroundColor Green "Created Hold Policy for Case: $casename"
New-CaseHoldRule -name $rulename -Policy $policyName
Write-Host -ForegroundColor Green "Created Hold Rule for Policy: $policyName"
