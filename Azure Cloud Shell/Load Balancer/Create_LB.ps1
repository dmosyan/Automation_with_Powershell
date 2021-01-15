$location = "eastus2"

$resourceGroup = New-AzResourceGroup -ResourceGroupName "rg-loadBalancer" -Location $location

$pip = New-AzPublicIpAddress -ResourceGroupName $resourceGroup -Location $location -Name "pip-loadBalancer"

$frontEndIpConfig = New-AzLoadBalancerFrontendIpConfig -Name "ip-frontEnd" -PublicIpAddress $pip

$backAddressPoolConfig = New-AzLoadBalancerBackendAddressConfig -Name "backEnd"

$healthProbe = New-AzLoadBalancerProbeConfig -Name "http-prob" -RequestPath "/" -Protocol Http -Port 80 `
               -IntervalInSeconds 30 -ProbeCount 2

$loadBalancerRule = New-AzLoadBalancerRuleConfig -Name "loadBalancer-r1" -FrontendIpConfiguration $frontEndIpConfig `
                    -BackendAddressPool $backAddressPoolConfig -Protocol TCP -FrontendPort 80 -BackendPort 80 -Probe $healthProbe

$loadBalancer = New-AzLoadbalancer -Name "lb-eastus2" -ResourceGroupName $resourceGroup -Location $location `
                -FrontendIpConfiguration $frontEndIpConfig -BackendAddressPool $backAddressPoolConfig -Probe $healthProbe -LoadBalancingRule $loadBalancerRule

