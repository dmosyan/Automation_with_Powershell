$loadBalancer = Get-AzLoadBalancer -Name "lb-eastus2"

$backendPoolConfig = Get-AzLoadBalncerBackendAddressPoolConfig -Name "backEnd"

$loadBalancer | Add-AzLoadBalancerInboundNatRuleConfig -Name "remoteDesktopVM1Rule" `
  -FrontendIpConfiguration $loadBalancer.FrontendIpConfiguration[0] -Protocol "Tcp" `
  -FrontendPort 33890 -BackendPort 3389
