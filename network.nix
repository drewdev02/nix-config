{ config, pkgs, ... }: {
  # Network configuration
  networking = {
    # Computer name (hostname)
    computerName = "Andrews-MacBook";
    hostName = "Andrews-MacBook";

    # DNS servers
    # nameservers = [ "1.1.1.1" "8.8.8.8" ];

    # Search domains
    # search = [ "local" ];

    # Network services (requires knowing service names)
    # networkServices = {
    #   Wi-Fi = {
    #     IPv4 = {
    #       ConfigMethod = "DHCP";
    #     };
    #   };
    # };
  };

  # Firewall configuration
  # networking.firewall.enable = true;

  # SSH configuration
  services.openssh = {
    enable = false;
    # settings = {
    #   PermitRootLogin = "no";
    #   PasswordAuthentication = false;
    # };
  };

  # Local DNS resolver (mDNS)
  # services.dnsmasq.enable = true;
}
