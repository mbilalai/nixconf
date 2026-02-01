# modules/system/lid-display-switch.nix
# Automatic display switching when laptop lid is opened/closed
{ config, lib, pkgs, ... }:

let
  lidSwitchScript = pkgs.writeShellScript "lid-display-switch" ''
    #!/bin/bash
    
    export WAYLAND_DISPLAY=wayland-1
    export XDG_RUNTIME_DIR="/run/user/1000"
    
    # Function to log messages
    log_message() {
        echo "$(date): $1" | systemd-cat -t lid-display-switch
    }
    
    # Get lid state
    LID_STATE=$(cat /proc/acpi/button/lid/LID0/state 2>/dev/null | awk '{print $2}' || echo "unknown")
    
    # Get connected displays using wlr-randr
    DISPLAYS=$(wlr-randr --json | jq -r '.[] | select(.enabled == true) | .name')
    LAPTOP_DISPLAY=$(echo "$DISPLAYS" | grep -E "(eDP|LVDS)" | head -1)
    EXTERNAL_DISPLAYS=$(echo "$DISPLAYS" | grep -v -E "(eDP|LVDS)")
    
    log_message "Lid state: $LID_STATE"
    log_message "Laptop display: $LAPTOP_DISPLAY"
    log_message "External displays: $(echo $EXTERNAL_DISPLAYS | tr '\n' ' ')"
    
    if [ "$LID_STATE" = "closed" ]; then
        # Lid closed - switch to external display as primary if available
        if [ -n "$EXTERNAL_DISPLAYS" ] && [ -n "$LAPTOP_DISPLAY" ]; then
            log_message "Lid closed: Disabling laptop display and using external as primary"
            
            # Disable laptop display
            wlr-randr --output "$LAPTOP_DISPLAY" --off
            
            # Set first external display as primary
            FIRST_EXTERNAL=$(echo "$EXTERNAL_DISPLAYS" | head -1)
            wlr-randr --output "$FIRST_EXTERNAL" --on --primary
            
            log_message "Switched to external display: $FIRST_EXTERNAL"
        else
            log_message "Lid closed but no external display found, keeping laptop display active"
        fi
    elif [ "$LID_STATE" = "open" ]; then
        # Lid opened - enable laptop display
        if [ -n "$LAPTOP_DISPLAY" ]; then
            log_message "Lid opened: Enabling laptop display"
            
            # Turn on laptop display
            wlr-randr --output "$LAPTOP_DISPLAY" --on
            
            # If there are external displays, set up dual monitor (laptop as primary)
            if [ -n "$EXTERNAL_DISPLAYS" ]; then
                log_message "Setting up dual monitor with laptop as primary"
                wlr-randr --output "$LAPTOP_DISPLAY" --primary
                
                # Position external displays to the right
                for ext_display in $EXTERNAL_DISPLAYS; do
                    wlr-randr --output "$ext_display" --on --right-of "$LAPTOP_DISPLAY"
                done
            else
                # Just laptop display
                wlr-randr --output "$LAPTOP_DISPLAY" --primary
            fi
            
            log_message "Laptop display restored as primary"
        fi
    else
        log_message "Unknown lid state: $LID_STATE"
    fi
  '';

in {
  # Make the script available in system PATH for manual testing
  environment.systemPackages = with pkgs; [
    (pkgs.writeShellScriptBin "lid-display-switch-manual" ''
      ${lidSwitchScript}
    '')
  ];
  
  # Systemd service to monitor lid events
  systemd.services.lid-display-switch = {
    description = "Automatic display switching on lid open/close";
    wantedBy = [ "multi-user.target" ];
    after = [ "graphical-session.target" ];
    
    # Run as the user to access Wayland session
    serviceConfig = {
      Type = "oneshot";
      User = "alpha";
      Group = "users";
      Environment = [
        "XDG_RUNTIME_DIR=/run/user/1000"
        "WAYLAND_DISPLAY=wayland-1"
      ];
      ExecStart = "${lidSwitchScript}";
    };
  };
  
  # udev rule to trigger the service on lid events
  services.udev.extraRules = ''
    # Trigger display switch on lid open/close
    SUBSYSTEM=="platform", KERNEL=="PNP0C0D:00", ACTION=="change", RUN+="${pkgs.systemd}/bin/systemctl --no-block start lid-display-switch.service"
  '';
  
  # Also add a manual trigger via acpi events if available
  services.acpid = {
    enable = true;
    lidEventCommands = ''
      ${pkgs.systemd}/bin/systemctl --no-block start lid-display-switch.service
    '';
  };
}