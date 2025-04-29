# How to use
1. Copy or cut `mirrormyphone.sh` file into `~/` path
2. Make it executable `chmod +x ~/mirrormyphone.sh`
3. Add an alias to make it even easier
  - Edit shell config `nano ~/.zshrc` or `nano ~/.bash_profile`
  - Add this line `alias mirrormyphone="~/mirrormyphone.sh"`
  - Reload the shell `source ~/.zshrc` or `source ~/.bash_profile`
4. Now you can run it by:
  - Using USB `mirrormyphone usb` or `mirrormyphone usb --[SCRCPY_OPTIONS]`. Example: `mirrormyphone usb --no-audio`
  - Wireless (WiFi) `mirrormyphone [PHONE_IP_ADDRESS]` or `mirrormyphone [PHONE_IP_ADDRESS] --[SCRCPY_OPTIONS]`. Example: `mirrormyphone 192.168.1.2 --no-audio`
