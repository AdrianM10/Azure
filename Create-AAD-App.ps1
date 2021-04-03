# Create Azure Active Directory Application, generate and store secret in Azure Key Vault
# Application Administrator role Azure AD built-in role required
# Requires access to Key Vault

# Provide TenantId  
$TenantId = 'aaaa-aaaa-aaaa-aaaa'

# Connect to Azure Active Directory 
Connect-AzureAD -TenantID $TenantId

# Create Application  
$ApplicationName = "Application Name"
$StartDate = Get-Date
$EndDate = $StartDate.AddYears(1)

$AzureApplicationObject = New-AzureADApplication -DisplayName $ApplicationName -AvailableToOtherTenants $false 

# Generate Client Secret for App Registration and set expiry date for secret
$AzureApplicationSecret = New-AzureADApplicationPasswordCredential -ObjectId $AzureApplicationObject.ObjectID -EndDate $EndDate

# Convert plain text password to a secure string
$SecretValue = ConvertTo-SecureString $AzureApplicationSecret.Value -AsPlainText -Force

# Connect to Azure with an authenticated account
Connect-AzAccount -TenantId $TenantId

# Store Secret in Key Vault
$Secret = Set-AzKeyVaultSecret -VaultName "<Key Vault Name>" -Name $ApplicationName -SecretValue $SecretValue